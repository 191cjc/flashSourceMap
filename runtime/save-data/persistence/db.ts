import { createHash } from "node:crypto";
import { mkdirSync, readFileSync } from "node:fs";
import path from "node:path";
import { DatabaseSync } from "node:sqlite";
import { saveDataPaths } from "../server/paths.js";
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

type AccountRow = {
  id: number;
  uid: string;
  username: string;
  nickname: string;
};

type SaveSlotRow = {
  id: number;
  slot_index: number;
  title: string;
  raw_data: string;
  status: string;
  updated_at: string;
};

type WalletRow = {
  balance: number;
  total_paid: number;
  total_recharged: number;
};

function sha256(value: string): string {
  return createHash("sha256").update(value).digest("hex");
}

function asAccount(row: AccountRow): Account {
  return {
    id: row.id,
    uid: row.uid,
    username: row.username,
    nickname: row.nickname,
  };
}

export class LocalSaveDatabase implements SaveDataStore {
  readonly db: DatabaseSync;

  constructor(readonly dbFile: string = saveDataPaths.defaultDbFile) {
    mkdirSync(path.dirname(dbFile), { recursive: true });
    this.db = new DatabaseSync(dbFile);
    this.db.exec(readFileSync(saveDataPaths.schemaFile, "utf8"));
    this.migrateLegacyUnionSchema();
    this.ensureColumn("union_log_mock", "actor_username", "TEXT NOT NULL DEFAULT ''");
    this.ensureColumn("online_mode_state", "arena_settled_season", "INTEGER NOT NULL DEFAULT 0");
  }

  close(): void {
    this.db.close();
  }

  private tableColumns(tableName: string): Set<string> {
    const columns = this.db.prepare(`PRAGMA table_info(${tableName})`).all() as Array<{ name: string }>;
    return new Set(columns.map((column) => column.name));
  }

  private ensureColumn(tableName: string, columnName: string, definition: string): void {
    if (!this.tableColumns(tableName).has(columnName)) {
      this.db.exec(`ALTER TABLE ${tableName} ADD COLUMN ${columnName} ${definition}`);
    }
  }

  private migrateLegacyUnionSchema(): void {
    const legacyColumns = this.tableColumns("union_mock");
    const hasLegacyOwnerAccountId = legacyColumns.has("owner_account_id");

    for (const [columnName, definition] of [
      ["owner_uid", "TEXT NOT NULL DEFAULT ''"],
      ["owner_username", "TEXT NOT NULL DEFAULT ''"],
      ["owner_nickname", "TEXT NOT NULL DEFAULT ''"],
      ["extra2", "TEXT NOT NULL DEFAULT ''"],
      ["transfer", "TEXT NOT NULL DEFAULT ''"],
    ] as const) {
      this.ensureColumn("union_mock", columnName, definition);
    }

    if (!hasLegacyOwnerAccountId) {
      return;
    }

    this.db.exec("BEGIN IMMEDIATE");
    try {
      this.db.exec(
        [
          "UPDATE union_mock",
          "SET owner_uid = COALESCE(NULLIF(owner_uid, ''), (SELECT uid FROM accounts WHERE id = owner_account_id), ''),",
          "owner_username = COALESCE(NULLIF(owner_username, ''), (SELECT username FROM accounts WHERE id = owner_account_id), ''),",
          "owner_nickname = COALESCE(NULLIF(owner_nickname, ''), (SELECT nickname FROM accounts WHERE id = owner_account_id), '')",
          "WHERE owner_account_id IS NOT NULL",
          "AND (owner_uid = '' OR owner_username = '' OR owner_nickname = '')",
        ].join(" ")
      );
      this.db.exec(
        [
          "INSERT INTO union_member_mock",
          "(union_id, game_id, uid, username, nickname, slot_index, contribution, extra, extra2, active_time, role_id, role_name)",
          "SELECT union_row.id, union_row.game_id, account.uid, account.username, account.nickname,",
          "slot.slot_index, 0, '', '', '', '1', '团长'",
          "FROM union_mock AS union_row",
          "JOIN accounts AS account ON account.id = union_row.owner_account_id",
          "JOIN save_slots AS slot ON slot.account_id = account.id AND slot.game_id = union_row.game_id",
          "WHERE (",
          "SELECT COUNT(*) FROM save_slots AS candidate_slot",
          "WHERE candidate_slot.account_id = account.id AND candidate_slot.game_id = union_row.game_id",
          ") = 1",
          "AND (",
          "SELECT COUNT(*) FROM union_mock AS owned_union",
          "WHERE owned_union.game_id = union_row.game_id AND owned_union.owner_uid = account.uid",
          ") = 1",
          "AND NOT EXISTS (",
          "SELECT 1 FROM union_member_mock AS owner_membership",
          "WHERE owner_membership.union_id = union_row.id AND owner_membership.uid = account.uid",
          ")",
          "AND NOT EXISTS (",
          "SELECT 1 FROM union_member_mock AS claimed_slot",
          "WHERE claimed_slot.game_id = union_row.game_id",
          "AND claimed_slot.uid = account.uid AND claimed_slot.slot_index = slot.slot_index",
          ")",
        ].join(" ")
      );
      this.db.exec("COMMIT");
    } catch (error) {
      this.db.exec("ROLLBACK");
      throw error;
    }
  }

