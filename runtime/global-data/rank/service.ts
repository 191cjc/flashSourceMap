import type { GlobalDataDatabase } from "../persistence/db.js";

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
}
