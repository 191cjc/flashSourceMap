import { createHash, randomUUID } from "node:crypto";
import type { Account } from "../types.js";
import { LocalSaveDatabase } from "../persistence/db.js";
import type { SaveDataStore } from "../persistence/store.js";
import { canonicalizeLocalSaveIdentity, clearArenaOpponentCache, readLocalSaveIdentity, resetArenaSeasonSaveData } from "./gameData.js";

const DEFAULT_UID = "10001";
const DEFAULT_GAME_ID = "100025235";

type OnlineStateRow = {
  instance_id: string;
  enabled: number;
  server_url: string;
  assigned_uid: string;
  username: string;
  migration_state: string;
  registered_at: string;
  last_health_at: string;
  last_sync_at: string;
  arena_settled_season: number;
  last_error: string;
};

type SyncRow = {
  account_id: number;
  game_id: string;
  slot_index: number;
  local_revision: number;
  uploaded_revision: number;
  local_checksum: string;
  uploaded_checksum: string;
  pending: number;
  retry_count: number;
  last_attempt_at: string;
  last_success_at: string;
  last_error: string;
  title: string;
  raw_data: string;
};

type RegistrationResponse = {
  ok: boolean;
  uid: number;
  username: string;
  player: { nickname: string };
};

type RemoteBackupSave = {
  uid: number;
  gameId: string;
  slotIndex: number;
  title: string;
  data: string;
  checksum: string;
  revision: number;
  updatedAt: string;
};

export class OnlineModeError extends Error {
  constructor(readonly code: string, message: string, readonly status = 400) {
    super(message);
  }
}

function sha256(value: string): string {
  return createHash("sha256").update(value).digest("hex");
}

function normalizedServerUrl(value: string): string {
  const url = new URL(value);
  return url.toString().replace(/\/$/, "");
}

function normalizedUsername(value: string): string {
  const username = value.trim();
  if (!/^[\p{L}\p{N}_]{2,20}$/u.test(username)) {
    throw new OnlineModeError("invalid_username", "用户名必须是 2 至 20 个中文、英文、数字或下划线字符");
  }
  return username;
}

export class OnlineModeService {
  private readonly sqlite: LocalSaveDatabase | null;
  readonly serverUrl: string;

  constructor(readonly store: SaveDataStore, serverUrl: string) {
    this.sqlite = store instanceof LocalSaveDatabase ? store : null;
    this.serverUrl = normalizedServerUrl(serverUrl);
  }

  async status(checkHealth = true): Promise<Record<string, unknown>> {
    if (!this.sqlite) {
      return { ok: false, mode: "unsupported", error: "legacy_store_not_supported" };
    }
    const state = this.ensureState();
    const account = this.store.getCurrentAccount();
    const slots = account ? this.slotIdentities(account) : [];
    const populatedUids = slots.map((slot) => slot.uid).filter((uid): uid is string => uid != null);
    const uniqueUids = [...new Set(populatedUids)];
    const identityConflict = uniqueUids.length > 1 || (uniqueUids.length === 1 && account != null && uniqueUids[0] !== account.uid);
    const pendingCount = this.pendingCount();
    const server = checkHealth ? await this.health() : { reachable: false, healthy: false, skipped: true };
    let mode = "eligible";
    if (identityConflict) {
      mode = "identity_conflict";
    } else if (state.migration_state === "failed") {
      mode = "migration_failed";
    } else if (account?.uid !== DEFAULT_UID || state.enabled === 1) {
      mode = pendingCount > 0 ? "sync_pending" : "online";
    } else if (!server.healthy) {
      mode = "server_offline";
    }
    return {
      ok: true,
      mode,
      server,
      account,
      slots,
      online: {
        enabled: state.enabled === 1,
        instanceId: state.instance_id,
        assignedUid: state.assigned_uid,
        username: state.username,
        migrationState: state.migration_state,
        registeredAt: state.registered_at,
        lastSyncAt: state.last_sync_at,
        arenaSettledSeason: state.arena_settled_season,
        lastError: state.last_error,
      },
      sync: { pendingCount },
    };
  }

