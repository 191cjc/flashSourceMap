import assert from "node:assert/strict";
import { existsSync, mkdtempSync, readFileSync, rmSync, writeFileSync } from "node:fs";
import os from "node:os";
import path from "node:path";
import { deflateSync, inflateSync } from "node:zlib";
import CryptoJS from "crypto-js";
import { LegacyJsonSaveDatabase } from "../persistence/legacyJsonDb.js";
import { LocalSaveDatabase } from "../persistence/db.js";
import {
  antiCheatRequiredRecharge,
  canonicalizeLocalSaveIdentity,
  decodeSaveXml,
  estimateSaveShopValue,
  loadGameDataCatalog,
  type GameDataCatalog,
} from "../services/gameData.js";
import { applyLevelRewardAchievementBoostToXml, parseLevelRewardRecords } from "../services/levelRewards.js";
import { SaveDataLogger } from "../server/logger.js";
import { DEFAULT_ACCOUNT, MockShopError, SaveDataMockApi } from "../platform4399/mockApi.js";

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

function encodeAmf3U29(value: number): Buffer {
  if (value < 0x80) {
    return Buffer.from([value]);
  }
  if (value < 0x4000) {
    return Buffer.from([(value >> 7) | 0x80, value & 0x7f]);
  }
  if (value < 0x200000) {
    return Buffer.from([(value >> 14) | 0x80, ((value >> 7) & 0x7f) | 0x80, value & 0x7f]);
  }
  return Buffer.from([
    Math.floor(value / 0x400000) | 0x80,
    (Math.floor(value / 0x8000) & 0x7f) | 0x80,
    (Math.floor(value / 0x100) & 0x7f) | 0x80,
    value & 0xff,
  ]);
}

function readAmf3U29(buffer: Buffer, offset: number): { value: number; offset: number } {
  let value = 0;
  let cursor = offset;
  for (let index = 0; index < 3; index += 1) {
    const byte = buffer[cursor++];
    value = (value << 7) | (byte & 0x7f);
    if ((byte & 0x80) === 0) {
      return { value, offset: cursor };
    }
  }
  value = (value << 8) | buffer[cursor++];
  return { value, offset: cursor };
}

function compressedSaveXml(xml: string): string {
  const xmlBytes = Buffer.from(xml, "utf8");
  return deflateSync(Buffer.concat([Buffer.from([0x06]), encodeAmf3U29(xmlBytes.length * 2 + 1), xmlBytes])).toString(
    "base64"
  );
}

function amf3SaveXmlStats(rawData: string): { declaredBytes: number; actualBytes: number; inflatedBytes: number } {
  const inflated = inflateSync(Buffer.from(rawData, "base64"));
  assert.equal(inflated[0], 0x06);
  const header = readAmf3U29(inflated, 1);
  assert.equal(header.value & 1, 1);
  const declaredBytes = Math.floor(header.value / 2);
  const actualBytes = inflated.length - header.offset;
  return { declaredBytes, actualBytes, inflatedBytes: inflated.length };
}

const SHOP_SAVE_XML = [
  '<saveXml type="Object" game4399="true">',
  '  <s type="Object" name="null">',
  '    <s type="Object" name="jxkaizhong">',
  '      <s type="Object" name="jxbag">',
  '        <s type="Object" name="b3">',
  '          <s type="Array" name="bg">',
  '            <s type="Object" name="null">',
  '              <s type="Number" name="gn">2</s>',
  '              <s type="Object" name="gs">',
  '                <s type="Object" name="ob"><s type="Number" name="wm">0</s></s>',
  '                <s type="Number" name="ct">1</s>',
  '                <s type="Number" name="id">331362</s>',
  '              </s>',
  '              <s type="Number" name="key">0</s>',
  '            </s>',
  '            <s type="Object" name="null">',
  '              <s type="Number" name="gn">5</s>',
  '              <s type="Object" name="gs">',
  '                <s type="Object" name="ob"/>',
  '                <s type="Number" name="ct">1</s>',
  '                <s type="Number" name="id">321000</s>',
  '              </s>',
  '              <s type="Number" name="key">0</s>',
  '            </s>',
  '          </s>',
  '        </s>',
  '      </s>',
  '    </s>',
  '  </s>',
  "</saveXml>",
].join("\n");

