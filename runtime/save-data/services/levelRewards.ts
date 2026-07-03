import { createHash } from "node:crypto";
import { existsSync, mkdirSync, readFileSync, statSync, writeFileSync } from "node:fs";
import path from "node:path";
import { decodeSwf, encodeSwf, replaceDefineBinaryData } from "../../../src/swf/swf.js";
import { saveDataPaths } from "../server/paths.js";
import { DATA_XML_SWF, readDefineBinaryText } from "./gameData.js";

export const LEVEL_REWARD_BINARY_ID = 52;
export const LEVEL_REWARD_ASSET_NAME = "dataxmlvav447.swf";
export const LEVEL_REWARD_ACHIEVEMENT_BOOST_VALUE = 9999;

export type LevelRewardValues = {
  exp: number;
  gold: number;
  achievement: number;
};

export type LevelRewardRecord = {
  key: string;
  levelId: number;
  name: string;
  difficulty: number;
  original: LevelRewardValues;
  effective: LevelRewardValues;
  hasOverride: boolean;
};

export type LevelRewardState = {
  ok: true;
  loaded: boolean;
  sourceFile: string;
  overridesFile: string;
  achievementBoostEnabled: boolean;
  achievementBoostValue: number;
  overridesCount: number;
  levels: LevelRewardRecord[];
};

type LevelRewardSourceCache = {
  sourceFile: string;
  mtimeMs: number;
  size: number;
  xml: string;
  records: Array<Omit<LevelRewardRecord, "effective" | "hasOverride">>;
};

type LevelRewardConfigFile = {
  version: 2;
  updatedAt: string;
  achievementBoostEnabled: boolean;
};

const FIELD_TAGS = {
  exp: "过关奖励经验",
  gold: "过关奖励金币",
  achievement: "过关奖励成就",
} as const;

let sourceCache: LevelRewardSourceCache | null = null;

export function levelRewardKey(levelId: number, difficulty: number): string {
  return `${levelId}:${difficulty}`;
}

function escapeRegExp(value: string): string {
  return value.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
}

function tagText(record: string, tagName: string): string | null {
  const escaped = escapeRegExp(tagName);
  const match = new RegExp(`<${escaped}>([\\s\\S]*?)</${escaped}>`).exec(record);
  return match ? match[1].trim() : null;
}

function unescapeXmlText(value: string): string {
  return value
    .replace(/&lt;/g, "<")
    .replace(/&gt;/g, ">")
    .replace(/&quot;/g, '"')
    .replace(/&apos;/g, "'")
    .replace(/&amp;/g, "&");
}

function numberFromTag(record: string, tagName: string): number | null {
  const value = tagText(record, tagName);
  if (value == null || value === "") {
    return null;
  }
  const parsed = Number(value);
  return Number.isFinite(parsed) ? parsed : null;
}

function asInputObject(input: unknown): Record<string, unknown> {
  if (!input || typeof input !== "object" || Array.isArray(input)) {
    throw new RangeError("level reward payload must be an object");
  }
  return input as Record<string, unknown>;
}

export function parseLevelRewardRecords(xml: string): Array<Omit<LevelRewardRecord, "effective" | "hasOverride">> {
  const records: Array<Omit<LevelRewardRecord, "effective" | "hasOverride">> = [];
  const recordRe = /<关卡>([\s\S]*?)<\/关卡>/g;
  let match: RegExpExecArray | null;

  while ((match = recordRe.exec(xml))) {
    const record = match[1];
    const levelId = numberFromTag(record, "关卡ID");
    const difficulty = numberFromTag(record, "难度");
    const exp = numberFromTag(record, FIELD_TAGS.exp);
    const gold = numberFromTag(record, FIELD_TAGS.gold);
    const achievement = numberFromTag(record, FIELD_TAGS.achievement);

    if (levelId == null || difficulty == null || exp == null || gold == null || achievement == null) {
      continue;
    }

    records.push({
      key: levelRewardKey(levelId, difficulty),
      levelId,
      name: unescapeXmlText(tagText(record, "关卡名") ?? `关卡 ${levelId}`),
      difficulty,
      original: { exp, gold, achievement },
    });
  }

  return records;
}