  async join(): Promise<Record<string, unknown>> {
    const sqlite = this.requireSqlite();
    const state = this.ensureState();
    const account = this.store.getCurrentAccount();
    if (!account) {
      throw new OnlineModeError("account_not_found", "本地账号不存在", 404);
    }
    const slots = this.slotIdentities(account);
    const inconsistent = slots.some((slot) => slot.uid != null && slot.uid !== account.uid);
    if (inconsistent) {
      throw new OnlineModeError("identity_conflict", "本地账号 UID 与存档 UID 不一致", 409);
    }

    sqlite.db.prepare("UPDATE online_mode_state SET migration_state = 'joining', last_error = '' WHERE id = 1").run();
    try {
      await this.ensureServerAvailable();
      const registration = await this.register(state, account);
      const nextUid = String(registration.uid);
      if (account.uid !== nextUid || account.username !== registration.username || state.enabled !== 1) {
        this.migrateIdentity(account, nextUid, registration.username, registration.player.nickname);
      }
      await this.syncPending();
      return this.status(false);
    } catch (error) {
      this.markMigrationFailed(error);
      throw error;
    }
  }

  async repair(): Promise<Record<string, unknown>> {
    const sqlite = this.requireSqlite();
    const state = this.ensureState();
    const account = this.store.getCurrentAccount();
    if (!account) {
      throw new OnlineModeError("account_not_found", "本地账号不存在", 404);
    }
    sqlite.db.prepare("UPDATE online_mode_state SET migration_state = 'repairing', last_error = '' WHERE id = 1").run();
    try {
      await this.ensureServerAvailable();
      const registration = await this.register(state, account);
      this.migrateIdentity(account, String(registration.uid), registration.username, registration.username);
      await this.syncPending();
      return this.status(false);
    } catch (error) {
      this.markMigrationFailed(error);
      throw error;
    }
  }

  async updateUsername(username: string): Promise<Record<string, unknown>> {
    const sqlite = this.requireSqlite();
    const state = this.ensureState();
    const account = this.store.getCurrentAccount();
    if (!account || account.uid === DEFAULT_UID || state.enabled !== 1) {
      throw new OnlineModeError("not_online", "尚未接入联机模式", 409);
    }
    const normalized = normalizedUsername(username);
    const profile = await this.requestJson<{ ok: boolean; player: { username: string; nickname: string } }>(
      `/api/global/players/${account.uid}`,
      {
        method: "PATCH",
        body: JSON.stringify({ username: normalized, nickname: normalized }),
      }
    );
    if (profile.player.username !== normalized) {
      throw new OnlineModeError("remote_profile_mismatch", "Linux 服务未确认新的联机用户名", 502);
    }

    sqlite.db.exec("BEGIN IMMEDIATE");
    try {
      sqlite.db
        .prepare("UPDATE accounts SET username = ?, nickname = ?, updated_at = datetime('now') WHERE id = ?")
        .run(normalized, normalized, account.id);
      const rows = sqlite.db
        .prepare("SELECT id, game_id, slot_index, title, raw_data, checksum FROM save_slots WHERE account_id = ?")
        .all(account.id) as Array<{
        id: number;
        game_id: string;
        slot_index: number;
        title: string;
        raw_data: string;
        checksum: string;
      }>;
      for (const row of rows) {
        sqlite.db
          .prepare("INSERT INTO save_snapshots (save_slot_id, title, raw_data, checksum) VALUES (?, ?, ?, ?)")
          .run(row.id, row.title, row.raw_data, row.checksum);
        const data = canonicalizeLocalSaveIdentity(row.raw_data, {
          uid: account.uid,
          username: normalized,
          slotIndex: row.slot_index,
          displayName: normalized,
        });
        const checksum = sha256(data);
        sqlite.db
          .prepare("UPDATE save_slots SET raw_data = ?, checksum = ?, updated_at = datetime('now') WHERE id = ?")
          .run(data, checksum, row.id);
        this.upsertSync(sqlite, account.id, row.game_id, row.slot_index, checksum);
      }
      sqlite.db
        .prepare("UPDATE online_mode_state SET username = ?, last_error = '' WHERE id = 1")
        .run(normalized);
      sqlite.db.exec("COMMIT");
    } catch (error) {
      sqlite.db.exec("ROLLBACK");
      throw error;
    }
    await this.syncPending();
    return this.status(false);
  }

