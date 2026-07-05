const fs = require("fs");
const http = require("http");
const os = require("os");
const path = require("path");
const zlib = require("zlib");
const { spawn, spawnSync } = require("child_process");

const projectRoot = path.resolve(__dirname, "..");
const defaultDebugPort = 9334;
const defaultHost = "127.0.0.1";
const defaultPort = 8787;
const cefBuildName = "cef_binary_75.1.14+gc81164e+chromium-75.0.3770.100_windows64_client";
const cefDownloadUrl = "https://cef-builds.spotifycdn.com/cef_binary_75.1.14%2Bgc81164e%2Bchromium-75.0.3770.100_windows64_client.tar.bz2";
const cefCacheDir = path.join(projectRoot, "workspace", "native-cef75");
const cefArchive = path.join(cefCacheDir, "cef_binary_75.1.14_windows64_client.tar.bz2");
const preparedCefClient = path.join(cefCacheDir, cefBuildName, "Release", "cefclient.exe");
const nativeHostExeName = "flash-native-host.exe";
const preparedNativeHost = path.join(projectRoot, "workspace", "native-host", "Release", nativeHostExeName);
const bundledPepperFlash = path.join(cefCacheDir, "pepflashplayer64.dll");
const legacyBundledPepperFlash = path.join(projectRoot, "workspace", "native-cef", "pepflashplayer64.dll");
const vendoredPepperFlash = path.join(projectRoot, "vendor", "native-flash", "pepflashplayer64.dll");
const defaultPepperFlashVersion = "99.9.9.999";
const sourceOuterSwf = path.join(projectRoot, "downloads", "swf", "xfbbv451.swf");
const legacySavesFileName = path.join("data", "runtime-mock-saves.json");
const desktopAppDataRoot = process.env.APPDATA || path.join(os.homedir(), "AppData", "Roaming");
const legacyDesktopDbFile = path.join(desktopAppDataRoot, "flash-source-map", "saveData", "local-save.db");
const projectLegacySavesFileCandidates = [path.join(projectRoot, legacySavesFileName)];
const referenceLegacySavesFileCandidates = [
  path.join(path.dirname(projectRoot), "flash-4399-115225-dev", legacySavesFileName),
  path.join(os.homedir(), "flash-4399-115225-dev", legacySavesFileName),
  path.join(os.homedir(), "Desktop", "flash-4399-115225-dev", legacySavesFileName),
];
const nativePatchedSwfUrlPath = "/swf/xfbbv451-native.swf";
const nativeProxyHttpsPrefix = "http://127.000.000.001:80";
const nativeProxyHttpPrefix = "http://127.000.000.01:80";
const nativePlatformAssets = [
  ["ctrl_mo_v5.swf", "ctrl_mo_v5-native.swf"],
  [path.join("assets", "A4399dv_base.swf"), path.join("assets", "A4399dv_base-native.swf")],
  [path.join("assets", "A4399dv_base_main.swf"), path.join("assets", "A4399dv_base_main-native.swf")],
  [path.join("assets", "open4399tools_AS3.swf"), path.join("assets", "open4399tools_AS3-native.swf")],
];
const defaultBorrowedBundleDir = path.join(
  os.homedir(),
  "Desktop",
  "[64\u4f4d]My\u5965\u5947\uff08\u70b9\u5f00\u6309\u89e3\u538b\u5373\u7528\uff09"
);
const defaultReferenceHostNames = [
  "My\u5965\u5947\u4f20\u8bf4Pro 3.2.8.exe",
  "My642.5.2.exe",
  "My642.3.3.exe",
];
const defaultPolicyProxyHost = "127.0.0.1";
const defaultPolicyProxyPort = 80;
const defaultPolicyProxyDomains = [
  "stat.api.4399.com",
  "cdn.comment.4399pk.com",
];
const crossDomainPolicy = '<?xml version="1.0"?><cross-domain-policy><allow-access-from domain="*" secure="false" /></cross-domain-policy>';
const nativeSwfUrlReplacements = [
  ["http://stat.api.4399.com/flash_ctrl_version.xml", `${nativeProxyHttpsPrefix}/fc.xml`],
  ["http://cdn.comment.4399pk.com/control/zwsf2-3.gif", `${nativeProxyHttpsPrefix}/eg.gif`],
  ["http://cdn.comment.4399pk.com/control/ctrl_mo_v5.swf?200", `${nativeProxyHttpsPrefix}/ctrl.swf`],
  ["http://cdn.comment.4399pk.com/control/A4399dv_base.swf?200", `${nativeProxyHttpsPrefix}/ad.swf`],
];
const nativePlatformPrefixReplacements = [
  ["https://stat.api.4399.com", nativeProxyHttpsPrefix],
  ["http://stat.api.4399.com", nativeProxyHttpPrefix],
  ["https://save.api.4399.com", nativeProxyHttpsPrefix],
  ["http://save.api.4399.com", nativeProxyHttpPrefix],
  ["https://media.5054399.net", nativeProxyHttpsPrefix],
  ["https://my.4399.com/services/game-play", "http://127.1/services/game-play?xxxxxx"],
];

function saveDataWorkspaceRoot() {
  return process.env.SAVE_DATA_WORKSPACE_ROOT
    ? path.resolve(process.env.SAVE_DATA_WORKSPACE_ROOT)
    : path.join(projectRoot, "workspace", "saveData");
}

function nativePatchedSwfPath() {
  return path.join(saveDataWorkspaceRoot(), "public", "swf", "xfbbv451-native.swf");
}

function runtimePatchedOuterSwfPath() {
  return path.join(saveDataWorkspaceRoot(), "public", "swf", "xfbbv451.swf");
}

function envPath(name) {
  const value = process.env[name];
  return value && value.trim() ? value.trim() : null;
}

function existingFile(filePath) {
  if (!filePath) {
    return null;
  }
  const resolved = path.resolve(filePath);
  return fs.existsSync(resolved) && fs.statSync(resolved).isFile() ? resolved : null;
}

function firstExistingFile(candidates) {
  for (const candidate of candidates) {
    const found = existingFile(candidate);
    if (found) {
      return found;
    }
  }
  return null;
}

function configuredLegacySavesFile(env = process.env) {
  const explicit = env.SAVE_DATA_LEGACY_SAVES_FILE || env.SAVE_DATA_LEGACY_SAVES;
  if (explicit && explicit.trim()) {
    return path.resolve(explicit.trim());
  }
  if (env.SAVE_DATA_DB && env.SAVE_DATA_DB.trim()) {
    return null;
  }
  const candidates = [...projectLegacySavesFileCandidates];
  if (env.NATIVE_FLASH_ALLOW_REFERENCE_SAVES === "1") {
    candidates.push(...referenceLegacySavesFileCandidates);
  }
  return firstExistingFile(candidates);
}

function configuredDbFile(env = process.env) {
  const explicit = env.SAVE_DATA_DB;
  if (explicit && explicit.trim()) {
    return path.resolve(explicit.trim());
  }
  return existingFile(legacyDesktopDbFile);
}

