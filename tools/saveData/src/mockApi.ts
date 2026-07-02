import { URLSearchParams } from "node:url";
import CryptoJS from "crypto-js";
import { LocalSaveDatabase } from "./db.js";
import { payloadSummary, SaveDataLogger } from "./logger.js";
import type { AccountSeed, SaveDataLogEvent } from "./types.js";

export const DEFAULT_ACCOUNT: AccountSeed = {
  uid: "10001",
  username: "local_user",
  nickname: "本地玩家",
};

type MockResponse = {
  status: number;
  contentType: string;
  body: string | Buffer;
};

function text(body: string, status = 200, contentType = "text/plain; charset=utf-8"): MockResponse {
  return { status, contentType, body };
}

function json(body: unknown, status = 200): MockResponse {
  return text(JSON.stringify(body), status, "application/json; charset=utf-8");
}

function getFirst(params: URLSearchParams, key: string, fallback = ""): string {
  return params.get(key) ?? fallback;
}

function parseBodyParams(body: string): URLSearchParams {
  return new URLSearchParams(body);
}

function parseDebugParams(body: string): URLSearchParams {
  const trimmed = body.trim();
  if (!trimmed) {
    return new URLSearchParams();
  }

  if (trimmed.startsWith("{")) {
    const value = JSON.parse(trimmed) as Record<string, unknown>;
    const params = new URLSearchParams();
    for (const [key, entry] of Object.entries(value)) {
      if (entry != null && (typeof entry === "string" || typeof entry === "number" || typeof entry === "boolean")) {
        params.set(key, String(entry));
      }
    }
    return params;
  }

  return parseBodyParams(body);
}

function parseRechargeAmount(value: string | null): number {
  const amount = Number(value);
  if (!Number.isFinite(amount) || amount <= 0) {
    throw new RangeError("amount must be a positive number");
  }
  const integerAmount = Math.floor(amount);
  if (!Number.isSafeInteger(integerAmount)) {
    throw new RangeError("amount must be a safe integer");
  }
  return integerAmount;
}

function pad2(value: number): string {
  return String(value).padStart(2, "0");
}

function currentGameTime(): string {
  const now = new Date();
  return [
    `${now.getFullYear()}-${pad2(now.getMonth() + 1)}-${pad2(now.getDate())}`,
    `${pad2(now.getHours())}:${pad2(now.getMinutes())}:${pad2(now.getSeconds())}`,
  ].join(" ");
}

function pickPaymentTime(params: URLSearchParams): string {
  for (const key of ["time", "Time", "timestamp", "Timestamp", "ts", "t"]) {
    const value = params.get(key);
    if (value) {
      return value;
    }
  }

  for (const [key, value] of params.entries()) {
    if (/time/i.test(key) && value) {
      return value;
    }
  }

  for (const [, value] of params.entries()) {
    if (/^\d{10,13}$/.test(value)) {
      return value;
    }
  }

  return String(Math.floor(Date.now() / 1000));
}

function encryptedPaymentPayload(params: URLSearchParams, amount: number): { encrypted: string; plain: string } {
  const plain = `${pickPaymentTime(params)}####${Math.max(0, Math.floor(amount))}`;
  const encrypted = CryptoJS.DES.encrypt(plain, CryptoJS.enc.Utf8.parse("4399api_"), {
    mode: CryptoJS.mode.ECB,
    padding: CryptoJS.pad.Pkcs7,
  }).ciphertext.toString(CryptoJS.enc.Base64);

  return { encrypted, plain };
}

export class SaveDataMockApi {
  readonly account: AccountSeed;

  constructor(readonly db: LocalSaveDatabase, account: AccountSeed = DEFAULT_ACCOUNT, readonly logger?: SaveDataLogger) {
    this.account = account;
    this.db.getOrCreateAccount(account);
  }

  private log(event: Omit<SaveDataLogEvent, "ts">): void {
    this.logger?.appendSync(event);
  }

  handleUniLogin(pathname: string): MockResponse | null {
    switch (pathname) {
      case "/api/unilogin/uid":
        return text(this.account.uid);
      case "/api/unilogin/uname":
        return text(this.account.username);
      case "/api/unilogin/nickname":
        return text(this.account.nickname);
      case "/api/unilogin/login-type":
        return text("local");
      case "/api/unilogin/account":
        return json(this.account);
      default:
        return null;
    }
  }