  async syncPending(): Promise<{ ok: boolean; synced: number; pending: number; errors: string[] }> {
    const sqlite = this.requireSqlite();
    const state = this.ensureState();
    if (state.enabled !== 1) {
      return { ok: true, synced: 0, pending: 0, errors: [] };
    }
    const account = this.store.getCurrentAccount();
    if (!account) {
      throw new OnlineModeError("account_not_found", "本地账号不存在", 404);
    }
    await this.reconcileArenaSeason(account, state);
    const rows = sqlite.db
      .prepare(
        [
          "SELECT sync.account_id, sync.game_id, sync.slot_index, sync.local_revision, sync.uploaded_revision,",
          "sync.local_checksum, sync.uploaded_checksum, sync.pending, sync.retry_count, sync.last_attempt_at,",
          "sync.last_success_at, sync.last_error, slot.title, slot.raw_data",
          "FROM remote_save_sync sync",
          "JOIN save_slots slot ON slot.account_id = sync.account_id AND slot.game_id = sync.game_id AND slot.slot_index = sync.slot_index",
          "WHERE sync.account_id = ? AND sync.pending = 1 ORDER BY sync.slot_index ASC",
        ].join(" ")
      )
      .all(account.id) as SyncRow[];
    let synced = 0;
    const errors: string[] = [];
    for (const row of rows) {
      sqlite.db
        .prepare(
          "UPDATE remote_save_sync SET last_attempt_at = datetime('now'), retry_count = retry_count + 1 WHERE account_id = ? AND game_id = ? AND slot_index = ?"
        )
        .run(row.account_id, row.game_id, row.slot_index);
      try {
        await this.requestJson(`/api/global/saves/${account.uid}/${row.slot_index}`, {
          method: "PUT",
          body: JSON.stringify({
            gameId: row.game_id,
            title: row.title,
            data: row.raw_data,
            checksum: row.local_checksum,
            revision: row.local_revision,
          }),
        });
        sqlite.db
          .prepare(
            [
              "UPDATE remote_save_sync SET uploaded_revision = local_revision, uploaded_checksum = local_checksum,",
              "pending = 0, retry_count = 0, last_success_at = datetime('now'), last_error = ''",
              "WHERE account_id = ? AND game_id = ? AND slot_index = ? AND local_revision = ?",
            ].join(" ")
          )
          .run(row.account_id, row.game_id, row.slot_index, row.local_revision);
        synced += 1;
      } catch (error) {
        const message = error instanceof Error ? error.message : String(error);
        errors.push(message);
        sqlite.db
          .prepare(
            "UPDATE remote_save_sync SET last_error = ? WHERE account_id = ? AND game_id = ? AND slot_index = ?"
          )
          .run(message, row.account_id, row.game_id, row.slot_index);
      }
    }
    const pending = this.pendingCount();
    sqlite.db
      .prepare(
        "UPDATE online_mode_state SET last_sync_at = CASE WHEN ? = 0 THEN datetime('now') ELSE last_sync_at END, last_error = ? WHERE id = 1"
      )
      .run(pending, errors[0] ?? "");
    return { ok: errors.length === 0, synced, pending, errors };
  }

