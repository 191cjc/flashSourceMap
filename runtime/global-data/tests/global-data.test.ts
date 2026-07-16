import assert from "node:assert/strict";
import { mkdtempSync, rmSync } from "node:fs";
import { tmpdir } from "node:os";
import path from "node:path";
import { startGlobalDataServer } from "../server/server.js";

const dir = mkdtempSync(path.join(tmpdir(), "flash-global-data-"));
const server = await startGlobalDataServer({ host: "127.0.0.1", port: 0, dbFile: path.join(dir, "global.db") });
const THRIFT = { STOP: 0, I32: 8, STRING: 11, STRUCT: 12, LIST: 15 } as const;

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

function rankRequest(uid: number, methodName: string, fields: Buffer[]): Buffer {
  const header = thriftStruct([
    thriftField(THRIFT.STRING, 1, thriftString(String(uid))),
    thriftField(THRIFT.STRING, 2, thriftString("100025235")),
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

function rankSubmitRequest(uid: number, slotIndex: number, rankListId: number, score: number, extra: string): Buffer {
  const submission = thriftStruct([
    thriftField(THRIFT.I32, 1, thriftI32(rankListId)),
    thriftField(THRIFT.I32, 2, thriftI32(score)),
    thriftField(THRIFT.STRING, 3, thriftString(extra)),
  ]);
  return rankRequest(uid, "submit", [
    thriftField(THRIFT.I32, 2, thriftI32(slotIndex)),
    thriftField(THRIFT.LIST, 3, Buffer.concat([Buffer.from([THRIFT.STRUCT]), thriftI32(1), submission])),
  ]);
}

async function unionApiRequest(uid: number, requestBody: Buffer): Promise<Response> {
  return fetch(`${server.url}/api/4399/union/FlashUnionApi`, {
    method: "POST",
    headers: { "content-type": "application/x-thrift", "x-flash-uid": String(uid) },
    body: new Uint8Array(requestBody),
  });
}

async function rankApiRequest(uid: number, requestBody: Buffer): Promise<Response> {
  return fetch(`${server.url}/api/4399/rank/FlashScoreApi`, {
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

  const firstRankSubmit = await rankApiRequest(10000001, rankSubmitRequest(10000001, 0, 1093, 1200, "player-a-extra"));
  assert.equal(firstRankSubmit.status, 200);
  assert.ok((await firstRankSubmit.arrayBuffer()).byteLength > 0);
  const secondRankSubmit = await rankApiRequest(10000002, rankSubmitRequest(10000002, 1, 1093, 1500, "player-b-extra"));
  assert.equal(secondRankSubmit.status, 200);
  assert.ok((await secondRankSubmit.arrayBuffer()).byteLength > 0);

  const rankRows = server.db.db
    .prepare("SELECT uid, slot_index, score, extra FROM rank_entries WHERE rank_list_id = 1093 ORDER BY score DESC")
    .all() as Array<{ uid: number; slot_index: number; score: number; extra: string }>;
  assert.deepEqual(rankRows.map((row) => ({ ...row })), [
    { uid: 10000002, slot_index: 1, score: 1500, extra: "player-b-extra" },
    { uid: 10000001, slot_index: 0, score: 1200, extra: "player-a-extra" },
  ]);

  const rankPage = await rankApiRequest(
    10000001,
    rankRequest(10000001, "getRankingByPage", [
      thriftField(THRIFT.I32, 2, thriftI32(1093)),
      thriftField(THRIFT.I32, 3, thriftI32(100)),
      thriftField(THRIFT.I32, 4, thriftI32(1)),
    ])
  );
  assert.equal(rankPage.status, 200);
  const rankPageBody = Buffer.from(await rankPage.arrayBuffer());
  assert.ok(rankPageBody.includes(Buffer.from("player-b-extra")));
  assert.ok(rankPageBody.includes(Buffer.from("player-a-extra")));

  const rankToken = await fetch(`${server.url}/ranging.php/?ac=get_token`);
  assert.equal(await rankToken.text(), "global-rank-token");
  const opponentSave = await fetch(`${server.url}/ranging.php/?ac=get`, {
    method: "POST",
    headers: { "content-type": "application/x-www-form-urlencoded" },
    body: new URLSearchParams({ uid: "10000001", gameid: "100025235", index: "0" }),
  });
  assert.deepEqual(await opponentSave.json(), {
    index: 0,
    title: "角色一",
    datetime: fetched.body.save.updatedAt,
    data: "save-data-v1",
    status: "0",
  });

  const staffPage = await fetch(`${server.url}/staff`);
  assert.equal(staffPage.status, 200);
  assert.match(staffPage.headers.get("content-type") ?? "", /text\/html/);
  assert.match(await staffPage.text(), /联机数据控制台/);

  const staffScript = await fetch(`${server.url}/staff/app.js`);
  assert.equal(staffScript.status, 200);
  assert.match(staffScript.headers.get("content-type") ?? "", /javascript/);
  assert.match(await staffScript.text(), /api\/staff\/overview/);

  const staffResponse = await jsonRequest("/api/staff/overview");
  assert.equal(staffResponse.status, 200);
  assert.equal(staffResponse.body.ok, true);
  assert.deepEqual(staffResponse.body.summary, {
    playerCount: 2,
    saveSlotCount: 1,
    unionCount: 1,
    unionMemberCount: 1,
    unionApplicationCount: 0,
    rankEntryCount: 2,
  });
  assert.equal(staffResponse.body.players.length, 2);
  const staffPlayer = staffResponse.body.players.find((player: { uid: number }) => player.uid === 10000001);
  assert.deepEqual(
    {
      username: staffPlayer.username,
      saveCount: staffPlayer.saveCount,
      unionMembershipCount: staffPlayer.unionMembershipCount,
      rankEntryCount: staffPlayer.rankEntryCount,
    },
    { username: "测试玩家_A", saveCount: 1, unionMembershipCount: 1, rankEntryCount: 1 }
  );
  assert.equal(staffResponse.body.unions[0].title, "Linux测试军团");
  assert.equal(staffResponse.body.unions[0].members[0].uid, "10000001");
  assert.deepEqual(staffResponse.body.ranks, [
    { rankListId: 1093, entryCount: 2, topScore: 1500, updatedAt: staffResponse.body.ranks[0].updatedAt },
  ]);
  assert.equal(JSON.stringify(staffResponse.body).includes("save-data-v1"), false);

  console.log("global data flow ok");
} finally {
  await server.close();
  rmSync(dir, { recursive: true, force: true });
}
