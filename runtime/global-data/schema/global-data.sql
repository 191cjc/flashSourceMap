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