  async refreshArenaCache(): Promise<{
    ok: boolean;
    cleared: number;
    sync: { ok: boolean; synced: number; pending: number; errors: string[] };
  }> {
    const account = this.requireOnlineAccount();
    const sqlite = this.requireSqlite();
    const rows = sqlite.db
      .prepare("SELECT id, game_id, slot_index, title, raw_data, checksum FROM save_slots WHERE account_id = ?")
      .all(account.id) as Array<{
      id: number;
      game_id: string;
      slot_index: number;
      title: string;
      raw_data: string;
      checksum: string;
    }>;
    let cleared = 0;
    sqlite.db.exec("BEGIN IMMEDIATE");
    try {
      for (const row of rows) {
        const data = clearArenaOpponentCache(row.raw_data);
        if (data === row.raw_data) continue;
        sqlite.db
          .prepare("INSERT INTO save_snapshots (save_slot_id, title, raw_data, checksum) VALUES (?, ?, ?, ?)")
          .run(row.id, `竞技场缓存刷新前备份 - ${row.title}`, row.raw_data, row.checksum);
        const checksum = sha256(data);
        sqlite.db
          .prepare("UPDATE save_slots SET raw_data = ?, checksum = ?, updated_at = datetime('now') WHERE id = ?")
          .run(data, checksum, row.id);
        this.upsertSync(sqlite, account.id, row.game_id, row.slot_index, checksum);
        cleared += 1;
      }
      sqlite.db.exec("COMMIT");
    } catch (error) {
      sqlite.db.exec("ROLLBACK");
      throw error;
    }
    return { ok: true, cleared, sync: await this.syncPending() };
  }

  syncStatus(): Record<string, unknown> {
    const sqlite = this.requireSqlite();
    const account = this.store.getCurrentAccount();
    if (!account) {
      return { ok: true, account: null, pendingCount: 0, slots: [] };
    }
    const rows = sqlite.db
      .prepare(
        [
          "SELECT game_id, slot_index, local_revision, uploaded_revision, pending, retry_count,",
          "last_attempt_at, last_success_at, last_error",
          "FROM remote_save_sync WHERE account_id = ? ORDER BY game_id, slot_index",
        ].join(" ")
      )
      .all(account.id) as Array<{
      game_id: string;
      slot_index: number;
      local_revision: number;
      uploaded_revision: number;
      pending: number;
      retry_count: number;
      last_attempt_at: string;
      last_success_at: string;
      last_error: string;
    }>;
    return {
      ok: true,
      account: { uid: account.uid, username: account.username },
      pendingCount: rows.filter((row) => row.pending === 1).length,
      slots: rows.map((row) => ({
        gameId: row.game_id,
        slotIndex: row.slot_index,
        localRevision: row.local_revision,
        uploadedRevision: row.uploaded_revision,
        pending: row.pending === 1,
        retryCount: row.retry_count,
        lastAttemptAt: row.last_attempt_at,
        lastSuccessAt: row.last_success_at,
        lastError: row.last_error,
      })),
    };
  }

  async listRemoteBackups(gameId = DEFAULT_GAME_ID): Promise<Record<string, unknown>> {
    const account = this.requireOnlineAccount();
    const response = await this.requestJson<{ ok: boolean; saves: RemoteBackupSave[] }>(
      `/api/global/saves/${account.uid}?gameId=${encodeURIComponent(gameId)}`,
      { method: "GET" }
    );
    return {
      ok: true,
      uid: account.uid,
      username: account.username,
      saves: response.saves.map((save) => ({
        index: save.slotIndex,
        title: save.title,
        datetime: save.updatedAt,
        revision: save.revision,
        hasData: Boolean(save.data),
      })),
    };
  }

