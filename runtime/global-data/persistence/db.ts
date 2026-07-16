import { mkdirSync, readFileSync } from "node:fs";
import path from "node:path";
import { DatabaseSync } from "node:sqlite";
import { fileURLToPath } from "node:url";
import type {
  GlobalPlayer,
  PutRemoteSaveRequest,
  RegisterGlobalPlayerRequest,
  RemoteSaveSlot,
} from "../types.js";

const moduleDir = path.dirname(fileURLToPath(import.meta.url));
const schemaFile = path.resolve(moduleDir, "../schema/global-data.sql");
const DEFAULT_SOURCE_UID = 10001;
const MIN_ALLOCATED_UID = 10000001;
const MAX_GLOBAL_UID = 199999999;
const USERNAME_RE = /^[\p{L}\p{N}_]{2,20}$/u;

type PlayerRow = {
  uid: number;
  instance_id: string;
  username: string;
  nickname: string;
  created_at: string;
  updated_at: string;
  last_seen_at: string;
};

type SaveRow = {
  uid: number;
  game_id: string;
  slot_index: number;
  title: string;
  raw_data: string;
  checksum: string;
  revision: number;
  updated_at: string;
};

export class GlobalDataError extends Error {
  constructor(readonly code: string, message: string, readonly status = 400) {
    super(message);
  }
}

function asPlayer(row: PlayerRow): GlobalPlayer {
  return {
    uid: row.uid,
    instanceId: row.instance_id,
    username: row.username,
    nickname: row.nickname,
    createdAt: row.created_at,
    updatedAt: row.updated_at,
    lastSeenAt: row.last_seen_at,
  };
}

function asSave(row: SaveRow): RemoteSaveSlot {
  return {
    uid: row.uid,
    gameId: row.game_id,
    slotIndex: row.slot_index,
    title: row.title,
    data: row.raw_data,
    checksum: row.checksum,
    revision: row.revision,
    updatedAt: row.updated_at,
  };
}

function normalizedInstanceId(value: string): string {
  const instanceId = value.trim();
  if (!instanceId || instanceId.length > 128) {
    throw new GlobalDataError("invalid_instance_id", "instanceId 必须是 1 至 128 个字符");
  }
  return instanceId;
}

function normalizedUid(value: string | number): number {
  const uid = Number(value);
  if (!Number.isSafeInteger(uid) || uid <= 0 || uid > MAX_GLOBAL_UID) {
    throw new GlobalDataError("invalid_uid", `UID 必须是 1 至 ${MAX_GLOBAL_UID} 的整数`);
  }
  return uid;
}

function normalizedUsername(value: string): string {
  const username = value.trim();
  if (!USERNAME_RE.test(username)) {
    throw new GlobalDataError("invalid_username", "用户名必须是 2 至 20 个中文、英文、数字或下划线字符");
  }
  return username;
}

function normalizedNickname(value: string): string {
  const nickname = value.trim();
  if (!nickname || nickname.length > 40) {
    throw new GlobalDataError("invalid_nickname", "昵称必须是 1 至 40 个字符");
  }
  return nickname;
}

export class GlobalDataDatabase {
  readonly db: DatabaseSync;

  constructor(readonly dbFile: string) {
    mkdirSync(path.dirname(dbFile), { recursive: true });
    this.db = new DatabaseSync(dbFile);
    this.db.exec(readFileSync(schemaFile, "utf8"));
  }

  close(): void {
    this.db.close();
  }

  health(): { sqliteVersion: string } {
    const row = this.db.prepare("SELECT sqlite_version() AS version").get() as { version: string };
    return { sqliteVersion: row.version };
  }

  getPlayerByUid(uid: number): GlobalPlayer | null {
    const row = this.db
      .prepare(
        "SELECT uid, instance_id, username, nickname, created_at, updated_at, last_seen_at FROM global_players WHERE uid = ?"
      )
      .get(uid) as PlayerRow | undefined;
    return row ? asPlayer(row) : null;
  }

  getPlayerByInstanceId(instanceId: string): GlobalPlayer | null {
    const row = this.db
      .prepare(
        "SELECT uid, instance_id, username, nickname, created_at, updated_at, last_seen_at FROM global_players WHERE instance_id = ?"
      )
      .get(instanceId) as PlayerRow | undefined;
    return row ? asPlayer(row) : null;
  }

  registerPlayer(request: RegisterGlobalPlayerRequest): { player: GlobalPlayer; newlyAllocated: boolean } {
    const instanceId = normalizedInstanceId(request.instanceId);
    const sourceUid = normalizedUid(request.sourceUid);
    const nickname = normalizedNickname(request.nickname || "本地玩家");
    const existing = this.getPlayerByInstanceId(instanceId);
    if (existing) {
      this.db.prepare("UPDATE global_players SET last_seen_at = datetime('now') WHERE uid = ?").run(existing.uid);
      return { player: this.getPlayerByUid(existing.uid)!, newlyAllocated: false };
    }

    this.db.exec("BEGIN IMMEDIATE");
    try {
      const uid = sourceUid === DEFAULT_SOURCE_UID ? this.allocateUid() : sourceUid;
      const uidOwner = this.getPlayerByUid(uid);
      if (uidOwner) {
        throw new GlobalDataError("uid_conflict", "该 UID 已绑定其他 Windows 实例", 409);
      }
      const requestedUsername = request.username.trim();
      const username =
        sourceUid === DEFAULT_SOURCE_UID && requestedUsername === "local_user"
          ? `player_${uid}`
          : this.availableUsername(requestedUsername, uid);
      this.db
        .prepare("INSERT INTO global_players (uid, instance_id, username, nickname) VALUES (?, ?, ?, ?)")
        .run(uid, instanceId, username, nickname);
      this.db.exec("COMMIT");
      return { player: this.getPlayerByUid(uid)!, newlyAllocated: sourceUid === DEFAULT_SOURCE_UID };
    } catch (error) {
      this.db.exec("ROLLBACK");
      throw error;
    }
  }

