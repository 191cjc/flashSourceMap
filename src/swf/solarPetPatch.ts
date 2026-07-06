import { type DecodedSwf, parseTags } from "./swf.js";

export const SOLAR_PET_RESOURCE_NAME = "c_taiyangshen_pet";
export const SOLAR_PET_ASSET_NAME = "c_taiyangshen_petv1.swf";
export const SOLAR_PET_INTERNAL_MODEL_CLASS = "m_taiyangshenBoss";
export const SOLAR_PET_BULLET_ATTACK2_CLASS_ALIAS = "abullet_taiyangshenPetgjb";
export const SOLAR_PET_BULLET_INTERNAL_ATTACK2_CLASS = "abullet_taiyangshenBossgjb";
export const SOLAR_PET_BULLET_SELECT_CLASS_ALIAS = "BulletM_taiyangshenPetgj3";
export const SOLAR_PET_BULLET_INTERNAL_SELECT_CLASS = "BulletM_taiyangshenBossgj3";
export const SOLAR_PET_BULLET_ATTACK4_CLASS_ALIAS = "abullet_taiyangshenPetgjd";
export const SOLAR_PET_BULLET_INTERNAL_ATTACK4_CLASS = "abullet_taiyangshenBossgjd";
export const SOLAR_PET_FUSION_LEVEL_MAX = 70;

const LOADER_MANAGER_CLASS = "hotpointgame.utils.gameloader::LoaderManager";
const GAME_DATA_INIT_CLASS = "hotpointgame.Control::GameDataInit";
const PET_MANAGER_CLASS = "hotpointgame.pet::PetManager";

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
  index: number;
  method: number;
  maxStack: number;
  localCount: number;
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

type MethodBodyHeader = {
  index: number;
  method: number;
  maxStack: number;
  maxStackOffset: number;
  localCount: number;
  localCountOffset: number;
  codeLength: number;
  codeLengthOffset: number;
  codeStart: number;
};

type DecodedInstruction = {
  offset: number;
  op: number;
  name: string;
  length: number;
  operands: number[];
};

type AssemblyPart = Buffer | { kind: "label"; name: string } | { kind: "branch"; op: number; target: string };

type FusionPatchTarget = {
  startOffset: number;
  endOffset: number;
};

