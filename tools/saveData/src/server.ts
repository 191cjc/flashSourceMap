import { createServer, type IncomingMessage, type ServerResponse } from "node:http";
import type { AddressInfo } from "node:net";
import { createReadStream, existsSync, mkdirSync, readFileSync, statSync, writeFileSync } from "node:fs";
import { cp, readFile, writeFile } from "node:fs/promises";
import path from "node:path";
import { fileURLToPath } from "node:url";
import { patchRuffleEventCompatibility } from "../../../src/swf/payEventPatch.js";
import { decodeSwf, encodeSwf, replaceDefineBinaryData } from "../../../src/swf/swf.js";
import { LocalSaveDatabase } from "./db.js";
import { SaveDataLogger } from "./logger.js";
import { SaveDataMockApi } from "./mockApi.js";
import { saveDataPaths } from "./paths.js";

type ServerOptions = {
  host?: string;
  port?: number;
  dbFile?: string;
};

const MIME_TYPES: Record<string, string> = {
  ".html": "text/html; charset=utf-8",
  ".js": "text/javascript; charset=utf-8",
  ".css": "text/css; charset=utf-8",
  ".json": "application/json; charset=utf-8",
  ".swf": "application/x-shockwave-flash",
  ".wasm": "application/wasm",
  ".gif": "image/gif",
  ".png": "image/png",
  ".jpg": "image/jpeg",
  ".jpeg": "image/jpeg",
};

const EMPTY_GIF = Buffer.from("R0lGODlhAQABAIAAAAAAAP///ywAAAAAAQABAAACAUwAOw==", "base64");
const REMOTE_SWF_ASSETS = {
  ctrl: "http://cdn.comment.4399pk.com/control/ctrl_mo_v5.swf?200",
  adBase: "http://cdn.comment.4399pk.com/control/A4399dv_base.swf?200",
  adMain: "https://cdn.comment.4399pk.com/control/A4399dv_base_main.swf?20200714",
  tools: "http://cdn.comment.4399pk.com/control/open4399tools_AS3.swf",
} as const;
const GAME_ASSET_BASE_URL = "https://sbai.4399.com/4399swf/upload_swf/ftp10/honghao/20130530/27/";
const GAME_ASSET_REFERER = `${GAME_ASSET_BASE_URL}jjxzfcms.htm`;
const SWF_FILE_RE = /^[A-Za-z0-9_.-]+\.swf$/i;

function getContentType(filePath: string): string {
  return MIME_TYPES[path.extname(filePath).toLowerCase()] ?? "application/octet-stream";
}

async function readRequestBody(req: IncomingMessage): Promise<string> {
  const chunks: Buffer[] = [];
  for await (const chunk of req) {
    chunks.push(Buffer.isBuffer(chunk) ? chunk : Buffer.from(chunk));
  }
  return Buffer.concat(chunks).toString("utf8");
}

function send(res: ServerResponse, status: number, contentType: string, body: string | Buffer): void {
  res.writeHead(status, {
    "content-type": contentType,
    "access-control-allow-origin": "*",
    "access-control-allow-methods": "GET,POST,OPTIONS",
    "access-control-allow-headers": "*",
  });
  res.end(body);
}

function sendNotFound(res: ServerResponse): void {
  send(res, 404, "text/plain; charset=utf-8", "not found");
}

function safeJoin(root: string, requestPath: string): string | null {
  const decoded = decodeURIComponent(requestPath);
  const joined = path.resolve(root, `.${decoded}`);
  return joined.startsWith(path.resolve(root)) ? joined : null;
}

async function ensureRemoteAsset(assetFile: string, sourceUrl: string): Promise<void> {
  if (existsSync(assetFile)) {
    return;
  }

  mkdirSync(path.dirname(assetFile), { recursive: true });
  const response = await fetch(sourceUrl);
  if (!response.ok) {
    throw new Error(`Failed to download ${sourceUrl}: ${response.status} ${response.statusText}`);
  }

  await writeFile(assetFile, Buffer.from(await response.arrayBuffer()));
}

function gameAssetFile(assetName: string): string {
  return path.join(saveDataPaths.remoteAssetsRoot, "sbai.4399.com", "4399swf", "upload_swf", "ftp10", "honghao", "20130530", "27", assetName);
}