  handleSaveApi(url: URL, method: string, body: string): MockResponse | null {
    const params = method === "GET" ? url.searchParams : parseBodyParams(body);
    const ac = url.searchParams.get("ac") ?? params.get("ac") ?? "";
    const pathname = url.pathname;

    if (pathname === "/auth/openapi.php") {
      this.log({
        event: "auth.check_user",
        method,
        pathname,
        uid: getFirst(params, "uid", this.account.uid),
        gameid: getFirst(params, "gameid", "100025235"),
        status: 200,
        result: "ok",
      });
      return text(`|1000|${this.account.uid}|${this.account.username}|`);
    }

    if (pathname === "/index.php" && ac === "get_token") {
      this.log({
        event: "save.get_token",
        method,
        pathname,
        ac,
        uid: getFirst(params, "uid", this.account.uid),
        gameid: getFirst(params, "gameid", "100025235"),
        status: 200,
        result: "ok",
      });
      return text("local-token");
    }

    if (pathname === "/" || pathname === "") {
      switch (ac) {
        case "get_session":
          this.log({
            event: "save.get_session",
            method,
            pathname,
            ac,
            uid: getFirst(params, "uid", this.account.uid),
            gameid: getFirst(params, "gameid", "100025235"),
            status: 200,
            result: "ok",
          });
          return text("local-session");
        case "check_session":
          this.log({
            event: "save.check_session",
            method,
            pathname,
            ac,
            uid: getFirst(params, "uid", this.account.uid),
            gameid: getFirst(params, "gameid", "100025235"),
            status: 200,
            result: "ok",
          });
          return text("1");
        case "get_time":
          this.log({
            event: "save.get_time",
            method,
            pathname,
            ac,
            uid: getFirst(params, "uid", this.account.uid),
            gameid: getFirst(params, "gameid", "100025235"),
            status: 200,
            result: "ok",
          });
          return json({ time: currentGameTime() });
        case "save":
          return this.save(params);
        case "get":
          return this.get(params);
        case "get_list":
          return this.list(params);
        default:
          return null;
      }
    }

    if (pathname === "/exchange/v2/flash/GetToken") {
      return text("local-pay-token");
    }

    if (pathname === "/exchange/v2/flash/GetMoney") {
      const wallet = this.db.getWallet(this.account.uid);
      const payload = encryptedPaymentPayload(params, wallet.balance);
      this.log({
        event: "payment.get_money",
        method,
        pathname,
        uid: this.account.uid,
        status: 200,
        result: "ok",
        details: { ...wallet, responsePlain: payload.plain },
      });
      return text(payload.encrypted);
    }

    if (pathname === "/exchange/v2/flash/GetTotalPay") {
      const wallet = this.db.getWallet(this.account.uid);
      const payload = encryptedPaymentPayload(params, wallet.totalPaid);
      this.log({
        event: "payment.get_total_pay",
        method,
        pathname,
        uid: this.account.uid,
        status: 200,
        result: "ok",
        details: { ...wallet, responsePlain: payload.plain },
      });
      return text(payload.encrypted);
    }

    if (pathname === "/exchange/v2/flash/GetTotalRecharge") {
      const wallet = this.db.getWallet(this.account.uid);
      const payload = encryptedPaymentPayload(params, wallet.totalRecharged);
      this.log({
        event: "payment.get_total_recharge",
        method,
        pathname,
        uid: this.account.uid,
        status: 200,
        result: "ok",
        details: { ...wallet, responsePlain: payload.plain },
      });
      return text(payload.encrypted);
    }

    if (pathname === "/mall/index.php/Api/GetToken") {
      return text("local-shop-token");
    }

    if (pathname === "/mall/index.php/Api/BuyPropNd" || pathname === "/mall/index.php/Api/BuyProp") {
      const result = this.db.buyProp({
        uid: getFirst(params, "uid", this.account.uid),
        propId: Number(getFirst(params, "propId", getFirst(params, "prop_id", "0"))),
        count: Number(getFirst(params, "count", "1")),
        price: Number(getFirst(params, "price", "0")),
        tag: Number(getFirst(params, "tag", "0")),
      });
      this.log({
        event: "payment.buy_prop",
        method,
        pathname,
        uid: getFirst(params, "uid", this.account.uid),
        status: 200,
        result: "ok",
        details: result,
      });
      return json(result);
    }

    return null;
  }

