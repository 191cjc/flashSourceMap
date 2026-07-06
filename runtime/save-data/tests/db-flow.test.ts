import assert from "node:assert/strict";
import { existsSync, mkdtempSync, readFileSync, rmSync, writeFileSync } from "node:fs";
import os from "node:os";
import path from "node:path";
import { deflateSync, inflateSync } from "node:zlib";
import CryptoJS from "crypto-js";
import { decodeSwf } from "../../../src/swf/swf.js";
import { inspectSolarPetRuntimePatch, patchSolarPetRuntime } from "../../../src/swf/solarPetPatch.js";
import {
  inspectEquipmentStrengtheningOptimization,
  patchEquipmentStrengtheningOptimization,
} from "../../../src/swf/strengtheningPatch.js";
import { inspectZodiacSoulExpOptimization, patchZodiacSoulExpOptimization } from "../../../src/swf/zodiacSoulExpPatch.js";
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
import {
  applyEquipmentStrengtheningSuccessPatchToXml,
  applyLevelRewardAchievementBoostToXml,
  applyPetSkillLearningOptimizationToXml,
  applySolarPetEggPatchToXml,
  applySolarPetPatchToXml,
  applySolarPetSummonMonsterPatchToXml,
  applyPetFusionLevelAttributePatchToXml,
  parseLevelRewardRecords,
  PET_FUSION_LEVEL_MAX,
  SOLAR_PET_APTITUDE,
  SOLAR_PET_BULLET_ATTACK2_CLASS_ALIAS,
  SOLAR_PET_BULLET_ATTACK4_CLASS_ALIAS,
  SOLAR_PET_BULLET_SELECT_CLASS_ALIAS,
  SOLAR_PET_EGG_GOODS_ID,
  SOLAR_PET_EGG_NAME,
  SOLAR_PET_ID,
  SOLAR_PET_NAME,
  SOLAR_PET_PASSIVE_SKILL_NAME,
  SOLAR_PET_QUALITY,
  SOLAR_PET_RESOURCE_NAME,
  SOLAR_PET_SKILL_BASE_ID,
  SOLAR_PET_SKILL_GROUP_COUNT,
  SOLAR_PET_SKILL_QUALITY_COUNT,
  SOLAR_PET_SUMMON_MONSTER_NAME,
  SOLAR_PET_SUMMON_SOURCE_MONSTER_NAME,
} from "../services/levelRewards.js";
import { SaveDataLogger } from "../server/logger.js";
import { DEFAULT_ACCOUNT, MockShopError, SaveDataMockApi } from "../platform4399/mockApi.js";

const GAME_ID = "100025235";
const INNER_GAME_SWF = path.join(process.cwd(), "extracted", "swf", "L4399Main_gamefile.swf");

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
const STRENGTHENING_XML = [
  "<root>",
  "<强化><掉落等级>1131000</掉落等级><品质>2</品质><强化值>6*12*19</强化值><强化概率>98*95*90</强化概率><金币>70*140*209</金币><材料id>321000*321000*321000</材料id></强化>",
  "<强化><掉落等级>1131001</掉落等级><品质>3</品质><强化值>9*18</强化值><强化概率>80*70</强化概率><金币>90*180</金币><材料id>321001*321001</材料id></强化>",
  "</root>",
].join("");
const PET_SKILL_SHOW_XML = [
  "<root>",
  "<宠物技能显示与说明><技能编号>1</技能编号><技能名称>爪击</技能名称><技能品质>0</技能品质><初始经验>10</初始经验></宠物技能显示与说明>",
  "<宠物技能显示与说明><技能编号>2</技能编号><技能名称>爪击</技能名称><技能品质>1</技能品质><初始经验>150</初始经验></宠物技能显示与说明>",
  "<宠物技能显示与说明><技能编号>3</技能编号><技能名称>爪击</技能名称><技能品质>2</技能品质><初始经验>300</初始经验></宠物技能显示与说明>",
  "<宠物技能显示与说明><技能编号>4</技能编号><技能名称>爪击</技能名称><技能品质>3</技能品质><初始经验>700</初始经验></宠物技能显示与说明>",
  "<宠物技能显示与说明><技能编号>5</技能编号><技能名称>唤雷</技能名称><技能品质>3</技能品质><初始经验>700</初始经验></宠物技能显示与说明>",
  "<宠物技能显示与说明><技能编号>10001</技能编号><技能名称>技能碎片</技能名称><技能品质>0</技能品质><初始经验>5</初始经验></宠物技能显示与说明>",
  "<宠物技能显示与说明><技能编号>10002</技能编号><技能名称>技能碎片</技能名称><技能品质>1</技能品质><初始经验>75</初始经验></宠物技能显示与说明>",
  "</root>",
].join("");
const PET_SKILL_LEARNING_XML = [
  "<root>",
  "<宠物技能领悟><针对的宠物ID>1</针对的宠物ID><领悟等级>1</领悟等级><进入下一等级概率>2000</进入下一等级概率><领悟后获得技能与概率>1*1000,2*1000,\n10001*8000</领悟后获得技能与概率><领悟需求晶币>1900</领悟需求晶币></宠物技能领悟>",
  "<宠物技能领悟><针对的宠物ID>1</针对的宠物ID><领悟等级>2</领悟等级><进入下一等级概率>5000</进入下一等级概率><领悟后获得技能与概率>3*500,4*1000,5*3000,\n10002*5500</领悟后获得技能与概率><领悟需求晶币>2500</领悟需求晶币></宠物技能领悟>",
  "</root>",
].join("");

