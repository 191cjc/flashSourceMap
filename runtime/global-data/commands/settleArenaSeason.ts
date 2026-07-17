import path from "node:path";
import { fileURLToPath } from "node:url";
import { GlobalDataDatabase } from "../persistence/db.js";
import { GlobalRankService } from "../rank/service.js";

const moduleDir = path.dirname(fileURLToPath(import.meta.url));
const projectRoot = path.resolve(moduleDir, "../../..");
const dbFile = process.env.GLOBAL_DATA_DB ?? path.join(projectRoot, "workspace", "globalData", "global-game.db");
const seasonArgumentIndex = process.argv.indexOf("--season");
const expectedSeason = Number(seasonArgumentIndex >= 0 ? process.argv[seasonArgumentIndex + 1] : NaN);
if (!Number.isSafeInteger(expectedSeason) || expectedSeason < 1) {
  throw new Error("用法：npm run globalData:arena:settle -- --season <当前赛季号>");
}
const database = new GlobalDataDatabase(dbFile);

try {
  const result = new GlobalRankService(database).settleArenaSeason(expectedSeason);
  console.log(JSON.stringify({ ok: true, database: dbFile, ...result }, null, 2));
} finally {
  database.close();
}
