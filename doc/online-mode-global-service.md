# 联机模式与 Linux 全局服务设计

## 目标

在保持 Windows 本地存档、钱包、充值和商城能力可独立运行的前提下，增加用户主动接入的联机模式：

- 默认账号 UID 为 `10001` 时，用户通过左侧侧边栏的“联机模式”主动注册。
- Linux 服务为首次接入的 Windows 实例分配不可修改的永久 UID。
- Windows 在本地事务中迁移账号 UID，并重写所有当前存档中的身份字段。
- 接入后每次存档先写本地，再通过持久化同步队列写入 Linux。
- Linux 保存远程存档副本，并承载军团、排行榜和竞技场公共数据。
- Linux 不保存钱包、充值、商城购买记录和本地存档历史。

## 数据边界

### Windows 本地

- `accounts`
- `save_slots`
- `save_snapshots`
- `wallet_mock`
- `purchase_records`
- `recharge_records`
- 联机状态和远程同步队列

本地数据库始终是玩家日常读取和单机模式使用的存档来源。Linux 不可用时，本地读取、保存、充值和商城功能不得受影响。

### Linux 全局服务

- 全局玩家与实例绑定
- 远程完整存档副本
- 军团
- 排行榜
- 竞技场公开存档和比赛数据

Linux 存档用于双写副本、竞技场读取其他玩家和后续远程恢复，不自动覆盖 Windows 本地存档。

## 目录边界

Linux 特有代码放在独立目录：

```text
runtime/global-data/
  persistence/
  rank/
  deploy/
  server/
  schema/
  tests/
  types.ts
```

Windows 本地联机协调逻辑继续放在：

```text
runtime/save-data/services/onlineMode.ts
runtime/save-data/server/server.ts
runtime/save-data/public/
```

两个运行时可以复用无状态的协议和存档编解码工具，但 Linux 目录不得直接注册钱包、充值、商城和本地存档调试接口。

## 联机状态

联机模式使用以下状态：

| 状态 | 含义 |
| --- | --- |
| `eligible` | 服务器正常，本地 UID 和所有存档 UID 均为 `10001`，允许接入 |
| `joining` | 已请求注册，正在迁移本地身份或上传初始存档 |
| `online` | 已获得永久 UID，身份一致，远程存档已同步 |
| `sync_pending` | 已接入，但有远程存档等待上传 |
| `server_offline` | Linux 不可访问，本地功能继续工作 |
| `identity_conflict` | 账号 UID 与存档 UID 不一致，暂停远程同步 |
| `migration_failed` | Linux 已分配 UID，但本地迁移未完成，可按实例 ID 重试 |

如果所有当前存档 UID 相同且不为 `10001`，侧栏显示该 UID 和用户名。若 Linux 中不存在该实例绑定，则使用当前 UID恢复登记，不重新分配 UID。

## 健康检查

Linux 提供：

```http
GET /health
```

响应包含服务版本、数据库状态、服务器时间和可用功能。

Windows 侧栏只访问本地接口：

```http
GET /api/saveData/online-mode/status
```

本地服务请求 Linux `/health`，并合并本地账号、存档身份和同步状态。侧栏因此可以区分网络失败、HTTP 失败、数据库失败和版本不兼容。

## UID 注册和迁移

Windows 首次启动联机功能时生成持久化 `instance_id`。注册请求为：

```http
POST /api/global/register
```

```json
{
  "instanceId": "uuid",
  "sourceUid": "10001",
  "username": "local_user",
  "nickname": "本地玩家"
}
```

Linux 按 `instance_id` 幂等处理：

- 已注册实例返回原 UID。
- 新实例且来源 UID 为 `10001` 时，从 `10000001` 开始分配 UID。
- 新实例且来源 UID 不为 `10001` 时，保留该 UID；若已被其他实例占用则返回冲突。

本地迁移在单个 SQLite 事务中完成：

1. 创建迁移前存档快照。
2. 更新 `accounts.uid` 和用户名。
3. 使用 `canonicalizeLocalSaveIdentity()` 重写所有当前槽位的 `jxid`、`sidx`、`idn` 和 `idai`。
4. 重算槽位 checksum 和本地 revision。
5. 写入远程同步队列。
6. 标记联机模式已启用。

钱包、充值、购买和存档记录通过 `account_id` 关联，因此 UID 原地更新不会迁移或丢失这些记录。

迁移成功后必须重载 Flash，使运行中的平台账号从 `10001` 切换为新 UID。

## 用户名修改

已接入用户可以修改用户名，但 UID 始终只读。

用户名修改流程：

1. Linux 更新全局玩家用户名。
2. Windows 更新本地账号和联机状态。
3. 重写所有当前存档的 `idn`。
4. 增加 revision 并加入远程同步队列。
5. 重载 Flash。

用户名允许中文、英文、数字和下划线，长度为 2 至 20 个字符。Linux 保证用户名不区分大小写唯一。

## 双写策略

不使用跨 Windows 和 Linux 的强事务。每次保存执行：