function solarBossAction(level: string, bullet = "{}"): string {
  return [
    "<技能>",
    "<技能名称>帝王谷太阳神</技能名称>",
    `<技能等级>${level}</技能等级>`,
    "<动作名>待机</动作名>",
    "<动作类名>CASkillOneHiAndOneBullet</动作类名>",
    "<技能CD>900</技能CD>",
    "<CD随机浮动>30</CD随机浮动>",
    "<技能声音>{}</技能声音>",
    `<生成子弹>${bullet}</生成子弹>`,
    "</技能>",
  ].join("");
}

function solarBossBullet(level: string, className: string, monster = "null"): string {
  return [
    "<子弹>",
    "<源名>帝王谷太阳神</源名>",
    `<二名>${level}</二名>`,
    `<元件名>${className}</元件名>`,
    "<动作类名>CBBulletOne</动作类名>",
    "<生成声音>mp_taiyangshen</生成声音>",
    "<爆炸声音>mp_taiyangshen_boom</爆炸声音>",
    `<出那个怪>${monster}</出那个怪>`,
    "<存在帧数>80</存在帧数>",
    "<伤害增幅>1</伤害增幅>",
    "</子弹>",
  ].join("");
}

function solarMonster(name: string, secondName = "null", group = 2, className = "CMonster"): string {
  return [
    "<怪物>",
    `<怪物名>${name}</怪物名>`,
    `<怪物二名>${secondName}</怪物二名>`,
    "<真实名称>眼睛怪</真实名称>",
    "<头像帧数>1</头像帧数>",
    "<怪物等级>62</怪物等级>",
    "<类型>1</类型>",
    "<怪物级别分类>1</怪物级别分类>",
    "<怪物五行>0</怪物五行>",
    "<血量条基数>12415</血量条基数>",
    "<血量>111695</血量>",
    "<攻击力>68000</攻击力>",
    "<护甲>4993</护甲>",
    "<重力>3</重力>",
    "<金>0</金>",
    "<木>0</木>",
    "<水>0</水>",
    "<火>0</火>",
    "<土>0</土>",
    "<混沌>0</混沌>",
    "<死亡给予玩家经验>null</死亡给予玩家经验>",
    "<死亡掉落>null</死亡掉落>",
    "<死亡掉落2>null</死亡掉落2>",
    "<任务掉落>null</任务掉落>",
    "<特殊物品掉落上限>null</特殊物品掉落上限>",
    "<走帧定>30</走帧定>",
    "<走帧浮动>60</走帧浮动>",
    "<攻击列表>帝王谷眼球攻击1</攻击列表>",
    "<警戒>-2000,2000,-2000,2000</警戒>",
    "<追踪距离>-2000,2000,-2000,2000</追踪距离>",
    `<阵营>${group}</阵营>`,
    "<存在控制>0</存在控制>",
    "<存在时间>450</存在时间>",
    "<死亡后出现的球>null</死亡后出现的球>",
    "<元件名>m_yanqiu</元件名>",
    `<类名>${className}</类名>`,
    "</怪物>",
  ].join("");
}