function configureDbEnv(env = process.env) {
  const dbFile = configuredDbFile(env);
  if (dbFile && !(env.SAVE_DATA_DB && env.SAVE_DATA_DB.trim())) {
    env.SAVE_DATA_DB = dbFile;
  }
  return dbFile;
}

function configureLegacySavesEnv(env = process.env) {
  const legacySavesFile = configuredLegacySavesFile(env);
  if (
    legacySavesFile &&
    !env.SAVE_DATA_LEGACY_SAVES_FILE &&
    !env.SAVE_DATA_LEGACY_SAVES &&
    !(env.SAVE_DATA_DB && env.SAVE_DATA_DB.trim())
  ) {
    env.SAVE_DATA_LEGACY_SAVES_FILE = legacySavesFile;
  }
  return legacySavesFile;
}

function run(command, args, options = {}) {
  return new Promise((resolve, reject) => {
    const child = spawn(command, args, {
      stdio: "inherit",
      windowsHide: true,
      ...options,
    });
    child.on("error", reject);
    child.on("exit", (code, signal) => {
      if (code === 0) {
        resolve();
        return;
      }
      reject(new Error(`${command} exited with code=${code ?? "null"} signal=${signal ?? "null"}`));
    });
  });
}

async function ensureCefClient() {
  if (existingFile(preparedCefClient)) {
    return preparedCefClient;
  }
  if (process.env.NATIVE_FLASH_AUTO_DOWNLOAD_CEF === "0") {
    return null;
  }

  fs.mkdirSync(cefCacheDir, { recursive: true });
  if (!existingFile(cefArchive)) {
    console.log(`[native-flash] Downloading CEF 75 client: ${cefDownloadUrl}`);
    await run("curl.exe", ["-L", cefDownloadUrl, "-o", cefArchive]);
  }

  if (!existingFile(preparedCefClient)) {
    console.log("[native-flash] Extracting CEF 75 client...");
    await run("tar.exe", ["-xf", cefArchive, "-C", cefCacheDir]);
  }

  return existingFile(preparedCefClient);
}

function ensurePepperFlash() {
  const explicit = existingFile(envPath("NATIVE_FLASH_PEPPER_PATH"));
  if (explicit) {
    return explicit;
  }

  const bundled = existingFile(bundledPepperFlash);
  if (bundled) {
    return bundled;
  }

  const vendored = existingFile(vendoredPepperFlash);
  if (vendored) {
    return vendored;
  }

  const legacyBundled = existingFile(legacyBundledPepperFlash);
  if (legacyBundled) {
    fs.mkdirSync(cefCacheDir, { recursive: true });
    fs.copyFileSync(legacyBundled, bundledPepperFlash);
    console.log(`[native-flash] Copied Pepper Flash into local CEF 75 bundle: ${bundledPepperFlash}`);
    return bundledPepperFlash;
  }

  const canBorrow =
    process.env.NATIVE_FLASH_ALLOW_REFERENCE === "1" ||
    process.env.NATIVE_FLASH_PREFER_REFERENCE === "1" ||
    envPath("NATIVE_FLASH_BUNDLE_DIR") != null;
  if (!canBorrow) {
    return null;
  }

  const bundleDir = envPath("NATIVE_FLASH_BUNDLE_DIR")
    ? path.resolve(envPath("NATIVE_FLASH_BUNDLE_DIR"))
    : defaultBorrowedBundleDir;
  const borrowed = existingFile(path.join(bundleDir, "pepflashplayer64.dll"));
  if (!borrowed) {
    return null;
  }

  fs.mkdirSync(cefCacheDir, { recursive: true });
  fs.copyFileSync(borrowed, bundledPepperFlash);
  console.log(`[native-flash] Copied Pepper Flash into local bundle: ${bundledPepperFlash}`);
  return bundledPepperFlash;
}

function referenceHostCandidates() {
  const explicitReference = envPath("NATIVE_FLASH_REFERENCE_PATH");
  const allowBundledReference =
    process.env.NATIVE_FLASH_ALLOW_REFERENCE === "1" ||
    process.env.NATIVE_FLASH_PREFER_REFERENCE === "1" ||
    envPath("NATIVE_FLASH_BUNDLE_DIR") != null;

  if (process.env.NATIVE_FLASH_DISABLE_REFERENCE === "1") {
    return [];
  }
  if (!allowBundledReference) {
    return [explicitReference];
  }

  const bundleDir = envPath("NATIVE_FLASH_BUNDLE_DIR")
    ? path.resolve(envPath("NATIVE_FLASH_BUNDLE_DIR"))
    : defaultBorrowedBundleDir;
  return [
    explicitReference,
    ...defaultReferenceHostNames.map((name) => path.join(bundleDir, name)),
  ];
}

function explicitBrowserCandidates() {
  return [
    envPath("NATIVE_FLASH_BROWSER_PATH"),
    envPath("CEF_FLASH_BROWSER_PATH"),
  ];
}

function nativeHostCandidates() {
  return [
    envPath("NATIVE_FLASH_HOST_PATH"),
    preparedNativeHost,
  ];
}

function fallbackBrowserCandidates(preferredCefClient) {
  const env = process.env;
  return [
    preferredCefClient,
    envPath("BROWSER_360X_PATH"),
    path.join(env.LOCALAPPDATA || "", "360ChromeX", "Chrome", "Application", "360ChromeX.exe"),
    path.join(env.ProgramFiles || "", "360ChromeX", "Chrome", "Application", "360ChromeX.exe"),
    path.join(env["ProgramFiles(x86)"] || "", "360ChromeX", "Chrome", "Application", "360ChromeX.exe"),
    path.join(env.ProgramFiles || "", "360", "360ChromeX", "Chrome", "Application", "360ChromeX.exe"),
    path.join(env["ProgramFiles(x86)"] || "", "360", "360ChromeX", "Chrome", "Application", "360ChromeX.exe"),
  ];
}

async function findBrowser() {
  const explicit = firstExistingFile(explicitBrowserCandidates());
  if (explicit) {
    return explicit;
  }

  if (process.env.NATIVE_FLASH_PREFER_REFERENCE === "1") {
    const referenceHost = firstExistingFile(referenceHostCandidates());
    if (referenceHost) {
      return referenceHost;
    }
  }

  const nativeHost = firstExistingFile(nativeHostCandidates());
  if (nativeHost) {
    return nativeHost;
  }

  const preferredCefClient = await ensureCefClient();
  const browser = firstExistingFile(fallbackBrowserCandidates(preferredCefClient));
  if (browser) {
    return browser;
  }

  const referenceHost = firstExistingFile(referenceHostCandidates());
  if (referenceHost) {
    return referenceHost;
  }

  throw new Error(
    [
      "Native Flash browser was not found.",
      "Run npm run native-flash:build-host to build the local CEF host,",
      "or set NATIVE_FLASH_HOST_PATH / NATIVE_FLASH_BROWSER_PATH / CEF_FLASH_BROWSER_PATH.",
      "Set NATIVE_FLASH_ALLOW_REFERENCE=1 only if you want to use the old reference bundle.",
    ].join(" ")
  );
}

