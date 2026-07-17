import { deflateSync, inflateSync } from "node:zlib";

export type ArenaExtraValue = null | boolean | number | string | ArenaExtraValue[] | { [key: string]: ArenaExtraValue };

type ArenaExtraObject = { [key: string]: ArenaExtraValue };

const DEFAULT_STAT_TEXT = ["0", "0", "0", "0", "0", "0"];
const DEFAULT_EQUIPMENT_FRAMES = Array.from({ length: 17 }, () => -1);

export const DEFAULT_ARENA_EXTRA_VALUE = {
  qsl: 0,
  qsb: 0,
  qls: 0,
  lv: 1,
  ca: -1,
  cb: -1,
  tx: [DEFAULT_STAT_TEXT, DEFAULT_STAT_TEXT],
  jo: 1,
  fe: DEFAULT_EQUIPMENT_FRAMES,
} satisfies ArenaExtraValue;

type Amf3Traits = {
  dynamic: boolean;
  externalizable: boolean;
  sealedNames: string[];
};

class Amf3Reader {
  private offset = 0;
  private readonly stringReferences: string[] = [];
  private readonly objectReferences: ArenaExtraValue[] = [];
  private readonly traitReferences: Amf3Traits[] = [];

  constructor(private readonly buffer: Buffer) {}

  read(): ArenaExtraValue {
    return this.readValue(0);
  }

  private readValue(depth: number): ArenaExtraValue {
    if (depth > 32 || this.offset >= this.buffer.length) {
      throw new Error("Invalid AMF3 value");
    }
    const marker = this.buffer[this.offset++];
    if (marker === 0x00 || marker === 0x01) return null;
    if (marker === 0x02) return false;
    if (marker === 0x03) return true;
    if (marker === 0x04) {
      const value = this.readU29();
      return value & 0x10000000 ? value - 0x20000000 : value;
    }
    if (marker === 0x05) {
      this.ensureAvailable(8);
      const value = this.buffer.readDoubleBE(this.offset);
      this.offset += 8;
      return value;
    }
    if (marker === 0x06) return this.readString();
    if (marker === 0x09) return this.readArray(depth + 1);
    if (marker === 0x0a) return this.readObject(depth + 1);
    throw new Error(`Unsupported AMF3 marker: ${marker}`);
  }

  private readArray(depth: number): ArenaExtraValue {
    const header = this.readU29();
    if ((header & 1) === 0) {
      return this.readObjectReference(header >> 1);
    }
    const length = header >> 1;
    if (length > 1024) throw new Error("AMF3 array too large");
    const value: ArenaExtraValue[] = [];
    this.objectReferences.push(value);
    if (this.readString() !== "") {
      throw new Error("Associative AMF3 arrays are unsupported");
    }
    for (let index = 0; index < length; index += 1) {
      value.push(this.readValue(depth));
    }
    return value;
  }

  private readObject(depth: number): ArenaExtraValue {
    const header = this.readU29();
    if ((header & 1) === 0) {
      return this.readObjectReference(header >> 1);
    }

    let traits: Amf3Traits;
    if ((header & 2) === 0) {
      const traitIndex = header >> 2;
      traits = this.traitReferences[traitIndex];
      if (!traits) throw new Error("Invalid AMF3 trait reference");
    } else {
      this.readString();
      traits = {
        externalizable: (header & 4) !== 0,
        dynamic: (header & 8) !== 0,
        sealedNames: [],
      };
      const sealedCount = header >> 4;
      if (sealedCount > 256) throw new Error("AMF3 object has too many fields");
      for (let index = 0; index < sealedCount; index += 1) {
        traits.sealedNames.push(this.readString());
      }
      this.traitReferences.push(traits);
    }
    if (traits.externalizable) throw new Error("Externalizable AMF3 objects are unsupported");

    const value: ArenaExtraObject = {};
    this.objectReferences.push(value);
    for (const name of traits.sealedNames) {
      value[name] = this.readValue(depth);
    }
    if (traits.dynamic) {
      while (true) {
        const name = this.readString();
        if (!name) break;
        value[name] = this.readValue(depth);
      }
    }
    return value;
  }

