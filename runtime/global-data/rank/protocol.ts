import type { GlobalPlayer } from "../types.js";
import { ARENA_RANK_LIST_ID, GlobalRankService, type RankEntry, type RankSubmissionResult } from "./service.js";

const TYPE = { STOP: 0, BOOL: 2, BYTE: 3, DOUBLE: 4, I16: 6, I32: 8, I64: 10, STRING: 11, STRUCT: 12, MAP: 13, SET: 14, LIST: 15 } as const;
const MESSAGE = { CALL: 1, REPLY: 2, EXCEPTION: 3 } as const;
const VERSION_1 = 0x80010000;

type RankRequest = {
  method: string;
  seqid: number;
  uid: number;
  gameId: string;
  slotIndex: number;
  rankListId: number;
  count: number;
  page: number;
  username: string;
  submissions: Array<{ rankListId: number; score: number; extra: string }>;
};

class Reader {
  private offset = 0;

  constructor(private readonly buffer: Buffer) {}

  byte(): number {
    this.ensure(1);
    return this.buffer.readUInt8(this.offset++);
  }

  i16(): number {
    this.ensure(2);
    const value = this.buffer.readInt16BE(this.offset);
    this.offset += 2;
    return value;
  }

  i32(): number {
    this.ensure(4);
    const value = this.buffer.readInt32BE(this.offset);
    this.offset += 4;
    return value;
  }

  string(): string {
    const length = this.i32();
    if (length < 0) {
      throw new Error("Invalid thrift string length");
    }
    this.ensure(length);
    const value = this.buffer.toString("utf8", this.offset, this.offset + length);
    this.offset += length;
    return value;
  }

  field(): { type: number; id: number } {
    const type = this.byte();
    return { type, id: type === TYPE.STOP ? 0 : this.i16() };
  }

  list(): { type: number; size: number } {
    return { type: this.byte(), size: this.i32() };
  }

  skip(type: number): void {
    switch (type) {
      case TYPE.STOP:
        return;
      case TYPE.BOOL:
      case TYPE.BYTE:
        this.byte();
        return;
      case TYPE.I16:
        this.i16();
        return;
      case TYPE.I32:
        this.i32();
        return;
      case TYPE.I64:
      case TYPE.DOUBLE:
        this.ensure(8);
        this.offset += 8;
        return;
      case TYPE.STRING:
        this.string();
        return;
      case TYPE.STRUCT:
        while (true) {
          const field = this.field();
          if (field.type === TYPE.STOP) return;
          this.skip(field.type);
        }
      case TYPE.LIST:
      case TYPE.SET: {
        const list = this.list();
        for (let index = 0; index < list.size; index += 1) this.skip(list.type);
        return;
      }
      case TYPE.MAP: {
        const keyType = this.byte();
        const valueType = this.byte();
        const size = this.i32();
        for (let index = 0; index < size; index += 1) {
          this.skip(keyType);
          this.skip(valueType);
        }
        return;
      }
      default:
        throw new Error(`Unsupported thrift type: ${type}`);
    }
  }

  private ensure(length: number): void {
    if (this.offset + length > this.buffer.length) {
      throw new Error("Unexpected end of thrift request");
    }
  }
}

class Writer {
  private readonly chunks: Buffer[] = [];

  byte(value: number): void {
    this.chunks.push(Buffer.from([value & 0xff]));
  }

  i16(value: number): void {
    const buffer = Buffer.allocUnsafe(2);
    buffer.writeInt16BE(value);
    this.chunks.push(buffer);
  }

  i32(value: number): void {
    const buffer = Buffer.allocUnsafe(4);
    buffer.writeInt32BE(value);
    this.chunks.push(buffer);
  }

  string(value: string): void {
    const bytes = Buffer.from(value, "utf8");
    this.i32(bytes.length);
    this.chunks.push(bytes);
  }

  message(name: string, type: number, seqid: number): void {
    const version = Buffer.allocUnsafe(4);
    version.writeUInt32BE((VERSION_1 | type) >>> 0);
    this.chunks.push(version);
    this.string(name);
    this.i32(seqid);
  }

  field(type: number, id: number): void {
    this.byte(type);
    this.i16(id);
  }

