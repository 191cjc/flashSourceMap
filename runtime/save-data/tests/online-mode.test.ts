import assert from "node:assert/strict";
import { mkdtempSync, rmSync } from "node:fs";
import { tmpdir } from "node:os";
import path from "node:path";
import { startGlobalDataServer } from "../../global-data/server/server.js";
import { LocalSaveDatabase } from "../persistence/db.js";
import { DEFAULT_ACCOUNT, SaveDataMockApi } from "../platform4399/mockApi.js";
import { readLocalSaveIdentity } from "../services/gameData.js";
import { OnlineModeService } from "../services/onlineMode.js";

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

const dir = mkdtempSync(path.join(tmpdir(), "flash-online-mode-"));
const globalServer = await startGlobalDataServer({ host: "127.0.0.1", port: 0, dbFile: path.join(dir, "global.db") });
const localDb = new LocalSaveDatabase(path.join(dir, "local.db"));
const api = new SaveDataMockApi(localDb, DEFAULT_ACCOUNT);
const onlineMode = new OnlineModeService(localDb, globalServer.url);

try {
  localDb.saveSlot({ uid: DEFAULT_ACCOUNT.uid, gameid: "100025235", index: 0, title: "本地角色", data: SAVE_DATA });
  const initialWallet = localDb.rechargeWallet({ uid: DEFAULT_ACCOUNT.uid, amount: 250 });

  const eligible = await onlineMode.status();
  assert.equal(eligible.mode, "eligible");

  const joined = await onlineMode.join();
  assert.equal(joined.mode, "online");
  assert.equal(api.account.uid, "10000001");
  assert.equal(api.account.username, "player_10000001");
  assert.deepEqual(localDb.getWallet("10000001"), {
    balance: initialWallet.balance,
    totalPaid: initialWallet.totalPaid,
    totalRecharged: initialWallet.totalRecharged,
  });

  const migratedSlot = localDb.getSlot("10000001", "100025235", 0);
  assert.equal(readLocalSaveIdentity(String(migratedSlot?.data)).uid, "10000001");
  assert.equal(readLocalSaveIdentity(String(migratedSlot?.data)).username, "player_10000001");
  assert.equal(localDb.countSnapshots("10000001", "100025235", 0), 1);

  const remoteSave = globalServer.db.getSave(10000001, "100025235", 0);
  assert.equal(remoteSave?.revision, 1);
  assert.equal(readLocalSaveIdentity(remoteSave?.data ?? "").uid, "10000001");

  const updatedData = String(migratedSlot?.data).replace(
    "</saveXml>",
    '<s type="Number" name="test">1</s></saveXml>'
  );
  localDb.saveSlot({ uid: "10000001", gameid: "100025235", index: 0, title: "更新角色", data: updatedData });
  const pending = await onlineMode.status(false);
  assert.equal(pending.mode, "sync_pending");
  const sync = await onlineMode.syncPending();
  assert.equal(sync.pending, 0);
  assert.equal(globalServer.db.getSave(10000001, "100025235", 0)?.revision, 2);

  await onlineMode.updateUsername("联机玩家_1");
  assert.equal(api.account.username, "联机玩家_1");
  assert.equal(readLocalSaveIdentity(String(localDb.getSlot("10000001", "100025235", 0)?.data)).username, "联机玩家_1");
  assert.equal(globalServer.db.getPlayerByUid(10000001)?.username, "联机玩家_1");
  assert.equal(globalServer.db.getSave(10000001, "100025235", 0)?.revision, 3);

  console.log("online mode flow ok");
} finally {
  localDb.close();
  await globalServer.close();
  rmSync(dir, { recursive: true, force: true });
}