const SOLAR_PET_XML = [
  "<root>",
  "<宠物><ID>1</ID><帧数>1</帧数><名字>测试宠物</名字><加载需求文件>c_test</加载需求文件><品质>1</品质><资质>1</资质><品种>普通</品种><融合经验>100</融合经验><重力>3</重力><警戒>0,1,2,3</警戒><追踪距离>0,1,2,3</追踪距离></宠物>",
  "</root>",
].join("");
const PET_FUSION_ATTRIBUTE_XML = [
  "<root>",
  "<融合等级属性><等级>65</等级><生命>7493</生命><能量>0</能量><攻击>460</攻击><防御>5478</防御><暴击>0</暴击><速度>0</速度><金>0</金><木>0</木><水>0</水><火>0</火><土>0</土><混沌>472</混沌></融合等级属性>",
  "<融合等级属性><等级>66</等级><生命>7661</生命><能量>0</能量><攻击>468</攻击><防御>5615</防御><暴击>0</暴击><速度>0</速度><金>0</金><木>0</木><水>0</水><火>0</火><土>0</土><混沌>484</混沌></融合等级属性>",
  "</root>",
].join("");
const SOLAR_PET_ACTION_XML = ["<root>", "<技能><技能名称>通用宠物</技能名称><技能等级>待机</技能等级></技能>", "</root>"].join("");
const SOLAR_MONSTER_ACTION_XML = [
  "<root>",
  solarBossAction("待机"),
  solarBossAction("移动"),
  solarBossAction("被打"),
  solarBossAction("倒地"),
  solarBossAction("眩晕"),
  solarBossAction("攻击1"),
  solarBossAction("攻击2", '{"59":"帝王谷太阳神攻击2"}'),
  solarBossAction("攻击3", '{"47":"帝王谷太阳神攻击3"}'),
  solarBossAction("攻击4", '{"35":"帝王谷太阳神攻击4"}'),
  "</root>",
].join("");
const SOLAR_BULLET_XML = [
  "<root>",
  solarBossBullet("攻击2", "abullet_taiyangshenBossgjb"),
  solarBossBullet("攻击3", "BulletM_taiyangshenBossgj3"),
  solarBossBullet("攻击4", "abullet_taiyangshenBossgjd", "帝王谷眼球"),
  "</root>",
].join("");
const SOLAR_PET_BULLET_XML = [
  "<root>",
  "<子弹><源名>旧太阳神技能</源名><二名>10</二名></子弹>",
  "</root>",
].join("");
const SOLAR_MONSTER_XML = [
  "<root>",
  solarMonster("帝王谷眼球"),
  solarMonster("帝王谷眼球", "噩梦_"),
  "</root>",
].join("");
const SOLAR_GOODS_XML = [
  "<root>",
  "<物品>",
  "<共有>",
  "<id>331398</id>",
  "<帧数>1358</帧数>",
  "<名称>光之白虎宠物蛋</名称>",
  "<颜色>2</颜色>",
  "<创建等级>1331401</创建等级>",
  "<类型>2</类型>",
  "<小类型>18</小类型>",
  '<说明>&lt;![CDATA[&lt;font color="#36ccff"&gt;使用后可孵化出上古神宠——光之白虎&lt;/font&gt;]]&gt;*</说明>',
  "<价格>1</价格>",
  "<叠加数>-1</叠加数>",
  "<背包>2</背包>",
  "<是否出售>true</是否出售>",
  "<是否使用>true</是否使用>",
  "</共有>",
  "<其他>",
  "<值>1800000</值>",
  "<需求id>26</需求id>",
  "<需求数量>-1</需求数量>",
  "<奖励概率>1000000</奖励概率>",
  "</其他>",
  "</物品>",
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

  const strengthened = applyEquipmentStrengtheningSuccessPatchToXml(STRENGTHENING_XML);
  assert.equal(strengthened.recordCount, 2);
  assert.equal(strengthened.targets.length, 2);
  assert.equal(strengthened.probabilityEntryCount, 5);
  assert.deepEqual(strengthened.targets[0].originalProbabilities, [98, 95, 90]);
  assert.deepEqual(strengthened.targets[0].patchedProbabilities, [100, 100, 100]);
  assert.deepEqual(strengthened.targets[1].patchedProbabilities, [100, 100]);
  assert.match(strengthened.xml, /<掉落等级>1131000<\/掉落等级>[\s\S]*?<强化概率>100\*100\*100<\/强化概率>/);
  assert.match(strengthened.xml, /<掉落等级>1131001<\/掉落等级>[\s\S]*?<强化概率>100\*100<\/强化概率>/);
  assert.match(strengthened.xml, /<金币>70\*140\*209<\/金币>/);
  assert.match(strengthened.xml, /<材料id>321001\*321001<\/材料id>/);

  const petSkillPatch = applyPetSkillLearningOptimizationToXml(PET_SKILL_LEARNING_XML, PET_SKILL_SHOW_XML);
  assert.equal(petSkillPatch.learningPoolCount, 2);
  assert.equal(petSkillPatch.targets.length, 2);
  assert.equal(petSkillPatch.nextLevelUnlockRecordCount, 2);
  assert.equal(petSkillPatch.fragmentEntryRemovalCount, 2);
  assert.equal(petSkillPatch.lowerQualityEntryRemovalCount, 2);
  assert.equal(petSkillPatch.targets[0].originalNextLevelProbability, 2000);
  assert.equal(petSkillPatch.targets[0].patchedNextLevelProbability, 10000);
  assert.equal(petSkillPatch.targets[1].originalNextLevelProbability, 5000);
  assert.equal(petSkillPatch.targets[1].patchedNextLevelProbability, 10000);
  assert.deepEqual(petSkillPatch.affectedSkillIds, [2, 4, 5]);
  assert.match(petSkillPatch.learningXml, /<领悟等级>1<\/领悟等级>[\s\S]*?<进入下一等级概率>10000<\/进入下一等级概率>/);
  assert.match(petSkillPatch.learningXml, /<领悟等级>2<\/领悟等级>[\s\S]*?<进入下一等级概率>10000<\/进入下一等级概率>/);
  assert.match(petSkillPatch.learningXml, /<领悟等级>1<\/领悟等级>[\s\S]*?<领悟后获得技能与概率>2\*10000<\/领悟后获得技能与概率>/);
  assert.match(petSkillPatch.learningXml, /<领悟等级>2<\/领悟等级>[\s\S]*?<领悟后获得技能与概率>4\*2500,5\*7500<\/领悟后获得技能与概率>/);
  assert.doesNotMatch(petSkillPatch.learningXml, /10001|10002/);
  assert.match(petSkillPatch.skillShowXml, /<技能编号>2<\/技能编号>[\s\S]*?<初始经验>3000<\/初始经验>/);
  assert.match(petSkillPatch.skillShowXml, /<技能编号>4<\/技能编号>[\s\S]*?<初始经验>14000<\/初始经验>/);
  assert.match(petSkillPatch.skillShowXml, /<技能编号>5<\/技能编号>[\s\S]*?<初始经验>14000<\/初始经验>/);
  assert.match(petSkillPatch.skillShowXml, /<技能编号>1<\/技能编号>[\s\S]*?<初始经验>10<\/初始经验>/);
  const petSkillPatchAgain = applyPetSkillLearningOptimizationToXml(petSkillPatch.learningXml, petSkillPatch.skillShowXml);
  assert.equal(petSkillPatchAgain.learningXml, petSkillPatch.learningXml);
  assert.equal(petSkillPatchAgain.skillShowXml, petSkillPatch.skillShowXml);

  const petFusionAttributePatch = applyPetFusionLevelAttributePatchToXml(PET_FUSION_ATTRIBUTE_XML);
  assert.equal(petFusionAttributePatch.originalMaxLevel, 66);
  assert.equal(petFusionAttributePatch.targetMaxLevel, PET_FUSION_LEVEL_MAX);
  assert.equal(petFusionAttributePatch.addedRecordCount, 4);
  assert.match(petFusionAttributePatch.xml, /<等级>70<\/等级>[\s\S]*?<生命>8333<\/生命>/);
  assert.match(petFusionAttributePatch.xml, /<等级>70<\/等级>[\s\S]*?<攻击>500<\/攻击>/);
  assert.match(petFusionAttributePatch.xml, /<等级>70<\/等级>[\s\S]*?<防御>6163<\/防御>/);
  assert.match(petFusionAttributePatch.xml, /<等级>70<\/等级>[\s\S]*?<混沌>532<\/混沌>/);
  const petFusionAttributePatchAgain = applyPetFusionLevelAttributePatchToXml(petFusionAttributePatch.xml);
  assert.equal(petFusionAttributePatchAgain.xml, petFusionAttributePatch.xml);
  assert.equal(petFusionAttributePatchAgain.addedRecordCount, 0);

  const solarPetPatch = applySolarPetPatchToXml(
    SOLAR_PET_XML,
    SOLAR_PET_ACTION_XML,
    SOLAR_MONSTER_ACTION_XML,
    SOLAR_BULLET_XML,
    SOLAR_PET_BULLET_XML,
    PET_SKILL_SHOW_XML,
    PET_SKILL_LEARNING_XML
  );
  const solarPetSummonMonsterPatch = applySolarPetSummonMonsterPatchToXml(SOLAR_MONSTER_XML);
  const solarPetSkillActionRecordCount =
    (SOLAR_PET_SKILL_GROUP_COUNT * (SOLAR_PET_SKILL_GROUP_COUNT + 1)) / 2 * SOLAR_PET_SKILL_QUALITY_COUNT;
  assert.equal(solarPetPatch.petRecordPresent, true);
  assert.equal(solarPetPatch.actionRecordCount, SOLAR_PET_APTITUDE + 1 + 5 + solarPetSkillActionRecordCount);
  assert.equal(solarPetPatch.bulletRecordCount, 3);
  assert.equal(solarPetPatch.petBulletRecordCount, (SOLAR_PET_SKILL_GROUP_COUNT - 2) * SOLAR_PET_SKILL_QUALITY_COUNT);
  assert.equal(solarPetPatch.skillActionRecordCount, solarPetSkillActionRecordCount);
  assert.equal(solarPetPatch.skillShowRecordCount, SOLAR_PET_SKILL_GROUP_COUNT * SOLAR_PET_SKILL_QUALITY_COUNT);
  assert.equal(solarPetPatch.skillLearningRecordCount, 7);
  assert.match(solarPetPatch.petXml, new RegExp(`<ID>${SOLAR_PET_ID}</ID>[\\s\\S]*?<名字>${SOLAR_PET_NAME}</名字>`));
  assert.match(solarPetPatch.petXml, new RegExp(`<加载需求文件>${SOLAR_PET_RESOURCE_NAME}</加载需求文件>`));
  assert.match(solarPetPatch.petXml, new RegExp(`<品质>${SOLAR_PET_QUALITY}</品质>`));
  assert.match(solarPetPatch.petXml, new RegExp(`<资质>${SOLAR_PET_APTITUDE}</资质>`));
  assert.equal((solarPetPatch.petActionXml.match(new RegExp(`<技能名称>${SOLAR_PET_NAME}</技能名称>`, "g")) ?? []).length, 13);
  assert.match(solarPetPatch.petActionXml, /<技能等级>0墨攻<\/技能等级>[\s\S]*?<生成子弹>{}<\/生成子弹>/);
  assert.match(
    solarPetPatch.petActionXml,
    /<技能等级>2墨攻<\/技能等级>[\s\S]*?<生成子弹>{"59":"太阳神宠物攻击2"}<\/生成子弹>/
  );
  assert.match(
    solarPetPatch.petActionXml,
    /<技能等级>4墨攻<\/技能等级>[\s\S]*?<生成子弹>{"47":"太阳神宠物攻击3"}<\/生成子弹>/
  );
  assert.match(
    solarPetPatch.petActionXml,
    /<技能等级>7墨攻<\/技能等级>[\s\S]*?<生成子弹>{"35":"太阳神宠物攻击4"}<\/生成子弹>/
  );
  assert.doesNotMatch(solarPetPatch.petActionXml, /<技能名称>帝王谷太阳神<\/技能名称>/);
  assert.doesNotMatch(solarPetPatch.petActionXml, /帝王谷太阳神攻击[234]/);
  assert.equal((solarPetPatch.bulletXml.match(/<源名>太阳神宠物<\/源名>/g) ?? []).length, 3);
  assert.match(solarPetPatch.bulletXml, new RegExp(`<二名>攻击2</二名>[\\s\\S]*?<元件名>${SOLAR_PET_BULLET_ATTACK2_CLASS_ALIAS}</元件名>`));
  assert.match(solarPetPatch.bulletXml, new RegExp(`<二名>攻击3</二名>[\\s\\S]*?<元件名>${SOLAR_PET_BULLET_SELECT_CLASS_ALIAS}</元件名>`));
  assert.match(solarPetPatch.bulletXml, new RegExp(`<二名>攻击4</二名>[\\s\\S]*?<元件名>${SOLAR_PET_BULLET_ATTACK4_CLASS_ALIAS}</元件名>`));
  assert.match(
    solarPetPatch.bulletXml,
    new RegExp(`<二名>攻击4</二名>[\\s\\S]*?<出那个怪>${SOLAR_PET_SUMMON_MONSTER_NAME}</出那个怪>`)
  );
  const solarPetBulletRecords = solarPetPatch.bulletXml.match(/<子弹><源名>太阳神宠物<\/源名>[\s\S]*?<\/子弹>/g) ?? [];
  assert.equal(solarPetBulletRecords.length, 3);
  assert.ok(solarPetBulletRecords.every((record) => !record.includes("<源名>帝王谷太阳神</源名>")));
  assert.ok(solarPetBulletRecords.every((record) => !record.includes("taiyangshenBoss")));
  assert.match(solarPetPatch.petSkillShowXml, new RegExp(`<技能编号>${SOLAR_PET_SKILL_BASE_ID}</技能编号>[\\s\\S]*?<技能名称>技能1</技能名称>`));
  assert.match(solarPetPatch.petSkillShowXml, /<针对的技能列表ID>技能1白<\/针对的技能列表ID>/);
  assert.match(
    solarPetPatch.petSkillShowXml,
    new RegExp(`<技能名称>${SOLAR_PET_PASSIVE_SKILL_NAME}</技能名称>[\\s\\S]*?<针对的技能列表ID>${SOLAR_PET_PASSIVE_SKILL_NAME}橙</针对的技能列表ID>[\\s\\S]*?<等级成长的技能伤害系数>0</等级成长的技能伤害系数>[\\s\\S]*?<基数>1</基数>[\\s\\S]*?<技能说明>被动：永久霸体，免疫冰冻、石化、眩晕。稳定度Z%</技能说明>`)
  );
  assert.match(solarPetPatch.petSkillShowXml, /<技能名称>技能7<\/技能名称>[\s\S]*?<针对的技能列表ID>技能7橙<\/针对的技能列表ID>/);
  assert.match(solarPetPatch.petSkillShowXml, /<最低资质限制>7<\/最低资质限制>/);
  assert.match(
    solarPetPatch.petSkillLearningXml,
    /<针对的宠物ID>27<\/针对的宠物ID>[\s\S]*?<领悟等级>1<\/领悟等级>[\s\S]*?<领悟后获得技能与概率>193\*1429,197\*1429,201\*1429,205\*1429,209\*1428,213\*1428,217\*1428<\/领悟后获得技能与概率>/
  );
  assert.match(
    solarPetPatch.petSkillLearningXml,
    /<领悟等级>7<\/领悟等级>[\s\S]*?<领悟后获得技能与概率>196\*1429,200\*1429,204\*1429,208\*1429,212\*1428,216\*1428,220\*1428<\/领悟后获得技能与概率>/
  );
  assert.match(solarPetPatch.petActionXml, /<技能名称>7技能7橙<\/技能名称>[\s\S]*?<技能等级>1<\/技能等级>/);
  assert.match(solarPetPatch.petActionXml, /<技能名称>7技能7橙<\/技能名称>[\s\S]*?<生成子弹>{"35":"技能7橙"}<\/生成子弹>/);
  assert.match(
    solarPetPatch.petActionXml,
    new RegExp(`<技能名称>5${SOLAR_PET_PASSIVE_SKILL_NAME}橙</技能名称>[\\s\\S]*?<技能等级>1</技能等级>[\\s\\S]*?<技能CD>999999999</技能CD>[\\s\\S]*?<生成子弹>{}</生成子弹>`)
  );
  assert.doesNotMatch(solarPetPatch.petBulletXml, new RegExp(`<源名>${SOLAR_PET_PASSIVE_SKILL_NAME}`));
  assert.match(solarPetPatch.petBulletXml, /<源名>技能7橙<\/源名>[\s\S]*?<二名>10<\/二名>/);
  assert.match(solarPetPatch.petBulletXml, /<源名>技能7橙<\/源名>[\s\S]*?<伤害增幅>9.12\*0.5472<\/伤害增幅>/);
  assert.match(
    solarPetPatch.petBulletXml,
    new RegExp(`<源名>技能7橙</源名>[\\s\\S]*?<出那个怪>${SOLAR_PET_SUMMON_MONSTER_NAME}</出那个怪>`)
  );
  assert.equal(solarPetSummonMonsterPatch.summonMonsterRecordPresent, true);
  assert.match(
    solarPetSummonMonsterPatch.monsterXml,
    new RegExp(
      `<怪物名>${SOLAR_PET_SUMMON_MONSTER_NAME}</怪物名>[\\s\\S]*?<阵营>1</阵营>[\\s\\S]*?<元件名>m_yanqiu</元件名>[\\s\\S]*?<类名>CMonsterFollowMe</类名>`
    )
  );
  assert.match(
    solarPetSummonMonsterPatch.monsterXml,
    new RegExp(`<怪物二名>噩梦_</怪物二名>[\\s\\S]*?<怪物名>帝王谷眼球</怪物名>|<怪物名>帝王谷眼球</怪物名>[\\s\\S]*?<怪物二名>噩梦_</怪物二名>`)
  );
  assert.equal((solarPetSummonMonsterPatch.monsterXml.match(new RegExp(`<怪物名>${SOLAR_PET_SUMMON_MONSTER_NAME}</怪物名>`, "g")) ?? []).length, 1);
  assert.notEqual(SOLAR_PET_SUMMON_MONSTER_NAME, SOLAR_PET_SUMMON_SOURCE_MONSTER_NAME);
  const solarPetPatchAgain = applySolarPetPatchToXml(
    solarPetPatch.petXml,
    solarPetPatch.petActionXml,
    SOLAR_MONSTER_ACTION_XML,
    solarPetPatch.bulletXml,
    solarPetPatch.petBulletXml,
    solarPetPatch.petSkillShowXml,
    solarPetPatch.petSkillLearningXml
  );
  assert.equal(solarPetPatchAgain.petXml, solarPetPatch.petXml);
  assert.equal(solarPetPatchAgain.petActionXml, solarPetPatch.petActionXml);
  assert.equal(solarPetPatchAgain.bulletXml, solarPetPatch.bulletXml);
  assert.equal(solarPetPatchAgain.petBulletXml, solarPetPatch.petBulletXml);
  assert.equal(solarPetPatchAgain.petSkillShowXml, solarPetPatch.petSkillShowXml);
  assert.equal(solarPetPatchAgain.petSkillLearningXml, solarPetPatch.petSkillLearningXml);
  const solarPetSummonMonsterPatchAgain = applySolarPetSummonMonsterPatchToXml(solarPetSummonMonsterPatch.monsterXml);
  assert.equal(solarPetSummonMonsterPatchAgain.monsterXml, solarPetSummonMonsterPatch.monsterXml);

  const solarPetEggPatch = applySolarPetEggPatchToXml(SOLAR_GOODS_XML);
  assert.equal(solarPetEggPatch.eggRecordPresent, true);
  assert.match(solarPetEggPatch.goodsXml, new RegExp(`<id>${SOLAR_PET_EGG_GOODS_ID}</id>[\\s\\S]*?<名称>${SOLAR_PET_EGG_NAME}</名称>`));
  assert.match(solarPetEggPatch.goodsXml, /<类型>2<\/类型>[\s\S]*?<小类型>18<\/小类型>/);
  assert.match(solarPetEggPatch.goodsXml, /<帧数>1358<\/帧数>/);
  assert.match(solarPetEggPatch.goodsXml, /<值>1800000<\/值>/);
  assert.match(solarPetEggPatch.goodsXml, new RegExp(`<需求id>${SOLAR_PET_ID}</需求id>`));
  assert.match(solarPetEggPatch.goodsXml, /<奖励概率>1000000<\/奖励概率>/);
  assert.match(solarPetEggPatch.goodsXml, /使用后可孵化出上古神宠——太阳神/);
  assert.equal((solarPetEggPatch.goodsXml.match(new RegExp(`<名称>${SOLAR_PET_EGG_NAME}</名称>`, "g")) ?? []).length, 1);
  const solarPetEggPatchAgain = applySolarPetEggPatchToXml(solarPetEggPatch.goodsXml);
  assert.equal(solarPetEggPatchAgain.goodsXml, solarPetEggPatch.goodsXml);

  assert.equal(existsSync(INNER_GAME_SWF), true);
  const innerGameSwf = decodeSwf(readFileSync(INNER_GAME_SWF));
  const strengtheningInspectionBefore = inspectEquipmentStrengtheningOptimization(innerGameSwf);
  assert.equal(strengtheningInspectionBefore.targetFound, true);
  if (!strengtheningInspectionBefore.oneClickMaxLevel || !strengtheningInspectionBefore.perfectLevelMaxed) {
    assert.equal(patchEquipmentStrengtheningOptimization(innerGameSwf), 1);
  }
  const strengtheningInspectionAfter = inspectEquipmentStrengtheningOptimization(innerGameSwf);
  assert.deepEqual(strengtheningInspectionAfter, { targetFound: true, oneClickMaxLevel: true, perfectLevelMaxed: true });
  assert.equal(patchEquipmentStrengtheningOptimization(innerGameSwf), 0);

  const zodiacInspectionBefore = inspectZodiacSoulExpOptimization(innerGameSwf);
  assert.equal(zodiacInspectionBefore.targetFound, true);
  if (!zodiacInspectionBefore.optimized) {
    assert.equal(patchZodiacSoulExpOptimization(innerGameSwf), 2);
  }
  const zodiacInspectionAfter = inspectZodiacSoulExpOptimization(innerGameSwf);
  assert.deepEqual(zodiacInspectionAfter, { targetFound: true, optimized: true });
  assert.equal(patchZodiacSoulExpOptimization(innerGameSwf), 0);

  const solarPetRuntimeBefore = inspectSolarPetRuntimePatch(innerGameSwf);
  assert.equal(solarPetRuntimeBefore.targetFound, true);
  if (
    !solarPetRuntimeBefore.filenameMapping ||
    !solarPetRuntimeBefore.classMappings ||
    !solarPetRuntimeBefore.classAliases ||
    !solarPetRuntimeBefore.fusionLevelMax ||
    !solarPetRuntimeBefore.passiveSuperArmor
  ) {
    assert.equal(patchSolarPetRuntime(innerGameSwf), 5);
  }
  const solarPetRuntimeAfter = inspectSolarPetRuntimePatch(innerGameSwf);
  assert.deepEqual(solarPetRuntimeAfter, {
    targetFound: true,
    filenameMapping: true,
    classMappings: true,
    classAliases: true,
    fusionLevelMax: true,
    passiveSuperArmor: true,
  });
  assert.equal(patchSolarPetRuntime(innerGameSwf), 0);

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
