import type { AccountSeed } from "../types.js";
import type { SaveDataStore } from "../persistence/store.js";

export type UnionInfo = {
  id: number;
  gameId: number;
  uId: string;
  userName: string;
  index: string;
  nickName: string;
  title: string;
  level: number;
  experience: number;
  contribution: number;
  extra: string;
  extra2: string;
  dissolveDate: string;
  count: string;
  transfer: string;
};

export type UnionListItem = {
  unionId: number;
  title: string;
  username: string;
  level: number;
  count: string;
  extra: string;
  experience: number;
};

export type UnionMember = {
  gameId: number;
  unionId: number;
  uId: string;
  userName: string;
  index: string;
  nickName: string;
  contribution: number;
  extra: string;
  extra2: string;
  active_time: string;
  roleId: string;
  roleName: string;
};

export type UnionApply = {
  gameId: number;
  unionId: number;
  uId: string;
  userName: string;
  index: string;
  nickName: string;
  extra: string;
};

export type UnionVariable = {
  id: string;
  value: string;
};

export type UnionTask = {
  taskName: string;
  value: string;
};

export type UnionRole = {
  id: number;
  name: string;
  privilegeList: string;
  create_time: number;
  memo: string;
};

export type UnionOfMe = {
  unionInfo: UnionInfo | null;
  member: UnionMember | null;
};

export type UnionListView = {
  unionList: UnionListItem[];
  count: string;
};

export type UnionApplyListView = {
  applyList: UnionApply[];
  count: string;
};

export type UnionTaskValueView = {
  value: UnionTask[];
  exchange: string;
  total: string;
};

type SqliteDatabase = {
  prepare(sql: string): {
    get(...params: unknown[]): unknown;
    all(...params: unknown[]): unknown[];
    run(...params: unknown[]): { lastInsertRowid: bigint | number };
  };
};

type UnionRow = {
  id: number;
  game_id: string;
  owner_uid: string;
  owner_username: string;
  owner_nickname: string;
  title: string;
  level: number;
  experience: number;
  contribution: number;
  extra: string;
  extra2: string;
  dissolve_date: string;
  transfer: string;
};

type UnionMemberRow = {
  union_id: number;
  game_id: string;
  uid: string;
  username: string;
  nickname: string;
  slot_index: number;
  contribution: number;
  extra: string;
  extra2: string;
  active_time: string;
  role_id: string;
  role_name: string;
};

type UnionApplyRow = {
  union_id: number;
  game_id: string;
  uid: string;
  username: string;
  nickname: string;
  slot_index: number;
  extra: string;
};

type MemoryState = {
  nextUnionId: number;
  unions: UnionRow[];
  members: UnionMemberRow[];
  applies: UnionApplyRow[];
  variables: Array<{ union_id: number; variable_id: number; value: number }>;
  tasks: Array<{ union_id: number; uid: string; slot_index: number; task_id: string; value: number }>;
  logs: Array<{ union_id: number; message: string; created_at: string }>;
};

const DEFAULT_GAME_ID = "100025235";
const DEFAULT_MEMBER_EXTRA = "1*0*本地机甲*0";
const DEFAULT_UNION_EXTRA = "欢迎加入军团，大家可以加入QQ群:XX!*0";
const LEVEL_EXP_STEP = 1000;

function nowMs(): string {
  return String(Date.now());
}

function nowText(): string {
  const now = new Date();
  const pad = (value: number) => String(value).padStart(2, "0");
  return [
    `${now.getFullYear()}-${pad(now.getMonth() + 1)}-${pad(now.getDate())}`,
    `${pad(now.getHours())}:${pad(now.getMinutes())}:${pad(now.getSeconds())}`,
  ].join(" ");
}

function asInteger(value: unknown, fallback = 0): number {
  const numberValue = typeof value === "number" ? value : Number(value);
  return Number.isSafeInteger(numberValue) ? numberValue : fallback;
}

function clampPositiveInteger(value: unknown, fallback = 1): number {
  const integer = Math.floor(Number(value));
  return Number.isSafeInteger(integer) && integer > 0 ? integer : fallback;
}

function normalizeGameId(value?: string | number | null): string {
  const gameId = String(value ?? DEFAULT_GAME_ID).trim();
  return gameId || DEFAULT_GAME_ID;
}

function normalizeIndex(value?: string | number | null): number {
  const index = Math.floor(Number(value ?? 0));
  return Number.isSafeInteger(index) && index >= 0 ? index : 0;
}

function normalizeExtra(value: string | undefined, fallback: string): string {
  const trimmed = String(value ?? "").trim();
  return trimmed || fallback;
}