  async restoreRemoteBackup(slotIndex: number, gameId = DEFAULT_GAME_ID): Promise<Record<string, unknown>> {
    const sqlite = this.requireSqlite();
    const account = this.requireOnlineAccount();
    if (!Number.isInteger(slotIndex) || slotIndex < 0 || slotIndex > 7) {
      throw new OnlineModeError("invalid_slot", "存档槽位必须是 0 至 7", 400);
    }
    const response = await this.requestJson<{ ok: boolean; save: RemoteBackupSave }>(
      `/api/global/saves/${account.uid}/${slotIndex}?gameId=${encodeURIComponent(gameId)}`,
      { method: "GET" }
    );
    const save = response.save;
    const data = canonicalizeLocalSaveIdentity(save.data, {
      uid: account.uid,
      username: account.username,
      slotIndex,
    });
    const checksum = sha256(data);
    this.store.saveSlot({ uid: account.uid, gameid: gameId, index: slotIndex, title: save.title, data });
    const syncRow = sqlite.db
      .prepare(
        "SELECT local_revision FROM remote_save_sync WHERE account_id = ? AND game_id = ? AND slot_index = ?"
      )
      .get(account.id, gameId, slotIndex) as { local_revision: number } | undefined;
    const nextRevision = Math.max(syncRow?.local_revision ?? 0, save.revision + 1);
    sqlite.db
      .prepare(
        [
          "INSERT INTO remote_save_sync",
          "(account_id, game_id, slot_index, local_revision, uploaded_revision, local_checksum, uploaded_checksum, pending)",
          "VALUES (?, ?, ?, ?, ?, ?, ?, 1)",
          "ON CONFLICT(account_id, game_id, slot_index) DO UPDATE SET",
          "local_revision = excluded.local_revision, uploaded_revision = excluded.uploaded_revision,",
          "local_checksum = excluded.local_checksum, uploaded_checksum = excluded.uploaded_checksum,",
          "pending = 1, retry_count = 0, last_error = ''",
        ].join(" ")
      )
      .run(account.id, gameId, slotIndex, nextRevision, save.revision, checksum, save.checksum);
    const sync = await this.syncPending();
    return {
      ok: true,
      uid: account.uid,
      slot: { index: slotIndex, title: save.title, revision: nextRevision },
      sync,
    };
  }

  private ensureState(): OnlineStateRow {
    const sqlite = this.requireSqlite();
    const existing = sqlite.db.prepare("SELECT * FROM online_mode_state WHERE id = 1").get() as OnlineStateRow | undefined;
    if (existing) {
      if (existing.server_url !== this.serverUrl) {
        sqlite.db.prepare("UPDATE online_mode_state SET server_url = ? WHERE id = 1").run(this.serverUrl);
        return { ...existing, server_url: this.serverUrl };
      }
      return existing;
    }
    const account = this.store.getCurrentAccount();
    sqlite.db
      .prepare(
        [
          "INSERT INTO online_mode_state",
          "(id, instance_id, enabled, server_url, assigned_uid, username)",
          "VALUES (1, ?, 0, ?, ?, ?)",
        ].join(" ")
      )
      .run(randomUUID(), this.serverUrl, account?.uid ?? DEFAULT_UID, account?.username ?? "local_user");
    return sqlite.db.prepare("SELECT * FROM online_mode_state WHERE id = 1").get() as OnlineStateRow;
  }

  private slotIdentities(account: Account): Array<{ index: number; uid: string | null; username: string | null }> {
    return this.store.listSlotsWithData(account.uid, DEFAULT_GAME_ID).map((slot) => ({
      index: slot.index,
      ...readLocalSaveIdentity(typeof slot.data === "string" ? slot.data : ""),
    }));
  }