function samePath(left, right) {
  return path.resolve(left).toLowerCase() === path.resolve(right).toLowerCase();
}

function isReferenceHost(browserPath) {
  const override = process.env.NATIVE_FLASH_CDP_NAVIGATE;
  if (override === "1") {
    return true;
  }
  if (override === "0") {
    return false;
  }
  return referenceHostCandidates()
    .filter(Boolean)
    .some((candidate) => fs.existsSync(candidate) && samePath(candidate, browserPath));
}

function isNativeHost(browserPath) {
  return path.basename(browserPath).toLowerCase() === nativeHostExeName;
}

function defaultUserDataDirForBrowser(browserPath) {
  const lower = String(browserPath || "").toLowerCase();
  if (isNativeHost(browserPath)) {
    return path.join(projectRoot, "workspace", "native-flash-profile-host");
  }
  if (lower.includes("cef_binary_75")) {
    return path.join(projectRoot, "workspace", "native-flash-profile-cef75");
  }
  return path.join(projectRoot, "workspace", "native-flash-profile");
}

function clearNativeFlashCache(userDataDir) {
  const cacheDirs = [
    "Cache",
    "Code Cache",
    "GPUCache",
    path.join("Default", "Cache"),
    path.join("Default", "Code Cache"),
    path.join("Default", "GPUCache"),
    path.join("Default", "Service Worker", "CacheStorage"),
  ];
  const root = path.resolve(userDataDir);
  for (const relativeDir of cacheDirs) {
    const target = path.resolve(root, relativeDir);
    if (!target.startsWith(root + path.sep) || !fs.existsSync(target)) {
      continue;
    }
    fs.rmSync(target, { recursive: true, force: true });
  }
}

function splitEnvList(value) {
  return value
    .split(/[,\s]+/)
    .map((item) => item.trim())
    .filter(Boolean);
}

function policyProxyDomains() {
  const configured = process.env.NATIVE_FLASH_POLICY_DOMAINS;
  if (configured && configured.trim()) {
    return splitEnvList(configured);
  }
  return defaultPolicyProxyDomains;
}

function hostResolverRules(domains) {
  return domains.map((domain) => `MAP ${domain} 127.0.0.1`).join(",");
}

function policyProxyEnabled() {
  return process.env.NATIVE_FLASH_DISABLE_POLICY_PROXY !== "1";
}

function findPepperFlash(browserPath) {
  const explicit = existingFile(envPath("NATIVE_FLASH_PEPPER_PATH"));
  if (explicit) {
    return explicit;
  }

  const sibling = existingFile(path.join(path.dirname(browserPath), "pepflashplayer64.dll"));
  if (sibling) {
    return sibling;
  }

  return ensurePepperFlash();
}

function fitReplacementUrl(serverUrl, localPath, targetLength) {
  const replacement = /^https?:\/\//i.test(localPath) ? localPath : new URL(localPath, serverUrl).toString();
  if (replacement.length > targetLength) {
    throw new Error(`Native SWF replacement URL is too long: ${replacement} (${replacement.length} > ${targetLength})`);
  }
  if (replacement.length === targetLength) {
    return replacement;
  }
  const paddingLength = targetLength - replacement.length;
  return `${replacement}?${"x".repeat(paddingLength - 1)}`;
}

function replaceBufferAll(buffer, fromText, toText) {
  const from = Buffer.from(fromText, "ascii");
  const to = Buffer.from(toText, "ascii");
  if (from.length !== to.length) {
    throw new Error(`Replacement length mismatch for ${fromText}: ${from.length} !== ${to.length}`);
  }

  let offset = 0;
  let count = 0;
  while (offset <= buffer.length - from.length) {
    const found = buffer.indexOf(from, offset);
    if (found === -1) {
      break;
    }
    to.copy(buffer, found);
    offset = found + to.length;
    count += 1;
  }
  return count;
}

function decompressSwf(buffer) {
  const signature = buffer.subarray(0, 3).toString("ascii");
  if (signature === "FWS") {
    return { signature, header: buffer.subarray(0, 8), body: Buffer.from(buffer.subarray(8)) };
  }
  if (signature === "CWS") {
    return { signature, header: buffer.subarray(0, 8), body: zlib.inflateSync(buffer.subarray(8)) };
  }
  throw new Error(`Unsupported SWF signature: ${signature}`);
}

function compressSwf({ signature, header, body }) {
  if (signature === "FWS") {
    return Buffer.concat([header, body]);
  }
  return Buffer.concat([header, zlib.deflateSync(body, { level: 9 })]);
}

function ensureNativePatchedSwf(serverUrl) {
  if (process.env.NATIVE_FLASH_PATCH_SWF === "0") {
    return null;
  }
  const source = firstExistingFile([runtimePatchedOuterSwfPath(), sourceOuterSwf]);
  if (!source) {
    throw new Error(`Source SWF not found: ${runtimePatchedOuterSwfPath()} or ${sourceOuterSwf}`);
  }

  const swf = decompressSwf(fs.readFileSync(source));
  const body = Buffer.from(swf.body);
  const replacementCounts = {};
  for (const [remoteUrl, localPath] of nativeSwfUrlReplacements) {
    const replacement = fitReplacementUrl(serverUrl, localPath, remoteUrl.length);
    const count = replaceBufferAll(body, remoteUrl, replacement);
    replacementCounts[remoteUrl] = count;
    if (count === 0) {
      throw new Error(`Native SWF patch did not find URL: ${remoteUrl}`);
    }
  }

  const outputFile = nativePatchedSwfPath();
  fs.mkdirSync(path.dirname(outputFile), { recursive: true });
  fs.writeFileSync(outputFile, compressSwf({ ...swf, body }));
  console.log(`[native-flash] Wrote native patched SWF: ${outputFile}`);
  console.log(`[native-flash] SWF URL replacements: ${JSON.stringify(replacementCounts)}`);
  const stat = fs.statSync(outputFile);
  return `${nativePatchedSwfUrlPath}?v=${Math.round(stat.mtimeMs)}-${stat.size}`;
}

function patchSwfFile(sourceFile, targetFile, replacements, options = {}) {
  const source = existingFile(sourceFile);
  if (!source) {
    if (options.required) {
      throw new Error(`SWF patch source not found: ${sourceFile}`);
    }
    return null;
  }

  const swf = decompressSwf(fs.readFileSync(source));
  const body = Buffer.from(swf.body);
  const replacementCounts = {};
  for (const [fromText, toText] of replacements) {
    if (fromText.length !== toText.length) {
      throw new Error(`Replacement length mismatch: ${fromText} (${fromText.length}) -> ${toText} (${toText.length})`);
    }
    const count = replaceBufferAll(body, fromText, toText);
    replacementCounts[fromText] = count;
  }

  fs.mkdirSync(path.dirname(targetFile), { recursive: true });
  fs.writeFileSync(targetFile, compressSwf({ ...swf, body }));
  return replacementCounts;
}