function levelFromExperience(experience: number): number {
  return Math.max(1, Math.floor(Math.max(0, experience) / LEVEL_EXP_STEP) + 1);
}

function toUnionInfo(row: UnionRow, memberCount: number): UnionInfo {
  return {
    id: row.id,
    gameId: Number(row.game_id),
    uId: row.owner_uid,
    userName: row.owner_username,
    index: "0",
    nickName: row.owner_nickname,
    title: row.title,
    level: row.level,
    experience: row.experience,
    contribution: row.contribution,
    extra: row.extra,
    extra2: row.extra2,
    dissolveDate: row.dissolve_date,
    count: String(memberCount),
    transfer: row.transfer,
  };
}

function toUnionListItem(row: UnionRow, memberCount: number): UnionListItem {
  return {
    unionId: row.id,
    title: row.title,
    username: row.owner_username,
    level: row.level,
    count: String(memberCount),
    extra: row.extra,
    experience: row.experience,
  };
}

function toMember(row: UnionMemberRow): UnionMember {
  return {
    gameId: Number(row.game_id),
    unionId: row.union_id,
    uId: row.uid,
    userName: row.username,
    index: String(row.slot_index),
    nickName: row.nickname,
    contribution: row.contribution,
    extra: row.extra,
    extra2: row.extra2,
    active_time: row.active_time,
    roleId: row.role_id,
    roleName: row.role_name,
  };
}

function toApply(row: UnionApplyRow): UnionApply {
  return {
    gameId: Number(row.game_id),
    unionId: row.union_id,
    uId: row.uid,
    userName: row.username,
    index: String(row.slot_index),
    nickName: row.nickname,
    extra: row.extra,
  };
}

function paginate<T>(items: T[], pageId: number, pageShow: number): T[] {
  const page = clampPositiveInteger(pageId, 1);
  const size = clampPositiveInteger(pageShow, 10);
  return items.slice((page - 1) * size, page * size);
}

function sqliteFromStore(store: SaveDataStore): SqliteDatabase | null {
  const maybe = store as SaveDataStore & { db?: SqliteDatabase };
  return maybe.db && typeof maybe.db.prepare === "function" ? maybe.db : null;
}

export class LocalUnionMockService {
  private readonly sqlite: SqliteDatabase | null;
  private readonly memory: MemoryState = {
    nextUnionId: 1,
    unions: [],
    members: [],
    applies: [],
    variables: [],
    tasks: [],
    logs: [],
  };

  constructor(readonly store: SaveDataStore, readonly account: AccountSeed) {
    this.sqlite = sqliteFromStore(store);
  }

  createUnion(request: { gameId?: string; index?: number; title: string; extra?: string }): boolean {
    const gameId = normalizeGameId(request.gameId);
    const index = normalizeIndex(request.index);
    if (this.getOwnMember(gameId, index)) {
      return false;
    }
    const title = request.title.trim();
    if (!title) {
      return false;
    }
    const extra = normalizeExtra(request.extra, DEFAULT_UNION_EXTRA);
    const union = this.insertUnion({
      game_id: gameId,
      owner_uid: this.account.uid,
      owner_username: this.account.username,
      owner_nickname: this.account.nickname,
      title,
      level: 1,
      experience: 0,
      contribution: 0,
      extra,
      extra2: "",
      dissolve_date: "",
      transfer: "",
    });
    this.insertMember({
      union_id: union.id,
      game_id: gameId,
      uid: this.account.uid,
      username: this.account.username,
      nickname: this.account.nickname,
      slot_index: index,
      contribution: 0,
      extra: DEFAULT_MEMBER_EXTRA,
      extra2: "",
      active_time: nowMs(),
      role_id: "1",
      role_name: "团长",
    });
    this.ensureVariables(union.id, defaultVariableIds());
    this.addLog(union.id, `${this.account.nickname} 创建了军团`);
    return true;
  }

  listUnions(request: { gameId?: string; pageId?: number; pageShow?: number }): UnionListView {
    const gameId = normalizeGameId(request.gameId);
    const unions = this.listUnionRows(gameId)
      .sort((left, right) => right.level - left.level || right.experience - left.experience || left.id - right.id)
      .map((union) => toUnionListItem(union, this.countMembers(union.id)));
    return {
      unionList: paginate(unions, request.pageId ?? 1, request.pageShow ?? 10),
      count: String(unions.length),
    };
  }