  private migrateIdentity(account: Account, uid: string, username: string, nickname: string): void {
    const sqlite = this.requireSqlite();
    const conflict = sqlite.getAccountByUid(uid);
    if (conflict && conflict.id !== account.id) {
      throw new OnlineModeError("uid_conflict", "Linux 分配的 UID 已被另一本地账号使用", 409);
    }
    sqlite.db.exec("BEGIN IMMEDIATE");
    try {
      const rows = sqlite.db
        .prepare("SELECT id, game_id, slot_index, title, raw_data, checksum FROM save_slots WHERE account_id = ?")
        .all(account.id) as Array<{
        id: number;
        game_id: string;
        slot_index: number;
        title: string;
        raw_data: string;
        checksum: string;
      }>;
      sqlite.db
        .prepare("UPDATE accounts SET uid = ?, username = ?, nickname = ?, updated_at = datetime('now') WHERE id = ?")
        .run(uid, username, nickname, account.id);
      for (const row of rows) {
        sqlite.db
          .prepare("INSERT INTO save_snapshots (save_slot_id, title, raw_data, checksum) VALUES (?, ?, ?, ?)")
          .run(row.id, `UID迁移前备份 - ${row.title}`, row.raw_data, row.checksum);
        const data = canonicalizeLocalSaveIdentity(row.raw_data, {
          uid,
          username,
          slotIndex: row.slot_index,
          displayName: nickname,
        });
        const checksum = sha256(data);
        sqlite.db
          .prepare("UPDATE save_slots SET raw_data = ?, checksum = ?, updated_at = datetime('now') WHERE id = ?")
          .run(data, checksum, row.id);
        this.upsertSync(sqlite, account.id, row.game_id, row.slot_index, checksum);
      }
      sqlite.db
        .prepare(
          [
            "UPDATE online_mode_state SET enabled = 1, assigned_uid = ?, username = ?,",
            "migration_state = 'migrated', registered_at = datetime('now'), last_error = '' WHERE id = 1",
          ].join(" ")
        )
        .run(uid, username);
      sqlite.db.exec("COMMIT");
    } catch (error) {
      sqlite.db.exec("ROLLBACK");
      throw error;
    }
  }

  private upsertSync(sqlite: LocalSaveDatabase, accountId: number, gameId: string, slotIndex: number, checksum: string): void {
    sqlite.db
      .prepare(
        [
          "INSERT INTO remote_save_sync",
          "(account_id, game_id, slot_index, local_revision, local_checksum, pending)",
          "VALUES (?, ?, ?, 1, ?, 1)",
          "ON CONFLICT(account_id, game_id, slot_index) DO UPDATE SET",
          "local_revision = remote_save_sync.local_revision + 1,",
          "local_checksum = excluded.local_checksum, pending = 1, last_error = ''",
        ].join(" ")
      )
      .run(accountId, gameId, slotIndex, checksum);
  }

  private async reconcileArenaSeason(account: Account, state: OnlineStateRow): Promise<void> {
    const season = await this.requestJson<{
      ok: boolean;
      currentSeason: number;
      lastSettledSeason: number;
      lastSettledAt: string;
    }>("/api/global/arena/season", { method: "GET" });
    if (season.lastSettledSeason <= state.arena_settled_season) {
      return;
    }

    const sqlite = this.requireSqlite();
    const rows = sqlite.db
      .prepare("SELECT id, game_id, slot_index, title, raw_data, checksum FROM save_slots WHERE account_id = ?")
      .all(account.id) as Array<{
      id: number;
      game_id: string;
      slot_index: number;
      title: string;
      raw_data: string;
      checksum: string;
    }>;
    sqlite.db.exec("BEGIN IMMEDIATE");
    try {
      for (const row of rows) {
        const data = resetArenaSeasonSaveData(row.raw_data);
        if (data === row.raw_data) continue;
        sqlite.db
          .prepare("INSERT INTO save_snapshots (save_slot_id, title, raw_data, checksum) VALUES (?, ?, ?, ?)")
          .run(row.id, `竞技场第 ${season.lastSettledSeason} 赛季结算前备份 - ${row.title}`, row.raw_data, row.checksum);
        const checksum = sha256(data);
        sqlite.db
          .prepare("UPDATE save_slots SET raw_data = ?, checksum = ?, updated_at = datetime('now') WHERE id = ?")
          .run(data, checksum, row.id);
        this.upsertSync(sqlite, account.id, row.game_id, row.slot_index, checksum);
      }
      sqlite.db
        .prepare("UPDATE online_mode_state SET arena_settled_season = ?, last_error = '' WHERE id = 1")
        .run(season.lastSettledSeason);
      sqlite.db.exec("COMMIT");
    } catch (error) {
      sqlite.db.exec("ROLLBACK");
      throw error;
    }
  }

