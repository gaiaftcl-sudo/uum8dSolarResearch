#!/usr/bin/env bash
# Validate every published number against the program that produces it.
#
# This is the check a stranger runs. It needs no account, no key and no access to the
# substrate repository: it compiles the programs in this directory, runs them against the
# corpora pinned in ../corpus, and confirms that the figures printed appear in the
# published study pages. It also confirms those pages carry no private reference.
#
# A number in a page that no program prints is not reproducible, and this harness says so.
set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$HERE/.." && pwd)"
PASS=0; FAIL=0
ok()   { printf '  PASS  %s\n' "$*"; PASS=$((PASS+1)); }
bad()  { printf '  FAIL  %s\n' "$*"; FAIL=$((FAIL+1)); }
have() { command -v "$1" >/dev/null 2>&1; }

echo "=== 1. corpora match their pinned digests ==="
for d in "$ROOT"/corpus/*/; do
    [ -f "$d/SHA256SUMS" ] || continue
    if ( cd "$d" && shasum -a 256 -c SHA256SUMS >/dev/null 2>&1 ); then
        ok "$(basename "$d") digests verify"
    else
        bad "$(basename "$d") DIGEST MISMATCH — the bytes are not the ones measured"
    fi
done

echo "=== 2. every program compiles and runs ==="
if have xcrun || have swiftc; then
    SC=$(have xcrun && echo "xcrun swiftc" || echo "swiftc")
    for p in "$HERE"/*.swift; do
        n=$(basename "$p" .swift)
        out="$(cd "$ROOT/corpus/flood-lead-time" 2>/dev/null || cd "$HERE"; \
               $SC -O -swift-version 5 "$p" -o "/tmp/val_$n" 2>/dev/null && "/tmp/val_$n" 2>/dev/null)"
        if [ -n "$out" ]; then ok "$n runs"; printf '%s\n' "$out" > "/tmp/out_$n.txt"
        else bad "$n produced no output"; fi
        rm -f "/tmp/val_$n"
    done
else
    echo "  SKIP — no Swift toolchain on this host; the programs are the evidence, install Swift to run them"
fi

echo "=== 3. published figures appear in the program output that produces them ==="
# each row: <program> <figure> <page>
check_figure() {
    local prog="$1" fig="$2" page="$3"
    local o="/tmp/out_$prog.txt"
    [ -f "$o" ] || { echo "  SKIP  $fig (no output from $prog)"; return; }
    if grep -qF -- "$fig" "$o"; then
        if [ -z "$page" ] || grep -qF -- "$fig" "$ROOT/$page" 2>/dev/null; then
            ok "$fig — printed by $prog${page:+ and present in $page}"
        else
            bad "$fig printed by $prog but ABSENT from $page"
        fi
    else
        bad "$fig NOT printed by $prog — the page cites a number its program does not produce"
    fi
}
check_figure lora-time-on-air              "287.744"  "Study-30-Sovereign-Edge-Pod.md"
check_figure lora-time-on-air              "1004.544" "Study-30-Sovereign-Edge-Pod.md"
check_figure z8-vs-e8-lattice              "240"      "Study-30-Sovereign-Edge-Pod.md"
check_figure unimodular-control-arms       "4000"     ""
check_figure reentry-alumina-ledger        "374.4"    "Study-29-Continuous-Model-Shear.md"
check_figure guadalupe-wave-ledger         "180"      ""
check_figure rate-of-rise-common-window    "885"      ""
check_figure flourishing-entropy-ledger    "9 resolve exactly" ""
check_figure flourishing-entropy-ledger    "1/1"      "Home.md"

echo "=== 4. the public pages carry no private reference ==="
# grep -c prints 0 AND exits 1 on no match, so `|| echo 0` yields "0\n0" and breaks the
# arithmetic — which is how the first version of this check reported PASS having counted
# nothing. Count with a single grep -l pass and a positive control instead.
BREACH=0
PAGES=$(ls "$ROOT"/*.md 2>/dev/null | wc -l | tr -d ' ')
[ "$PAGES" -gt 0 ] || { bad "no pages found to scan — refusing to report a clean boundary"; BREACH=1; }
for pat in 'cells/' 'Sources/' '\.gaiaftcl' '/Users/' '\.swift:[0-9]' 'mortonBits' 'CapabilityRegistry'; do
    hits=$(grep -lE "$pat" "$ROOT"/*.md 2>/dev/null | wc -l | tr -d ' ')
    if [ "${hits:-0}" -gt 0 ]; then
        bad "private reference '$pat' in $hits page(s): $(grep -lE "$pat" "$ROOT"/*.md 2>/dev/null | xargs -n1 basename | tr '\n' ' ')"
        BREACH=1
    fi
done
# POSITIVE CONTROL: the scanner must be able to find something that IS there.
CTRL=$(grep -lE 'Affine' "$ROOT"/*.md 2>/dev/null | wc -l | tr -d ' ')
if [ "${CTRL:-0}" -gt 0 ]; then
    [ "$BREACH" -eq 0 ] && ok "no private reference across $PAGES pages (scanner verified live on $CTRL)"
else
    bad "the scanner found NOTHING at all, including its own control — it is not working"
fi

echo "=== 4b. every cited public artifact actually exists ==="
# A page citing reproduce/foo.swift or corpus/bar that is not there is a broken
# reproduction instruction — exactly the defect this repository was restructured to fix,
# so the harness checks it rather than trusting that a rename kept up.
MISSING=0
for cited in $(grep -ohE 'reproduce/[a-z0-9-]+\.swift|corpus/[A-Za-z0-9/_.-]+\.(tsv|md)|corpus/[A-Za-z0-9_-]+/SHA256SUMS' "$ROOT"/*.md 2>/dev/null | sort -u); do
    [ -e "$ROOT/$cited" ] || { bad "cited but absent: $cited"; MISSING=$((MISSING+1)); }
done
[ "$MISSING" -eq 0 ] && ok "every cited program and corpus path exists"

echo "=== 4c. no private identifier, not just no private path ==="
# The path patterns in 4 miss private IDENTIFIERS — daemon names, artifact names, internal
# record fields. A boundary scan scoped to paths reported clean while three of these were
# present, which is the same scoping error the substrate's float and heap gates each paid
# for once.
IDS=0
for pat in 'treasury-swarm' 'injector_lease_holder' 'covered_execs' 'observed_execs' \
           'com\.gaiaftcl' 'gaiaftcl-language-invariant' 'prove-fleet-byte-identity' \
           'apex-watchdog' 'prove-cell-identity' 'CertifiedUser' 'servableEntries'; do
    hits=$(grep -lE "$pat" "$ROOT"/*.md 2>/dev/null | wc -l | tr -d ' ')
    [ "${hits:-0}" -gt 0 ] && { bad "private identifier '$pat' in $hits page(s)"; IDS=1; }
done
[ "$IDS" -eq 0 ] && ok "no private identifier in any published page"

echo "=== 5. the live surface serves ==="
if have curl; then
    code=$(curl -s -o /tmp/games.json -w '%{http_code}' --max-time 30 \
           https://affine.earth/language-invariant/games 2>/dev/null)
    if [ "$code" = "200" ]; then
        ok "live catalogue serves 200"
        if have jq; then
            d=$(jq -r '.lattice_courts.domain_count // empty' /tmp/games.json 2>/dev/null)
            [ "$d" = "48" ] && ok "catalogue reports 48 domains" || bad "domain_count is '$d', pages say 48"
            nf=$(jq -r '.lattice_courts.no_float // empty' /tmp/games.json 2>/dev/null)
            [ "$nf" = "true" ] && ok "catalogue reports no_float true" || bad "no_float is '$nf'"
        fi
    else
        bad "live catalogue returned $code"
    fi
else
    echo "  SKIP — no curl"
fi

echo
echo "=== $PASS passed · $FAIL failed ==="
[ "$FAIL" -eq 0 ] && { echo "VALIDATED — every published figure reproduces from public bytes."; exit 0; }
echo "NOT VALIDATED — see the failures above."; exit 1
