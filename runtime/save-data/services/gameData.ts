import { existsSync, readFileSync, statSync } from "node:fs";
import path from "node:path";
import { deflateSync, inflateSync } from "node:zlib";
import { decodeSwf, parseTags } from "../../../src/swf/swf.js";
import { saveDataPaths } from "../server/paths.js";

export const SHOP_VALUE_RECHARGE_MULTIPLIER = 0.75;

const COUNTED_BAG_NAMES = new Set(["b1", "b2", "b3", "b4", "b5", "b9"]);
export const DATA_XML_SWF = path.join(
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

export type GameItem = {
  id: number;
  name: string;
  type: number;
  smallType: number;
  bag: number;
  stack: number;
  price: number;
  mallPrice: number;
  hasMallPrice: boolean;
  canUse: boolean;
};

export type GameDataCatalog = {
  sourceFile: string;
  loaded: boolean;
  mtimeMs?: number;
  items: GameItem[];
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

export type LocalSaveIdentity = {
  uid: string;
  username: string;
  slotIndex: number;
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

type SaveXmlParts = {
  xml: string;
  compressed: boolean;
  encoding:
    | {
        kind: "amf3-string";
      }
    | {
        kind: "raw-prefix";
        prefix: Buffer;
      };
};

let catalogCache: GameDataCatalog | null = null;

function readAmf3U29(buffer: Buffer, offset: number): { value: number; offset: number } | null {
  let value = 0;
  let cursor = offset;

  for (let index = 0; index < 3; index += 1) {
    const byte = buffer[cursor];
    if (byte == null) {
      return null;
    }
    cursor += 1;
    value = (value << 7) | (byte & 0x7f);
    if ((byte & 0x80) === 0) {
      return { value, offset: cursor };
    }
  }

  const byte = buffer[cursor];
  if (byte == null) {
    return null;
  }
  cursor += 1;
  value = (value << 8) | byte;
  return { value, offset: cursor };
}

function encodeAmf3U29(value: number): Buffer {
  if (!Number.isSafeInteger(value) || value < 0 || value > 0x1fffffff) {
    throw new RangeError(`AMF3 U29 value out of range: ${value}`);
  }

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

function decodeAmf3SaveXml(buffer: Buffer): string | null {
  if (buffer[0] !== 0x06) {
    return null;
  }

  const header = readAmf3U29(buffer, 1);
  if (!header || (header.value & 1) === 0) {
    return null;
  }

  const declaredLength = Math.floor(header.value / 2);
  const declaredEnd = header.offset + declaredLength;
  const declaredXml =
    declaredEnd <= buffer.length ? buffer.subarray(header.offset, declaredEnd).toString("utf8") : "";
  if (declaredXml.startsWith("<saveXml") && declaredXml.trimEnd().endsWith("</saveXml>")) {
    return declaredXml;
  }

  const remainingXml = buffer.subarray(header.offset).toString("utf8");
  return remainingXml.startsWith("<saveXml") ? remainingXml : null;
}

function encodeAmf3SaveXml(xml: string): Buffer {
  const xmlBytes = Buffer.from(xml, "utf8");
  const header = encodeAmf3U29(xmlBytes.length * 2 + 1);
  return Buffer.concat([Buffer.from([0x06]), header, xmlBytes]);
}

function decodeSaveXmlParts(rawData: string): SaveXmlParts | null {
  const trimmed = rawData.trim();
  if (trimmed.includes("<saveXml")) {
    const start = trimmed.indexOf("<saveXml");
    return {
      xml: trimmed.slice(start),
      compressed: false,
      encoding: {
        kind: "raw-prefix",
        prefix: Buffer.from(trimmed.slice(0, start), "utf8"),
      },
    };
  }

  try {
    const inflated = inflateSync(Buffer.from(trimmed, "base64"));
    const amf3Xml = decodeAmf3SaveXml(inflated);
    if (amf3Xml) {
      return {
        xml: amf3Xml,
        compressed: true,
        encoding: {
          kind: "amf3-string",
        },
      };
    }

    const start = inflated.indexOf(Buffer.from("<saveXml", "utf8"));
    return start >= 0
      ? {
          xml: inflated.subarray(start).toString("utf8"),
          compressed: true,
          encoding: {
            kind: "raw-prefix",
            prefix: inflated.subarray(0, start),
          },
        }
      : null;
  } catch {
    return null;
  }
}

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

export function readDefineBinaryText(swfFile: string, binaryId: number): string {
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

function parseGameItems(xml: string): GameItem[] {
  const items: GameItem[] = [];
  const recordRe = /<物品>([\s\S]*?)<\/物品>/g;
  let match: RegExpExecArray | null;

  while ((match = recordRe.exec(xml))) {
    const record = match[1];
    const id = numberFromText(tagText(record, "id"));
    if (id == null) {
      continue;
    }

    const mallPriceText = tagText(record, "商城价格") ?? "";
    const mallPrice = numberFromText(mallPriceText);
    items.push({
      id,
      name: tagText(record, "名称") ?? "",
      type: numberFromText(tagText(record, "类型")) ?? -1,
      smallType: numberFromText(tagText(record, "小类型")) ?? -1,
      bag: numberFromText(tagText(record, "背包")) ?? -1,
      stack: numberFromText(tagText(record, "叠加数")) ?? -1,
      price: numberFromText(tagText(record, "价格")) ?? -1,
      mallPrice: mallPrice ?? -1,
      hasMallPrice: mallPriceText !== "" && mallPrice != null,
      canUse: tagText(record, "是否使用") === "true",
    });
  }

  return items.sort((left, right) => left.id - right.id);
}

export function loadGameDataCatalog(): GameDataCatalog {
  if (catalogCache) {
    return catalogCache;
  }

  if (!existsSync(DATA_XML_SWF)) {
    catalogCache = {
      sourceFile: DATA_XML_SWF,
      loaded: false,
      items: [],
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
    items: parseGameItems(goodsXml),
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
  return decodeSaveXmlParts(rawData)?.xml ?? null;
}

function replaceNumberField(xml: string, name: string, value: number): string {
  const field = `<s type="Number" name="${name}">${value}</s>`;
  const fieldRe = new RegExp(`<s type="Number" name="${name}">[^<]*</s>`);
  return fieldRe.test(xml) ? xml.replace(fieldRe, field) : xml;
}

function replaceStringField(xml: string, name: string, value: string): string {
  const field = `<s type="String" name="${name}">${escapeSaveXmlText(value)}</s>`;
  const fieldRe = new RegExp(`<s type="String" name="${name}">[\\s\\S]*?</s>`);
  return fieldRe.test(xml) ? xml.replace(fieldRe, field) : xml;
}

function escapeSaveXmlText(value: string): string {
  return value.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;");
}

function findNamedSaveElement(xml: string, name: string): { start: number; end: number; innerStart: number; innerEnd: number } | null {
  const tagRe = /<\/?s\b[^>]*>/g;
  const stack: Array<{ name: string; start: number; innerStart: number }> = [];
  let match: RegExpExecArray | null;

  while ((match = tagRe.exec(xml))) {
    const tag = match[0];
    if (tag.startsWith("</")) {
      const closed = stack.pop();
      if (closed?.name === name) {
        return {
          start: closed.start,
          end: match.index + tag.length,
          innerStart: closed.innerStart,
          innerEnd: match.index,
        };
      }
      continue;
    }

    const attrs = parseSaveTagAttributes(tag);
    if (!attrs) {
      continue;
    }
    if (attrs.name === name && tag.endsWith("/>")) {
      return {
        start: match.index,
        end: match.index + tag.length,
        innerStart: match.index + tag.length,
        innerEnd: match.index + tag.length,
      };
    }
    if (!tag.endsWith("/>")) {
      stack.push({ name: attrs.name, start: match.index, innerStart: match.index + tag.length });
    }
  }

  return null;
}

function removeLocalIdentityFlags(xml: string): string {
  const fa = findNamedSaveElement(xml, "fa");
  if (!fa || fa.innerStart === fa.innerEnd) {
    return xml;
  }

  const objectRe =
    /<s type="Object" name="null">(?:\s*<s type="Number" name="(?:cd|cm|cf|cv)">[^<]*<\/s>)+\s*<\/s>/g;
  const inner = xml.slice(fa.innerStart, fa.innerEnd);
  const filtered = inner.replace(objectRe, (objectXml) => {
    const flag = Number(/<s type="Number" name="cf">([^<]*)<\/s>/.exec(objectXml)?.[1] ?? NaN);
    return flag === 1 || flag === 2 ? "" : objectXml;
  });
  return filtered === inner ? xml : `${xml.slice(0, fa.innerStart)}${filtered}${xml.slice(fa.innerEnd)}`;
}

export function canonicalizeLocalSaveIdentity(rawData: string, identity: LocalSaveIdentity): string {
  const decoded = decodeSaveXmlParts(rawData);
  const uidNumber = Number(identity.uid);
  if (!decoded || !Number.isSafeInteger(uidNumber)) {
    return rawData;
  }

  const expectedIdAndIndex = uidNumber * (identity.slotIndex + 1);
  if (!Number.isSafeInteger(expectedIdAndIndex)) {
    return rawData;
  }

  let xml = decoded.xml;
  xml = replaceNumberField(xml, "jxid", uidNumber);
  xml = replaceNumberField(xml, "sidx", identity.slotIndex);
  xml = replaceStringField(xml, "idn", identity.username);
  xml = replaceNumberField(xml, "idai", expectedIdAndIndex);
  xml = removeLocalIdentityFlags(xml);

  if (xml === decoded.xml) {
    return rawData;
  }
  if (!decoded.compressed) {
    const prefix = decoded.encoding.kind === "raw-prefix" ? decoded.encoding.prefix : Buffer.alloc(0);
    return Buffer.concat([prefix, Buffer.from(xml, "utf8")]).toString("utf8");
  }

  const payload =
    decoded.encoding.kind === "amf3-string"
      ? encodeAmf3SaveXml(xml)
      : Buffer.concat([decoded.encoding.prefix, Buffer.from(xml, "utf8")]);
  return deflateSync(payload).toString("base64");
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
