import type { GlobalDataDatabase } from "../persistence/db.js";

export const ARENA_RANK_LIST_ID = 1093;
const MIN_ARENA_REFRESH_CANDIDATES = 20;
const DEFAULT_ARENA_EXTRA = JSON.stringify({ qsl: 0, qsb: 0, qls: 0, lv: 1, ca: 0, cb: 0, tx: [], jo: 1, fe: [] });

export type RankEntry = {
  rankListId: number;
  uid: number;
  username: string;
  slotIndex: number;
  score: number;
  rank: number;
  timestamp: string;
  extra: string;
};

export type RankSubmissionResult = {
  rankListId: number;
  score: number;
  rank: number;
  scoreLast: number;
  rankLast: number;
};

type RankRow = {
  rank_list_id: number;
  uid: number;
  username: string;
  slot_index: number;
  score: number;
  extra: string;
  updated_at: string;
};

function repeatEntries(entries: RankEntry[], size: number): RankEntry[] {
  if (entries.length === 0) {
    return [];
  }
  return Array.from({ length: size }, (_, index) => ({ ...entries[index % entries.length] }));
}

export class GlobalRankService {
  constructor(private readonly database: GlobalDataDatabase) {}

  submit(uid: number, slotIndex: number, submissions: Array<{ rankListId: number; score: number; extra: string }>): RankSubmissionResult[] {
    const results: RankSubmissionResult[] = [];
    this.database.db.exec("BEGIN IMMEDIATE");
    try {
      for (const submission of submissions) {
        const previous = this.findEntry(submission.rankListId, uid, slotIndex);
        this.database.db
          .prepare(
            [
              "INSERT INTO rank_entries (rank_list_id, uid, slot_index, score, extra)",
              "VALUES (?, ?, ?, ?, ?)",
              "ON CONFLICT(rank_list_id, uid, slot_index) DO UPDATE SET",
              "score = excluded.score, extra = excluded.extra, updated_at = datetime('now')",
            ].join(" ")
          )
          .run(submission.rankListId, uid, slotIndex, submission.score, submission.extra);
        const current = this.findEntry(submission.rankListId, uid, slotIndex)!;
        results.push({
          rankListId: submission.rankListId,
          score: current.score,
          rank: current.rank,
          scoreLast: previous?.score ?? 0,
          rankLast: previous?.rank ?? 0,
        });
      }
      this.database.db.exec("COMMIT");
      return results;
    } catch (error) {
      this.database.db.exec("ROLLBACK");
      throw error;
    }
  }

  getAround(rankListId: number, uid: number, slotIndex: number, arounds: number): RankEntry[] {
    const entries = this.listRank(rankListId);
    const ownIndex = entries.findIndex((entry) => entry.uid === uid && entry.slotIndex === slotIndex);
    if (ownIndex < 0) {
      return entries.slice(0, Math.max(1, arounds));
    }
    const radius = Math.max(1, arounds);
    const start = Math.max(0, ownIndex - Math.floor(radius / 2));
    return entries.slice(start, start + radius);
  }

  getArenaCandidates(gameId: string, uid: number, slotIndex: number, requestedCount: number): RankEntry[] {
    const size = Math.max(MIN_ARENA_REFRESH_CANDIDATES, Math.min(100, requestedCount));
    const entries = this.listArenaSaves(gameId);
    const eligible = entries.filter((entry) => entry.uid !== uid || entry.slotIndex !== slotIndex);
    if (eligible.length > 0) {
      return repeatEntries(eligible, size);
    }

    const ownEntry = entries.find((entry) => entry.uid === uid && entry.slotIndex === slotIndex) ?? entries.find((entry) => entry.uid === uid);
    if (!ownEntry) {
      return [];
    }
    const alternateSlot = slotIndex === 0 ? 1 : 0;
    return repeatEntries([{ ...ownEntry, slotIndex: alternateSlot }], size);
  }

  getInitialArenaCandidates(gameId: string, requestedCount: number): RankEntry[] {
    const size = Math.max(10, Math.min(100, requestedCount));
    return repeatEntries(this.listArenaSaves(gameId), size);
  }

  getPage(rankListId: number, pageSize: number, page: number): RankEntry[] {
    const size = Math.max(1, Math.min(100, pageSize));
    const pageNumber = Math.max(1, page);
    return this.listRank(rankListId).slice((pageNumber - 1) * size, pageNumber * size);
  }

  getByUsername(rankListId: number, username: string): RankEntry[] {
    const normalized = username.trim().toLocaleLowerCase();
    return this.listRank(rankListId).filter((entry) => entry.username.toLocaleLowerCase() === normalized);
  }

  private findEntry(rankListId: number, uid: number, slotIndex: number): RankEntry | null {
    return this.listRank(rankListId).find((entry) => entry.uid === uid && entry.slotIndex === slotIndex) ?? null;
  }

  private listRank(rankListId: number): RankEntry[] {
    const rows = this.database.db
      .prepare(
        [
          "SELECT rank.rank_list_id, rank.uid, player.username, rank.slot_index, rank.score, rank.extra, rank.updated_at",
          "FROM rank_entries rank JOIN global_players player ON player.uid = rank.uid",
          "WHERE rank.rank_list_id = ?",
          "ORDER BY rank.score DESC, rank.updated_at ASC, rank.uid ASC, rank.slot_index ASC",
        ].join(" ")
      )
      .all(rankListId) as RankRow[];
    return rows.map((row, index) => ({
      rankListId: row.rank_list_id,
      uid: row.uid,
      username: row.username,
      slotIndex: row.slot_index,
      score: row.score,
      rank: index + 1,
      timestamp: row.updated_at,
      extra: row.extra,
    }));
  }

  private listArenaSaves(gameId: string): RankEntry[] {
    const rows = this.database.db
      .prepare(
        [
          "SELECT save.uid, player.username, save.slot_index,",
          "COALESCE(rank.score, 1) AS score, COALESCE(NULLIF(rank.extra, ''), ?) AS extra,",
          "COALESCE(rank.updated_at, save.updated_at) AS updated_at",
          "FROM remote_save_slots save",
          "JOIN global_players player ON player.uid = save.uid",
          "LEFT JOIN rank_entries rank ON rank.uid = save.uid AND rank.slot_index = save.slot_index AND rank.rank_list_id = ?",
          "WHERE save.game_id = ?",
          "ORDER BY score DESC, updated_at ASC, save.uid ASC, save.slot_index ASC",
        ].join(" ")
      )
      .all(DEFAULT_ARENA_EXTRA, ARENA_RANK_LIST_ID, gameId) as Array<Omit<RankRow, "rank_list_id">>;
    return rows.map((row, index) => ({
      rankListId: ARENA_RANK_LIST_ID,
      uid: row.uid,
      username: row.username,
      slotIndex: row.slot_index,
      score: row.score,
      rank: index + 1,
      timestamp: row.updated_at,
      extra: row.extra,
    }));
  }
}
