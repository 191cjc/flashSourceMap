import { type DecodedSwf, parseTags } from "./swf.js";

type Multiname = {
  kind: number;
  qname?: string;
  ns?: number;
  name?: number;
  nsset?: number;
  qnameIndex?: number;
  params?: number[];
};

type AbcMethod = {
  index: number;
  params: number[];
  paramOffsets: number[];
  name: string;
};

type AbcMethodBody = {
  method: number;
  codeStart: number;
  code: Buffer;
};

type Abc = {
  strings: string[];
  namespaces: Array<{ kind: number; name: number; value: string } | null>;
  namespaceSets: Array<number[] | null>;
  multinames: Array<Multiname | null>;
  methods: AbcMethod[];
  methodBodies: AbcMethodBody[];
};

class Reader {
  constructor(readonly buffer: Buffer, public offset = 0) {}

  u8(): number {
    return this.buffer[this.offset++];
  }

  u16(): number {
    const value = this.buffer.readUInt16LE(this.offset);
    this.offset += 2;
    return value;
  }

  u30(): number {
    let value = 0;
    for (let i = 0; i < 5; i += 1) {
      const byte = this.u8();
      value |= (byte & 0x7f) << (7 * i);
      if ((byte & 0x80) === 0) {
        return value >>> 0;
      }
    }
    return value >>> 0;
  }

  bytes(length: number): Buffer {
    const value = this.buffer.subarray(this.offset, this.offset + length);
    this.offset += length;
    return value;
  }

  cstr(): string {
    const start = this.offset;
    while (this.offset < this.buffer.length && this.buffer[this.offset] !== 0) {
      this.offset += 1;
    }
    const value = this.buffer.subarray(start, this.offset).toString("utf8");
    this.offset += 1;
    return value;
  }
}

function qname(multiname: Multiname | null | undefined): string {
  return multiname?.qname ?? "";
}

function isRuffleCrossSwfEventQname(value: string): boolean {
  return (
    value === "unit4399.events::PayEvent" ||
    value === "unit4399.events.PayEvent" ||
    value === "unit4399.events::UnionEvent" ||
    value === "unit4399.events.UnionEvent"
  );
}

function skipMetadata(reader: Reader): void {
  const metadataCount = reader.u30();
  for (let i = 0; i < metadataCount; i += 1) {
    reader.u30();
    const itemCount = reader.u30();
    for (let j = 0; j < itemCount; j += 1) {
      reader.u30();
      reader.u30();
    }
  }
}

function readTraits(reader: Reader): void {
  const traitCount = reader.u30();
  for (let i = 0; i < traitCount; i += 1) {
    reader.u30();
    const tag = reader.u8();
    const kind = tag & 0x0f;
    const attrs = tag >> 4;

    if (kind === 0 || kind === 6) {
      reader.u30();
      reader.u30();
      const valueIndex = reader.u30();
      if (valueIndex !== 0) {
        reader.u8();
      }
    } else if (kind === 1 || kind === 2 || kind === 3 || kind === 5) {
      reader.u30();
      reader.u30();
    } else if (kind === 4) {
      reader.u30();
      reader.u30();
    } else {
      throw new Error(`Unsupported ABC trait kind: ${kind}`);
    }

    if ((attrs & 0x04) !== 0) {
      const metadataCount = reader.u30();
      for (let j = 0; j < metadataCount; j += 1) {
        reader.u30();
      }
    }
  }
}