function coalesceLevelRewardRecords(
  records: Array<Omit<LevelRewardRecord, "effective" | "hasOverride">>
): Array<Omit<LevelRewardRecord, "effective" | "hasOverride">> {
  const byKey = new Map<string, Omit<LevelRewardRecord, "effective" | "hasOverride">>();
  for (const record of records) {
    const existing = byKey.get(record.key);
    if (!existing) {
      byKey.set(record.key, record);
      continue;
    }

    const names = new Set(existing.name.split(" / "));
    names.add(record.name);
    byKey.set(record.key, {
      ...existing,
      name: [...names].join(" / "),
    });
  }
  return [...byKey.values()];
}

export function applyLevelRewardAchievementBoostToXml(
  xml: string,
  enabled: boolean,
  value = LEVEL_REWARD_ACHIEVEMENT_BOOST_VALUE
): string {
  if (!enabled) {
    return xml;
  }

  const escaped = escapeRegExp(FIELD_TAGS.achievement);
  return xml.replace(/<关卡>([\s\S]*?)<\/关卡>/g, (fullMatch, inner: string) => {
    const levelId = numberFromTag(inner, "关卡ID");
    const difficulty = numberFromTag(inner, "难度");
    if (levelId == null || difficulty == null) {
      return fullMatch;
    }

    const patched = inner.replace(
      new RegExp(`(<${escaped}>)[\\s\\S]*?(</${escaped}>)`),
      (_match, open: string, close: string) => `${open}${value}${close}`
    );
    return `<关卡>${patched}</关卡>`;
  });
}

function readLevelRewardConfig(overridesFile = saveDataPaths.levelRewardOverridesFile): LevelRewardConfigFile {
  if (!existsSync(overridesFile)) {
    return { version: 2, updatedAt: "", achievementBoostEnabled: false };
  }

  const parsed = JSON.parse(readFileSync(overridesFile, "utf8")) as Partial<LevelRewardConfigFile>;
  return {
    version: 2,
    updatedAt: typeof parsed.updatedAt === "string" ? parsed.updatedAt : "",
    achievementBoostEnabled: parsed.achievementBoostEnabled === true,
  };
}

function writeLevelRewardConfig(
  config: Pick<LevelRewardConfigFile, "achievementBoostEnabled">,
  overridesFile = saveDataPaths.levelRewardOverridesFile
): void {
  mkdirSync(path.dirname(overridesFile), { recursive: true });
  const payload: LevelRewardConfigFile = {
    version: 2,
    updatedAt: new Date().toISOString(),
    achievementBoostEnabled: config.achievementBoostEnabled,
  };
  writeFileSync(overridesFile, `${JSON.stringify(payload, null, 2)}\n`);
}

export function getLevelRewardAchievementBoostEnabled(overridesFile = saveDataPaths.levelRewardOverridesFile): boolean {
  return readLevelRewardConfig(overridesFile).achievementBoostEnabled;
}

function loadLevelRewardSource(sourceFile = DATA_XML_SWF): LevelRewardSourceCache | null {
  if (!existsSync(sourceFile)) {
    sourceCache = null;
    return null;
  }

  const stat = statSync(sourceFile);
  if (
    sourceCache &&
    sourceCache.sourceFile === sourceFile &&
    sourceCache.mtimeMs === stat.mtimeMs &&
    sourceCache.size === stat.size
  ) {
    return sourceCache;
  }

  const xml = readDefineBinaryText(sourceFile, LEVEL_REWARD_BINARY_ID);
  sourceCache = {
    sourceFile,
    mtimeMs: stat.mtimeMs,
    size: stat.size,
    xml,
    records: coalesceLevelRewardRecords(parseLevelRewardRecords(xml)),
  };
  return sourceCache;
}

export function clearLevelRewardSourceCache(): void {
  sourceCache = null;
}

