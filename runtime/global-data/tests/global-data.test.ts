import assert from "node:assert/strict";
import { mkdtempSync, rmSync } from "node:fs";
import { tmpdir } from "node:os";
import path from "node:path";
import { startGlobalDataServer } from "../server/server.js";

const dir = mkdtempSync(path.join(tmpdir(), "flash-global-data-"));
const server = await startGlobalDataServer({ host: "127.0.0.1", port: 0, dbFile: path.join(dir, "global.db") });
const THRIFT = { STOP: 0, I32: 8, STRING: 11, STRUCT: 12 } as const;

function thriftI16(value: number): Buffer {
  const buffer = Buffer.alloc(2);
  buffer.writeInt16BE(value);
  return buffer;
}

function thriftI32(value: number): Buffer {
  const buffer = Buffer.alloc(4);
  buffer.writeInt32BE(value);
  return buffer;
}

function thriftString(value: string): Buffer {
  const bytes = Buffer.from(value, "utf8");
  return Buffer.concat([thriftI32(bytes.length), bytes]);
}

function thriftField(type: number, id: number, value: Buffer): Buffer {
  return Buffer.concat([Buffer.from([type]), thriftI16(id), value]);
}

function thriftStruct(fields: Buffer[]): Buffer {
  return Buffer.concat([...fields, Buffer.from([THRIFT.STOP])]);
}

function unionRequest(methodName: string, fields: Buffer[] = []): Buffer {
  const header = thriftStruct([
    thriftField(THRIFT.STRING, 1, thriftString("global-test")),
    thriftField(THRIFT.STRING, 2, thriftString("100025235")),
    thriftField(THRIFT.I32, 3, thriftI32(0)),
  ]);
  const versionAndType = Buffer.alloc(4);
  versionAndType.writeUInt32BE(0x80010001);
  return Buffer.concat([
    versionAndType,
    thriftString(methodName),
    thriftI32(1),
    thriftStruct([thriftField(THRIFT.STRUCT, 1, header), ...fields]),
  ]);
}

async function unionApiRequest(uid: number, requestBody: Buffer): Promise<Response> {
  return fetch(`${server.url}/api/4399/union/FlashUnionApi`, {
    method: "POST",
    headers: { "content-type": "application/x-thrift", "x-flash-uid": String(uid) },
    body: new Uint8Array(requestBody),
  });
}

async function jsonRequest(pathname: string, init?: RequestInit): Promise<{ status: number; body: any }> {
  const response = await fetch(`${server.url}${pathname}`, {
    ...init,
    headers: { "content-type": "application/json", ...(init?.headers ?? {}) },
  });
  return { status: response.status, body: await response.json() };
}

try {
  const health = await jsonRequest("/health");
  assert.equal(health.status, 200);
  assert.equal(health.body.ok, true);

  const registration = await jsonRequest("/api/global/register", {
    method: "POST",
    body: JSON.stringify({ instanceId: "windows-a", sourceUid: 10001, username: "local_user", nickname: "玩家A" }),
  });
  assert.equal(registration.status, 200);
  assert.equal(registration.body.uid, 10000001);
  assert.equal(registration.body.username, "player_10000001");
  assert.equal(registration.body.newlyAllocated, true);

  const repeated = await jsonRequest("/api/global/register", {
    method: "POST",
    body: JSON.stringify({ instanceId: "windows-a", sourceUid: 10001, username: "ignored", nickname: "忽略" }),
  });
  assert.equal(repeated.body.uid, 10000001);
  assert.equal(repeated.body.newlyAllocated, false);

  const second = await jsonRequest("/api/global/register", {
    method: "POST",
    body: JSON.stringify({ instanceId: "windows-b", sourceUid: 10001, username: "local_user", nickname: "玩家B" }),
  });
  assert.equal(second.body.uid, 10000002);

  const renamed = await jsonRequest("/api/global/players/10000001", {
    method: "PATCH",
    body: JSON.stringify({ username: "测试玩家_A" }),
  });
  assert.equal(renamed.status, 200);
  assert.equal(renamed.body.player.username, "测试玩家_A");

  const save = await jsonRequest("/api/global/saves/10000001/0", {
    method: "PUT",
    body: JSON.stringify({ gameId: "100025235", title: "角色一", data: "save-data-v1", checksum: "checksum-v1", revision: 1 }),
  });
  assert.equal(save.status, 200);
  assert.equal(save.body.ignored, false);

  const repeatedSave = await jsonRequest("/api/global/saves/10000001/0", {
    method: "PUT",
    body: JSON.stringify({ gameId: "100025235", title: "角色一", data: "save-data-v1", checksum: "checksum-v1", revision: 1 }),
  });
  assert.equal(repeatedSave.body.ignored, true);

  const olderSave = await jsonRequest("/api/global/saves/10000001/0", {
    method: "PUT",
    body: JSON.stringify({ gameId: "100025235", title: "旧角色", data: "old", checksum: "old", revision: 0 }),
  });
  assert.equal(olderSave.body.ignored, true);
  assert.equal(olderSave.body.save.revision, 1);

  const fetched = await jsonRequest("/api/global/saves/10000001/0?gameId=100025235");
  assert.equal(fetched.body.save.data, "save-data-v1");

  const conflict = await jsonRequest("/api/global/saves/10000001/0", {
    method: "PUT",
    body: JSON.stringify({ gameId: "100025235", title: "冲突", data: "conflict", checksum: "other", revision: 1 }),
  });
  assert.equal(conflict.status, 409);
  assert.equal(conflict.body.error, "revision_conflict");

  const createUnion = await unionApiRequest(
    10000001,
    unionRequest("unionCreate", [
      thriftField(THRIFT.STRING, 2, thriftString("Linux测试军团")),
      thriftField(THRIFT.STRING, 3, thriftString("全局军团公告*0")),
    ])
  );
  assert.equal(createUnion.status, 200);
  assert.match(createUnion.headers.get("content-type") ?? "", /application\/x-thrift/);
  assert.ok((await createUnion.arrayBuffer()).byteLength > 0);

  const unionRow = server.db.db
    .prepare("SELECT title, owner_uid, owner_username FROM union_mock WHERE game_id = ?")
    .get("100025235") as { title: string; owner_uid: string; owner_username: string };
  assert.deepEqual({ ...unionRow }, {
    title: "Linux测试军团",
    owner_uid: "10000001",
    owner_username: "测试玩家_A",
  });
  const memberRow = server.db.db
    .prepare("SELECT uid, slot_index, role_name FROM union_member_mock WHERE union_id = 1")
    .get() as { uid: string; slot_index: number; role_name: string };
  assert.deepEqual({ ...memberRow }, { uid: "10000001", slot_index: 0, role_name: "团长" });

  const sharedUnionList = await unionApiRequest(10000002, unionRequest("unionList"));
  assert.equal(sharedUnionList.status, 200);
  assert.ok((await sharedUnionList.arrayBuffer()).byteLength > 0);

  console.log("global data flow ok");
} finally {
  await server.close();
  rmSync(dir, { recursive: true, force: true });
}
