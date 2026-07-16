import { createServer, type IncomingMessage, type ServerResponse } from "node:http";
import type { AddressInfo } from "node:net";
import path from "node:path";
import { fileURLToPath } from "node:url";
import { GlobalDataDatabase, GlobalDataError } from "../persistence/db.js";
import type { PutRemoteSaveRequest, RegisterGlobalPlayerRequest } from "../types.js";
import type { SaveDataStore } from "../../save-data/persistence/store.js";
import { unionMockResponse } from "../../save-data/server/server.js";
import { LocalUnionMockService } from "../../save-data/services/union.js";
import { handleGlobalRankRequest } from "../rank/protocol.js";
import { GlobalRankService } from "../rank/service.js";

type GlobalDataServerOptions = {
  host?: string;
  port?: number;
  dbFile?: string;
};

const moduleDir = path.dirname(fileURLToPath(import.meta.url));
const projectRoot = path.resolve(moduleDir, "../../..");
const defaultDbFile = path.join(projectRoot, "workspace", "globalData", "global-game.db");
const MAX_BODY_BYTES = 32 * 1024 * 1024;

function sendJson(res: ServerResponse, status: number, value: unknown): void {
  const body = JSON.stringify(value);
  res.writeHead(status, {
    "content-type": "application/json; charset=utf-8",
    "content-length": Buffer.byteLength(body),
    "access-control-allow-origin": "*",
    "access-control-allow-headers": "content-type",
    "access-control-allow-methods": "GET,POST,PUT,PATCH,OPTIONS",
  });
  res.end(body);
}

function sendBinary(res: ServerResponse, status: number, contentType: string, body: Buffer): void {
  res.writeHead(status, {
    "content-type": contentType,
    "content-length": body.length,
    "access-control-allow-origin": "*",
    "access-control-allow-headers": "*",
    "access-control-allow-methods": "GET,POST,PUT,PATCH,OPTIONS",
  });
  res.end(body);
}

function sendText(res: ServerResponse, status: number, contentType: string, body: string): void {
  sendBinary(res, status, contentType, Buffer.from(body, "utf8"));
}

async function readJson<T>(req: IncomingMessage): Promise<T> {
  const chunks: Buffer[] = [];
  let length = 0;
  for await (const chunk of req) {
    const buffer = Buffer.from(chunk);
    length += buffer.length;
    if (length > MAX_BODY_BYTES) {
      throw new GlobalDataError("body_too_large", "请求体过大", 413);
    }
    chunks.push(buffer);
  }
  try {
    return JSON.parse(Buffer.concat(chunks).toString("utf8") || "{}") as T;
  } catch {
    throw new GlobalDataError("invalid_json", "请求体不是有效 JSON");
  }
}

function routeMatch(pathname: string, pattern: RegExp): RegExpExecArray | null {
  return pattern.exec(pathname);
}

