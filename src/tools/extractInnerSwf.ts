import { createHash } from "node:crypto";
import { mkdir, readFile, writeFile } from "node:fs/promises";
import path from "node:path";
import { paths } from "../shared/paths.js";
import { decodeSwf, isSwfBuffer, parseTags } from "../swf/swf.js";

type EmbeddedSwf = {
  id: number;
  tagOffset: number;
  bytes: Buffer;
};

function sha256(buffer: Buffer): string {
  return createHash("sha256").update(buffer).digest("hex");
}

function findEmbeddedSwfs(file: Buffer): EmbeddedSwf[] {
  const swf = decodeSwf(file);
  const tags = parseTags(swf.body);
  const embedded: EmbeddedSwf[] = [];

  for (const tag of tags) {
    if (tag.code !== 87 || tag.data.length < 6) {
      continue;
    }

    const id = tag.data.readUInt16LE(0);
    const payload = tag.data.subarray(6);
    if (!isSwfBuffer(payload)) {
      continue;
    }

    embedded.push({
      id,
      tagOffset: tag.offset,
      bytes: Buffer.from(payload),
    });
  }

  return embedded.sort((a, b) => b.bytes.length - a.bytes.length);
}

async function main(): Promise<void> {
  const outerPath = path.join(paths.downloadsSwf, "xfbbv451.swf");
  const outer = await readFile(outerPath);
  const embedded = findEmbeddedSwfs(outer);

  if (embedded.length === 0) {
    throw new Error("No embedded SWF was found in xfbbv451.swf");
  }

  await mkdir(paths.extractedSwf, { recursive: true });

  const records = [];
  for (const item of embedded) {
    const outputName = `define-binary-${item.id}.swf`;
    const outputPath = path.join(paths.extractedSwf, outputName);
    await writeFile(outputPath, item.bytes);

    const record = {
      id: item.id,
      tagOffset: item.tagOffset,
      bytes: item.bytes.length,
      sha256: sha256(item.bytes),
      outputPath: path.relative(paths.projectRoot, outputPath).replaceAll("\\", "/"),
    };
    records.push(record);
    console.log(`${outputName}: ${record.bytes} bytes ${record.sha256}`);
  }

  const mainSwf = embedded[0];
  const mainPath = path.join(paths.extractedSwf, "L4399Main_gamefile.swf");
  await writeFile(mainPath, mainSwf.bytes);
  records.unshift({
    id: mainSwf.id,
    tagOffset: mainSwf.tagOffset,
    bytes: mainSwf.bytes.length,
    sha256: sha256(mainSwf.bytes),
    outputPath: path.relative(paths.projectRoot, mainPath).replaceAll("\\", "/"),
    selectedAsMainGame: true,
  });

  await writeFile(
    path.join(paths.logs, "embedded-swfs.json"),
    `${JSON.stringify(records, null, 2)}\n`,
    "utf8"
  );
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
