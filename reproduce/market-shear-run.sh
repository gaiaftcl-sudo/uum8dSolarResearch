#!/usr/bin/env bash
# market-shear-run.sh — build the kernel from source, self-test it, then run every pinned
# corpus through it in one pass.
#
# PATH-INDEPENDENT: every path is derived from this script's own location. Nothing here
# names a machine, a user or a home directory.
#
# THE SOURCE DIGEST IS BRACKETED AROUND THE WHOLE RUN. A source edited mid-run means the
# binary under test came from no single source state, and the run says so rather than
# reporting the figures it happened to produce.
#
# EVERY EXIT PATH PRINTS ITS REFERENCE FIGURES, including the one where the corpus is not
# here. ABSENCE and REFUSAL are different answers, and neither is a pass.
#
# CORPUS: fetched, never committed — 1,103,272,137 bytes is too much to carry in a wiki,
# and it is public. See market-shear-corpus.sha256 for the pins and the study page for the
# fetch commands. Default location is ../corpus/market-shear; CORPUS=<dir> overrides it.
set -u
here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
corpus="${CORPUS:-$here/../corpus/market-shear}"
pins="$here/market-shear-corpus.sha256"

build() {
    xcrun swiftc -O -swift-version 5 "$here/market-shear-exact.swift" -o "$here/msx" \
      || { echo BUILD_FAILED; exit 1; }
    echo "BUILD_OK"
}

if [ ! -d "$corpus" ]; then
    echo "CORPUS_ABSENT	$corpus"
    echo "ABSENT is not a failure and it is not a pass: the corpus is fetched, not committed."
    echo "Fetch it with the commands on the study page, or set CORPUS=<dir>, then re-run."
    echo
    echo "Building the kernel anyway — that part needs no corpus — and running its"
    echo "reference-figures path, so this run still prints the published figures it"
    echo "would have measured."
    build
    "$here/msx" </dev/null
    exit 4
fi

pre=$(shasum -a 256 "$here/market-shear-exact.swift" | cut -d' ' -f1)
echo "source_sha256_before_build	$pre"
build
K="$here/msx"
mkdir -p "$here/logs-market-shear"

# The self-test stages its fixtures in a TEMPORARY directory, never inside the checkout:
# a run must not leave untracked litter in a repository a reader has just cloned.
sttmp="$(mktemp -d)"
trap 'rm -rf "$sttmp"' EXIT

"$K" selftest --tmp "$sttmp" > "$here/logs-market-shear/selftest.txt" 2>&1
echo "selftest_exit	$?"
grep -E '^(arms_run|arms_passed|arms_failed|SELFTEST|VERDICT)' "$here/logs-market-shear/selftest.txt"

# A DIGEST IS READ FROM THE PIN FILE AT RUN TIME, never retyped into a command line.
pin() { awk -v f="$1" '$3==f{print $1}' "$pins"; }

echo "--- ETH ---"
"$K" eth --dir "$corpus/eth" --start 14000000 --count 1000 \
  --expect-blocks "$(pin eth/blocks.ndjson)" \
  --expect-receipts "$(pin eth/receipts.ndjson)" \
  > "$here/logs-market-shear/eth.txt" 2>&1
echo "eth exit=$?"

echo "--- ITCH v2, 2003-01-03 ---"
"$K" itchv2 --zip "$corpus/itch/S010303-v2.zip" --member S010303-v2.txt \
  --expect-sha256 "$(pin itch/S010303-v2.zip)" \
  > "$here/logs-market-shear/itchv2.txt" 2>&1
echo "itchv2 exit=$?"

echo "--- ITCH 5.0, 2019-07-30 ---"
"$K" itch50 --gz "$corpus/itch/20190730.BX_ITCH_50.gz" \
  --expect-sha256 "$(pin itch/20190730.BX_ITCH_50.gz)" \
  > "$here/logs-market-shear/itch50.txt" 2>&1
echo "itch50 exit=$?"

post=$(shasum -a 256 "$here/market-shear-exact.swift" | cut -d' ' -f1)
echo "source_sha256_after_runs	$post"
if [ "$pre" = "$post" ]; then
    echo "SOURCE_UNCHANGED_THROUGHOUT	YES"
else
    echo "SOURCE_UNCHANGED_THROUGHOUT	NO_REFUSE"
    exit 5
fi
shasum -a 256 "$K" | sed 's/^/binary_sha256	/'
echo MARKET_SHEAR_RUN_DONE