1. 本地事务写入存档。
2. 同一事务更新本地 revision 和远程同步队列。
3. 立即向 Flash 返回本地保存成功。
4. 后台异步上传 Linux。

Linux 不可用时，保存仍然成功，队列保留待同步状态。后台在保存后、启动后、打开联机 tab、用户手动同步和进入竞技场前重试。

上传使用 `revision + checksum` 保证幂等，Linux 拒绝旧 revision 覆盖新数据。

竞技场开始前要求当前槽位已经同步；普通单机游戏不要求 Linux 在线。

## Windows 本地接口

```text
GET  /api/saveData/online-mode/status
POST /api/saveData/online-mode/join
POST /api/saveData/online-mode/profile
POST /api/saveData/online-mode/sync
POST /api/saveData/online-mode/repair
GET  /api/saveData/online-mode/sync-status
```

## Linux 接口

```text
GET   /health
POST  /api/global/register
GET   /api/global/players/:uid
PATCH /api/global/players/:uid
PUT   /api/global/saves/:uid/:slot
GET   /api/global/saves/:uid/:slot
GET   /api/global/saves/:uid
POST  /api/4399/union/*
POST  /api/4399/rank/FlashScoreApi
GET   /ranging.php/?ac=get_token
POST  /ranging.php/?ac=get
```

已实现健康检查、注册、玩家资料、远程存档双写、军团、排行榜和竞技场对手存档读取。排行榜支持游戏当前使用的 `submit`、`getRankingByArounds`、`getRankingByPage` 和 `getRank` Thrift 方法。Windows 在访问排行榜前先重试所有待上传存档；仍有待同步数据时拒绝进入竞技场。

Windows 通过 `GLOBAL_DATA_URL=http://Linux地址:7778` 指向全局服务。Linux 默认监听 `0.0.0.0:7778`，可使用 `runtime/global-data/deploy/flash-global-data.service.example` 作为 `systemd` 服务模板。

## 本地数据表扩展

```sql
CREATE TABLE online_mode_state (
  id INTEGER PRIMARY KEY CHECK (id = 1),
  instance_id TEXT NOT NULL,
  enabled INTEGER NOT NULL DEFAULT 0,
  server_url TEXT NOT NULL,
  assigned_uid TEXT NOT NULL DEFAULT '10001',
  username TEXT NOT NULL DEFAULT 'local_user',
  migration_state TEXT NOT NULL DEFAULT 'none',
  registered_at TEXT NOT NULL DEFAULT '',
  last_health_at TEXT NOT NULL DEFAULT '',
  last_sync_at TEXT NOT NULL DEFAULT '',
  last_error TEXT NOT NULL DEFAULT ''
);

CREATE TABLE remote_save_sync (
  account_id INTEGER NOT NULL REFERENCES accounts(id) ON DELETE CASCADE,
  game_id TEXT NOT NULL,
  slot_index INTEGER NOT NULL,
  local_revision INTEGER NOT NULL DEFAULT 0,
  uploaded_revision INTEGER NOT NULL DEFAULT 0,
  local_checksum TEXT NOT NULL DEFAULT '',
  uploaded_checksum TEXT NOT NULL DEFAULT '',
  pending INTEGER NOT NULL DEFAULT 1,
  retry_count INTEGER NOT NULL DEFAULT 0,
  last_attempt_at TEXT NOT NULL DEFAULT '',
  last_success_at TEXT NOT NULL DEFAULT '',
  last_error TEXT NOT NULL DEFAULT '',
  PRIMARY KEY(account_id, game_id, slot_index)
);
```

## 初始 Linux 数据表

```sql
CREATE TABLE global_players (
  uid INTEGER PRIMARY KEY,
  instance_id TEXT NOT NULL UNIQUE,
  username TEXT NOT NULL,
  nickname TEXT NOT NULL,
  created_at TEXT NOT NULL DEFAULT (datetime('now')),
  updated_at TEXT NOT NULL DEFAULT (datetime('now')),
  last_seen_at TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE UNIQUE INDEX idx_global_players_username
ON global_players(username COLLATE NOCASE);

CREATE TABLE remote_save_slots (
  uid INTEGER NOT NULL REFERENCES global_players(uid) ON DELETE CASCADE,
  game_id TEXT NOT NULL,
  slot_index INTEGER NOT NULL,
  title TEXT NOT NULL,
  raw_data TEXT NOT NULL,
  checksum TEXT NOT NULL,
  revision INTEGER NOT NULL DEFAULT 0,
  updated_at TEXT NOT NULL DEFAULT (datetime('now')),
  PRIMARY KEY(uid, game_id, slot_index)
);
```

## 提交阶段

1. 提交当前工作区基线。
2. 提交本设计文档和任务规划。
3. 提交 Linux 独立全局服务、schema 和测试。
4. 提交 Windows 本地 UID 迁移、动态账号和同步队列。
5. 提交联机模式侧栏和接口。
6. 提交双写联调、启动脚本和完整测试。

每个阶段必须通过相关测试、TypeScript 类型检查和 `git diff --check` 后再提交。