  stop(): void {
    this.byte(TYPE.STOP);
  }

  list(type: number, size: number): void {
    this.byte(type);
    this.i32(size);
  }

  map(keyType: number, valueType: number, size: number): void {
    this.byte(keyType);
    this.byte(valueType);
    this.i32(size);
  }

  buffer(): Buffer {
    return Buffer.concat(this.chunks);
  }
}

function readHeader(reader: Reader): { uid: number; gameId: string } {
  let uid = 0;
  let gameId = "100025235";
  while (true) {
    const field = reader.field();
    if (field.type === TYPE.STOP) return { uid, gameId };
    if (field.id === 1 && field.type === TYPE.STRING) uid = Number(reader.string());
    else if (field.id === 2 && field.type === TYPE.STRING) gameId = reader.string();
    else reader.skip(field.type);
  }
}

function readSubmission(reader: Reader): { rankListId: number; score: number; extra: string } {
  let rankListId = 0;
  let score = 0;
  let extra = "";
  while (true) {
    const field = reader.field();
    if (field.type === TYPE.STOP) return { rankListId, score, extra };
    if (field.id === 1 && field.type === TYPE.I32) rankListId = reader.i32();
    else if (field.id === 2 && field.type === TYPE.I32) score = reader.i32();
    else if (field.id === 3 && field.type === TYPE.STRING) extra = reader.string();
    else reader.skip(field.type);
  }
}

function readRequest(body: Buffer): RankRequest {
  const reader = new Reader(body);
  const versionAndType = reader.i32() >>> 0;
  if (((versionAndType & 0xffff0000) >>> 0) !== VERSION_1) throw new Error("Unsupported thrift protocol version");
  const method = reader.string();
  const seqid = reader.i32();
  const request: RankRequest = {
    method,
    seqid,
    uid: 0,
    gameId: "100025235",
    slotIndex: 0,
    rankListId: 0,
    count: 10,
    page: 1,
    username: "",
    submissions: [],
  };
  while (true) {
    const field = reader.field();
    if (field.type === TYPE.STOP) return request;
    if (field.id === 1 && field.type === TYPE.STRUCT) {
      const header = readHeader(reader);
      request.uid = header.uid;
      request.gameId = header.gameId;
    } else if (method === "submit" && field.id === 2 && field.type === TYPE.I32) request.slotIndex = reader.i32();
    else if (method === "submit" && field.id === 3 && field.type === TYPE.LIST) {
      const list = reader.list();
      if (list.type !== TYPE.STRUCT) throw new Error("Invalid rank submission list");
      for (let index = 0; index < list.size; index += 1) request.submissions.push(readSubmission(reader));
    } else if (method === "getRankingByArounds" && field.id === 2 && field.type === TYPE.I32) request.slotIndex = reader.i32();
    else if (method === "getRankingByArounds" && field.id === 3 && field.type === TYPE.I32) request.rankListId = reader.i32();
    else if (method === "getRankingByArounds" && field.id === 4 && field.type === TYPE.I32) request.count = reader.i32();
    else if (method === "getRankingByPage" && field.id === 2 && field.type === TYPE.I32) request.rankListId = reader.i32();
    else if (method === "getRankingByPage" && field.id === 3 && field.type === TYPE.I32) request.count = reader.i32();
    else if (method === "getRankingByPage" && field.id === 4 && field.type === TYPE.I32) request.page = reader.i32();
    else if (method === "getRank" && field.id === 2 && field.type === TYPE.I32) request.rankListId = reader.i32();
    else if (method === "getRank" && field.id === 3 && field.type === TYPE.STRING) request.username = reader.string();
    else reader.skip(field.type);
  }
}

function writeEntry(writer: Writer, entry: RankEntry): void {
  writer.field(TYPE.STRING, 1); writer.string(String(entry.slotIndex));
  writer.field(TYPE.STRING, 2); writer.string(String(entry.uid));
  writer.field(TYPE.STRING, 3); writer.string(entry.username);
  writer.field(TYPE.I32, 4); writer.i32(entry.score);
  writer.field(TYPE.I32, 5); writer.i32(entry.rank);
  writer.field(TYPE.STRING, 6); writer.string(entry.timestamp);
  writer.field(TYPE.STRING, 7); writer.string("");
  if (entry.extra) { writer.field(TYPE.STRING, 8); writer.string(entry.extra); }
  writer.stop();
}

