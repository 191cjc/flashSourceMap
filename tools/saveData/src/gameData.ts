import { existsSync, readFileSync, statSync } from "node:fs";
import path from "node:path";
import { inflateSync } from "node:zlib";
import { decodeSwf, parseTags } from "../../../src/swf/swf.js";
import { saveDataPaths } from "./paths.js";

export const SHOP_VALUE_RECHARGE_MULTIPLIER = 0.75;

const COUNTED_BAG_NAMES = new Set(["b1", "b2", "b3", "b4", "b5", "b9"]);
const DATA_XML_SWF = path.join(
  saveDataPaths.remoteAssetsRoot,
  "sbai.4399.com",
  "4399swf",
  "upload_swf",
  "ftp10",
  "honghao",
  "20130530",
  "27",
  "dataxmlvav447.swf"
);

export type ShopProduct = {
  goodsId: number;
  platformId: number;
  showPrice: number;
  realPrice: number;
  priceFlag: number;
  job: number;
};

export type GameDataCatalog = {
  sourceFile: string;
  loaded: boolean;
  mtimeMs?: number;
  productsByPlatformId: Map<number, ShopProduct[]>;
  goodsShopPriceById: Map<number, number>;
};

export type ProductShopValueEstimate = {
  productKnown: boolean;
  candidates: ShopProduct[];
  perItemShopValue: number;
  addedShopValue: number;
  unknownGoodsIds: number[];
};

export type SaveShopValueEstimate = {
  decoded: boolean;
  shopValue: number;
  gridCount: number;
  stackCount: number;
  unpricedGoodsIds: number[];
  error?: string;
};

export type SlotShopValueEstimate = SaveShopValueEstimate & {
  slotIndex: number;
};

export type AccountShopValueEstimate = {
  shopValue: number;
  requiredTotalRecharge: number;
  slots: SlotShopValueEstimate[];
};

type SaveXmlContext = {
  name: string;
  type: string;
  textStart: number;
  childCount: number;
  grid?: {
    bagName: string;
    goodsId?: number;
    count?: number;
  };
};

let catalogCache: GameDataCatalog | null = null;

function numberFromText(value: string | null): number | null {
  if (value == null || value.trim() === "") {
    return null;
  }
  const numberValue = Number(value.trim());
  return Number.isFinite(numberValue) ? numberValue : null;
}

function tagText(record: string, tagName: string): string | null {
  const match = new RegExp(`<${tagName}>([\\s\\S]*?)</${tagName}>`).exec(record);
  return match ? match[1].trim() : null;
}

function readDefineBinaryText(swfFile: string, binaryId: number): string {
  const swf = decodeSwf(readFileSync(swfFile));
  for (const tag of parseTags(swf.body)) {
    if (tag.code === 87 && tag.data.length >= 6 && tag.data.readUInt16LE(0) === binaryId) {
      return tag.data.subarray(6).toString("utf8");
    }
  }
  throw new Error(`DefineBinaryData ${binaryId} not found in ${swfFile}`);
}

function parseShopProducts(xml: string): Map<number, ShopProduct[]> {
  const productsByPlatformId = new Map<number, ShopProduct[]>();
  const recordRe = /<商城>([\s\S]*?)<\/商城>/g;
  let match: RegExpExecArray | null;

  while ((match = recordRe.exec(xml))) {
    const record = match[1];
    const goodsId = numberFromText(tagText(record, "商城ID"));
    const platformId = numberFromText(tagText(record, "平台随机ID"));
    const showPrice = numberFromText(tagText(record, "显示价格"));
    const realPrice = numberFromText(tagText(record, "真实价格"));

    if (goodsId == null || platformId == null || showPrice == null || realPrice == null) {
      continue;
    }

    const product: ShopProduct = {
      goodsId,
      platformId,
      showPrice,
      realPrice,
      priceFlag: numberFromText(tagText(record, "标识")) ?? 0,
      job: numberFromText(tagText(record, "职业")) ?? -1,
    };
    const list = productsByPlatformId.get(platformId) ?? [];
    list.push(product);
    productsByPlatformId.set(platformId, list);
  }

  return productsByPlatformId;
}