const SHOP_SAVE_DATA = compressedSaveXml(SHOP_SAVE_XML);
const LEGACY_IDENTITY_SAVE_DATA = compressedSaveXml(
  [
    '<saveXml type="Object" game4399="true">',
    '  <s type="Object" name="null">',
    '    <s type="Number" name="jxid">395614828</s>',
    '    <s type="Number" name="sidx">4</s>',
    '    <s type="String" name="idn">191chenjiachun</s>',
    '    <s type="Object" name="asaved">',
    '      <s type="Object" name="cm">',
    '        <s type="Number" name="co">1</s>',
    '        <s type="Number" name="idai">1978074140</s>',
    '        <s type="Array" name="dm"/>',
    '        <s type="Array" name="fa">',
    '          <s type="Object" name="null">',
    '            <s type="Number" name="cd">70308</s>',
    '            <s type="Number" name="cm">1</s>',
    '            <s type="Number" name="cf">1</s>',
    '            <s type="Number" name="cv">1978074140</s>',
    '          </s>',
    '          <s type="Object" name="null">',
    '            <s type="Number" name="cd">70308</s>',
    '            <s type="Number" name="cm">100123</s>',
    '            <s type="Number" name="cf">3</s>',
    '            <s type="Number" name="cv">19600</s>',
    '          </s>',
    '        </s>',
    '      </s>',
    '    </s>',
    '  </s>',
    "</saveXml>",
  ].join("\n")
);
const TEST_CATALOG: GameDataCatalog = {
  sourceFile: "test",
  loaded: true,
  items: [],
  productsByPlatformId: new Map([
    [
      1652,
      [{ goodsId: 331362, platformId: 1652, showPrice: 50, realPrice: 50, priceFlag: 1, job: -1 }],
    ],
  ]),
  goodsShopPriceById: new Map([
    [331362, 50],
    [321000, -1],
  ]),
};
const LEVEL_REWARD_XML = [
  "<root>",
  "<关卡><关卡ID>1</关卡ID><关卡名>溪谷小筑</关卡名><难度>1</难度><过关奖励经验>1045</过关奖励经验><过关奖励金币>1178</过关奖励金币><过关奖励成就>23</过关奖励成就></关卡>",
  "<关卡><关卡ID>2</关卡ID><关卡名>原始森林</关卡名><难度>1</难度><过关奖励经验>1131</过关奖励经验><过关奖励金币>1336</过关奖励金币><过关奖励成就>23</过关奖励成就></关卡>",
  "</root>",
].join("");

const { dir, dbFile } = tempDbFile();
const db = new LocalSaveDatabase(dbFile);
const logger = new SaveDataLogger({ logFile: path.join(dir, "mock-api.ndjson") });
const disabledLogFile = path.join(dir, "disabled-log.ndjson");
const disabledLogger = new SaveDataLogger({ logFile: disabledLogFile, enabled: false });

