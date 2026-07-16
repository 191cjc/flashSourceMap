# Platform Runtime Contracts

## Scenario: Empty union search and cloud-backed arena opponents

### 1. Scope / Trigger

Apply this contract when changing any of:

- union list arguments or Thrift responses;
- rank list `1093` query behavior;
- `ranging.php` routing or response data;
- native `save.api.4399.com` URL rewriting;
- generated inner-game SWF compatibility patches.

These paths span Flash bytecode, the native proxy, Windows saveData, Linux globalData, SQLite, and Thrift/JSON responses. A response can be structurally valid at one boundary but unusable at the next.

### 2. Signatures

```typescript
GlobalRankService.getArenaCandidates(
  gameId: string,
  uid: number,
  slotIndex: number,
  requestedCount: number
): RankEntry[];

GlobalRankService.getInitialArenaCandidates(
  gameId: string,
  requestedCount: number
): RankEntry[];

GlobalDataDatabase.getLatestSave(
  uid: number,
  gameId: string
): RemoteSaveSlot | null;

inspectEmptyUnionListCompatibility(swf: DecodedSwf): {
  targetFound: boolean;
  pageSizeSafe: boolean;
};

patchEmptyUnionListCompatibility(swf: DecodedSwf): number;
```

HTTP aliases accepted by Windows saveData:

```text
/ranging.php
/ranging.php/
/api/4399/ranging.php
/api/4399/ranging.php/
```

All aliases forward to global `/ranging.php/` with method, query, request body, content type, and `x-flash-*` identity headers preserved.

### 3. Contracts

#### Empty union

- `UnionSqPanel.initUnion` must call `getGameUList(slot, 1, 10)`, never pass the current zero union count as `pageShow`.
- An empty `unionList` response remains a Thrift success containing `list<struct>` length `0` and string count `"0"`.
- Do not create an placeholder union or report a false positive count.
- The SWF patch modifies only the second `getGameUList` argument and is idempotent.

#### Arena refresh

- Rank list `1093` `getRankingByArounds` uses `remote_save_slots` as eligibility and matching rank data as ordering/display metadata.
- Exclude the caller's exact UID/slot from real refresh candidates.
- Return at least 20 candidates. Flash backfills from stale `last100` below 20 and has an unsafe random-selection loop below 10.
- Repeat eligible entries transiently when fewer than 20 real slots exist.
- If only the caller's current slot exists, expose a transient alternate-slot entry so Flash does not self-filter the whole result.
- Do not insert repeated or alternate-slot entries into `rank_entries`, `remote_save_slots`, or `global_players`.

#### Arena initial list

- The client-specific rank `1093` page `95` request may be padded from the same cloud-save pool.
- Ordinary page `1` and other rank pages remain real and unpadded.

#### Opponent save

`GET|POST /ranging.php/?ac=get` accepts `uid`, `gameid`, and `index` from query parameters or POST form data.

Successful JSON:

```json
{
  "index": 1,
  "title": "role title",
  "datetime": "SQLite timestamp",
  "data": "complete save payload",
  "status": "0"
}
```

- If the exact target save exists, return it unchanged.
- If it is missing and `x-flash-uid` identifies a registered caller with a synced save, canonicalize a response-only copy to the requested UID/slot and mark the title as a training mirror.
- The canonicalized save must contain matching `jxid` and `sidx`; otherwise Flash `isHasFdata()` cannot complete.
- A mirror is never persisted.
- If neither a target save nor a caller mirror source exists, return text `0`.

Environment routing remains:

```text
GLOBAL_DATA_URL=http://host:7778
```

### 4. Validation & Error Matrix

| Condition | Required behavior |
|-----------|-------------------|
| Empty global union table | Thrift success, empty list, `count="0"` |
| Flash union search total is zero | SWF sends positive `pageShow=10` |
| Rank entry has no matching cloud save | Exclude it from arena refresh candidates |
| Fewer than 20 eligible arena slots | Repeat response-only candidates to requested/minimum size |
| Only caller's current slot exists | Use an alternate-slot training entry |
| Native `/api/4399/ranging.php/` request | Normalize and forward to global `/ranging.php/` |
| Exact opponent save exists | Return exact save |
| Exact opponent save missing, caller save exists | Return canonicalized training mirror |
| No exact save and no caller save | Return text `0` |
| SWF target missing or structurally changed | Fail runtime asset preparation instead of silently shipping an unpatched SWF |

### 5. Good / Base / Bad Cases

- Good: 30 other players have synced saves and rank rows. Refresh returns the requested 50 real cloud-backed candidates; selecting any tuple returns its exact save.
- Base: only the current player has one synced save. Refresh returns transient alternate-slot entries, Flash selects ten, and `ranging.php` returns a canonicalized caller-save mirror.
- Bad: return a short array of 1-9 candidates. Flash's `getTenInDTen()` can select undefined entries and never produce usable `PkSaveData`.
- Bad: return old rank entries without matching saves. The UI renders them, but selection stalls in “data loading.”

### 6. Tests Required

- Empty global DB `unionList`: decode the Thrift success and assert field `2` is `[]`, field `3` is `"0"`.
- SWF patch: assert target found, first patch count is `1` when original, inspection becomes safe, second patch count is `0`.
- Arena mirror pool: with one saved player and one unsaved ranked player, assert 50 candidates use the saved player's alternate slot and DB row counts are unchanged.
- Real arena pool: add the second player's matching save and assert candidates switch to that real UID/slot.
- Page isolation: assert rank page `1` is unpadded while page `95` has the requested initial candidate count.
- Candidate round trip: fetch a tuple returned by refresh through `ranging.php` and assert response `jxid/sidx` match.
- Native route: call `/api/4399/ranging.php/?ac=get...` through Windows saveData and assert a JSON save response instead of 404.
- Mirror persistence: compare player/save/rank row counts before and after candidate generation and mirror retrieval.

### 7. Wrong vs Correct

#### Wrong

```typescript
// A visible rank entry is not proof that battle data exists.
const candidates = listRank(1093);
return candidates.slice(0, 10);
```

```actionscript
// Zero is rejected by the platform SDK before the empty response can be handled.
getGameUList(1, unionData.getUnionAllNum());
```

#### Correct

```typescript
const candidates = listArenaSaves(gameId)
  .filter((entry) => entry.uid !== uid || entry.slotIndex !== slotIndex);
return repeatEntries(candidates, Math.max(20, requestedCount));
```

```actionscript
getGameUList(1, 10);
```
