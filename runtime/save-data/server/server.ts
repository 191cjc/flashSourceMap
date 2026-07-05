import { createServer, type IncomingMessage, type ServerResponse } from "node:http";
import type { AddressInfo } from "node:net";
import {
  copyFileSync,
  createReadStream,
  existsSync,
  mkdirSync,
  readdirSync,
  readFileSync,
  statSync,
  writeFileSync,
} from "node:fs";
import { cp, readFile, writeFile } from "node:fs/promises";
import path from "node:path";
import { fileURLToPath } from "node:url";
import { createGzip } from "node:zlib";
import { aliasSwfFontName } from "../../../src/swf/fontAlias.js";
import { patchRuffleEventCompatibility } from "../../../src/swf/payEventPatch.js";
import { decodeSwf, encodeSwf, replaceDefineBinaryData } from "../../../src/swf/swf.js";
import { LocalSaveDatabase } from "../persistence/db.js";
import { LegacyJsonSaveDatabase } from "../persistence/legacyJsonDb.js";
import type { SaveDataStore } from "../persistence/store.js";
import { SaveDataLogger } from "./logger.js";
import { MockShopError, SaveDataMockApi } from "../platform4399/mockApi.js";
import { saveDataPaths } from "./paths.js";
import {
  clearLevelRewardAchievementBoost,
  ensurePatchedLevelRewardAsset,
  getLevelRewardState,
  LEVEL_REWARD_ASSET_NAME,
  setLevelRewardAchievementBoost,
} from "../services/levelRewards.js";

type ServerOptions = {
  host?: string;
  port?: number;
  dbFile?: string;
  legacySavesFile?: string;
};

const MIME_TYPES: Record<string, string> = {
  ".html": "text/html; charset=utf-8",
  ".js": "text/javascript; charset=utf-8",
  ".css": "text/css; charset=utf-8",
  ".json": "application/json; charset=utf-8",
  ".swf": "application/x-shockwave-flash",
  ".wasm": "application/wasm",
  ".gif": "image/gif",
  ".png": "image/png",
  ".jpg": "image/jpeg",
  ".jpeg": "image/jpeg",
};

const EMPTY_GIF = Buffer.from("R0lGODlhAQABAIAAAAAAAP///ywAAAAAAQABAAACAUwAOw==", "base64");
const REMOTE_SWF_ASSETS = {
  ctrl: "http://cdn.comment.4399pk.com/control/ctrl_mo_v5.swf?200",
  adBase: "http://cdn.comment.4399pk.com/control/A4399dv_base.swf?200",
  adMain: "https://cdn.comment.4399pk.com/control/A4399dv_base_main.swf?20200714",
  tools: "http://cdn.comment.4399pk.com/control/open4399tools_AS3.swf",
} as const;
const GAME_ASSET_BASE_URL = "https://sbai.4399.com/4399swf/upload_swf/ftp10/honghao/20130530/27/";
const GAME_ASSET_REFERER = `${GAME_ASSET_BASE_URL}jjxzfcms.htm`;
const SWF_FILE_RE = /^[A-Za-z0-9_.-]+\.swf$/i;
const FONT_ALIAS_PATH_PREFIX = "/font-aliases/";
const FONT_ALIAS_SOURCE_SWF = "ziti.swf";
const FONT_ALIAS_SOURCE_FONT_ID = 1;
const FONT_ALIAS_ASSETS: Record<string, { fontName: string; bold?: boolean }> = {
  "ziti-simsun.swf": { fontName: "SimSun" },
  "ziti-simsun-bold.swf": { fontName: "SimSun", bold: true },
  "ziti-songti.swf": { fontName: "宋体" },
  "ziti-songti-bold.swf": { fontName: "宋体", bold: true },
  "ziti-arial.swf": { fontName: "Arial" },
  "ziti-arial-bold.swf": { fontName: "Arial", bold: true },
  "ziti-yahei.swf": { fontName: "微软雅黑" },
  "ziti-yahei-bold.swf": { fontName: "微软雅黑", bold: true },
  "ziti-microsoft-yahei.swf": { fontName: "Microsoft YaHei" },
  "ziti-microsoft-yahei-bold.swf": { fontName: "Microsoft YaHei", bold: true },
  "ziti-heiti.swf": { fontName: "黑体" },
  "ziti-newsimsun.swf": { fontName: "新宋体" },
  "ziti-newsimsun-bold.swf": { fontName: "新宋体", bold: true },
  "ziti-nsimsun.swf": { fontName: "NSimSun" },
  "ziti-nsimsun-bold.swf": { fontName: "NSimSun", bold: true },
  "ziti-times-new-roman.swf": { fontName: "Times New Roman" },
};
const GZIP_STATIC_EXTENSIONS = new Set([".css", ".html", ".js", ".json", ".wasm", ".xml"]);
const LOG_ASSET_HITS = process.env.SAVE_DATA_LOG_ASSET_HITS === "1";

function saveDataLoggingEnabled(): boolean {
  const value = process.env.SAVE_DATA_LOGS?.trim().toLowerCase();
  if (process.env.SAVE_DATA_NO_LOGS === "1") {
    return false;
  }
  return value == null || !["0", "false", "no", "off"].includes(value);
}

function configuredLegacySavesFile(options: ServerOptions): string | null {
  const value =
    options.legacySavesFile ??
    process.env.SAVE_DATA_LEGACY_SAVES_FILE ??
    process.env.SAVE_DATA_LEGACY_SAVES ??
    "";
  const trimmed = value.trim();
  return trimmed ? path.resolve(trimmed) : null;
}

function configuredDbFile(options: ServerOptions): string | null {
  const value = options.dbFile ?? process.env.SAVE_DATA_DB ?? "";
  const trimmed = value.trim();
  return trimmed ? path.resolve(trimmed) : null;
}

function createSaveDataStore(options: ServerOptions): SaveDataStore {
  const dbFile = configuredDbFile(options);
  if (dbFile) {
    return new LocalSaveDatabase(dbFile);
  }
  const legacySavesFile = configuredLegacySavesFile(options);
  if (legacySavesFile) {
    return new LegacyJsonSaveDatabase(legacySavesFile);
  }
  return new LocalSaveDatabase(saveDataPaths.defaultDbFile);
}

