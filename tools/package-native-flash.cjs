const fs = require("fs");
const path = require("path");
const crypto = require("crypto");
const { spawnSync } = require("child_process");

const projectRoot = path.resolve(__dirname, "..");
const packageJson = JSON.parse(fs.readFileSync(path.join(projectRoot, "package.json"), "utf8"));
const version = packageJson.version;
const packageName = `FlashSourceMap-NativeFlash-v${version}-win-x64`;
const buildsRoot = path.join(projectRoot, "builds");
const packageRoot = path.join(buildsRoot, "native-flash", packageName);
const releaseRoot = path.join(buildsRoot, "release-assets");
const zipFile = path.join(releaseRoot, `${packageName}.zip`);
const checksumFile = path.join(releaseRoot, "checksums.txt");
const cefBuildName = "cef_binary_75.1.14+gc81164e+chromium-75.0.3770.100_windows64_client";
const cefReleaseDir = path.join(projectRoot, "workspace", "native-cef75", cefBuildName, "Release");
const nativeHostExeName = "flash-native-host.exe";
const nativeHostReleaseDir = path.join(projectRoot, "workspace", "native-host", "Release");
const nativeHostExe = path.join(nativeHostReleaseDir, nativeHostExeName);
const packageLauncherExe = path.join(projectRoot, "workspace", "native-launcher", "FlashSourceMap.exe");
const vendoredPepperFlash = path.join(projectRoot, "vendor", "native-flash", "pepflashplayer64.dll");

function run(command, args, options = {}) {
  const result = spawnSync(command, args, {
    cwd: projectRoot,
    stdio: "inherit",
    windowsHide: true,
    ...options,
  });
  if (result.error) {
    throw result.error;
  }
  if (result.status !== 0) {
    throw new Error(`${command} ${args.join(" ")} failed with exit code ${result.status}`);
  }
}

function runNpmScript(scriptName) {
  if (process.platform === "win32") {
    run("cmd.exe", ["/d", "/s", "/c", `npm run ${scriptName}`]);
    return;
  }
  run("npm", ["run", scriptName]);
}

function ensureInsideRepo(target) {
  const resolved = path.resolve(target);
  if (!resolved.toLowerCase().startsWith(projectRoot.toLowerCase())) {
    throw new Error(`Refusing to touch path outside project: ${resolved}`);
  }
  return resolved;
}

function cleanDir(target) {
  const resolved = ensureInsideRepo(target);
  fs.rmSync(resolved, { recursive: true, force: true });
  fs.mkdirSync(resolved, { recursive: true });
}

function copyFile(source, target) {
  if (!fs.existsSync(source) || !fs.statSync(source).isFile()) {
    throw new Error(`Required file is missing: ${source}`);
  }
  fs.mkdirSync(path.dirname(target), { recursive: true });
  fs.copyFileSync(source, target);
}

function copyDir(source, target) {
  if (!fs.existsSync(source) || !fs.statSync(source).isDirectory()) {
    throw new Error(`Required directory is missing: ${source}`);
  }
  fs.cpSync(source, target, { recursive: true, force: true });
}

function copyOptionalDir(source, target) {
  if (fs.existsSync(source) && fs.statSync(source).isDirectory()) {
    fs.cpSync(source, target, { recursive: true, force: true });
    return true;
  }
  return false;
}

function existingFile(candidates) {
  for (const candidate of candidates.filter(Boolean)) {
    const resolved = path.resolve(candidate);
    if (fs.existsSync(resolved) && fs.statSync(resolved).isFile()) {
      return resolved;
    }
  }
  return null;
}

function pepperFlashPath() {
  return existingFile([
    process.env.NATIVE_FLASH_PEPPER_PATH,
    vendoredPepperFlash,
    path.join(nativeHostReleaseDir, "pepflashplayer64.dll"),
    path.join(cefReleaseDir, "pepflashplayer64.dll"),
    path.join(projectRoot, "workspace", "native-cef75", "pepflashplayer64.dll"),
    path.join(projectRoot, "workspace", "native-cef", "pepflashplayer64.dll"),
  ]);
}

