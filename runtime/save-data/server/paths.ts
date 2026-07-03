import path from "node:path";

export const projectRoot = process.env.SAVE_DATA_PROJECT_ROOT
  ? path.resolve(process.env.SAVE_DATA_PROJECT_ROOT)
  : path.resolve(import.meta.dirname, "..", "..", "..");
export const saveDataRoot = process.env.SAVE_DATA_RUNTIME_ROOT
  ? path.resolve(process.env.SAVE_DATA_RUNTIME_ROOT)
  : path.join(projectRoot, "runtime", "save-data");
export const workspaceRoot = process.env.SAVE_DATA_WORKSPACE_ROOT
  ? path.resolve(process.env.SAVE_DATA_WORKSPACE_ROOT)
  : path.join(projectRoot, "workspace", "saveData");

export const saveDataPaths = {
  projectRoot,
  saveDataRoot,
  workspaceRoot,
  publicRoot: path.join(saveDataRoot, "public"),
  runtimePublicRoot: path.join(workspaceRoot, "public"),
  platformAssetsRoot: path.join(workspaceRoot, "platform-assets"),
  remoteAssetsRoot: path.join(workspaceRoot, "remote-assets"),
  logsRoot: path.join(workspaceRoot, "logs"),
  mockApiLogFile: path.join(workspaceRoot, "logs", "mock-api.ndjson"),
  schemaFile: path.join(saveDataRoot, "schema", "local-save.sql"),
  defaultDbFile: path.join(workspaceRoot, "local-save.db"),
  downloadsSwf: path.join(projectRoot, "downloads", "swf"),
  extractedSwf: path.join(projectRoot, "extracted", "swf"),
  ruffleRoot: process.env.SAVE_DATA_RUFFLE_ROOT
    ? path.resolve(process.env.SAVE_DATA_RUFFLE_ROOT)
    : path.join(projectRoot, "node_modules", "@ruffle-rs", "ruffle"),
} as const;