  applyUnion(request: { gameId?: string; index?: number; unionId: number; extra?: string }): boolean {
    const gameId = normalizeGameId(request.gameId);
    const index = normalizeIndex(request.index);
    const union = this.getUnionById(request.unionId);
    if (!union || union.game_id !== gameId || this.getOwnMember(gameId, index)) {
      return false;
    }
    this.upsertApply({
      union_id: union.id,
      game_id: gameId,
      uid: this.account.uid,
      username: this.account.username,
      nickname: this.account.nickname,
      slot_index: index,
      extra: normalizeExtra(request.extra, DEFAULT_MEMBER_EXTRA),
    });
    this.addLog(union.id, `${this.account.nickname} 申请加入军团`);
    return true;
  }

  unionOfMe(request: { gameId?: string; index?: number }): UnionOfMe {
    const gameId = normalizeGameId(request.gameId);
    const index = normalizeIndex(request.index);
    const member = this.getOwnMember(gameId, index);
    if (!member) {
      return { unionInfo: null, member: null };
    }
    const union = this.getUnionById(member.union_id);
    if (!union) {
      return { unionInfo: null, member: null };
    }
    return {
      unionInfo: toUnionInfo(union, this.countMembers(union.id)),
      member: toMember(member),
    };
  }

  unionInfo(unionId: number): UnionInfo | null {
    const union = this.getUnionById(unionId);
    return union ? toUnionInfo(union, this.countMembers(union.id)) : null;
  }

  unionMembers(unionId: number): UnionMember[] {
    return this.listMemberRows(unionId)
      .sort((left, right) => Number(right.role_id) - Number(left.role_id) || right.contribution - left.contribution)
      .map(toMember);
  }

  setMemberExtra(request: { unionId: number; uId?: number; index?: number; extra: string }): boolean {
    const member = this.findMember(request.unionId, String(request.uId ?? this.account.uid), normalizeIndex(request.index));
    if (!member) {
      return false;
    }
    this.updateMemberExtra(member.union_id, member.uid, member.slot_index, normalizeExtra(request.extra, DEFAULT_MEMBER_EXTRA));
    this.addLog(member.union_id, `${member.nickname} 更新了成员信息`);
    return true;
  }

  setUnionExtra(request: { unionId: number; extra: string }): boolean {
    const union = this.getUnionById(request.unionId);
    if (!union) {
      return false;
    }
    this.updateUnionExtra(union.id, normalizeExtra(request.extra, DEFAULT_UNION_EXTRA));
    this.addLog(union.id, "军团公告已更新");
    return true;
  }

  unionLog(request: { gameId?: string; index?: number; unionId?: number; pageId?: number; pageShow?: number }): { logList: string[]; count: string } {
    const unionId =
      request.unionId ?? this.getOwnMember(normalizeGameId(request.gameId), normalizeIndex(request.index))?.union_id ?? 0;
    const logs = this.listLogs(unionId).map((row) =>
      JSON.stringify({ time: row.created_at, msg: row.message, userName: this.account.username })
    );
    return {
      logList: paginate(logs, request.pageId ?? 1, request.pageShow ?? 10),
      count: String(logs.length),
    };
  }

  unionQuit(request: { gameId?: string; index?: number }): boolean {
    const gameId = normalizeGameId(request.gameId);
    const index = normalizeIndex(request.index);
    const member = this.getOwnMember(gameId, index);
    if (!member || member.uid === this.getUnionById(member.union_id)?.owner_uid) {
      return false;
    }
    this.deleteMember(member.union_id, member.uid, member.slot_index);
    this.addLog(member.union_id, `${member.nickname} 退出了军团`);
    return true;
  }

  doTask(request: { gameId?: string; index?: number; taskId: string }): boolean {
    const member = this.getOwnMember(normalizeGameId(request.gameId), normalizeIndex(request.index));
    if (!member) {
      return false;
    }
    const value = taskContribution(request.taskId);
    this.addMemberContribution(member.union_id, member.uid, member.slot_index, value);
    this.addUnionExperience(member.union_id, value);
    this.upsertTask(member.union_id, member.uid, member.slot_index, request.taskId, value);
    this.addLog(member.union_id, `${member.nickname} 完成军团任务 ${request.taskId}`);
    return true;
  }

  exchange(request: { gameId?: string; index?: number; money: number }): boolean {
    const member = this.getOwnMember(normalizeGameId(request.gameId), normalizeIndex(request.index));
    if (!member) {
      return false;
    }
    const value = Math.max(1000, clampPositiveInteger(request.money, 1));
    this.addMemberContribution(member.union_id, member.uid, member.slot_index, value);
    this.addUnionExperience(member.union_id, value);
    this.addLog(member.union_id, `${member.nickname} 兑换了 ${value} 贡献`);
    return true;
  }