function getContentType(filePath: string): string {
  return MIME_TYPES[path.extname(filePath).toLowerCase()] ?? "application/octet-stream";
}

async function readRequestBody(req: IncomingMessage): Promise<Buffer> {
  const chunks: Buffer[] = [];
  for await (const chunk of req) {
    chunks.push(Buffer.isBuffer(chunk) ? chunk : Buffer.from(chunk));
  }
  return Buffer.concat(chunks);
}

function send(res: ServerResponse, status: number, contentType: string, body: string | Buffer): void {
  const contentLength = Buffer.isBuffer(body) ? body.length : Buffer.byteLength(body);
  res.writeHead(status, {
    "content-type": contentType,
    "content-length": contentLength,
    "access-control-allow-origin": "*",
    "access-control-allow-methods": "GET,POST,OPTIONS",
    "access-control-allow-headers": "*",
  });
  res.end(body);
}

function sendNotFound(res: ServerResponse): void {
  send(res, 404, "text/plain; charset=utf-8", "not found");
}

function clampLogText(value: unknown, maxLength = 500): unknown {
  if (typeof value !== "string") {
    return value;
  }
  return value.length > maxLength ? `${value.slice(0, maxLength)}...` : value;
}

function sanitizeClientLogDetails(value: unknown, depth = 0): Record<string, unknown> {
  if (!value || typeof value !== "object" || Array.isArray(value) || depth > 2) {
    return {};
  }

  const output: Record<string, unknown> = {};
  for (const [key, entry] of Object.entries(value)) {
    if (entry == null || typeof entry === "number" || typeof entry === "boolean" || typeof entry === "string") {
      output[key] = clampLogText(entry);
    } else if (typeof entry === "object" && !Array.isArray(entry)) {
      output[key] = sanitizeClientLogDetails(entry, depth + 1);
    }
  }
  return output;
}

function parseClientLog(body: string): { event: string; result: string; details: Record<string, unknown> } {
  try {
    const parsed = JSON.parse(body) as Record<string, unknown>;
    const eventName = typeof parsed.event === "string" && parsed.event ? parsed.event : "client.event";
    const result = typeof parsed.result === "string" && parsed.result ? parsed.result : "ok";
    return {
      event: eventName.startsWith("client.") || eventName.startsWith("ruffle.") ? eventName : `client.${eventName}`,
      result,
      details: sanitizeClientLogDetails(parsed),
    };
  } catch (error) {
    return {
      event: "client.log_parse_error",
      result: "invalid_json",
      details: { message: error instanceof Error ? error.message : String(error) },
    };
  }
}

function parseJsonRequestBody(body: string): unknown {
  try {
    return JSON.parse(body);
  } catch (error) {
    throw new Error(`Invalid JSON request body: ${error instanceof Error ? error.message : String(error)}`);
  }
}

const THRIFT_VERSION_1 = 0x80010000;
const THRIFT_MESSAGE_TYPE = {
  CALL: 1,
  REPLY: 2,
  EXCEPTION: 3,
} as const;
const THRIFT_TYPE = {
  STOP: 0,
  BOOL: 2,
  BYTE: 3,
  DOUBLE: 4,
  I16: 6,
  I32: 8,
  I64: 10,
  STRING: 11,
  STRUCT: 12,
  MAP: 13,
  SET: 14,
  LIST: 15,
} as const;

type ThriftMessageInfo = {
  name: string;
  type: number;
  seqid: number;
};

class ThriftBinaryWriter {
  private readonly chunks: Buffer[] = [];

  writeByte(value: number): void {
    const buffer = Buffer.allocUnsafe(1);
    buffer.writeUInt8(value & 0xff, 0);
    this.chunks.push(buffer);
  }

  writeI16(value: number): void {
    const buffer = Buffer.allocUnsafe(2);
    buffer.writeInt16BE(value, 0);
    this.chunks.push(buffer);
  }

  writeI32(value: number): void {
    const buffer = Buffer.allocUnsafe(4);
    buffer.writeInt32BE(value, 0);
    this.chunks.push(buffer);
  }

  writeMessageBegin(name: string, type: number, seqid: number): void {
    const version = Buffer.allocUnsafe(4);
    version.writeUInt32BE((THRIFT_VERSION_1 | type) >>> 0, 0);
    this.chunks.push(version);
    this.writeString(name);
    this.writeI32(seqid);
  }

  writeFieldBegin(type: number, id: number): void {
    this.writeByte(type);
    this.writeI16(id);
  }

  writeFieldStop(): void {
    this.writeByte(THRIFT_TYPE.STOP);
  }

  writeListBegin(elementType: number, size: number): void {
    this.writeByte(elementType);
    this.writeI32(size);
  }

  writeString(value: string): void {
    const bytes = Buffer.from(value, "utf8");
    this.writeI32(bytes.length);
    this.chunks.push(bytes);
  }

  toBuffer(): Buffer {
    return Buffer.concat(this.chunks);
  }
}

type ThriftFieldInfo = {
  type: number;
  id: number;
};

type ShopHeadPayload = {
  gameId?: string;
  uId?: string;
  index?: number;
  verify?: string;
};

type ShopPropPayload = {
  propId?: string;
  propCount?: number;
  propPrice?: number;
  tag?: string;
};

type ShopBuyPropRequest = {
  message: ThriftMessageInfo;
  head: ShopHeadPayload;
  prop: ShopPropPayload;
};

type ShopThriftResponse = {
  body: Buffer;
  apiName: string;
  result: string;
  request?: ShopBuyPropRequest;
  error?: {
    code: number;
    message: string;
    details?: Record<string, unknown>;
  };
  details?: Record<string, unknown>;
};

class ThriftBinaryReader {
  private offset = 0;

  constructor(private readonly body: Buffer) {}

  readByte(): number {
    this.ensureAvailable(1);
    const value = this.body.readUInt8(this.offset);
    this.offset += 1;
    return value;
  }

  readI16(): number {
    this.ensureAvailable(2);
    const value = this.body.readInt16BE(this.offset);
    this.offset += 2;
    return value;
  }

  readI32(): number {
    this.ensureAvailable(4);
    const value = this.body.readInt32BE(this.offset);
    this.offset += 4;
    return value;
  }

