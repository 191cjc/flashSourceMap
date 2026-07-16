import { deflateSync, inflateSync } from "node:zlib";

export type ArenaExtraValue = null | boolean | number | string | ArenaExtraValue[] | { [key: string]: ArenaExtraValue };

export const DEFAULT_ARENA_EXTRA_VALUE = {
  qsl: 0,
  qsb: 0,
  qls: 0,
  lv: 1,
  ca: 0,
  cb: 0,
  tx: [],
  jo: 1,
  fe: [],
} satisfies ArenaExtraValue;

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

export function isEncodedArenaExtra(value: string): boolean {
  if (!value || !/^[A-Za-z0-9+/]+={0,2}$/.test(value)) return false;
  try {
    return inflateSync(Buffer.from(value, "base64"))[0] === 0x0a;
  } catch {
    return false;
  }
}

export const DEFAULT_ARENA_EXTRA = encodeArenaExtra();
