PRAGMA journal_mode = WAL;
PRAGMA synchronous = NORMAL;
PRAGMA busy_timeout = 3000;
PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS accounts (
  id INTEGER PRIMARY KEY,
  uid TEXT NOT NULL UNIQUE,
  username TEXT NOT NULL,
  nickname TEXT NOT NULL,
  created_at TEXT NOT NULL DEFAULT (datetime('now')),
  updated_at TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS save_slots (
  id INTEGER PRIMARY KEY,
  account_id INTEGER NOT NULL REFERENCES accounts(id) ON DELETE CASCADE,
  game_id TEXT NOT NULL,
  slot_index INTEGER NOT NULL,
  title TEXT NOT NULL,
  raw_data TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT '0',
  checksum TEXT NOT NULL,
  created_at TEXT NOT NULL DEFAULT (datetime('now')),
  updated_at TEXT NOT NULL DEFAULT (datetime('now')),
  UNIQUE(account_id, game_id, slot_index)
);

CREATE TABLE IF NOT EXISTS save_snapshots (
  id INTEGER PRIMARY KEY,
  save_slot_id INTEGER NOT NULL REFERENCES save_slots(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  raw_data TEXT NOT NULL,
  checksum TEXT NOT NULL,
  created_at TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS wallet_mock (
  account_id INTEGER NOT NULL REFERENCES accounts(id) ON DELETE CASCADE,
  balance INTEGER NOT NULL DEFAULT 0,
  total_paid INTEGER NOT NULL DEFAULT 0,
  total_recharged INTEGER NOT NULL DEFAULT 0,
  updated_at TEXT NOT NULL DEFAULT (datetime('now')),
  PRIMARY KEY(account_id)
);

CREATE TABLE IF NOT EXISTS purchase_records (
  id INTEGER PRIMARY KEY,
  account_id INTEGER NOT NULL REFERENCES accounts(id) ON DELETE CASCADE,
  prop_id INTEGER NOT NULL,
  count INTEGER NOT NULL,
  price INTEGER NOT NULL,
  tag INTEGER NOT NULL DEFAULT 0,
  balance_after INTEGER NOT NULL,
  created_at TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS recharge_records (
  id INTEGER PRIMARY KEY,
  account_id INTEGER NOT NULL REFERENCES accounts(id) ON DELETE CASCADE,
  amount INTEGER NOT NULL,
  balance_after INTEGER NOT NULL,
  total_recharged_after INTEGER NOT NULL,
  created_at TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS online_mode_state (
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
  arena_settled_season INTEGER NOT NULL DEFAULT 0,
  last_error TEXT NOT NULL DEFAULT ''
);

CREATE TABLE IF NOT EXISTS remote_save_sync (
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

CREATE TABLE IF NOT EXISTS union_mock (
  id INTEGER PRIMARY KEY,
  game_id TEXT NOT NULL,
  owner_uid TEXT NOT NULL,
  owner_username TEXT NOT NULL,
  owner_nickname TEXT NOT NULL,
  title TEXT NOT NULL,
  level INTEGER NOT NULL DEFAULT 1,
  experience INTEGER NOT NULL DEFAULT 0,
  contribution INTEGER NOT NULL DEFAULT 0,
  extra TEXT NOT NULL DEFAULT '',
  extra2 TEXT NOT NULL DEFAULT '',
  dissolve_date TEXT NOT NULL DEFAULT '',
  transfer TEXT NOT NULL DEFAULT '',
  created_at TEXT NOT NULL DEFAULT (datetime('now')),
  updated_at TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS union_member_mock (
  union_id INTEGER NOT NULL REFERENCES union_mock(id) ON DELETE CASCADE,
  game_id TEXT NOT NULL,
  uid TEXT NOT NULL,
  username TEXT NOT NULL,
  nickname TEXT NOT NULL,
  slot_index INTEGER NOT NULL DEFAULT 0,
  contribution INTEGER NOT NULL DEFAULT 0,
  extra TEXT NOT NULL DEFAULT '',
  extra2 TEXT NOT NULL DEFAULT '',
  active_time TEXT NOT NULL DEFAULT '',
  role_id TEXT NOT NULL DEFAULT '0',
  role_name TEXT NOT NULL DEFAULT '成员',
  created_at TEXT NOT NULL DEFAULT (datetime('now')),
  updated_at TEXT NOT NULL DEFAULT (datetime('now')),
  PRIMARY KEY(union_id, uid, slot_index)
);

CREATE TABLE IF NOT EXISTS union_apply_mock (
  union_id INTEGER NOT NULL REFERENCES union_mock(id) ON DELETE CASCADE,
  game_id TEXT NOT NULL,
  uid TEXT NOT NULL,
  username TEXT NOT NULL,
  nickname TEXT NOT NULL,
  slot_index INTEGER NOT NULL DEFAULT 0,
  extra TEXT NOT NULL DEFAULT '',
  created_at TEXT NOT NULL DEFAULT (datetime('now')),
  updated_at TEXT NOT NULL DEFAULT (datetime('now')),
  PRIMARY KEY(union_id, uid, slot_index)
);

CREATE TABLE IF NOT EXISTS union_variable_mock (
  union_id INTEGER NOT NULL REFERENCES union_mock(id) ON DELETE CASCADE,
  variable_id INTEGER NOT NULL,
  value INTEGER NOT NULL DEFAULT 0,
  updated_at TEXT NOT NULL DEFAULT (datetime('now')),
  PRIMARY KEY(union_id, variable_id)
);

CREATE TABLE IF NOT EXISTS union_task_mock (
  union_id INTEGER NOT NULL REFERENCES union_mock(id) ON DELETE CASCADE,
  uid TEXT NOT NULL,
  slot_index INTEGER NOT NULL DEFAULT 0,
  task_id TEXT NOT NULL,
  value INTEGER NOT NULL DEFAULT 0,
  updated_at TEXT NOT NULL DEFAULT (datetime('now')),
  PRIMARY KEY(union_id, uid, slot_index, task_id)
);

CREATE TABLE IF NOT EXISTS union_log_mock (
  id INTEGER PRIMARY KEY,
  union_id INTEGER NOT NULL REFERENCES union_mock(id) ON DELETE CASCADE,
  message TEXT NOT NULL,
  actor_username TEXT NOT NULL DEFAULT '',
  created_at TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE TRIGGER IF NOT EXISTS trg_union_title_unique_insert
BEFORE INSERT ON union_mock
WHEN EXISTS (
  SELECT 1 FROM union_mock
  WHERE game_id = NEW.game_id AND title = NEW.title COLLATE NOCASE
)
BEGIN
  SELECT RAISE(ABORT, 'duplicate union title');
END;

CREATE TRIGGER IF NOT EXISTS trg_union_title_unique_update
BEFORE UPDATE OF game_id, title ON union_mock
WHEN EXISTS (
  SELECT 1 FROM union_mock
  WHERE game_id = NEW.game_id AND title = NEW.title COLLATE NOCASE AND id <> NEW.id
)
BEGIN
  SELECT RAISE(ABORT, 'duplicate union title');
END;

CREATE TRIGGER IF NOT EXISTS trg_union_member_one_union_insert
BEFORE INSERT ON union_member_mock
WHEN EXISTS (
  SELECT 1 FROM union_member_mock
  WHERE game_id = NEW.game_id
    AND uid = NEW.uid
    AND slot_index = NEW.slot_index
    AND union_id <> NEW.union_id
)
BEGIN
  SELECT RAISE(ABORT, 'account slot already belongs to a union');
END;

CREATE INDEX IF NOT EXISTS idx_save_slots_account_game
ON save_slots(account_id, game_id);

CREATE INDEX IF NOT EXISTS idx_save_snapshots_slot
ON save_snapshots(save_slot_id, created_at DESC);

CREATE INDEX IF NOT EXISTS idx_recharge_records_account
ON recharge_records(account_id, created_at DESC);

CREATE INDEX IF NOT EXISTS idx_remote_save_sync_pending
ON remote_save_sync(pending, last_attempt_at);

CREATE INDEX IF NOT EXISTS idx_union_mock_game
ON union_mock(game_id, level DESC, experience DESC);

CREATE INDEX IF NOT EXISTS idx_union_member_mock_account
ON union_member_mock(game_id, uid, slot_index);

CREATE INDEX IF NOT EXISTS idx_union_apply_mock_union
ON union_apply_mock(union_id, updated_at ASC);

CREATE INDEX IF NOT EXISTS idx_union_log_mock_union
ON union_log_mock(union_id, id DESC);
