import assert from "node:assert/strict";
import { mkdtempSync, rmSync } from "node:fs";
import { tmpdir } from "node:os";
import path from "node:path";
import { inflateSync } from "node:zlib";
import { startGlobalDataServer } from "../server/server.js";

const dir = mkdtempSync(path.join(tmpdir(), "flash-global-data-"));
const server = await startGlobalDataServer({ host: "127.0.0.1", port: 0, dbFile: path.join(dir, "global.db") });
const THRIFT = { STOP: 0, I32: 8, STRING: 11, STRUCT: 12, LIST: 15 } as const;
const FIRST_SAVE_DATA = '<saveXml type="Object" game4399="true"><s type="Object" name="null"><s type="Number" name="jxid">10000001</s><s type="Number" name="sidx">0</s><s type="String" name="idn">player_a</s><s type="Number" name="idai">10000001</s></s></saveXml>';
const SECOND_SAVE_DATA = '<saveXml type="Object" game4399="true"><s type="Object" name="null"><s type="Number" name="jxid">10000002</s><s type="Number" name="sidx">1</s><s type="String" name="idn">player_b</s><s type="Number" name="idai">20000004</s></s></saveXml>';

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

function readThriftStruct(buffer: Buffer, startOffset: number): { fields: Map<number, unknown>; offset: number } {
  const fields = new Map<number, unknown>();
  let offset = startOffset;
  while (buffer[offset] !== THRIFT.STOP) {
    const type = buffer[offset++];
    const id = buffer.readInt16BE(offset);
    offset += 2;
    const value = readThriftValue(buffer, offset, type);
    fields.set(id, value.value);
    offset = value.offset;
  }
  return { fields, offset: offset + 1 };
}

function readThriftValue(buffer: Buffer, startOffset: number, type: number): { value: unknown; offset: number } {
  if (type === THRIFT.I32) {
    return { value: buffer.readInt32BE(startOffset), offset: startOffset + 4 };
  }
  if (type === THRIFT.STRING) {
    const length = buffer.readInt32BE(startOffset);
    const valueOffset = startOffset + 4;
    return { value: buffer.subarray(valueOffset, valueOffset + length).toString("utf8"), offset: valueOffset + length };
  }
  if (type === THRIFT.STRUCT) {
    const result = readThriftStruct(buffer, startOffset);
    return { value: result.fields, offset: result.offset };
  }
  if (type === THRIFT.LIST) {
    const elementType = buffer[startOffset];
    const size = buffer.readInt32BE(startOffset + 1);
    const values: unknown[] = [];
    let offset = startOffset + 5;
    for (let index = 0; index < size; index += 1) {
      const item = readThriftValue(buffer, offset, elementType);
      values.push(item.value);
      offset = item.offset;
    }
    return { value: values, offset };
  }
  throw new Error(`Unsupported test thrift type: ${type}`);
}

function readThriftResponse(body: Buffer): Map<number, unknown> {
  let offset = 4;
  const methodLength = body.readInt32BE(offset);
  offset += 4 + methodLength + 4;
  return readThriftStruct(body, offset).fields;
}

function readAmf3U29(buffer: Buffer, startOffset: number): { value: number; offset: number } {
  let value = 0;
  let offset = startOffset;
  for (let index = 0; index < 3; index += 1) {
    const byte = buffer[offset++];
    value = (value << 7) | (byte & 0x7f);
    if ((byte & 0x80) === 0) return { value, offset };
  }
  return { value: (value << 8) | buffer[offset++], offset };
}

function readAmf3String(buffer: Buffer, startOffset: number): { value: string; offset: number } {
  const header = readAmf3U29(buffer, startOffset);
  assert.equal(header.value & 1, 1);
  const length = header.value >> 1;
  return {
    value: buffer.subarray(header.offset, header.offset + length).toString("utf8"),
    offset: header.offset + length,
  };
}

function readAmf3Value(buffer: Buffer, startOffset: number): { value: unknown; offset: number } {
  const marker = buffer[startOffset];
  if (marker === 0x01) return { value: null, offset: startOffset + 1 };
  if (marker === 0x02) return { value: false, offset: startOffset + 1 };
  if (marker === 0x03) return { value: true, offset: startOffset + 1 };
  if (marker === 0x04) {
    const encoded = readAmf3U29(buffer, startOffset + 1);
    return { value: encoded.value & 0x10000000 ? encoded.value - 0x20000000 : encoded.value, offset: encoded.offset };
  }
  if (marker === 0x05) return { value: buffer.readDoubleBE(startOffset + 1), offset: startOffset + 9 };
  if (marker === 0x06) return readAmf3String(buffer, startOffset + 1);
  if (marker === 0x09) {
    const header = readAmf3U29(buffer, startOffset + 1);
    assert.equal(header.value & 1, 1);
    const length = header.value >> 1;
    const associativeEnd = readAmf3String(buffer, header.offset);
    assert.equal(associativeEnd.value, "");
    const values: unknown[] = [];
    let offset = associativeEnd.offset;
    for (let index = 0; index < length; index += 1) {
      const entry = readAmf3Value(buffer, offset);
      values.push(entry.value);
      offset = entry.offset;
    }
    return { value: values, offset };
  }
  if (marker === 0x0a) {
    const traits = readAmf3U29(buffer, startOffset + 1);
    assert.equal(traits.value, 0x0b);
    const className = readAmf3String(buffer, traits.offset);
    assert.equal(className.value, "");
    const value: Record<string, unknown> = {};
    let offset = className.offset;
    while (true) {
      const key = readAmf3String(buffer, offset);
      offset = key.offset;
      if (!key.value) return { value, offset };
      const entry = readAmf3Value(buffer, offset);
      value[key.value] = entry.value;
      offset = entry.offset;
    }
  }
  throw new Error(`Unsupported test AMF3 marker: ${marker}`);
}