  readString(): string {
    const length = this.readI32();
    if (length < 0) {
      throw new Error(`Invalid thrift string length: ${length}`);
    }
    this.ensureAvailable(length);
    const value = this.body.subarray(this.offset, this.offset + length).toString("utf8");
    this.offset += length;
    return value;
  }

  readMessageBegin(): ThriftMessageInfo {
    const firstOffset = this.offset;
    const first = this.readI32();

    if (first < 0) {
      const version = (this.body.readUInt32BE(firstOffset) & 0xffff0000) >>> 0;
      if (version !== THRIFT_VERSION_1) {
        throw new Error("Unsupported thrift message version");
      }
      return {
        name: this.readString(),
        type: this.body.readUInt32BE(firstOffset) & 0xff,
        seqid: this.readI32(),
      };
    }

    this.ensureAvailable(first + 5);
    const name = this.body.subarray(this.offset, this.offset + first).toString("utf8");
    this.offset += first;
    const type = this.readByte();
    return {
      name,
      type,
      seqid: this.readI32(),
    };
  }

  readFieldBegin(): ThriftFieldInfo {
    const type = this.readByte();
    return {
      type,
      id: type === THRIFT_TYPE.STOP ? 0 : this.readI16(),
    };
  }

  skip(type: number): void {
    switch (type) {
      case THRIFT_TYPE.STOP:
        return;
      case THRIFT_TYPE.BOOL:
      case THRIFT_TYPE.BYTE:
        this.skipBytes(1);
        return;
      case THRIFT_TYPE.I16:
        this.skipBytes(2);
        return;
      case THRIFT_TYPE.I32:
        this.skipBytes(4);
        return;
      case THRIFT_TYPE.I64:
      case THRIFT_TYPE.DOUBLE:
        this.skipBytes(8);
        return;
      case THRIFT_TYPE.STRING:
        this.skipBytes(this.readI32());
        return;
      case THRIFT_TYPE.STRUCT:
        while (true) {
          const field = this.readFieldBegin();
          if (field.type === THRIFT_TYPE.STOP) {
            return;
          }
          this.skip(field.type);
        }
      case THRIFT_TYPE.LIST:
      case THRIFT_TYPE.SET: {
        const elementType = this.readByte();
        const size = this.readI32();
        for (let index = 0; index < size; index += 1) {
          this.skip(elementType);
        }
        return;
      }
      case THRIFT_TYPE.MAP: {
        const keyType = this.readByte();
        const valueType = this.readByte();
        const size = this.readI32();
        for (let index = 0; index < size; index += 1) {
          this.skip(keyType);
          this.skip(valueType);
        }
        return;
      }
      default:
        throw new Error(`Unsupported thrift field type: ${type}`);
    }
  }

  private skipBytes(length: number): void {
    if (length < 0) {
      throw new Error(`Invalid thrift byte length: ${length}`);
    }
    this.ensureAvailable(length);
    this.offset += length;
  }

  private ensureAvailable(length: number): void {
    if (this.offset + length > this.body.length) {
      throw new Error("Unexpected end of thrift payload");
    }
  }
}

function readThriftMessageInfo(body: Buffer): ThriftMessageInfo | null {
  if (body.length < 4) {
    return null;
  }

  let offset = 0;
  const first = body.readInt32BE(offset);
  offset += 4;

  if (first < 0) {
    const version = (body.readUInt32BE(0) & 0xffff0000) >>> 0;
    if (version !== THRIFT_VERSION_1 || body.length < offset + 4) {
      return null;
    }

    const nameLength = body.readInt32BE(offset);
    offset += 4;
    if (nameLength < 0 || body.length < offset + nameLength + 4) {
      return null;
    }

    const name = body.subarray(offset, offset + nameLength).toString("utf8");
    offset += nameLength;
    return {
      name,
      type: body.readUInt32BE(0) & 0xff,
      seqid: body.readInt32BE(offset),
    };
  }

  if (first < 0 || body.length < offset + first + 5) {
    return null;
  }

  const name = body.subarray(offset, offset + first).toString("utf8");
  offset += first;
  const type = body.readUInt8(offset);
  offset += 1;
  return {
    name,
    type,
    seqid: body.readInt32BE(offset),
  };
}

function writeThriftStringField(writer: ThriftBinaryWriter, id: number, value: string): void {
  writer.writeFieldBegin(THRIFT_TYPE.STRING, id);
  writer.writeString(value);
}

function writeThriftI32Field(writer: ThriftBinaryWriter, id: number, value: number): void {
  writer.writeFieldBegin(THRIFT_TYPE.I32, id);
  writer.writeI32(value);
}

function writeThriftStructField(writer: ThriftBinaryWriter, id: number, writeStruct: () => void): void {
  writer.writeFieldBegin(THRIFT_TYPE.STRUCT, id);
  writeStruct();
}

function thriftUnionListResponse(seqid: number): Buffer {
  const writer = new ThriftBinaryWriter();
  writer.writeMessageBegin("unionList", THRIFT_MESSAGE_TYPE.REPLY, seqid);
  writeThriftStructField(writer, 0, () => {
    writeThriftStringField(writer, 1, String(Date.now()));
    writer.writeFieldBegin(THRIFT_TYPE.LIST, 2);
    writer.writeListBegin(THRIFT_TYPE.STRUCT, 0);
    writeThriftStringField(writer, 3, "0");
    writer.writeFieldStop();
  });
  writer.writeFieldStop();
  return writer.toBuffer();
}

function thriftUnionOfMeResponse(seqid: number): Buffer {
  const writer = new ThriftBinaryWriter();
  writer.writeMessageBegin("unionOfMe", THRIFT_MESSAGE_TYPE.REPLY, seqid);
  writeThriftStructField(writer, 0, () => {
    writeThriftStringField(writer, 1, String(Date.now()));
    writeThriftStructField(writer, 2, () => {
      writeThriftStructField(writer, 1, () => {
        writer.writeFieldStop();
      });
      writeThriftStructField(writer, 2, () => {
        writer.writeFieldStop();
      });
      writer.writeFieldStop();
    });
    writer.writeFieldStop();
  });
  writer.writeFieldStop();
  return writer.toBuffer();
}