  getTaskValue(request: { gameId?: string; index?: number }): UnionTaskValueView {
    const member = this.getOwnMember(normalizeGameId(request.gameId), normalizeIndex(request.index));
    if (!member) {
      return { value: [], exchange: "0", total: "0" };
    }
    const tasks = this.listTasks(member.union_id, member.uid, member.slot_index).map((task) => ({
      taskName: task.task_id,
      value: String(task.value),
    }));
    const total = tasks.reduce((sum, task) => sum + asInteger(task.value, 0), 0);
    return { value: tasks, exchange: "0", total: String(total) };
  }

  applyList(request: { gameId?: string; index?: number; pageId?: number; pageShow?: number }): UnionApplyListView {
    const member = this.getOwnMember(normalizeGameId(request.gameId), normalizeIndex(request.index));
    const applies = member ? this.listApplyRows(member.union_id).map(toApply) : [];
    return {
      applyList: paginate(applies, request.pageId ?? 1, request.pageShow ?? 6),
      count: String(applies.length),
    };
  }

  applyAudit(request: { gameId?: string; index?: number; uId: number; targetIndex: number; auditResult: number }): boolean {
    const owner = this.getOwnMember(normalizeGameId(request.gameId), normalizeIndex(request.index));
    if (!owner || !this.isOwner(owner)) {
      return false;
    }
    const apply = this.findApply(owner.union_id, String(request.uId), normalizeIndex(request.targetIndex));
    if (!apply) {
      return false;
    }
    if (request.auditResult === 1) {
      this.insertOrReplaceMember({
        union_id: owner.union_id,
        game_id: apply.game_id,
        uid: apply.uid,
        username: apply.username,
        nickname: apply.nickname,
        slot_index: apply.slot_index,
        contribution: 0,
        extra: normalizeExtra(apply.extra, DEFAULT_MEMBER_EXTRA),
        extra2: "",
        active_time: nowMs(),
        role_id: "0",
        role_name: "成员",
      });
      this.addLog(owner.union_id, `${apply.nickname} 加入了军团`);
    }
    this.deleteApply(owner.union_id, apply.uid, apply.slot_index);
    return true;
  }

  memberRemove(request: { gameId?: string; index?: number; uId: number; targetIndex: number }): boolean {
    const owner = this.getOwnMember(normalizeGameId(request.gameId), normalizeIndex(request.index));
    if (!owner || !this.isOwner(owner) || String(request.uId) === owner.uid) {
      return false;
    }
    const target = this.findMember(owner.union_id, String(request.uId), normalizeIndex(request.targetIndex));
    if (!target) {
      return false;
    }
    this.deleteMember(owner.union_id, target.uid, target.slot_index);
    this.addLog(owner.union_id, `${target.nickname} 被移出军团`);
    return true;
  }

  dissolve(request: { gameId?: string; index?: number; actionType: number }): string {
    const owner = this.getOwnMember(normalizeGameId(request.gameId), normalizeIndex(request.index));
    if (!owner || !this.isOwner(owner)) {
      return "";
    }
    const dissolveDate = request.actionType === 1 ? futureDateText(3) : "";
    this.updateDissolveDate(owner.union_id, dissolveDate);
    this.addLog(owner.union_id, request.actionType === 1 ? "军团进入解散倒计时" : "军团取消了解散");
    return request.actionType === 1 ? dissolveDate : "0";
  }

  deleteContributionPersonal(request: { gameId?: string; index?: number; contribution: number }): number {
    const member = this.getOwnMember(normalizeGameId(request.gameId), normalizeIndex(request.index));
    if (!member) {
      return 0;
    }
    const spent = Math.min(member.contribution, clampPositiveInteger(request.contribution, 1));
    this.addMemberContribution(member.union_id, member.uid, member.slot_index, -spent);
    return spent;
  }

  deleteContributionUnion(request: { gameId?: string; index?: number; contribution: number }): number {
    const owner = this.getOwnMember(normalizeGameId(request.gameId), normalizeIndex(request.index));
    if (!owner || !this.isOwner(owner)) {
      return 0;
    }
    const union = this.getUnionById(owner.union_id);
    const spent = Math.min(union?.contribution ?? 0, clampPositiveInteger(request.contribution, 1));
    this.addUnionContribution(owner.union_id, -spent);
    return spent;
  }

  getVariables(request: { gameId?: string; index?: number; ids: number[] }): UnionVariable[] {
    const member = this.getOwnMember(normalizeGameId(request.gameId), normalizeIndex(request.index));
    const unionId = member?.union_id ?? 0;
    if (unionId > 0) {
      this.ensureVariables(unionId, request.ids);
    }
    return request.ids.map((id) => ({ id: String(id), value: String(unionId > 0 ? this.getVariable(unionId, id) : 0) }));
  }