  handleDebugApi(url: URL, method: string, body: string): MockResponse | null {
    if (url.pathname === "/api/saveData/slots") {
      const uid = getFirst(url.searchParams, "uid", this.account.uid);
      const gameid = getFirst(url.searchParams, "gameid", "100025235");
      return json(this.db.listSlots(uid, gameid));
    }

    if (url.pathname === "/api/saveData/wallet") {
      const uid = getFirst(url.searchParams, "uid", this.account.uid);
      return json({ uid, ...this.db.getWallet(uid) });
    }

    if (url.pathname === "/api/saveData/recharge") {
      if (method !== "POST") {
        return json({ ok: false, error: "method_not_allowed" }, 405);
      }

      try {
        const params = parseDebugParams(body);
        const uid = getFirst(params, "uid", getFirst(url.searchParams, "uid", this.account.uid));
        const amount = parseRechargeAmount(params.get("amount") ?? url.searchParams.get("amount"));
        const result = this.db.rechargeWallet({ uid, amount });
        this.log({
          event: "payment.local_recharge",
          method,
          pathname: url.pathname,
          uid,
          status: 200,
          result: "ok",
          details: result,
        });
        return json({ ok: true, uid, wallet: result });
      } catch (error) {
        this.log({
          event: "payment.local_recharge",
          method,
          pathname: url.pathname,
          uid: this.account.uid,
          status: 400,
          result: "invalid_amount",
          details: { message: error instanceof Error ? error.message : String(error) },
        });
        return json({ ok: false, error: "invalid_amount" }, 400);
      }
    }

    return null;
  }

  private save(params: URLSearchParams): MockResponse {
    const uid = getFirst(params, "uid", this.account.uid);
    const gameid = getFirst(params, "gameid", "100025235");
    const index = Number(getFirst(params, "index", "0"));
    const title = getFirst(params, "title", `slot-${index}`);
    const data = getFirst(params, "data", "");

    if (!Number.isFinite(index) || index < 0 || index > 7) {
      this.log({
        event: "save.write",
        uid,
        gameid,
        slotIndex: index,
        title,
        status: 400,
        result: "invalid_index",
        ...payloadSummary(data, this.logger?.previewLength),
      });
      return text("invalid_index", 400);
    }

    this.db.saveSlot({ uid, gameid, index, title, data });
    this.log({
      event: "save.write",
      uid,
      gameid,
      slotIndex: index,
      title,
      status: 200,
      result: "ok",
      ...payloadSummary(data, this.logger?.previewLength),
    });
    return text("1");
  }

  private get(params: URLSearchParams): MockResponse {
    const uid = getFirst(params, "uid", this.account.uid);
    const gameid = getFirst(params, "gameid", "100025235");
    const index = Number(getFirst(params, "index", "0"));
    const slot = this.db.getSlot(uid, gameid, index);

    if (!slot) {
      this.log({
        event: "save.read",
        uid,
        gameid,
        slotIndex: index,
        status: 200,
        result: "miss",
      });
      return text("0");
    }

    this.log({
      event: "save.read",
      uid,
      gameid,
      slotIndex: index,
      title: slot.title,
      status: 200,
      result: "hit",
      ...(typeof slot.data === "string" ? payloadSummary(slot.data, this.logger?.previewLength) : {}),
    });
    return json(slot);
  }

  private list(params: URLSearchParams): MockResponse {
    const uid = getFirst(params, "uid", this.account.uid);
    const gameid = getFirst(params, "gameid", "100025235");
    const slots = this.db.listSlots(uid, gameid);
    this.log({
      event: "save.list",
      uid,
      gameid,
      status: 200,
      result: slots.length > 0 ? "hit" : "empty",
      details: {
        count: slots.length,
        slots: slots.map((slot) => ({ index: slot.index, title: slot.title, datetime: slot.datetime, status: slot.status })),
      },
    });
    return slots.length > 0 ? json(slots) : text("0");
  }
}