function ensureNativePatchedPlatformSwfs() {
  if (process.env.NATIVE_FLASH_PATCH_SWF === "0") {
    return;
  }

  const publicRoot = path.join(saveDataWorkspaceRoot(), "public");
  const summary = {};
  for (const [sourceRelative, targetRelative] of nativePlatformAssets) {
    const sourceFile = path.join(publicRoot, sourceRelative);
    const targetFile = path.join(publicRoot, targetRelative);
    const counts = patchSwfFile(sourceFile, targetFile, nativePlatformPrefixReplacements);
    if (counts) {
      summary[targetRelative.replaceAll("\\", "/")] = counts;
    }
  }
  if (Object.keys(summary).length > 0) {
    console.log(`[native-flash] Wrote native platform SWFs: ${Object.keys(summary).join(", ")}`);
  }
}

function httpRequest(url, options = {}) {
  return new Promise((resolve, reject) => {
    const body = options.body ? Buffer.from(options.body) : null;
    const req = http.request(url, {
      method: options.method || "GET",
      headers: {
        ...(options.headers || {}),
        ...(body ? { "content-length": body.length } : {}),
      },
      timeout: options.timeout || 5000,
    }, (res) => {
      const chunks = [];
      res.on("data", (chunk) => chunks.push(Buffer.from(chunk)));
      res.on("end", () => {
        resolve({
          statusCode: res.statusCode || 0,
          headers: res.headers,
          body: Buffer.concat(chunks),
        });
      });
    });
    req.on("timeout", () => req.destroy(new Error(`Timed out requesting ${url}`)));
    req.on("error", reject);
    if (body) {
      req.write(body);
    }
    req.end();
  });
}

async function waitForHttp(url, timeoutMs = 20000) {
  const startedAt = Date.now();
  let lastError = null;
  while (Date.now() - startedAt < timeoutMs) {
    try {
      const response = await httpRequest(url, { timeout: 1500 });
      if (response.statusCode >= 200 && response.statusCode < 500) {
        return response;
      }
    } catch (error) {
      lastError = error;
    }
    await new Promise((resolve) => setTimeout(resolve, 500));
  }
  throw lastError || new Error(`Timed out waiting for ${url}`);
}

function getJson(port, pathname) {
  return new Promise((resolve, reject) => {
    const req = http.get({
      hostname: "127.0.0.1",
      port,
      path: pathname,
      timeout: 3000,
    }, (res) => {
      let body = "";
      res.setEncoding("utf8");
      res.on("data", (chunk) => {
        body += chunk;
      });
      res.on("end", () => {
        if (res.statusCode < 200 || res.statusCode >= 300) {
          reject(new Error(`HTTP ${res.statusCode}: ${body.slice(0, 200)}`));
          return;
        }
        resolve(JSON.parse(body));
      });
    });
    req.on("timeout", () => req.destroy(new Error(`Timed out connecting to CDP port ${port}`)));
    req.on("error", reject);
  });
}

async function waitForJson(port, pathname, timeoutMs = 20000) {
  const startedAt = Date.now();
  let lastError = null;
  while (Date.now() - startedAt < timeoutMs) {
    try {
      return await getJson(port, pathname);
    } catch (error) {
      lastError = error;
      await new Promise((resolve) => setTimeout(resolve, 500));
    }
  }
  throw lastError || new Error(`Timed out waiting for CDP ${pathname}`);
}

class CdpClient {
  constructor(url) {
    this.url = url;
    this.nextId = 1;
    this.pending = new Map();
    this.handlers = new Map();
    this.socket = null;
  }

  connect() {
    return new Promise((resolve, reject) => {
      const socket = new WebSocket(this.url);
      this.socket = socket;
      socket.addEventListener("open", () => resolve());
      socket.addEventListener("error", (event) => reject(event.error || new Error("CDP WebSocket error")));
      socket.addEventListener("message", (event) => this.handleMessage(event.data));
      socket.addEventListener("close", () => {
        for (const { reject: rejectPending } of this.pending.values()) {
          rejectPending(new Error("CDP WebSocket closed"));
        }
        this.pending.clear();
      });
    });
  }

  handleMessage(data) {
    const message = JSON.parse(data);
    if (message.id && this.pending.has(message.id)) {
      const pending = this.pending.get(message.id);
      this.pending.delete(message.id);
      if (message.error) {
        pending.reject(new Error(message.error.message || JSON.stringify(message.error)));
      } else {
        pending.resolve(message.result);
      }
      return;
    }
    if (message.method && this.handlers.has(message.method)) {
      for (const handler of this.handlers.get(message.method)) {
        handler(message.params || {});
      }
    }
  }

  send(method, params = {}) {
    const id = this.nextId++;
    this.socket.send(JSON.stringify({ id, method, params }));
    return new Promise((resolve, reject) => this.pending.set(id, { resolve, reject }));
  }

  on(method, handler) {
    if (!this.handlers.has(method)) {
      this.handlers.set(method, []);
    }
    this.handlers.get(method).push(handler);
  }
}

async function findPageTarget(port) {
  const targets = await waitForJson(port, "/json/list");
  const page = targets.find((item) => item.type === "page" && item.webSocketDebuggerUrl && item.url.includes("/native.html"))
    || targets.find((item) => item.type === "page" && item.webSocketDebuggerUrl && item.url === "about:blank")
    || targets.find((item) => item.type === "page" && item.webSocketDebuggerUrl);
  if (!page) {
    throw new Error(`No debuggable page target found on port ${port}`);
  }
  return page;
}

function withSearchParam(rawUrl, name, value) {
  const url = new URL(rawUrl);
  url.searchParams.set(name, value);
  return url.toString();
}

function chromeTimestampNow() {
  return String((BigInt(Date.now()) + 11644473600000n) * 1000n);
}

function readJsonObject(filePath) {
  if (!fs.existsSync(filePath)) {
    return {};
  }
  try {
    const parsed = JSON.parse(fs.readFileSync(filePath, "utf8"));
    return parsed && typeof parsed === "object" && !Array.isArray(parsed) ? parsed : {};
  } catch {
    return {};
  }
}

function ensureObject(parent, key) {
  if (!parent[key] || typeof parent[key] !== "object" || Array.isArray(parent[key])) {
    parent[key] = {};
  }
  return parent[key];
}