  doVariable(request: { gameId?: string; index?: number; id: number }): boolean {
    const member = this.getOwnMember(normalizeGameId(request.gameId), normalizeIndex(request.index));
    if (!member || request.id <= 0) {
      return false;
    }
    this.ensureVariables(member.union_id, [request.id]);
    this.setVariable(member.union_id, request.id, this.getVariable(member.union_id, request.id) + 1);
    this.addLog(member.union_id, `${member.nickname} 更新了军团变量 ${request.id}`);
    return true;
  }

  getRoleList(): { roleList: UnionRole[]; count: string } {
    const roleList = [
      { id: 1, name: "团长", privilegeList: "*", create_time: 0, memo: "local master" },
      { id: 0, name: "成员", privilegeList: "", create_time: 0, memo: "local member" },
    ];
    return { roleList, count: String(roleList.length) };
  }

  setRole(request: { gameId?: string; index?: number; uId: number; targetIndex: number; roleId: number }): boolean {
    const owner = this.getOwnMember(normalizeGameId(request.gameId), normalizeIndex(request.index));
    if (!owner || !this.isOwner(owner)) {
      return false;
    }
    const target = this.findMember(owner.union_id, String(request.uId), normalizeIndex(request.targetIndex));
    if (!target) {
      return false;
    }
    this.updateMemberRole(owner.union_id, target.uid, target.slot_index, String(request.roleId), request.roleId === 1 ? "团长" : "成员");
    return true;
  }

  transfer(request: { gameId?: string; index?: number; uId: number; targetIndex: number; transferResult: number }): boolean {
    const owner = this.getOwnMember(normalizeGameId(request.gameId), normalizeIndex(request.index));
    if (!owner || !this.isOwner(owner) || request.transferResult !== 1) {
      return false;
    }
    const target = this.findMember(owner.union_id, String(request.uId), normalizeIndex(request.targetIndex));
    if (!target || target.uid === owner.uid) {
      return false;
    }
    this.updateUnionOwner(owner.union_id, target.uid, target.username, target.nickname);
    this.updateMemberRole(owner.union_id, owner.uid, owner.slot_index, "0", "成员");
    this.updateMemberRole(owner.union_id, target.uid, target.slot_index, "1", "团长");
    this.addLog(owner.union_id, `${owner.nickname} 将团长转让给 ${target.nickname}`);
    return true;
  }

  private insertUnion(row: Omit<UnionRow, "id">): UnionRow {
    if (this.sqlite) {
      const result = this.sqlite
        .prepare(
          [
            "INSERT INTO union_mock",
            "(game_id, owner_uid, owner_username, owner_nickname, title, level, experience, contribution, extra, extra2, dissolve_date, transfer)",
            "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
          ].join(" ")
        )
        .run(
          row.game_id,
          row.owner_uid,
          row.owner_username,
          row.owner_nickname,
          row.title,
          row.level,
          row.experience,
          row.contribution,
          row.extra,
          row.extra2,
          row.dissolve_date,
          row.transfer
        );
      return { id: Number(result.lastInsertRowid), ...row };
    }

    const union = { id: this.memory.nextUnionId++, ...row };
    this.memory.unions.push(union);
    return union;
  }

  private listUnionRows(gameId: string): UnionRow[] {
    if (this.sqlite) {
      return this.sqlite
        .prepare("SELECT * FROM union_mock WHERE game_id = ? ORDER BY id ASC")
        .all(gameId) as UnionRow[];
    }
    return this.memory.unions.filter((union) => union.game_id === gameId);
  }

  private getUnionById(unionId: number): UnionRow | null {
    if (this.sqlite) {
      return (this.sqlite.prepare("SELECT * FROM union_mock WHERE id = ?").get(unionId) as UnionRow | undefined) ?? null;
    }
    return this.memory.unions.find((union) => union.id === unionId) ?? null;
  }

  private updateUnionExtra(unionId: number, extra: string): void {
    if (this.sqlite) {
      this.sqlite.prepare("UPDATE union_mock SET extra = ?, updated_at = datetime('now') WHERE id = ?").run(extra, unionId);
      return;
    }
    const union = this.getUnionById(unionId);
    if (union) {
      union.extra = extra;
    }
  }

  private updateUnionOwner(unionId: number, uid: string, username: string, nickname: string): void {
    if (this.sqlite) {
      this.sqlite
        .prepare(
          "UPDATE union_mock SET owner_uid = ?, owner_username = ?, owner_nickname = ?, updated_at = datetime('now') WHERE id = ?"
        )
        .run(uid, username, nickname, unionId);
      return;
    }
    const union = this.getUnionById(unionId);
    if (union) {
      union.owner_uid = uid;
      union.owner_username = username;
      union.owner_nickname = nickname;
    }
  }

