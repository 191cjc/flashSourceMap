import { type DecodedSwf, parseTags } from "./swf.js";

const CALLBACK_FUNCTION_NAME = "dataIndexYouData";
const PANEL_TRIGGER_CALLBACK_NAME = "codexSendBagItems";
const MAX_BAG_MOCK_ITEMS = 12;
const BAG_ITEM_ID_CALLBACK_KIND = "goodsId";
const BAG_ITEM_COUNT_CALLBACK_KIND = "goodsNum";

const SAVE_PROCESS_METHOD = "hotpointgame.gameobj::Api4399::::saveProcess";
const GM_BASE_DATA_INIT_METHOD = "hotpointgame.Control::GM::static::::baseDatainit";
const BAG_FACTORY_SJ_CH_FUN_METHOD = "hotpointgame.models.bag::BagFactory::static::::sjChFun";
const BAG_FACTORY_BC_LB_METHOD = "hotpointgame.models.bag::BagFactory::static::::bcLb";

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

type AbcMethod = {
  index: number;
  returnType: number;
  params: number[];
  paramOffsets: number[];
  name: string;
};

type AbcMethodBody = {
  index: number;
  method: number;
  maxStack: number;
  localCount: number;
  initScopeDepth: number;
  maxScopeDepth: number;
  codeStart: number;
  code: Buffer;
};

type Abc = {
  strings: string[];
  namespaces: Array<{ kind: number; name: number; value: string } | null>;
  namespaceSets: Array<number[] | null>;
  multinames: Array<Multiname | null>;
  methods: AbcMethod[];
  instances: Array<{ name: number; iinit: number; traits: Trait[] }>;
  classes: Array<{ cinit: number; traits: Trait[] }>;
  scripts: Array<{ init: number; traits: Trait[] }>;
  methodBodies: AbcMethodBody[];
};