  updatePlayer(uid: number, username: string): GlobalPlayer {
    const player = this.getPlayerByUid(normalizedUid(uid));
    if (!player) {
      throw new GlobalDataError("player_not_found", "玩家不存在", 404);
    }
    const normalized = normalizedUsername(username);
    const owner = this.db
      .prepare("SELECT uid FROM global_players WHERE username = ? COLLATE NOCASE")
      .get(normalized) as { uid: number } | undefined;
    if (owner && owner.uid !== uid) {
      throw new GlobalDataError("username_taken", "用户名已被使用", 409);
    }
    this.db
      .prepare(
        "UPDATE global_players SET username = ?, updated_at = datetime('now'), last_seen_at = datetime('now') WHERE uid = ?"
      )
      .run(normalized, uid);
    return this.getPlayerByUid(uid)!;
  }

  putSave(uid: number, slotIndex: number, request: PutRemoteSaveRequest): {
    save: RemoteSaveSlot;
    ignored: boolean;
  } {
    const player = this.getPlayerByUid(normalizedUid(uid));
    if (!player) {
      throw new GlobalDataError("player_not_found", "玩家不存在", 404);
    }
    if (!Number.isInteger(slotIndex) || slotIndex < 0 || slotIndex > 7) {
      throw new GlobalDataError("invalid_slot", "存档槽位必须是 0 至 7");
    }
    if (!request.gameId.trim() || !request.checksum.trim() || !request.data) {
      throw new GlobalDataError("invalid_save", "gameId、checksum 和 data 不能为空");
    }
    if (!Number.isSafeInteger(request.revision) || request.revision < 0) {
      throw new GlobalDataError("invalid_revision", "revision 必须是非负整数");
    }

    const existing = this.getSave(uid, request.gameId, slotIndex);
    if (existing && existing.revision > request.revision) {
      return { save: existing, ignored: true };
    }
    if (existing && existing.revision === request.revision) {
      if (existing.checksum !== request.checksum) {
        throw new GlobalDataError("revision_conflict", "相同 revision 的 checksum 不一致", 409);
      }
      return { save: existing, ignored: true };
    }

    this.db
      .prepare(
        [
          "INSERT INTO remote_save_slots (uid, game_id, slot_index, title, raw_data, checksum, revision)",
          "VALUES (?, ?, ?, ?, ?, ?, ?)",
          "ON CONFLICT(uid, game_id, slot_index) DO UPDATE SET",
          "title = excluded.title, raw_data = excluded.raw_data, checksum = excluded.checksum,",
          "revision = excluded.revision, updated_at = datetime('now')",
        ].join(" ")
      )
      .run(uid, request.gameId.trim(), slotIndex, request.title, request.data, request.checksum, request.revision);
    return { save: this.getSave(uid, request.gameId, slotIndex)!, ignored: false };
  }

  getSave(uid: number, gameId: string, slotIndex: number): RemoteSaveSlot | null {
    const row = this.db
      .prepare(
        [
          "SELECT uid, game_id, slot_index, title, raw_data, checksum, revision, updated_at",
          "FROM remote_save_slots WHERE uid = ? AND game_id = ? AND slot_index = ?",
        ].join(" ")
      )
      .get(uid, gameId, slotIndex) as SaveRow | undefined;
    return row ? asSave(row) : null;
  }

  listSaves(uid: number, gameId: string): RemoteSaveSlot[] {
    return (
      this.db
        .prepare(
          [
            "SELECT uid, game_id, slot_index, title, raw_data, checksum, revision, updated_at",
            "FROM remote_save_slots WHERE uid = ? AND game_id = ? ORDER BY slot_index ASC",
          ].join(" ")
        )
        .all(uid, gameId) as SaveRow[]
    ).map(asSave);
  }

  private allocateUid(): number {
    const row = this.db.prepare("SELECT next_uid FROM global_uid_sequence WHERE id = 1").get() as { next_uid: number };
    if (row.next_uid < MIN_ALLOCATED_UID || row.next_uid > MAX_GLOBAL_UID) {
      throw new GlobalDataError("uid_exhausted", "可分配 UID 已耗尽", 503);
    }
    this.db.prepare("UPDATE global_uid_sequence SET next_uid = next_uid + 1 WHERE id = 1").run();
    return row.next_uid;
  }

  private availableUsername(requested: string, uid: number): string {
    const username = normalizedUsername(requested || `player_${uid}`);
    const existing = this.db
      .prepare("SELECT uid FROM global_players WHERE username = ? COLLATE NOCASE")
      .get(username) as { uid: number } | undefined;
    return existing ? `player_${uid}` : username;
  }
}