  private updateDissolveDate(unionId: number, dissolveDate: string): void {
    if (this.sqlite) {
      this.sqlite.prepare("UPDATE union_mock SET dissolve_date = ?, updated_at = datetime('now') WHERE id = ?").run(dissolveDate, unionId);
      return;
    }
    const union = this.getUnionById(unionId);
    if (union) {
      union.dissolve_date = dissolveDate;
    }
  }

  private insertMember(row: UnionMemberRow): void {
    if (this.sqlite) {
      this.sqlite
        .prepare(
          [
            "INSERT INTO union_member_mock",
            "(union_id, game_id, uid, username, nickname, slot_index, contribution, extra, extra2, active_time, role_id, role_name)",
            "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
          ].join(" ")
        )
        .run(
          row.union_id,
          row.game_id,
          row.uid,
          row.username,
          row.nickname,
          row.slot_index,
          row.contribution,
          row.extra,
          row.extra2,
          row.active_time,
          row.role_id,
          row.role_name
        );
      return;
    }
    this.memory.members.push(row);
  }

  private insertOrReplaceMember(row: UnionMemberRow): void {
    if (this.sqlite) {
      this.sqlite
        .prepare(
          [
            "INSERT INTO union_member_mock",
            "(union_id, game_id, uid, username, nickname, slot_index, contribution, extra, extra2, active_time, role_id, role_name)",
            "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
            "ON CONFLICT(union_id, uid, slot_index) DO UPDATE SET",
            "username = excluded.username, nickname = excluded.nickname, extra = excluded.extra, updated_at = datetime('now')",
          ].join(" ")
        )
        .run(
          row.union_id,
          row.game_id,
          row.uid,
          row.username,
          row.nickname,
          row.slot_index,
          row.contribution,
          row.extra,
          row.extra2,
          row.active_time,
          row.role_id,
          row.role_name
        );
      return;
    }
    this.deleteMember(row.union_id, row.uid, row.slot_index);
    this.memory.members.push(row);
  }

  private getOwnMember(gameId: string, index: number): UnionMemberRow | null {
    if (this.sqlite) {
      return (
        (this.sqlite
          .prepare("SELECT * FROM union_member_mock WHERE game_id = ? AND uid = ? AND slot_index = ? ORDER BY union_id DESC LIMIT 1")
          .get(gameId, this.account.uid, index) as UnionMemberRow | undefined) ?? null
      );
    }
    return (
      this.memory.members.find(
        (member) => member.game_id === gameId && member.uid === this.account.uid && member.slot_index === index
      ) ?? null
    );
  }

  private findMember(unionId: number, uid: string, index: number): UnionMemberRow | null {
    if (this.sqlite) {
      return (
        (this.sqlite
          .prepare("SELECT * FROM union_member_mock WHERE union_id = ? AND uid = ? AND slot_index = ?")
          .get(unionId, uid, index) as UnionMemberRow | undefined) ?? null
      );
    }
    return this.memory.members.find((member) => member.union_id === unionId && member.uid === uid && member.slot_index === index) ?? null;
  }

  private listMemberRows(unionId: number): UnionMemberRow[] {
    if (this.sqlite) {
      return this.sqlite.prepare("SELECT * FROM union_member_mock WHERE union_id = ?").all(unionId) as UnionMemberRow[];
    }
    return this.memory.members.filter((member) => member.union_id === unionId);
  }

  private countMembers(unionId: number): number {
    if (this.sqlite) {
      const row = this.sqlite.prepare("SELECT COUNT(*) AS count FROM union_member_mock WHERE union_id = ?").get(unionId) as
        | { count: number }
        | undefined;
      return row?.count ?? 0;
    }
    return this.memory.members.filter((member) => member.union_id === unionId).length;
  }

  private updateMemberExtra(unionId: number, uid: string, index: number, extra: string): void {
    if (this.sqlite) {
      this.sqlite
        .prepare("UPDATE union_member_mock SET extra = ?, updated_at = datetime('now') WHERE union_id = ? AND uid = ? AND slot_index = ?")
        .run(extra, unionId, uid, index);
      return;
    }
    const member = this.findMember(unionId, uid, index);
    if (member) {
      member.extra = extra;
    }
  }

