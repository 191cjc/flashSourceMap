import { type DecodedSwf, parseTags } from "./swf.js";

export const ZODIAC_SOUL_TARGET_LEVEL = 100;
export const ZODIAC_SOUL_TARGET_UP_LIMIT = 3;

const ZODIAC_SOUL_ADD_EXP_METHOD = "hotpointgame.savedatal::ShengxiaoDouHun::::addExp";
const ZODIAC_SOUL_GET_LEVEL_UP_METHOD = "hotpointgame.savedatal::ShengxiaoDouHun::::getLevelUp";

type Multiname = {
  kind: number;
  qname?: string;
  ns?: number;
  name?: number;
  nsset?: number;
  qnameIndex?: number;
  params?: number[];
};

type Trait = {
  name: number;
  kind: number;
  method?: number;
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
  instances: Array<{ name: number; iinit: number; traits: Trait[] }>;
  classes: Array<{ cinit: number; traits: Trait[] }>;
  scripts: Array<{ init: number; traits: Trait[] }>;
  methodBodies: AbcMethodBody[];
};

type DecodedInstruction = {
  offset: number;
  op: number;
  name: string;
  length: number;
  operands: number[];
};

export type ZodiacSoulExpOptimizationInspection = {
  targetFound: boolean;
  optimized: boolean;
};

class Reader {
  constructor(readonly buffer: Buffer, public offset = 0) {}