function readShopHead(reader: ThriftBinaryReader): ShopHeadPayload {
  const head: ShopHeadPayload = {};

  while (true) {
    const field = reader.readFieldBegin();
    if (field.type === THRIFT_TYPE.STOP) {
      return head;
    }

    switch (field.id) {
      case 1:
        field.type === THRIFT_TYPE.STRING ? (head.gameId = reader.readString()) : reader.skip(field.type);
        break;
      case 2:
        field.type === THRIFT_TYPE.STRING ? (head.uId = reader.readString()) : reader.skip(field.type);
        break;
      case 3:
        field.type === THRIFT_TYPE.I32 ? (head.index = reader.readI32()) : reader.skip(field.type);
        break;
      case 4:
        field.type === THRIFT_TYPE.STRING ? (head.verify = reader.readString()) : reader.skip(field.type);
        break;
      default:
        reader.skip(field.type);
    }
  }
}

function readShopProp(reader: ThriftBinaryReader): ShopPropPayload {
  const prop: ShopPropPayload = {};

  while (true) {
    const field = reader.readFieldBegin();
    if (field.type === THRIFT_TYPE.STOP) {
      return prop;
    }

    switch (field.id) {
      case 1:
        field.type === THRIFT_TYPE.STRING ? (prop.propId = reader.readString()) : reader.skip(field.type);
        break;
      case 2:
        field.type === THRIFT_TYPE.I32 ? (prop.propCount = reader.readI32()) : reader.skip(field.type);
        break;
      case 3:
        field.type === THRIFT_TYPE.I32 ? (prop.propPrice = reader.readI32()) : reader.skip(field.type);
        break;
      case 4:
        field.type === THRIFT_TYPE.STRING ? (prop.tag = reader.readString()) : reader.skip(field.type);
        break;
      default:
        reader.skip(field.type);
    }
  }
}

function readShopBuyPropRequest(body: Buffer): ShopBuyPropRequest {
  const reader = new ThriftBinaryReader(body);
  const message = reader.readMessageBegin();
  const head: ShopHeadPayload = {};
  const prop: ShopPropPayload = {};

  while (true) {
    const field = reader.readFieldBegin();
    if (field.type === THRIFT_TYPE.STOP) {
      return { message, head, prop };
    }

    if (field.id === 1 && field.type === THRIFT_TYPE.STRUCT) {
      Object.assign(head, readShopHead(reader));
    } else if (field.id === 2 && field.type === THRIFT_TYPE.STRUCT) {
      Object.assign(prop, readShopProp(reader));
    } else {
      reader.skip(field.type);
    }
  }
}

function thriftShopBuyPropResponse(seqid: number, propId: string, count: number, balance: number, tag = ""): Buffer {
  const writer = new ThriftBinaryWriter();
  writer.writeMessageBegin("buyProp", THRIFT_MESSAGE_TYPE.REPLY, seqid);
  writeThriftStructField(writer, 0, () => {
    writeThriftStructField(writer, 1, () => {
      writeThriftI32Field(writer, 1, balance);
      writeThriftStringField(writer, 2, propId);
      writeThriftI32Field(writer, 3, count);
      writeThriftStringField(writer, 4, tag);
      writer.writeFieldStop();
    });
    writer.writeFieldStop();
  });
  writer.writeFieldStop();
  return writer.toBuffer();
}

function thriftShopBuyPropErrorResponse(seqid: number, code: number, message: string): Buffer {
  const writer = new ThriftBinaryWriter();
  writer.writeMessageBegin("buyProp", THRIFT_MESSAGE_TYPE.REPLY, seqid);
  writeThriftStructField(writer, 1, () => {
    writeThriftI32Field(writer, 1, code);
    writeThriftStringField(writer, 2, message);
    writer.writeFieldStop();
  });
  writer.writeFieldStop();
  return writer.toBuffer();
}

function thriftShopGetPropListResponse(seqid: number): Buffer {
  const writer = new ThriftBinaryWriter();
  writer.writeMessageBegin("getPropList", THRIFT_MESSAGE_TYPE.REPLY, seqid);
  writeThriftStructField(writer, 0, () => {
    writer.writeFieldBegin(THRIFT_TYPE.LIST, 1);
    writer.writeListBegin(THRIFT_TYPE.STRUCT, 0);
    writer.writeFieldStop();
  });
  writer.writeFieldStop();
  return writer.toBuffer();
}

function thriftExceptionResponse(name: string, seqid: number, message: string): Buffer {
  const writer = new ThriftBinaryWriter();
  writer.writeMessageBegin(name, THRIFT_MESSAGE_TYPE.EXCEPTION, seqid);
  writeThriftStringField(writer, 1, message);
  writeThriftI32Field(writer, 2, 1);
  writer.writeFieldStop();
  return writer.toBuffer();
}

function shopMockResponse(api: SaveDataMockApi, body: Buffer): ShopThriftResponse {
  const message = readThriftMessageInfo(body);
  const apiName = message?.name ?? "unknown";
  const seqid = message?.seqid ?? 0;

  if (apiName === "getPropList") {
    return { apiName, result: "empty_prop_list", body: thriftShopGetPropListResponse(seqid) };
  }

  if (apiName !== "buyProp") {
    return {
      apiName,
      result: "unsupported",
      body: thriftExceptionResponse(apiName, seqid, `Unsupported local shop API: ${apiName}`),
    };
  }

  try {
    const request = readShopBuyPropRequest(body);
    const propId = request.prop.propId ?? "0";
    const count = request.prop.propCount ?? 1;
    const price = request.prop.propPrice ?? 0;
    const tag = request.prop.tag ?? "";
    const requestedUid = request.head.uId ?? api.account.uid;
    const uid = api.resolvePaymentUid(requestedUid);
    const result = api.buyProp({
      uid: requestedUid,
      gameId: request.head.gameId ?? "100025235",
      slotIndex: request.head.index,
      propId: Number(propId),
      count,
      price,
      tag: Number(tag) || 0,
    });

    return {
      apiName,
      result: "ok",
      request,
      details: {
        requestedUid,
        paymentUid: uid,
        balance: result.balance,
        totalPrice: result.totalPrice,
        projectedShopValue: result.projectedShopValue,
        requiredTotalRecharge: result.requiredTotalRecharge,
        availableTotalRecharge: result.availableTotalRecharge,
        productKnown: result.product.productKnown,
        perItemShopValue: result.product.perItemShopValue,
        candidateGoodsIds: result.product.candidates.map((candidate) => candidate.goodsId),
        slotShopValue: result.slotShopValue?.shopValue,
      },
      body: thriftShopBuyPropResponse(request.message.seqid, propId, count, result.balance, tag),
    };
  } catch (error) {
    if (error instanceof MockShopError) {
      return {
        apiName,
        result: error.result,
        error: {
          code: error.code,
          message: error.message,
          details: error.details,
        },
        body: thriftShopBuyPropErrorResponse(seqid, error.code, error.message),
      };
    }
    return {
      apiName,
      result: "invalid_request",
      error: {
        code: 20003,
        message: error instanceof Error ? error.message : String(error),
      },
      body: thriftShopBuyPropErrorResponse(seqid, 20003, error instanceof Error ? error.message : String(error)),
    };
  }
}

