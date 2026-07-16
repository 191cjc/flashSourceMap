import assert from "node:assert/strict";
import { mkdtempSync, rmSync } from "node:fs";
import { tmpdir } from "node:os";
import path from "node:path";
import { startGlobalDataServer } from "../server/server.js";

const dir = mkdtempSync(path.join(tmpdir(), "flash-global-data-"));
const server = await startGlobalDataServer({ host: "127.0.0.1", port: 0, dbFile: path.join(dir, "global.db") });

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

  console.log("global data flow ok");
} finally {
  await server.close();
  rmSync(dir, { recursive: true, force: true });
}
