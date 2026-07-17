import assert from "node:assert/strict";
import { mkdtempSync, rmSync } from "node:fs";
import { tmpdir } from "node:os";
import path from "node:path";
import { GlobalRankService } from "../../global-data/rank/service.js";
import { startGlobalDataServer } from "../../global-data/server/server.js";
import { LocalSaveDatabase } from "../persistence/db.js";
import { DEFAULT_ACCOUNT, SaveDataMockApi } from "../platform4399/mockApi.js";
import {
  canonicalizeLocalSaveIdentity,
  clearArenaOpponentCache,
  decodeAmf3StringBase64,
  decodeSaveXml,
  encodeAmf3StringBase64,
  readLocalSaveIdentity,
} from "../services/gameData.js";
import { OnlineModeError, OnlineModeService } from "../services/onlineMode.js";

const SAVE_DATA = [
  '<saveXml type="Object" game4399="true">',
  '  <s type="Object" name="null">',
  '    <s type="Number" name="jxid">10001</s>',
  '    <s type="Number" name="sidx">0</s>',
  '    <s type="String" name="idn">local_user</s>',
  `    <s type="String" name="newnn">${encodeAmf3StringBase64("本地玩家")}</s>`,
  '    <s type="String" name="jxname">本地玩家</s>',
  '    <s type="Number" name="idai">10001</s>',
  '    <s type="Number" name="oldpkb">251</s>',
  '    <s type="Number" name="oldawb">1</s>',
  '    <s type="Number" name="oldatb">5</s>',
  '    <s type="Number" name="sxb">1014</s>',
  '    <s type="Object" name="pkl">',
  '      <s type="Array" name="ea"><s type="Object" name="null"><s type="Number" name="id">10000002</s></s></s>',
  '      <s type="Array" name="wa"><s type="Number" name="null">0</s></s>',
  '      <s type="Array" name="gup"><s type="Number" name="null">20</s></s>',
  '    </s>',
  '  </s>',
  '</saveXml>',
].join("");

const CLEARED_ARENA_CACHE_DATA = clearArenaOpponentCache(SAVE_DATA);
assert.match(decodeSaveXml(CLEARED_ARENA_CACHE_DATA) ?? "", /<s type="Array" name="ea"\/>/);
assert.match(decodeSaveXml(CLEARED_ARENA_CACHE_DATA) ?? "", /<s type="Array" name="wa"\/>/);
assert.match(decodeSaveXml(CLEARED_ARENA_CACHE_DATA) ?? "", /<s type="Array" name="gup"\/>/);

function saveStringField(rawData: string, name: string): string | null {
  const xml = decodeSaveXml(rawData);
  return xml ? new RegExp(`<s type="String" name="${name}">([\\s\\S]*?)</s>`).exec(xml)?.[1] ?? null : null;
}

function saveDisplayName(rawData: string): string | null {
  const encoded = saveStringField(rawData, "newnn");
  return encoded ? decodeAmf3StringBase64(encoded) : null;
}