async function ensureGameAsset(assetName: string, logger: SaveDataLogger): Promise<string | null> {
  if (!SWF_FILE_RE.test(assetName)) {
    return null;
  }

  const assetFile = gameAssetFile(assetName);
  if (existsSync(assetFile)) {
    logger.appendSync({
      event: "asset.local_hit",
      method: "GET",
      pathname: `/${assetName}`,
      status: 200,
      result: "ok",
      details: { assetName, file: assetFile, size: statSync(assetFile).size },
    });
    return assetFile;
  }

  const sourceUrl = new URL(assetName, GAME_ASSET_BASE_URL).toString();
  logger.appendSync({
    event: "asset.remote_fetch",
    method: "GET",
    pathname: `/${assetName}`,
    status: 0,
    result: "pending",
    details: { assetName, sourceUrl },
  });

  const response = await fetch(sourceUrl, {
    headers: {
      "User-Agent": "Mozilla/5.0",
      Referer: GAME_ASSET_REFERER,
    },
  });

  if (!response.ok) {
    logger.appendSync({
      event: "asset.remote_fetch",
      method: "GET",
      pathname: `/${assetName}`,
      status: response.status,
      result: "error",
      details: { assetName, sourceUrl, statusText: response.statusText },
    });
    return null;
  }

  const body = Buffer.from(await response.arrayBuffer());
  mkdirSync(path.dirname(assetFile), { recursive: true });
  await writeFile(assetFile, body);
  logger.appendSync({
    event: "asset.remote_fetch",
    method: "GET",
    pathname: `/${assetName}`,
    status: 200,
    result: "ok",
    details: { assetName, sourceUrl, file: assetFile, size: body.length },
  });
  return assetFile;
}

function patchedRuffleEventSwfBytes(inputFile: string): Buffer {
  const swf = decodeSwf(readFileSync(inputFile));
  const patchCount = patchRuffleEventCompatibility(swf);

  if (patchCount < 1) {
    throw new Error(`Expected Ruffle event compatibility target in ${inputFile}, patched ${patchCount}`);
  }

  return encodeSwf(swf);
}

function patchRuffleEventSwf(inputFile: string, outputFile: string): void {
  writeFileSync(outputFile, patchedRuffleEventSwfBytes(inputFile));
}

function patchOuterSwfForRuffle(outerFile: string, patchedInnerBytes: Buffer, outputFile: string): void {
  const swf = decodeSwf(readFileSync(outerFile));
  const patchCount = patchRuffleEventCompatibility(swf);
  const replacements = replaceDefineBinaryData(swf, 13, patchedInnerBytes);

  if (patchCount < 1) {
    throw new Error(`Expected Ruffle event compatibility target in ${outerFile}, patched ${patchCount}`);
  }
  if (replacements !== 1) {
    throw new Error(`Expected one embedded game SWF replacement in ${outerFile}, found ${replacements}`);
  }

  writeFileSync(outputFile, encodeSwf(swf));
}

