import { mkdirSync, readFileSync, renameSync, writeFileSync } from "node:fs";
import path from "node:path";
import type {
  Account,
  AccountSeed,
  BuyPropRequest,
  BuyPropResult,
  RechargeWalletRequest,
  RechargeWalletResult,
  SavePayload,
  SaveSlot,
  Wallet,
} from "../types.js";
import type { SaveDataStore } from "./store.js";

type LegacySlotRecord = {
  index?: unknown;
  title?: unknown;
  datetime?: unknown;
  data?: unknown;
  status?: unknown;
};

type LegacyWalletRecord = {
  balance?: unknown;
  totalPaid?: unknown;
  totalRecharged?: unknown;
  total_paid?: unknown;
  total_recharged?: unknown;
};

type LegacyStore = {
  slots?: Record<string, LegacySlotRecord>;
  wallets?: Record<string, LegacyWalletRecord>;
  [key: string]: unknown;
};

function isObject(value: unknown): value is Record<string, unknown> {
  return value != null && typeof value === "object" && !Array.isArray(value);
}

function nowText(date = new Date()): string {
  const pad = (value: number) => String(value).padStart(2, "0");
  return [
    `${date.getFullYear()}-${pad(date.getMonth() + 1)}-${pad(date.getDate())}`,
    `${pad(date.getHours())}:${pad(date.getMinutes())}:${pad(date.getSeconds())}`,
  ].join(" ");
}

function safeInteger(value: unknown, fallback: number): number {
  const numberValue = typeof value === "number" ? value : Number(String(value ?? ""));
  return Number.isSafeInteger(numberValue) ? numberValue : fallback;
}

function walletNumber(value: unknown, fallback: number): number {
  const numberValue = typeof value === "number" ? value : Number(value);
  return Number.isSafeInteger(numberValue) && numberValue >= 0 ? numberValue : fallback;
}

function defaultWallet(): Wallet {
  return { balance: 100000, totalPaid: 0, totalRecharged: 100000 };
}

function asWallet(record: LegacyWalletRecord | undefined): Wallet {
  if (!record) {
    return defaultWallet();
  }

  const fallback = defaultWallet();
  return {
    balance: walletNumber(record.balance, fallback.balance),
    totalPaid: walletNumber(record.totalPaid ?? record.total_paid, fallback.totalPaid),
    totalRecharged: walletNumber(record.totalRecharged ?? record.total_recharged, fallback.totalRecharged),
  };
}

export class LegacyJsonSaveDatabase implements SaveDataStore {
  private readonly accounts = new Map<string, Account>();
  private nextAccountId = 1;

  constructor(readonly storeFile: string) {}

  close(): void {
    // JSON saves are opened per operation, so there is no persistent handle.
  }

  getOrCreateAccount(seed: AccountSeed): Account {
    const existing = this.accounts.get(seed.uid);
    if (existing) {
      const updated = { ...existing, username: seed.username, nickname: seed.nickname };
      this.accounts.set(seed.uid, updated);
      return updated;
    }

    const account = { id: this.nextAccountId++, ...seed };
    this.accounts.set(seed.uid, account);
    return account;
  }

  getAccountByUid(uid: string): Account | null {
    return this.accounts.get(uid) ?? null;
  }

  ensureAccount(uid: string): Account {
    return (
      this.getAccountByUid(uid) ??
      this.getOrCreateAccount({
        uid,
        username: `local_${uid}`,
        nickname: `鏈湴璐﹀彿${uid}`,
      })
    );
  }

  saveSlot(payload: SavePayload): boolean {
    this.ensureAccount(payload.uid);
    const store = this.readStore();
    store.slots = isObject(store.slots) ? store.slots : {};
    store.slots[String(payload.index)] = {
      index: payload.index,
      title: payload.title,
      datetime: nowText(),
      data: payload.data,
      status: "0",
    };
    this.writeStore(store);
    return true;
  }

  getSlot(_uid: string, _gameId: string, slotIndex: number): SaveSlot | null {
    const store = this.readStore();
    return this.normalizeSlot(String(slotIndex), store.slots?.[String(slotIndex)], true);
  }

  listSlots(_uid: string, _gameId: string): SaveSlot[] {
    return this.listSlotsFromStore(false);
  }

  listSlotsWithData(_uid: string, _gameId: string): SaveSlot[] {
    return this.listSlotsFromStore(true);
  }

