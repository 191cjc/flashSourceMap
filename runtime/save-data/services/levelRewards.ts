import { createHash } from "node:crypto";
import { existsSync, mkdirSync, readFileSync, statSync, writeFileSync } from "node:fs";
import path from "node:path";
import { decodeSwf, encodeSwf, replaceDefineBinaryData } from "../../../src/swf/swf.js";
import { saveDataPaths } from "../server/paths.js";
import { clearGameDataCatalogCache, DATA_XML_SWF, readDefineBinaryText } from "./gameData.js";

export const LEVEL_REWARD_BINARY_ID = 52;
export const STRENGTHEN_BINARY_ID = 30;
export const ACTIVITY_GIFT_BINARY_ID = 16;
export const GOODS_BINARY_ID = 15;
export const PET_BINARY_ID = 42;
export const PET_SKILL_SHOW_BINARY_ID = 18;
export const PET_SKILL_LEARNING_BINARY_ID = 56;
export const LEVEL_REWARD_ASSET_NAME = "dataxmlvav447.swf";
export const LEVEL_REWARD_ACHIEVEMENT_BOOST_VALUE = 9999;
export const EQUIPMENT_STRENGTHEN_SUCCESS_PROBABILITY = 100;
export const ACTIVITY_VISIBILITY_START_TIME = "1900-01-01|00:00:00";
export const ACTIVITY_VISIBILITY_END_TIME = "2999-12-31|23:59:59";
export const ACTIVITY_VISIBILITY_VISIBLE_FLAG = "0";
export const ADVANCED_PET_EGG_GOODS_IDS = [331196, 331198] as const;
export const ADVANCED_PET_EGG_DARK_PET_ID = 19;
export const ADVANCED_PET_EGG_MIN_APTITUDE = 4;
export const PET_EGG_PROBABILITY_TOTAL = 1_000_000;
export const PET_SKILL_LEARNING_PROBABILITY_TOTAL = 10_000;
export const PET_SKILL_NEXT_LEVEL_UNLOCK_PROBABILITY = PET_SKILL_LEARNING_PROBABILITY_TOTAL;
export const PET_SKILL_INITIAL_EXP_MULTIPLIER = 20;
export const PET_INITIAL_FUSION_EXP_MULTIPLIER = 10;
export const PET_SKILL_BASE_INITIAL_EXP_BY_QUALITY: Readonly<Record<number, number>> = {
  0: 10,
  1: 150,
  2: 300,
  3: 700,
};
export const PET_INITIAL_FUSION_EXP_TARGETS = [
  { petId: 12, baseFusionExp: 100 },
  { petId: 17, baseFusionExp: 1200 },
  { petId: 15, baseFusionExp: 1200 },
  { petId: 25, baseFusionExp: 1200 },
  { petId: 19, baseFusionExp: 2000 },
] as const;

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

export type ActivityVisibilityState = {
  ok: true;
  loaded: boolean;
  sourceFile: string;
  assetName: string;
  patchedAssetFile: string | null;
  patchedAssetReady: boolean;
  allActivitiesVisible: boolean;
  giftCount: number;
  timedGiftCount: number;
  delistedGiftCount: number;
  patchedTimedGiftCount: number;
  patchedDelistedGiftCount: number;
  startTime: string;
  endTime: string;
  error?: string;
};

export type EquipmentStrengtheningTarget = {
  dropLevel: number | null;
  quality: number | null;
  originalProbabilities: number[];
  patchedProbabilities: number[];
  changed: boolean;
};

export type EquipmentStrengtheningOptimizationState = {
  ok: true;
  loaded: boolean;
  sourceFile: string;
  assetName: string;
  patchedAssetFile: string | null;
  patchedAssetReady: boolean;
  equipmentStrengtheningOptimized: boolean;
  oneClickMaxLevel: boolean;
  perfectLevelMaxed: boolean;
  successProbability: number;
  recordCount: number;
  probabilityRecordCount: number;
  probabilityEntryCount: number;
  patchedProbabilityEntryCount: number;
  error?: string;
};

export type AdvancedPetEggTarget = {
  goodsId: number;
  name: string;
  originalPetIds: number[];
  patchedPetIds: number[];
  patchedPetNames: string[];
  patchedProbabilities: number[];
  changed: boolean;
};

export type AdvancedPetEggOptimizationState = {
  ok: true;
  loaded: boolean;
  sourceFile: string;
  assetName: string;
  patchedAssetFile: string | null;
  patchedAssetReady: boolean;
  advancedPetEggOptimized: boolean;
  goodsIds: number[];
  minAptitude: number;
  addedPetId: number;
  probabilityTotal: number;
  targets: AdvancedPetEggTarget[];
  error?: string;
};

export type PetSkillLearningEntry = {
  skillId: number;
  probability: number;
  name: string;
  quality: number;
  fragment: boolean;
};

export type PetSkillLearningTarget = {
  petId: number | null;
  learnLevel: number | null;
  originalNextLevelProbability: number | null;
  patchedNextLevelProbability: number | null;
  originalEntries: PetSkillLearningEntry[];
  patchedEntries: PetSkillLearningEntry[];
  highestQuality: number;
  removedFragmentEntries: number;
  removedLowerQualityEntries: number;
  changed: boolean;
};

export type PetSkillInitialExpTarget = {
  skillId: number;
  name: string;
  quality: number;
  originalInitialExp: number;
  targetInitialExp: number;
  multiplier: number;
  changed: boolean;
};

export type PetSkillOptimizationState = {
  ok: true;
  loaded: boolean;
  sourceFile: string;
  assetName: string;
  patchedAssetFile: string | null;
  patchedAssetReady: boolean;
  petSkillOptimized: boolean;
  initialExpMultiplier: number;
  learningProbabilityTotal: number;
  nextLevelUnlockProbability: number;
  learningPoolCount: number;
  optimizedPoolCount: number;
  nextLevelUnlockRecordCount: number;
  affectedSkillCount: number;
  fragmentEntryRemovalCount: number;
  lowerQualityEntryRemovalCount: number;
  expTargetCount: number;
  error?: string;
};

export type PetInitialFusionExpTarget = {
  petId: number;
  name: string;
  originalFusionExp: number;
  targetFusionExp: number;
  multiplier: number;
  changed: boolean;
};

export type PetInitialFusionExpOptimizationState = {
  ok: true;
  loaded: boolean;
  sourceFile: string;
  assetName: string;
  patchedAssetFile: string | null;
  patchedAssetReady: boolean;
  petInitialFusionExpOptimized: boolean;
  multiplier: number;
  targetPetIds: number[];
  targets: PetInitialFusionExpTarget[];
  error?: string;
};