async function ensureRuntimeAssets(): Promise<void> {
  mkdirSync(path.join(saveDataPaths.runtimePublicRoot, "assets"), { recursive: true });
  mkdirSync(path.join(saveDataPaths.runtimePublicRoot, "swf"), { recursive: true });
  mkdirSync(path.join(saveDataPaths.runtimePublicRoot, "ruffle"), { recursive: true });

  const outerSwf = path.join(saveDataPaths.downloadsSwf, "xfbbv451.swf");
  const innerSwf = path.join(saveDataPaths.extractedSwf, "L4399Main_gamefile.swf");
  const publicOuter = path.join(saveDataPaths.runtimePublicRoot, "swf", "xfbbv451.swf");
  const publicInner = path.join(saveDataPaths.runtimePublicRoot, "swf", "L4399Main_gamefile.swf");
  const adAsset = path.join(saveDataPaths.platformAssetsRoot, "A4399dv_base.swf");
  const adMainAsset = path.join(saveDataPaths.platformAssetsRoot, "A4399dv_base_main.swf");
  const toolsAsset = path.join(saveDataPaths.platformAssetsRoot, "open4399tools_AS3.swf");
  const publicAd = path.join(saveDataPaths.runtimePublicRoot, "assets", "A4399dv_base.swf");
  const publicAdMain = path.join(saveDataPaths.runtimePublicRoot, "assets", "A4399dv_base_main.swf");
  const publicTools = path.join(saveDataPaths.runtimePublicRoot, "assets", "open4399tools_AS3.swf");

  const patchedInnerBytes = existsSync(innerSwf) ? patchedRuffleEventSwfBytes(innerSwf) : null;
  if (existsSync(outerSwf) && patchedInnerBytes) {
    patchOuterSwfForRuffle(outerSwf, patchedInnerBytes, publicOuter);
  } else if (existsSync(outerSwf)) {
    patchRuffleEventSwf(outerSwf, publicOuter);
  }
  if (patchedInnerBytes) {
    await writeFile(publicInner, patchedInnerBytes);
  }
  await ensureRemoteAsset(adAsset, REMOTE_SWF_ASSETS.adBase);
  await ensureRemoteAsset(adMainAsset, REMOTE_SWF_ASSETS.adMain);
  await ensureRemoteAsset(toolsAsset, REMOTE_SWF_ASSETS.tools);
  await cp(adAsset, publicAd);
  await cp(adMainAsset, publicAdMain);
  await cp(toolsAsset, publicTools);

  await cp(saveDataPaths.ruffleRoot, path.join(saveDataPaths.runtimePublicRoot, "ruffle"), {
    recursive: true,
    force: true,
  });

  const ctrlAsset = path.join(saveDataPaths.platformAssetsRoot, "ctrl_mo_v5.swf");
  const publicCtrl = path.join(saveDataPaths.runtimePublicRoot, "ctrl_mo_v5.swf");
  await ensureRemoteAsset(ctrlAsset, REMOTE_SWF_ASSETS.ctrl);
  patchRuffleEventSwf(ctrlAsset, publicCtrl);
}

async function serveStatic(res: ServerResponse, root: string, requestPath: string): Promise<boolean> {
  const filePath = safeJoin(root, requestPath);
  if (!filePath || !existsSync(filePath) || !statSync(filePath).isFile()) {
    return false;
  }

  res.writeHead(200, {
    "content-type": getContentType(filePath),
    "access-control-allow-origin": "*",
  });
  createReadStream(filePath).pipe(res);
  return true;
}

function localCtrlXml(baseUrl: string): string {
  return [
    '<?xml version="1.0" encoding="utf-8"?>',
    "<resInfos>",
    `  <info resName="zwsf">${baseUrl}/assets/empty.gif</info>`,
    `  <info resName="ctrl_v5">${baseUrl}/ctrl_mo_v5.swf</info>`,
    `  <info resName="ads">${baseUrl}/assets/A4399dv_base.swf</info>`,
    "</resInfos>",
  ].join("\n");
}

