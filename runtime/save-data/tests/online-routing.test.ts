import assert from "node:assert/strict";
import { mkdtempSync, rmSync } from "node:fs";
import { tmpdir } from "node:os";
import path from "node:path";
import { startGlobalDataServer } from "../../global-data/server/server.js";
import { LocalSaveDatabase } from "../persistence/db.js";
import { startSaveDataServer } from "../server/server.js";

const THRIFT = { STOP: 0, I32: 8, STRING: 11, STRUCT: 12, LIST: 15 } as const;
const GAME_ID = "100025235";
process.env.SAVE_DATA_NO_LOGS = "1";
const SAVE_DATA = [
  '<saveXml type="Object" game4399="true">',
  '  <s type="Object" name="null">',
  '    <s type="Number" name="jxid">10001</s>',
  '    <s type="Number" name="sidx">0</s>',
  '    <s type="String" name="idn">local_user</s>',
  '    <s type="Number" name="idai">10001</s>',
  '  </s>',
  '</saveXml>',
].join("");

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

function thriftMessage(methodName: string, fields: Buffer[]): Buffer {
  const versionAndType = Buffer.alloc(4);
  versionAndType.writeUInt32BE(0x80010001);
  return Buffer.concat([versionAndType, thriftString(methodName), thriftI32(1), thriftStruct(fields)]);
}

function unionCreateRequest(title: string): Buffer {
  const header = thriftStruct([
    thriftField(THRIFT.STRING, 1, thriftString("routing-test")),
    thriftField(THRIFT.STRING, 2, thriftString(GAME_ID)),
    thriftField(THRIFT.I32, 3, thriftI32(0)),
  ]);
  return thriftMessage("unionCreate", [
    thriftField(THRIFT.STRUCT, 1, header),
    thriftField(THRIFT.STRING, 2, thriftString(title)),
    thriftField(THRIFT.STRING, 3, thriftString("HTTP转发测试*0")),
  ]);
}

function rankSubmitRequest(uid: number): Buffer {
  const header = thriftStruct([
    thriftField(THRIFT.STRING, 1, thriftString(String(uid))),
    thriftField(THRIFT.STRING, 2, thriftString(GAME_ID)),
  ]);
  const submission = thriftStruct([
    thriftField(THRIFT.I32, 1, thriftI32(1093)),
    thriftField(THRIFT.I32, 2, thriftI32(2468)),
    thriftField(THRIFT.STRING, 3, thriftString("routing-rank-extra")),
  ]);
  return thriftMessage("submit", [
    thriftField(THRIFT.STRUCT, 1, header),
    thriftField(THRIFT.I32, 2, thriftI32(0)),
    thriftField(THRIFT.LIST, 3, Buffer.concat([Buffer.from([THRIFT.STRUCT]), thriftI32(1), submission])),
  ]);
}

async function thriftRequest(baseUrl: string, pathname: string, body: Buffer): Promise<Response> {
  return fetch(`${baseUrl}${pathname}`, {
    method: "POST",
    headers: { "content-type": "application/x-thrift" },
    body: new Uint8Array(body),
  });
}

const dir = mkdtempSync(path.join(tmpdir(), "flash-online-routing-"));
const globalServer = await startGlobalDataServer({ host: "127.0.0.1", port: 0, dbFile: path.join(dir, "global.db") });
const localServer = await startSaveDataServer({
  host: "127.0.0.1",
  port: 0,
  dbFile: path.join(dir, "local.db"),
  globalDataUrl: globalServer.url,
});