function parseGoodsShopPrices(xml: string): Map<number, number> {
  const prices = new Map<number, number>();
  const recordRe = /<物品>([\s\S]*?)<\/物品>/g;
  let match: RegExpExecArray | null;

  while ((match = recordRe.exec(xml))) {
    const record = match[1];
    const id = numberFromText(tagText(record, "id"));
    const shopPrice = numberFromText(tagText(record, "商城价格"));
    if (id != null && shopPrice != null) {
      prices.set(id, shopPrice);
    }
  }

  return prices;
}

export function loadGameDataCatalog(): GameDataCatalog {
  if (catalogCache) {
    return catalogCache;
  }

  if (!existsSync(DATA_XML_SWF)) {
    catalogCache = {
      sourceFile: DATA_XML_SWF,
      loaded: false,
      productsByPlatformId: new Map(),
      goodsShopPriceById: new Map(),
    };
    return catalogCache;
  }

  const stat = statSync(DATA_XML_SWF);
  const goodsXml = readDefineBinaryText(DATA_XML_SWF, 15);
  const shopXml = readDefineBinaryText(DATA_XML_SWF, 36);
  catalogCache = {
    sourceFile: DATA_XML_SWF,
    loaded: true,
    mtimeMs: stat.mtimeMs,
    productsByPlatformId: parseShopProducts(shopXml),
    goodsShopPriceById: parseGoodsShopPrices(goodsXml),
  };
  return catalogCache;
}

export function clearGameDataCatalogCache(): void {
  catalogCache = null;
}

export function antiCheatRequiredRecharge(shopValue: number): number {
  if (!Number.isFinite(shopValue) || shopValue <= 0) {
    return 0;
  }
  return Math.ceil(shopValue * SHOP_VALUE_RECHARGE_MULTIPLIER);
}

export function estimateProductShopValue(
  catalog: GameDataCatalog,
  platformId: number,
  count: number
): ProductShopValueEstimate {
  const candidates = catalog.productsByPlatformId.get(platformId) ?? [];
  if (candidates.length === 0) {
    return {
      productKnown: false,
      candidates,
      perItemShopValue: 0,
      addedShopValue: 0,
      unknownGoodsIds: [],
    };
  }

  let perItemShopValue = 0;
  const unknownGoodsIds: number[] = [];
  for (const candidate of candidates) {
    const goodsPrice = catalog.goodsShopPriceById.get(candidate.goodsId);
    if (goodsPrice == null) {
      unknownGoodsIds.push(candidate.goodsId);
      continue;
    }
    if (goodsPrice >= 0) {
      perItemShopValue = Math.max(perItemShopValue, goodsPrice);
    }
  }

  return {
    productKnown: true,
    candidates,
    perItemShopValue,
    addedShopValue: perItemShopValue * count,
    unknownGoodsIds,
  };
}

export function decodeSaveXml(rawData: string): string | null {
  const trimmed = rawData.trim();
  if (trimmed.includes("<saveXml")) {
    return trimmed.slice(trimmed.indexOf("<saveXml"));
  }

  try {
    const inflated = inflateSync(Buffer.from(trimmed, "base64")).toString("utf8");
    const start = inflated.indexOf("<saveXml");
    return start >= 0 ? inflated.slice(start) : null;
  } catch {
    return null;
  }
}

function parseSaveTagAttributes(tag: string): { name: string; type: string } | null {
  const name = /\bname="([^"]*)"/.exec(tag)?.[1];
  const type = /\btype="([^"]*)"/.exec(tag)?.[1];
  return name != null && type != null ? { name, type } : null;
}

function isGridContext(stack: SaveXmlContext[], type: string): string | null {
  if (type !== "Object" || stack.length < 4) {
    return null;
  }

  const parent = stack[stack.length - 1];
  const bag = stack[stack.length - 2];
  const bagRoot = stack[stack.length - 3];
  if (parent?.name !== "bg" || bagRoot?.name !== "jxbag" || !COUNTED_BAG_NAMES.has(bag?.name)) {
    return null;
  }
  return bag.name;
}