  private updateMemberRole(unionId: number, uid: string, index: number, roleId: string, roleName: string): void {
    if (this.sqlite) {
      this.sqlite
        .prepare(
          "UPDATE union_member_mock SET role_id = ?, role_name = ?, updated_at = datetime('now') WHERE union_id = ? AND uid = ? AND slot_index = ?"
        )
        .run(roleId, roleName, unionId, uid, index);
      return;
    }
    const member = this.findMember(unionId, uid, index);
    if (member) {
      member.role_id = roleId;
      member.role_name = roleName;
    }
  }

  private addMemberContribution(unionId: number, uid: string, index: number, contribution: number): void {
    if (this.sqlite) {
      this.sqlite
        .prepare(
          [
            "UPDATE union_member_mock",
            "SET contribution = MAX(0, contribution + ?), active_time = ?, updated_at = datetime('now')",
            "WHERE union_id = ? AND uid = ? AND slot_index = ?",
          ].join(" ")
        )
        .run(contribution, nowMs(), unionId, uid, index);
      return;
    }
    const member = this.findMember(unionId, uid, index);
    if (member) {
      member.contribution = Math.max(0, member.contribution + contribution);
      member.active_time = nowMs();
    }
  }

  private addUnionExperience(unionId: number, value: number): void {
    const union = this.getUnionById(unionId);
    if (!union) {
      return;
    }
    const nextExperience = Math.max(0, union.experience + value);
    const nextLevel = levelFromExperience(nextExperience);
    if (this.sqlite) {
      this.sqlite
        .prepare(
          "UPDATE union_mock SET experience = ?, level = ?, contribution = contribution + ?, updated_at = datetime('now') WHERE id = ?"
        )
        .run(nextExperience, nextLevel, Math.max(0, value), unionId);
      return;
    }
    union.experience = nextExperience;
    union.level = nextLevel;
    union.contribution += Math.max(0, value);
  }

  private addUnionContribution(unionId: number, value: number): void {
    if (this.sqlite) {
      this.sqlite.prepare("UPDATE union_mock SET contribution = MAX(0, contribution + ?), updated_at = datetime('now') WHERE id = ?").run(value, unionId);
      return;
    }
    const union = this.getUnionById(unionId);
    if (union) {
      union.contribution = Math.max(0, union.contribution + value);
    }
  }

  private deleteMember(unionId: number, uid: string, index: number): void {
    if (this.sqlite) {
      this.sqlite.prepare("DELETE FROM union_member_mock WHERE union_id = ? AND uid = ? AND slot_index = ?").run(unionId, uid, index);
      return;
    }
    this.memory.members = this.memory.members.filter(
      (member) => !(member.union_id === unionId && member.uid === uid && member.slot_index === index)
    );
  }

  private upsertApply(row: UnionApplyRow): void {
    if (this.sqlite) {
      this.sqlite
        .prepare(
          [
            "INSERT INTO union_apply_mock",
            "(union_id, game_id, uid, username, nickname, slot_index, extra)",
            "VALUES (?, ?, ?, ?, ?, ?, ?)",
            "ON CONFLICT(union_id, uid, slot_index) DO UPDATE SET",
            "extra = excluded.extra, updated_at = datetime('now')",
          ].join(" ")
        )
        .run(row.union_id, row.game_id, row.uid, row.username, row.nickname, row.slot_index, row.extra);
      return;
    }
    this.deleteApply(row.union_id, row.uid, row.slot_index);
    this.memory.applies.push(row);
  }

  private findApply(unionId: number, uid: string, index: number): UnionApplyRow | null {
    if (this.sqlite) {
      return (
        (this.sqlite
          .prepare("SELECT * FROM union_apply_mock WHERE union_id = ? AND uid = ? AND slot_index = ?")
          .get(unionId, uid, index) as UnionApplyRow | undefined) ?? null
      );
    }
    return this.memory.applies.find((apply) => apply.union_id === unionId && apply.uid === uid && apply.slot_index === index) ?? null;
  }

  private listApplyRows(unionId: number): UnionApplyRow[] {
    if (this.sqlite) {
      return this.sqlite.prepare("SELECT * FROM union_apply_mock WHERE union_id = ? ORDER BY updated_at ASC").all(unionId) as UnionApplyRow[];
    }
    return this.memory.applies.filter((apply) => apply.union_id === unionId);
  }

  private deleteApply(unionId: number, uid: string, index: number): void {
    if (this.sqlite) {
      this.sqlite.prepare("DELETE FROM union_apply_mock WHERE union_id = ? AND uid = ? AND slot_index = ?").run(unionId, uid, index);
      return;
    }
    this.memory.applies = this.memory.applies.filter(
      (apply) => !(apply.union_id === unionId && apply.uid === uid && apply.slot_index === index)
    );
  }