  getWallet(uid: string): Wallet {
    this.ensureAccount(uid);
    const store = this.readStore();
    return asWallet(store.wallets?.[uid]);
  }

  rechargeWallet(request: RechargeWalletRequest): RechargeWalletResult {
    const amount = Math.floor(request.amount);
    if (!Number.isSafeInteger(amount) || amount <= 0) {
      throw new RangeError("Recharge amount must be a positive safe integer");
    }

    const wallet = this.getWallet(request.uid);
    const balanceAfter = wallet.balance + amount;
    const totalRechargedAfter = wallet.totalRecharged + amount;
    if (!Number.isSafeInteger(balanceAfter) || !Number.isSafeInteger(totalRechargedAfter)) {
      throw new RangeError("Recharge result exceeds safe integer range");
    }

    const nextWallet = {
      balance: balanceAfter,
      totalPaid: wallet.totalPaid,
      totalRecharged: totalRechargedAfter,
    };
    this.writeWallet(request.uid, nextWallet);
    return { amount, ...nextWallet };
  }

  buyProp(request: BuyPropRequest): BuyPropResult {
    const propId = Math.floor(request.propId);
    const count = Math.floor(request.count);
    const price = Math.floor(request.price);
    const tag = Math.floor(request.tag);

    if (!Number.isSafeInteger(propId) || propId < 0) {
      throw new RangeError("Prop id must be a non-negative safe integer");
    }
    if (!Number.isSafeInteger(count) || count <= 0) {
      throw new RangeError("Prop count must be a positive safe integer");
    }
    if (!Number.isSafeInteger(price) || price < 0) {
      throw new RangeError("Prop price must be a non-negative safe integer");
    }
    if (!Number.isSafeInteger(tag)) {
      throw new RangeError("Prop tag must be a safe integer");
    }

    const wallet = this.getWallet(request.uid);
    const totalPrice = price * count;
    if (!Number.isSafeInteger(totalPrice)) {
      throw new RangeError("Purchase total exceeds safe integer range");
    }
    if (wallet.balance < totalPrice) {
      throw new RangeError("Insufficient wallet balance");
    }

    const nextWallet = {
      balance: wallet.balance - totalPrice,
      totalPaid: wallet.totalPaid + totalPrice,
      totalRecharged: wallet.totalRecharged,
    };
    if (!Number.isSafeInteger(nextWallet.totalPaid)) {
      throw new RangeError("Total paid exceeds safe integer range");
    }

    this.writeWallet(request.uid, nextWallet);
    return { propId, count, tag, balance: nextWallet.balance };
  }

  private listSlotsFromStore(includeData: boolean): SaveSlot[] {
    const store = this.readStore();
    const entries = Object.entries(store.slots ?? {});
    return entries
      .map(([key, value]) => this.normalizeSlot(key, value, includeData))
      .filter((slot): slot is SaveSlot => slot != null)
      .sort((left, right) => left.index - right.index);
  }

  private normalizeSlot(key: string, record: LegacySlotRecord | undefined, includeData: boolean): SaveSlot | null {
    if (!record) {
      return null;
    }

    const fallbackIndex = safeInteger(key, -1);
    const index = safeInteger(record.index, fallbackIndex);
    if (!Number.isSafeInteger(index) || index < 0) {
      return null;
    }

    const slot: SaveSlot = {
      index,
      title: String(record.title || `slot-${index}`),
      datetime: String(record.datetime || nowText()),
      status: String(record.status ?? "0"),
    };
    if (includeData) {
      slot.data = record.data == null ? "" : String(record.data);
    }
    return slot;
  }

  private writeWallet(uid: string, wallet: Wallet): void {
    this.ensureAccount(uid);
    const store = this.readStore();
    store.wallets = isObject(store.wallets) ? store.wallets : {};
    store.wallets[uid] = wallet;
    this.writeStore(store);
  }

  private readStore(): LegacyStore {
    try {
      const parsed = JSON.parse(readFileSync(this.storeFile, "utf8")) as unknown;
      if (!isObject(parsed)) {
        return { slots: {} };
      }
      return parsed as LegacyStore;
    } catch {
      return { slots: {} };
    }
  }

  private writeStore(store: LegacyStore): void {
    mkdirSync(path.dirname(this.storeFile), { recursive: true });
    const tmpFile = `${this.storeFile}.${process.pid}.${Date.now()}.tmp`;
    writeFileSync(tmpFile, `${JSON.stringify(store, null, 2)}\n`);
    renameSync(tmpFile, this.storeFile);
  }
}
