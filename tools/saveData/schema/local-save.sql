PRAGMA journal_mode = WAL;
PRAGMA synchronous = NORMAL;
PRAGMA busy_timeout = 3000;

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

CREATE INDEX IF NOT EXISTS idx_save_slots_account_game
ON save_slots(account_id, game_id);

CREATE INDEX IF NOT EXISTS idx_save_snapshots_slot
ON save_snapshots(save_slot_id, created_at DESC);

CREATE INDEX IF NOT EXISTS idx_recharge_records_account
ON recharge_records(account_id, created_at DESC);
