PRAGMA journal_mode = WAL;
PRAGMA synchronous = NORMAL;
PRAGMA busy_timeout = 3000;
PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS global_uid_sequence (
  id INTEGER PRIMARY KEY CHECK (id = 1),
  next_uid INTEGER NOT NULL
);

INSERT OR IGNORE INTO global_uid_sequence (id, next_uid)
VALUES (1, 10000001);

CREATE TABLE IF NOT EXISTS global_players (
  uid INTEGER PRIMARY KEY,
  instance_id TEXT NOT NULL UNIQUE,
  username TEXT NOT NULL,
  nickname TEXT NOT NULL,
  created_at TEXT NOT NULL DEFAULT (datetime('now')),
  updated_at TEXT NOT NULL DEFAULT (datetime('now')),
  last_seen_at TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE UNIQUE INDEX IF NOT EXISTS idx_global_players_username
ON global_players(username COLLATE NOCASE);

CREATE TABLE IF NOT EXISTS remote_save_slots (
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

CREATE INDEX IF NOT EXISTS idx_remote_save_slots_updated
ON remote_save_slots(updated_at DESC);

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
  SELECT 1 FROM union_mock WHERE game_id = NEW.game_id AND title = NEW.title COLLATE NOCASE
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
  WHERE game_id = NEW.game_id AND uid = NEW.uid AND slot_index = NEW.slot_index AND union_id <> NEW.union_id
)
BEGIN
  SELECT RAISE(ABORT, 'account slot already belongs to a union');
END;

CREATE INDEX IF NOT EXISTS idx_union_mock_game
ON union_mock(game_id, level DESC, experience DESC);

CREATE INDEX IF NOT EXISTS idx_union_member_mock_account
ON union_member_mock(game_id, uid, slot_index);

CREATE INDEX IF NOT EXISTS idx_union_apply_mock_union
ON union_apply_mock(union_id, updated_at ASC);

CREATE INDEX IF NOT EXISTS idx_union_log_mock_union
ON union_log_mock(union_id, id DESC);

CREATE TABLE IF NOT EXISTS rank_entries (
  rank_list_id INTEGER NOT NULL,
  uid INTEGER NOT NULL REFERENCES global_players(uid) ON DELETE CASCADE,
  slot_index INTEGER NOT NULL,
  score INTEGER NOT NULL DEFAULT 0,
  extra TEXT NOT NULL DEFAULT '',
  created_at TEXT NOT NULL DEFAULT (datetime('now')),
  updated_at TEXT NOT NULL DEFAULT (datetime('now')),
  PRIMARY KEY(rank_list_id, uid, slot_index)
);

CREATE INDEX IF NOT EXISTS idx_rank_entries_order
ON rank_entries(rank_list_id, score DESC, updated_at ASC, uid ASC, slot_index ASC);
