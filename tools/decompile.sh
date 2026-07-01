#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
FFDEC_JAR="$ROOT/vendor/ffdec/ffdec.jar"

if [[ ! -f "$FFDEC_JAR" ]]; then
  echo "Missing FFDec jar: $FFDEC_JAR" >&2
  exit 1
fi

mkdir -p \
  "$ROOT/decompiled/ffdec/xfbbv451/as3" \
  "$ROOT/decompiled/ffdec/xfbbv451/pcode" \
  "$ROOT/decompiled/ffdec/L4399Main_gamefile/as3" \
  "$ROOT/decompiled/ffdec/L4399Main_gamefile/pcode" \
  "$ROOT/logs"

java -jar "$FFDEC_JAR" -onerror ignore -export script,binaryData,image,sound,movie "$ROOT/decompiled/ffdec/xfbbv451/as3" "$ROOT/downloads/swf/xfbbv451.swf" \
  > "$ROOT/logs/ffdec-xfbbv451-as3.log" 2>&1

java -jar "$FFDEC_JAR" -onerror ignore -format script:pcode -export script "$ROOT/decompiled/ffdec/xfbbv451/pcode" "$ROOT/downloads/swf/xfbbv451.swf" \
  > "$ROOT/logs/ffdec-xfbbv451-pcode.log" 2>&1

java -jar "$FFDEC_JAR" -onerror ignore -export script,binaryData,image,sound,movie "$ROOT/decompiled/ffdec/L4399Main_gamefile/as3" "$ROOT/extracted/swf/L4399Main_gamefile.swf" \
  > "$ROOT/logs/ffdec-L4399Main_gamefile-as3.log" 2>&1

java -jar "$FFDEC_JAR" -onerror ignore -format script:pcode -export script "$ROOT/decompiled/ffdec/L4399Main_gamefile/pcode" "$ROOT/extracted/swf/L4399Main_gamefile.swf" \
  > "$ROOT/logs/ffdec-L4399Main_gamefile-pcode.log" 2>&1