function unionMockResponse(body: Buffer): { body: Buffer; apiName: string; result: string } {
  const message = readThriftMessageInfo(body);
  const apiName = message?.name ?? "unknown";
  const seqid = message?.seqid ?? 0;

  if (apiName === "unionList") {
    return { apiName, result: "empty_union_list", body: thriftUnionListResponse(seqid) };
  }

  if (apiName === "unionOfMe") {
    return { apiName, result: "empty_own_union", body: thriftUnionOfMeResponse(seqid) };
  }

  return {
    apiName,
    result: "unsupported",
    body: thriftExceptionResponse(apiName, seqid, `Unsupported local union API: ${apiName}`),
  };
}

function acceptsGzip(req: IncomingMessage): boolean {
  return /\bgzip\b/i.test(req.headers["accept-encoding"] ?? "");
}

function requestOrigin(req: IncomingMessage, fallbackHost: string, fallbackPort: number): string {
  const forwardedProto = req.headers["x-forwarded-proto"];
  const proto = Array.isArray(forwardedProto) ? forwardedProto[0] : forwardedProto ?? "http";
  const forwardedHost = req.headers["x-forwarded-host"];
  const hostHeader = Array.isArray(forwardedHost)
    ? forwardedHost[0]
    : forwardedHost ?? req.headers.host ?? `${fallbackHost}:${fallbackPort}`;
  return `${proto}://${hostHeader}`;
}

function safeJoin(root: string, requestPath: string): string | null {
  const decoded = decodeURIComponent(requestPath);
  const joined = path.resolve(root, `.${decoded}`);
  return joined.startsWith(path.resolve(root)) ? joined : null;
}

async function ensureRemoteAsset(assetFile: string, sourceUrl: string): Promise<void> {
  if (existsSync(assetFile)) {
    return;
  }

  mkdirSync(path.dirname(assetFile), { recursive: true });
  const response = await fetch(sourceUrl);
  if (!response.ok) {
    throw new Error(`Failed to download ${sourceUrl}: ${response.status} ${response.statusText}`);
  }

  await writeFile(assetFile, Buffer.from(await response.arrayBuffer()));
}

function copyMissingFiles(sourceRoot: string, targetRoot: string): void {
  if (!existsSync(sourceRoot)) {
    return;
  }

  for (const entry of readdirSync(sourceRoot, { withFileTypes: true })) {
    const sourcePath = path.join(sourceRoot, entry.name);
    const targetPath = path.join(targetRoot, entry.name);
    if (entry.isDirectory()) {
      copyMissingFiles(sourcePath, targetPath);
      continue;
    }
    if (!entry.isFile() || existsSync(targetPath)) {
      continue;
    }
    mkdirSync(path.dirname(targetPath), { recursive: true });
    copyFileSync(sourcePath, targetPath);
  }
}

function gameAssetFile(assetName: string): string {
  return path.join(saveDataPaths.remoteAssetsRoot, "sbai.4399.com", "4399swf", "upload_swf", "ftp10", "honghao", "20130530", "27", assetName);
}

async function ensureGameAsset(assetName: string, logger: SaveDataLogger): Promise<string | null> {
  if (!SWF_FILE_RE.test(assetName)) {
    return null;
  }

  const assetFile = gameAssetFile(assetName);
  if (existsSync(assetFile)) {
    const effectiveAsset =
      assetName.toLowerCase() === LEVEL_REWARD_ASSET_NAME ? ensurePatchedLevelRewardAsset(assetFile) ?? assetFile : assetFile;
    if (LOG_ASSET_HITS) {
      logger.appendSync({
        event: "asset.local_hit",
        method: "GET",
        pathname: `/${assetName}`,
        status: 200,
        result: "ok",
        details: { assetName, file: effectiveAsset, sourceFile: assetFile, size: statSync(effectiveAsset).size },
      });
    }
    return effectiveAsset;
  }

  const sourceUrl = new URL(assetName, GAME_ASSET_BASE_URL).toString();
  logger.appendSync({
    event: "asset.remote_fetch",
    method: "GET",
    pathname: `/${assetName}`,
    status: 0,
    result: "pending",
    details: { assetName, sourceUrl },
  });

  const response = await fetch(sourceUrl, {
    headers: {
      "User-Agent": "Mozilla/5.0",
      Referer: GAME_ASSET_REFERER,
    },
  });

  if (!response.ok) {
    logger.appendSync({
      event: "asset.remote_fetch",
      method: "GET",
      pathname: `/${assetName}`,
      status: response.status,
      result: "error",
      details: { assetName, sourceUrl, statusText: response.statusText },
    });
    return null;
  }

  const body = Buffer.from(await response.arrayBuffer());
  mkdirSync(path.dirname(assetFile), { recursive: true });
  await writeFile(assetFile, body);
  logger.appendSync({
    event: "asset.remote_fetch",
    method: "GET",
    pathname: `/${assetName}`,
    status: 200,
    result: "ok",
    details: { assetName, sourceUrl, file: assetFile, size: body.length },
  });
  return assetName.toLowerCase() === LEVEL_REWARD_ASSET_NAME ? ensurePatchedLevelRewardAsset(assetFile) ?? assetFile : assetFile;
}

function fontAliasFile(assetName: string): string {
  return path.join(saveDataPaths.generatedAssetsRoot, "font-aliases", assetName);
}