export function getLevelRewardState(): LevelRewardState {
  const source = loadLevelRewardSource();
  const achievementBoostEnabled = getLevelRewardAchievementBoostEnabled();
  const levels = (source?.records ?? []).map((record) => {
    return {
      ...record,
      effective: {
        ...record.original,
        achievement: achievementBoostEnabled ? LEVEL_REWARD_ACHIEVEMENT_BOOST_VALUE : record.original.achievement,
      },
      hasOverride: achievementBoostEnabled,
    };
  });

  return {
    ok: true,
    loaded: Boolean(source),
    sourceFile: DATA_XML_SWF,
    overridesFile: saveDataPaths.levelRewardOverridesFile,
    achievementBoostEnabled,
    achievementBoostValue: LEVEL_REWARD_ACHIEVEMENT_BOOST_VALUE,
    overridesCount: achievementBoostEnabled ? levels.length : 0,
    levels,
  };
}

export function setLevelRewardAchievementBoost(input: unknown): LevelRewardState {
  const object = asInputObject(input);
  const enabled = object.enabled === true || object.achievementBoostEnabled === true;
  writeLevelRewardConfig({ achievementBoostEnabled: enabled });
  return getLevelRewardState();
}

export function clearLevelRewardAchievementBoost(): LevelRewardState {
  writeLevelRewardConfig({ achievementBoostEnabled: false });
  return getLevelRewardState();
}

function patchedAssetSignature(sourceFile: string, achievementBoostEnabled: boolean): string {
  const stat = statSync(sourceFile);
  return createHash("sha256")
    .update(
      JSON.stringify({
        sourceFile,
        sourceMtimeMs: stat.mtimeMs,
        sourceSize: stat.size,
        achievementBoostEnabled,
        achievementBoostValue: LEVEL_REWARD_ACHIEVEMENT_BOOST_VALUE,
      })
    )
    .digest("hex");
}

function cachedPatchMatches(metaFile: string, signature: string): boolean {
  if (!existsSync(metaFile)) {
    return false;
  }
  try {
    const meta = JSON.parse(readFileSync(metaFile, "utf8")) as { signature?: unknown };
    return meta.signature === signature;
  } catch {
    return false;
  }
}

export function ensurePatchedLevelRewardAsset(sourceFile = DATA_XML_SWF): string | null {
  const achievementBoostEnabled = getLevelRewardAchievementBoostEnabled();
  if (!existsSync(sourceFile)) {
    return null;
  }
  if (!achievementBoostEnabled) {
    return sourceFile;
  }

  const source = loadLevelRewardSource(sourceFile);
  if (!source) {
    return null;
  }

  const patchedXml = applyLevelRewardAchievementBoostToXml(source.xml, achievementBoostEnabled);
  if (patchedXml === source.xml) {
    return sourceFile;
  }

  const outputDir = path.join(saveDataPaths.generatedAssetsRoot, "level-rewards");
  const outputFile = path.join(outputDir, LEVEL_REWARD_ASSET_NAME);
  const metaFile = `${outputFile}.json`;
  const signature = patchedAssetSignature(sourceFile, achievementBoostEnabled);
  if (existsSync(outputFile) && cachedPatchMatches(metaFile, signature)) {
    return outputFile;
  }

  const swf = decodeSwf(readFileSync(sourceFile));
  const replacements = replaceDefineBinaryData(swf, LEVEL_REWARD_BINARY_ID, Buffer.from(patchedXml, "utf8"));
  if (replacements !== 1) {
    throw new Error(`Expected one level reward binary replacement, found ${replacements}`);
  }

  mkdirSync(outputDir, { recursive: true });
  writeFileSync(outputFile, encodeSwf(swf));
  writeFileSync(
    metaFile,
    `${JSON.stringify(
      {
        signature,
        sourceFile,
        generatedAt: new Date().toISOString(),
        achievementBoostEnabled,
        achievementBoostValue: LEVEL_REWARD_ACHIEVEMENT_BOOST_VALUE,
      },
      null,
      2
    )}\n`
  );
  return outputFile;
}
