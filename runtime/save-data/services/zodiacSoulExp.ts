import { existsSync, readFileSync } from "node:fs";
import path from "node:path";
import { decodeSwf } from "../../../src/swf/swf.js";
import {
  inspectZodiacSoulExpOptimization,
  ZODIAC_SOUL_TARGET_LEVEL,
  ZODIAC_SOUL_TARGET_UP_LIMIT,
} from "../../../src/swf/zodiacSoulExpPatch.js";
import { saveDataPaths } from "../server/paths.js";

export type ZodiacSoulExpOptimizationState = {
  ok: true;
  loaded: boolean;
  sourceFile: string;
  patchedSwfFile: string;
  patchedSwfReady: boolean;
  targetFound: boolean;
  zodiacSoulExpOptimized: boolean;
  targetLevel: number;
  targetUpLimit: number;
  error?: string;
};

const INNER_GAME_SWF_NAME = "L4399Main_gamefile.swf";

export function getZodiacSoulExpOptimizationState(): ZodiacSoulExpOptimizationState {
  const sourceFile = path.join(saveDataPaths.extractedSwf, INNER_GAME_SWF_NAME);
  const patchedSwfFile = path.join(saveDataPaths.runtimePublicRoot, "swf", INNER_GAME_SWF_NAME);

  if (!existsSync(sourceFile)) {
    return {
      ok: true,
      loaded: false,
      sourceFile,
      patchedSwfFile,
      patchedSwfReady: false,
      targetFound: false,
      zodiacSoulExpOptimized: false,
      targetLevel: ZODIAC_SOUL_TARGET_LEVEL,
      targetUpLimit: ZODIAC_SOUL_TARGET_UP_LIMIT,
    };
  }

  try {
    const sourceInspection = inspectZodiacSoulExpOptimization(decodeSwf(readFileSync(sourceFile)));
    const patchedSwfReady = existsSync(patchedSwfFile);
    const patchedInspection = patchedSwfReady
      ? inspectZodiacSoulExpOptimization(decodeSwf(readFileSync(patchedSwfFile)))
      : { targetFound: false, optimized: false };
    const optimized = patchedInspection.targetFound && patchedInspection.optimized;

    return {
      ok: true,
      loaded: sourceInspection.targetFound && optimized,
      sourceFile,
      patchedSwfFile,
      patchedSwfReady,
      targetFound: sourceInspection.targetFound || patchedInspection.targetFound,
      zodiacSoulExpOptimized: sourceInspection.targetFound && optimized,
      targetLevel: ZODIAC_SOUL_TARGET_LEVEL,
      targetUpLimit: ZODIAC_SOUL_TARGET_UP_LIMIT,
    };
  } catch (error) {
    return {
      ok: true,
      loaded: false,
      sourceFile,
      patchedSwfFile,
      patchedSwfReady: existsSync(patchedSwfFile),
      targetFound: false,
      zodiacSoulExpOptimized: false,
      targetLevel: ZODIAC_SOUL_TARGET_LEVEL,
      targetUpLimit: ZODIAC_SOUL_TARGET_UP_LIMIT,
      error: error instanceof Error ? error.message : String(error),
    };
  }
}
