import { createHash } from "node:crypto";
import { appendFileSync, existsSync, mkdirSync, readFileSync, truncateSync } from "node:fs";
import path from "node:path";
import { saveDataPaths } from "./paths.js";
import type { SaveDataLogEvent } from "./types.js";

type LoggerOptions = {
  logFile?: string;
  previewLength?: number;
};

export function sha256(value: string): string {
  return createHash("sha256").update(value).digest("hex");
}

export function payloadSummary(data: string, previewLength = 96) {
  return {
    dataLength: data.length,
    dataSha256: sha256(data),
    dataPreview: data.length > previewLength ? `${data.slice(0, previewLength)}...` : data,
  };
}

export class SaveDataLogger {
  readonly logFile: string;
  readonly previewLength: number;

  constructor(options: LoggerOptions = {}) {
    this.logFile = options.logFile ?? saveDataPaths.mockApiLogFile;
    this.previewLength = options.previewLength ?? 96;
    mkdirSync(path.dirname(this.logFile), { recursive: true });
  }

  appendSync(event: Omit<SaveDataLogEvent, "ts">): void {
    const line = JSON.stringify({ ts: new Date().toISOString(), ...event }) + "\n";
    mkdirSync(path.dirname(this.logFile), { recursive: true });
    appendFileSync(this.logFile, line, "utf8");
  }

  list(limit = 200): SaveDataLogEvent[] {
    if (!existsSync(this.logFile)) {
      return [];
    }

    const lines = readFileSync(this.logFile, "utf8").split("\n").filter(Boolean);
    return lines.slice(Math.max(0, lines.length - limit)).map((line) => JSON.parse(line) as SaveDataLogEvent);
  }

  clear(): void {
    mkdirSync(path.dirname(this.logFile), { recursive: true });
    truncateSync(this.logFile);
  }
}