async function ensureFontAliasAsset(assetName: string, logger: SaveDataLogger): Promise<string | null> {
  const alias = FONT_ALIAS_ASSETS[assetName];
  if (!alias) {
    return null;
  }

  const outputFile = fontAliasFile(assetName);
  if (existsSync(outputFile)) {
    return outputFile;
  }

  const sourceFile = await ensureGameAsset(FONT_ALIAS_SOURCE_SWF, logger);
  if (!sourceFile || !existsSync(sourceFile)) {
    return null;
  }

  mkdirSync(path.dirname(outputFile), { recursive: true });
  const swf = decodeSwf(readFileSync(sourceFile));
  const replacements = aliasSwfFontName(swf, FONT_ALIAS_SOURCE_FONT_ID, alias.fontName, { bold: alias.bold });
  if (replacements < 1) {
    return null;
  }
  writeFileSync(outputFile, encodeSwf(swf));
  logger.appendSync({
    event: "font.alias",
    method: "GET",
    pathname: `${FONT_ALIAS_PATH_PREFIX}${assetName}`,
    status: 200,
    result: "ok",
    details: {
      assetName,
      fontName: alias.fontName,
      bold: alias.bold === true,
      sourceFile,
      outputFile,
      replacements,
      size: statSync(outputFile).size,
    },
  });
  return outputFile;
}

function patchedRuffleEventSwfBytes(inputFile: string): Buffer {
  const swf = decodeSwf(readFileSync(inputFile));
  const patchCount = patchRuffleEventCompatibility(swf);

  if (patchCount < 1) {
    throw new Error(`Expected Ruffle event compatibility target in ${inputFile}, patched ${patchCount}`);
  }

  return encodeSwf(swf);
}

function patchRuffleEventSwf(inputFile: string, outputFile: string): void {
  writeFileSync(outputFile, patchedRuffleEventSwfBytes(inputFile));
}

function patchOuterSwfForRuffle(outerFile: string, patchedInnerBytes: Buffer, outputFile: string): void {
  const swf = decodeSwf(readFileSync(outerFile));
  const patchCount = patchRuffleEventCompatibility(swf);
  const replacements = replaceDefineBinaryData(swf, 13, patchedInnerBytes);

  if (patchCount < 1) {
    throw new Error(`Expected Ruffle event compatibility target in ${outerFile}, patched ${patchCount}`);
  }
  if (replacements !== 1) {
    throw new Error(`Expected one embedded game SWF replacement in ${outerFile}, found ${replacements}`);
  }

  writeFileSync(outputFile, encodeSwf(swf));
}

async function ensureRuntimeAssets(): Promise<void> {
  mkdirSync(path.join(saveDataPaths.runtimePublicRoot, "assets"), { recursive: true });
  mkdirSync(path.join(saveDataPaths.runtimePublicRoot, "swf"), { recursive: true });
  mkdirSync(path.join(saveDataPaths.runtimePublicRoot, "ruffle"), { recursive: true });
  copyMissingFiles(saveDataPaths.bundledRemoteAssetsRoot, saveDataPaths.remoteAssetsRoot);

  const outerSwf = path.join(saveDataPaths.downloadsSwf, "xfbbv451.swf");
  const innerSwf = path.join(saveDataPaths.extractedSwf, "L4399Main_gamefile.swf");
  const publicOuter = path.join(saveDataPaths.runtimePublicRoot, "swf", "xfbbv451.swf");
  const publicInner = path.join(saveDataPaths.runtimePublicRoot, "swf", "L4399Main_gamefile.swf");
  const adAsset = path.join(saveDataPaths.platformAssetsRoot, "A4399dv_base.swf");
  const adMainAsset = path.join(saveDataPaths.platformAssetsRoot, "A4399dv_base_main.swf");
  const toolsAsset = path.join(saveDataPaths.platformAssetsRoot, "open4399tools_AS3.swf");
  const publicAd = path.join(saveDataPaths.runtimePublicRoot, "assets", "A4399dv_base.swf");
  const publicAdMain = path.join(saveDataPaths.runtimePublicRoot, "assets", "A4399dv_base_main.swf");
  const publicTools = path.join(saveDataPaths.runtimePublicRoot, "assets", "open4399tools_AS3.swf");

  const patchedInnerBytes = existsSync(innerSwf) ? patchedRuffleEventSwfBytes(innerSwf) : null;
  if (existsSync(outerSwf) && patchedInnerBytes) {
    patchOuterSwfForRuffle(outerSwf, patchedInnerBytes, publicOuter);
  } else if (existsSync(outerSwf)) {
    patchRuffleEventSwf(outerSwf, publicOuter);
  }
  if (patchedInnerBytes) {
    await writeFile(publicInner, patchedInnerBytes);
  }
  await ensureRemoteAsset(adAsset, REMOTE_SWF_ASSETS.adBase);
  await ensureRemoteAsset(adMainAsset, REMOTE_SWF_ASSETS.adMain);
  await ensureRemoteAsset(toolsAsset, REMOTE_SWF_ASSETS.tools);
  await cp(adAsset, publicAd);
  await cp(adMainAsset, publicAdMain);
  await cp(toolsAsset, publicTools);

  await cp(saveDataPaths.ruffleRoot, path.join(saveDataPaths.runtimePublicRoot, "ruffle"), {
    recursive: true,
    force: true,
  });

  const ctrlAsset = path.join(saveDataPaths.platformAssetsRoot, "ctrl_mo_v5.swf");
  const publicCtrl = path.join(saveDataPaths.runtimePublicRoot, "ctrl_mo_v5.swf");
  await ensureRemoteAsset(ctrlAsset, REMOTE_SWF_ASSETS.ctrl);
  patchRuffleEventSwf(ctrlAsset, publicCtrl);
}

async function serveStatic(req: IncomingMessage, res: ServerResponse, root: string, requestPath: string): Promise<boolean> {
  const filePath = safeJoin(root, requestPath);
  if (!filePath || !existsSync(filePath)) {
    return false;
  }
  const fileStat = statSync(filePath);
  if (!fileStat.isFile()) {
    return false;
  }

  const ext = path.extname(filePath).toLowerCase();
  const gzip = acceptsGzip(req) && GZIP_STATIC_EXTENSIONS.has(ext);
  res.writeHead(200, {
    "content-type": getContentType(filePath),
    "access-control-allow-origin": "*",
    "cache-control": "public, max-age=3600",
    ...(gzip ? {} : { "content-length": fileStat.size }),
    ...(gzip ? { "content-encoding": "gzip", vary: "accept-encoding" } : {}),
  });
  if (req.method === "HEAD") {
    res.end();
    return true;
  }
  const stream = createReadStream(filePath);
  if (gzip) {
    stream.pipe(createGzip()).pipe(res);
  } else {
    stream.pipe(res);
  }
  return true;
}