  private pendingCount(): number {
    const sqlite = this.requireSqlite();
    const account = this.store.getCurrentAccount();
    if (!account) {
      return 0;
    }
    const row = sqlite.db
      .prepare("SELECT COUNT(*) AS count FROM remote_save_sync WHERE account_id = ? AND pending = 1")
      .get(account.id) as { count: number };
    return row.count;
  }

  private async health(): Promise<Record<string, any>> {
    const startedAt = Date.now();
    try {
      const response = await fetch(`${this.serverUrl}/health`, { signal: AbortSignal.timeout(3000) });
      const body = (await response.json()) as Record<string, unknown>;
      const healthy = response.ok && body.ok === true;
      const sqlite = this.requireSqlite();
      sqlite.db
        .prepare("UPDATE online_mode_state SET last_health_at = datetime('now'), last_error = ? WHERE id = 1")
        .run(healthy ? "" : String(body.error ?? `HTTP ${response.status}`));
      return { reachable: true, healthy, status: response.status, latencyMs: Date.now() - startedAt, ...body };
    } catch (error) {
      const message = error instanceof Error ? error.message : String(error);
      this.requireSqlite().db.prepare("UPDATE online_mode_state SET last_error = ? WHERE id = 1").run(message);
      return { reachable: false, healthy: false, latencyMs: Date.now() - startedAt, error: message };
    }
  }

  private async ensureServerAvailable(): Promise<void> {
    const health = await this.health();
    if (!health.healthy) {
      throw new OnlineModeError("server_offline", "Linux 联机服务器不可用", 503);
    }
  }

  private requireOnlineAccount(): Account {
    const state = this.ensureState();
    const account = this.store.getCurrentAccount();
    if (!account || account.uid === DEFAULT_UID || state.enabled !== 1) {
      throw new OnlineModeError("not_online", "必须先接入联机模式才能恢复服务器备份", 409);
    }
    return account;
  }

  private register(state: OnlineStateRow, account: Account): Promise<RegistrationResponse> {
    return this.requestJson<RegistrationResponse>("/api/global/register", {
      method: "POST",
      body: JSON.stringify({
        instanceId: state.instance_id,
        sourceUid: account.uid,
        username: account.username,
        nickname: account.nickname,
      }),
    });
  }

  private markMigrationFailed(error: unknown): void {
    const message = error instanceof Error ? error.message : String(error);
    this.requireSqlite().db
      .prepare("UPDATE online_mode_state SET migration_state = 'failed', last_error = ? WHERE id = 1")
      .run(message);
  }

  private async requestJson<T = Record<string, unknown>>(pathname: string, init: RequestInit): Promise<T> {
    const response = await fetch(`${this.serverUrl}${pathname}`, {
      ...init,
      headers: { "content-type": "application/json", ...(init.headers ?? {}) },
      signal: AbortSignal.timeout(10000),
    });
    const body = (await response.json()) as T & { error?: string; message?: string };
    if (!response.ok) {
      throw new OnlineModeError(body.error ?? "remote_error", body.message ?? `Linux 服务返回 ${response.status}`, response.status);
    }
    return body;
  }

  private requireSqlite(): LocalSaveDatabase {
    if (!this.sqlite) {
      throw new OnlineModeError("legacy_store_not_supported", "联机模式只支持 SQLite 本地数据库", 409);
    }
    return this.sqlite;
  }
}
