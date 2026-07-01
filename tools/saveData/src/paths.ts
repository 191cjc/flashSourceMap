import path from "node:path";

export const projectRoot = path.resolve(import.meta.dirname, "..", "..", "..");
export const saveDataRoot = path.join(projectRoot, "tools", "saveData");
export const workspaceRoot = path.join(projectRoot, "workspace", "saveData");

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
  ruffleRoot: path.join(projectRoot, "node_modules", "@ruffle-rs", "ruffle"),
} as const;