  getOrCreateAccount(seed: AccountSeed): Account {
    const existing = this.db
      .prepare("SELECT id, uid, username, nickname FROM accounts WHERE uid = ?")
      .get(seed.uid) as AccountRow | undefined;

    if (existing) {
      this.db
        .prepare("UPDATE accounts SET username = ?, nickname = ?, updated_at = datetime('now') WHERE id = ?")
        .run(seed.username, seed.nickname, existing.id);
      return asAccount({ ...existing, username: seed.username, nickname: seed.nickname });
    }

    const result = this.db
      .prepare("INSERT INTO accounts (uid, username, nickname) VALUES (?, ?, ?)")
      .run(seed.uid, seed.username, seed.nickname);

    this.db
      .prepare("INSERT INTO wallet_mock (account_id, balance, total_paid, total_recharged) VALUES (?, ?, ?, ?)")
      .run(Number(result.lastInsertRowid), 100000, 0, 100000);

    return {
      id: Number(result.lastInsertRowid),
      ...seed,
    };
  }

  getAccountByUid(uid: string): Account | null {
    const row = this.db
      .prepare("SELECT id, uid, username, nickname FROM accounts WHERE uid = ?")
      .get(uid) as AccountRow | undefined;
    return row ? asAccount(row) : null;
  }

  getCurrentAccount(): Account | null {
    const state = this.db.prepare("SELECT assigned_uid FROM online_mode_state WHERE id = 1").get() as
      | { assigned_uid: string }
      | undefined;
    if (state) {
      const assigned = this.getAccountByUid(state.assigned_uid);
      if (assigned) {
        return assigned;
      }
    }
    const defaultAccount = this.getAccountByUid("10001");
    if (defaultAccount) {
      return defaultAccount;
    }
    const row = this.db
      .prepare("SELECT id, uid, username, nickname FROM accounts ORDER BY id ASC LIMIT 1")
      .get() as AccountRow | undefined;
    return row ? asAccount(row) : null;
  }

  ensureAccount(uid: string): Account {
    return this.getAccountByUid(uid) ?? this.getOrCreateAccount({
      uid,
      username: `local_${uid}`,
      nickname: `本地账号${uid}`,
    });
  }

