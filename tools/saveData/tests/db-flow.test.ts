import assert from "node:assert/strict";
import { mkdtempSync, rmSync } from "node:fs";
import os from "node:os";
import path from "node:path";
import CryptoJS from "crypto-js";
import { LocalSaveDatabase } from "../src/db.js";
import { SaveDataLogger } from "../src/logger.js";
import { DEFAULT_ACCOUNT, SaveDataMockApi } from "../src/mockApi.js";

const GAME_ID = "100025235";

function tempDbFile(): { dir: string; dbFile: string } {
  const dir = mkdtempSync(path.join(os.tmpdir(), "flash-save-data-"));
  return { dir, dbFile: path.join(dir, "local-save.db") };
}

function request(api: SaveDataMockApi, rawUrl: string, method = "GET", body = ""): string {
  const response = api.handleSaveApi(new URL(rawUrl), method, body);
  assert.ok(response, `no mock response for ${rawUrl}`);
  assert.equal(response.status, 200);
  return response.body.toString();
}

function debugRequest(api: SaveDataMockApi, rawUrl: string, method = "GET", body = ""): string {
  const response = api.handleDebugApi(new URL(rawUrl), method, body);
  assert.ok(response, `no debug response for ${rawUrl}`);
  assert.equal(response.status, 200);
  return response.body.toString();
}

function decryptPaymentPayload(body: string): string {
  return CryptoJS.DES.decrypt(
    CryptoJS.lib.CipherParams.create({ ciphertext: CryptoJS.enc.Base64.parse(body) }),
    CryptoJS.enc.Utf8.parse("4399api_"),
    {
      mode: CryptoJS.mode.ECB,
      padding: CryptoJS.pad.Pkcs7,
    }
  ).toString(CryptoJS.enc.Utf8);
}

const { dir, dbFile } = tempDbFile();
const db = new LocalSaveDatabase(dbFile);
const logger = new SaveDataLogger({ logFile: path.join(dir, "mock-api.ndjson") });

try {
  const api = new SaveDataMockApi(db, DEFAULT_ACCOUNT, logger);
  const firstData = "compressed-save-payload-v1";
  const secondData = "compressed-save-payload-v2";

  assert.equal(
    request(
      api,
      "https://save.api.4399.com/?ac=save",
      "POST",
      new URLSearchParams({
        uid: DEFAULT_ACCOUNT.uid,
        gameid: GAME_ID,
        index: "0",
        title: "测试存档",
        data: firstData,
      }).toString()
    ),
    "1"
  );

  const list = JSON.parse(request(api, `https://save.api.4399.com/?ac=get_list&uid=${DEFAULT_ACCOUNT.uid}&gameid=${GAME_ID}`));
  assert.equal(list.length, 1);
  assert.equal(list[0].index, 0);
  assert.equal(list[0].title, "测试存档");

  const loaded = JSON.parse(
    request(api, `https://save.api.4399.com/?ac=get&uid=${DEFAULT_ACCOUNT.uid}&gameid=${GAME_ID}&index=0`)
  );
  assert.equal(loaded.index, 0);
  assert.equal(loaded.data, firstData);
  assert.equal(loaded.status, "0");

  const serverTime = JSON.parse(request(api, `https://save.api.4399.com/?ac=get_time&uid=${DEFAULT_ACCOUNT.uid}`));
  assert.match(serverTime.time, /^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}$/);

  assert.equal(
    request(
      api,
      "https://save.api.4399.com/?ac=save",
      "POST",
      new URLSearchParams({
        uid: DEFAULT_ACCOUNT.uid,
        gameid: GAME_ID,
        index: "0",
        title: "测试存档二次保存",
        data: secondData,
      }).toString()
    ),
    "1"
  );

  const reloaded = JSON.parse(
    request(api, `https://save.api.4399.com/?ac=get&uid=${DEFAULT_ACCOUNT.uid}&gameid=${GAME_ID}&index=0`)
  );
  assert.equal(reloaded.title, "测试存档二次保存");
  assert.equal(reloaded.data, secondData);
  assert.equal(db.countSnapshots(DEFAULT_ACCOUNT.uid, GAME_ID, 0), 1);

  const wallet = db.getWallet(DEFAULT_ACCOUNT.uid);
  const purchase = db.buyProp({ uid: DEFAULT_ACCOUNT.uid, propId: 12, count: 2, price: 30, tag: 7 });
  assert.equal(purchase.balance, wallet.balance - 60);
  assert.equal(
    decryptPaymentPayload(request(api, "https://save.api.4399.com/exchange/v2/flash/GetTotalRecharge?time=123")),
    `123####${wallet.totalRecharged}`
  );
  const recharge = JSON.parse(
    debugRequest(
      api,
      "http://local.test/api/saveData/recharge",
      "POST",
      JSON.stringify({ uid: DEFAULT_ACCOUNT.uid, amount: 250 })
    )
  );
  assert.equal(recharge.ok, true);
  assert.equal(recharge.wallet.balance, purchase.balance + 250);
  assert.equal(recharge.wallet.totalRecharged, wallet.totalRecharged + 250);
  assert.equal(
    decryptPaymentPayload(request(api, "https://save.api.4399.com/exchange/v2/flash/GetMoney?time=124")),
    `124####${purchase.balance + 250}`
  );
  assert.equal(
    decryptPaymentPayload(request(api, "https://save.api.4399.com/exchange/v2/flash/GetTotalRecharge?time=125")),
    `125####${wallet.totalRecharged + 250}`
  );

  const events = logger.list();
  assert.ok(events.some((event) => event.event === "save.write" && event.slotIndex === 0 && event.dataSha256));
  assert.ok(events.some((event) => event.event === "save.read" && event.result === "hit"));
  assert.ok(events.some((event) => event.event === "save.list" && event.result === "hit"));
  assert.ok(events.some((event) => event.event === "payment.get_total_recharge" && event.details?.responsePlain === "123####100000"));
  assert.ok(events.some((event) => event.event === "payment.local_recharge" && event.details?.amount === 250));

  console.log("saveData db flow ok");
} finally {
  db.close();
  rmSync(dir, { recursive: true, force: true });
}
