import { inflateSync } from "node:zlib";

export type SwfTag = {
  code: number;
  length: number;
  offset: number;
  dataOffset: number;
  data: Buffer;
};

export type DecodedSwf = {
  signature: string;
  version: number;
  declaredLength: number;
  body: Buffer;
};

function readRectByteLength(buffer: Buffer, offset: number): number {
  const nbits = buffer[offset] >> 3;
  const totalBits = 5 + nbits * 4;
  return Math.ceil(totalBits / 8);
}

export function decodeSwf(file: Buffer): DecodedSwf {
  if (file.length < 8) {
    throw new Error("SWF file is too short");
  }

  const signature = file.subarray(0, 3).toString("ascii");
  const version = file[3];
  const declaredLength = file.readUInt32LE(4);

  if (signature === "FWS") {
    return {
      signature,
      version,
      declaredLength,
      body: file.subarray(8),
    };
  }

  if (signature === "CWS") {
    return {
      signature,
      version,
      declaredLength,
      body: inflateSync(file.subarray(8)),
    };
  }

  throw new Error(`Unsupported SWF signature: ${signature}`);
}

export function parseTags(body: Buffer): SwfTag[] {
  const rectLength = readRectByteLength(body, 0);
  let offset = rectLength + 4;
  const tags: SwfTag[] = [];

  while (offset + 2 <= body.length) {
    const headerOffset = offset;
    const tagHeader = body.readUInt16LE(offset);
    offset += 2;

    const code = tagHeader >> 6;
    let length = tagHeader & 0x3f;
    if (length === 0x3f) {
      if (offset + 4 > body.length) {
        throw new Error(`Truncated long tag header at ${headerOffset}`);
      }
      length = body.readUInt32LE(offset);
      offset += 4;
    }

    if (offset + length > body.length) {
      throw new Error(`Tag ${code} at ${headerOffset} exceeds body length`);
    }

    const dataOffset = offset;
    const data = body.subarray(offset, offset + length);
    tags.push({ code, length, offset: headerOffset, dataOffset, data });
    offset += length;

    if (code === 0) {
      break;
    }
  }

  return tags;
}

export function isSwfBuffer(buffer: Buffer): boolean {
  const signature = buffer.subarray(0, 3).toString("ascii");
  return signature === "FWS" || signature === "CWS" || signature === "ZWS";
}