function decodeArenaExtra(value: string): Record<string, unknown> {
  const decoded = readAmf3Value(inflateSync(Buffer.from(value, "base64")), 0).value;
  assert.equal(typeof decoded, "object");
  assert.ok(decoded);
  return decoded as Record<string, unknown>;
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

function rankAroundRequest(uid: number, slotIndex: number, count = 50): Buffer {
  return rankRequest(uid, "getRankingByArounds", [
    thriftField(THRIFT.I32, 2, thriftI32(slotIndex)),
    thriftField(THRIFT.I32, 3, thriftI32(1093)),
    thriftField(THRIFT.I32, 4, thriftI32(count)),
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
    body: JSON.stringify({ gameId: "100025235", title: "角色一", data: FIRST_SAVE_DATA, checksum: "checksum-v1", revision: 1 }),
  });
  assert.equal(save.status, 200);
  assert.equal(save.body.ignored, false);

  const repeatedSave = await jsonRequest("/api/global/saves/10000001/0", {
    method: "PUT",
    body: JSON.stringify({ gameId: "100025235", title: "角色一", data: FIRST_SAVE_DATA, checksum: "checksum-v1", revision: 1 }),
  });
  assert.equal(repeatedSave.body.ignored, true);

  const olderSave = await jsonRequest("/api/global/saves/10000001/0", {
    method: "PUT",
    body: JSON.stringify({ gameId: "100025235", title: "旧角色", data: "old", checksum: "old", revision: 0 }),
  });
  assert.equal(olderSave.body.ignored, true);
  assert.equal(olderSave.body.save.revision, 1);

  const fetched = await jsonRequest("/api/global/saves/10000001/0?gameId=100025235");
  assert.equal(fetched.body.save.data, FIRST_SAVE_DATA);

  const conflict = await jsonRequest("/api/global/saves/10000001/0", {
    method: "PUT",
    body: JSON.stringify({ gameId: "100025235", title: "冲突", data: "conflict", checksum: "other", revision: 1 }),
  });
  assert.equal(conflict.status, 409);
  assert.equal(conflict.body.error, "revision_conflict");

  const emptyUnionList = await unionApiRequest(10000001, unionRequest("unionList"));
  assert.equal(emptyUnionList.status, 200);
  const emptyUnionResult = readThriftResponse(Buffer.from(await emptyUnionList.arrayBuffer())).get(0) as Map<number, unknown>;
  assert.deepEqual(emptyUnionResult.get(2), []);
  assert.equal(emptyUnionResult.get(3), "0");

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

  const persistedBeforeMirrorCandidates = server.db.db
    .prepare("SELECT (SELECT COUNT(*) FROM global_players) players, (SELECT COUNT(*) FROM remote_save_slots) saves, (SELECT COUNT(*) FROM rank_entries) ranks")
    .get();
  const mirrorCandidatesResponse = await rankApiRequest(10000001, rankAroundRequest(10000001, 0));
  const mirrorCandidatesResult = readThriftResponse(Buffer.from(await mirrorCandidatesResponse.arrayBuffer())).get(0) as Map<number, unknown>;
  const mirrorCandidates = mirrorCandidatesResult.get(3) as Array<Map<number, unknown>>;
  assert.equal(mirrorCandidates.length, 50);
  assert.equal(mirrorCandidates.every((entry) => entry.get(2) === "10000001" && entry.get(1) === "1"), true);
  assert.deepEqual(decodeArenaExtra(String(mirrorCandidates[0].get(8))), {
    qsl: 0,
    qsb: 0,
    qls: 0,
    lv: 1,
    ca: 0,
    cb: 0,
    tx: [],
    jo: 1,
    fe: [],
  });
  const mirroredCandidateSaveResponse = await fetch(`${server.url}/ranging.php/?ac=get&uid=10000001&gameid=100025235&index=1`, {
    headers: { "x-flash-uid": "10000001" },
  });
  const mirroredCandidateSave = await mirroredCandidateSaveResponse.json() as { index: number; data: string; status: string };
  assert.equal(mirroredCandidateSave.index, 1);
  assert.match(mirroredCandidateSave.data, /<s type="Number" name="jxid">10000001<\/s>/);
  assert.match(mirroredCandidateSave.data, /<s type="Number" name="sidx">1<\/s>/);
  assert.equal(mirroredCandidateSave.status, "0");
  assert.deepEqual(
    server.db.db
      .prepare("SELECT (SELECT COUNT(*) FROM global_players) players, (SELECT COUNT(*) FROM remote_save_slots) saves, (SELECT COUNT(*) FROM rank_entries) ranks")
      .get(),
    persistedBeforeMirrorCandidates
  );

  const secondSave = await jsonRequest("/api/global/saves/10000002/1", {
    method: "PUT",
    body: JSON.stringify({ gameId: "100025235", title: "player-b", data: SECOND_SAVE_DATA, checksum: "checksum-b", revision: 1 }),
  });
  assert.equal(secondSave.status, 200);
  const realCandidatesResponse = await rankApiRequest(10000001, rankAroundRequest(10000001, 0));
  const realCandidatesResult = readThriftResponse(Buffer.from(await realCandidatesResponse.arrayBuffer())).get(0) as Map<number, unknown>;
  const realCandidates = realCandidatesResult.get(3) as Array<Map<number, unknown>>;
  assert.equal(realCandidates.length, 50);
  assert.equal(realCandidates.every((entry) => entry.get(2) === "10000002" && entry.get(1) === "1"), true);
  assert.equal(decodeArenaExtra(String(realCandidates[0].get(8))).qsl, 0);

  const thirdRegistration = await jsonRequest("/api/global/register", {
    method: "POST",
    body: JSON.stringify({ instanceId: "instance-c", sourceUid: 10000003, username: "player_c", nickname: "玩家C" }),
  });
  assert.equal(thirdRegistration.status, 200);
  const thirdSave = await jsonRequest("/api/global/saves/10000003/1", {
    method: "PUT",
    body: JSON.stringify({ gameId: "100025235", title: "player-c", data: SECOND_SAVE_DATA, checksum: "checksum-c", revision: 1 }),
  });
  assert.equal(thirdSave.status, 200);
  const noRankCandidateResponse = await rankApiRequest(10000001, rankAroundRequest(10000001, 0));
  const noRankCandidateResult = readThriftResponse(Buffer.from(await noRankCandidateResponse.arrayBuffer())).get(0) as Map<number, unknown>;
  const noRankCandidate = (noRankCandidateResult.get(3) as Array<Map<number, unknown>>).find((entry) => entry.get(2) === "10000003");
  assert.ok(noRankCandidate);
  assert.equal(decodeArenaExtra(String(noRankCandidate.get(8))).qsl, 0);
  server.db.db.prepare("DELETE FROM global_players WHERE uid = 10000003").run();

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
  const rankPageResult = readThriftResponse(rankPageBody).get(0) as Map<number, unknown>;
  assert.equal((rankPageResult.get(3) as unknown[]).length, 2);

  const initialArenaPage = await rankApiRequest(
    10000001,
    rankRequest(10000001, "getRankingByPage", [
      thriftField(THRIFT.I32, 2, thriftI32(1093)),
      thriftField(THRIFT.I32, 3, thriftI32(100)),
      thriftField(THRIFT.I32, 4, thriftI32(95)),
    ])
  );
  const initialArenaResult = readThriftResponse(Buffer.from(await initialArenaPage.arrayBuffer())).get(0) as Map<number, unknown>;
  assert.equal((initialArenaResult.get(3) as unknown[]).length, 100);

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
    data: FIRST_SAVE_DATA,
    status: "0",
  });

  const persistedBeforeLegacyMirror = server.db.db
    .prepare("SELECT (SELECT COUNT(*) FROM global_players) players, (SELECT COUNT(*) FROM remote_save_slots) saves, (SELECT COUNT(*) FROM rank_entries) ranks")
    .get();
  const legacyMirrorResponse = await fetch(`${server.url}/ranging.php/?ac=get&uid=71922639&gameid=100025235&index=1`, {
    headers: { "x-flash-uid": "10000001" },
  });
  const legacyMirror = await legacyMirrorResponse.json() as { index: number; title: string; data: string; status: string };
  assert.equal(legacyMirror.index, 1);
  assert.match(legacyMirror.title, /训练镜像/);
  assert.match(legacyMirror.data, /<s type="Number" name="jxid">71922639<\/s>/);
  assert.match(legacyMirror.data, /<s type="Number" name="sidx">1<\/s>/);
  assert.equal(legacyMirror.status, "0");
  assert.deepEqual(
    server.db.db
      .prepare("SELECT (SELECT COUNT(*) FROM global_players) players, (SELECT COUNT(*) FROM remote_save_slots) saves, (SELECT COUNT(*) FROM rank_entries) ranks")
      .get(),
    persistedBeforeLegacyMirror
  );

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
    saveSlotCount: 2,
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