  private ensureVariables(unionId: number, ids: number[]): void {
    for (const id of ids) {
      if (!Number.isSafeInteger(id) || id <= 0) {
        continue;
      }
      if (this.sqlite) {
        this.sqlite
          .prepare("INSERT OR IGNORE INTO union_variable_mock (union_id, variable_id, value) VALUES (?, ?, ?)")
          .run(unionId, id, 0);
      } else if (!this.memory.variables.some((entry) => entry.union_id === unionId && entry.variable_id === id)) {
        this.memory.variables.push({ union_id: unionId, variable_id: id, value: 0 });
      }
    }
  }

  private getVariable(unionId: number, id: number): number {
    if (this.sqlite) {
      const row = this.sqlite.prepare("SELECT value FROM union_variable_mock WHERE union_id = ? AND variable_id = ?").get(unionId, id) as
        | { value: number }
        | undefined;
      return row?.value ?? 0;
    }
    return this.memory.variables.find((entry) => entry.union_id === unionId && entry.variable_id === id)?.value ?? 0;
  }

  private setVariable(unionId: number, id: number, value: number): void {
    if (this.sqlite) {
      this.sqlite
        .prepare(
          [
            "INSERT INTO union_variable_mock (union_id, variable_id, value)",
            "VALUES (?, ?, ?)",
            "ON CONFLICT(union_id, variable_id) DO UPDATE SET value = excluded.value, updated_at = datetime('now')",
          ].join(" ")
        )
        .run(unionId, id, value);
      return;
    }
    const entry = this.memory.variables.find((variable) => variable.union_id === unionId && variable.variable_id === id);
    if (entry) {
      entry.value = value;
    } else {
      this.memory.variables.push({ union_id: unionId, variable_id: id, value });
    }
  }

  private upsertTask(unionId: number, uid: string, index: number, taskId: string, value: number): void {
    if (this.sqlite) {
      this.sqlite
        .prepare(
          [
            "INSERT INTO union_task_mock (union_id, uid, slot_index, task_id, value)",
            "VALUES (?, ?, ?, ?, ?)",
            "ON CONFLICT(union_id, uid, slot_index, task_id) DO UPDATE SET",
            "value = value + excluded.value, updated_at = datetime('now')",
          ].join(" ")
        )
        .run(unionId, uid, index, taskId, value);
      return;
    }
    const entry = this.memory.tasks.find(
      (task) => task.union_id === unionId && task.uid === uid && task.slot_index === index && task.task_id === taskId
    );
    if (entry) {
      entry.value += value;
    } else {
      this.memory.tasks.push({ union_id: unionId, uid, slot_index: index, task_id: taskId, value });
    }
  }

  private listTasks(unionId: number, uid: string, index: number): Array<{ task_id: string; value: number }> {
    if (this.sqlite) {
      return this.sqlite
        .prepare("SELECT task_id, value FROM union_task_mock WHERE union_id = ? AND uid = ? AND slot_index = ?")
        .all(unionId, uid, index) as Array<{ task_id: string; value: number }>;
    }
    return this.memory.tasks.filter((task) => task.union_id === unionId && task.uid === uid && task.slot_index === index);
  }

  private addLog(unionId: number, message: string): void {
    if (this.sqlite) {
      this.sqlite.prepare("INSERT INTO union_log_mock (union_id, message) VALUES (?, ?)").run(unionId, message);
      return;
    }
    this.memory.logs.push({ union_id: unionId, message, created_at: nowText() });
  }

  private listLogs(unionId: number): Array<{ message: string; created_at: string }> {
    if (this.sqlite) {
      return this.sqlite
        .prepare("SELECT message, created_at FROM union_log_mock WHERE union_id = ? ORDER BY id DESC")
        .all(unionId) as Array<{ message: string; created_at: string }>;
    }
    return this.memory.logs.filter((log) => log.union_id === unionId).slice().reverse();
  }

  private isOwner(member: UnionMemberRow): boolean {
    return this.getUnionById(member.union_id)?.owner_uid === member.uid;
  }
}

function defaultVariableIds(): number[] {
  return [6, 7, 8, 9, 10, 11, 12, 13, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 99, 90, 91, 92, 93, 94, 95, 96, 97, 98];
}

function taskContribution(taskId: string): number {
  const parsed = Number(taskId);
  if (Number.isFinite(parsed) && parsed > 0) {
    return Math.min(10000, Math.max(1, Math.floor(parsed)));
  }
  return 20;
}

function futureDateText(days: number): string {
  const date = new Date(Date.now() + days * 24 * 60 * 60 * 1000);
  const pad = (value: number) => String(value).padStart(2, "0");
  return `${date.getFullYear()}-${pad(date.getMonth() + 1)}-${pad(date.getDate())}`;
}