function writeFlashPreferences(preferencesFile, launchUrl) {
  const prefs = readJsonObject(preferencesFile);
  const launchOrigin = new URL(launchUrl).origin;
  const allowedPatterns = [
    `${launchOrigin},*`,
    "http://127.0.0.1:*,*",
    "http://localhost:*,*",
  ];
  const allowedUrls = [
    launchOrigin,
    `${launchOrigin}/*`,
    "http://127.0.0.1:*/*",
    "http://localhost:*/*",
  ];
  const lastModified = chromeTimestampNow();

  const profile = ensureObject(prefs, "profile");
  const defaultSettings = ensureObject(profile, "default_content_setting_values");
  defaultSettings.plugins = 1;
  const managedDefaultSettings = ensureObject(profile, "managed_default_content_settings");
  managedDefaultSettings.plugins = 1;
  profile.managed_plugins_allowed_for_urls = allowedUrls;
  profile.managed_plugins_blocked_for_urls = [];

  const contentSettings = ensureObject(profile, "content_settings");
  const exceptions = ensureObject(contentSettings, "exceptions");
  const pluginExceptions = ensureObject(exceptions, "plugins");
  const ppapiBrokerExceptions = ensureObject(exceptions, "ppapi_broker");
  for (const allowedPattern of allowedPatterns) {
    pluginExceptions[allowedPattern] = {
      last_modified: lastModified,
      setting: 1,
    };
    ppapiBrokerExceptions[allowedPattern] = {
      last_modified: lastModified,
      setting: 1,
    };
  }

  const plugins = ensureObject(prefs, "plugins");
  plugins.npapi_flash_migrated_to_pepper_flash = true;
  plugins.run_all_flash_in_allow_mode = true;
  plugins.allow_outdated = true;
  plugins.always_authorize = true;

  const webkit = ensureObject(prefs, "webkit");
  const webprefs = ensureObject(webkit, "webprefs");
  webprefs.plugins_enabled = true;

  fs.mkdirSync(path.dirname(preferencesFile), { recursive: true });
  fs.writeFileSync(preferencesFile, JSON.stringify(prefs, null, 2));
}

function allowFlashForProfile(userDataDir, launchUrl) {
  const profileDir = path.join(userDataDir, "Default");
  const launchOrigin = new URL(launchUrl).origin;
  writeFlashPreferences(path.join(profileDir, "Preferences"), launchUrl);
  writeFlashPreferences(path.join(userDataDir, "Preferences"), launchUrl);
  fs.mkdirSync(profileDir, { recursive: true });
  console.log(`[native-flash] Flash plugin allowed for ${launchOrigin}`);
}

function regAdd(key, name, type, value) {
  const result = spawnSync("reg.exe", ["add", key, "/v", name, "/t", type, "/d", String(value), "/f"], {
    stdio: "pipe",
    windowsHide: true,
  });
  if (result.status !== 0) {
    const stderr = result.stderr?.toString("utf8").trim();
    const stdout = result.stdout?.toString("utf8").trim();
    throw new Error(`reg.exe failed for ${key}\\${name}: ${stderr || stdout || `exit ${result.status}`}`);
  }
}

function allowFlashWithChromiumPolicy(launchUrl) {
  if (
    process.platform !== "win32"
    || process.env.NATIVE_FLASH_SKIP_POLICY === "1"
    || process.env.NATIVE_FLASH_ENABLE_POLICY !== "1"
  ) {
    return;
  }

  const launchOrigin = new URL(launchUrl).origin;
  const policyRoot = "HKCU\\Software\\Policies\\Chromium";
  const allowedUrlsRoot = `${policyRoot}\\PluginsAllowedForUrls`;

  try {
    regAdd(policyRoot, "DefaultPluginsSetting", "REG_DWORD", "1");
    regAdd(allowedUrlsRoot, "1", "REG_SZ", launchOrigin);
    regAdd(allowedUrlsRoot, "2", "REG_SZ", `${launchOrigin}/*`);
    console.log(`[native-flash] Chromium Flash policy allowed for ${launchOrigin}`);
  } catch (error) {
    console.log(`[native-flash] Chromium Flash policy was not written: ${error instanceof Error ? error.message : String(error)}`);
  }
}

function localPathForNativeFlashRequest(source) {
  const pathname = source.pathname;
  const search = source.search || "";

  if (pathname === "/crossdomain.xml") {
    return "/crossdomain.xml";
  }

  if (source.hostname === "save.api.4399.com") {
    return `/api/4399${pathname}${search}`;
  }

  if (source.hostname === "stat.api.4399.com") {
    if (pathname === "/flash_ctrl_version.xml") {
      return "/flash_ctrl_version.xml";
    }
    if (pathname === "/flash_ad_version.xml") {
      return "/flash_ad_version.xml";
    }
    if (pathname === "/flashflowstatis/submitflowstatis.php") {
      return `/api/stat/flashflowstatis/submitflowstatis.php${search}`;
    }
    if (pathname.startsWith("/flash_flow/")) {
      return `/api/stat${pathname}${search}`;
    }
    if (pathname === "/archive_status/log.js") {
      return `/api/stat/archive_status/log.js${search}`;
    }
  }

  if (source.hostname === "media.5054399.net" && pathname === "/cover/entries") {
    return `/api/media/cover/entries${search}`;
  }

  if (source.hostname === "my.4399.com" && pathname === "/services/game-play") {
    return "/api/4399-task/game-play";
  }

  if (source.hostname === "cdn.comment.4399pk.com") {
    if (pathname === "/control/ctrl_mo_v5.swf") {
      return "/ctrl_mo_v5.swf";
    }
    if (pathname === "/control/A4399dv_base.swf") {
      return "/assets/A4399dv_base.swf";
    }
    if (pathname === "/control/A4399dv_base_main.swf") {
      return "/assets/A4399dv_base_main.swf";
    }
    if (pathname === "/control/open4399tools_AS3.swf") {
      return "/assets/open4399tools_AS3.swf";
    }
    if (pathname === "/control/zwsf2-3.gif") {
      return "/assets/empty.gif";
    }
  }

  return null;
}

function localPathForNativeProxyRequest(source) {
  const pathname = source.pathname;
  const search = source.search || "";

  if (pathname === "/eg.gif") {
    return "/assets/empty.gif";
  }
  if (pathname === "/ctrl.swf") {
    return "/ctrl_mo_v5-native.swf";
  }
  if (pathname === "/ad.swf") {
    return "/assets/A4399dv_base-native.swf";
  }

  if (pathname === "/flash_ctrl_version.xml" || pathname === "/flash_ad_version.xml") {
    return `${pathname}${search}`;
  }
  if (pathname === "/flashflowstatis/submitflowstatis.php") {
    return `/api/stat/flashflowstatis/submitflowstatis.php${search}`;
  }
  if (pathname.startsWith("/flash_flow/")) {
    return `/api/stat${pathname}${search}`;
  }
  if (pathname === "/archive_status/log.js") {
    return `/api/stat/archive_status/log.js${search}`;
  }

  if (pathname === "/services/game-play") {
    return "/api/4399-task/game-play";
  }
  if (pathname === "/cover/entries") {
    return `/api/media/cover/entries${search}`;
  }

  if (
    pathname === "/"
    || pathname === "/index.php"
    || pathname.startsWith("/auth/")
    || pathname.startsWith("/exchange/")
    || pathname.startsWith("/mall/")
    || pathname.startsWith("/rank/")
    || pathname.startsWith("/score/")
    || pathname.startsWith("/recommend/")
    || pathname.startsWith("/union/")
    || pathname.startsWith("/ranging.php")
    || pathname.startsWith("/secondary.php")
  ) {
    return `/api/4399${pathname}${search}`;
  }

  return `${pathname}${search}`;
}

