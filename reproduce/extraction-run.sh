#!/usr/bin/env bash
# extraction-run.sh — build the extraction kernel, self-test it, run it over the pinned
# corpus and over every live detection row on disk, and scan the built image for floating
# point. One pass, one source state.
#
# THE SOURCE DIGEST IS BRACKETED AROUND THE WHOLE RUN. A source edited mid-run means the
# binary under test came from no single source state, and the run says so rather than
# reporting the figures it happened to produce.
#
# EVERY EXIT PATH PRINTS ITS REFERENCE FIGURES, including the one where the corpus is not
# here. ABSENCE and REFUSAL are different answers and neither is a pass.
#
# PATH-INDEPENDENT: every path derives from this script's own location.
set -u
here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
corpus="${CORPUS:-$here/../corpus/market-shear/eth}"
pins="$here/market-shear-corpus.sha256"
out="$here/logs"
mkdir -p "$out"

pin() { awk -v f="$1" '$3==f{print $1}' "$pins"; }

pre=$(shasum -a 256 "$here/extraction-exact.swift" | cut -d' ' -f1)
echo "source_sha256_before_build	$pre"

xcrun swiftc -O -swift-version 5 "$here/extraction-exact.swift" -o "$here/extraction-exact" \
  || { echo BUILD_FAILED; exit 1; }
echo "BUILD_OK"
shasum -a 256 "$here/extraction-exact" | sed 's/^/binary_sha256	/'

echo
echo "--- SELF-TEST ---"
"$here/extraction-exact" selftest > "$out/extraction-selftest.txt" 2>&1
rc=$?
echo "selftest_exit	$rc"
grep -E '^(arms_run|arms_passed|arms_failed|SELFTEST)' "$out/extraction-selftest.txt"
[ "$rc" -ne 0 ] && { echo "REFUSE	SELFTEST_FAILED"; exit 3; }

echo
echo "--- FLOATING POINT, BY DISASSEMBLY ---"
nm "$here/extraction-exact" 2>/dev/null | awk '$2=="t"||$2=="T"{print $3}' \
  | grep '4main' \
  | grep -E 'v2Out|v2Recover|getAmount0Delta|getAmount1Delta|nextSqrtFromAmount|v3Step|v3InvertStart|computeShortfall|finishRatios|U256V6mulDiv|U256V8mulDivUp|U256V3div|U256V7divFull|U256V7mulFull|U256V3shl|U256V4addC|U256V4subB|U256V3cmp|4SIntV4diff|dataWord|hexU64' \
  | grep -vE 'Mn$|MF$|Ma$|Mf$|N$|WV$|wet|wst|vg$|vs$|vM$|vpfi$|TW$|Wl$|WL$|Mc$' \
  | sort -u > "$here/extraction-core-syms.txt"
echo "decision_path_symbols	$(wc -l < "$here/extraction-core-syms.txt" | tr -d ' ')"
bash "$here/extraction-fpscan.sh" "$here/extraction-exact" "$here/extraction-core-syms.txt" \
  > "$out/extraction-fpscan.txt" 2>&1
echo "fpscan_exit	$?"
grep -E '^(CONTROL_1|CONTROL_2|whole_binary|WHOLE_BINARY|SYMBOLS_SCANNED|SYMBOLS_NOT_FOUND|INSTRUCTIONS_SCANNED|FP_ARITHMETIC|FP_MOVES|DECISION_PATH|REFUSE)' "$out/extraction-fpscan.txt"

echo
if [ ! -d "$corpus" ]; then
    echo "CORPUS_ABSENT	$corpus"
    echo "ABSENT is not a failure and it is not a pass: the corpus is fetched, never committed."
    "$here/extraction-exact" </dev/null
    exit 4
fi

echo "--- EXTRACTION over the pinned corpus ---"
"$here/extraction-exact" --dir "$corpus" --start 14000000 --count 1000 \
  --expect-blocks "$(pin eth/blocks.ndjson)" \
  --expect-receipts "$(pin eth/receipts.ndjson)" \
  --live "$here/detections-live.jsonl,$here/detections-replay.jsonl" \
  > "$out/extraction.txt" 2>&1
echo "extraction_exit	$?"

post=$(shasum -a 256 "$here/extraction-exact.swift" | cut -d' ' -f1)
echo "source_sha256_after_runs	$post"
if [ "$pre" = "$post" ]; then echo "SOURCE_UNCHANGED_THROUGHOUT	YES"
else echo "SOURCE_UNCHANGED_THROUGHOUT	NO_REFUSE"; exit 5; fi
echo EXTRACTION_RUN_DONE