  private readString(): string {
    const header = this.readU29();
    if ((header & 1) === 0) {
      const value = this.stringReferences[header >> 1];
      if (value == null) throw new Error("Invalid AMF3 string reference");
      return value;
    }
    const length = header >> 1;
    this.ensureAvailable(length);
    const value = this.buffer.subarray(this.offset, this.offset + length).toString("utf8");
    this.offset += length;
    if (value) this.stringReferences.push(value);
    return value;
  }

  private readU29(): number {
    let value = 0;
    for (let index = 0; index < 4; index += 1) {
      this.ensureAvailable(1);
      const byte = this.buffer[this.offset++];
      if (index === 3) return (value << 8) | byte;
      value = (value << 7) | (byte & 0x7f);
      if ((byte & 0x80) === 0) return value;
    }
    throw new Error("Invalid AMF3 U29 value");
  }

  private readObjectReference(index: number): ArenaExtraValue {
    const value = this.objectReferences[index];
    if (value == null) throw new Error("Invalid AMF3 object reference");
    return value;
  }

  private ensureAvailable(length: number): void {
    if (length < 0 || this.offset + length > this.buffer.length) {
      throw new Error("Unexpected end of AMF3 data");
    }
  }
}

function encodeU29(value: number): Buffer {
  if (!Number.isSafeInteger(value) || value < 0 || value > 0x1fffffff) {
    throw new RangeError(`AMF3 U29 value out of range: ${value}`);
  }
  if (value < 0x80) return Buffer.from([value]);
  if (value < 0x4000) return Buffer.from([(value >> 7) | 0x80, value & 0x7f]);
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

function encodeStringData(value: string): Buffer {
  const bytes = Buffer.from(value, "utf8");
  return Buffer.concat([encodeU29(bytes.length * 2 + 1), bytes]);
}

function encodeAmf3Value(value: ArenaExtraValue): Buffer {
  if (value === null) return Buffer.from([0x01]);
  if (value === false) return Buffer.from([0x02]);
  if (value === true) return Buffer.from([0x03]);
  if (typeof value === "number") {
    if (Number.isInteger(value) && value >= -0x10000000 && value <= 0x0fffffff) {
      return Buffer.concat([Buffer.from([0x04]), encodeU29(value & 0x1fffffff)]);
    }
    const bytes = Buffer.alloc(9);
    bytes[0] = 0x05;
    bytes.writeDoubleBE(value, 1);
    return bytes;
  }
  if (typeof value === "string") {
    return Buffer.concat([Buffer.from([0x06]), encodeStringData(value)]);
  }
  if (Array.isArray(value)) {
    return Buffer.concat([
      Buffer.from([0x09]),
      encodeU29(value.length * 2 + 1),
      encodeStringData(""),
      ...value.map(encodeAmf3Value),
    ]);
  }
  const entries = Object.entries(value);
  return Buffer.concat([
    Buffer.from([0x0a]),
    encodeU29(0x0b),
    encodeStringData(""),
    ...entries.flatMap(([key, entry]) => [encodeStringData(key), encodeAmf3Value(entry)]),
    encodeStringData(""),
  ]);
}

export function encodeArenaExtra(value: ArenaExtraValue = DEFAULT_ARENA_EXTRA_VALUE): string {
  return deflateSync(encodeAmf3Value(value)).toString("base64");
}

function decodeArenaExtra(value: string): ArenaExtraValue {
  return new Amf3Reader(inflateSync(Buffer.from(value, "base64"))).read();
}

function isArenaExtraObject(value: ArenaExtraValue): value is ArenaExtraObject {
  return value !== null && !Array.isArray(value) && typeof value === "object";
}

function finiteNumber(value: ArenaExtraValue | undefined, fallback: number): number {
  return typeof value === "number" && Number.isFinite(value) ? value : fallback;
}

function positiveInteger(value: ArenaExtraValue | undefined, fallback: number): number {
  return typeof value === "number" && Number.isInteger(value) && value >= 1 ? value : fallback;
}

function safeStatRows(value: ArenaExtraValue | undefined): ArenaExtraValue[][] {
  if (!Array.isArray(value)) return [DEFAULT_STAT_TEXT, DEFAULT_STAT_TEXT];
  return [0, 1].map((rowIndex) => {
    const row = value[rowIndex];
    if (!Array.isArray(row)) return [...DEFAULT_STAT_TEXT];
    return Array.from({ length: 6 }, (_, index) => {
      const entry = row[index];
      return typeof entry === "string" || typeof entry === "number" ? entry : "0";
    });
  });
}

function safeEquipmentFrames(value: ArenaExtraValue | undefined): number[] {
  if (!Array.isArray(value)) return [...DEFAULT_EQUIPMENT_FRAMES];
  return Array.from({ length: 17 }, (_, index) => {
    const frame = value[index];
    return typeof frame === "number" && Number.isInteger(frame) && frame >= 1 ? frame : -1;
  });
}

function isDisplaySafe(value: ArenaExtraObject): boolean {
  const petFrame = value.ca;
  const petState = value.cb;
  const stats = value.tx;
  const frames = value.fe;
  return (
    (petFrame === -1 || (typeof petFrame === "number" && Number.isInteger(petFrame) && petFrame >= 1)) &&
    (petFrame === -1
      ? petState === -1
      : typeof petState === "number" && Number.isInteger(petState) && petState >= 1) &&
    Array.isArray(stats) &&
    stats.length >= 2 &&
    stats.slice(0, 2).every((row) => Array.isArray(row) && row.length >= 6) &&
    Array.isArray(frames) &&
    frames.length >= 17 &&
    frames.slice(0, 17).every((frame) => frame === -1 || (typeof frame === "number" && Number.isInteger(frame) && frame >= 1))
  );
}

function hasVisibleStats(value: ArenaExtraObject): boolean {
  if (!Array.isArray(value.tx)) return false;
  return value.tx.slice(0, 2).some((row) => {
    if (!Array.isArray(row)) return false;
    return row.slice(0, 6).some((entry) => {
      if (typeof entry === "number") return Number.isFinite(entry) && entry !== 0;
      if (typeof entry !== "string") return false;
      const numeric = Number(entry.replace(/%$/, "").trim());
      return Number.isFinite(numeric) && numeric !== 0;
    });
  });
}

function hasVisibleEquipment(value: ArenaExtraObject): boolean {
  return Array.isArray(value.fe) && value.fe.slice(0, 17).some((frame) => typeof frame === "number" && frame >= 1);
}

export function hasCompleteArenaDisplay(value: string): boolean {
  try {
    const decoded = decodeArenaExtra(value);
    return isArenaExtraObject(decoded) && isDisplaySafe(decoded) && (hasVisibleStats(decoded) || hasVisibleEquipment(decoded));
  } catch {
    return false;
  }
}

export function normalizeArenaExtra(value: string, username = ""): string {
  let decoded: ArenaExtraObject = {};
  try {
    const candidate = decodeArenaExtra(value);
    if (isArenaExtraObject(candidate)) {
      decoded = candidate;
      if (isDisplaySafe(decoded)) return value;
    }
  } catch {
    decoded = {};
  }

  const normalizedPetFrame = positiveInteger(decoded.ca, -1);
  const normalized: ArenaExtraObject = {
    ...decoded,
    qsl: finiteNumber(decoded.qsl, 0),
    qsb: finiteNumber(decoded.qsb, 0),
    qls: finiteNumber(decoded.qls, 0),
    lv: Math.max(1, finiteNumber(decoded.lv, 1)),
    ca: normalizedPetFrame,
    cb: normalizedPetFrame === -1 ? -1 : positiveInteger(decoded.cb, 1),
    tx: safeStatRows(decoded.tx),
    jo: decoded.jo === 2 ? 2 : 1,
    fe: safeEquipmentFrames(decoded.fe),
  };
  if (typeof normalized.newne !== "string" && typeof normalized.ne !== "string" && username) {
    normalized.ne = username;
  }
  return encodeArenaExtra(normalized);
}

export function resetArenaExtraForNewSeason(value: string, username = ""): string {
  const normalized = decodeArenaExtra(normalizeArenaExtra(value, username));
  if (!isArenaExtraObject(normalized)) {
    return normalizeArenaExtra("", username);
  }
  return encodeArenaExtra({ ...normalized, qsl: 0, qsb: 0, qls: 0 });
}