export async function startGlobalDataServer(options: GlobalDataServerOptions = {}) {
  const host = options.host ?? process.env.GLOBAL_DATA_HOST ?? "0.0.0.0";
  const port = options.port ?? Number(process.env.GLOBAL_DATA_PORT ?? 8800);
  const dbFile = options.dbFile ?? process.env.GLOBAL_DATA_DB ?? defaultDbFile;
  const db = new GlobalDataDatabase(dbFile);
  const rankService = new GlobalRankService(db);
  const startedAt = Date.now();

  const server = createServer(async (req, res) => {
    try {
      if (req.method === "OPTIONS") {
        sendJson(res, 204, {});
        return;
      }
      const url = new URL(req.url ?? "/", `http://${req.headers.host ?? `${host}:${port}`}`);

      if (req.method === "GET" && url.pathname === "/health") {
        sendJson(res, 200, {
          ok: true,
          service: "flash-global-data",
          version: "1.0.0",
          database: "ok",
          sqlite: db.health().sqliteVersion,
          serverTime: Date.now(),
          uptimeMs: Date.now() - startedAt,
          features: { registration: true, remoteSave: true, union: true, rank: true, arena: true },
        });
        return;
      }

      if (req.method === "POST" && url.pathname === "/api/global/register") {
        const result = db.registerPlayer(await readJson<RegisterGlobalPlayerRequest>(req));
        sendJson(res, 200, { ok: true, ...result, uid: result.player.uid, username: result.player.username });
        return;
      }

      const playerMatch = routeMatch(url.pathname, /^\/api\/global\/players\/(\d+)$/);
      if (playerMatch && req.method === "GET") {
        const player = db.getPlayerByUid(Number(playerMatch[1]));
        sendJson(res, player ? 200 : 404, player ? { ok: true, player } : { ok: false, error: "player_not_found" });
        return;
      }
      if (playerMatch && req.method === "PATCH") {
        const body = await readJson<{ username?: string }>(req);
        const player = db.updatePlayer(Number(playerMatch[1]), body.username ?? "");
        sendJson(res, 200, { ok: true, player });
        return;
      }

      const saveMatch = routeMatch(url.pathname, /^\/api\/global\/saves\/(\d+)\/(\d+)$/);
      if (saveMatch && req.method === "PUT") {
        const result = db.putSave(Number(saveMatch[1]), Number(saveMatch[2]), await readJson<PutRemoteSaveRequest>(req));
        sendJson(res, 200, { ok: true, ...result });
        return;
      }
      if (saveMatch && req.method === "GET") {
        const gameId = url.searchParams.get("gameId") ?? "100025235";
        const save = db.getSave(Number(saveMatch[1]), gameId, Number(saveMatch[2]));
        sendJson(res, save ? 200 : 404, save ? { ok: true, save } : { ok: false, error: "save_not_found" });
        return;
      }

      const saveListMatch = routeMatch(url.pathname, /^\/api\/global\/saves\/(\d+)$/);
      if (saveListMatch && req.method === "GET") {
        const gameId = url.searchParams.get("gameId") ?? "100025235";
        sendJson(res, 200, { ok: true, saves: db.listSaves(Number(saveListMatch[1]), gameId) });
        return;
      }

      if (req.method === "POST" && url.pathname.startsWith("/api/4399/union/")) {
        const uid = Number(req.headers["x-flash-uid"] ?? 0);
        const player = db.getPlayerByUid(uid);
        if (!player) {
          throw new GlobalDataError("player_not_found", "联机玩家不存在", 404);
        }
        const requestBody = Buffer.concat(await readBodyChunks(req));
        const unionApi = new LocalUnionMockService(db as unknown as SaveDataStore, {
          uid: String(player.uid),
          username: player.username,
          nickname: player.nickname,
        });
        const response = unionMockResponse(unionApi, requestBody);
        sendBinary(res, 200, "application/x-thrift", response.body);
        return;
      }

      if (req.method === "POST" && url.pathname === "/api/4399/rank/FlashScoreApi") {
        const uid = Number(req.headers["x-flash-uid"] ?? 0);
        const player = db.getPlayerByUid(uid);
        if (!player) {
          throw new GlobalDataError("player_not_found", "联机玩家不存在", 404);
        }
        const response = handleGlobalRankRequest(rankService, player, Buffer.concat(await readBodyChunks(req)));
        sendBinary(res, 200, "application/x-thrift", response.body);
        return;
      }

      if ((url.pathname === "/ranging.php" || url.pathname === "/ranging.php/") && url.searchParams.get("ac") === "get_token") {
        sendText(res, 200, "text/plain; charset=utf-8", "global-rank-token");
        return;
      }

      if ((url.pathname === "/ranging.php" || url.pathname === "/ranging.php/") && url.searchParams.get("ac") === "get") {
        const requestBody = req.method === "POST" ? Buffer.concat(await readBodyChunks(req)).toString("utf8") : "";
        const params = new URLSearchParams(requestBody);
        const uid = Number(params.get("uid") ?? url.searchParams.get("uid") ?? 0);
        const gameId = params.get("gameid") ?? url.searchParams.get("gameid") ?? "100025235";
        const slotIndex = Number(params.get("index") ?? url.searchParams.get("index") ?? 0);
        const save = db.getSave(uid, gameId, slotIndex);
        if (!save) {
          sendText(res, 200, "text/plain; charset=utf-8", "0");
          return;
        }
        sendJson(res, 200, {
          index: save.slotIndex,
          title: save.title,
          datetime: save.updatedAt,
          data: save.data,
          status: "0",
        });
        return;
      }

      sendJson(res, 404, { ok: false, error: "not_found" });
    } catch (error) {
      if (error instanceof GlobalDataError) {
        sendJson(res, error.status, { ok: false, error: error.code, message: error.message });
        return;
      }
      sendJson(res, 500, { ok: false, error: "internal_error", message: error instanceof Error ? error.message : String(error) });
    }
  });

  await new Promise<void>((resolve) => server.listen(port, host, resolve));
  const address = server.address() as AddressInfo;
  return {
    host,
    port: address.port,
    url: `http://${host}:${address.port}`,
    db,
    server,
    close: async () => {
      await new Promise<void>((resolve, reject) => server.close((error) => (error ? reject(error) : resolve())));
      db.close();
    },
  };
}

async function readBodyChunks(req: IncomingMessage): Promise<Buffer[]> {
  const chunks: Buffer[] = [];
  let length = 0;
  for await (const chunk of req) {
    const buffer = Buffer.from(chunk);
    length += buffer.length;
    if (length > MAX_BODY_BYTES) {
      throw new GlobalDataError("body_too_large", "请求体过大", 413);
    }
    chunks.push(buffer);
  }
  return chunks;
}

if (process.argv[1] && path.resolve(fileURLToPath(import.meta.url)) === path.resolve(process.argv[1])) {
  startGlobalDataServer()
    .then(({ url, db }) => {
      console.log(`globalData server: ${url}`);
      console.log(`database: ${db.dbFile}`);
    })
    .catch((error) => {
      console.error(error);
      process.exitCode = 1;
    });
}
