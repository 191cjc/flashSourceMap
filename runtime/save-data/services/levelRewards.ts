import { createHash } from "node:crypto";
import { existsSync, mkdirSync, readFileSync, statSync, writeFileSync } from "node:fs";
import path from "node:path";
import { decodeSwf, encodeSwf, replaceDefineBinaryData } from "../../../src/swf/swf.js";
import { saveDataPaths } from "../server/paths.js";
import { DATA_XML_SWF, readDefineBinaryText } from "./gameData.js";

export const LEVEL_REWARD_BINARY_ID = 52;
export const LEVEL_REWARD_ASSET_NAME = "dataxmlvav447.swf";

export type LevelRewardValues = {
  exp: number;
  gold: number;
  achievement: number;
};

export type LevelRewardOverride = LevelRewardValues & {
  levelId: number;
  difficulty: number;
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

type LevelRewardOverrideFile = {
  version: 1;
  updatedAt: string;
  overrides: LevelRewardOverride[];
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

function integerFromInput(value: unknown, fieldName: string, minValue: number): number {
  const parsed = typeof value === "number" ? value : typeof value === "string" ? Number(value.trim()) : NaN;
  if (!Number.isFinite(parsed)) {
    throw new RangeError(`${fieldName} must be a finite number`);
  }
  const integer = Math.floor(parsed);
  if (!Number.isSafeInteger(integer) || integer < minValue) {
    throw new RangeError(`${fieldName} must be a safe integer >= ${minValue}`);
  }
  return integer;
}

function asInputObject(input: unknown): Record<string, unknown> {
  if (!input || typeof input !== "object" || Array.isArray(input)) {
    throw new RangeError("level reward payload must be an object");
  }
  return input as Record<string, unknown>;
}

function parseLevelRewardOverride(input: unknown): LevelRewardOverride {
  const object = asInputObject(input);
  return {
    levelId: integerFromInput(object.levelId, "levelId", 1),
    difficulty: integerFromInput(object.difficulty, "difficulty", 0),
    exp: integerFromInput(object.exp, "exp", 0),
    gold: integerFromInput(object.gold, "gold", 0),
    achievement: integerFromInput(object.achievement, "achievement", 0),
  };
}

function parseLevelRewardSelector(input: unknown): { levelId: number; difficulty: number } {
  const object = asInputObject(input);
  return {
    levelId: integerFromInput(object.levelId, "levelId", 1),
    difficulty: integerFromInput(object.difficulty, "difficulty", 0),
  };
}

function overrideMap(overrides: LevelRewardOverride[]): Map<string, LevelRewardOverride> {
  const map = new Map<string, LevelRewardOverride>();
  for (const override of overrides) {
    map.set(levelRewardKey(override.levelId, override.difficulty), override);
  }
  return map;
}

function sortOverrides(overrides: LevelRewardOverride[]): LevelRewardOverride[] {
  return [...overrides].sort((left, right) => left.levelId - right.levelId || left.difficulty - right.difficulty);
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

export function applyLevelRewardOverridesToXml(xml: string, overrides: LevelRewardOverride[]): string {
  const overridesByKey = overrideMap(overrides);
  if (overridesByKey.size === 0) {
    return xml;
  }

  return xml.replace(/<关卡>([\s\S]*?)<\/关卡>/g, (fullMatch, inner: string) => {
    const levelId = numberFromTag(inner, "关卡ID");
    const difficulty = numberFromTag(inner, "难度");
    if (levelId == null || difficulty == null) {
      return fullMatch;
    }

    const override = overridesByKey.get(levelRewardKey(levelId, difficulty));
    if (!override) {
      return fullMatch;
    }

    let patched = inner;
    for (const [field, tagName] of Object.entries(FIELD_TAGS) as Array<[keyof LevelRewardValues, string]>) {
      const escaped = escapeRegExp(tagName);
      patched = patched.replace(
        new RegExp(`(<${escaped}>)[\\s\\S]*?(</${escaped}>)`),
        (_match, open: string, close: string) => `${open}${override[field]}${close}`
      );
    }
    return `<关卡>${patched}</关卡>`;
  });
}

function readOverridesFile(overridesFile = saveDataPaths.levelRewardOverridesFile): LevelRewardOverrideFile {
  if (!existsSync(overridesFile)) {
    return { version: 1, updatedAt: "", overrides: [] };
  }

  const parsed = JSON.parse(readFileSync(overridesFile, "utf8")) as Partial<LevelRewardOverrideFile>;
  const overrides = Array.isArray(parsed.overrides)
    ? parsed.overrides.map((override) => parseLevelRewardOverride(override))
    : [];
  return {
    version: 1,
    updatedAt: typeof parsed.updatedAt === "string" ? parsed.updatedAt : "",
    overrides: sortOverrides(overrides),
  };
}

function writeOverridesFile(overrides: LevelRewardOverride[], overridesFile = saveDataPaths.levelRewardOverridesFile): void {
  mkdirSync(path.dirname(overridesFile), { recursive: true });
  const payload: LevelRewardOverrideFile = {
    version: 1,
    updatedAt: new Date().toISOString(),
    overrides: sortOverrides(overrides),
  };
  writeFileSync(overridesFile, `${JSON.stringify(payload, null, 2)}\n`);
}

export function loadLevelRewardOverrides(overridesFile = saveDataPaths.levelRewardOverridesFile): LevelRewardOverride[] {
  return readOverridesFile(overridesFile).overrides;
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

function assertKnownLevel(source: LevelRewardSourceCache | null, selector: { levelId: number; difficulty: number }): void {
  if (!source) {
    throw new Error(`level reward source is missing: ${DATA_XML_SWF}`);
  }
  if (!source.records.some((record) => record.key === levelRewardKey(selector.levelId, selector.difficulty))) {
    throw new RangeError(`level reward record not found: ${selector.levelId}:${selector.difficulty}`);
  }
}

export function getLevelRewardState(): LevelRewardState {
  const source = loadLevelRewardSource();
  const overrides = loadLevelRewardOverrides();
  const overridesByKey = overrideMap(overrides);
  const levels = (source?.records ?? []).map((record) => {
    const override = overridesByKey.get(record.key);
    return {
      ...record,
      effective: override
        ? { exp: override.exp, gold: override.gold, achievement: override.achievement }
        : { ...record.original },
      hasOverride: Boolean(override),
    };
  });

  return {
    ok: true,
    loaded: Boolean(source),
    sourceFile: DATA_XML_SWF,
    overridesFile: saveDataPaths.levelRewardOverridesFile,
    overridesCount: overrides.length,
    levels,
  };
}

export function setLevelRewardOverride(input: unknown): LevelRewardState {
  const override = parseLevelRewardOverride(input);
  const source = loadLevelRewardSource();
  assertKnownLevel(source, override);

  const existing = loadLevelRewardOverrides().filter(
    (entry) => levelRewardKey(entry.levelId, entry.difficulty) !== levelRewardKey(override.levelId, override.difficulty)
  );
  existing.push(override);
  writeOverridesFile(existing);
  return getLevelRewardState();
}

export function clearLevelRewardOverride(input: unknown): LevelRewardState {
  const selector = parseLevelRewardSelector(input);
  const existing = loadLevelRewardOverrides();
  const next = existing.filter(
    (entry) => levelRewardKey(entry.levelId, entry.difficulty) !== levelRewardKey(selector.levelId, selector.difficulty)
  );
  writeOverridesFile(next);
  return getLevelRewardState();
}

export function clearAllLevelRewardOverrides(): LevelRewardState {
  writeOverridesFile([]);
  return getLevelRewardState();
}

function patchedAssetSignature(sourceFile: string, overrides: LevelRewardOverride[]): string {
  const stat = statSync(sourceFile);
  return createHash("sha256")
    .update(
      JSON.stringify({
        sourceFile,
        sourceMtimeMs: stat.mtimeMs,
        sourceSize: stat.size,
        overrides: sortOverrides(overrides),
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
  const overrides = loadLevelRewardOverrides();
  if (!existsSync(sourceFile)) {
    return null;
  }
  if (overrides.length === 0) {
    return sourceFile;
  }

  const source = loadLevelRewardSource(sourceFile);
  if (!source) {
    return null;
  }

  const patchedXml = applyLevelRewardOverridesToXml(source.xml, overrides);
  if (patchedXml === source.xml) {
    return sourceFile;
  }

  const outputDir = path.join(saveDataPaths.generatedAssetsRoot, "level-rewards");
  const outputFile = path.join(outputDir, LEVEL_REWARD_ASSET_NAME);
  const metaFile = `${outputFile}.json`;
  const signature = patchedAssetSignature(sourceFile, overrides);
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
        overrides: sortOverrides(overrides),
      },
      null,
      2
    )}\n`
  );
  return outputFile;
}