function toSafePositiveNumber(value: string): number | null {
  const parsed = Number(value);
  return Number.isFinite(parsed) && parsed > 0 ? parsed : null;
}

export function estimateSaveShopValue(rawData: string, catalog: GameDataCatalog = loadGameDataCatalog()): SaveShopValueEstimate {
  const xml = decodeSaveXml(rawData);
  if (!xml) {
    return {
      decoded: false,
      shopValue: 0,
      gridCount: 0,
      stackCount: 0,
      unpricedGoodsIds: [],
      error: "save_xml_decode_failed",
    };
  }

  const stack: SaveXmlContext[] = [];
  const unpricedGoodsIds = new Set<number>();
  const tagRe = /<\/?s\b[^>]*>/g;
  let shopValue = 0;
  let gridCount = 0;
  let stackCount = 0;
  let match: RegExpExecArray | null;

  while ((match = tagRe.exec(xml))) {
    const tag = match[0];
    const isClosing = tag.startsWith("</");
    if (!isClosing) {
      const attrs = parseSaveTagAttributes(tag);
      if (!attrs) {
        continue;
      }

      if (stack.length > 0) {
        stack[stack.length - 1].childCount += 1;
      }

      const bagName = isGridContext(stack, attrs.type);
      if (tag.endsWith("/>")) {
        continue;
      }

      stack.push({
        name: attrs.name,
        type: attrs.type,
        textStart: match.index + tag.length,
        childCount: 0,
        grid: bagName ? { bagName } : undefined,
      });
      continue;
    }

    const closed = stack.pop();
    if (!closed) {
      continue;
    }

    const parent = stack[stack.length - 1];
    const grandparent = stack[stack.length - 2];
    const text = closed.childCount === 0 ? xml.slice(closed.textStart, match.index).trim() : "";

    if (closed.name === "gn" && closed.type === "Number" && parent?.grid) {
      parent.grid.count = toSafePositiveNumber(text) ?? 0;
    } else if (
      closed.name === "id" &&
      closed.type === "Number" &&
      parent?.name === "gs" &&
      parent.type === "Object" &&
      grandparent?.grid
    ) {
      grandparent.grid.goodsId = toSafePositiveNumber(text) ?? undefined;
    }

    if (closed.grid) {
      gridCount += 1;
      const goodsId = closed.grid.goodsId;
      const count = closed.grid.count ?? 0;
      if (goodsId != null && count > 0) {
        stackCount += count;
        const goodsPrice = catalog.goodsShopPriceById.get(goodsId);
        if (goodsPrice == null) {
          unpricedGoodsIds.add(goodsId);
        } else if (goodsPrice >= 0) {
          shopValue += goodsPrice * count;
        }
      }
    }
  }

  return {
    decoded: true,
    shopValue,
    gridCount,
    stackCount,
    unpricedGoodsIds: [...unpricedGoodsIds].sort((a, b) => a - b),
  };
}

export function estimateAccountShopValue(
  slots: Array<{ index: number; data?: unknown }>,
  catalog: GameDataCatalog = loadGameDataCatalog()
): AccountShopValueEstimate {
  const slotEstimates: SlotShopValueEstimate[] = [];
  let maxShopValue = 0;

  for (const slot of slots) {
    if (typeof slot.data !== "string") {
      continue;
    }
    const estimate = estimateSaveShopValue(slot.data, catalog);
    const slotEstimate = { slotIndex: slot.index, ...estimate };
    slotEstimates.push(slotEstimate);
    if (estimate.decoded) {
      maxShopValue = Math.max(maxShopValue, estimate.shopValue);
    }
  }

  return {
    shopValue: maxShopValue,
    requiredTotalRecharge: antiCheatRequiredRecharge(maxShopValue),
    slots: slotEstimates,
  };
}