export type SolarPetRuntimePatchInspection = {
  targetFound: boolean;
  filenameMapping: boolean;
  classMappings: boolean;
  classAliases: boolean;
  fusionLevelMax: boolean;
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

function readMultiname(reader: Reader, strings: string[], namespaces: Abc["namespaces"], namespaceSets: Abc["namespaceSets"]): Multiname {
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

  return item;
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
    multinames[i] = readMultiname(reader, strings, namespaces, namespaceSets);
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

  const methodBodies: AbcMethodBody[] = [];
  const bodyCount = reader.u30();
  for (let i = 0; i < bodyCount; i += 1) {
    const method = reader.u30();
    const maxStack = reader.u30();
    const localCount = reader.u30();
    reader.u30();
    reader.u30();
    const codeLength = reader.u30();
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
    methodBodies.push({ index: i, method, maxStack, localCount, code });
  }

  return { strings, namespaces, namespaceSets, multinames, instances, classes, scripts, methodBodies };
}

function skipMultiname(reader: Reader): void {
  const kind = reader.u8();
  if (kind === 0x07 || kind === 0x0d || kind === 0x09 || kind === 0x0e) {
    reader.u30();
    reader.u30();
  } else if (kind === 0x0f || kind === 0x10 || kind === 0x1b || kind === 0x1c) {
    reader.u30();
  } else if (kind === 0x11 || kind === 0x12) {
    return;
  } else if (kind === 0x1d) {
    reader.u30();
    const paramCount = reader.u30();
    for (let j = 0; j < paramCount; j += 1) {
      reader.u30();
    }
  } else {
    throw new Error(`Unsupported ABC multiname kind: ${kind}`);
  }
}

function methodBodyHeaders(abcBuffer: Buffer): MethodBodyHeader[] {
  const reader = new Reader(abcBuffer);
  reader.u16();
  reader.u16();

  let count = reader.u30();
  for (let i = 1; i < count; i += 1) reader.u30();
  count = reader.u30();
  for (let i = 1; i < count; i += 1) reader.u30();
  count = reader.u30();
  reader.offset += Math.max(0, count - 1) * 8;
  count = reader.u30();
  for (let i = 1; i < count; i += 1) reader.bytes(reader.u30());
  count = reader.u30();
  for (let i = 1; i < count; i += 1) {
    reader.u8();
    reader.u30();
  }
  count = reader.u30();
  for (let i = 1; i < count; i += 1) {
    const setCount = reader.u30();
    for (let j = 0; j < setCount; j += 1) reader.u30();
  }
  count = reader.u30();
  for (let i = 1; i < count; i += 1) skipMultiname(reader);

  const methodCount = reader.u30();
  for (let i = 0; i < methodCount; i += 1) {
    const paramCount = reader.u30();
    reader.u30();
    for (let j = 0; j < paramCount; j += 1) reader.u30();
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
      for (let j = 0; j < paramCount; j += 1) reader.u30();
    }
  }

  skipMetadata(reader);

  const classCount = reader.u30();
  for (let i = 0; i < classCount; i += 1) {
    reader.u30();
    reader.u30();
    const flags = reader.u8();
    if ((flags & 0x08) !== 0) reader.u30();
    const interfaceCount = reader.u30();
    for (let j = 0; j < interfaceCount; j += 1) reader.u30();
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

  const bodyCount = reader.u30();
  const headers: MethodBodyHeader[] = [];
  for (let i = 0; i < bodyCount; i += 1) {
    const method = reader.u30();
    const maxStackOffset = reader.offset;
    const maxStack = reader.u30();
    const localCountOffset = reader.offset;
    const localCount = reader.u30();
    reader.u30();
    reader.u30();
    const codeLengthOffset = reader.offset;
    const codeLength = reader.u30();
    const codeStart = reader.offset;
    reader.bytes(codeLength);
    const exceptionCount = reader.u30();
    for (let j = 0; j < exceptionCount; j += 1) {
      reader.u30();
      reader.u30();
      reader.u30();
      reader.u30();
      reader.u30();
    }
    readTraits(reader);
    headers.push({ index: i, method, maxStack, maxStackOffset, localCount, localCountOffset, codeLength, codeLengthOffset, codeStart });
  }

  return headers;
}

function buildMethodNames(abc: Abc): Map<number, string[]> {
  const names = new Map<number, string[]>();
  const add = (methodIndex: number | undefined, value: string): void => {
    if (methodIndex == null || methodIndex < 0) return;
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
    if (!script) continue;
    add(script.init, `(script#${i})::<init>`);
    for (const trait of script.traits) {
      if (trait.method != null) {
        add(trait.method, `(script#${i})::${qname(abc.multinames[trait.name]) || trait.name}`);
      }
    }
  }

  return names;
}

function methodBodyByName(
  abc: Abc,
  classNameSuffix: string,
  methodName: string,
  staticOnly: boolean
): AbcMethodBody | null {
  const names = buildMethodNames(abc);
  for (const body of abc.methodBodies) {
    const bodyNames = names.get(body.method) ?? [];
    if (
      bodyNames.some((name) => {
        return (
          name.includes(classNameSuffix) &&
          (!staticOnly || name.includes("::static::")) &&
          (name.endsWith(`::${methodName}`) || name.endsWith(methodName))
        );
      })
    ) {
      return body;
    }
  }
  return null;
}

function staticInitializerBody(abc: Abc, classNameSuffix: string): AbcMethodBody | null {
  const names = buildMethodNames(abc);
  for (const body of abc.methodBodies) {
    if ((names.get(body.method) ?? []).some((name) => name.includes(classNameSuffix) && name.endsWith("::<static>"))) {
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
    if (current !== 0) byte |= 0x80;
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
  0x24: "pushbyte",
  0x25: "pushshort",
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
  0x87: "astypelate",
  0xab: "equals",
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
  if (op === 0x24) {
    return { offset, op, name, length: 2, operands: [code[offset + 1] ?? 0] };
  }
  if ((op >= 0x0c && op <= 0x1a) || op === 0x10) {
    return { offset, op, name, length: 4, operands: [readS24(code, offset + 1)] };
  }
  if (
    [
      0x04, 0x05, 0x06, 0x08, 0x25, 0x2c, 0x2d, 0x2e, 0x2f, 0x31, 0x40, 0x49, 0x53, 0x55, 0x56,
      0x58, 0x59, 0x5a, 0x5d, 0x5e, 0x5f, 0x60, 0x61, 0x62, 0x63, 0x66, 0x68, 0x6a, 0x6c,
      0x6d, 0x6e, 0x6f, 0x80, 0x86, 0x92, 0x94, 0xb2, 0xc2, 0xc3,
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

function instruction(op: number, ...operands: number[]): Buffer {
  return Buffer.concat([Buffer.from([op]), ...operands.map((operand) => encodeU30(operand))]);
}

function getLocal(index: number): Buffer {
  return index >= 0 && index <= 3 ? Buffer.from([0xd0 + index]) : instruction(0x62, index);
}

function setLocal(index: number): Buffer {
  return index >= 0 && index <= 3 ? Buffer.from([0xd4 + index]) : instruction(0x63, index);
}

function pushIntLiteral(value: number): Buffer {
  if (value >= -128 && value <= 127) {
    return Buffer.from([0x24, value & 0xff]);
  }
  return instruction(0x25, value);
}

function branchInstruction(op: number, offset: number): Buffer {
  const encoded = Buffer.alloc(4);
  encoded[0] = op;
  encoded.writeIntLE(offset, 1, 3);
  return encoded;
}

function label(name: string): AssemblyPart {
  return { kind: "label", name };
}

function branch(op: number, target: string): AssemblyPart {
  return { kind: "branch", op, target };
}

function assemble(parts: AssemblyPart[]): Buffer {
  const labels = new Map<string, number>();
  let offset = 0;
  for (const part of parts) {
    if (Buffer.isBuffer(part)) {
      offset += part.length;
    } else if (part.kind === "label") {
      labels.set(part.name, offset);
    } else {
      offset += 4;
    }
  }

  const output: Buffer[] = [];
  offset = 0;
  for (const part of parts) {
    if (Buffer.isBuffer(part)) {
      output.push(part);
      offset += part.length;
      continue;
    }
    if (part.kind === "branch") {
      const targetOffset = labels.get(part.target);
      if (targetOffset == null) {
        throw new Error(`Missing branch label: ${part.target}`);
      }
      output.push(branchInstruction(part.op, targetOffset - (offset + 4)));
      offset += 4;
    }
  }
  return Buffer.concat(output);
}

function writeU30SameLength(buffer: Buffer, offset: number, newValue: number, labelText: string): void {
  const old = readU30At(buffer, offset);
  const encoded = encodeU30(newValue);
  if (old.length !== encoded.length) {
    throw new Error(`${labelText} U30 length would change from ${old.length} to ${encoded.length}`);
  }
  encoded.copy(buffer, offset);
}

function replaceMethodCode(
  abcBuffer: Buffer,
  headers: MethodBodyHeader[],
  body: AbcMethodBody,
  code: Buffer,
  labelText: string,
  options: { maxStack?: number; localCount?: number } = {}
): Buffer {
  const header = headers[body.index];
  if (!header) {
    throw new Error(`Missing method body header for ${labelText}`);
  }
  const encodedLength = encodeU30(code.length);
  const exceptionsOffset = header.codeStart + header.codeLength;
  const nextAbc = Buffer.concat([
    abcBuffer.subarray(0, header.codeLengthOffset),
    encodedLength,
    code,
    abcBuffer.subarray(exceptionsOffset),
  ]);

  const maxStack = options.maxStack ?? header.maxStack;
  if (maxStack !== header.maxStack) {
    writeU30SameLength(nextAbc, header.maxStackOffset, maxStack, `${labelText} maxStack`);
  }
  const localCount = options.localCount ?? header.localCount;
  if (localCount !== header.localCount) {
    writeU30SameLength(nextAbc, header.localCountOffset, localCount, `${labelText} localCount`);
  }
  return nextAbc;
}

function insertMethodCode(
  abcBuffer: Buffer,
  headers: MethodBodyHeader[],
  body: AbcMethodBody,
  insertOffset: number,
  insertCode: Buffer,
  labelText: string,
  options: { maxStack?: number; localCount?: number } = {}
): Buffer {
  const header = headers[body.index];
  if (!header) {
    throw new Error(`Missing method body header for ${labelText}`);
  }
  const code = Buffer.concat([
    abcBuffer.subarray(header.codeStart, header.codeStart + insertOffset),
    insertCode,
    abcBuffer.subarray(header.codeStart + insertOffset, header.codeStart + header.codeLength),
  ]);
  return replaceMethodCode(abcBuffer, headers, body, code, labelText, options);
}

function constantPoolOffsets(abcBuffer: Buffer): {
  stringCountOffset: number;
  stringsEnd: number;
  multinameCountOffset: number;
  multinamesEnd: number;
} {
  const reader = new Reader(abcBuffer);
  reader.u16();
  reader.u16();

  let count = reader.u30();
  for (let i = 1; i < count; i += 1) reader.u30();
  count = reader.u30();
  for (let i = 1; i < count; i += 1) reader.u30();
  count = reader.u30();
  reader.offset += Math.max(0, count - 1) * 8;

  const stringCountOffset = reader.offset;
  const stringCount = reader.u30();
  for (let i = 1; i < stringCount; i += 1) reader.bytes(reader.u30());
  const stringsEnd = reader.offset;

  count = reader.u30();
  for (let i = 1; i < count; i += 1) {
    reader.u8();
    reader.u30();
  }
  count = reader.u30();
  for (let i = 1; i < count; i += 1) {
    const setCount = reader.u30();
    for (let j = 0; j < setCount; j += 1) reader.u30();
  }

  const multinameCountOffset = reader.offset;
  const multinameCount = reader.u30();
  for (let i = 1; i < multinameCount; i += 1) skipMultiname(reader);

  return { stringCountOffset, stringsEnd, multinameCountOffset, multinamesEnd: reader.offset };
}

function ensureStringConstant(abcBuffer: Buffer, abc: Abc, value: string): { abcBuffer: Buffer; index: number } {
  const existing = abc.strings.findIndex((item) => item === value);
  if (existing >= 0) {
    return { abcBuffer, index: existing };
  }

  const offsets = constantPoolOffsets(abcBuffer);
  const oldCountInfo = readU30At(abcBuffer, offsets.stringCountOffset);
  const raw = Buffer.from(value, "utf8");
  const entry = Buffer.concat([encodeU30(raw.length), raw]);
  return {
    abcBuffer: Buffer.concat([
      abcBuffer.subarray(0, offsets.stringCountOffset),
      encodeU30(oldCountInfo.value + 1),
      abcBuffer.subarray(offsets.stringCountOffset + oldCountInfo.length, offsets.stringsEnd),
      entry,
      abcBuffer.subarray(offsets.stringsEnd),
    ]),
    index: oldCountInfo.value,
  };
}

function ensureStringConstants(abcBuffer: Buffer, values: string[]): Buffer {
  let nextAbcBuffer = abcBuffer;
  for (const value of values) {
    const abc = parseAbc(nextAbcBuffer);
    nextAbcBuffer = ensureStringConstant(nextAbcBuffer, abc, value).abcBuffer;
  }
  return nextAbcBuffer;
}

function multinameIndexEndingWith(abc: Abc, suffix: string): number {
  const index = abc.multinames.findIndex((multiname) => qname(multiname).endsWith(suffix));
  if (index < 1) {
    throw new Error(`Unable to find ABC multiname ending with ${suffix}`);
  }
  return index;
}

function dynamicPropertyMultinameIndex(abc: Abc, body: AbcMethodBody, opName: "getproperty" | "setproperty"): number {
  for (const decoded of instructionsFor(body)) {
    if (decoded.name !== opName || decoded.operands.length === 0) {
      continue;
    }
    const multiname = abc.multinames[decoded.operands[0]];
    if (multiname?.kind === 0x1b || multiname?.kind === 0x1c) {
      return decoded.operands[0];
    }
  }
  throw new Error(`Missing dynamic ${opName} multiname`);
}

function stringIndexFor(abc: Abc, value: string): number {
  const index = abc.strings.findIndex((item) => item === value);
  if (index < 0) {
    throw new Error(`Missing string constant: ${value}`);
  }
  return index;
}

function bodyHasString(abc: Abc, body: AbcMethodBody | null, value: string): boolean {
  if (!body) {
    return false;
  }
  const index = abc.strings.findIndex((item) => item === value);
  if (index < 0) {
    return false;
  }
  return instructionsFor(body).some((decoded) => decoded.name === "pushstring" && decoded.operands[0] === index);
}

function bodyHasGetProperty(abc: Abc, body: AbcMethodBody | null, qnameSuffix: string): boolean {
  if (!body) {
    return false;
  }
  return instructionsFor(body).some((decoded) => {
    return decoded.name === "getproperty" && qname(abc.multinames[decoded.operands[0]]).endsWith(qnameSuffix);
  });
}

function lastReturnOffset(body: AbcMethodBody): number {
  const returns = instructionsFor(body).filter((decoded) => decoded.name === "returnvoid" || decoded.name === "returnvalue");
  const last = returns.at(-1);
  if (!last) {
    throw new Error("method body has no return instruction");
  }
  return last.offset;
}

function solarClassMappingKeys(): string[] {
  return Array.from({ length: 8 }, (_value, index) => `${SOLAR_PET_RESOURCE_NAME}${index}`);
}

function solarBulletClassAliases(): Array<[string, string]> {
  return [
    [SOLAR_PET_BULLET_ATTACK2_CLASS_ALIAS, SOLAR_PET_BULLET_INTERNAL_ATTACK2_CLASS],
    [SOLAR_PET_BULLET_SELECT_CLASS_ALIAS, SOLAR_PET_BULLET_INTERNAL_SELECT_CLASS],
    [SOLAR_PET_BULLET_ATTACK4_CLASS_ALIAS, SOLAR_PET_BULLET_INTERNAL_ATTACK4_CLASS],
  ];
}

function solarPatchStrings(): string[] {
  return [
    SOLAR_PET_RESOURCE_NAME,
    SOLAR_PET_ASSET_NAME,
    SOLAR_PET_INTERNAL_MODEL_CLASS,
    ...solarBulletClassAliases().flat(),
    ...solarClassMappingKeys(),
  ];
}

function mapAssignmentCode(abc: Abc, mapMultinameIndex: number, setPropertyIndex: number, entries: Array<[string, string]>): Buffer {
  const chunks: Buffer[] = [];
  for (const [key, value] of entries) {
    chunks.push(
      instruction(0x60, mapMultinameIndex),
      instruction(0x2c, stringIndexFor(abc, key)),
      instruction(0x2c, stringIndexFor(abc, value)),
      instruction(0x61, setPropertyIndex)
    );
  }
  return Buffer.concat(chunks);
}

function patchLoaderFilenameMapping(abcBuffer: Buffer): { abcBuffer: Buffer; patchCount: number } {
  let nextAbcBuffer = ensureStringConstants(abcBuffer, [SOLAR_PET_RESOURCE_NAME, SOLAR_PET_ASSET_NAME]);
  let abc = parseAbc(nextAbcBuffer);
  const body = methodBodyByName(abc, LOADER_MANAGER_CLASS, "initFilename", true);
  if (!body || bodyHasString(abc, body, SOLAR_PET_RESOURCE_NAME)) {
    return { abcBuffer: nextAbcBuffer, patchCount: 0 };
  }

  const headers = methodBodyHeaders(nextAbcBuffer);
  const nameToFilenameIndex = multinameIndexEndingWith(abc, "nameToFilename");
  const dynamicSetIndex = dynamicPropertyMultinameIndex(abc, body, "setproperty");
  const code = mapAssignmentCode(abc, nameToFilenameIndex, dynamicSetIndex, [[SOLAR_PET_RESOURCE_NAME, SOLAR_PET_ASSET_NAME]]);
  nextAbcBuffer = insertMethodCode(nextAbcBuffer, headers, body, lastReturnOffset(body), code, "solar pet filename mapping", {
    maxStack: Math.max(body.maxStack, 3),
  });
  abc = parseAbc(nextAbcBuffer);
  return { abcBuffer: nextAbcBuffer, patchCount: bodyHasString(abc, methodBodyByName(abc, LOADER_MANAGER_CLASS, "initFilename", true), SOLAR_PET_RESOURCE_NAME) ? 1 : 0 };
}

function patchGameDataClassMappings(abcBuffer: Buffer): { abcBuffer: Buffer; patchCount: number } {
  let nextAbcBuffer = ensureStringConstants(abcBuffer, solarPatchStrings());
  let abc = parseAbc(nextAbcBuffer);
  const body = methodBodyByName(abc, GAME_DATA_INIT_CLASS, "swfClassNameInit", true);
  if (
    !body ||
    (bodyHasString(abc, body, `${SOLAR_PET_RESOURCE_NAME}7`) &&
      solarBulletClassAliases().every(([alias]) => bodyHasString(abc, body, alias)))
  ) {
    return { abcBuffer: nextAbcBuffer, patchCount: 0 };
  }

  const headers = methodBodyHeaders(nextAbcBuffer);
  const allClassNameIndex = multinameIndexEndingWith(abc, "allClassName");
  const dynamicSetIndex = dynamicPropertyMultinameIndex(abc, body, "setproperty");
  const entries: Array<[string, string]> = [
    [SOLAR_PET_RESOURCE_NAME, SOLAR_PET_RESOURCE_NAME],
    ...solarClassMappingKeys().map((key): [string, string] => [key, SOLAR_PET_RESOURCE_NAME]),
    ...solarBulletClassAliases().map(([alias]): [string, string] => [alias, SOLAR_PET_RESOURCE_NAME]),
  ];
  const code = mapAssignmentCode(abc, allClassNameIndex, dynamicSetIndex, entries);
  nextAbcBuffer = insertMethodCode(nextAbcBuffer, headers, body, lastReturnOffset(body), code, "solar pet class mappings", {
    maxStack: Math.max(body.maxStack, 3),
  });
  abc = parseAbc(nextAbcBuffer);
  const patchedBody = methodBodyByName(abc, GAME_DATA_INIT_CLASS, "swfClassNameInit", true);
  const complete =
    bodyHasString(abc, patchedBody, `${SOLAR_PET_RESOURCE_NAME}7`) &&
    solarBulletClassAliases().every(([alias]) => bodyHasString(abc, patchedBody, alias));
  return { abcBuffer: nextAbcBuffer, patchCount: complete ? 1 : 0 };
}

function buildGetSwfClassAliasCode(abc: Abc, originalBody: AbcMethodBody): Buffer {
  const loadsIndex = multinameIndexEndingWith(abc, "loads");
  const allClassNameIndex = multinameIndexEndingWith(abc, "allClassName");
  const swfLoaderIndex = multinameIndexEndingWith(abc, "SwfLoader");
  const getClassIndex = multinameIndexEndingWith(abc, "getClass");
  const dynamicGetIndex = dynamicPropertyMultinameIndex(abc, originalBody, "getproperty");
  const petClassNames = solarClassMappingKeys();

  const parts: AssemblyPart[] = [
    Buffer.from([0xd0, 0x30]),
    getLocal(1),
    setLocal(2),
  ];

  for (const petClassName of petClassNames) {
    parts.push(
      getLocal(1),
      instruction(0x2c, stringIndexFor(abc, petClassName)),
      Buffer.from([0xab]),
      branch(0x11, "aliasPetModel")
    );
  }

  for (const [alias, internalClass] of solarBulletClassAliases()) {
    const labelName = `aliasPetBullet${alias}`;
    parts.push(
      getLocal(1),
      instruction(0x2c, stringIndexFor(abc, alias)),
      Buffer.from([0xab]),
      branch(0x11, labelName),
      branch(0x10, `after${labelName}`),
      label(labelName),
      instruction(0x2c, stringIndexFor(abc, internalClass)),
      setLocal(2),
      branch(0x10, "afterSolarAlias"),
      label(`after${labelName}`)
    );
  }

  parts.push(
    branch(0x10, "afterSolarAlias"),
    label("aliasPetModel"),
    instruction(0x2c, stringIndexFor(abc, SOLAR_PET_INTERNAL_MODEL_CLASS)),
    setLocal(2),
    label("afterSolarAlias"),
    instruction(0x60, loadsIndex),
    instruction(0x60, allClassNameIndex),
    getLocal(1),
    instruction(0x66, dynamicGetIndex),
    instruction(0x66, dynamicGetIndex),
    instruction(0x60, swfLoaderIndex),
    Buffer.from([0x87]),
    getLocal(2),
    instruction(0x46, getClassIndex, 1),
    Buffer.from([0x48])
  );

  return assemble(parts);
}

function patchLoaderClassAliases(abcBuffer: Buffer): { abcBuffer: Buffer; patchCount: number } {
  let nextAbcBuffer = ensureStringConstants(abcBuffer, solarPatchStrings());
  let abc = parseAbc(nextAbcBuffer);
  const body = methodBodyByName(abc, LOADER_MANAGER_CLASS, "getSwfClass", true);
  if (
    !body ||
    solarBulletClassAliases().every(([alias, internalClass]) => {
      return bodyHasString(abc, body, alias) && bodyHasString(abc, body, internalClass);
    })
  ) {
    return { abcBuffer: nextAbcBuffer, patchCount: 0 };
  }

  const headers = methodBodyHeaders(nextAbcBuffer);
  const code = buildGetSwfClassAliasCode(abc, body);
  nextAbcBuffer = replaceMethodCode(nextAbcBuffer, headers, body, code, "solar pet class aliases", {
    maxStack: Math.max(body.maxStack, 4),
    localCount: Math.max(body.localCount, 3),
  });
  abc = parseAbc(nextAbcBuffer);
  const patchedBody = methodBodyByName(abc, LOADER_MANAGER_CLASS, "getSwfClass", true);
  const complete = solarBulletClassAliases().every(([alias, internalClass]) => {
    return bodyHasString(abc, patchedBody, alias) && bodyHasString(abc, patchedBody, internalClass);
  });
  return { abcBuffer: nextAbcBuffer, patchCount: complete ? 1 : 0 };
}

function fusionLevelMaxStatus(abc: Abc, body: AbcMethodBody): { optimized: boolean; target: FusionPatchTarget | null } {
  const petLevelMaxIndexes = abc.multinames
    .map((multiname, index) => (qname(multiname).endsWith("_petLevelMax") ? index : -1))
    .filter((index) => index > 0);
  const a65Indexes = abc.multinames
    .map((multiname, index) => (qname(multiname).endsWith("a65") ? index : -1))
    .filter((index) => index > 0);
  const a70Indexes = abc.multinames
    .map((multiname, index) => (qname(multiname).endsWith("a70") ? index : -1))
    .filter((index) => index > 0);
  const gsIndexes = abc.multinames
    .map((multiname, index) => (qname(multiname).endsWith("GS") ? index : -1))
    .filter((index) => index > 0);
  if (petLevelMaxIndexes.length === 0 || a65Indexes.length === 0 || gsIndexes.length === 0) {
    return { optimized: false, target: null };
  }

  for (const petLevelMaxIndex of petLevelMaxIndexes) {
    const findPetLevelMax = instruction(0x5e, petLevelMaxIndex);
    let searchOffset = 0;
    while (searchOffset < body.code.length) {
      const findOffset = body.code.indexOf(findPetLevelMax, searchOffset);
      if (findOffset < 0) {
        break;
      }

      const windowEnd = Math.min(body.code.length, findOffset + 96);
      const window = body.code.subarray(findOffset, windowEnd);
      if (
        window.indexOf(pushIntLiteral(SOLAR_PET_FUSION_LEVEL_MAX)) >= 0 ||
        a70Indexes.some((a70Index) => window.indexOf(instruction(0x66, a70Index)) >= 0)
      ) {
        return { optimized: true, target: null };
      }

      for (const gsIndex of gsIndexes) {
        const getLexGs = instruction(0x60, gsIndex);
        for (const a65Index of a65Indexes) {
          const originalSequence = Buffer.concat([getLexGs, instruction(0x66, a65Index)]);
          const sequenceOffset = window.indexOf(originalSequence);
          if (sequenceOffset >= 0) {
            const startOffset = findOffset + sequenceOffset;
            return {
              optimized: false,
              target: {
                startOffset,
                endOffset: startOffset + originalSequence.length,
              },
            };
          }
        }
      }

      searchOffset = findOffset + findPetLevelMax.length;
    }
  }

  return { optimized: false, target: null };
}

function petManagerFusionCandidateBodies(abc: Abc): AbcMethodBody[] {
  const staticBody = staticInitializerBody(abc, PET_MANAGER_CLASS);
  return staticBody ? [staticBody] : abc.methodBodies;
}

function patchPetManagerFusionLevelMax(abcBuffer: Buffer): { abcBuffer: Buffer; patchCount: number } {
  const abc = parseAbc(abcBuffer);
  let targetBody: AbcMethodBody | null = null;
  let target: FusionPatchTarget | null = null;
  for (const body of petManagerFusionCandidateBodies(abc)) {
    const status = fusionLevelMaxStatus(abc, body);
    if (status.optimized) {
      return { abcBuffer, patchCount: 0 };
    }
    if (status.target) {
      targetBody = body;
      target = status.target;
      break;
    }
  }
  if (!target || !targetBody) {
    return { abcBuffer, patchCount: 0 };
  }

  const headers = methodBodyHeaders(abcBuffer);
  const replacement = pushIntLiteral(SOLAR_PET_FUSION_LEVEL_MAX);
  const code = Buffer.concat([
    targetBody.code.subarray(0, target.startOffset),
    replacement,
    targetBody.code.subarray(target.endOffset),
  ]);
  return {
    abcBuffer: replaceMethodCode(abcBuffer, headers, targetBody, code, "solar pet fusion level max"),
    patchCount: 1,
  };
}

function inspectAbcBuffer(abcBuffer: Buffer): SolarPetRuntimePatchInspection {
  const abc = parseAbc(abcBuffer);
  const filenameBody = methodBodyByName(abc, LOADER_MANAGER_CLASS, "initFilename", true);
  const classMappingBody = methodBodyByName(abc, GAME_DATA_INIT_CLASS, "swfClassNameInit", true);
  const classAliasBody = methodBodyByName(abc, LOADER_MANAGER_CLASS, "getSwfClass", true);
  const fusionCandidates = petManagerFusionCandidateBodies(abc);
  const fusionLevelMax = fusionCandidates.some((body) => fusionLevelMaxStatus(abc, body).optimized);
  const filenameMapping = bodyHasString(abc, filenameBody, SOLAR_PET_RESOURCE_NAME) && bodyHasString(abc, filenameBody, SOLAR_PET_ASSET_NAME);
  const classMappings =
    bodyHasString(abc, classMappingBody, `${SOLAR_PET_RESOURCE_NAME}7`) &&
    solarBulletClassAliases().every(([alias]) => bodyHasString(abc, classMappingBody, alias));
  const classAliases = solarBulletClassAliases().every(([alias, internalClass]) => {
    return bodyHasString(abc, classAliasBody, alias) && bodyHasString(abc, classAliasBody, internalClass);
  });
  return {
    targetFound: filenameBody != null || classMappingBody != null || classAliasBody != null || fusionCandidates.length > 0,
    filenameMapping,
    classMappings,
    classAliases,
    fusionLevelMax,
  };
}

function mergeInspection(left: SolarPetRuntimePatchInspection, right: SolarPetRuntimePatchInspection): SolarPetRuntimePatchInspection {
  return {
    targetFound: left.targetFound || right.targetFound,
    filenameMapping: left.filenameMapping || right.filenameMapping,
    classMappings: left.classMappings || right.classMappings,
    classAliases: left.classAliases || right.classAliases,
    fusionLevelMax: left.fusionLevelMax || right.fusionLevelMax,
  };
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

function patchDoAbcData(data: Buffer): { data: Buffer; patchCount: number } {
  const abcRelativeStart = doAbcStart(data);
  let abcBuffer = data.subarray(abcRelativeStart);
  let patchCount = 0;

  let patched = patchLoaderFilenameMapping(abcBuffer);
  abcBuffer = patched.abcBuffer;
  patchCount += patched.patchCount;

  patched = patchGameDataClassMappings(abcBuffer);
  abcBuffer = patched.abcBuffer;
  patchCount += patched.patchCount;

  patched = patchLoaderClassAliases(abcBuffer);
  abcBuffer = patched.abcBuffer;
  patchCount += patched.patchCount;

  patched = patchPetManagerFusionLevelMax(abcBuffer);
  abcBuffer = patched.abcBuffer;
  patchCount += patched.patchCount;

  return {
    data: patchCount > 0 ? Buffer.concat([data.subarray(0, abcRelativeStart), abcBuffer]) : data,
    patchCount,
  };
}

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

export function inspectSolarPetRuntimePatch(swf: DecodedSwf): SolarPetRuntimePatchInspection {
  let result: SolarPetRuntimePatchInspection = {
    targetFound: false,
    filenameMapping: false,
    classMappings: false,
    classAliases: false,
    fusionLevelMax: false,
  };

  for (const tag of parseTags(swf.body)) {
    if (tag.code !== 82) {
      continue;
    }
    const abcRelativeStart = doAbcStart(tag.data);
    result = mergeInspection(result, inspectAbcBuffer(tag.data.subarray(abcRelativeStart)));
  }
  return result;
}

export function patchSolarPetRuntime(swf: DecodedSwf): number {
  const tags = parseTags(swf.body);
  const firstTagOffset = tags[0]?.offset;
  if (firstTagOffset == null) {
    return 0;
  }

  let patchCount = 0;
  const chunks: Buffer[] = [swf.body.subarray(0, firstTagOffset)];

  for (const tag of tags) {
    const originalEnd = tag.dataOffset + tag.length;
    if (tag.code !== 82) {
      chunks.push(swf.body.subarray(tag.offset, originalEnd));
      continue;
    }

    const patched = patchDoAbcData(tag.data);
    patchCount += patched.patchCount;
    chunks.push(patched.patchCount > 0 ? encodeTag(tag.code, patched.data) : swf.body.subarray(tag.offset, originalEnd));
  }

  if (patchCount > 0) {
    swf.body = Buffer.concat(chunks);
  }
  return patchCount;
}