try {
  disabledLogger.appendSync({ event: "disabled.log", result: "ignored" });
  assert.equal(disabledLogger.list().length, 0);
  assert.equal(existsSync(disabledLogFile), false);
  disabledLogger.clear();
  assert.equal(existsSync(disabledLogFile), false);

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

  const saveEstimate = estimateSaveShopValue(SHOP_SAVE_DATA, TEST_CATALOG);
  assert.equal(saveEstimate.decoded, true);
  assert.equal(saveEstimate.shopValue, 100);
  assert.equal(saveEstimate.stackCount, 7);
  assert.equal(antiCheatRequiredRecharge(saveEstimate.shopValue), 75);
  const canonicalSave = canonicalizeLocalSaveIdentity(LEGACY_IDENTITY_SAVE_DATA, {
    uid: DEFAULT_ACCOUNT.uid,
    username: DEFAULT_ACCOUNT.username,
    slotIndex: 4,
  });
  const canonicalXml = decodeSaveXml(canonicalSave);
  assert.ok(canonicalXml);
  assert.match(canonicalXml, /name="jxid">10001</);
  assert.match(canonicalXml, /name="sidx">4</);
  assert.match(canonicalXml, /name="idn">local_user</);
  assert.match(canonicalXml, /name="idai">50005</);
  assert.doesNotMatch(canonicalXml, /name="cf">1</);
  assert.match(canonicalXml, /name="cf">3</);
  const canonicalStats = amf3SaveXmlStats(canonicalSave);
  assert.equal(canonicalStats.declaredBytes, canonicalStats.actualBytes);
  assert.equal(canonicalStats.actualBytes, Buffer.byteLength(canonicalXml, "utf8"));

  const levelRewards = parseLevelRewardRecords(LEVEL_REWARD_XML);
  assert.equal(levelRewards.length, 2);
  assert.equal(levelRewards[0].key, "1:1");
  assert.equal(levelRewards[0].name, "溪谷小筑");
  assert.deepEqual(levelRewards[0].original, { exp: 1045, gold: 1178, achievement: 23 });
  const boostedLevelRewards = applyLevelRewardAchievementBoostToXml(LEVEL_REWARD_XML, true);
  assert.match(boostedLevelRewards, /<关卡ID>1<\/关卡ID>[\s\S]*?<过关奖励经验>1045<\/过关奖励经验>/);
  assert.match(boostedLevelRewards, /<关卡ID>1<\/关卡ID>[\s\S]*?<过关奖励金币>1178<\/过关奖励金币>/);
  assert.match(boostedLevelRewards, /<关卡ID>1<\/关卡ID>[\s\S]*?<过关奖励成就>9999<\/过关奖励成就>/);
  assert.match(boostedLevelRewards, /<关卡ID>2<\/关卡ID>[\s\S]*?<过关奖励成就>9999<\/过关奖励成就>/);
  assert.equal(applyLevelRewardAchievementBoostToXml(LEVEL_REWARD_XML, false), LEVEL_REWARD_XML);

  const wallet = db.getWallet(DEFAULT_ACCOUNT.uid);
  const purchase = db.buyProp({ uid: DEFAULT_ACCOUNT.uid, propId: 12, count: 2, price: 30, tag: 7 });
  assert.equal(purchase.balance, wallet.balance - 60);
  assert.throws(
    () => db.buyProp({ uid: DEFAULT_ACCOUNT.uid, propId: 12, count: 1, price: 999999, tag: 7 }),
    /Insufficient wallet balance/
  );
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

  const legacySavesFile = path.join(dir, "runtime-mock-saves.json");
  writeFileSync(
    legacySavesFile,
    JSON.stringify({
      slots: {
        "1": {
          index: 1,
          title: "legacy-slot-1",
          datetime: "2026-06-30 21:26:11",
          data: "legacy-save-data",
          status: "0",
        },
      },
    })
  );
  const legacyDb = new LegacyJsonSaveDatabase(legacySavesFile);
  const legacyApi = new SaveDataMockApi(legacyDb, DEFAULT_ACCOUNT, logger);
  try {
    const legacyList = JSON.parse(
      request(legacyApi, `https://save.api.4399.com/?ac=get_list&uid=${DEFAULT_ACCOUNT.uid}&gameid=${GAME_ID}`)
    );
    assert.equal(legacyList.length, 1);
    assert.equal(legacyList[0].index, 1);
    assert.equal(legacyList[0].title, "legacy-slot-1");

    const legacyLoaded = JSON.parse(
      request(legacyApi, `https://save.api.4399.com/?ac=get&uid=${DEFAULT_ACCOUNT.uid}&gameid=${GAME_ID}&index=1`)
    );
    assert.equal(legacyLoaded.index, 1);
    assert.equal(legacyLoaded.data, "legacy-save-data");

    assert.equal(
      request(
        legacyApi,
        "https://save.api.4399.com/?ac=save",
        "POST",
        new URLSearchParams({
          uid: DEFAULT_ACCOUNT.uid,
          gameid: GAME_ID,
          index: "1",
          title: "legacy-slot-1-updated",
          data: "legacy-save-data-updated",
        }).toString()
      ),
      "1"
    );
    const persistedLegacyStore = JSON.parse(readFileSync(legacySavesFile, "utf8"));
    assert.equal(persistedLegacyStore.slots["1"].title, "legacy-slot-1-updated");
    assert.equal(persistedLegacyStore.slots["1"].data, "legacy-save-data-updated");
  } finally {
    legacyDb.close();
  }

  const catalog = loadGameDataCatalog();
  if (catalog.loaded) {
    const second = tempDbFile();
    const db2 = new LocalSaveDatabase(second.dbFile);
    const logger2 = new SaveDataLogger({ logFile: path.join(second.dir, "mock-api.ndjson") });
    try {
      const api2 = new SaveDataMockApi(db2, DEFAULT_ACCOUNT, logger2);
      db2.saveSlot({
        uid: DEFAULT_ACCOUNT.uid,
        gameid: GAME_ID,
        index: 2,
        title: "商城价值基线",
        data: SHOP_SAVE_DATA,
      });
      const account = db2.ensureAccount(DEFAULT_ACCOUNT.uid);
      db2.db.prepare("UPDATE wallet_mock SET balance = ?, total_recharged = ? WHERE account_id = ?").run(1000000, 0, account.id);

      assert.equal(api2.getTotalRechargeView(DEFAULT_ACCOUNT.uid, GAME_ID).totalRecharged, 75);
      assert.throws(
        () =>
          api2.buyProp({
            uid: DEFAULT_ACCOUNT.uid,
            gameId: GAME_ID,
            slotIndex: 2,
            propId: 1652,
            count: 2,
            price: 50,
            tag: 1,
          }),
        (error) => error instanceof MockShopError && error.code === 20003 && error.result === "recharge_required"
      );

      db2.rechargeWallet({ uid: DEFAULT_ACCOUNT.uid, amount: 200 });
      const okPurchase = api2.buyProp({
        uid: DEFAULT_ACCOUNT.uid,
        gameId: GAME_ID,
        slotIndex: 2,
        propId: 1652,
        count: 1,
        price: 50,
        tag: 2,
      });
      assert.equal(okPurchase.balance, 1000150);
      assert.equal(okPurchase.requiredTotalRecharge, 113);

      const mismatchUidPurchase = api2.buyProp({
        uid: "legacy-platform-uid",
        gameId: GAME_ID,
        slotIndex: 2,
        propId: 1652,
        count: 1,
        price: 50,
        tag: 3,
      });
      assert.equal(mismatchUidPurchase.requestedUid, "legacy-platform-uid");
      assert.equal(mismatchUidPurchase.paymentUid, DEFAULT_ACCOUNT.uid);
      assert.equal(mismatchUidPurchase.balance, 1000100);
      assert.equal(db2.getAccountByUid("legacy-platform-uid"), null);
    } finally {
      db2.close();
      rmSync(second.dir, { recursive: true, force: true });
    }
  }

  console.log("saveData db flow ok");
} finally {
  db.close();
  rmSync(dir, { recursive: true, force: true });
}