function nativeHostPath() {
  return existingFile([
    process.env.NATIVE_FLASH_HOST_PATH,
    process.env.NATIVE_FLASH_BROWSER_PATH,
    nativeHostExe,
  ]);
}

function writeText(target, contents) {
  fs.mkdirSync(path.dirname(target), { recursive: true });
  fs.writeFileSync(target, contents.replace(/\n/g, "\r\n"), "utf8");
}

function sha256(file) {
  return crypto.createHash("sha256").update(fs.readFileSync(file)).digest("hex");
}

function buildZip() {
  fs.rmSync(zipFile, { force: true });
  run("powershell.exe", [
    "-NoProfile",
    "-ExecutionPolicy",
    "Bypass",
    "-Command",
    `Compress-Archive -LiteralPath ${JSON.stringify(packageRoot)} -DestinationPath ${JSON.stringify(zipFile)} -Force`,
  ]);
}

function buildPackageLauncher() {
  run("powershell.exe", [
    "-NoProfile",
    "-ExecutionPolicy",
    "Bypass",
    "-File",
    path.join(projectRoot, "tools", "build-native-package-launcher.ps1"),
  ]);
  if (!fs.existsSync(packageLauncherExe)) {
    throw new Error(`Package launcher was not created: ${packageLauncherExe}`);
  }
}