function writeGetResult(method: string, seqid: number, entries: RankEntry[]): Buffer {
  const writer = new Writer();
  writer.message(method, MESSAGE.REPLY, seqid);
  writer.field(TYPE.STRUCT, 0);
  writer.field(TYPE.I32, 1); writer.i32(10000);
  writer.field(TYPE.STRING, 2); writer.string("ok");
  writer.field(TYPE.LIST, 3); writer.list(TYPE.STRUCT, entries.length);
  for (const entry of entries) writeEntry(writer, entry);
  writer.stop();
  writer.stop();
  return writer.buffer();
}

function writeSubmitEntry(writer: Writer, result: RankSubmissionResult): void {
  writer.field(TYPE.I32, 1); writer.i32(10000);
  writer.field(TYPE.STRING, 2); writer.string("ok");
  writer.field(TYPE.STRUCT, 3);
  writer.field(TYPE.I32, 1); writer.i32(result.score);
  writer.field(TYPE.I32, 2); writer.i32(result.rank);
  writer.field(TYPE.I32, 3); writer.i32(result.scoreLast);
  writer.field(TYPE.I32, 4); writer.i32(result.rankLast);
  writer.stop();
  writer.stop();
}

function writeSubmitResult(method: string, seqid: number, results: RankSubmissionResult[]): Buffer {
  const writer = new Writer();
  writer.message(method, MESSAGE.REPLY, seqid);
  writer.field(TYPE.MAP, 0);
  writer.map(TYPE.I32, TYPE.STRUCT, results.length);
  for (const result of results) {
    writer.i32(result.rankListId);
    writeSubmitEntry(writer, result);
  }
  writer.stop();
  return writer.buffer();
}

function writeException(method: string, seqid: number, message: string): Buffer {
  const writer = new Writer();
  writer.message(method, MESSAGE.EXCEPTION, seqid);
  writer.field(TYPE.STRING, 1); writer.string(message);
  writer.field(TYPE.I32, 2); writer.i32(6);
  writer.stop();
  return writer.buffer();
}

export function handleGlobalRankRequest(service: GlobalRankService, player: GlobalPlayer, body: Buffer): { result: string; body: Buffer } {
  let method = "unknown";
  let seqid = 0;
  try {
    const request = readRequest(body);
    method = request.method;
    seqid = request.seqid;
    if (request.uid && request.uid !== player.uid) throw new Error("Rank request UID does not match connected player");
    if (request.gameId !== "100025235") throw new Error("Unsupported game ID");
    if (method === "submit") {
      if (request.submissions.length < 1 || request.submissions.length > 5) throw new Error("Invalid rank submissions");
      const results = service.submit(player.uid, request.slotIndex, request.submissions);
      return { result: "ok", body: writeSubmitResult(method, seqid, results) };
    }
    if (method === "getRankingByArounds") {
      const entries = request.rankListId === ARENA_RANK_LIST_ID
        ? service.getArenaCandidates(request.gameId, player.uid, request.slotIndex, request.count)
        : service.getAround(request.rankListId, player.uid, request.slotIndex, request.count);
      return { result: "ok", body: writeGetResult(method, seqid, entries) };
    }
    if (method === "getRankingByPage") {
      const entries = request.rankListId === ARENA_RANK_LIST_ID && request.page === 95
        ? service.getInitialArenaCandidates(request.gameId, request.count)
        : service.getPage(request.rankListId, request.count, request.page);
      return { result: "ok", body: writeGetResult(method, seqid, entries) };
    }
    if (method === "getRank") {
      return { result: "ok", body: writeGetResult(method, seqid, service.getByUsername(request.rankListId, request.username)) };
    }
    return { result: "unsupported", body: writeException(method, seqid, `Unsupported global rank API: ${method}`) };
  } catch (error) {
    const message = error instanceof Error ? error.message : String(error);
    return { result: "invalid_request", body: writeException(method, seqid, message) };
  }
}