function parseAbc(buffer: Buffer): Abc {
  const reader = new Reader(buffer);
  reader.u16();
  reader.u16();

  let count = reader.u30();
  for (let i = 1; i < count; i += 1) {
    reader.u30();
  }

  count = reader.u30();
  for (let i = 1; i < count; i += 1) {
    reader.u30();
  }

  count = reader.u30();
  reader.offset += Math.max(0, count - 1) * 8;

  const strings = [""];
  count = reader.u30();
  for (let i = 1; i < count; i += 1) {
    strings[i] = reader.bytes(reader.u30()).toString("utf8");
  }

  const namespaces: Abc["namespaces"] = [null];
  count = reader.u30();
  for (let i = 1; i < count; i += 1) {
    const kind = reader.u8();
    const name = reader.u30();
    namespaces[i] = { kind, name, value: strings[name] ?? "" };
  }

  const namespaceSets: Abc["namespaceSets"] = [null];
  count = reader.u30();
  for (let i = 1; i < count; i += 1) {
    const setCount = reader.u30();
    const set: number[] = [];
    for (let j = 0; j < setCount; j += 1) {
      set.push(reader.u30());
    }
    namespaceSets[i] = set;
  }

  const multinames: Abc["multinames"] = [null];
  count = reader.u30();
  for (let i = 1; i < count; i += 1) {
    const kind = reader.u8();
    const item: Multiname = { kind };

    if (kind === 0x07 || kind === 0x0d) {
      item.ns = reader.u30();
      item.name = reader.u30();
      item.qname = `${namespaces[item.ns]?.value ?? ""}::${strings[item.name] ?? ""}`;
    } else if (kind === 0x0f || kind === 0x10) {
      item.name = reader.u30();
      item.qname = `*::${strings[item.name] ?? ""}`;
    } else if (kind === 0x11 || kind === 0x12) {
      item.qname = "*::*";
    } else if (kind === 0x09 || kind === 0x0e) {
      item.name = reader.u30();
      item.nsset = reader.u30();
      const nsValues = (namespaceSets[item.nsset] ?? []).map((index) => namespaces[index]?.value ?? "");
      item.qname = `{${nsValues.join(",")}}::${strings[item.name] ?? ""}`;
    } else if (kind === 0x1b || kind === 0x1c) {
      item.nsset = reader.u30();
      const nsValues = (namespaceSets[item.nsset] ?? []).map((index) => namespaces[index]?.value ?? "");
      item.qname = `{${nsValues.join(",")}}::*`;
    } else if (kind === 0x1d) {
      item.qnameIndex = reader.u30();
      const paramCount = reader.u30();
      item.params = [];
      for (let j = 0; j < paramCount; j += 1) {
        item.params.push(reader.u30());
      }
      item.qname = `TypeName(${item.qnameIndex})`;
    } else {
      throw new Error(`Unsupported ABC multiname kind: ${kind}`);
    }

    multinames[i] = item;
  }

  const methodCount = reader.u30();
  const methods: AbcMethod[] = [];
  for (let i = 0; i < methodCount; i += 1) {
    const paramCount = reader.u30();
    reader.u30();
    const params: number[] = [];
    const paramOffsets: number[] = [];

    for (let j = 0; j < paramCount; j += 1) {
      paramOffsets.push(reader.offset);
      params.push(reader.u30());
    }

    const name = reader.u30();
    const flags = reader.u8();
    if ((flags & 0x08) !== 0) {
      const optionCount = reader.u30();
      for (let j = 0; j < optionCount; j += 1) {
        reader.u30();
        reader.u8();
      }
    }
    if ((flags & 0x80) !== 0) {
      for (let j = 0; j < paramCount; j += 1) {
        reader.u30();
      }
    }

    methods.push({ index: i, params, paramOffsets, name: strings[name] ?? "" });
  }

  skipMetadata(reader);

  const classCount = reader.u30();
  for (let i = 0; i < classCount; i += 1) {
    reader.u30();
    reader.u30();
    const flags = reader.u8();
    if ((flags & 0x08) !== 0) {
      reader.u30();
    }
    const interfaceCount = reader.u30();
    for (let j = 0; j < interfaceCount; j += 1) {
      reader.u30();
    }
    reader.u30();
    readTraits(reader);
  }

  for (let i = 0; i < classCount; i += 1) {
    reader.u30();
    readTraits(reader);
  }

  const scriptCount = reader.u30();
  for (let i = 0; i < scriptCount; i += 1) {
    reader.u30();
    readTraits(reader);
  }

  const methodBodyCount = reader.u30();
  const methodBodies: AbcMethodBody[] = [];
  for (let i = 0; i < methodBodyCount; i += 1) {
    const method = reader.u30();
    reader.u30();
    reader.u30();
    reader.u30();
    reader.u30();
    const codeLength = reader.u30();
    const codeStart = reader.offset;
    const code = reader.bytes(codeLength);
    const exceptionCount = reader.u30();
    for (let j = 0; j < exceptionCount; j += 1) {
      reader.u30();
      reader.u30();
      reader.u30();
      reader.u30();
      reader.u30();
    }
    readTraits(reader);
    methodBodies.push({ method, codeStart, code });
  }

  return { strings, namespaces, namespaceSets, multinames, methods, methodBodies };
}

function readU30At(buffer: Buffer, offset: number): { value: number; length: number } {
  let value = 0;
  for (let i = 0; i < 5; i += 1) {
    const byte = buffer[offset + i];
    value |= (byte & 0x7f) << (7 * i);
    if ((byte & 0x80) === 0) {
      return { value: value >>> 0, length: i + 1 };
    }
  }
  throw new Error(`Invalid U30 at bytecode offset ${offset}`);
}

function doAbcStart(data: Buffer): number {
  const reader = new Reader(data);
  reader.u8();
  reader.u8();
  reader.u8();
  reader.u8();
  reader.cstr();
  return reader.offset;
}

export function patchRuffleEventCompatibility(swf: DecodedSwf): number {
  let patchCount = 0;

  for (const tag of parseTags(swf.body)) {
    if (tag.code !== 82) {
      continue;
    }

    const abcRelativeStart = doAbcStart(tag.data);
    const abc = parseAbc(tag.data.subarray(abcRelativeStart));
    const abcStart = tag.dataOffset + abcRelativeStart;
    const eventMultinames = new Set<number>();

    for (let i = 1; i < abc.multinames.length; i += 1) {
      if (isRuffleCrossSwfEventQname(qname(abc.multinames[i]))) {
        eventMultinames.add(i);
      }
    }

    if (eventMultinames.size === 0) {
      continue;
    }

    for (const method of abc.methods) {
      for (let index = 0; index < method.params.length; index += 1) {
        if (!eventMultinames.has(method.params[index])) {
          continue;
        }

        const offset = abcStart + method.paramOffsets[index];
        if ((swf.body[offset] & 0x80) !== 0) {
          throw new Error(`Event type index at ${offset} is not a one-byte U30`);
        }
        if (swf.body[offset] !== 0x00) {
          swf.body[offset] = 0x00;
          patchCount += 1;
        }
      }
    }

    for (const body of abc.methodBodies) {
      for (let cursor = 0; cursor < body.code.length - 1; cursor += 1) {
        const op = body.code[cursor];
        if (op !== 0x80 && op !== 0x86) {
          continue;
        }

        let operand: { value: number; length: number };
        try {
          operand = readU30At(body.code, cursor + 1);
        } catch {
          continue;
        }
        if (!eventMultinames.has(operand.value)) {
          continue;
        }

        const offset = abcStart + body.codeStart + cursor;
        swf.body[offset] = 0x82;
        for (let i = 1; i < 1 + operand.length; i += 1) {
          swf.body[offset + i] = 0x02;
        }
        patchCount += 1;
      }
    }
  }

  return patchCount;
}

export const patchPayEventCompatibility = patchRuffleEventCompatibility;
