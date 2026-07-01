import { createHash } from "node:crypto";
import { mkdir, writeFile } from "node:fs/promises";
import path from "node:path";
import { paths } from "../shared/paths.js";

type SourceFile = {
  id: string;
  url: string;
  outputPath: string;
  referer?: string;
};

type DownloadRecord = {
  id: string;
  url: string;
  outputPath: string;
  downloadedAt: string;
  bytes: number;
  sha256: string;
};

const sources: SourceFile[] = [
  {
    id: "game-page",
    url: "https://www.4399.com/flash/115225_2.htm",
    outputPath: path.join(paths.downloadsPages, "page-115225_2.html"),
  },
  {
    id: "iframe-page",
    url: "https://sbai.4399.com/4399swf/upload_swf/ftp10/honghao/20130530/27/jjxzfcms.htm",
    outputPath: path.join(paths.downloadsPages, "iframe-jjxzfcms.html"),
    referer: "https://www.4399.com/flash/115225_2.htm",
  },
  {
    id: "outer-swf",
    url: "https://sbai.4399.com/4399swf/upload_swf/ftp10/honghao/20130530/27/xfbbv451.swf",
    outputPath: path.join(paths.downloadsSwf, "xfbbv451.swf"),
    referer: "https://sbai.4399.com/4399swf/upload_swf/ftp10/honghao/20130530/27/jjxzfcms.htm",
  },
];

function sha256(buffer: Buffer): string {
  return createHash("sha256").update(buffer).digest("hex");
}

async function download(source: SourceFile): Promise<DownloadRecord> {
  const response = await fetch(source.url, {
    headers: {
      "User-Agent": "Mozilla/5.0",
      ...(source.referer ? { Referer: source.referer } : {}),
    },
  });

  if (!response.ok) {
    throw new Error(`${source.id} failed: ${response.status} ${response.statusText}`);
  }

  const buffer = Buffer.from(await response.arrayBuffer());
  await mkdir(path.dirname(source.outputPath), { recursive: true });
  await writeFile(source.outputPath, buffer);

  return {
    id: source.id,
    url: source.url,
    outputPath: path.relative(paths.projectRoot, source.outputPath).replaceAll("\\", "/"),
    downloadedAt: new Date().toISOString(),
    bytes: buffer.length,
    sha256: sha256(buffer),
  };
}

async function main(): Promise<void> {
  await mkdir(paths.logs, { recursive: true });

  const records: DownloadRecord[] = [];
  for (const source of sources) {
    const record = await download(source);
    records.push(record);
    console.log(`${record.id}: ${record.bytes} bytes ${record.sha256}`);
  }

  const sourceLogPath = path.join(paths.logs, "source-urls.json");
  await writeFile(sourceLogPath, `${JSON.stringify(records, null, 2)}\n`, "utf8");

  const checksums = records
    .map((record) => `${record.sha256}  ${record.outputPath}`)
    .join("\n");
  await writeFile(path.join(paths.logs, "checksums.txt"), `${checksums}\n`, "utf8");
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
