import { type DecodedSwf, parseTags } from "./swf.js";

const UNION_PAGE_SIZE = 10;
const UNION_LIST_INIT_METHOD = "hotpointgame.views.unionPanel::UnionSqPanel::::initUnion";

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
  code: Buffer;
};

type Abc = {
  strings: string[];
  namespaces: Array<{ value: string } | null>;
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

export type EmptyUnionListCompatibilityInspection = {
  targetFound: boolean;
  pageSizeSafe: boolean;
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
    for (let index = 0; index < 5; index += 1) {
      const byte = this.u8();
      value |= (byte & 0x7f) << (7 * index);
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
  for (let index = 0; index < metadataCount; index += 1) {
    reader.u30();
    const itemCount = reader.u30();
    for (let item = 0; item < itemCount; item += 1) {
      reader.u30();
      reader.u30();
    }
  }
}

function readTraits(reader: Reader): Trait[] {
  const traits: Trait[] = [];
  const traitCount = reader.u30();
  for (let index = 0; index < traitCount; index += 1) {
    const name = reader.u30();
    const tag = reader.u8();
    const kind = tag & 0x0f;
    const attrs = tag >> 4;
    const trait: Trait = { name, kind };
    if (kind === 0 || kind === 6) {
      reader.u30();
      reader.u30();
      if (reader.u30() !== 0) {
        reader.u8();
      }
    } else if (kind === 1 || kind === 2 || kind === 3 || kind === 5) {
      reader.u30();
      trait.method = reader.u30();
    } else if (kind === 4) {
      reader.u30();
      reader.u30();
    } else {
      throw new Error(`Unsupported ABC trait kind: ${kind}`);
    }
    if ((attrs & 0x04) !== 0) {
      const metadataCount = reader.u30();
      for (let item = 0; item < metadataCount; item += 1) {
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
  for (let index = 1; index < count; index += 1) reader.u30();
  count = reader.u30();
  for (let index = 1; index < count; index += 1) reader.u30();
  count = reader.u30();
  reader.offset += Math.max(0, count - 1) * 8;

  const strings = [""];
  count = reader.u30();
  for (let index = 1; index < count; index += 1) {
    strings[index] = reader.bytes(reader.u30()).toString("utf8");
  }

  const namespaces: Abc["namespaces"] = [null];
  count = reader.u30();
  for (let index = 1; index < count; index += 1) {
    reader.u8();
    const name = reader.u30();
    namespaces[index] = { value: strings[name] ?? "" };
  }

  const namespaceSets: Abc["namespaceSets"] = [null];
  count = reader.u30();
  for (let index = 1; index < count; index += 1) {
    const setCount = reader.u30();
    const set: number[] = [];
    for (let item = 0; item < setCount; item += 1) set.push(reader.u30());
    namespaceSets[index] = set;
  }

  const multinames: Abc["multinames"] = [null];
  count = reader.u30();
  for (let index = 1; index < count; index += 1) {
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
      const values = (namespaceSets[item.nsset] ?? []).map((namespace) => namespaces[namespace]?.value ?? "");
      item.qname = `{${values.join(",")}}::${strings[item.name] ?? ""}`;
    } else if (kind === 0x1b || kind === 0x1c) {
      item.nsset = reader.u30();
      const values = (namespaceSets[item.nsset] ?? []).map((namespace) => namespaces[namespace]?.value ?? "");
      item.qname = `{${values.join(",")}}::*`;
    } else if (kind === 0x1d) {
      item.qnameIndex = reader.u30();
      const parameterCount = reader.u30();
      item.params = [];
      for (let parameter = 0; parameter < parameterCount; parameter += 1) item.params.push(reader.u30());
      item.qname = `TypeName(${item.qnameIndex})`;
    } else {
      throw new Error(`Unsupported ABC multiname kind: ${kind}`);
    }
    multinames[index] = item;
  }

  const methodCount = reader.u30();
  for (let index = 0; index < methodCount; index += 1) {
    const parameterCount = reader.u30();
    reader.u30();
    for (let parameter = 0; parameter < parameterCount; parameter += 1) reader.u30();
    reader.u30();
    const flags = reader.u8();
    if ((flags & 0x08) !== 0) {
      const optionCount = reader.u30();
      for (let option = 0; option < optionCount; option += 1) {
        reader.u30();
        reader.u8();
      }
    }
    if ((flags & 0x80) !== 0) {
      for (let parameter = 0; parameter < parameterCount; parameter += 1) reader.u30();
    }
  }

  skipMetadata(reader);
  const classCount = reader.u30();
  const instances: Abc["instances"] = [];
  for (let index = 0; index < classCount; index += 1) {
    const name = reader.u30();
    reader.u30();
    if ((reader.u8() & 0x08) !== 0) reader.u30();
    const interfaceCount = reader.u30();
    for (let item = 0; item < interfaceCount; item += 1) reader.u30();
    const iinit = reader.u30();
    instances.push({ name, iinit, traits: readTraits(reader) });
  }
  const classes: Abc["classes"] = [];
  for (let index = 0; index < classCount; index += 1) {
    const cinit = reader.u30();
    classes.push({ cinit, traits: readTraits(reader) });
  }
  const scriptCount = reader.u30();
  const scripts: Abc["scripts"] = [];
  for (let index = 0; index < scriptCount; index += 1) {
    const init = reader.u30();
    scripts.push({ init, traits: readTraits(reader) });
  }

  const methodBodyCount = reader.u30();
  const methodBodies: AbcMethodBody[] = [];
  for (let index = 0; index < methodBodyCount; index += 1) {
    const method = reader.u30();
    reader.u30();
    reader.u30();
    reader.u30();
    reader.u30();
    const code = reader.bytes(reader.u30());
    const exceptionCount = reader.u30();
    for (let item = 0; item < exceptionCount; item += 1) {
      reader.u30();
      reader.u30();
      reader.u30();
      reader.u30();
      reader.u30();
    }
    readTraits(reader);
    methodBodies.push({ method, code });
  }
  return { strings, namespaces, namespaceSets, multinames, instances, classes, scripts, methodBodies };
}

function buildMethodNames(abc: Abc): Map<number, string[]> {
  const names = new Map<number, string[]>();
  const add = (method: number, name: string): void => {
    names.set(method, [...(names.get(method) ?? []), name]);
  };
  for (let classIndex = 0; classIndex < abc.instances.length; classIndex += 1) {
    const instance = abc.instances[classIndex];
    const className = qname(abc.multinames[instance.name]);
    add(instance.iinit, `${className}::<init>`);
    for (const trait of instance.traits) {
      if (trait.method != null) add(trait.method, `${className}::${qname(abc.multinames[trait.name]) || trait.name}`);
    }
    const classInfo = abc.classes[classIndex];
    add(classInfo.cinit, `${className}::static::<init>`);
    for (const trait of classInfo.traits) {
      if (trait.method != null) add(trait.method, `${className}::static::${qname(abc.multinames[trait.name]) || trait.name}`);
    }
  }
  for (let index = 0; index < abc.scripts.length; index += 1) {
    const script = abc.scripts[index];
    add(script.init, `(script#${index})::<init>`);
    for (const trait of script.traits) {
      if (trait.method != null) add(trait.method, `(script#${index})::${qname(abc.multinames[trait.name]) || trait.name}`);
    }
  }
  return names;
}

function methodBodyFor(abc: Abc, ownerName: string): AbcMethodBody | null {
  const names = buildMethodNames(abc);
  return abc.methodBodies.find((body) => (names.get(body.method) ?? []).includes(ownerName)) ?? null;
}

function readU30At(buffer: Buffer, offset: number): { value: number; length: number } {
  let value = 0;
  for (let index = 0; index < 5; index += 1) {
    const byte = buffer[offset + index] ?? 0;
    value |= (byte & 0x7f) << (7 * index);
    if ((byte & 0x80) === 0) return { value: value >>> 0, length: index + 1 };
  }
  throw new Error(`Invalid U30 at bytecode offset ${offset}`);
}

function readS24(buffer: Buffer, offset: number): number {
  const value = buffer[offset] | ((buffer[offset + 1] ?? 0) << 8) | ((buffer[offset + 2] ?? 0) << 16);
  return value & 0x800000 ? value | ~0xffffff : value;
}

function skipU30Operands(buffer: Buffer, offset: number, count: number): { length: number; operands: number[] } {
  let cursor = offset;
  const operands: number[] = [];
  for (let index = 0; index < count; index += 1) {
    const decoded = readU30At(buffer, cursor);
    operands.push(decoded.value);
    cursor += decoded.length;
  }
  return { length: cursor - offset, operands };
}

const opNames: Record<number, string> = {
  0x02: "nop",
  0x24: "pushbyte",
  0x46: "callproperty",
  0x4f: "callpropvoid",
  0x60: "getlex",
  0x66: "getproperty",
  0xd0: "getlocal0",
};

function decodeInstruction(code: Buffer, offset: number): DecodedInstruction {
  const op = code[offset] ?? 0;
  const name = opNames[op] ?? `op_${op.toString(16).padStart(2, "0")}`;
  if (op >= 0xd0 && op <= 0xd7) return { offset, op, name, length: 1, operands: [] };
  if (op === 0x24 || op === 0x65) return { offset, op, name, length: 2, operands: [code[offset + 1] ?? 0] };
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
  let offset = 0;
  while (offset < body.code.length) {
    const instruction = decodeInstruction(body.code, offset);
    instructions.push(instruction);
    offset += Math.max(1, instruction.length);
  }
  return instructions;
}

function qnameEndsWith(abc: Abc, instruction: DecodedInstruction | undefined, suffix: string): boolean {
  return Boolean(instruction?.operands.length && qname(abc.multinames[instruction.operands[0]]).endsWith(suffix));
}

function isCall(instruction: DecodedInstruction | undefined, name: string, argumentCount: number): boolean {
  return instruction?.name === name && instruction.operands[1] === argumentCount;
}

function isUnionListCallPrefix(abc: Abc, instructions: DecodedInstruction[], index: number): boolean {
  return instructions[index]?.name === "getlex" &&
    qnameEndsWith(abc, instructions[index], "::GM") &&
    instructions[index + 1]?.name === "getproperty" &&
    qnameEndsWith(abc, instructions[index + 1], "::testapi") &&
    instructions[index + 2]?.name === "getlex" &&
    qnameEndsWith(abc, instructions[index + 2], "::GS") &&
    instructions[index + 3]?.name === "getproperty" &&
    qnameEndsWith(abc, instructions[index + 3], "::a1");
}

function inspectBody(abc: Abc, body: AbcMethodBody, mutate: boolean): { targetFound: boolean; pageSizeSafe: boolean; patchCount: number } {
  const instructions = instructionsFor(body);
  for (let index = 0; index < instructions.length; index += 1) {
    if (!isUnionListCallPrefix(abc, instructions, index)) continue;

    const firstArgument = instructions[index + 4];
    const dataProperty = instructions[index + 5];
    const countCall = instructions[index + 6];
    const listCall = instructions[index + 7];
    const original = firstArgument?.name === "getlocal0" &&
      dataProperty?.name === "getproperty" &&
      qnameEndsWith(abc, dataProperty, "::data") &&
      isCall(countCall, "callproperty", 0) &&
      qnameEndsWith(abc, countCall, "::getUnionAllNum") &&
      isCall(listCall, "callpropvoid", 2) &&
      qnameEndsWith(abc, listCall, "::getGameUList");
    if (original) {
      if (mutate) {
        const start = firstArgument.offset;
        const end = listCall.offset;
        body.code[start] = 0x24;
        body.code[start + 1] = UNION_PAGE_SIZE;
        body.code.fill(0x02, start + 2, end);
      }
      return { targetFound: true, pageSizeSafe: mutate, patchCount: mutate ? 1 : 0 };
    }

    if (firstArgument?.name !== "pushbyte" || firstArgument.operands[0] !== UNION_PAGE_SIZE) continue;
    let callIndex = index + 5;
    while (instructions[callIndex]?.name === "nop") callIndex += 1;
    if (
      isCall(instructions[callIndex], "callpropvoid", 2) &&
      qnameEndsWith(abc, instructions[callIndex], "::getGameUList")
    ) {
      return { targetFound: true, pageSizeSafe: true, patchCount: 0 };
    }
  }
  return { targetFound: false, pageSizeSafe: false, patchCount: 0 };
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

function inspectDoAbc(data: Buffer, mutate: boolean): { targetFound: boolean; pageSizeSafe: boolean; patchCount: number } {
  const abc = parseAbc(data.subarray(doAbcStart(data)));
  const body = methodBodyFor(abc, UNION_LIST_INIT_METHOD);
  return body ? inspectBody(abc, body, mutate) : { targetFound: false, pageSizeSafe: false, patchCount: 0 };
}

export function inspectEmptyUnionListCompatibility(swf: DecodedSwf): EmptyUnionListCompatibilityInspection {
  for (const tag of parseTags(swf.body)) {
    if (tag.code !== 82) continue;
    const result = inspectDoAbc(tag.data, false);
    if (result.targetFound) return { targetFound: true, pageSizeSafe: result.pageSizeSafe };
  }
  return { targetFound: false, pageSizeSafe: false };
}

export function patchEmptyUnionListCompatibility(swf: DecodedSwf): number {
  let patchCount = 0;
  for (const tag of parseTags(swf.body)) {
    if (tag.code !== 82) continue;
    patchCount += inspectDoAbc(tag.data, true).patchCount;
  }
  return patchCount;
}