function localCtrlXml(baseUrl: string): string {
  return [
    '<?xml version="1.0" encoding="utf-8"?>',
    "<resInfos>",
    `  <info resName="zwsf">${baseUrl}/assets/empty.gif</info>`,
    `  <info resName="ctrl_v5">${baseUrl}/ctrl_mo_v5.swf</info>`,
    `  <info resName="ads">${baseUrl}/assets/A4399dv_base.swf</info>`,
    "</resInfos>",
  ].join("\n");
}

export async function startSaveDataServer(options: ServerOptions = {}) {
  await ensureRuntimeAssets();

  const host = options.host ?? process.env.SAVE_DATA_HOST ?? "127.0.0.1";
  const port = options.port ?? Number(process.env.SAVE_DATA_PORT ?? 8787);
  const db = createSaveDataStore(options);
  const logger = new SaveDataLogger({ enabled: saveDataLoggingEnabled() });
  const api = new SaveDataMockApi(db, undefined, logger);

  const server = createServer(async (req, res) => {
    try {
      if (!req.url) {
        sendNotFound(res);
        return;
      }
      if (req.method === "OPTIONS") {
        send(res, 204, "text/plain", "");
        return;
      }

      const url = new URL(req.url, `http://${req.headers.host ?? `${host}:${port}`}`);
      const bodyBuffer = req.method === "POST" ? await readRequestBody(req) : Buffer.alloc(0);
      const body = bodyBuffer.toString("utf8");
      const address = server.address() as AddressInfo | null;
      const actualPort = address?.port ?? port;
      const baseUrl = requestOrigin(req, host, actualPort);

      if (url.pathname === "/" || url.pathname === "/index.html") {
        const html = await readFile(path.join(saveDataPaths.publicRoot, "index.html"));
        send(res, 200, "text/html; charset=utf-8", html);
        return;
      }

      if (url.pathname === "/flash_ctrl_version.xml") {
        send(res, 200, "application/xml; charset=utf-8", localCtrlXml(baseUrl));
        return;
      }

      if (url.pathname === "/flash_ad_version.xml") {
        send(
          res,
          200,
          "application/xml; charset=utf-8",
          `<?xml version="1.0" encoding="utf-8"?><info>${baseUrl}/assets/A4399dv_base_main.swf</info>`
        );
        return;
      }

      if (url.pathname === "/crossdomain.xml") {
        send(
          res,
          200,
          "application/xml; charset=utf-8",
          '<?xml version="1.0"?><cross-domain-policy><allow-access-from domain="*" secure="false" /></cross-domain-policy>'
        );
        return;
      }

      if (url.pathname === "/assets/empty.gif") {
        send(res, 200, "image/gif", EMPTY_GIF);
        return;
      }

      if (url.pathname === "/favicon.ico") {
        send(res, 200, "image/gif", EMPTY_GIF);
        return;
      }

      const loginResponse = api.handleUniLogin(url.pathname);
      if (loginResponse) {
        send(res, loginResponse.status, loginResponse.contentType, loginResponse.body);
        return;
      }

      const debugResponse = api.handleDebugApi(url, req.method ?? "GET", body);
      if (debugResponse) {
        send(res, debugResponse.status, debugResponse.contentType, debugResponse.body);
        return;
      }

      if (url.pathname === "/api/saveData/level-rewards") {
        if (req.method === "GET") {
          send(res, 200, "application/json; charset=utf-8", JSON.stringify(getLevelRewardState()));
          return;
        }
        if (req.method === "POST") {
          try {
            const state = setLevelRewardAchievementBoost(parseJsonRequestBody(body));
            logger.appendSync({
              event: "level_rewards.override",
              method: req.method,
              pathname: url.pathname,
              status: 200,
              result: "ok",
              details: {
                achievementBoostEnabled: state.achievementBoostEnabled,
                achievementBoostValue: state.achievementBoostValue,
                overridesCount: state.overridesCount,
              },
            });
            send(res, 200, "application/json; charset=utf-8", JSON.stringify(state));
          } catch (error) {
            logger.appendSync({
              event: "level_rewards.override",
              method: req.method,
              pathname: url.pathname,
              status: 400,
              result: "invalid_request",
              details: { message: error instanceof Error ? error.message : String(error) },
            });
            send(
              res,
              400,
              "application/json; charset=utf-8",
              JSON.stringify({ ok: false, error: error instanceof Error ? error.message : String(error) })
            );
          }
          return;
        }
        send(res, 405, "application/json; charset=utf-8", JSON.stringify({ ok: false, error: "method_not_allowed" }));
        return;
      }

      if (url.pathname === "/api/saveData/level-rewards/clear") {
        if (req.method !== "POST") {
          send(res, 405, "application/json; charset=utf-8", JSON.stringify({ ok: false, error: "method_not_allowed" }));
          return;
        }
        try {
          const state = clearLevelRewardAchievementBoost();
          logger.appendSync({
            event: "level_rewards.clear",
            method: req.method,
            pathname: url.pathname,
            status: 200,
            result: "ok",
            details: {
              achievementBoostEnabled: state.achievementBoostEnabled,
              achievementBoostValue: state.achievementBoostValue,
              overridesCount: state.overridesCount,
            },
          });
          send(res, 200, "application/json; charset=utf-8", JSON.stringify(state));
        } catch (error) {
          logger.appendSync({
            event: "level_rewards.clear",
            method: req.method,
            pathname: url.pathname,
            status: 400,
            result: "invalid_request",
            details: { message: error instanceof Error ? error.message : String(error) },
          });
          send(
            res,
            400,
            "application/json; charset=utf-8",
            JSON.stringify({ ok: false, error: error instanceof Error ? error.message : String(error) })
          );
        }
        return;
      }

      if (url.pathname === "/api/saveData/logs") {
        const limit = Number(url.searchParams.get("limit") ?? "200");
        send(res, 200, "application/json; charset=utf-8", JSON.stringify(logger.list(Number.isFinite(limit) ? limit : 200)));
        return;
      }

      if (url.pathname === "/api/saveData/logs/clear") {
        logger.clear();
        send(res, 200, "application/json; charset=utf-8", JSON.stringify({ ok: true }));
        return;
      }

      if (url.pathname === "/api/saveData/client-log") {
        if (req.method !== "POST") {
          send(res, 405, "application/json; charset=utf-8", JSON.stringify({ ok: false, error: "method_not_allowed" }));
          return;
        }
        const clientLog = parseClientLog(body);
        logger.appendSync({
          event: clientLog.event,
          method: req.method,
          pathname: url.pathname,
          status: 200,
          result: clientLog.result,
          details: clientLog.details,
        });
        send(res, 200, "application/json; charset=utf-8", JSON.stringify({ ok: true }));
        return;
      }

      if (url.pathname.startsWith("/api/stat")) {
        send(res, 200, "text/plain; charset=utf-8", "1");
        return;
      }

      if ((req.method === "GET" || req.method === "HEAD") && url.pathname.startsWith(FONT_ALIAS_PATH_PREFIX)) {
        const assetName = path.basename(url.pathname);
        if (url.pathname !== `${FONT_ALIAS_PATH_PREFIX}${assetName}`) {
          sendNotFound(res);
          return;
        }

        const assetFile = await ensureFontAliasAsset(assetName, logger);
        if (assetFile && (await serveStatic(req, res, path.dirname(assetFile), `/${path.basename(assetFile)}`))) {
          return;
        }
        sendNotFound(res);
        return;
      }

      if (url.pathname === "/api/media/cover/entries") {
        send(res, 200, "application/json; charset=utf-8", JSON.stringify({ code: 0, data: [] }));
        return;
      }

      if (url.pathname === "/api/4399-task/game-play") {
        logger.appendSync({
          event: "platform.game_play",
          method: req.method ?? "GET",
          pathname: url.pathname,
          uid: api.account.uid,
          gameid: "100025235",
          status: 200,
          result: "ok",
        });
        send(res, 200, "application/json; charset=utf-8", JSON.stringify({ code: 0, result: {} }));
        return;
      }

      if (url.pathname.startsWith("/api/4399/union/")) {
        const response = unionMockResponse(bodyBuffer);
        logger.appendSync({
          event: "platform.union",
          method: req.method ?? "GET",
          pathname: url.pathname,
          uid: api.account.uid,
          gameid: "100025235",
          status: 200,
          result: response.result,
          details: {
            apiName: response.apiName,
            requestBytes: bodyBuffer.length,
            responseBytes: response.body.length,
            query: Object.fromEntries(url.searchParams.entries()),
          },
        });
        send(res, 200, "application/x-thrift", response.body);
        return;
      }

      if (url.pathname === "/api/4399/mall/FlashStoreApi" || (url.hostname === "save.api.4399.com" && url.pathname === "/mall/FlashStoreApi")) {
        const response = shopMockResponse(api, bodyBuffer);
        logger.appendSync({
          event: "payment.shop_thrift",
          method: req.method ?? "GET",
          pathname: url.pathname,
          uid: typeof response.details?.paymentUid === "string" ? response.details.paymentUid : api.account.uid,
          gameid: response.request?.head.gameId ?? "100025235",
          status: 200,
          result: response.result,
          details: {
            apiName: response.apiName,
            requestBytes: bodyBuffer.length,
            responseBytes: response.body.length,
            head: response.request?.head,
            prop: response.request?.prop,
            error: response.error,
            result: response.details,
            hexPreview: bodyBuffer.subarray(0, 96).toString("hex"),
          },
        });
        send(res, 200, "application/x-thrift", response.body);
        return;
      }

      if (url.pathname.startsWith("/api/4399")) {
        const forwarded = new URL(url.toString());
        forwarded.pathname = url.pathname.replace(/^\/api\/4399/, "") || "/";
        const response = api.handleSaveApi(forwarded, req.method ?? "GET", body);
        if (response) {
          send(res, response.status, response.contentType, response.body);
          return;
        }
      }

      if (url.hostname === "save.api.4399.com") {
        const response = api.handleSaveApi(url, req.method ?? "GET", body);
        if (response) {
          send(res, response.status, response.contentType, response.body);
          return;
        }
      }

      if (await serveStatic(req, res, saveDataPaths.publicRoot, url.pathname)) {
        return;
      }

      if (await serveStatic(req, res, saveDataPaths.runtimePublicRoot, url.pathname)) {
        return;
      }

      if ((req.method === "GET" || req.method === "HEAD") && SWF_FILE_RE.test(path.basename(url.pathname))) {
        const assetFile = await ensureGameAsset(path.basename(url.pathname), logger);
        if (assetFile && (await serveStatic(req, res, path.dirname(assetFile), `/${path.basename(assetFile)}`))) {
          return;
        }
      }

      sendNotFound(res);
    } catch (error) {
      send(res, 500, "text/plain; charset=utf-8", error instanceof Error ? error.stack ?? error.message : String(error));
    }
  });

  await new Promise<void>((resolve) => server.listen(port, host, resolve));

  const address = server.address() as AddressInfo;
  const actualPort = address.port;

  return {
    host,
    port: actualPort,
    url: `http://${host}:${actualPort}`,
    db,
    server,
    close: async () => {
      await new Promise<void>((resolve, reject) => {
        server.close((error) => (error ? reject(error) : resolve()));
      });
      db.close();
    },
  };
}

if (process.argv[1] && path.resolve(fileURLToPath(import.meta.url)) === path.resolve(process.argv[1])) {
  startSaveDataServer()
    .then(({ url }) => {
      console.log(`saveData mock server: ${url}`);
      const dbFile = configuredDbFile({});
      if (dbFile) {
        console.log(`database: ${dbFile}`);
      } else {
        const legacySavesFile = configuredLegacySavesFile({});
        if (legacySavesFile) {
          console.log(`legacy saves: ${legacySavesFile}`);
        } else {
          console.log(`database: ${saveDataPaths.defaultDbFile}`);
        }
      }
    })
    .catch((error) => {
      console.error(error);
      process.exitCode = 1;
    });
}
