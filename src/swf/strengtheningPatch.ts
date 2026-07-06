import { type DecodedSwf, parseTags } from "./swf.js";

const GOODS_CHANGE_STRENGTH_METHOD = "hotpointgame.models.goods::Goods::::changeStreng";

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

export type EquipmentStrengtheningOptimizationInspection = {
  targetFound: boolean;
  oneClickMaxLevel: boolean;
  perfectLevelMaxed: boolean;
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
  0x87: "astypelate",
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

function operandFor(abc: Abc, instructions: DecodedInstruction[], opName: string, qnameSuffix: string): number {
  for (const instruction of instructions) {
    if (instruction.name !== opName || instruction.operands.length === 0) {
      continue;
    }
    if (instructionQnameEndsWith(abc, instruction, qnameSuffix)) {
      return instruction.operands[0];
    }
  }
  throw new Error(`Missing ${opName} ${qnameSuffix}`);
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

function nextNonNop(instructions: DecodedInstruction[], startIndex: number): number {
  let index = startIndex;
  while (instructions[index]?.name === "nop") {
    index += 1;
  }
  return index;
}

function valueTargetLength(abc: Abc, instructions: DecodedInstruction[], index: number, propertySuffix: string): number {
  if (
    instructions[index]?.name !== "getlocal0" ||
    instructions[index + 1]?.name !== "getproperty" ||
    !instructionQnameEndsWith(abc, instructions[index + 1], "_obj") ||
    instructions[index + 2]?.name !== "getproperty" ||
    !instructionQnameEndsWith(abc, instructions[index + 2], propertySuffix)
  ) {
    return 0;
  }

  if (
    instructions[index + 3]?.name === "getlex" &&
    instructionQnameEndsWith(abc, instructions[index + 3], "VT") &&
    instructions[index + 4]?.name === "astypelate"
  ) {
    return 5;
  }
  return 3;
}

function isQhValueTarget(abc: Abc, instructions: DecodedInstruction[], index: number): boolean {
  return valueTargetLength(abc, instructions, index, "qh") > 0;
}

function isIncrementRhs(abc: Abc, instructions: DecodedInstruction[], index: number): boolean {
  const targetLength = valueTargetLength(abc, instructions, index, "qh");
  return (
    targetLength > 0 &&
    instructions[index + targetLength]?.name === "callproperty" &&
    instructionQnameEndsWith(abc, instructions[index + targetLength], "getValue") &&
    instructions[index + targetLength + 1]?.name === "pushbyte" &&
    instructions[index + targetLength + 1].operands[0] === 1 &&
    instructions[index + targetLength + 2]?.name === "add" &&
    instructions[index + targetLength + 3]?.name === "callpropvoid" &&
    instructionQnameEndsWith(abc, instructions[index + targetLength + 3], "setValue")
  );
}

function isMaxValueRhs(abc: Abc, instructions: DecodedInstruction[], index: number, getterSuffix: string): boolean {
  return (
    instructions[index]?.name === "getlocal0" &&
    instructions[index + 1]?.name === "callproperty" &&
    instructionQnameEndsWith(abc, instructions[index + 1], getterSuffix) &&
    instructions[index + 2]?.name === "callpropvoid" &&
    instructionQnameEndsWith(abc, instructions[index + 2], "setValue")
  );
}

function valueTargetCode(abc: Abc, propertySuffix: string): Buffer {
  return Buffer.concat([
    Buffer.from([0xd0]),
    instruction(0x66, multinameIndexEndingWith(abc, "_obj")),
    instruction(0x66, multinameIndexEndingWith(abc, propertySuffix)),
  ]);
}

function maxSetterCode(abc: Abc, propertySuffix: string, getterSuffix: string, setValueIndex: number): Buffer {
  return Buffer.concat([
    valueTargetCode(abc, propertySuffix),
    Buffer.from([0xd0]),
    instruction(0x46, multinameIndexEndingWith(abc, getterSuffix), 0),
    instruction(0x4f, setValueIndex, 1),
  ]);
}

function isWmValueTarget(abc: Abc, instructions: DecodedInstruction[], index: number): boolean {
  return valueTargetLength(abc, instructions, index, "wm") > 0;
}

function replacementEndBeforeNextInstruction(
  body: AbcMethodBody,
  instructions: DecodedInstruction[],
  startIndex: number
): number {
  const nextIndex = nextNonNop(instructions, startIndex);
  return instructions[nextIndex]?.offset ?? body.code.length;
}

function patchChangeStrengBody(
  abc: Abc,
  body: AbcMethodBody,
  mutate: boolean
): { patched: boolean; oneClickMaxLevel: boolean; perfectLevelMaxed: boolean } {
  const instructions = instructionsFor(body);
  for (let index = 0; index < instructions.length; index += 1) {
    if (!isQhValueTarget(abc, instructions, index)) {
      continue;
    }

    const qhTargetLength = valueTargetLength(abc, instructions, index, "qh");
    const rhsIndex = nextNonNop(instructions, index + qhTargetLength);
    const wmTargetIndex = nextNonNop(instructions, rhsIndex + 3);
    const wmTargetLength = valueTargetLength(abc, instructions, wmTargetIndex, "wm");
    if (
      isMaxValueRhs(abc, instructions, rhsIndex, "isStrengBo") &&
      isWmValueTarget(abc, instructions, wmTargetIndex) &&
      isMaxValueRhs(abc, instructions, nextNonNop(instructions, wmTargetIndex + wmTargetLength), "getWmMax")
    ) {
      return { patched: false, oneClickMaxLevel: true, perfectLevelMaxed: true };
    }
    if (!isIncrementRhs(abc, instructions, rhsIndex)) {
      if (!isMaxValueRhs(abc, instructions, rhsIndex, "isStrengBo")) {
        continue;
      }
      if (!mutate) {
        return { patched: false, oneClickMaxLevel: true, perfectLevelMaxed: false };
      }

      const start = instructions[index].offset;
      const qhSetValueIndex = rhsIndex + 2;
      const end = replacementEndBeforeNextInstruction(body, instructions, qhSetValueIndex + 1);
      const setValueIndex =
        instructions[qhSetValueIndex].operands[0] || operandFor(abc, instructions, "callpropvoid", "setValue");
      const code = Buffer.concat([
        maxSetterCode(abc, "qh", "isStrengBo", setValueIndex),
        maxSetterCode(abc, "wm", "getWmMax", setValueIndex),
      ]);
      if (code.length > end - start) {
        throw new Error(`Equipment strengthening replacement is longer than original body slice: ${code.length} > ${end - start}`);
      }
      code.copy(body.code, start);
      body.code.fill(0x02, start + code.length, end);
      return { patched: true, oneClickMaxLevel: true, perfectLevelMaxed: true };
    }
    if (!mutate) {
      return { patched: false, oneClickMaxLevel: false, perfectLevelMaxed: false };
    }

    const start = instructions[index].offset;
    const rhsTargetLength = valueTargetLength(abc, instructions, rhsIndex, "qh");
    const setValueInstructionIndex = rhsIndex + rhsTargetLength + 3;
    const end = replacementEndBeforeNextInstruction(body, instructions, setValueInstructionIndex + 1);
    const setValueIndex =
      instructions[setValueInstructionIndex].operands[0] || operandFor(abc, instructions, "callpropvoid", "setValue");
    const code = Buffer.concat([
      maxSetterCode(abc, "qh", "isStrengBo", setValueIndex),
      maxSetterCode(abc, "wm", "getWmMax", setValueIndex),
    ]);
    if (code.length > end - start) {
      throw new Error(`Equipment strengthening replacement is longer than original body slice: ${code.length} > ${end - start}`);
    }
    code.copy(body.code, start);
    body.code.fill(0x02, start + code.length, end);
    return { patched: true, oneClickMaxLevel: true, perfectLevelMaxed: true };
  }

  return { patched: false, oneClickMaxLevel: false, perfectLevelMaxed: false };
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

function inspectDoAbcData(
  data: Buffer,
  patch: boolean
): { targetFound: boolean; oneClickMaxLevel: boolean; perfectLevelMaxed: boolean; patchCount: number } {
  const abcRelativeStart = doAbcStart(data);
  const abc = parseAbc(data.subarray(abcRelativeStart));
  const changeStrengBody = methodBodyFor(abc, GOODS_CHANGE_STRENGTH_METHOD);
  if (!changeStrengBody) {
    return { targetFound: false, oneClickMaxLevel: false, perfectLevelMaxed: false, patchCount: 0 };
  }

  const result = patchChangeStrengBody(abc, changeStrengBody, patch);
  return {
    targetFound: true,
    oneClickMaxLevel: result.oneClickMaxLevel,
    perfectLevelMaxed: result.perfectLevelMaxed,
    patchCount: Number(result.patched),
  };
}

export function inspectEquipmentStrengtheningOptimization(swf: DecodedSwf): EquipmentStrengtheningOptimizationInspection {
  for (const tag of parseTags(swf.body)) {
    if (tag.code !== 82) {
      continue;
    }
    const inspected = inspectDoAbcData(tag.data, false);
    if (inspected.targetFound) {
      return {
        targetFound: true,
        oneClickMaxLevel: inspected.oneClickMaxLevel,
        perfectLevelMaxed: inspected.perfectLevelMaxed,
      };
    }
  }
  return { targetFound: false, oneClickMaxLevel: false, perfectLevelMaxed: false };
}

export function patchEquipmentStrengtheningOptimization(swf: DecodedSwf): number {
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