type MethodBodyHeader = {
  index: number;
  method: number;
  methodOffset: number;
  maxStack: number;
  maxStackOffset: number;
  localCount: number;
  localCountOffset: number;
  initScopeDepth: number;
  initScopeDepthOffset: number;
  maxScopeDepth: number;
  maxScopeDepthOffset: number;
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
  const methods: AbcMethod[] = [];
  for (let i = 0; i < methodCount; i += 1) {
    const paramCount = reader.u30();
    const returnType = reader.u30();
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

    methods.push({ index: i, returnType, params, paramOffsets, name: strings[name] ?? "" });
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
    const maxStack = reader.u30();
    const localCount = reader.u30();
    const initScopeDepth = reader.u30();
    const maxScopeDepth = reader.u30();
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
    methodBodies.push({ index: i, method, maxStack, localCount, initScopeDepth, maxScopeDepth, codeStart, code });
  }

  return { strings, namespaces, namespaceSets, multinames, methods, instances, classes, scripts, methodBodies };
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
  for (let i = 1; i < count; i += 1) {
    const kind = reader.u8();
    if (kind === 0x07 || kind === 0x0d || kind === 0x09 || kind === 0x0e) {
      reader.u30();
      reader.u30();
    } else if (kind === 0x0f || kind === 0x10 || kind === 0x1b || kind === 0x1c) {
      reader.u30();
    } else if (kind === 0x11 || kind === 0x12) {
      // Marker-only multiname.
    } else if (kind === 0x1d) {
      reader.u30();
      const paramCount = reader.u30();
      for (let j = 0; j < paramCount; j += 1) reader.u30();
    } else {
      throw new Error(`Unsupported ABC multiname kind: ${kind}`);
    }
  }

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
    const methodOffset = reader.offset;
    const method = reader.u30();
    const maxStackOffset = reader.offset;
    const maxStack = reader.u30();
    const localCountOffset = reader.offset;
    const localCount = reader.u30();
    const initScopeDepthOffset = reader.offset;
    const initScopeDepth = reader.u30();
    const maxScopeDepthOffset = reader.offset;
    const maxScopeDepth = reader.u30();
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
    headers.push({
      index: i,
      method,
      methodOffset,
      maxStack,
      maxStackOffset,
      localCount,
      localCountOffset,
      initScopeDepth,
      initScopeDepthOffset,
      maxScopeDepth,
      maxScopeDepthOffset,
      codeLength,
      codeLengthOffset,
      codeStart,
    });
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

  for (const instance of abc.instances) {
    const className = qname(abc.multinames[instance.name]) || `(class#${instance.name})`;
    add(instance.iinit, `${className}::<init>`);
    const classIndex = abc.instances.indexOf(instance);
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
  0x4f: "callpropvoid",
  0x5d: "findpropstrict",
  0x60: "getlex",
  0x61: "setproperty",
  0x62: "getlocal",
  0x63: "setlocal",
  0x66: "getproperty",
  0x73: "convert_i",
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

function operandFor(abc: Abc, body: AbcMethodBody, opName: string, qnameSuffix: string): number {
  for (const decoded of instructionsFor(body)) {
    if (decoded.name !== opName || decoded.operands.length === 0) {
      continue;
    }
    const name = qname(abc.multinames[decoded.operands[0]]) || "";
    if (name.endsWith(qnameSuffix)) {
      return decoded.operands[0];
    }
  }
  throw new Error(`Missing ${opName} ${qnameSuffix}`);
}

function instructionAfter(abc: Abc, body: AbcMethodBody, opName: string, qnameSuffix: string): number {
  for (const decoded of instructionsFor(body)) {
    if (decoded.name !== opName || decoded.operands.length === 0) {
      continue;
    }
    const name = qname(abc.multinames[decoded.operands[0]]) || "";
    if (name.endsWith(qnameSuffix)) {
      return decoded.offset + decoded.length;
    }
  }
  throw new Error(`Missing ${opName} ${qnameSuffix}`);
}

function stringIndexFor(abc: Abc, value: string): number {
  const index = abc.strings.findIndex((item) => item === value);
  if (index < 0) {
    throw new Error(`Missing string constant: ${value}`);
  }
  return index;
}

function bodyHasString(abc: Abc, body: AbcMethodBody, value: string): boolean {
  const index = abc.strings.findIndex((item) => item === value);
  if (index < 0) {
    return false;
  }
  return instructionsFor(body).some((decoded) => decoded.name === "pushstring" && decoded.operands[0] === index);
}

function instruction(op: number, ...operands: number[]): Buffer {
  return Buffer.concat([Buffer.from([op]), ...operands.map((operand) => encodeU30(operand))]);
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

function pushIntLiteral(value: number): Buffer {
  if (value >= -128 && value <= 127) {
    return Buffer.from([0x24, value & 0xff]);
  }
  return instruction(0x25, value);
}

function getLocal(index: number): Buffer {
  return index >= 0 && index <= 3 ? Buffer.from([0xd0 + index]) : instruction(0x62, index);
}

function setLocal(index: number): Buffer {
  return index >= 0 && index <= 3 ? Buffer.from([0xd4 + index]) : instruction(0x63, index);
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
  const oldCodeLengthInfo = readU30At(abcBuffer, header.codeLengthOffset);
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
  if (oldCodeLengthInfo.length !== encodedLength.length) {
    // The new buffer layout already accounts for the encoded length change.
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
  for (let i = 1; i < multinameCount; i += 1) {
    const kind = reader.u8();
    if (kind === 0x07 || kind === 0x0d || kind === 0x09 || kind === 0x0e) {
      reader.u30();
      reader.u30();
    } else if (kind === 0x0f || kind === 0x10 || kind === 0x1b || kind === 0x1c) {
      reader.u30();
    } else if (kind === 0x11 || kind === 0x12) {
      // Marker-only multiname.
    } else if (kind === 0x1d) {
      reader.u30();
      const paramCount = reader.u30();
      for (let j = 0; j < paramCount; j += 1) reader.u30();
    } else {
      throw new Error(`Unsupported ABC multiname kind: ${kind}`);
    }
  }

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

function ensureMultinameKind9(
  abcBuffer: Buffer,
  abc: Abc,
  nameIndex: number,
  nssetIndex: number
): { abcBuffer: Buffer; index: number } {
  const existing = abc.multinames.findIndex((item) => item?.kind === 0x09 && item.name === nameIndex && item.nsset === nssetIndex);
  if (existing >= 0) {
    return { abcBuffer, index: existing };
  }

  const offsets = constantPoolOffsets(abcBuffer);
  const oldCountInfo = readU30At(abcBuffer, offsets.multinameCountOffset);
  const entry = Buffer.concat([Buffer.from([0x09]), encodeU30(nameIndex), encodeU30(nssetIndex)]);
  return {
    abcBuffer: Buffer.concat([
      abcBuffer.subarray(0, offsets.multinameCountOffset),
      encodeU30(oldCountInfo.value + 1),
      abcBuffer.subarray(offsets.multinameCountOffset + oldCountInfo.length, offsets.multinamesEnd),
      entry,
      abcBuffer.subarray(offsets.multinamesEnd),
    ]),
    index: oldCountInfo.value,
  };
}

function ensureBagPanelCallbackConstants(abcBuffer: Buffer): {
  abcBuffer: Buffer;
  addCallbackMultiname: number;
  availableMultiname: number;
  panelCallbackString: number;
} {
  let nextAbcBuffer = abcBuffer;
  let abc = parseAbc(nextAbcBuffer);

  let ensured = ensureStringConstant(nextAbcBuffer, abc, "addCallback");
  nextAbcBuffer = ensured.abcBuffer;
  abc = parseAbc(nextAbcBuffer);
  const addCallbackString = ensured.index;

  ensured = ensureStringConstant(nextAbcBuffer, abc, "available");
  nextAbcBuffer = ensured.abcBuffer;
  abc = parseAbc(nextAbcBuffer);
  const availableString = ensured.index;

  ensured = ensureStringConstant(nextAbcBuffer, abc, PANEL_TRIGGER_CALLBACK_NAME);
  nextAbcBuffer = ensured.abcBuffer;
  abc = parseAbc(nextAbcBuffer);
  const panelCallbackString = ensured.index;

  const saveProcessBody = methodBodyFor(abc, SAVE_PROCESS_METHOD);
  if (!saveProcessBody) {
    throw new Error(`${SAVE_PROCESS_METHOD} is required to reuse ExternalInterface operands`);
  }
  const externalCall = operandFor(abc, saveProcessBody, "callproperty", "::call");
  const callMultiname = abc.multinames[externalCall];
  if (!callMultiname || callMultiname.kind !== 0x09 || !callMultiname.nsset) {
    throw new Error("ExternalInterface.call multiname is not a multiname-set entry");
  }

  let multiname = ensureMultinameKind9(nextAbcBuffer, abc, addCallbackString, callMultiname.nsset);
  nextAbcBuffer = multiname.abcBuffer;
  abc = parseAbc(nextAbcBuffer);
  const addCallbackMultiname = multiname.index;

  multiname = ensureMultinameKind9(nextAbcBuffer, abc, availableString, callMultiname.nsset);
  nextAbcBuffer = multiname.abcBuffer;

  return { abcBuffer: nextAbcBuffer, addCallbackMultiname, availableMultiname: multiname.index, panelCallbackString };
}

function ensureBagSendValueConstants(abcBuffer: Buffer): Buffer {
  let nextAbcBuffer = abcBuffer;
  for (const value of [CALLBACK_FUNCTION_NAME, BAG_ITEM_ID_CALLBACK_KIND, BAG_ITEM_COUNT_CALLBACK_KIND]) {
    const abc = parseAbc(nextAbcBuffer);
    nextAbcBuffer = ensureStringConstant(nextAbcBuffer, abc, value).abcBuffer;
  }
  return nextAbcBuffer;
}

function buildBagInsertCode(abc: Abc, saveProcessBody: AbcMethodBody, bagSjChFunBody: AbcMethodBody): Buffer {
  const externalInterface = operandFor(abc, saveProcessBody, "getlex", "::ExternalInterface");
  const externalCall = operandFor(abc, saveProcessBody, "callproperty", "::call");
  const callbackString = stringIndexFor(abc, CALLBACK_FUNCTION_NAME);
  const goodsIdString = stringIndexFor(abc, BAG_ITEM_ID_CALLBACK_KIND);
  const goodsNumString = stringIndexFor(abc, BAG_ITEM_COUNT_CALLBACK_KIND);
  const addInBagById = operandFor(abc, bagSjChFunBody, "callpropvoid", "::addInBagById");
  const isFullById = operandFor(abc, bagSjChFunBody, "callproperty", "::isFullById");
  const hdGoodsTs = operandFor(abc, bagSjChFunBody, "callpropvoid", "::hdGoodsTs");

  const callbackCall = (kindString: number, slotCode: number): Buffer => Buffer.concat([
    instruction(0x60, externalInterface),
    instruction(0x2c, callbackString),
    instruction(0x2c, kindString),
    pushIntLiteral(slotCode),
    instruction(0x46, externalCall, 3),
  ]);

  const bagItemCode = (index: number): AssemblyPart[] => [
    callbackCall(goodsIdString, index),
    Buffer.from([0x73]),
    setLocal(3),
    getLocal(3),
    pushIntLiteral(0),
    branch(0x0e, `skipBagMock${index}`),
    callbackCall(goodsNumString, index),
    Buffer.from([0x73]),
    setLocal(4),
    getLocal(4),
    pushIntLiteral(1),
    branch(0x18, `hasBagCount${index}`),
    pushIntLiteral(1),
    setLocal(4),
    label(`hasBagCount${index}`),
    instruction(0x5d, isFullById),
    getLocal(3),
    getLocal(4),
    instruction(0x46, isFullById, 2),
    branch(0x12, `skipBagMock${index}`),
    instruction(0x5d, addInBagById),
    getLocal(3),
    getLocal(4),
    pushIntLiteral(0),
    instruction(0x4f, addInBagById, 3),
    instruction(0x5d, hdGoodsTs),
    getLocal(3),
    getLocal(4),
    instruction(0x4f, hdGoodsTs, 2),
    label(`skipBagMock${index}`),
  ];

  return assemble([
    ...Array.from({ length: MAX_BAG_MOCK_ITEMS }, (_, index) => bagItemCode(index)).flat(),
    instruction(0x60, externalInterface),
    instruction(0x2c, callbackString),
    instruction(0x2c, goodsIdString),
    pushIntLiteral(MAX_BAG_MOCK_ITEMS),
    instruction(0x46, externalCall, 3),
    Buffer.from([0x29]),
  ]);
}

function buildBagPanelTriggerCode(abc: Abc, saveProcessBody: AbcMethodBody, bagSjChFunBody: AbcMethodBody): Buffer {
  return assemble([
    Buffer.from([0xd0, 0x30]),
    buildBagInsertCode(abc, saveProcessBody, bagSjChFunBody),
    Buffer.from([0x47]),
  ]);
}

function buildBagPanelCallbackRegistrationCode(
  abc: Abc,
  saveProcessBody: AbcMethodBody,
  constants: { addCallbackMultiname: number; availableMultiname: number; panelCallbackString: number }
): Buffer {
  const externalInterface = operandFor(abc, saveProcessBody, "getlex", "::ExternalInterface");
  const bagFactory = abc.multinames.findIndex((item) => (qname(item) || "").endsWith("::BagFactory"));
  const bcLb = abc.multinames.findIndex((item) => (qname(item) || "").endsWith("::bcLb"));
  if (bagFactory < 0 || bcLb < 0) {
    throw new Error("Missing BagFactory or bcLb multiname");
  }

  return assemble([
    instruction(0x60, externalInterface),
    instruction(0x66, constants.availableMultiname),
    branch(0x12, "skipBagPanelCallbackRegistration"),
    instruction(0x60, externalInterface),
    instruction(0x2c, constants.panelCallbackString),
    instruction(0x60, bagFactory),
    instruction(0x66, bcLb),
    instruction(0x46, constants.addCallbackMultiname, 2),
    Buffer.from([0x29]),
    label("skipBagPanelCallbackRegistration"),
  ]);
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
  let abc = parseAbc(abcBuffer);
  let headers = methodBodyHeaders(abcBuffer);
  let patchCount = 0;

  const saveProcessBody = methodBodyFor(abc, SAVE_PROCESS_METHOD);
  const bagSjChFunBody = methodBodyFor(abc, BAG_FACTORY_SJ_CH_FUN_METHOD);
  const bagBcLbBody = methodBodyFor(abc, BAG_FACTORY_BC_LB_METHOD);
  if (!saveProcessBody || !bagSjChFunBody || !bagBcLbBody) {
    return { data, patchCount };
  }

  if (!bodyHasString(abc, bagBcLbBody, CALLBACK_FUNCTION_NAME)) {
    abcBuffer = ensureBagSendValueConstants(abcBuffer);
    abc = parseAbc(abcBuffer);
    headers = methodBodyHeaders(abcBuffer);

    const saveProcessBodyForInsert = methodBodyFor(abc, SAVE_PROCESS_METHOD);
    const bagSjChFunBodyForInsert = methodBodyFor(abc, BAG_FACTORY_SJ_CH_FUN_METHOD);
    const bagBcLbBodyForInsert = methodBodyFor(abc, BAG_FACTORY_BC_LB_METHOD);
    if (!saveProcessBodyForInsert || !bagSjChFunBodyForInsert || !bagBcLbBodyForInsert) {
      return { data, patchCount };
    }

    const panelTriggerCode = buildBagPanelTriggerCode(abc, saveProcessBodyForInsert, bagSjChFunBodyForInsert);
    abcBuffer = replaceMethodCode(
      abcBuffer,
      headers,
      bagBcLbBodyForInsert,
      panelTriggerCode,
      BAG_FACTORY_BC_LB_METHOD,
      { maxStack: Math.max(bagBcLbBodyForInsert.maxStack, 16), localCount: Math.max(bagBcLbBodyForInsert.localCount, 5) }
    );
    patchCount += 1;
    abc = parseAbc(abcBuffer);
    headers = methodBodyHeaders(abcBuffer);
  }

  const constants = ensureBagPanelCallbackConstants(abcBuffer);
  abcBuffer = constants.abcBuffer;
  abc = parseAbc(abcBuffer);
  headers = methodBodyHeaders(abcBuffer);

  const gmBaseDatainitBody = methodBodyFor(abc, GM_BASE_DATA_INIT_METHOD);
  const saveProcessBodyForPanel = methodBodyFor(abc, SAVE_PROCESS_METHOD);
  if (gmBaseDatainitBody && saveProcessBodyForPanel && !bodyHasString(abc, gmBaseDatainitBody, PANEL_TRIGGER_CALLBACK_NAME)) {
    const insertOffset = instructionAfter(abc, gmBaseDatainitBody, "callpropvoid", "::gameStart");
    const registration = buildBagPanelCallbackRegistrationCode(abc, saveProcessBodyForPanel, constants);
    abcBuffer = insertMethodCode(
      abcBuffer,
      headers,
      gmBaseDatainitBody,
      insertOffset,
      registration,
      GM_BASE_DATA_INIT_METHOD,
      { maxStack: Math.max(gmBaseDatainitBody.maxStack, 4), localCount: gmBaseDatainitBody.localCount }
    );
    patchCount += 1;
  }

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

export function patchBagItemSenderCompatibility(swf: DecodedSwf): number {
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