export async function startSaveDataServer(options: ServerOptions = {}) {
  await ensureRuntimeAssets();

  const host = options.host ?? "127.0.0.1";
  const port = options.port ?? Number(process.env.SAVE_DATA_PORT ?? 8787);
  const db = new LocalSaveDatabase(options.dbFile ?? process.env.SAVE_DATA_DB ?? saveDataPaths.defaultDbFile);
  const logger = new SaveDataLogger();
  const api = new SaveDataMockApi(db, undefined, logger);

  const server = createServer(async (req, res) => {
    try {
      if (!req.url) {
        sendNotFound(res);
        return;
      }
      if (req.method === "OPTIONS") {
        send(res, 204, "text/plain", "");
        return;
      }

      const url = new URL(req.url, `http://${req.headers.host ?? `${host}:${port}`}`);
      const body = req.method === "POST" ? await readRequestBody(req) : "";
      const address = server.address() as AddressInfo | null;
      const actualPort = address?.port ?? port;
      const baseUrl = `http://${host}:${actualPort}`;

      if (url.pathname === "/" || url.pathname === "/index.html") {
        const html = await readFile(path.join(saveDataPaths.publicRoot, "index.html"));
        send(res, 200, "text/html; charset=utf-8", html);
        return;
      }

      if (url.pathname === "/flash_ctrl_version.xml") {
        send(res, 200, "application/xml; charset=utf-8", localCtrlXml(baseUrl));
        return;
      }

      if (url.pathname === "/flash_ad_version.xml") {
        send(
          res,
          200,
          "application/xml; charset=utf-8",
          `<?xml version="1.0" encoding="utf-8"?><info>${baseUrl}/assets/A4399dv_base_main.swf</info>`
        );
        return;
      }

      if (url.pathname === "/crossdomain.xml") {
        send(
          res,
          200,
          "application/xml; charset=utf-8",
          '<?xml version="1.0"?><cross-domain-policy><allow-access-from domain="*" secure="false" /></cross-domain-policy>'
        );
        return;
      }

      if (url.pathname === "/assets/empty.gif") {
        send(res, 200, "image/gif", EMPTY_GIF);
        return;
      }

      const loginResponse = api.handleUniLogin(url.pathname);
      if (loginResponse) {
        send(res, loginResponse.status, loginResponse.contentType, loginResponse.body);
        return;
      }

      const debugResponse = api.handleDebugApi(url);
      if (debugResponse) {
        send(res, debugResponse.status, debugResponse.contentType, debugResponse.body);
        return;
      }

      if (url.pathname === "/api/saveData/logs") {
        const limit = Number(url.searchParams.get("limit") ?? "200");
        send(res, 200, "application/json; charset=utf-8", JSON.stringify(logger.list(Number.isFinite(limit) ? limit : 200)));
        return;
      }

      if (url.pathname === "/api/saveData/logs/clear") {
        logger.clear();
        send(res, 200, "application/json; charset=utf-8", JSON.stringify({ ok: true }));
        return;
      }

      if (url.pathname.startsWith("/api/stat")) {
        send(res, 200, "text/plain; charset=utf-8", "1");
        return;
      }

      if (url.pathname === "/api/media/cover/entries") {
        send(res, 200, "application/json; charset=utf-8", JSON.stringify({ code: 0, data: [] }));
        return;
      }

      if (url.pathname === "/api/4399-task/game-play") {
        logger.appendSync({
          event: "platform.game_play",
          method: req.method ?? "GET",
          pathname: url.pathname,
          uid: api.account.uid,
          gameid: "100025235",
          status: 200,
          result: "ok",
        });
        send(res, 200, "application/json; charset=utf-8", JSON.stringify({ code: 0, result: {} }));
        return;
      }

      if (url.pathname.startsWith("/api/4399/union/")) {
        logger.appendSync({
          event: "platform.union",
          method: req.method ?? "GET",
          pathname: url.pathname,
          uid: api.account.uid,
          gameid: "100025235",
          status: 200,
          result: "empty",
        });
        send(res, 200, "application/octet-stream", "");
        return;
      }

      if (url.pathname.startsWith("/api/4399")) {
        const forwarded = new URL(url.toString());
        forwarded.pathname = url.pathname.replace(/^\/api\/4399/, "") || "/";
        const response = api.handleSaveApi(forwarded, req.method ?? "GET", body);
        if (response) {
          send(res, response.status, response.contentType, response.body);
          return;
        }
      }

      if (url.hostname === "save.api.4399.com") {
        const response = api.handleSaveApi(url, req.method ?? "GET", body);
        if (response) {
          send(res, response.status, response.contentType, response.body);
          return;
        }
      }

      if (await serveStatic(res, saveDataPaths.publicRoot, url.pathname)) {
        return;
      }

      if (await serveStatic(res, saveDataPaths.runtimePublicRoot, url.pathname)) {
        return;
      }

      if (req.method === "GET" && SWF_FILE_RE.test(path.basename(url.pathname))) {
        const assetFile = await ensureGameAsset(path.basename(url.pathname), logger);
        if (assetFile && (await serveStatic(res, path.dirname(assetFile), `/${path.basename(assetFile)}`))) {
          return;
        }
      }

      sendNotFound(res);
    } catch (error) {
      send(res, 500, "text/plain; charset=utf-8", error instanceof Error ? error.stack ?? error.message : String(error));
    }
  });

  await new Promise<void>((resolve) => server.listen(port, host, resolve));

  const address = server.address() as AddressInfo;
  const actualPort = address.port;

  return {
    host,
    port: actualPort,
    url: `http://${host}:${actualPort}`,
    db,
    server,
    close: async () => {
      await new Promise<void>((resolve, reject) => {
        server.close((error) => (error ? reject(error) : resolve()));
      });
      db.close();
    },
  };
}

if (process.argv[1] && path.resolve(fileURLToPath(import.meta.url)) === path.resolve(process.argv[1])) {
  startSaveDataServer()
    .then(({ url }) => {
      console.log(`saveData mock server: ${url}`);
      console.log(`database: ${process.env.SAVE_DATA_DB ?? saveDataPaths.defaultDbFile}`);
    })
    .catch((error) => {
      console.error(error);
      process.exitCode = 1;
    });
}