  saveSlot(payload: SavePayload): boolean {
    const account = this.ensureAccount(payload.uid);
    const checksum = sha256(payload.data);
    this.db.exec("BEGIN IMMEDIATE");
    try {
      const existing = this.db
        .prepare("SELECT id FROM save_slots WHERE account_id = ? AND game_id = ? AND slot_index = ?")
        .get(account.id, payload.gameid, payload.index) as { id: number } | undefined;

      if (existing) {
        const old = this.db
          .prepare("SELECT title, raw_data, checksum FROM save_slots WHERE id = ?")
          .get(existing.id) as { title: string; raw_data: string; checksum: string } | undefined;
        if (old) {
          this.db
            .prepare("INSERT INTO save_snapshots (save_slot_id, title, raw_data, checksum) VALUES (?, ?, ?, ?)")
            .run(existing.id, old.title, old.raw_data, old.checksum);
        }

        this.db
          .prepare(
            [
              "UPDATE save_slots",
              "SET title = ?, raw_data = ?, checksum = ?, status = '0', updated_at = datetime('now')",
              "WHERE id = ?",
            ].join(" ")
          )
          .run(payload.title, payload.data, checksum, existing.id);
      } else {
        this.db
          .prepare(
            [
              "INSERT INTO save_slots",
              "(account_id, game_id, slot_index, title, raw_data, checksum)",
              "VALUES (?, ?, ?, ?, ?, ?)",
            ].join(" ")
          )
          .run(account.id, payload.gameid, payload.index, payload.title, payload.data, checksum);
      }

      const online = this.db.prepare("SELECT enabled FROM online_mode_state WHERE id = 1").get() as
        | { enabled: number }
        | undefined;
      if (online?.enabled === 1) {
        this.db
          .prepare(
            [
              "INSERT INTO remote_save_sync",
              "(account_id, game_id, slot_index, local_revision, local_checksum, pending)",
              "VALUES (?, ?, ?, 1, ?, 1)",
              "ON CONFLICT(account_id, game_id, slot_index) DO UPDATE SET",
              "local_revision = remote_save_sync.local_revision + 1,",
              "local_checksum = excluded.local_checksum, pending = 1, last_error = ''",
            ].join(" ")
          )
          .run(account.id, payload.gameid, payload.index, checksum);
      }
      this.db.exec("COMMIT");
      return true;
    } catch (error) {
      this.db.exec("ROLLBACK");
      throw error;
    }
  }

  getSlot(uid: string, gameId: string, slotIndex: number): SaveSlot | null {
    const account = this.ensureAccount(uid);
    const row = this.db
      .prepare(
        [
          "SELECT id, slot_index, title, raw_data, status, updated_at",
          "FROM save_slots",
          "WHERE account_id = ? AND game_id = ? AND slot_index = ?",
        ].join(" ")
      )
      .get(account.id, gameId, slotIndex) as SaveSlotRow | undefined;

    if (!row) {
      return null;
    }

    return {
      index: row.slot_index,
      title: row.title,
      datetime: row.updated_at,
      data: row.raw_data,
      status: row.status,
    };
  }

  listSlots(uid: string, gameId: string): SaveSlot[] {
    const account = this.ensureAccount(uid);
    const rows = this.db
      .prepare(
        [
          "SELECT id, slot_index, title, raw_data, status, updated_at",
          "FROM save_slots",
          "WHERE account_id = ? AND game_id = ?",
          "ORDER BY slot_index ASC",
        ].join(" ")
      )
      .all(account.id, gameId) as SaveSlotRow[];

    return rows.map((row) => ({
      index: row.slot_index,
      title: row.title,
      datetime: row.updated_at,
      status: row.status,
    }));
  }

  listSlotsWithData(uid: string, gameId: string): SaveSlot[] {
    const account = this.ensureAccount(uid);
    const rows = this.db
      .prepare(
        [
          "SELECT id, slot_index, title, raw_data, status, updated_at",
          "FROM save_slots",
          "WHERE account_id = ? AND game_id = ?",
          "ORDER BY slot_index ASC",
        ].join(" ")
      )
      .all(account.id, gameId) as SaveSlotRow[];

    return rows.map((row) => ({
      index: row.slot_index,
      title: row.title,
      datetime: row.updated_at,
      data: row.raw_data,
      status: row.status,
    }));
  }

