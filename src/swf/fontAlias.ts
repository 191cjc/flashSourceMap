import { type DecodedSwf, parseTags } from "./swf.js";

function encodeTag(code: number, payload: Buffer): Buffer {
  if (payload.length < 0x3f) {
    const header = Buffer.alloc(2);
    header.writeUInt16LE((code << 6) | payload.length, 0);
    return Buffer.concat([header, payload]);
  }

  const header = Buffer.alloc(6);
  header.writeUInt16LE((code << 6) | 0x3f, 0);
  header.writeUInt32LE(payload.length, 2);
  return Buffer.concat([header, payload]);
}

function nullTerminatedSwfNameBytes(fontName: string): Buffer {
  return Buffer.concat([Buffer.from(fontName, "utf8"), Buffer.from([0])]);
}

type FontAliasOptions = {
  bold?: boolean;
};

function replaceDefineFont2Or3Name(data: Buffer, fontId: number, fontName: string, options: FontAliasOptions): Buffer | null {
  if (data.length < 6 || data.readUInt16LE(0) !== fontId) {
    return null;
  }

  const oldNameLength = data[4];
  const oldNameEnd = 5 + oldNameLength;
  if (oldNameEnd > data.length) {
    return null;
  }

  const nextName = Buffer.from(fontName, "utf8");
  if (nextName.length > 0xff) {
    throw new Error(`SWF font name is too long: ${fontName}`);
  }

  const flags = Buffer.from(data.subarray(2, 4));
  if (options.bold != null) {
    flags[0] = options.bold ? flags[0] | 0x01 : flags[0] & ~0x01;
  }

  return Buffer.concat([data.subarray(0, 2), flags, Buffer.from([nextName.length]), nextName, data.subarray(oldNameEnd)]);
}

function replaceDefineFontName(data: Buffer, fontId: number, fontName: string): Buffer | null {
  if (data.length < 4 || data.readUInt16LE(0) !== fontId) {
    return null;
  }

  let copyrightStart = 2;
  while (copyrightStart < data.length && data[copyrightStart] !== 0) {
    copyrightStart += 1;
  }
  if (copyrightStart >= data.length) {
    return null;
  }
  copyrightStart += 1;

  return Buffer.concat([data.subarray(0, 2), nullTerminatedSwfNameBytes(fontName), data.subarray(copyrightStart)]);
}

export function aliasSwfFontName(swf: DecodedSwf, fontId: number, fontName: string, options: FontAliasOptions = {}): number {
  const tags = parseTags(swf.body);
  const firstTagOffset = tags[0]?.offset;
  if (firstTagOffset == null) {
    throw new Error("SWF has no tags");
  }

  const chunks = [swf.body.subarray(0, firstTagOffset)];
  let replacements = 0;

  for (const tag of tags) {
    const originalEnd = tag.dataOffset + tag.length;
    let replacement: Buffer | null = null;

    if (tag.code === 48 || tag.code === 75) {
      replacement = replaceDefineFont2Or3Name(tag.data, fontId, fontName, options);
    } else if (tag.code === 88) {
      replacement = replaceDefineFontName(tag.data, fontId, fontName);
    }

    if (replacement) {
      chunks.push(encodeTag(tag.code, replacement));
      replacements += 1;
    } else {
      chunks.push(swf.body.subarray(tag.offset, originalEnd));
    }
  }

  swf.body = Buffer.concat(chunks);
  return replacements;
}