function saveNumberField(rawData: string, name: string): number | null {
  const xml = decodeSaveXml(rawData);
  const value = xml ? new RegExp(`<s type="Number" name="${name}">([^<]*)</s>`).exec(xml)?.[1] : null;
  return value == null ? null : Number(value);
}

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

  const secondSlotData = canonicalizeLocalSaveIdentity(SAVE_DATA, {
    uid: "10000001",
    username: "player_10000001",
    slotIndex: 1,
  });
  localDb.saveSlot({ uid: "10000001", gameid: "100025235", index: 1, title: "第二角色", data: secondSlotData });

  const otherAccount = localDb.getOrCreateAccount({ uid: "20000000", username: "other_user", nickname: "其他玩家" });
  const otherSlotData = canonicalizeLocalSaveIdentity(SAVE_DATA, {
    uid: otherAccount.uid,
    username: otherAccount.username,
    slotIndex: 0,
    displayName: otherAccount.nickname,
  });
  localDb.saveSlot({ uid: otherAccount.uid, gameid: "100025235", index: 0, title: "其他账号角色", data: otherSlotData });
  const otherSlotBeforeRename = String(localDb.getSlot(otherAccount.uid, "100025235", 0)?.data);

  globalServer.db.registerPlayer({
    instanceId: "occupied-username",
    sourceUid: 10000002,
    username: "已占用名称",
    nickname: "已占用名称",
  });
  const accountBeforeFailedRename = localDb.getCurrentAccount()!;
  const firstSlotBeforeFailedRename = String(localDb.getSlot("10000001", "100025235", 0)?.data);
  const firstSlotSnapshotsBeforeFailedRename = localDb.countSnapshots("10000001", "100025235", 0);
  await assert.rejects(
    onlineMode.updateUsername("已占用名称"),
    (error: unknown) => error instanceof OnlineModeError && error.code === "username_taken"
  );
  assert.deepEqual(localDb.getCurrentAccount(), accountBeforeFailedRename);
  assert.equal(String(localDb.getSlot("10000001", "100025235", 0)?.data), firstSlotBeforeFailedRename);
  assert.equal(localDb.countSnapshots("10000001", "100025235", 0), firstSlotSnapshotsBeforeFailedRename);

  const firstSlotSnapshotsBeforeRename = localDb.countSnapshots("10000001", "100025235", 0);
  const secondSlotSnapshotsBeforeRename = localDb.countSnapshots("10000001", "100025235", 1);

  const updatePlayer = globalServer.db.updatePlayer.bind(globalServer.db);
  globalServer.db.updatePlayer = (uid, username) => updatePlayer(uid, username);
  try {
    await onlineMode.updateUsername("联机玩家_1");
  } finally {
    globalServer.db.updatePlayer = updatePlayer;
  }
  assert.equal(api.account.username, "联机玩家_1");
  assert.equal(api.account.nickname, "联机玩家_1");
  for (const slotIndex of [0, 1]) {
    const localData = String(localDb.getSlot("10000001", "100025235", slotIndex)?.data);
    assert.equal(readLocalSaveIdentity(localData).username, "联机玩家_1");
    assert.equal(saveDisplayName(localData), "联机玩家_1");
    assert.equal(saveStringField(localData, "jxname"), "联机玩家_1");
  }
  assert.equal(localDb.countSnapshots("10000001", "100025235", 0), firstSlotSnapshotsBeforeRename + 1);
  assert.equal(localDb.countSnapshots("10000001", "100025235", 1), secondSlotSnapshotsBeforeRename + 1);
  assert.equal(localDb.getSlot("10000001", "100025235", 0)?.title, "更新角色");
  assert.equal(localDb.getSlot("10000001", "100025235", 1)?.title, "第二角色");
  assert.deepEqual(localDb.getAccountByUid(otherAccount.uid), otherAccount);
  assert.equal(String(localDb.getSlot(otherAccount.uid, "100025235", 0)?.data), otherSlotBeforeRename);
  assert.equal(globalServer.db.getPlayerByUid(10000001)?.username, "联机玩家_1");
  assert.equal(globalServer.db.getPlayerByUid(10000001)?.nickname, DEFAULT_ACCOUNT.nickname);
  assert.equal(globalServer.db.getSave(10000001, "100025235", 0)?.revision, 3);
  assert.equal(globalServer.db.getSave(10000001, "100025235", 1)?.revision, 2);
  assert.equal(saveDisplayName(globalServer.db.getSave(10000001, "100025235", 0)?.data ?? ""), "联机玩家_1");
  assert.equal(saveDisplayName(globalServer.db.getSave(10000001, "100025235", 1)?.data ?? ""), "联机玩家_1");

  const corruptedData = canonicalizeLocalSaveIdentity(
    String(localDb.getSlot("10000001", "100025235", 0)?.data),
    { uid: "99999999", username: "错误身份", slotIndex: 0 }
  );
  localDb.db.prepare("UPDATE save_slots SET raw_data = ? WHERE account_id = ? AND game_id = ? AND slot_index = ?").run(
    corruptedData,
    localDb.getCurrentAccount()!.id,
    "100025235",
    0
  );
  assert.equal((await onlineMode.status(false)).mode, "identity_conflict");

  const repaired = await onlineMode.repair();
  assert.equal(repaired.mode, "online");
  assert.deepEqual(readLocalSaveIdentity(String(localDb.getSlot("10000001", "100025235", 0)?.data)), {
    uid: "10000001",
    username: "联机玩家_1",
  });
  assert.equal(api.account.nickname, "联机玩家_1");
  assert.equal(saveDisplayName(String(localDb.getSlot("10000001", "100025235", 0)?.data)), "联机玩家_1");
  assert.equal(globalServer.db.getSave(10000001, "100025235", 0)?.revision, 4);

  const backups = await onlineMode.listRemoteBackups() as {
    uid: string;
    saves: Array<{ index: number; title: string; datetime: string; revision: number; hasData: boolean }>;
  };
  assert.equal(backups.uid, "10000001");
  assert.deepEqual(
    backups.saves.map(({ index, title, revision, hasData }) => ({ index, title, revision, hasData })),
    [
      { index: 0, title: "更新角色", revision: 4, hasData: true },
      { index: 1, title: "第二角色", revision: 3, hasData: true },
    ]
  );

  const backupData = String(localDb.getSlot("10000001", "100025235", 0)?.data);
  const divergentData = backupData.replace("</saveXml>", '<s type="Number" name="localOnly">999</s></saveXml>');
  localDb.saveSlot({ uid: "10000001", gameid: "100025235", index: 0, title: "本地错误版本", data: divergentData });
  assert.match(String(localDb.getSlot("10000001", "100025235", 0)?.data), /localOnly/);

  const restored = await onlineMode.restoreRemoteBackup(0) as {
    ok: boolean;
    slot: { index: number; title: string; revision: number };
    sync: { pending: number };
  };
  assert.equal(restored.ok, true);
  assert.deepEqual(restored.slot, { index: 0, title: "更新角色", revision: 6 });
  assert.equal(restored.sync.pending, 0);
  assert.equal(String(localDb.getSlot("10000001", "100025235", 0)?.data).includes("localOnly"), false);
  assert.equal(globalServer.db.getSave(10000001, "100025235", 0)?.revision, 6);

  const syncStatus = onlineMode.syncStatus() as {
    pendingCount: number;
    slots: Array<{
      gameId: string;
      slotIndex: number;
      localRevision: number;
      uploadedRevision: number;
      pending: boolean;
      retryCount: number;
      lastError: string;
    }>;
  };
  assert.equal(syncStatus.pendingCount, 0);
  assert.equal(syncStatus.slots.length, 2);
  assert.deepEqual(
    {
      gameId: syncStatus.slots[0].gameId,
      slotIndex: syncStatus.slots[0].slotIndex,
      localRevision: syncStatus.slots[0].localRevision,
      uploadedRevision: syncStatus.slots[0].uploadedRevision,
      pending: syncStatus.slots[0].pending,
      retryCount: syncStatus.slots[0].retryCount,
      lastError: syncStatus.slots[0].lastError,
    },
    {
      gameId: "100025235",
      slotIndex: 0,
      localRevision: 6,
      uploadedRevision: 6,
      pending: false,
      retryCount: 0,
      lastError: "",
    }
  );
  assert.deepEqual(
    {
      gameId: syncStatus.slots[1].gameId,
      slotIndex: syncStatus.slots[1].slotIndex,
      localRevision: syncStatus.slots[1].localRevision,
      uploadedRevision: syncStatus.slots[1].uploadedRevision,
      pending: syncStatus.slots[1].pending,
    },
    { gameId: "100025235", slotIndex: 1, localRevision: 3, uploadedRevision: 3, pending: false }
  );

  new GlobalRankService(globalServer.db).submit(10000001, 0, [
    { rankListId: 1093, score: 1014, extra: "legacy-arena-extra" },
  ]);
  const settlement = new GlobalRankService(globalServer.db).settleArenaSeason(1);
  assert.equal(settlement.lastSettledSeason, 1);
  const snapshotsBeforeSeasonReset = localDb.countSnapshots("10000001", "100025235", 0);
  const seasonSync = await onlineMode.syncPending();
  assert.equal(seasonSync.pending, 0);
  const seasonResetData = String(localDb.getSlot("10000001", "100025235", 0)?.data);
  assert.equal(saveNumberField(seasonResetData, "oldpkb"), -1);
  assert.equal(saveNumberField(seasonResetData, "oldawb"), 0);
  assert.equal(saveNumberField(seasonResetData, "oldatb"), 5);
  assert.equal(saveNumberField(seasonResetData, "sxb"), 1);
  assert.equal(localDb.countSnapshots("10000001", "100025235", 0), snapshotsBeforeSeasonReset + 1);
  assert.equal(saveNumberField(globalServer.db.getSave(10000001, "100025235", 0)?.data ?? "", "oldpkb"), -1);
  const seasonStatus = await onlineMode.status(false) as { online: { arenaSettledSeason: number } };
  assert.equal(seasonStatus.online.arenaSettledSeason, 1);

  const snapshotsBeforeArenaRefresh = localDb.countSnapshots("10000001", "100025235", 0);
  const arenaRefresh = await onlineMode.refreshArenaCache();
  assert.equal(arenaRefresh.ok, true);
  assert.equal(arenaRefresh.cleared, 2);
  assert.equal(arenaRefresh.sync.pending, 0);
  const refreshedArenaData = String(localDb.getSlot("10000001", "100025235", 0)?.data);
  assert.match(decodeSaveXml(refreshedArenaData) ?? "", /<s type="Array" name="ea"\/>/);
  assert.equal(localDb.countSnapshots("10000001", "100025235", 0), snapshotsBeforeArenaRefresh + 1);
  assert.match(
    decodeSaveXml(globalServer.db.getSave(10000001, "100025235", 0)?.data ?? "") ?? "",
    /<s type="Array" name="ea"\/>/
  );

  console.log("online mode flow ok");
} finally {
  localDb.close();
  await globalServer.close();
  rmSync(dir, { recursive: true, force: true });
}