type ActivityGiftCounts = {
  giftCount: number;
  timedGiftCount: number;
  delistedGiftCount: number;
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

type PetDefinition = {
  id: number;
  name: string;
  aptitude: number;
};

type AdvancedPetEggPatchResult = {
  xml: string;
  targets: AdvancedPetEggTarget[];
};

type EquipmentStrengtheningPatchResult = {
  xml: string;
  targets: EquipmentStrengtheningTarget[];
  recordCount: number;
  probabilityEntryCount: number;
};

type PetSkillDefinition = {
  id: number;
  name: string;
  quality: number;
  initialExp: number;
};

type PetSkillLearningPatchResult = {
  learningXml: string;
  skillShowXml: string;
  targets: PetSkillLearningTarget[];
  expTargets: PetSkillInitialExpTarget[];
  affectedSkillIds: number[];
  learningPoolCount: number;
  nextLevelUnlockRecordCount: number;
  fragmentEntryRemovalCount: number;
  lowerQualityEntryRemovalCount: number;
};

type PetInitialFusionExpPatchResult = {
  xml: string;
  targets: PetInitialFusionExpTarget[];
};

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

function splitNumberList(value: string | null, separator = "*"): number[] {
  if (!value || value === "-1") {
    return [];
  }
  return value
    .split(separator)
    .map((entry) => Number(entry.trim()))
    .filter((entry) => Number.isSafeInteger(entry) && entry > 0);
}

function uniqueNumbers(values: number[]): number[] {
  const seen = new Set<number>();
  const result: number[] = [];
  for (const value of values) {
    if (seen.has(value)) {
      continue;
    }
    seen.add(value);
    result.push(value);
  }
  return result;
}

function parseStrengtheningProbabilityList(value: string): number[] {
  const entries = value.split("*").map((entry) => entry.trim());
  if (entries.length === 0 || entries.some((entry) => entry === "")) {
    throw new Error("strengthening probability list contains an empty entry");
  }
  return entries.map((entry) => {
    const parsed = Number(entry);
    if (!Number.isFinite(parsed) || parsed < 0) {
      throw new Error(`invalid strengthening probability: ${entry}`);
    }
    return parsed;
  });
}

function replaceTagContent(record: string, tagName: string, value: string): string {
  const escaped = escapeRegExp(tagName);
  return record.replace(new RegExp(`(<${escaped}>)[\\s\\S]*?(</${escaped}>)`), `$1${value}$2`);
}

function equalProbabilities(count: number): number[] {
  if (!Number.isSafeInteger(count) || count <= 0) {
    throw new Error("advanced pet egg target pool is empty");
  }
  const base = Math.floor(PET_EGG_PROBABILITY_TOTAL / count);
  let remainder = PET_EGG_PROBABILITY_TOTAL - base * count;
  return Array.from({ length: count }, () => {
    const value = base + (remainder > 0 ? 1 : 0);
    remainder -= 1;
    return value;
  });
}

function scaleWeightsToTotal(weights: number[], total: number): number[] {
  if (!Number.isSafeInteger(total) || total <= 0) {
    throw new Error("probability total must be a positive integer");
  }
  if (weights.length === 0) {
    throw new Error("probability weight list is empty");
  }
  if (weights.some((weight) => !Number.isFinite(weight) || weight <= 0)) {
    throw new Error("probability weights must be positive");
  }

  const weightTotal = weights.reduce((sum, weight) => sum + weight, 0);
  const scaled = weights.map((weight, index) => {
    const exact = (weight * total) / weightTotal;
    const floor = Math.floor(exact);
    return {
      index,
      value: floor,
      remainder: exact - floor,
    };
  });
  let remaining = total - scaled.reduce((sum, entry) => sum + entry.value, 0);
  scaled
    .slice()
    .sort((a, b) => b.remainder - a.remainder || a.index - b.index)
    .forEach((entry) => {
      if (remaining <= 0) {
        return;
      }
      entry.value += 1;
      remaining -= 1;
    });

  return scaled.sort((a, b) => a.index - b.index).map((entry) => entry.value);
}

function parsePetDefinitions(xml: string): Map<number, PetDefinition> {
  const pets = new Map<number, PetDefinition>();
  const petRe = /<宠物>([\s\S]*?)<\/宠物>/g;
  let match: RegExpExecArray | null;

  while ((match = petRe.exec(xml))) {
    const record = match[1];
    const id = numberFromTag(record, "ID");
    const aptitude = numberFromTag(record, "资质");
    if (id == null || aptitude == null) {
      continue;
    }
    pets.set(id, {
      id,
      name: tagText(record, "名字") ?? `宠物 ${id}`,
      aptitude,
    });
  }

  return pets;
}

function parsePetSkillDefinitions(xml: string): Map<number, PetSkillDefinition> {
  const skills = new Map<number, PetSkillDefinition>();
  const skillRe = /<宠物技能显示与说明>([\s\S]*?)<\/宠物技能显示与说明>/g;
  let match: RegExpExecArray | null;

  while ((match = skillRe.exec(xml))) {
    const record = match[1];
    const id = numberFromTag(record, "技能编号");
    const quality = numberFromTag(record, "技能品质");
    const initialExp = numberFromTag(record, "初始经验");
    if (id == null || quality == null || initialExp == null) {
      continue;
    }
    skills.set(id, {
      id,
      name: tagText(record, "技能名称") ?? `宠物技能 ${id}`,
      quality,
      initialExp,
    });
  }

  return skills;
}

function isPetSkillFragment(skill: PetSkillDefinition): boolean {
  return skill.id === 10000 || skill.name === "技能碎片" || skill.name === "融合的宠物技能";
}

function parsePetSkillLearningEntries(value: string, skills: Map<number, PetSkillDefinition>): PetSkillLearningEntry[] {
  const entries: PetSkillLearningEntry[] = [];
  for (const rawEntry of value.split(",")) {
    const entry = rawEntry.trim();
    if (!entry) {
      continue;
    }
    const [skillIdText, probabilityText, ...extra] = entry.split("*").map((part) => part.trim());
    if (!skillIdText || !probabilityText || extra.length > 0) {
      throw new Error(`invalid pet skill learning entry: ${entry}`);
    }
    const skillId = Number(skillIdText);
    const probability = Number(probabilityText);
    if (!Number.isSafeInteger(skillId) || !Number.isFinite(probability) || probability < 0) {
      throw new Error(`invalid pet skill learning entry: ${entry}`);
    }
    const skill = skills.get(skillId);
    if (!skill) {
      throw new Error(`pet skill ${skillId} is missing from skill display config`);
    }
    entries.push({
      skillId,
      probability,
      name: skill.name,
      quality: skill.quality,
      fragment: isPetSkillFragment(skill),
    });
  }
  return entries;
}

function formatPetSkillLearningEntries(entries: PetSkillLearningEntry[]): string {
  return entries.map((entry) => `${entry.skillId}*${entry.probability}`).join(",");
}

function petSkillTargetInitialExp(skill: { quality: number }): number {
  const baseInitialExp = PET_SKILL_BASE_INITIAL_EXP_BY_QUALITY[skill.quality];
  if (baseInitialExp == null) {
    throw new Error(`missing base initial experience for pet skill quality ${skill.quality}`);
  }
  return baseInitialExp * PET_SKILL_INITIAL_EXP_MULTIPLIER;
}

function targetAdvancedPetIds(originalPetIds: number[], pets: Map<number, PetDefinition>): number[] {
  const highAptitudeIds = originalPetIds.filter((petId) => {
    const pet = pets.get(petId);
    return pet != null && pet.aptitude >= ADVANCED_PET_EGG_MIN_APTITUDE;
  });
  return uniqueNumbers([...highAptitudeIds, ADVANCED_PET_EGG_DARK_PET_ID]);
}

export function applyAdvancedPetEggPatchToXml(goodsXml: string, petXml: string): AdvancedPetEggPatchResult {
  const pets = parsePetDefinitions(petXml);
  const targetIds = new Set<number>(ADVANCED_PET_EGG_GOODS_IDS);
  const targets: AdvancedPetEggTarget[] = [];

  const xml = goodsXml.replace(/<物品>[\s\S]*?<\/物品>/g, (record: string) => {
    const goodsId = numberFromTag(record, "id");
    if (goodsId == null || !targetIds.has(goodsId)) {
      return record;
    }

    const originalPetIds = splitNumberList(tagText(record, "需求id"));
    const patchedPetIds = targetAdvancedPetIds(originalPetIds, pets);
    const patchedProbabilities = equalProbabilities(patchedPetIds.length);
    const patchedPetNames = patchedPetIds.map((petId) => pets.get(petId)?.name ?? `宠物 ${petId}`);
    const patchedRecord = replaceTagContent(
      replaceTagContent(record, "需求id", patchedPetIds.join("*")),
      "奖励概率",
      patchedProbabilities.join("*")
    );

    targets.push({
      goodsId,
      name: tagText(record, "名称") ?? `物品 ${goodsId}`,
      originalPetIds,
      patchedPetIds,
      patchedPetNames,
      patchedProbabilities,
      changed: patchedRecord !== record,
    });
    return patchedRecord;
  });

  return { xml, targets };
}

export function applyEquipmentStrengtheningSuccessPatchToXml(strengtheningXml: string): EquipmentStrengtheningPatchResult {
  const targets: EquipmentStrengtheningTarget[] = [];
  let recordCount = 0;
  let probabilityEntryCount = 0;

  const xml = strengtheningXml.replace(/<强化>[\s\S]*?<\/强化>/g, (record: string) => {
    recordCount += 1;
    const probabilityText = tagText(record, "强化概率");
    if (probabilityText == null || probabilityText === "") {
      return record;
    }

    const originalProbabilities = parseStrengtheningProbabilityList(probabilityText);
    const patchedProbabilities = originalProbabilities.map(() => EQUIPMENT_STRENGTHEN_SUCCESS_PROBABILITY);
    const patchedRecord = replaceTagContent(record, "强化概率", patchedProbabilities.join("*"));
    probabilityEntryCount += patchedProbabilities.length;
    targets.push({
      dropLevel: numberFromTag(record, "掉落等级"),
      quality: numberFromTag(record, "品质"),
      originalProbabilities,
      patchedProbabilities,
      changed: patchedRecord !== record,
    });
    return patchedRecord;
  });

  return { xml, targets, recordCount, probabilityEntryCount };
}

export function applyPetSkillLearningOptimizationToXml(
  learningXml: string,
  skillShowXml: string
): PetSkillLearningPatchResult {
  const skills = parsePetSkillDefinitions(skillShowXml);
  const affectedSkillIds = new Set<number>();
  const targets: PetSkillLearningTarget[] = [];
  let learningPoolCount = 0;
  let nextLevelUnlockRecordCount = 0;
  let fragmentEntryRemovalCount = 0;
  let lowerQualityEntryRemovalCount = 0;

  const patchedLearningXml = learningXml.replace(/<宠物技能领悟>[\s\S]*?<\/宠物技能领悟>/g, (record: string) => {
    learningPoolCount += 1;
    const poolText = tagText(record, "领悟后获得技能与概率");
    if (poolText == null || poolText === "") {
      return record;
    }

    const originalEntries = parsePetSkillLearningEntries(poolText, skills);
    const learnableEntries = originalEntries.filter((entry) => !entry.fragment && entry.probability > 0);
    if (learnableEntries.length === 0) {
      throw new Error("pet skill learning pool has no learnable skill candidates");
    }

    const highestQuality = Math.max(...learnableEntries.map((entry) => entry.quality));
    const retainedEntries = learnableEntries.filter((entry) => entry.quality === highestQuality);
    const patchedProbabilities = scaleWeightsToTotal(
      retainedEntries.map((entry) => entry.probability),
      PET_SKILL_LEARNING_PROBABILITY_TOTAL
    );
    const patchedEntries = retainedEntries.map((entry, index) => {
      affectedSkillIds.add(entry.skillId);
      return {
        ...entry,
        probability: patchedProbabilities[index],
      };
    });
    const patchedPoolText = formatPetSkillLearningEntries(patchedEntries);
    const originalNextLevelProbability = numberFromTag(record, "进入下一等级概率");
    if (originalNextLevelProbability == null) {
      throw new Error("pet skill learning pool is missing next-level unlock probability");
    }
    nextLevelUnlockRecordCount += 1;
    const patchedRecord = replaceTagContent(
      replaceTagContent(record, "领悟后获得技能与概率", patchedPoolText),
      "进入下一等级概率",
      String(PET_SKILL_NEXT_LEVEL_UNLOCK_PROBABILITY)
    );
    const removedFragmentEntries = originalEntries.filter((entry) => entry.fragment).length;
    const removedLowerQualityEntries = learnableEntries.length - retainedEntries.length;
    fragmentEntryRemovalCount += removedFragmentEntries;
    lowerQualityEntryRemovalCount += removedLowerQualityEntries;
    targets.push({
      petId: numberFromTag(record, "针对的宠物ID"),
      learnLevel: numberFromTag(record, "领悟等级"),
      originalNextLevelProbability,
      patchedNextLevelProbability: PET_SKILL_NEXT_LEVEL_UNLOCK_PROBABILITY,
      originalEntries,
      patchedEntries,
      highestQuality,
      removedFragmentEntries,
      removedLowerQualityEntries,
      changed: patchedRecord !== record,
    });
    return patchedRecord;
  });

  const expTargets: PetSkillInitialExpTarget[] = [];
  const patchedSkillShowXml = skillShowXml.replace(
    /<宠物技能显示与说明>[\s\S]*?<\/宠物技能显示与说明>/g,
    (record: string) => {
      const skillId = numberFromTag(record, "技能编号");
      if (skillId == null || !affectedSkillIds.has(skillId)) {
        return record;
      }
      const skill = skills.get(skillId);
      if (!skill) {
        return record;
      }
      const targetInitialExp = petSkillTargetInitialExp(skill);
      const patchedRecord = replaceTagContent(record, "初始经验", String(targetInitialExp));
      expTargets.push({
        skillId,
        name: skill.name,
        quality: skill.quality,
        originalInitialExp: skill.initialExp,
        targetInitialExp,
        multiplier: PET_SKILL_INITIAL_EXP_MULTIPLIER,
        changed: patchedRecord !== record,
      });
      return patchedRecord;
    }
  );

  return {
    learningXml: patchedLearningXml,
    skillShowXml: patchedSkillShowXml,
    targets,
    expTargets,
    affectedSkillIds: [...affectedSkillIds].sort((a, b) => a - b),
    learningPoolCount,
    nextLevelUnlockRecordCount,
    fragmentEntryRemovalCount,
    lowerQualityEntryRemovalCount,
  };
}

export function applyPetInitialFusionExpPatchToXml(petXml: string): PetInitialFusionExpPatchResult {
  const targetByPetId = new Map<number, (typeof PET_INITIAL_FUSION_EXP_TARGETS)[number]>(
    PET_INITIAL_FUSION_EXP_TARGETS.map((target) => [target.petId, target])
  );
  const targets: PetInitialFusionExpTarget[] = [];

  const xml = petXml.replace(/<宠物>[\s\S]*?<\/宠物>/g, (record: string) => {
    const petId = numberFromTag(record, "ID");
    if (petId == null) {
      return record;
    }
    const target = targetByPetId.get(petId);
    if (!target) {
      return record;
    }

    const currentFusionExp = numberFromTag(record, "融合经验") ?? target.baseFusionExp;
    const targetFusionExp = target.baseFusionExp * PET_INITIAL_FUSION_EXP_MULTIPLIER;
    const patchedRecord = replaceTagContent(record, "融合经验", String(targetFusionExp));
    targets.push({
      petId,
      name: tagText(record, "名字") ?? `宠物 ${petId}`,
      originalFusionExp: currentFusionExp,
      targetFusionExp,
      multiplier: PET_INITIAL_FUSION_EXP_MULTIPLIER,
      changed: patchedRecord !== record,
    });
    return patchedRecord;
  });

  return { xml, targets };
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

export function getLevelRewardAchievementBoostEnabled(): boolean {
  return true;
}

function countActivityGifts(xml: string): ActivityGiftCounts {
  let giftCount = 0;
  let timedGiftCount = 0;
  let delistedGiftCount = 0;
  const giftRe = /<礼包>([\s\S]*?)<\/礼包>/g;
  let match: RegExpExecArray | null;

  while ((match = giftRe.exec(xml))) {
    const record = match[1];
    giftCount += 1;
    const start = tagText(record, "起始时间");
    const end = tagText(record, "结束时间");
    const delisted = tagText(record, "下架");
    if ((start != null && start !== "-1") || (end != null && end !== "-1")) {
      timedGiftCount += 1;
    }
    if (delisted != null && delisted !== "0") {
      delistedGiftCount += 1;
    }
  }

  return { giftCount, timedGiftCount, delistedGiftCount };
}

export function applyActivityVisibilityPatchToXml(xml: string): string {
  return xml.replace(/<礼包>[\s\S]*?<\/礼包>/g, (record: string) => {
    return record
      .replace(/<下架>[\s\S]*?<\/下架>/g, `<下架>${ACTIVITY_VISIBILITY_VISIBLE_FLAG}</下架>`)
      .replace(
        /<起始时间>(?!-1<\/起始时间>)[\s\S]*?<\/起始时间>/g,
        `<起始时间>${ACTIVITY_VISIBILITY_START_TIME}</起始时间>`
      )
      .replace(
        /<结束时间>(?!-1<\/结束时间>)[\s\S]*?<\/结束时间>/g,
        `<结束时间>${ACTIVITY_VISIBILITY_END_TIME}</结束时间>`
      );
  });
}

export function getActivityVisibilityState(): ActivityVisibilityState {
  if (!existsSync(DATA_XML_SWF)) {
    return {
      ok: true,
      loaded: false,
      sourceFile: DATA_XML_SWF,
      assetName: LEVEL_REWARD_ASSET_NAME,
      patchedAssetFile: null,
      patchedAssetReady: false,
      allActivitiesVisible: false,
      giftCount: 0,
      timedGiftCount: 0,
      delistedGiftCount: 0,
      patchedTimedGiftCount: 0,
      patchedDelistedGiftCount: 0,
      startTime: ACTIVITY_VISIBILITY_START_TIME,
      endTime: ACTIVITY_VISIBILITY_END_TIME,
    };
  }

  try {
    const xml = readDefineBinaryText(DATA_XML_SWF, ACTIVITY_GIFT_BINARY_ID);
    const sourceCounts = countActivityGifts(xml);
    const patchedCounts = countActivityGifts(applyActivityVisibilityPatchToXml(xml));
    const patchedAssetFile = ensurePatchedLevelRewardAsset(DATA_XML_SWF);
    const patchedAssetReady = patchedAssetFile != null && existsSync(patchedAssetFile);
    return {
      ok: true,
      loaded: patchedAssetReady,
      sourceFile: DATA_XML_SWF,
      assetName: LEVEL_REWARD_ASSET_NAME,
      patchedAssetFile,
      patchedAssetReady,
      allActivitiesVisible: patchedAssetReady,
      giftCount: sourceCounts.giftCount,
      timedGiftCount: sourceCounts.timedGiftCount,
      delistedGiftCount: sourceCounts.delistedGiftCount,
      patchedTimedGiftCount: patchedCounts.timedGiftCount,
      patchedDelistedGiftCount: patchedCounts.delistedGiftCount,
      startTime: ACTIVITY_VISIBILITY_START_TIME,
      endTime: ACTIVITY_VISIBILITY_END_TIME,
    };
  } catch (error) {
    return {
      ok: true,
      loaded: false,
      sourceFile: DATA_XML_SWF,
      assetName: LEVEL_REWARD_ASSET_NAME,
      patchedAssetFile: null,
      patchedAssetReady: false,
      allActivitiesVisible: false,
      giftCount: 0,
      timedGiftCount: 0,
      delistedGiftCount: 0,
      patchedTimedGiftCount: 0,
      patchedDelistedGiftCount: 0,
      startTime: ACTIVITY_VISIBILITY_START_TIME,
      endTime: ACTIVITY_VISIBILITY_END_TIME,
      error: error instanceof Error ? error.message : String(error),
    };
  }
}

export function getEquipmentStrengtheningOptimizationState(): EquipmentStrengtheningOptimizationState {
  if (!existsSync(DATA_XML_SWF)) {
    return {
      ok: true,
      loaded: false,
      sourceFile: DATA_XML_SWF,
      assetName: LEVEL_REWARD_ASSET_NAME,
      patchedAssetFile: null,
      patchedAssetReady: false,
      equipmentStrengtheningOptimized: false,
      oneClickMaxLevel: true,
      perfectLevelMaxed: true,
      successProbability: EQUIPMENT_STRENGTHEN_SUCCESS_PROBABILITY,
      recordCount: 0,
      probabilityRecordCount: 0,
      probabilityEntryCount: 0,
      patchedProbabilityEntryCount: 0,
    };
  }

  try {
    const strengtheningXml = readDefineBinaryText(DATA_XML_SWF, STRENGTHEN_BINARY_ID);
    const patched = applyEquipmentStrengtheningSuccessPatchToXml(strengtheningXml);
    const patchedAssetFile = ensurePatchedLevelRewardAsset(DATA_XML_SWF);
    const patchedAssetReady = patchedAssetFile != null && existsSync(patchedAssetFile);
    const targetsValid =
      patched.targets.length > 0 &&
      patched.targets.every((target) => {
        return (
          target.patchedProbabilities.length > 0 &&
          target.patchedProbabilities.every((value) => value === EQUIPMENT_STRENGTHEN_SUCCESS_PROBABILITY)
        );
      });

    return {
      ok: true,
      loaded: patchedAssetReady && targetsValid,
      sourceFile: DATA_XML_SWF,
      assetName: LEVEL_REWARD_ASSET_NAME,
      patchedAssetFile,
      patchedAssetReady,
      equipmentStrengtheningOptimized: patchedAssetReady && targetsValid,
      oneClickMaxLevel: true,
      perfectLevelMaxed: true,
      successProbability: EQUIPMENT_STRENGTHEN_SUCCESS_PROBABILITY,
      recordCount: patched.recordCount,
      probabilityRecordCount: patched.targets.length,
      probabilityEntryCount: patched.probabilityEntryCount,
      patchedProbabilityEntryCount: patched.targets.reduce(
        (total, target) =>
          total +
          target.patchedProbabilities.filter((value) => value === EQUIPMENT_STRENGTHEN_SUCCESS_PROBABILITY).length,
        0
      ),
    };
  } catch (error) {
    return {
      ok: true,
      loaded: false,
      sourceFile: DATA_XML_SWF,
      assetName: LEVEL_REWARD_ASSET_NAME,
      patchedAssetFile: null,
      patchedAssetReady: false,
      equipmentStrengtheningOptimized: false,
      oneClickMaxLevel: true,
      perfectLevelMaxed: true,
      successProbability: EQUIPMENT_STRENGTHEN_SUCCESS_PROBABILITY,
      recordCount: 0,
      probabilityRecordCount: 0,
      probabilityEntryCount: 0,
      patchedProbabilityEntryCount: 0,
      error: error instanceof Error ? error.message : String(error),
    };
  }
}

export function getPetSkillOptimizationState(): PetSkillOptimizationState {
  if (!existsSync(DATA_XML_SWF)) {
    return {
      ok: true,
      loaded: false,
      sourceFile: DATA_XML_SWF,
      assetName: LEVEL_REWARD_ASSET_NAME,
      patchedAssetFile: null,
      patchedAssetReady: false,
      petSkillOptimized: false,
      initialExpMultiplier: PET_SKILL_INITIAL_EXP_MULTIPLIER,
      learningProbabilityTotal: PET_SKILL_LEARNING_PROBABILITY_TOTAL,
      nextLevelUnlockProbability: PET_SKILL_NEXT_LEVEL_UNLOCK_PROBABILITY,
      learningPoolCount: 0,
      optimizedPoolCount: 0,
      nextLevelUnlockRecordCount: 0,
      affectedSkillCount: 0,
      fragmentEntryRemovalCount: 0,
      lowerQualityEntryRemovalCount: 0,
      expTargetCount: 0,
    };
  }

  try {
    const skillShowXml = readDefineBinaryText(DATA_XML_SWF, PET_SKILL_SHOW_BINARY_ID);
    const skillLearningXml = readDefineBinaryText(DATA_XML_SWF, PET_SKILL_LEARNING_BINARY_ID);
    const patched = applyPetSkillLearningOptimizationToXml(skillLearningXml, skillShowXml);
    const patchedAssetFile = ensurePatchedLevelRewardAsset(DATA_XML_SWF);
    const patchedAssetReady = patchedAssetFile != null && existsSync(patchedAssetFile);
    const poolsValid =
      patched.targets.length > 0 &&
      patched.targets.every((target) => {
        const probabilityTotal = target.patchedEntries.reduce((total, entry) => total + entry.probability, 0);
        return (
          target.patchedEntries.length > 0 &&
          probabilityTotal === PET_SKILL_LEARNING_PROBABILITY_TOTAL &&
          target.patchedNextLevelProbability === PET_SKILL_NEXT_LEVEL_UNLOCK_PROBABILITY &&
          target.patchedEntries.every((entry) => !entry.fragment && entry.quality === target.highestQuality)
        );
      });
    const expTargetsValid =
      patched.expTargets.length === patched.affectedSkillIds.length &&
      patched.expTargets.every((target) => target.targetInitialExp === petSkillTargetInitialExp(target));

    return {
      ok: true,
      loaded: patchedAssetReady && poolsValid && expTargetsValid,
      sourceFile: DATA_XML_SWF,
      assetName: LEVEL_REWARD_ASSET_NAME,
      patchedAssetFile,
      patchedAssetReady,
      petSkillOptimized: patchedAssetReady && poolsValid && expTargetsValid,
      initialExpMultiplier: PET_SKILL_INITIAL_EXP_MULTIPLIER,
      learningProbabilityTotal: PET_SKILL_LEARNING_PROBABILITY_TOTAL,
      nextLevelUnlockProbability: PET_SKILL_NEXT_LEVEL_UNLOCK_PROBABILITY,
      learningPoolCount: patched.learningPoolCount,
      optimizedPoolCount: patched.targets.length,
      nextLevelUnlockRecordCount: patched.nextLevelUnlockRecordCount,
      affectedSkillCount: patched.affectedSkillIds.length,
      fragmentEntryRemovalCount: patched.fragmentEntryRemovalCount,
      lowerQualityEntryRemovalCount: patched.lowerQualityEntryRemovalCount,
      expTargetCount: patched.expTargets.length,
    };
  } catch (error) {
    return {
      ok: true,
      loaded: false,
      sourceFile: DATA_XML_SWF,
      assetName: LEVEL_REWARD_ASSET_NAME,
      patchedAssetFile: null,
      patchedAssetReady: false,
      petSkillOptimized: false,
      initialExpMultiplier: PET_SKILL_INITIAL_EXP_MULTIPLIER,
      learningProbabilityTotal: PET_SKILL_LEARNING_PROBABILITY_TOTAL,
      nextLevelUnlockProbability: PET_SKILL_NEXT_LEVEL_UNLOCK_PROBABILITY,
      learningPoolCount: 0,
      optimizedPoolCount: 0,
      nextLevelUnlockRecordCount: 0,
      affectedSkillCount: 0,
      fragmentEntryRemovalCount: 0,
      lowerQualityEntryRemovalCount: 0,
      expTargetCount: 0,
      error: error instanceof Error ? error.message : String(error),
    };
  }
}

export function getAdvancedPetEggOptimizationState(): AdvancedPetEggOptimizationState {
  if (!existsSync(DATA_XML_SWF)) {
    return {
      ok: true,
      loaded: false,
      sourceFile: DATA_XML_SWF,
      assetName: LEVEL_REWARD_ASSET_NAME,
      patchedAssetFile: null,
      patchedAssetReady: false,
      advancedPetEggOptimized: false,
      goodsIds: [...ADVANCED_PET_EGG_GOODS_IDS],
      minAptitude: ADVANCED_PET_EGG_MIN_APTITUDE,
      addedPetId: ADVANCED_PET_EGG_DARK_PET_ID,
      probabilityTotal: PET_EGG_PROBABILITY_TOTAL,
      targets: [],
    };
  }

  try {
    const goodsXml = readDefineBinaryText(DATA_XML_SWF, GOODS_BINARY_ID);
    const petXml = readDefineBinaryText(DATA_XML_SWF, PET_BINARY_ID);
    const patched = applyAdvancedPetEggPatchToXml(goodsXml, petXml);
    const patchedAssetFile = ensurePatchedLevelRewardAsset(DATA_XML_SWF);
    const patchedAssetReady = patchedAssetFile != null && existsSync(patchedAssetFile);
    const targetGoodsIds = new Set<number>(patched.targets.map((target) => target.goodsId));
    const hasAllTargets = ADVANCED_PET_EGG_GOODS_IDS.every((goodsId) => targetGoodsIds.has(goodsId));
    const targetsValid = patched.targets.every((target) => {
      return (
        target.patchedPetIds.includes(ADVANCED_PET_EGG_DARK_PET_ID) &&
        target.patchedProbabilities.reduce((total, value) => total + value, 0) === PET_EGG_PROBABILITY_TOTAL
      );
    });

    return {
      ok: true,
      loaded: patchedAssetReady && hasAllTargets && targetsValid,
      sourceFile: DATA_XML_SWF,
      assetName: LEVEL_REWARD_ASSET_NAME,
      patchedAssetFile,
      patchedAssetReady,
      advancedPetEggOptimized: patchedAssetReady && hasAllTargets && targetsValid,
      goodsIds: [...ADVANCED_PET_EGG_GOODS_IDS],
      minAptitude: ADVANCED_PET_EGG_MIN_APTITUDE,
      addedPetId: ADVANCED_PET_EGG_DARK_PET_ID,
      probabilityTotal: PET_EGG_PROBABILITY_TOTAL,
      targets: patched.targets,
    };
  } catch (error) {
    return {
      ok: true,
      loaded: false,
      sourceFile: DATA_XML_SWF,
      assetName: LEVEL_REWARD_ASSET_NAME,
      patchedAssetFile: null,
      patchedAssetReady: false,
      advancedPetEggOptimized: false,
      goodsIds: [...ADVANCED_PET_EGG_GOODS_IDS],
      minAptitude: ADVANCED_PET_EGG_MIN_APTITUDE,
      addedPetId: ADVANCED_PET_EGG_DARK_PET_ID,
      probabilityTotal: PET_EGG_PROBABILITY_TOTAL,
      targets: [],
      error: error instanceof Error ? error.message : String(error),
    };
  }
}

export function getPetInitialFusionExpOptimizationState(): PetInitialFusionExpOptimizationState {
  if (!existsSync(DATA_XML_SWF)) {
    return {
      ok: true,
      loaded: false,
      sourceFile: DATA_XML_SWF,
      assetName: LEVEL_REWARD_ASSET_NAME,
      patchedAssetFile: null,
      patchedAssetReady: false,
      petInitialFusionExpOptimized: false,
      multiplier: PET_INITIAL_FUSION_EXP_MULTIPLIER,
      targetPetIds: PET_INITIAL_FUSION_EXP_TARGETS.map((target) => target.petId),
      targets: [],
    };
  }

  try {
    const petXml = readDefineBinaryText(DATA_XML_SWF, PET_BINARY_ID);
    const patched = applyPetInitialFusionExpPatchToXml(petXml);
    const patchedAssetFile = ensurePatchedLevelRewardAsset(DATA_XML_SWF);
    const patchedAssetReady = patchedAssetFile != null && existsSync(patchedAssetFile);
    const targetIds = new Set<number>(patched.targets.map((target) => target.petId));
    const hasAllTargets = PET_INITIAL_FUSION_EXP_TARGETS.every((target) => targetIds.has(target.petId));
    const expectedFusionExpByPetId = new Map<number, number>(
      PET_INITIAL_FUSION_EXP_TARGETS.map((target) => [
        target.petId,
        target.baseFusionExp * PET_INITIAL_FUSION_EXP_MULTIPLIER,
      ])
    );
    const targetsValid = patched.targets.every((target) => target.targetFusionExp === expectedFusionExpByPetId.get(target.petId));

    return {
      ok: true,
      loaded: patchedAssetReady && hasAllTargets && targetsValid,
      sourceFile: DATA_XML_SWF,
      assetName: LEVEL_REWARD_ASSET_NAME,
      patchedAssetFile,
      patchedAssetReady,
      petInitialFusionExpOptimized: patchedAssetReady && hasAllTargets && targetsValid,
      multiplier: PET_INITIAL_FUSION_EXP_MULTIPLIER,
      targetPetIds: PET_INITIAL_FUSION_EXP_TARGETS.map((target) => target.petId),
      targets: patched.targets,
    };
  } catch (error) {
    return {
      ok: true,
      loaded: false,
      sourceFile: DATA_XML_SWF,
      assetName: LEVEL_REWARD_ASSET_NAME,
      patchedAssetFile: null,
      patchedAssetReady: false,
      petInitialFusionExpOptimized: false,
      multiplier: PET_INITIAL_FUSION_EXP_MULTIPLIER,
      targetPetIds: PET_INITIAL_FUSION_EXP_TARGETS.map((target) => target.petId),
      targets: [],
      error: error instanceof Error ? error.message : String(error),
    };
  }
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
  asInputObject(input);
  writeLevelRewardConfig({ achievementBoostEnabled: true });
  return getLevelRewardState();
}

export function clearLevelRewardAchievementBoost(): LevelRewardState {
  writeLevelRewardConfig({ achievementBoostEnabled: true });
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
        equipmentStrengtheningOptimizationEnabled: true,
        equipmentStrengtheningBinaryId: STRENGTHEN_BINARY_ID,
        equipmentStrengtheningOneClickMaxLevel: true,
        equipmentStrengtheningPerfectLevelMaxed: true,
        equipmentStrengtheningSuccessProbability: EQUIPMENT_STRENGTHEN_SUCCESS_PROBABILITY,
        activityVisibilityEnabled: true,
        activityGiftBinaryId: ACTIVITY_GIFT_BINARY_ID,
        activityVisibilityVisibleFlag: ACTIVITY_VISIBILITY_VISIBLE_FLAG,
        activityVisibilityStartTime: ACTIVITY_VISIBILITY_START_TIME,
        activityVisibilityEndTime: ACTIVITY_VISIBILITY_END_TIME,
        advancedPetEggOptimizationEnabled: true,
        advancedPetEggGoodsIds: ADVANCED_PET_EGG_GOODS_IDS,
        advancedPetEggDarkPetId: ADVANCED_PET_EGG_DARK_PET_ID,
        advancedPetEggMinAptitude: ADVANCED_PET_EGG_MIN_APTITUDE,
        petEggProbabilityTotal: PET_EGG_PROBABILITY_TOTAL,
        petSkillOptimizationEnabled: true,
        petSkillShowBinaryId: PET_SKILL_SHOW_BINARY_ID,
        petSkillLearningBinaryId: PET_SKILL_LEARNING_BINARY_ID,
        petSkillInitialExpMultiplier: PET_SKILL_INITIAL_EXP_MULTIPLIER,
        petSkillLearningProbabilityTotal: PET_SKILL_LEARNING_PROBABILITY_TOTAL,
        petSkillNextLevelUnlockProbability: PET_SKILL_NEXT_LEVEL_UNLOCK_PROBABILITY,
        petSkillBaseInitialExpByQuality: PET_SKILL_BASE_INITIAL_EXP_BY_QUALITY,
        petInitialFusionExpOptimizationEnabled: true,
        petInitialFusionExpMultiplier: PET_INITIAL_FUSION_EXP_MULTIPLIER,
        petInitialFusionExpTargets: PET_INITIAL_FUSION_EXP_TARGETS,
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

  const source = loadLevelRewardSource(sourceFile);
  if (!source) {
    return null;
  }

  const activityXml = readDefineBinaryText(sourceFile, ACTIVITY_GIFT_BINARY_ID);
  const strengtheningXml = readDefineBinaryText(sourceFile, STRENGTHEN_BINARY_ID);
  const skillShowXml = readDefineBinaryText(sourceFile, PET_SKILL_SHOW_BINARY_ID);
  const skillLearningXml = readDefineBinaryText(sourceFile, PET_SKILL_LEARNING_BINARY_ID);
  const goodsXml = readDefineBinaryText(sourceFile, GOODS_BINARY_ID);
  const petXml = readDefineBinaryText(sourceFile, PET_BINARY_ID);
  const patchedLevelXml = applyLevelRewardAchievementBoostToXml(source.xml, achievementBoostEnabled);
  const patchedActivityXml = applyActivityVisibilityPatchToXml(activityXml);
  const strengtheningPatch = applyEquipmentStrengtheningSuccessPatchToXml(strengtheningXml);
  const petSkillPatch = applyPetSkillLearningOptimizationToXml(skillLearningXml, skillShowXml);
  const petEggPatch = applyAdvancedPetEggPatchToXml(goodsXml, petXml);
  const petFusionExpPatch = applyPetInitialFusionExpPatchToXml(petXml);
  const activityCounts = countActivityGifts(activityXml);
  const patchedActivityCounts = countActivityGifts(patchedActivityXml);
  if (
    patchedLevelXml === source.xml &&
    patchedActivityXml === activityXml &&
    strengtheningPatch.xml === strengtheningXml &&
    petSkillPatch.learningXml === skillLearningXml &&
    petSkillPatch.skillShowXml === skillShowXml &&
    petEggPatch.xml === goodsXml &&
    petFusionExpPatch.xml === petXml
  ) {
    return sourceFile;
  }

  const outputDir = path.join(saveDataPaths.generatedAssetsRoot, "game-data-optimizations");
  const outputFile = path.join(outputDir, LEVEL_REWARD_ASSET_NAME);
  const metaFile = `${outputFile}.json`;
  const signature = patchedAssetSignature(sourceFile, achievementBoostEnabled);
  if (existsSync(outputFile) && cachedPatchMatches(metaFile, signature)) {
    return outputFile;
  }

  const swf = decodeSwf(readFileSync(sourceFile));
  if (patchedLevelXml !== source.xml) {
    const replacements = replaceDefineBinaryData(swf, LEVEL_REWARD_BINARY_ID, Buffer.from(patchedLevelXml, "utf8"));
    if (replacements !== 1) {
      throw new Error(`Expected one level reward binary replacement, found ${replacements}`);
    }
  }
  if (patchedActivityXml !== activityXml) {
    const replacements = replaceDefineBinaryData(swf, ACTIVITY_GIFT_BINARY_ID, Buffer.from(patchedActivityXml, "utf8"));
    if (replacements !== 1) {
      throw new Error(`Expected one activity gift binary replacement, found ${replacements}`);
    }
  }
  if (strengtheningPatch.xml !== strengtheningXml) {
    const replacements = replaceDefineBinaryData(swf, STRENGTHEN_BINARY_ID, Buffer.from(strengtheningPatch.xml, "utf8"));
    if (replacements !== 1) {
      throw new Error(`Expected one strengthening binary replacement, found ${replacements}`);
    }
  }
  if (petSkillPatch.skillShowXml !== skillShowXml) {
    const replacements = replaceDefineBinaryData(swf, PET_SKILL_SHOW_BINARY_ID, Buffer.from(petSkillPatch.skillShowXml, "utf8"));
    if (replacements !== 1) {
      throw new Error(`Expected one pet skill display binary replacement, found ${replacements}`);
    }
  }
  if (petSkillPatch.learningXml !== skillLearningXml) {
    const replacements = replaceDefineBinaryData(
      swf,
      PET_SKILL_LEARNING_BINARY_ID,
      Buffer.from(petSkillPatch.learningXml, "utf8")
    );
    if (replacements !== 1) {
      throw new Error(`Expected one pet skill learning binary replacement, found ${replacements}`);
    }
  }
  if (petEggPatch.xml !== goodsXml) {
    const replacements = replaceDefineBinaryData(swf, GOODS_BINARY_ID, Buffer.from(petEggPatch.xml, "utf8"));
    if (replacements !== 1) {
      throw new Error(`Expected one goods binary replacement, found ${replacements}`);
    }
  }
  if (petFusionExpPatch.xml !== petXml) {
    const replacements = replaceDefineBinaryData(swf, PET_BINARY_ID, Buffer.from(petFusionExpPatch.xml, "utf8"));
    if (replacements !== 1) {
      throw new Error(`Expected one pet binary replacement, found ${replacements}`);
    }
  }

  mkdirSync(outputDir, { recursive: true });
  const patchedSwfBytes = encodeSwf(swf);
  writeFileSync(outputFile, patchedSwfBytes);
  if (path.resolve(outputFile) !== path.resolve(sourceFile)) {
    writeFileSync(sourceFile, patchedSwfBytes);
  }
  sourceCache = null;
  clearGameDataCatalogCache();
  writeFileSync(
    metaFile,
    `${JSON.stringify(
      {
        signature,
        sourceFile,
        generatedAt: new Date().toISOString(),
        achievementBoostEnabled,
        achievementBoostValue: LEVEL_REWARD_ACHIEVEMENT_BOOST_VALUE,
        equipmentStrengtheningOptimizationEnabled: true,
        equipmentStrengtheningBinaryId: STRENGTHEN_BINARY_ID,
        equipmentStrengtheningOneClickMaxLevel: true,
        equipmentStrengtheningPerfectLevelMaxed: true,
        equipmentStrengtheningSuccessProbability: EQUIPMENT_STRENGTHEN_SUCCESS_PROBABILITY,
        equipmentStrengtheningRecordCount: strengtheningPatch.recordCount,
        equipmentStrengtheningProbabilityRecordCount: strengtheningPatch.targets.length,
        equipmentStrengtheningProbabilityEntryCount: strengtheningPatch.probabilityEntryCount,
        activityVisibilityEnabled: true,
        activityVisibilityVisibleFlag: ACTIVITY_VISIBILITY_VISIBLE_FLAG,
        activityGiftCount: activityCounts.giftCount,
        activityTimedGiftCount: activityCounts.timedGiftCount,
        activityDelistedGiftCount: activityCounts.delistedGiftCount,
        patchedActivityTimedGiftCount: patchedActivityCounts.timedGiftCount,
        patchedActivityDelistedGiftCount: patchedActivityCounts.delistedGiftCount,
        activityVisibilityStartTime: ACTIVITY_VISIBILITY_START_TIME,
        activityVisibilityEndTime: ACTIVITY_VISIBILITY_END_TIME,
        advancedPetEggOptimizationEnabled: true,
        advancedPetEggGoodsIds: ADVANCED_PET_EGG_GOODS_IDS,
        advancedPetEggDarkPetId: ADVANCED_PET_EGG_DARK_PET_ID,
        advancedPetEggMinAptitude: ADVANCED_PET_EGG_MIN_APTITUDE,
        petEggProbabilityTotal: PET_EGG_PROBABILITY_TOTAL,
        advancedPetEggTargets: petEggPatch.targets,
        petSkillOptimizationEnabled: true,
        petSkillShowBinaryId: PET_SKILL_SHOW_BINARY_ID,
        petSkillLearningBinaryId: PET_SKILL_LEARNING_BINARY_ID,
        petSkillInitialExpMultiplier: PET_SKILL_INITIAL_EXP_MULTIPLIER,
        petSkillLearningProbabilityTotal: PET_SKILL_LEARNING_PROBABILITY_TOTAL,
        petSkillNextLevelUnlockProbability: PET_SKILL_NEXT_LEVEL_UNLOCK_PROBABILITY,
        petSkillLearningPoolCount: petSkillPatch.learningPoolCount,
        petSkillOptimizedPoolCount: petSkillPatch.targets.length,
        petSkillNextLevelUnlockRecordCount: petSkillPatch.nextLevelUnlockRecordCount,
        petSkillAffectedSkillIds: petSkillPatch.affectedSkillIds,
        petSkillFragmentEntryRemovalCount: petSkillPatch.fragmentEntryRemovalCount,
        petSkillLowerQualityEntryRemovalCount: petSkillPatch.lowerQualityEntryRemovalCount,
        petSkillInitialExpTargets: petSkillPatch.expTargets,
        petInitialFusionExpOptimizationEnabled: true,
        petInitialFusionExpMultiplier: PET_INITIAL_FUSION_EXP_MULTIPLIER,
        petInitialFusionExpTargets: petFusionExpPatch.targets,
      },
      null,
      2
    )}\n`
  );
  return outputFile;
}