function startServerIfNeeded(serverUrl) {
  const distServer = path.join(projectRoot, "dist", "runtime", "save-data", "server", "server.js");
  const tsxCli = path.join(projectRoot, "node_modules", "tsx", "dist", "cli.cjs");
  const useDistServer =
    process.env.NATIVE_FLASH_USE_TSX !== "1" &&
    fs.existsSync(distServer) &&
    (process.env.NATIVE_FLASH_USE_DIST === "1" || !fs.existsSync(tsxCli));
  if (!useDistServer && !fs.existsSync(tsxCli)) {
    throw new Error(`Neither compiled server nor tsx CLI was found. Expected ${distServer} or ${tsxCli}.`);
  }
  const env = {
    ...process.env,
    SAVE_DATA_PROJECT_ROOT: process.env.SAVE_DATA_PROJECT_ROOT || projectRoot,
    SAVE_DATA_HOST: process.env.SAVE_DATA_HOST || defaultHost,
    SAVE_DATA_PORT: String(process.env.SAVE_DATA_PORT || defaultPort),
  };
  const args = useDistServer ? [distServer] : [tsxCli, path.join(projectRoot, "runtime", "save-data", "server", "server.ts")];
  const child = spawn(process.execPath, args, {
    cwd: projectRoot,
    env,
    stdio: "inherit",
    windowsHide: true,
  });
  child.on("exit", (code, signal) => {
    if (code !== 0 && code !== null) {
      console.log(`[native-flash] saveData server exited: code=${code} signal=${signal || "null"}`);
    }
  });
  return child;
}

async function ensureServer(serverUrl) {
  try {
    await waitForHttp(`${serverUrl}/native.html`, 1500);
    console.log(`[native-flash] Reusing saveData server: ${serverUrl}`);
    if (process.env.SAVE_DATA_DB) {
      console.log("[native-flash] If this server was already running, restart it to apply the save database path.");
    }
    if (process.env.SAVE_DATA_LEGACY_SAVES_FILE || process.env.SAVE_DATA_LEGACY_SAVES) {
      console.log("[native-flash] If this server was already running, restart it to apply the legacy saves file.");
    }
    return null;
  } catch {
    const child = startServerIfNeeded(serverUrl);
    await waitForHttp(`${serverUrl}/native.html`, 30000);
    console.log(`[native-flash] Started saveData server: ${serverUrl}`);
    return child;
  }
}

async function proxySaveApiRequest(serverUrl, params) {
  const source = new URL(params.request.url);
  const target = new URL(`/api/4399${source.pathname}${source.search}`, serverUrl);
  const response = await httpRequest(target, {
    method: params.request.method,
    body: params.request.postData || "",
    headers: {
      "content-type": params.request.headers["Content-Type"] || params.request.headers["content-type"] || "application/x-www-form-urlencoded",
    },
  });

  return {
    responseCode: response.statusCode,
    responseHeaders: Object.entries(response.headers)
      .filter(([, value]) => value != null)
      .map(([name, value]) => ({ name, value: Array.isArray(value) ? value.join(", ") : String(value) })),
    body: response.body.toString("base64"),
  };
}

async function fulfillFromLocalMock(serverUrl, params, localPath) {
  const target = new URL(localPath, serverUrl);
  const response = await httpRequest(target, {
    method: params.request.method,
    body: params.request.postData || "",
    headers: {
      "content-type": params.request.headers["Content-Type"] || params.request.headers["content-type"] || "application/x-www-form-urlencoded",
    },
  });

  return {
    responseCode: response.statusCode,
    responseHeaders: Object.entries(response.headers)
      .filter(([, value]) => value != null)
      .map(([name, value]) => ({ name, value: Array.isArray(value) ? value.join(", ") : String(value) })),
    body: response.body.toString("base64"),
  };
}

function shouldRefreshWalletForLocalPath(localPath, responseCode) {
  if (responseCode >= 400) {
    return false;
  }
  let parsed;
  try {
    parsed = new URL(localPath, "http://local");
  } catch {
    return false;
  }
  return parsed.pathname === "/api/4399/mall/FlashStoreApi"
    || parsed.pathname === "/api/4399/mall/index.php/Api/BuyProp"
    || parsed.pathname === "/api/4399/mall/index.php/Api/BuyPropNd";
}

async function notifyWalletChanged(client) {
  await client.send("Runtime.evaluate", {
    expression: "window.__saveDataNotifyWalletChanged && window.__saveDataNotifyWalletChanged();",
    awaitPromise: false,
  }).catch(() => undefined);
}

function readIncomingBody(req) {
  return new Promise((resolve, reject) => {
    const chunks = [];
    req.on("data", (chunk) => chunks.push(Buffer.from(chunk)));
    req.on("end", () => resolve(Buffer.concat(chunks)));
    req.on("error", reject);
  });
}

function writeProxyResponse(res, response) {
  const headers = { ...response.headers };
  delete headers["transfer-encoding"];
  res.writeHead(response.statusCode, headers);
  res.end(response.body);
}

function sendText(res, statusCode, contentType, body) {
  res.writeHead(statusCode, {
    "access-control-allow-origin": "*",
    "content-type": contentType,
    "content-length": Buffer.byteLength(body),
  });
  res.end(body);
}

function nativePublicAssetUrl(serverUrl, relativePath) {
  const normalizedPath = relativePath.replaceAll("\\", "/").replace(/^\/+/, "");
  const filePath = path.join(saveDataWorkspaceRoot(), "public", normalizedPath);
  const url = new URL(normalizedPath, `${serverUrl}/`);
  const file = existingFile(filePath);
  if (file) {
    const stat = fs.statSync(file);
    url.searchParams.set("v", `${Math.round(stat.mtimeMs)}-${stat.size}`);
  }
  return url.toString();
}

function nativeCtrlXml(serverUrl) {
  return [
    '<?xml version="1.0" encoding="utf-8"?>',
    "<resInfos>",
    `  <info resName="zwsf">${nativePublicAssetUrl(serverUrl, "assets/empty.gif")}</info>`,
    `  <info resName="ctrl_v5">${nativePublicAssetUrl(serverUrl, "ctrl_mo_v5-native.swf")}</info>`,
    `  <info resName="ads">${nativePublicAssetUrl(serverUrl, "assets/A4399dv_base-native.swf")}</info>`,
    "</resInfos>",
  ].join("\n");
}

async function proxyToMainMock(serverUrl, req, res, localPath) {
  const body = req.method === "POST" ? await readIncomingBody(req) : null;
  const response = await httpRequest(new URL(localPath, serverUrl), {
    method: req.method || "GET",
    body: body && body.length > 0 ? body : null,
    headers: {
      "content-type": req.headers["content-type"] || "application/octet-stream",
    },
    timeout: 15000,
  });
  writeProxyResponse(res, response);
}