  u8(): number {
    return this.buffer[this.offset++] ?? 0;
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
    throw new Error(`Invalid U30 at ABC offset ${this.offset - 5}`);
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

function readTraits(reader: Reader): Trait[] {
  const traits: Trait[] = [];
  const traitCount = reader.u30();
  for (let i = 0; i < traitCount; i += 1) {
    const name = reader.u30();
    const tag = reader.u8();
    const kind = tag & 0x0f;
    const attrs = tag >> 4;
    const trait: Trait = { name, kind };

    if (kind === 0 || kind === 6) {
      reader.u30();
      reader.u30();
      const valueIndex = reader.u30();
      if (valueIndex !== 0) {
        reader.u8();
      }
    } else if (kind === 1 || kind === 2 || kind === 3) {
      reader.u30();
      trait.method = reader.u30();
    } else if (kind === 4) {
      reader.u30();
      reader.u30();
    } else if (kind === 5) {
      reader.u30();
      trait.method = reader.u30();
    } else {
      throw new Error(`Unsupported ABC trait kind: ${kind}`);
    }

    if ((attrs & 0x04) !== 0) {
      const metadataCount = reader.u30();
      for (let j = 0; j < metadataCount; j += 1) {
        reader.u30();
      }
    }

    traits.push(trait);
  }
  return traits;
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
  for (let i = 0; i < methodCount; i += 1) {
    const paramCount = reader.u30();
    reader.u30();
    for (let j = 0; j < paramCount; j += 1) {
      reader.u30();
    }
    reader.u30();
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
  }

  skipMetadata(reader);

  const instances: Abc["instances"] = [];
  const classCount = reader.u30();
  for (let i = 0; i < classCount; i += 1) {
    const name = reader.u30();
    reader.u30();
    const flags = reader.u8();
    if ((flags & 0x08) !== 0) {
      reader.u30();
    }
    const interfaceCount = reader.u30();
    for (let j = 0; j < interfaceCount; j += 1) {
      reader.u30();
    }
    const iinit = reader.u30();
    const traits = readTraits(reader);
    instances.push({ name, iinit, traits });
  }

  const classes: Abc["classes"] = [];
  for (let i = 0; i < classCount; i += 1) {
    const cinit = reader.u30();
    const traits = readTraits(reader);
    classes.push({ cinit, traits });
  }

  const scripts: Abc["scripts"] = [];
  const scriptCount = reader.u30();
  for (let i = 0; i < scriptCount; i += 1) {
    const init = reader.u30();
    const traits = readTraits(reader);
    scripts.push({ init, traits });
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

  return { strings, namespaces, namespaceSets, multinames, instances, classes, scripts, methodBodies };
}

function buildMethodNames(abc: Abc): Map<number, string[]> {
  const names = new Map<number, string[]>();
  const add = (methodIndex: number | undefined, value: string): void => {
    if (methodIndex == null || methodIndex < 0) {
      return;
    }
    const list = names.get(methodIndex) ?? [];
    if (!list.includes(value)) {
      list.push(value);
    }
    names.set(methodIndex, list);
  };

  for (let classIndex = 0; classIndex < abc.instances.length; classIndex += 1) {
    const instance = abc.instances[classIndex];
    const className = qname(abc.multinames[instance.name]) || `(class#${instance.name})`;
    add(instance.iinit, `${className}::<init>`);
    add(abc.classes[classIndex]?.cinit, `${className}::<static>`);
    for (const trait of instance.traits) {
      if (trait.method != null) {
        add(trait.method, `${className}::${qname(abc.multinames[trait.name]) || trait.name}`);
      }
    }
    for (const trait of abc.classes[classIndex]?.traits ?? []) {
      if (trait.method != null) {
        add(trait.method, `${className}::static::${qname(abc.multinames[trait.name]) || trait.name}`);
      }
    }
  }

  for (let i = 0; i < abc.scripts.length; i += 1) {
    const script = abc.scripts[i];
    if (!script) {
      continue;
    }
    add(script.init, `(script#${i})::<init>`);
    for (const trait of script.traits) {
      if (trait.method != null) {
        add(trait.method, `(script#${i})::${qname(abc.multinames[trait.name]) || trait.name}`);
      }
    }
  }

  return names;
}

function methodBodyFor(abc: Abc, ownerName: string): AbcMethodBody | null {
  const names = buildMethodNames(abc);
  for (const body of abc.methodBodies) {
    if ((names.get(body.method) ?? []).includes(ownerName)) {
      return body;
    }
  }
  return null;
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
  throw new Error(`Invalid U30 at byte offset ${offset}`);
}

function encodeU30(value: number): Buffer {
  const bytes: number[] = [];
  let current = value >>> 0;
  do {
    let byte = current & 0x7f;
    current >>>= 7;
    if (current !== 0) {
      byte |= 0x80;
    }
    bytes.push(byte);
  } while (current !== 0);
  return Buffer.from(bytes);
}

function readS24(buffer: Buffer, offset: number): number {
  const value = buffer[offset] | ((buffer[offset + 1] ?? 0) << 8) | ((buffer[offset + 2] ?? 0) << 16);
  return value & 0x800000 ? value | ~0xffffff : value;
}

function skipU30Operands(buffer: Buffer, offset: number, count: number): { length: number; operands: number[] } {
  let cursor = offset;
  const operands: number[] = [];
  for (let i = 0; i < count; i += 1) {
    const decoded = readU30At(buffer, cursor);
    operands.push(decoded.value);
    cursor += decoded.length;
  }
  return { length: cursor - offset, operands };
}

const opNames: Record<number, string> = {
  0x02: "nop",
  0x10: "jump",
  0x11: "iftrue",
  0x12: "iffalse",
  0x14: "ifne",
  0x16: "ifle",
  0x17: "ifgt",
  0x18: "ifge",
  0x24: "pushbyte",
  0x25: "pushshort",
  0x29: "pop",
  0x2c: "pushstring",
  0x30: "pushscope",
  0x46: "callproperty",
  0x47: "returnvoid",
  0x48: "returnvalue",
  0x4f: "callpropvoid",
  0x5d: "findpropstrict",
  0x60: "getlex",
  0x61: "setproperty",
  0x62: "getlocal",
  0x63: "setlocal",
  0x66: "getproperty",
  0x68: "initproperty",
  0x73: "convert_i",
  0xa0: "add",
  0xa1: "subtract",
  0xa2: "multiply",
  0xd0: "getlocal0",
  0xd1: "getlocal1",
  0xd2: "getlocal2",
  0xd3: "getlocal3",
  0xd4: "setlocal0",
  0xd5: "setlocal1",
  0xd6: "setlocal2",
  0xd7: "setlocal3",
};

function decodeInstruction(code: Buffer, offset: number): DecodedInstruction {
  const op = code[offset] ?? 0;
  const name = opNames[op] || `op_${op.toString(16).padStart(2, "0")}`;

  if (op >= 0xd0 && op <= 0xd7) {
    return { offset, op, name, length: 1, operands: [] };
  }
  if (op === 0x24 || op === 0x65) {
    return { offset, op, name, length: 2, operands: [code[offset + 1] ?? 0] };
  }
  if ((op >= 0x0c && op <= 0x1a) || op === 0x10) {
    return { offset, op, name, length: 4, operands: [readS24(code, offset + 1)] };
  }
  if (
    [
      0x04, 0x05, 0x06, 0x08, 0x25, 0x2c, 0x2d, 0x2e, 0x2f, 0x31, 0x40, 0x49, 0x53, 0x55, 0x56,
      0x58, 0x59, 0x5a, 0x5d, 0x5e, 0x5f, 0x60, 0x61, 0x62, 0x63, 0x66, 0x68, 0x6a, 0x6c,
      0x6d, 0x6e, 0x6f, 0x80, 0x85, 0x86, 0x92, 0x94, 0xb2, 0xc2, 0xc3,
    ].includes(op)
  ) {
    const operand = readU30At(code, offset + 1);
    return { offset, op, name, length: 1 + operand.length, operands: [operand.value] };
  }
  if ([0x32, 0x43, 0x44, 0x45, 0x46, 0x4a, 0x4c, 0x4e, 0x4f].includes(op)) {
    const decoded = skipU30Operands(code, offset + 1, 2);
    return { offset, op, name, length: 1 + decoded.length, operands: decoded.operands };
  }
  return { offset, op, name, length: 1, operands: [] };
}

function instructionsFor(body: AbcMethodBody): DecodedInstruction[] {
  const instructions: DecodedInstruction[] = [];
  let cursor = 0;
  while (cursor < body.code.length) {
    const decoded = decodeInstruction(body.code, cursor);
    instructions.push(decoded);
    cursor += Math.max(1, decoded.length);
  }
  return instructions;
}

function instructionQnameEndsWith(abc: Abc, instruction: DecodedInstruction | undefined, suffix: string): boolean {
  if (!instruction || instruction.operands.length === 0) {
    return false;
  }
  return qname(abc.multinames[instruction.operands[0]]).endsWith(suffix);
}

function multinameIndexEndingWith(abc: Abc, suffix: string): number {
  const index = abc.multinames.findIndex((multiname) => qname(multiname).endsWith(suffix));
  if (index < 1) {
    throw new Error(`Unable to find ABC multiname ending with ${suffix}`);
  }
  return index;
}

function instruction(op: number, ...operands: number[]): Buffer {
  return Buffer.concat([Buffer.from([op]), ...operands.map((operand) => encodeU30(operand))]);
}

function pushIntLiteral(value: number): Buffer {
  if (value >= -128 && value <= 127) {
    return Buffer.from([0x24, value & 0xff]);
  }
  return Buffer.concat([Buffer.from([0x25]), encodeU30(value)]);
}

function nextNonNop(instructions: DecodedInstruction[], startIndex: number): number {
  let index = startIndex;
  while (instructions[index]?.name === "nop") {
    index += 1;
  }
  return index;
}

function propertySetCode(abc: Abc, propertySuffix: string, value: number): Buffer {
  return Buffer.concat([
    Buffer.from([0xd0]),
    pushIntLiteral(value),
    instruction(0x68, multinameIndexEndingWith(abc, propertySuffix)),
  ]);
}

function replaceBodyWithPrefix(body: AbcMethodBody, replacement: Buffer, targetDescription: string): void {
  if (replacement.length > body.code.length) {
    throw new Error(`${targetDescription} replacement is longer than method body: ${replacement.length} > ${body.code.length}`);
  }
  replacement.copy(body.code, 0);
  body.code.fill(0x02, replacement.length);
}

function buildDirectMaxAddExpCode(abc: Abc): Buffer {
  return Buffer.concat([
    Buffer.from([0xd0, 0x30]),
    propertySetCode(abc, "::uplvLimit", ZODIAC_SOUL_TARGET_UP_LIMIT),
    propertySetCode(abc, "::curlevel", ZODIAC_SOUL_TARGET_LEVEL),
    propertySetCode(abc, "::curExp", 0),
    Buffer.from([0x47]),
  ]);
}

function buildDirectMaxGetLevelUpCode(): Buffer {
  return Buffer.concat([
    Buffer.from([0xd0, 0x30]),
    pushIntLiteral(ZODIAC_SOUL_TARGET_LEVEL),
    Buffer.from([0x48]),
  ]);
}

function isDirectMaxAddExpBody(abc: Abc, body: AbcMethodBody): boolean {
  const instructions = instructionsFor(body);
  let index = nextNonNop(instructions, 0);
  if (instructions[index]?.name !== "getlocal0" || instructions[index + 1]?.name !== "pushscope") {
    return false;
  }
  index += 2;
  const hasSet = (propertySuffix: string, value: number): boolean => {
    const target = instructions[index];
    const literal = instructions[index + 1];
    const setter = instructions[index + 2];
    const ok = target?.name === "getlocal0" &&
      literal?.name === "pushbyte" &&
      literal.operands[0] === value &&
      setter?.name === "initproperty" &&
      instructionQnameEndsWith(abc, setter, propertySuffix);
    index += 3;
    return ok;
  };

  return hasSet("::uplvLimit", ZODIAC_SOUL_TARGET_UP_LIMIT) &&
    hasSet("::curlevel", ZODIAC_SOUL_TARGET_LEVEL) &&
    hasSet("::curExp", 0) &&
    instructions[index]?.name === "returnvoid";
}

function isDirectMaxGetLevelUpBody(body: AbcMethodBody): boolean {
  const instructions = instructionsFor(body);
  const index = nextNonNop(instructions, 0);
  return instructions[index]?.name === "getlocal0" &&
    instructions[index + 1]?.name === "pushscope" &&
    instructions[index + 2]?.name === "pushbyte" &&
    instructions[index + 2].operands[0] === ZODIAC_SOUL_TARGET_LEVEL &&
    instructions[index + 3]?.name === "returnvalue";
}

function patchZodiacSoulAddExpBody(abc: Abc, body: AbcMethodBody, mutate: boolean): { patched: boolean; optimized: boolean } {
  if (isDirectMaxAddExpBody(abc, body)) {
    return { patched: false, optimized: true };
  }
  if (!mutate) {
    return { patched: false, optimized: false };
  }
  replaceBodyWithPrefix(body, buildDirectMaxAddExpCode(abc), "Zodiac soul addExp");
  return { patched: true, optimized: true };
}

function patchZodiacSoulGetLevelUpBody(body: AbcMethodBody, mutate: boolean): { patched: boolean; optimized: boolean } {
  if (isDirectMaxGetLevelUpBody(body)) {
    return { patched: false, optimized: true };
  }
  if (!mutate) {
    return { patched: false, optimized: false };
  }
  replaceBodyWithPrefix(body, buildDirectMaxGetLevelUpCode(), "Zodiac soul getLevelUp");
  return { patched: true, optimized: true };
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

function inspectDoAbcData(data: Buffer, patch: boolean): { targetFound: boolean; optimized: boolean; patchCount: number } {
  const abcRelativeStart = doAbcStart(data);
  const abc = parseAbc(data.subarray(abcRelativeStart));
  const addExpBody = methodBodyFor(abc, ZODIAC_SOUL_ADD_EXP_METHOD);
  const getLevelUpBody = methodBodyFor(abc, ZODIAC_SOUL_GET_LEVEL_UP_METHOD);
  if (!addExpBody || !getLevelUpBody) {
    return { targetFound: false, optimized: false, patchCount: 0 };
  }

  const addExpResult = patchZodiacSoulAddExpBody(abc, addExpBody, patch);
  const getLevelUpResult = patchZodiacSoulGetLevelUpBody(getLevelUpBody, patch);

  return {
    targetFound: true,
    optimized: addExpResult.optimized && getLevelUpResult.optimized,
    patchCount: Number(addExpResult.patched) + Number(getLevelUpResult.patched),
  };
}

export function inspectZodiacSoulExpOptimization(swf: DecodedSwf): ZodiacSoulExpOptimizationInspection {
  for (const tag of parseTags(swf.body)) {
    if (tag.code !== 82) {
      continue;
    }
    const inspected = inspectDoAbcData(tag.data, false);
    if (inspected.targetFound) {
      return { targetFound: true, optimized: inspected.optimized };
    }
  }
  return { targetFound: false, optimized: false };
}

export function patchZodiacSoulExpOptimization(swf: DecodedSwf): number {
  let patchCount = 0;
  for (const tag of parseTags(swf.body)) {
    if (tag.code !== 82) {
      continue;
    }
    const inspected = inspectDoAbcData(tag.data, true);
    patchCount += inspected.patchCount;
  }
  return patchCount;
}