try {
  const localDb = localServer.db as LocalSaveDatabase;
  localDb.saveSlot({ uid: "10001", gameid: GAME_ID, index: 0, title: "联调角色", data: SAVE_DATA });

  const unavailableBackup = await fetch(`${localServer.url}/api/saveData/backup-import/saves`);
  assert.equal(unavailableBackup.status, 409);
  assert.equal((await unavailableBackup.json() as { error: string }).error, "not_online");

  const joinResponse = await fetch(`${localServer.url}/api/saveData/online-mode/join`, {
    method: "POST",
    headers: { "content-type": "application/json" },
    body: "{}",
  });
  const joinBody = await joinResponse.text();
  assert.equal(joinResponse.status, 200, joinBody);
  const joined = JSON.parse(joinBody) as { account: { uid: string } };
  assert.equal(joined.account.uid, "10000001");

  const backupListResponse = await fetch(`${localServer.url}/api/saveData/backup-import/saves`);
  assert.equal(backupListResponse.status, 200);
  const backupList = await backupListResponse.json() as { uid: string; saves: Array<{ index: number; revision: number }> };
  assert.equal(backupList.uid, "10000001");
  assert.deepEqual(backupList.saves.map((save) => ({ index: save.index, revision: save.revision })), [{ index: 0, revision: 1 }]);

  const restoreResponse = await fetch(`${localServer.url}/api/saveData/backup-import/restore`, {
    method: "POST",
    headers: { "content-type": "application/json" },
    body: JSON.stringify({ slotIndex: 0 }),
  });
  assert.equal(restoreResponse.status, 200);
  const restore = await restoreResponse.json() as { ok: boolean; slot: { revision: number } };
  assert.equal(restore.ok, true);
  assert.equal(restore.slot.revision, 2);
  assert.equal(globalServer.db.getSave(10000001, GAME_ID, 0)?.revision, 2);

  const unionResponse = await thriftRequest(
    localServer.url,
    "/api/4399/union/FlashUnionApi",
    unionCreateRequest("Windows转发军团")
  );
  const unionBody = Buffer.from(await unionResponse.arrayBuffer());
  assert.equal(unionResponse.status, 200, unionBody.toString("utf8"));
  assert.ok(unionBody.byteLength > 0);
  const union = globalServer.db.db.prepare("SELECT title, owner_uid FROM union_mock").get() as { title: string; owner_uid: string };
  assert.deepEqual({ ...union }, { title: "Windows转发军团", owner_uid: "10000001" });

  const rankResponse = await thriftRequest(
    localServer.url,
    "/api/4399/rank/FlashScoreApi",
    rankSubmitRequest(10000001)
  );
  const rankBody = Buffer.from(await rankResponse.arrayBuffer());
  assert.equal(rankResponse.status, 200, rankBody.toString("utf8"));
  assert.ok(rankBody.byteLength > 0);
  const rank = globalServer.db.db
    .prepare("SELECT uid, slot_index, score, extra FROM rank_entries WHERE rank_list_id = 1093")
    .get() as { uid: number; slot_index: number; score: number; extra: string };
  assert.deepEqual({ ...rank }, { uid: 10000001, slot_index: 0, score: 2468, extra: "routing-rank-extra" });

  const opponentSave = await fetch(`${localServer.url}/ranging.php/?ac=get`, {
    method: "POST",
    headers: { "content-type": "application/x-www-form-urlencoded" },
    body: new URLSearchParams({ uid: "10000001", gameid: GAME_ID, index: "0" }),
  });
  assert.equal(opponentSave.status, 200);
  const opponentData = await opponentSave.json() as { index: number; title: string; data: string; status: string };
  assert.equal(opponentData.index, 0);
  assert.equal(opponentData.title, "联调角色");
  assert.match(opponentData.data, /10000001/);
  assert.equal(opponentData.status, "0");

  const syncStatusResponse = await fetch(`${localServer.url}/api/saveData/online-mode/sync-status`);
  assert.equal(syncStatusResponse.status, 200);
  const syncStatus = await syncStatusResponse.json() as { pendingCount: number };
  assert.equal(syncStatus.pendingCount, 0);

  console.log("online routing flow ok");
} finally {
  await localServer.close();
  await globalServer.close();
  rmSync(dir, { recursive: true, force: true });
}