async function startPolicyProxy(serverUrl, domains) {
  if (!policyProxyEnabled()) {
    return null;
  }

  const host = process.env.NATIVE_FLASH_POLICY_HOST || defaultPolicyProxyHost;
  const port = Number(process.env.NATIVE_FLASH_POLICY_PORT || defaultPolicyProxyPort);
  const server = http.createServer(async (req, res) => {
    try {
      const source = new URL(req.url || "/", `http://${req.headers.host || domains[0] || "localhost"}`);
      if (source.pathname === "/crossdomain.xml") {
        sendText(res, 200, "application/xml; charset=utf-8", crossDomainPolicy);
        return;
      }
      if (source.pathname === "/fc.xml" || source.pathname === "/flash_ctrl_version.xml") {
        sendText(res, 200, "application/xml; charset=utf-8", nativeCtrlXml(serverUrl));
        return;
      }
      if (source.pathname === "/fa.xml" || source.pathname === "/flash_ad_version.xml") {
        sendText(
          res,
          200,
          "application/xml; charset=utf-8",
          `<?xml version="1.0" encoding="utf-8"?><info>${nativePublicAssetUrl(serverUrl, "assets/A4399dv_base_main-native.swf")}</info>`
        );
        return;
      }

      const localPath = localPathForNativeFlashRequest(source) || localPathForNativeProxyRequest(source);
      await proxyToMainMock(serverUrl, req, res, localPath);
    } catch (error) {
      const message = error instanceof Error ? error.message : String(error);
      res.writeHead(502, { "content-type": "text/plain; charset=utf-8" });
      res.end(message);
    }
  });

  await new Promise((resolve, reject) => {
    server.once("error", reject);
    server.listen(port, host, () => {
      server.off("error", reject);
      resolve();
    });
  }).catch((error) => {
    const message = error instanceof Error ? error.message : String(error);
    throw new Error(`Native Flash policy proxy failed to listen on ${host}:${port}: ${message}`);
  });

  return {
    host,
    port,
    domains,
    server,
    close: () => new Promise((resolve) => server.close(() => resolve())),
  };
}

async function waitForRuntimePredicate(client, expression, label, timeoutMs = 20000) {
  const startedAt = Date.now();
  let lastError = null;
  while (Date.now() - startedAt < timeoutMs) {
    try {
      const result = await client.send("Runtime.evaluate", {
        expression: `(() => { try { return Boolean(${expression}); } catch { return false; } })()`,
        returnByValue: true,
      });
      if (result.result?.value === true) {
        return;
      }
    } catch (error) {
      lastError = error;
    }
    await new Promise((resolve) => setTimeout(resolve, 250));
  }
  throw lastError || new Error(`Timed out waiting for ${label}`);
}

async function readNativeFlashProbe(client) {
  const result = await client.send("Runtime.evaluate", {
    expression: `(() => ({
      href: location.href,
      readyState: document.readyState,
      flashPlugin: Array.from(navigator.plugins || []).map((plugin) => plugin.name).find((name) => /flash/i.test(name)) || null,
      objectCount: document.querySelectorAll('object[type="application/x-shockwave-flash"]').length,
      hasNativeMount: typeof window.__nativeFlashMount === "function"
    }))()`,
    returnByValue: true,
  });
  return result.result?.value || {};
}

