import { URLSearchParams } from "node:url";
import CryptoJS from "crypto-js";
import { LocalSaveDatabase } from "../persistence/db.js";
import {
  antiCheatRequiredRecharge,
  canonicalizeLocalSaveIdentity,
  estimateAccountShopValue,
  estimateProductShopValue,
  estimateSaveShopValue,
  loadGameDataCatalog,
  type AccountShopValueEstimate,
  type ProductShopValueEstimate,
  type SaveShopValueEstimate,
} from "../services/gameData.js";
import { payloadSummary, SaveDataLogger } from "../server/logger.js";
import type { AccountSeed, BuyPropRequest, BuyPropResult, SaveDataLogEvent, Wallet } from "../types.js";

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

type TotalRechargeView = {
  wallet: Wallet;
  totalRecharged: number;
  accountShopValue: AccountShopValueEstimate;
};

type LocalPurchaseResult = BuyPropResult & {
  totalPrice: number;
  product: ProductShopValueEstimate;
  slotShopValue: SaveShopValueEstimate | null;
  projectedShopValue: number;
  requiredTotalRecharge: number;
  availableTotalRecharge: number;
};

export class MockShopError extends Error {
  constructor(readonly code: number, readonly result: string, message: string, readonly details?: Record<string, unknown>) {
    super(message);
    this.name = "MockShopError";
  }
}

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

  getTotalRechargeView(uid = this.account.uid, gameid = "100025235"): TotalRechargeView {
    const wallet = this.db.getWallet(uid);
    const catalog = loadGameDataCatalog();
    const accountShopValue = estimateAccountShopValue(this.db.listSlotsWithData(uid, gameid), catalog);
    return {
      wallet,
      totalRecharged: Math.max(wallet.totalRecharged, accountShopValue.requiredTotalRecharge),
      accountShopValue,
    };
  }

  buyProp(request: BuyPropRequest): LocalPurchaseResult {
    const uid = request.uid;
    const gameId = request.gameId ?? "100025235";
    const propId = Math.floor(request.propId);
    const count = Math.floor(request.count);
    const price = Math.floor(request.price);
    const tag = Math.floor(request.tag);

    if (!Number.isSafeInteger(propId) || propId < 0) {
      throw new MockShopError(20003, "invalid_prop_id", "invalid prop id", { propId: request.propId });
    }
    if (!Number.isSafeInteger(count) || count <= 0) {
      throw new MockShopError(20003, "invalid_count", "invalid prop count", { count: request.count });
    }
    if (!Number.isSafeInteger(price) || price < 0) {
      throw new MockShopError(20003, "invalid_price", "invalid prop price", { price: request.price });
    }
    if (!Number.isSafeInteger(tag)) {
      throw new MockShopError(20003, "invalid_tag", "invalid prop tag", { tag: request.tag });
    }

    const totalPrice = price * count;
    if (!Number.isSafeInteger(totalPrice)) {
      throw new MockShopError(20003, "invalid_total_price", "purchase total is too large", { price, count });
    }

    const catalog = loadGameDataCatalog();
    if (!catalog.loaded) {
      throw new MockShopError(20003, "shop_data_missing", "local shop data is not loaded", { sourceFile: catalog.sourceFile });
    }

    const product = estimateProductShopValue(catalog, propId, count);
    if (product.productKnown && !product.candidates.some((candidate) => candidate.realPrice === price)) {
      throw new MockShopError(20003, "price_mismatch", "purchase price does not match shop data", {
        propId,
        price,
        expectedPrices: [...new Set(product.candidates.map((candidate) => candidate.realPrice))],
      });
    }
    if (product.unknownGoodsIds.length > 0) {
      throw new MockShopError(20003, "goods_price_missing", "local goods price data is incomplete", {
        propId,
        unknownGoodsIds: product.unknownGoodsIds,
      });
    }

    const rechargeView = this.getTotalRechargeView(uid, gameId);
    if (rechargeView.wallet.balance < totalPrice) {
      throw new MockShopError(20002, "insufficient_balance", "local wallet balance is insufficient", {
        balance: rechargeView.wallet.balance,
        totalPrice,
      });
    }

    const slotIndex = request.slotIndex;
    const slot =
      Number.isSafeInteger(slotIndex) && slotIndex != null ? this.db.getSlot(uid, gameId, slotIndex) : null;
    const slotShopValue =
      slot && typeof slot.data === "string" ? estimateSaveShopValue(slot.data, catalog) : null;
    const existingShopValue = slotShopValue?.decoded ? slotShopValue.shopValue : 0;
    const projectedShopValue = existingShopValue + product.addedShopValue;
    const requiredTotalRecharge = antiCheatRequiredRecharge(projectedShopValue);

    if (requiredTotalRecharge > rechargeView.totalRecharged) {
      throw new MockShopError(20003, "recharge_required", "local total recharge is below the save anti-cheat requirement", {
        existingShopValue,
        addedShopValue: product.addedShopValue,
        projectedShopValue,
        requiredTotalRecharge,
        availableTotalRecharge: rechargeView.totalRecharged,
      });
    }

    const result = this.db.buyProp({ uid, propId, count, price, tag });
    return {
      ...result,
      totalPrice,
      product,
      slotShopValue,
      projectedShopValue,
      requiredTotalRecharge,
      availableTotalRecharge: rechargeView.totalRecharged,
    };
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
      const rechargeView = this.getTotalRechargeView(this.account.uid, "100025235");
      const payload = encryptedPaymentPayload(params, rechargeView.totalRecharged);
      this.log({
        event: "payment.get_total_recharge",
        method,
        pathname,
        uid: this.account.uid,
        status: 200,
        result: "ok",
        details: {
          ...rechargeView.wallet,
          responseTotalRecharged: rechargeView.totalRecharged,
          responsePlain: payload.plain,
          antiCheat: {
            shopValue: rechargeView.accountShopValue.shopValue,
            requiredTotalRecharge: rechargeView.accountShopValue.requiredTotalRecharge,
            slots: rechargeView.accountShopValue.slots.map((slot) => ({
              slotIndex: slot.slotIndex,
              decoded: slot.decoded,
              shopValue: slot.shopValue,
              requiredTotalRecharge: antiCheatRequiredRecharge(slot.shopValue),
              unpricedGoodsIds: slot.unpricedGoodsIds.slice(0, 20),
              error: slot.error,
            })),
          },
        },
      });
      return text(payload.encrypted);
    }

    if (pathname === "/mall/index.php/Api/GetToken") {
      return text("local-shop-token");
    }

    if (pathname === "/mall/index.php/Api/BuyPropNd" || pathname === "/mall/index.php/Api/BuyProp") {
      const uid = getFirst(params, "uid", this.account.uid);
      try {
        const result = this.buyProp({
          uid,
          gameId: getFirst(params, "gameid", "100025235"),
          slotIndex: Number(getFirst(params, "idx", getFirst(params, "index", "-1"))),
          propId: Number(getFirst(params, "propId", getFirst(params, "prop_id", "0"))),
          count: Number(getFirst(params, "count", "1")),
          price: Number(getFirst(params, "price", "0")),
          tag: Number(getFirst(params, "tag", "0")),
        });
        this.log({
          event: "payment.buy_prop",
          method,
          pathname,
          uid,
          status: 200,
          result: "ok",
          details: result,
        });
        return json(result);
      } catch (error) {
        const shopError =
          error instanceof MockShopError
            ? error
            : new MockShopError(20003, "invalid_request", error instanceof Error ? error.message : String(error));
        this.log({
          event: "payment.buy_prop",
          method,
          pathname,
          uid,
          status: 200,
          result: shopError.result,
          details: { code: shopError.code, message: shopError.message, ...shopError.details },
        });
        return json({ eId: String(shopError.code), msg: shopError.message });
      }
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
    const account = this.db.ensureAccount(uid);
    const data = canonicalizeLocalSaveIdentity(getFirst(params, "data", ""), {
      uid,
      username: account.username,
      slotIndex: index,
    });

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
    const account = this.db.ensureAccount(uid);
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
    return json({
      ...slot,
      data:
        typeof slot.data === "string"
          ? canonicalizeLocalSaveIdentity(slot.data, { uid, username: account.username, slotIndex: index })
          : slot.data,
    });
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
