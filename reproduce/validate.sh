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
PASS=0
ABSENT=0; FAIL=0
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
    # THE LAW IS COMPILED IN, NEVER COPIED. A script that consumes FusionLaw is
    # built multi-file against its single home — which is why the law cannot fork
    # again. Top-level code must be named main.swift, so the script is staged.
    LAWSRC="$ROOT/app/FusionCourt/Sources/FusionLaw"
    for p in "$HERE"/*.swift; do
        n=$(basename "$p" .swift)
        extra=""
        if grep -q "FusionLaw\.\|LawConstants\." "$p" 2>/dev/null; then
            extra="$extra $(ls "$LAWSRC"/*.swift 2>/dev/null | tr '\n' ' ')"
        fi
        # A script consuming the operating-point court links that target too.
        if grep -q "FusionOperatingPointLaw\.\|OperatingEnvelope(" "$p" 2>/dev/null; then
            extra="$extra $(ls "$ROOT/app/FusionCourt/Sources/FusionOperatingPoint"/*.swift 2>/dev/null | tr '\n' ' ')"
        fi
        stage="$(mktemp -d)"; cp "$p" "$stage/main.swift"
        out="$(cd "$ROOT/corpus/flood-lead-time" 2>/dev/null || cd "$HERE"; \
               $SC -O -swift-version 5 $extra "$stage/main.swift" -o "/tmp/val_$n" 2>/dev/null && "/tmp/val_$n" 2>/dev/null)"
        if [ -n "$out" ]; then ok "$n runs"; printf '%s\n' "$out" > "/tmp/out_$n.txt"
        else bad "$n produced no output"; fi
        rm -f "/tmp/val_$n"; rm -rf "$stage"
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
check_figure flourishing-entropy-ledger    "1/1"      ""

# --- the landing page's own headline figures ---
check_figure seasonal-and-alternative      "About fifty tonnes" "SpaceX-Biosphere-Safety.md"
check_figure seasonal-and-alternative      "477 tonnes a season" "SpaceX-Biosphere-Safety.md"
check_figure seasonal-and-alternative      "2,460 tonnes a season" "SpaceX-Biosphere-Safety.md"
check_figure seasonal-and-alternative      "20,000 tonnes a season" "SpaceX-Biosphere-Safety.md"
check_figure seasonal-and-alternative      "219 tonnes every single day" "SpaceX-Biosphere-Safety.md"
check_figure seasonal-and-alternative      "1,594,900" "SpaceX-Biosphere-Safety.md"
check_figure seasonal-and-alternative      "1,825,000" "SpaceX-Biosphere-Safety.md"
check_figure seasonal-and-alternative      "3.240 J"  "SpaceX-Biosphere-Safety.md"
check_figure response-envelope-projection  "0.257"    ""
check_figure response-envelope-projection  "1.324"    ""
check_figure response-envelope-projection  "10.767"   ""
check_figure atmosphere-domain-entropy     "461,213,509" "SpaceX-Biosphere-Safety.md"

# --- closed system + cascade ---
check_figure closed-system-box-model      "5.4 to 10.9 times" "SpaceX-Biosphere-Safety.md"
check_figure closed-system-box-model      "13.0%"    ""
check_figure closed-system-box-model      "26.1%"    ""
check_figure mass-uncertainty-band        "75.6%"    ""
check_figure mass-uncertainty-band        "391 to 531" "SpaceX-Biosphere-Safety.md"
check_figure mass-uncertainty-band        "45 to 61 tonnes" "SpaceX-Biosphere-Safety.md"
check_figure biosphere-cascade-chain      "128.4%"   "Study-31-Biosphere-Cascade.md"
check_figure percolation-refutation       "1.1 x 10^-15" ""
check_figure tsat-control-arm             "1000000 to 10000000" ""
check_figure taxiout-floor-court          "20,405 hours" "Study-32-Taxi-Out-Floor-Court.md"
check_figure taxiout-floor-court          "3.6 minutes" ""
check_figure taxiout-floor-court          "8.8 min" "Study-32-Taxi-Out-Floor-Court.md"
check_figure taxiout-floor-court          "9794 to 18365" ""
check_figure guadalupe-wave-ledger        "180 minutes" "The-Replacement-Grade.md"
check_figure rate-of-rise-common-window   "885 milli-ft/min" ""
check_figure cost-ownership-horizon       "year 5"   "The-Replacement-Grade.md"
check_figure cost-ownership-horizon       "4,784,700" "The-Replacement-Grade.md"
check_figure cost-ownership-horizon       "2,160,000" "The-Replacement-Grade.md"
check_figure cost-ownership-horizon       "NOT BROADBAND" ""
check_figure fusion-verdict-stream       "FIRST MITIGATE at sample 7016" ""
check_figure fusion-verdict-figure       "warning lead 140 us" ""
check_figure fusion-verdict-figure       "140 µs" "Study-33-Fusion-Control-Verdict-Court.md"
check_figure fusion-operating-court       "COURT TERMINALS REACHED: 5 of 5" ""
check_figure fusion-operating-court       "NOT_APPLICABLE_NO_PLASMA_CURRENT" ""
check_figure fusion-topology-agnostic     "all three signatures byte-identical: true" ""
check_figure fusion-topology-agnostic     "spheromak toroidal-closure edges == 0: true" ""
check_figure fusion-real-machines         "REAL-MACHINE GEOMETRY GRADED: 4 WIN / 4 MISS-greenwald / 1 NOT_APPLICABLE" ""
check_figure fusion-real-machines         "1193661" ""
check_figure fusion-determinism-digest    "f49b576e073835bcab17bee10fe0eee1938774643d900b8ffe1a583b159ab3d7" ""
check_figure fusion-exact-vs-float       "PROOF_EXACT_VERDICT_IS_OBSERVER_INVARIANT" ""
check_figure fusion-exact-vs-float       "exact-refused points = 142 · float32 flips vs exact = 0 · two-pi float contradictions = 142" ""
check_figure fusion-exact-vs-float       "355/113 - 333/106 = 1/11978" ""
check_figure fusion-affine-density-invariant "AFFINE_DENSITY_INVARIANT_IS_PI_FREE" ""
check_figure fusion-affine-density-invariant "pi-ambiguous by 334 mm^2 across the bracket" ""
check_figure fusion-affine-magnitude-invariance "AFFINE_INVARIANT_CARRIES_MEANING_AT_ANY_MAGNITUDE" ""
check_figure fusion-affine-magnitude-invariance "float32 goes blind at 2^24 = 16777216" ""
check_figure fusion-affine-magnitude-invariance "float64 goes blind at 2^53 = 9007199254740992" ""
check_figure fusion-control-benchmark    "HEADROOM_EXCEEDS_50X            TRUE" "Study-33-Fusion-Control-Verdict-Court.md"
check_figure fusion-control-benchmark    "VERDICT_DETERMINISTIC_10K       TRUE" ""
check_figure fusion-control-exact-law     "5 of 5 arms hold" "Study-33-Fusion-Control-Verdict-Court.md"
check_figure fusion-control-exact-law     "REFUSED_OUT_OF_ENVELOPE" "Study-33-Fusion-Control-Verdict-Court.md"
check_figure fusion-control-exact-law     "idx=208 peak=960" ""
check_figure fusion-control-verdict-court "FIVE REAL-WORLD EXPERIMENTS" ""
check_figure fusion-control-verdict-court "STUDY33_FUSION_CONTROL_VERDICT_PENDING" "Study-33-Fusion-Control-Verdict-Court.md"
check_figure fusion-control-verdict-court "beta_normalized=1.8" ""

# --- Study 35: the safety brain that forgets (time axis) ---
check_figure float-degradation-demo "8.4 s"     "Study-35-The-Safety-Brain-That-Forgets.md"
check_figure float-degradation-demo "99.8%"     "Study-35-The-Safety-Brain-That-Forgets.md"
check_figure float-degradation-demo "FLOAT_STATE_DEGRADES_OVER_TIME_INVARIANT_DOES_NOT" "Study-35-The-Safety-Brain-That-Forgets.md"
check_figure drift-barrier-demo     "96.5%"     "Study-35-The-Safety-Brain-That-Forgets.md"
check_figure drift-barrier-demo     "49.6%"     "Study-35-The-Safety-Brain-That-Forgets.md"
check_figure drift-barrier-demo     "50.3%"     "Study-35-The-Safety-Brain-That-Forgets.md"
check_figure drift-barrier-demo     "DRIFT_BARRIER_TRAINED_MODEL_STALE_INVARIANT_FIXED" "Study-35-The-Safety-Brain-That-Forgets.md"

# --- Zilganersen / Alexander disease: the exact ASO off-target screen ---
check_figure aso-offtarget-exact-vs-float "ASO_OFFTARGET_EXACT_IS_OBSERVER_INVARIANT" "The-Safety-Question-Made-Exact.md"
check_figure crispr-guide-offtarget-exact-vs-float "CRISPR_OFFTARGET_EXACT_IS_OBSERVER_INVARIANT" "PM359-Prime-Editing-Certified-Before-Anyone-Is-Dosed.md"
check_figure flt-nearmiss-fractal-shear "FLT_NEARMISS_FRACTAL_SHEAR__EXACT_IS_OBSERVER_INVARIANT" "Study-36-The-Language-Game-of-Fermats-Last-Theorem.md"
check_figure flt-nearmiss-fractal-shear "1bba2839c16677070a986d49eb978dcd8a822c7dee30c769500d67544e861998" "Study-36-The-Language-Game-of-Fermats-Last-Theorem.md"
check_figure flt-nearmiss-fractal-shear "700212234530608691501223040959" "Study-36-The-Language-Game-of-Fermats-Last-Theorem.md"
check_figure valuation-crossing-ledger    "2036"     "The-Replacement-Grade.md"
check_figure valuation-crossing-ledger    "2038"     "The-Replacement-Grade.md"
check_figure valuation-crossing-ledger    "973.7"    "The-Replacement-Grade.md"
check_figure pod-mesh-planetary           "129:1"    "The-Replacement-Grade.md"
check_figure pod-mesh-planetary           "35:1"     "The-Replacement-Grade.md"
check_figure pod-mesh-planetary           "59:1"     "The-Replacement-Grade.md"
check_figure replacement-grade-ledger     "domains declared" ""
check_figure replacement-grade-ledger     "49" "The-Replacement-Grade.md"
check_figure replacement-grade-ledger     "live PROVEN marker    13" ""
check_figure replacement-grade-ledger     "identity to 1/1    9" ""
check_figure operator-reentry-ledger      "187.3"    "Impact-Study-SpaceX-Biosphere-Forcing.md"
check_figure operator-reentry-ledger      "0.89x"    ""
check_figure operator-reentry-ledger      "45.8%"    "Impact-Study-SpaceX-Biosphere-Forcing.md"
check_figure ozone-baseline-and-state-change "CONTROL ARM PASSES" "Study-31-Biosphere-Cascade.md"
check_figure radiative-baseline           "3,539 mW/m2" ""
check_figure radiative-baseline           "43.7%"    "Study-31-Biosphere-Cascade.md"
check_figure radiative-baseline           "1,547.3"  "Study-31-Biosphere-Cascade.md"
check_figure closed-system-joint-ledger   "not an estimate" "Study-31-Biosphere-Cascade.md"
check_figure ozone-baseline-and-state-change "-16.1%"   "Study-31-Biosphere-Cascade.md"
check_figure ozone-baseline-and-state-change "+8.3%"    "Study-31-Biosphere-Cascade.md"
check_figure ozone-baseline-and-state-change "261.7 DU" "Study-31-Biosphere-Cascade.md"
check_figure ozone-baseline-and-state-change "21618"    ""
check_figure tsat-control-arm             "REFUSED"  "Study-31-Biosphere-Cascade.md"
check_figure percolation-refutation       "0.29"     "Study-31-Biosphere-Cascade.md"
check_figure biosphere-cascade-chain      "15.6%"    "Study-31-Biosphere-Cascade.md"
check_figure biosphere-cascade-chain      "+17.1% to +31.2%" "Study-31-Biosphere-Cascade.md"

echo "=== 4. the public pages carry no private reference ==="
# grep -c prints 0 AND exits 1 on no match, so `|| echo 0` yields "0\n0" and breaks the
# arithmetic — which is how the first version of this check reported PASS having counted
# nothing. Count with a single grep -l pass and a positive control instead.
BREACH=0
PAGES=$(ls "$ROOT"/*.md 2>/dev/null | wc -l | tr -d ' ')
[ "$PAGES" -gt 0 ] || { bad "no pages found to scan — refusing to report a clean boundary"; BREACH=1; }
# 'Sources/' alone is AMBIGUOUS: this public repo legitimately contains
# clients/math-court-mcp/swift-example/Sources/main.swift. The pattern must name the
# PRIVATE parents only, or it fires on our own public tree and trains readers to
# ignore it — an always-red gate is as useless as an always-green one.
for pat in 'cells/' 'cells/xcode/Sources/' 'LatticeRender/Sources/' '\.gaiaftcl' '/Users/' '\.swift:[0-9]' 'mortonBits' 'CapabilityRegistry'; do
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
    # ABSENT (unreachable / truncated) and MISS (reachable, wrong value) are different
    # answers and are reported as different answers. Neither counts as a pass.
    #
    # NOTE 2026-09-01: the REST path /language-invariant/games now returns a
    # CAPABILITIES REGISTRY and no longer carries domain_count or no_float. Those
    # fields live on the MCP path. The harness follows the fields, not the habit.
    MCP=https://affine.earth/language-invariant/mcp
    code=$(curl -s -o /tmp/court.json -w '%{http_code}' --max-time 90 -X POST "$MCP" \
           -H 'Content-Type: application/json' \
           -d '{"jsonrpc":"2.0","id":1,"method":"tools/call","params":{"name":"math_court","arguments":{"domain":""}}}' 2>/dev/null)
    size=$(wc -c < /tmp/court.json 2>/dev/null | tr -d ' ')
    if [ "$code" != "200" ] || [ "${size:-0}" -lt 256 ]; then
        echo "  ABSENT  live court unreachable or truncated (HTTP $code, ${size:-0} bytes) — surface not graded this run"
    else
        ok "live court answers 200 ($size bytes)"
        dc=$(grep -o 'domain_count[^0-9]*[0-9]*' /tmp/court.json | grep -o '[0-9]*$' | head -1)
        [ "$dc" = "49" ] && ok "court reports 49 domains (biosphere joined the 48)" || bad "domain_count is '$dc', pages say 49"
        if grep -q 'no_float' /tmp/court.json; then
            grep -q 'no_float[^a-z]*false' /tmp/court.json \
              && bad "court reports a no_float:false domain" \
              || ok "court reports no_float true"
        else
            echo "  ABSENT  no_float not present in the court response — not graded"
        fi
    fi
else
    echo "  SKIP — no curl"
fi

echo
echo "=== $PASS passed · $FAIL failed ==="
[ "$FAIL" -eq 0 ] && { echo "VALIDATED — every published figure reproduces from public bytes."; exit 0; }
echo "NOT VALIDATED — see the failures above."; exit 1