async function main() {
  if (typeof WebSocket !== "function") {
    throw new Error("This script requires a Node.js runtime with global WebSocket support.");
  }

  const prepareOnly = process.argv.includes("--prepare");
  const host = process.env.SAVE_DATA_HOST || defaultHost;
  const port = Number(process.env.SAVE_DATA_PORT || defaultPort);
  const serverUrl = `http://${host}:${port}`;
  const debugPort = Number(process.env.NATIVE_FLASH_DEBUG_PORT || defaultDebugPort);
  const dbFile = configureDbEnv(process.env);
  const legacySavesFile = configureLegacySavesEnv(process.env);
  const browserPath = await findBrowser();
  const useCdpNavigation = isReferenceHost(browserPath);
  const useNativeFlashProxy = policyProxyEnabled();
  const policyDomains = policyProxyDomains();
  const pepperFlashPath = findPepperFlash(browserPath);
  if (prepareOnly) {
    console.log(`[native-flash] Browser: ${browserPath}`);
    if (path.basename(browserPath).toLowerCase() === "cefclient.exe") {
      console.log("[native-flash] Warning: official cefclient.exe can consume Space; run npm run native-flash:build-host for the custom host.");
    }
    console.log(`[native-flash] Host mode: ${useCdpNavigation ? "reference-cdp" : "direct-url"}`);
    console.log(`[native-flash] Pepper Flash: ${pepperFlashPath || "missing"}`);
    if (dbFile) {
      console.log(`[native-flash] Database: ${dbFile}`);
    }
    if (legacySavesFile) {
      console.log(`[native-flash] Legacy saves: ${legacySavesFile}`);
    }
    if (useNativeFlashProxy) {
      console.log(`[native-flash] Local Flash proxy: http://${process.env.NATIVE_FLASH_POLICY_HOST || defaultPolicyProxyHost}:${process.env.NATIVE_FLASH_POLICY_PORT || defaultPolicyProxyPort}`);
    }
    if (!pepperFlashPath) {
      throw new Error("Pepper Flash was not found. Set NATIVE_FLASH_PEPPER_PATH, place it under vendor/native-flash/, or set NATIVE_FLASH_BUNDLE_DIR.");
    }
    return;
  }

  const userDataDir = process.env.NATIVE_FLASH_USER_DATA_DIR
    ? path.resolve(process.env.NATIVE_FLASH_USER_DATA_DIR)
    : defaultUserDataDirForBrowser(browserPath);
  const pageUrl = process.env.NATIVE_FLASH_URL || `${serverUrl}/native.html`;
  let launchUrl = withSearchParam(pageUrl, "autostart", useCdpNavigation ? "0" : "1");
  const serverProcess = await ensureServer(serverUrl);
  const nativeSwfUrlPath = useNativeFlashProxy ? ensureNativePatchedSwf(serverUrl) : null;
  if (nativeSwfUrlPath) {
    launchUrl = withSearchParam(launchUrl, "swf", nativeSwfUrlPath);
  }
  if (useNativeFlashProxy) {
    ensureNativePatchedPlatformSwfs();
  }

  fs.mkdirSync(userDataDir, { recursive: true });
  clearNativeFlashCache(userDataDir);
  if (!useCdpNavigation) {
    allowFlashForProfile(userDataDir, launchUrl);
    allowFlashWithChromiumPolicy(launchUrl);
  }

  const isCefClient = path.basename(browserPath).toLowerCase() === "cefclient.exe";
  const isCustomNativeHost = isNativeHost(browserPath);
  const args = [`--remote-debugging-port=${debugPort}`];
  if (useCdpNavigation) {
    // The borrowed Qt/CEF host ignores --url and opens its own page first.
    // Keep its launch args minimal, then navigate the debuggable page via CDP.
    if (policyDomains.length > 0 && policyProxyEnabled() && process.env.NATIVE_FLASH_ENABLE_HOST_RESOLVER === "1") {
      args.push(`--host-resolver-rules=${hostResolverRules(policyDomains)}`);
    }
  } else {
    args.push(
      "--remote-allow-origins=*",
      `--user-data-dir=${userDataDir}`,
      `--cache-path=${userDataDir}`,
      "--persist-user-preferences",
      "--persist-session-cookies",
      "--enable-system-flash",
      "--enable-features=RunAllFlashInAllowMode",
      "--disable-features=EphemeralFlashPermission",
      "--run-all-flash-in-allow-mode",
      "--plugin-policy=allow",
      "--allow-outdated-plugins",
      "--always-authorize-plugins",
      "--disable-application-cache",
      "--disk-cache-size=1",
      "--media-cache-size=1",
      "--no-first-run",
      "--no-default-browser-check",
      "--no-sandbox",
    );
    if (pepperFlashPath) {
      args.push(`--ppapi-flash-path=${pepperFlashPath}`);
      args.push(`--ppapi-flash-version=${process.env.NATIVE_FLASH_PEPPER_VERSION || defaultPepperFlashVersion}`);
    }
    if (isCefClient || isCustomNativeHost) {
      args.push(`--url=${launchUrl}`);
    } else {
      args.push("--new-window", launchUrl);
    }
  }

  console.log(`[native-flash] Browser: ${browserPath}`);
  if (isCefClient) {
    console.log("[native-flash] Warning: official cefclient.exe can consume Space; run npm run native-flash:build-host for the custom host.");
  }
  console.log(`[native-flash] Host mode: ${useCdpNavigation ? "reference-cdp" : "direct-url"}`);
  console.log(`[native-flash] Pepper Flash: ${pepperFlashPath || "browser/system default"}`);
  if (dbFile) {
    console.log(`[native-flash] Database: ${dbFile}`);
  }
  if (legacySavesFile) {
    console.log(`[native-flash] Legacy saves: ${legacySavesFile}`);
  }
  console.log(`[native-flash] Page: ${launchUrl}`);
  console.log(`[native-flash] CDP: http://127.0.0.1:${debugPort}/json/list`);
  if (nativeSwfUrlPath) {
    console.log(`[native-flash] Native SWF: ${nativeSwfUrlPath}`);
  }
  if (useNativeFlashProxy) {
    console.log(`[native-flash] Local Flash proxy: http://${process.env.NATIVE_FLASH_POLICY_HOST || defaultPolicyProxyHost}:${process.env.NATIVE_FLASH_POLICY_PORT || defaultPolicyProxyPort}`);
  }

  if (process.env.NATIVE_FLASH_DRY_RUN === "1") {
    console.log("[native-flash] Dry run only; browser was not started.");
    serverProcess?.kill();
    return;
  }

  const policyProxy = useNativeFlashProxy ? await startPolicyProxy(serverUrl, policyDomains) : null;

  const browser = spawn(browserPath, args, {
    cwd: path.dirname(browserPath),
    stdio: "ignore",
    windowsHide: false,
  });

  let closing = false;
  let browserExited = false;
  function cleanup(options = {}) {
    if (closing) {
      return;
    }
    closing = true;
    if (options.killBrowser && !browserExited) {
      browser.kill();
    }
    policyProxy?.close().catch(() => undefined);
    serverProcess?.kill();
  }

  process.on("SIGINT", () => {
    cleanup({ killBrowser: true });
    process.exit(130);
  });
  process.on("SIGTERM", () => {
    cleanup({ killBrowser: true });
    process.exit(143);
  });
  browser.on("exit", (code, signal) => {
    browserExited = true;
    console.log(`[native-flash] Browser exited: code=${code ?? "null"} signal=${signal || "null"}`);
    cleanup();
  });

  if (!useCdpNavigation) {
    console.log("[native-flash] Direct CEF mode uses page autostart; CDP attach is skipped.");
    console.log("[native-flash] Keep this terminal open while playing; press Ctrl+C to stop.");
    return;
  }

  const target = await findPageTarget(debugPort);
  const client = new CdpClient(target.webSocketDebuggerUrl);
  await client.connect();
  client.on("Fetch.requestPaused", async (params) => {
    try {
      const url = new URL(params.request.url);
      const localPath = localPathForNativeFlashRequest(url);
      if (localPath) {
        const fulfillment = await fulfillFromLocalMock(serverUrl, params, localPath);
        await client.send("Fetch.fulfillRequest", {
          requestId: params.requestId,
          ...fulfillment,
        });
        if (shouldRefreshWalletForLocalPath(localPath, fulfillment.responseCode)) {
          await notifyWalletChanged(client);
        }
        return;
      }
      await client.send("Fetch.continueRequest", { requestId: params.requestId });
    } catch (error) {
      console.log(`[native-flash] request proxy failed: ${error instanceof Error ? error.message : String(error)}`);
      await client.send("Fetch.continueRequest", { requestId: params.requestId }).catch(() => undefined);
    }
  });

  await client.send("Page.enable");
  await client.send("Runtime.enable");
  await client.send("Network.enable");
  await client.send("Network.setCacheDisabled", { cacheDisabled: true });
  await client.send("Fetch.enable", {
    patterns: [
      { urlPattern: "*://save.api.4399.com/*", requestStage: "Request" },
      { urlPattern: "*://stat.api.4399.com/*", requestStage: "Request" },
      { urlPattern: "*://cdn.comment.4399pk.com/*", requestStage: "Request" },
      { urlPattern: "*://my.4399.com/*", requestStage: "Request" },
      { urlPattern: "*://media.5054399.net/*", requestStage: "Request" },
    ],
  });
  if (useCdpNavigation) {
    console.log(`[native-flash] Navigating CEF host to local page: ${launchUrl}`);
    await client.send("Page.navigate", { url: launchUrl });
    await waitForRuntimePredicate(
      client,
      `location.href === ${JSON.stringify(launchUrl)} && document.readyState !== "loading" && typeof window.__nativeFlashMount === "function"`,
      "native Flash page navigation",
    );
  }
  await client.send("Runtime.evaluate", {
    expression: "if (window.__nativeFlashMount) window.__nativeFlashMount();",
    awaitPromise: false,
  });
  await waitForRuntimePredicate(
    client,
    "document.querySelectorAll('object[type=\"application/x-shockwave-flash\"]').length > 0",
    "native Flash object mount",
    5000,
  );
  const probe = await readNativeFlashProbe(client).catch(() => null);
  if (probe) {
    console.log(`[native-flash] Probe: url=${probe.href} plugin=${probe.flashPlugin || "missing"} objectCount=${probe.objectCount}`);
  }

  console.log("[native-flash] Keep this terminal open while playing; press Ctrl+C to stop.");
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