  countSnapshots(uid: string, gameId: string, slotIndex: number): number {
    const account = this.ensureAccount(uid);
    const row = this.db
      .prepare(
        [
          "SELECT COUNT(*) AS count",
          "FROM save_snapshots snap",
          "JOIN save_slots slot ON slot.id = snap.save_slot_id",
          "WHERE slot.account_id = ? AND slot.game_id = ? AND slot.slot_index = ?",
        ].join(" ")
      )
      .get(account.id, gameId, slotIndex) as { count: number } | undefined;

    return row?.count ?? 0;
  }

  getWallet(uid: string): Wallet {
    const account = this.ensureAccount(uid);
    const row = this.db
      .prepare("SELECT balance, total_paid, total_recharged FROM wallet_mock WHERE account_id = ?")
      .get(account.id) as WalletRow | undefined;

    if (!row) {
      this.db
        .prepare("INSERT INTO wallet_mock (account_id, balance, total_paid, total_recharged) VALUES (?, ?, ?, ?)")
        .run(account.id, 100000, 0, 100000);
      return { balance: 100000, totalPaid: 0, totalRecharged: 100000 };
    }

    return {
      balance: row.balance,
      totalPaid: row.total_paid,
      totalRecharged: row.total_recharged,
    };
  }

  rechargeWallet(request: RechargeWalletRequest): RechargeWalletResult {
    const amount = Math.floor(request.amount);
    if (!Number.isSafeInteger(amount) || amount <= 0) {
      throw new RangeError("Recharge amount must be a positive safe integer");
    }

    const account = this.ensureAccount(request.uid);
    const wallet = this.getWallet(request.uid);
    const balanceAfter = wallet.balance + amount;
    const totalRechargedAfter = wallet.totalRecharged + amount;

    if (!Number.isSafeInteger(balanceAfter) || !Number.isSafeInteger(totalRechargedAfter)) {
      throw new RangeError("Recharge result exceeds safe integer range");
    }

    this.db
      .prepare(
        [
          "UPDATE wallet_mock",
          "SET balance = balance + ?, total_recharged = total_recharged + ?, updated_at = datetime('now')",
          "WHERE account_id = ?",
        ].join(" ")
      )
      .run(amount, amount, account.id);
    this.db
      .prepare(
        [
          "INSERT INTO recharge_records",
          "(account_id, amount, balance_after, total_recharged_after)",
          "VALUES (?, ?, ?, ?)",
        ].join(" ")
      )
      .run(account.id, amount, balanceAfter, totalRechargedAfter);

    return {
      amount,
      balance: balanceAfter,
      totalPaid: wallet.totalPaid,
      totalRecharged: totalRechargedAfter,
    };
  }

  buyProp(request: BuyPropRequest): BuyPropResult {
    const account = this.ensureAccount(request.uid);
    const wallet = this.getWallet(request.uid);
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

    const totalPrice = price * count;
    if (!Number.isSafeInteger(totalPrice)) {
      throw new RangeError("Purchase total exceeds safe integer range");
    }
    if (wallet.balance < totalPrice) {
      throw new RangeError("Insufficient wallet balance");
    }

    const balanceAfter = wallet.balance - totalPrice;
    const totalPaidAfter = wallet.totalPaid + totalPrice;
    if (!Number.isSafeInteger(totalPaidAfter)) {
      throw new RangeError("Total paid exceeds safe integer range");
    }

    this.db
      .prepare("UPDATE wallet_mock SET balance = ?, total_paid = total_paid + ?, updated_at = datetime('now') WHERE account_id = ?")
      .run(balanceAfter, totalPrice, account.id);
    this.db
      .prepare(
        [
          "INSERT INTO purchase_records",
          "(account_id, prop_id, count, price, tag, balance_after)",
          "VALUES (?, ?, ?, ?, ?, ?)",
        ].join(" ")
      )
      .run(account.id, propId, count, price, tag, balanceAfter);

    return {
      propId,
      count,
      tag,
      balance: balanceAfter,
    };
  }
}
