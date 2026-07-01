import path from "node:path";

export const projectRoot = path.resolve(import.meta.dirname, "..", "..");

export const paths = {
  projectRoot,
  downloadsPages: path.join(projectRoot, "downloads", "pages"),
  downloadsSwf: path.join(projectRoot, "downloads", "swf"),
  extractedSwf: path.join(projectRoot, "extracted", "swf"),
  logs: path.join(projectRoot, "logs"),
  vendor: path.join(projectRoot, "vendor"),
} as const;