function main() {
  const nativeHost = nativeHostPath();
  if (!nativeHost) {
    throw new Error(
      [
        "flash-native-host.exe was not found.",
        "Run npm run native-flash:build-host before packaging,",
        "or set NATIVE_FLASH_HOST_PATH to an existing custom CEF host.",
      ].join(" ")
    );
  }

  const pepper = pepperFlashPath();
  if (!pepper) {
    throw new Error(
      [
        "pepflashplayer64.dll was not found.",
        "Set NATIVE_FLASH_PEPPER_PATH or place it under vendor/native-flash/ before packaging.",
      ].join(" ")
    );
  }

  run(process.execPath, [path.join(projectRoot, "tools", "launch-native-flash-mock.cjs"), "--prepare"], {
    env: {
      ...process.env,
      NATIVE_FLASH_BROWSER_PATH: nativeHost,
      NATIVE_FLASH_DISABLE_REFERENCE: "1",
      NATIVE_FLASH_AUTO_DOWNLOAD_CEF: "0",
    },
  });

  const nativeHostRuntimeDir = path.dirname(nativeHost);
  if (!fs.existsSync(nativeHostRuntimeDir)) {
    throw new Error(`Native host runtime directory is missing: ${nativeHostRuntimeDir}`);
  }

  buildPackageLauncher();

  fs.rmSync(path.join(projectRoot, "dist"), { recursive: true, force: true });
  runNpmScript("build");

  cleanDir(packageRoot);
  cleanDir(releaseRoot);

  const appRoot = path.join(packageRoot, "app");
  const dataRoot = path.join(packageRoot, "data");
  const cefTarget = path.join(packageRoot, "cef", "Release");
  const nodeTarget = path.join(packageRoot, "node", "node.exe");

  copyFile(process.execPath, nodeTarget);
  copyFile(path.join(projectRoot, "package.json"), path.join(appRoot, "package.json"));
  copyDir(path.join(projectRoot, "dist"), path.join(appRoot, "dist"));
  copyFile(path.join(projectRoot, "tools", "launch-native-flash-mock.cjs"), path.join(appRoot, "tools", "launch-native-flash-mock.cjs"));
  copyDir(path.join(projectRoot, "runtime", "save-data", "public"), path.join(appRoot, "runtime", "save-data", "public"));
  copyDir(path.join(projectRoot, "runtime", "save-data", "schema"), path.join(appRoot, "runtime", "save-data", "schema"));
  copyOptionalDir(path.join(projectRoot, "runtime", "save-data", "assets"), path.join(appRoot, "runtime", "save-data", "assets"));
  copyDir(path.join(projectRoot, "downloads", "swf"), path.join(appRoot, "downloads", "swf"));
  copyDir(path.join(projectRoot, "extracted", "swf"), path.join(appRoot, "extracted", "swf"));
  copyDir(path.join(projectRoot, "node_modules", "crypto-js"), path.join(appRoot, "node_modules", "crypto-js"));

  copyDir(nativeHostRuntimeDir, cefTarget);
  copyFile(pepper, path.join(cefTarget, "pepflashplayer64.dll"));
  copyFile(packageLauncherExe, path.join(packageRoot, "FlashSourceMap.exe"));

  fs.mkdirSync(path.join(dataRoot, "saveData"), { recursive: true });
  copyOptionalDir(path.join(projectRoot, "workspace", "saveData", "platform-assets"), path.join(dataRoot, "saveData", "platform-assets"));
  copyOptionalDir(path.join(projectRoot, "workspace", "saveData", "remote-assets"), path.join(dataRoot, "saveData", "remote-assets"));

  if (process.env.NATIVE_FLASH_INCLUDE_LEGACY_SAVES === "1") {
    const legacy = existingFile([
      process.env.SAVE_DATA_LEGACY_SAVES_FILE,
      path.join(projectRoot, "data", "runtime-mock-saves.json"),
      path.join(path.dirname(projectRoot), "flash-4399-115225-dev", "data", "runtime-mock-saves.json"),
    ]);
    if (legacy) {
      copyFile(legacy, path.join(dataRoot, "runtime-mock-saves.json"));
    }
  }

  writeText(
    path.join(packageRoot, "start-native-flash-debug.bat"),
    `@echo off
setlocal
cd /d "%~dp0"
set "ROOT=%~dp0"
set "APP_ROOT=%ROOT%app"
set "NODE_EXE=%ROOT%node\\node.exe"
set "SAVE_DATA_PROJECT_ROOT=%APP_ROOT%"
set "SAVE_DATA_WORKSPACE_ROOT=%ROOT%data\\saveData"
set "LEGACY_DESKTOP_DB=%APPDATA%\\flash-source-map\\saveData\\local-save.db"
if exist "%LEGACY_DESKTOP_DB%" (
  set "SAVE_DATA_DB=%LEGACY_DESKTOP_DB%"
) else (
  set "SAVE_DATA_DB=%ROOT%data\\saveData\\local-save.db"
  if exist "%ROOT%data\\runtime-mock-saves.json" set "SAVE_DATA_LEGACY_SAVES_FILE=%ROOT%data\\runtime-mock-saves.json"
)
set "NATIVE_FLASH_BROWSER_PATH=%ROOT%cef\\Release\\flash-native-host.exe"
set "NATIVE_FLASH_PEPPER_PATH=%ROOT%cef\\Release\\pepflashplayer64.dll"
set "NATIVE_FLASH_USER_DATA_DIR=%ROOT%data\\cef-profile"
set "NATIVE_FLASH_AUTO_DOWNLOAD_CEF=0"
set "NATIVE_FLASH_DISABLE_REFERENCE=1"
set "SAVE_DATA_LOGS=0"
"%NODE_EXE%" "%APP_ROOT%\\tools\\launch-native-flash-mock.cjs"
if errorlevel 1 pause
`
  );

  writeText(
    path.join(packageRoot, "README.txt"),
    `FlashSourceMap Native Flash ${version}

1. Extract the whole folder to a writable location.
2. Double-click FlashSourceMap.exe.
3. No console window is shown. Diagnostic output is written to data\\launcher.log.

For troubleshooting, start-native-flash-debug.bat keeps the console open.

Saves are read from %APPDATA%\\flash-source-map\\saveData\\local-save.db when that old desktop database exists.
If that database is missing, runtime data is stored under data\\saveData.
If you need to reuse an old JSON save file, put it at data\\runtime-mock-saves.json before starting; SQLite takes priority when present.
`
  );

  buildZip();
  fs.writeFileSync(checksumFile, `${sha256(zipFile)}  ${path.basename(zipFile)}\n`, "utf8");

  const sizeMb = (fs.statSync(zipFile).size / 1024 / 1024).toFixed(1);
  console.log(`[native-package] ${zipFile}`);
  console.log(`[native-package] size=${sizeMb} MiB`);
  console.log(`[native-package] sha256=${sha256(zipFile)}`);
}

main();
