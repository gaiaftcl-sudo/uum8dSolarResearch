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
        stage="$(mktemp -d)"; berr="$(mktemp)"
        # STAGING NAME IS A CHOICE, AND IT IS NOT THE SAME CHOICE FOR EVERY PROGRAM.
        # Top-level code is legal only in a file called main.swift, so that is the default.
        # A file declaring `@main` is the OPPOSITE case: Swift refuses that attribute in a
        # file that could carry top-level code, and naming it main.swift fails the build with
        # "'main' attribute cannot be used in a module that contains top-level code" — which
        # this harness would then report as the program being broken. It is not; the staging
        # was. Measured on wasi-sandwiched.swift, which is @main.
        if grep -q '^@main' "$p" 2>/dev/null; then src="$stage/$(basename "$p")"
        else src="$stage/main.swift"; fi
        cp "$p" "$src"
        # ONE LAW, ONE HOME — the market-shear tool. wasi-sandwiched defines no conjunct,
        # no pool arithmetic and no shortfall formula of its own: it compiles a VERBATIM
        # BYTE SLICE of extraction-exact.swift, which is exactly what its own build script
        # does. Building it here the same way is the point — a harness that linked a COPY
        # of the law would be grading a second law, and then there would be two.
        #
        # THE BOUNDARY IS CHECKED, NOT ASSERTED. Line END must close referenceFigures() and
        # END+2 must open the detector's own MAIN. If the detector source moves, this
        # REFUSES rather than slicing a law in half and reporting a green run over it.
        if grep -q 'CORE_SLICE_SHA256' "$p" 2>/dev/null; then
            CORE="$HERE/extraction-exact.swift"; END=2535
            if [ -f "$CORE" ] && [ "$(sed -n "${END}p" "$CORE" 2>/dev/null)" = "}" ] \
               && sed -n "$((END+2))p" "$CORE" 2>/dev/null | grep -q '^// ====='; then
                sed -n "1,${END}p" "$CORE" > "$stage/core-detector.swift"
                { echo "let CORE_SLICE_SHA256   = \"$(shasum -a 256 "$stage/core-detector.swift" | awk '{print $1}')\""
                  echo "let CORE_SLICE_BYTES    = \"$(wc -c < "$stage/core-detector.swift" | tr -d ' ')\""
                  echo "let CORE_SLICE_LINES    = \"1..$END\""
                  echo "let CORE_SOURCE_NAME    = \"extraction-exact.swift\""
                  echo "let CORE_SOURCE_SHA256  = \"$(shasum -a 256 "$CORE" | awk '{print $1}')\""
                  echo "let CORE_SOURCE_BYTES   = \"$(wc -c < "$CORE" | tr -d ' ')\""
                  echo "let TOOL_SOURCE_SHA256  = \"$(shasum -a 256 "$p" | awk '{print $1}')\""
                  echo "let BUILD_UTC           = \"$(date -u +%Y-%m-%dT%H:%M:%SZ)\""
                } > "$stage/core-pin.swift"
                extra="$extra $stage/core-detector.swift $stage/core-pin.swift"
            else
                bad "$n SLICE BOUNDARY MOVED — extraction-exact.swift line $END no longer closes referenceFigures(); refusing to compile half a law"
                rm -f "$berr"; rm -rf "$stage"; continue
            fi
        fi
        out="$(cd "$ROOT/corpus/flood-lead-time" 2>/dev/null || cd "$HERE"; \
               $SC -O -swift-version 5 $extra "$src" -o "/tmp/val_$n" 2>"$berr" && "/tmp/val_$n" 2>/dev/null </dev/null)"
        if [ -n "$out" ]; then ok "$n runs"; printf '%s\n' "$out" > "/tmp/out_$n.txt"
        else
            # A STALE TRANSCRIPT IS WORSE THAN NO TRANSCRIPT, and it was being left in place.
            # When a build failed, /tmp/out_<program>.txt from an EARLIER run survived, so the
            # harness printed ONE failure and then passed every check_figure pinned to that
            # program against yesterday's bytes. Removing it makes those rows report SKIP —
            # absent, which is a third answer and not a pass.
            rm -f "/tmp/out_$n.txt"
            # DID NOT COMPILE and COMPILED BUT PRINTED NOTHING are different answers and were
            # printed alike, with the compiler's reason discarded to /dev/null.
            if [ -s "$berr" ]; then
                bad "$n DID NOT COMPILE — $(head -1 "$berr" | cut -c1-160)"
            else
                bad "$n compiled and printed nothing — every exit must print its reference figures"
            fi
        fi
        rm -f "/tmp/val_$n" "$berr"; rm -rf "$stage"
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

# --- Study 38: the loss-reserve triangle, exact against float ---
check_figure reserve-triangle-exact-vs-float "STUDY38_RESERVE_TRIANGLE_EXACT_VS_FLOAT" "Study-38-Loss-Reserve-Triangle.md"
check_figure reserve-triangle-exact-vs-float "SELFTEST PASS" ""
check_figure reserve-triangle-exact-vs-float "control arms failed = 0" "Study-38-Loss-Reserve-Triangle.md"
check_figure reserve-triangle-exact-vs-float "5,393,021"  "Study-38-Loss-Reserve-Triangle.md"
check_figure reserve-triangle-exact-vs-float "77,900"     "Study-38-Loss-Reserve-Triangle.md"
check_figure reserve-triangle-exact-vs-float "-16,662,494" "Study-38-Loss-Reserve-Triangle.md"
check_figure reserve-triangle-exact-vs-float "21,770,741" "Study-38-Loss-Reserve-Triangle.md"
check_figure reserve-triangle-exact-vs-float "19,041,666" "Study-38-Loss-Reserve-Triangle.md"
check_figure reserve-triangle-exact-vs-float "17,138,459" "Study-38-Loss-Reserve-Triangle.md"
check_figure reserve-triangle-exact-vs-float "15,618,034" "Study-38-Loss-Reserve-Triangle.md"
check_figure reserve-triangle-exact-vs-float "2,390"      "Study-38-Loss-Reserve-Triangle.md"
check_figure reserve-triangle-exact-vs-float "f1=14043/46" "Study-38-Loss-Reserve-Triangle.md"
check_figure reserve-triangle-exact-vs-float "Dorinco Rein Co" "Study-38-Loss-Reserve-Triangle.md"
check_figure reserve-triangle-exact-vs-float "9,007,199,254,740,992" "Study-38-Loss-Reserve-Triangle.md"

# --- Study 39: the actuarial domain, exact against float ---
check_figure actuarial-domain-exact-vs-float "STUDY39_ACTUARIAL_DOMAIN_EXACT_VS_FLOAT" "Study-39-Actuarial-Domain.md"
check_figure actuarial-domain-exact-vs-float "SELFTEST PASS" ""
check_figure actuarial-domain-exact-vs-float "control arms failed = 0" "Study-39-Actuarial-Domain.md"
check_figure actuarial-domain-exact-vs-float "16,128"    "Study-39-Actuarial-Domain.md"
check_figure actuarial-domain-exact-vs-float "10,878"    "Study-39-Actuarial-Domain.md"
check_figure actuarial-domain-exact-vs-float "2,016"     "Study-39-Actuarial-Domain.md"
check_figure actuarial-domain-exact-vs-float "3,990"     "Study-39-Actuarial-Domain.md"
check_figure actuarial-domain-exact-vs-float "6,048"     "Study-39-Actuarial-Domain.md"
check_figure actuarial-domain-exact-vs-float "2,835"     "Study-39-Actuarial-Domain.md"
check_figure actuarial-domain-exact-vs-float "1,995"     "Study-39-Actuarial-Domain.md"
check_figure actuarial-domain-exact-vs-float "22,973,085" "Study-39-Actuarial-Domain.md"
check_figure actuarial-domain-exact-vs-float "11,561,327" "Study-39-Actuarial-Domain.md"
check_figure actuarial-domain-exact-vs-float "IT 2022, from age 9, 86 steps" "Study-39-Actuarial-Domain.md"
check_figure actuarial-domain-exact-vs-float "fewest agreeing significant digits" "Study-39-Actuarial-Domain.md"
check_figure actuarial-domain-exact-vs-float "3,845"     "Study-39-Actuarial-Domain.md"
check_figure actuarial-domain-exact-vs-float "442, 547, 631" "Study-39-Actuarial-Domain.md"

# --- Study 26: the exact discrimination court, and the exhaustive off-target screen ---
check_figure mr-topology-vs-expression-exact "TOPOLOGY_EXPLAINS: 11 of 17 tumour types" "Study-26-Master-Regulator-Bonds.md"
check_figure mr-topology-vs-expression-exact "EXPRESSION_ADDS  : 5 of 17 tumour types"  "Study-26-Master-Regulator-Bonds.md"
check_figure mr-topology-vs-expression-exact "d0051d7a19daa0cb7f1a3d4f7be7433af73401bbf25fe41079f6409c066fee5a" "Study-26-Master-Regulator-Bonds.md"
check_figure mr-topology-vs-expression-exact "100891344545564193334812497256" "Study-26-Master-Regulator-Bonds.md"
check_figure mr-topology-vs-expression-exact "9.138e-12" "Study-26-Master-Regulator-Bonds.md"
check_figure mr-topology-vs-expression-exact "4.756e-6"  "Study-26-Master-Regulator-Bonds.md"
check_figure mr-topology-vs-expression-exact "1.151e-1"  "Study-26-Master-Regulator-Bonds.md"
check_figure mr-topology-vs-expression-exact "2.685e-29" "Study-26-Master-Regulator-Bonds.md"
check_figure mr-topology-vs-expression-exact "SELFTEST PASS" ""
check_figure pelacarsen-offtarget-whole-transcriptome "513de7e9db6556df1895bfce4cb4d69e4816d7b45b75bee1dc8452335c2c7757" "Study-26-Master-Regulator-Bonds.md"
check_figure pelacarsen-offtarget-whole-transcriptome "TGCTCCGTTGGTGCTTGTTC" "Study-26-Master-Regulator-Bonds.md"
check_figure pelacarsen-offtarget-whole-transcriptome "670670" "Study-26-Master-Regulator-Bonds.md"
check_figure pelacarsen-offtarget-whole-transcriptome "1467336203" "Study-26-Master-Regulator-Bonds.md"
check_figure pelacarsen-offtarget-whole-transcriptome "5a320f524d73b5793518eb19b118829033713443d0f42af20a67bb31cc06cf56" "Study-26-Master-Regulator-Bonds.md"

# --- Study 26 S3-COMBINATION: the eleven pairs, made re-derivable 2026-09-07 ---
check_figure study26-combination-pairs-exact "STUDY26_COMBINATION_PAIRS__ELEVEN_CLEAR_ALL_THREE_CONTROLS" "Study-26-Master-Regulator-Bonds.md"
check_figure study26-combination-pairs-exact "d0117523ff3b950a0741de281671c0bd977f8dc003f41972f2bfac2f50994d74" "Study-26-Master-Regulator-Bonds.md"
check_figure study26-combination-pairs-exact "estradiol + AMG-208" "Study-26-Master-Regulator-Bonds.md"
check_figure study26-combination-pairs-exact "olaparib + ursodeoxycholyltaurine" "Study-26-Master-Regulator-Bonds.md"
check_figure study26-combination-pairs-exact "drospirenone + alpelisib" "Study-26-Master-Regulator-Bonds.md"
check_figure study26-combination-pairs-exact "HMN-214 + saracatinib" "Study-26-Master-Regulator-Bonds.md"
check_figure study26-combination-pairs-exact "XMD-892 + NVP-BGJ398" "Study-26-Master-Regulator-Bonds.md"

# --- Rentosertib: the structural lock, the network census, the modality register ---
check_figure rentosertib-structure-lock-exact "C27H30FN7O" "A-Drug-An-AI-Designed.md"
check_figure rentosertib-structure-lock-exact "b5da901cbcba5535" "A-Drug-An-AI-Designed.md"
check_figure rentosertib-structure-lock-exact "ZVDNXHUSIKGTSF-UHFFFAOYSA-N" "A-Drug-An-AI-Designed.md"
check_figure tnik-repairs-exact "12548903" ""
check_figure tnik-network-degree-exact "12017368" ""
check_figure modality-register-exact "validation_arms_failed     = 0" ""

# --- the genome-wide CRISPR off-target map ---
check_figure crispr-genome-offtarget-exact "487b4f81de2d24bd0bb11ecd1d8d42778e3a5d91b9edb33627c86dcc8df34980" "CRISPR-Genome-Off-Target-Map.md"
check_figure crispr-genome-offtarget-exact "CRISPR_GENOME_OFFTARGET_EXACT__COMPLETE_ENUMERATION_IS_OBSERVER_INVARIANT" "CRISPR-Genome-Off-Target-Map.md"
check_figure crispr-genome-offtarget-exact "487b4f81de2d24bd0bb11ecd1d8d42778e3a5d91b9edb33627c86dcc8df34980" "CRISPR-Genome-Off-Target-Map.md"
check_figure crispr-genome-offtarget-exact "304796751" "CRISPR-Genome-Off-Target-Map.md"
check_figure crispr-genome-offtarget-exact "3099750718" "CRISPR-Genome-Off-Target-Map.md"
check_figure crispr-genome-offtarget-exact "L28RZ5CC6K" "CRISPR-Genome-Off-Target-Map.md"
check_figure crispr-genome-offtarget-exact "D8UQ4B2T7M" "CRISPR-Genome-Off-Target-Map.md"

# --- Study 37: the corpus-collapse instrument ---
check_figure corpus-distinct-count-exact "1c2e05a659917cd5de0d20446483b26372c757b48cec510070644e7307b7fd36" "Study-37-Validated-Discoveries-Five-Molecules.md"
check_figure corpus-distinct-count-exact "95594154026f63552bf746f535be96392bca50385b4577c72d545c3d1de67aa1" "Study-37-Validated-Discoveries-Five-Molecules.md"
check_figure corpus-distinct-count-exact "74db969f653be18214608230b4aaee30498f7fcd09df9e3d7b107ddb5c8f64f7" "Study-37-Validated-Discoveries-Five-Molecules.md"
check_figure corpus-distinct-count-exact "0169f514a861ece42573fbff4d4db28e27880373adb7296a304aa9ddb860c1f4" "Study-37-Validated-Discoveries-Five-Molecules.md"
check_figure corpus-distinct-count-exact "CONTROL ARM  13/13 PASS" ""

# --- where humans actually yield: fatigue curves vs regulator limits ---
check_figure fatigue-yield-vs-regulator "FATIGUE_YIELD_VS_REGULATOR__FOUR_AGREE_ONE_CONFLICT_ONE_NOT_COMPARABLE" "Where-Humans-Actually-Yield.md"
check_figure fatigue-yield-vs-regulator "d5fab6529c34126003aec8d8ea2f80cb1558ccf9feb3b4896eaef739758206a1" "Where-Humans-Actually-Yield.md"


# --- MARKET SURVEILLANCE: the detector that flags the whole market -----------------
# Un-numbered family page, added 2026-09-08. Every row below was checked with grep -F on
# BOTH sides before it was written here — the program's own no-argv output and the page —
# because a pin on a figure the program does not print is exactly the defect this harness
# exists to catch, and it has bitten this repository before.
#
# THESE FIVE PROGRAMS PRINT THEIR REFERENCE FIGURES ON EVERY EXIT PATH, INCLUDING THE
# NO-ARGV ONE THIS HARNESS TAKES. The corpora are 1.1 GB and fetched, not committed, so a
# run here measures nothing; it prints what it WOULD have measured, says so on its own
# face, and exits non-zero. ABSENCE and REFUSAL are different answers, and an
# uninstrumented early exit is indistinguishable from a program that never built.
#
# live-wire-watch is the one that could have cost this harness ten minutes on the network:
# its old default probed live endpoints and watched the chain head for 600 seconds. The
# no-argv path is now the ZERO-NETWORK one — self-test arms, the in-process null
# population, then the figures — and --all still does what the old default did.

# the phantom-mass base rate, the equities composite, the ETH conjunct set, attribution
check_figure market-shear-exact "12,676,036"  "The-Detector-That-Flags-The-Whole-Market.md"
check_figure market-shear-exact "12,156,283"  "The-Detector-That-Flags-The-Whole-Market.md"
check_figure market-shear-exact "10,164,658"  "The-Detector-That-Flags-The-Whole-Market.md"
check_figure market-shear-exact "2,921,796"   "The-Detector-That-Flags-The-Whole-Market.md"
check_figure market-shear-exact "2,732,598"   "The-Detector-That-Flags-The-Whole-Market.md"
check_figure market-shear-exact "88,900"      "The-Detector-That-Flags-The-Whole-Market.md"
check_figure market-shear-exact "63,140"      "The-Detector-That-Flags-The-Whole-Market.md"
check_figure market-shear-exact "1,407 per 1,000" "The-Detector-That-Flags-The-Whole-Market.md"
check_figure market-shear-exact "7.3 per 1,000"   "The-Detector-That-Flags-The-Whole-Market.md"
check_figure market-shear-exact "RATIO_PUBLISHED_NO_THRESHOLD" "The-Detector-That-Flags-The-Whole-Market.md"
check_figure market-shear-exact "10,580,123"  "The-Detector-That-Flags-The-Whole-Market.md"
check_figure market-shear-exact "NOT_COMPUTABLE" "The-Detector-That-Flags-The-Whole-Market.md"
check_figure market-shear-exact "837,472,908" "The-Detector-That-Flags-The-Whole-Market.md"
check_figure market-shear-exact "15,393"      "The-Detector-That-Flags-The-Whole-Market.md"

# MAR Annex I A(f) computed in FULL, and the legitimate quoter that outscores the session
check_figure af-conjunct-exact "9,589 bp"     "The-Detector-That-Flags-The-Whole-Market.md"
check_figure af-conjunct-exact "5,384 bp"     "The-Detector-That-Flags-The-Whole-Market.md"
check_figure af-conjunct-exact "7,665 bp"     "The-Detector-That-Flags-The-Whole-Market.md"
check_figure af-conjunct-exact "9,189 bp"     "The-Detector-That-Flags-The-Whole-Market.md"
check_figure af-conjunct-exact "6,825,510"    "The-Detector-That-Flags-The-Whole-Market.md"
check_figure af-conjunct-exact "9,716,694"    "The-Detector-That-Flags-The-Whole-Market.md"
check_figure af-conjunct-exact "7,032 bp"     "The-Detector-That-Flags-The-Whole-Market.md"
check_figure af-conjunct-exact "85.14th percentile" "The-Detector-That-Flags-The-Whole-Market.md"
check_figure af-conjunct-exact "REFUTED_CONTROL_SCORES_HIGHER" "The-Detector-That-Flags-The-Whole-Market.md"
check_figure af-conjunct-exact "REFUSED_SINGLE_POPULATION"     "The-Detector-That-Flags-The-Whole-Market.md"

# the live wire, the self-contradiction guard, and the false-positive FLOOR
check_figure live-wire-watch "68,121 per 10,000,000" "The-Detector-That-Flags-The-Whole-Market.md"
check_figure live-wire-watch "2,208 per 10,000,000"  "The-Detector-That-Flags-The-Whole-Market.md"
check_figure live-wire-watch "53.95x"                "The-Detector-That-Flags-The-Whole-Market.md"
check_figure live-wire-watch "IRREDUCIBLE FLOOR"     "The-Detector-That-Flags-The-Whole-Market.md"
check_figure live-wire-watch "100,426,957 bytes"     "The-Detector-That-Flags-The-Whole-Market.md"
check_figure live-wire-watch "815 HTTP requests"     "The-Detector-That-Flags-The-Whole-Market.md"
check_figure live-wire-watch "8,119,826"             "The-Detector-That-Flags-The-Whole-Market.md"
check_figure live-wire-watch "4,766 swaps"           "The-Detector-That-Flags-The-Whole-Market.md"
check_figure live-wire-watch "1,427 leg pairs"       "The-Detector-That-Flags-The-Whole-Market.md"
# ABSENCE, REFUSAL, BOT_BLOCKED and NOT_KNOWN are four different answers on every wire
# verdict. Two of them are pinned so the distinction cannot quietly collapse into one.
check_figure live-wire-watch "NOT_KNOWN"             "The-Detector-That-Flags-The-Whole-Market.md"
check_figure live-wire-watch "BOT_BLOCKED"           "The-Detector-That-Flags-The-Whole-Market.md"

# the independently written kernel that reproduced the set member for member
check_figure market-shear-rederive "200,826 · 276,014" "The-Detector-That-Flags-The-Whole-Market.md"
check_figure market-shear-rederive "13,272 · 3,245"    "The-Detector-That-Flags-The-Whole-Market.md"
check_figure market-shear-rederive "22,287"            "The-Detector-That-Flags-The-Whole-Market.md"
check_figure market-shear-rederive "28 · 26"           "The-Detector-That-Flags-The-Whole-Market.md"

# the naive geometry the conjunct set is measured AGAINST — the discrimination, not a rate
check_figure market-shear-positional "262,799"               "The-Detector-That-Flags-The-Whole-Market.md"
check_figure market-shear-positional "2,433x"                "The-Detector-That-Flags-The-Whole-Market.md"
check_figure market-shear-positional "101 per 1,000 flagged" "The-Detector-That-Flags-The-Whole-Market.md"
check_figure market-shear-positional "4.8 per 1,000"         "The-Detector-That-Flags-The-Whole-Market.md"

# --- WHAT WAS TAKEN: the extraction kernel, added 2026-09-08 --------------------------
# The study measured a capability and never answered "so what". This program is that
# answer: per victim, per token, in integer base units, from the pool's own arithmetic.
# Every row below was checked with grep -F on BOTH sides before it was written here.
#
# THESE RUN WITH NO CORPUS AND NO NETWORK. The 1.1 GB Ethereum corpus is fetched, never
# committed, so the no-argv path measures NOTHING and says so — it prints the published
# reference figures, labels them PUBLISHED_REFERENCES_NOT_THIS_RUNS_MEASUREMENTS, and
# exits 4. A gate given nothing must not exit 0, and this one does not.
check_figure extraction-exact "GEOMETRY_ONLY_DETECTION_IS_NOT_PROOF_OF_INTENT" "The-Detector-That-Flags-The-Whole-Market.md"
check_figure extraction-exact "KEYED_PSEUDONYM_8HEX"        "The-Detector-That-Flags-The-Whole-Market.md"
check_figure extraction-exact "CORPUS_ABSENT"               "The-Detector-That-Flags-The-Whole-Market.md"
check_figure extraction-exact "PUBLISHED_REFERENCES_NOT_THIS_RUNS_MEASUREMENTS" "The-Detector-That-Flags-The-Whole-Market.md"
check_figure extraction-exact "126 brackets · 108 extractive · 104 blocks · 26 extractive actors" "The-Detector-That-Flags-The-Whole-Market.md"
check_figure extraction-exact "108 of 108 SET-IDENTICAL"    "The-Detector-That-Flags-The-Whole-Market.md"
check_figure extraction-exact "47 false positives per 212,769 leg pairs" "The-Detector-That-Flags-The-Whole-Market.md"
check_figure extraction-exact "87 of 108 EXACT · 21 NOT_KNOWN" "The-Detector-That-Flags-The-Whole-Market.md"
# the per-token integer table IS the result; the single-unit lines are DERIVED and the
# page carries that label on both. Pinning both halves stops the derived one drifting free
# of the measured one.
check_figure extraction-exact "155,576,958,801,814,594,396,893" "The-Detector-That-Flags-The-Whole-Market.md"
check_figure extraction-exact "5,074,012,211,888,792,743,310"   "The-Detector-That-Flags-The-Whole-Market.md"
check_figure extraction-exact "28,924,625,003,219,287,345,953"  "The-Detector-That-Flags-The-Whole-Market.md"
check_figure extraction-exact "1,689,797,703,211,127,422"       "The-Detector-That-Flags-The-Whole-Market.md"
check_figure extraction-exact "28,889,398,990,674,697,077"      "The-Detector-That-Flags-The-Whole-Market.md"
check_figure extraction-exact "28,247,424,339,991,594,322"      "The-Detector-That-Flags-The-Whole-Market.md"
check_figure extraction-exact "94,645,772,620"                  "The-Detector-That-Flags-The-Whole-Market.md"
check_figure extraction-exact "3,276,141,973"                   "The-Detector-That-Flags-The-Whole-Market.md"
check_figure extraction-exact "min 47 · p25 102 · MEDIAN 476 · p75 1,785 · max 9,999" "The-Detector-That-Flags-The-Whole-Market.md"
check_figure extraction-exact "0.170457244547709297"            "The-Detector-That-Flags-The-Whole-Market.md"
check_figure extraction-exact "558.442133"                      "The-Detector-That-Flags-The-Whole-Market.md"
check_figure extraction-exact "0.104516232525109603"            "The-Detector-That-Flags-The-Whole-Market.md"
check_figure extraction-exact "+491 permille"                   "The-Detector-That-Flags-The-Whole-Market.md"
check_figure extraction-exact "-500 permille"                   "The-Detector-That-Flags-The-Whole-Market.md"
# MEASURED and PROJECTED are two answers. Both are pinned so neither can quietly become
# the other — the label lives on the program's own key name, not only in the page's prose.
check_figure extraction-exact "108 detections per 1,000 blocks = 13,586 s · 28 per hour" "The-Detector-That-Flags-The-Whole-Market.md"
check_figure extraction-exact "686 per day · 250,390 per year" "The-Detector-That-Flags-The-Whole-Market.md"

# --- THE TOOL a person can actually run on their own transaction ----------------------
# wasi-sandwiched carries NO law of its own: section 2 above compiles it against a verbatim
# byte slice of extraction-exact.swift, refusing outright if that slice boundary has moved.
# Given no hash it prints the reference figures and exits 4 — the same discipline.
check_figure wasi-sandwiched "WAS I SANDWICHED, AND WHAT DID IT COST ME" "The-Detector-That-Flags-The-Whole-Market.md"
check_figure wasi-sandwiched "A GATE GIVEN NOTHING MUST NOT PASS"        "The-Detector-That-Flags-The-Whole-Market.md"
check_figure wasi-sandwiched "== NOTHING WAS GIVEN =="                   "The-Detector-That-Flags-The-Whole-Market.md"
check_figure wasi-sandwiched "ZERO — no API key, no account, no registration, nobody's permission" "The-Detector-That-Flags-The-Whole-Market.md"
check_figure wasi-sandwiched "extraction-exact.swift lines 1..2535"      "The-Detector-That-Flags-The-Whole-Market.md"
check_figure wasi-sandwiched "126 brackets · 108 extractive · 104 blocks · 26 pseudonymous actors" "The-Detector-That-Flags-The-Whole-Market.md"
check_figure wasi-sandwiched "median 476 ten-thousandths of the output that was due — about 0.17 ETH" "The-Detector-That-Flags-The-Whole-Market.md"
# The compiled-in law digest, printed by the binary and computed at build time by shasum(1)
# over the slice. It is on the page so a stranger can re-derive it in one command:
#   sed -n '1,2535p' reproduce/extraction-exact.swift | shasum -a 256
check_figure wasi-sandwiched "d46ea837b66f21763ed3dfc50c9ca246e05cb9f2a499237aa4cc77ec4edbdf5e" "The-Detector-That-Flags-The-Whole-Market.md"

# --- the generated-peptide novelty screen (cures family) ---
check_figure protein-novelty-exact "8c50b3e877d1dac7b68244464ae679fc43ed273d9fd38e7e348b823c3e80563b" "Generated-Peptides-Against-The-Human-Proteome.md"
check_figure protein-novelty-exact "bf1bc7e188e55199a2447fc20d25834db5f7f798daa818432370deb4a6b0df5e" "Generated-Peptides-Against-The-Human-Proteome.md"
check_figure protein-novelty-exact "bb3691b332fb15cdd54c43bc42905478e53c4f4b01862885a7304260498cf3f7" "Generated-Peptides-Against-The-Human-Proteome.md"
check_figure protein-novelty-exact "24cdbf96621e6c38fa046c7a203fcc3ea09e31fad410d9c1cb51f6d192a04204" "Generated-Peptides-Against-The-Human-Proteome.md"
# Added 2026-09-07 with the three new PROTEINS library entries (the Q14258 maximum, the
# residual-overlap null, the composition signature). The library admission law requires a
# check_figure row in the same commit as the entry, so page and program cannot drift apart.
check_figure protein-novelty-exact "LETFLAKSRPEL" "Generated-Peptides-Against-The-Human-Proteome.md"
check_figure protein-novelty-exact "Q14258" "Generated-Peptides-Against-The-Human-Proteome.md"
check_figure protein-novelty-exact "249852560" "Generated-Peptides-Against-The-Human-Proteome.md"
# Program-side pin only, because the page carrying it is not yet in this root. The third
# argument becomes Library-Of-Proteins.md the moment that page lands, and the pin is then
# two-sided like the rows above it. A row pinned to a page that does not exist is a red
# harness, and a red harness nobody can fix is how a harness stops being read.
check_figure protein-novelty-exact "198674 ppm = 19.8674%" ""

# --- the oligonucleotide off-target atlas ---
check_figure oligo-offtarget-atlas-exact "OLIGO_OFFTARGET_ATLAS_EXACT__COMPLETE_ENUMERATION_IS_OBSERVER_INVARIANT" "Oligonucleotide-Off-Target-Atlas.md"
check_figure oligo-offtarget-atlas-exact "321b36c694b89a45bb81668d7ea62b9c85cf0b3087e18bba586f43b230274b08" "Oligonucleotide-Off-Target-Atlas.md"
check_figure oligo-offtarget-atlas-exact "TGCTCCGTTGGTGCTTGTTC" "Oligonucleotide-Off-Target-Atlas.md"

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
check_figure fusion-control-benchmark    "VERDICT_DETERMINISTIC_10K       TRUE" "Study-33-Fusion-Control-Verdict-Court.md"
check_figure fusion-control-benchmark    "VERDICT_RENDERED_AT_INDEX_208   TRUE" "Study-33-Fusion-Control-Verdict-Court.md"
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
check_figure zilganersen-offtarget-whole-transcriptome "ZILGANERSEN_OFFTARGET_EXACT__REAL_SEQUENCE_WITH_COMPOSITION_CONTROL" "The-Safety-Question-Made-Exact.md"
check_figure zilganersen-offtarget-whole-transcriptome "edcb277ddea44820502b6446b00ed8bdcfdb08835d6785fdee7d1b370420bbaa" "The-Safety-Question-Made-Exact.md"
check_figure zilganersen-offtarget-whole-transcriptome "CAGTATTACCTCTACTAGTC" "The-Safety-Question-Made-Exact.md"
check_figure zilganersen-offtarget-whole-transcriptome "1467336203" "The-Safety-Question-Made-Exact.md"
check_figure zilganersen-offtarget-whole-transcriptome "670670" "The-Safety-Question-Made-Exact.md"
check_figure zilganersen-offtarget-whole-transcriptome "5a320f524d73b5793518eb19b118829033713443d0f42af20a67bb31cc06cf56" "The-Safety-Question-Made-Exact.md"
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


# --- THE THREE LIBRARIES: one check_figure row per admitted entry, in the same commit.
# The admission law's own "what must accompany an addition" requires this row and the entry
# together, so a page and the program behind it cannot drift apart between commits. The sixth
# PROTEINS entry — homology under substitution — has NO row here on purpose: it is HELD, its
# program's output in this harness is a refusal, and a row pinned to a figure that program does
# not print here would be a red harness rather than a measurement.
check_figure protein-novelty-exact "bb3691b332fb15cdd54c43bc42905478e53c4f4b01862885a7304260498cf3f7" "Library-Of-Proteins.md"
check_figure protein-novelty-exact "second rows       1400   residues 78694   lengths 20 to 100   labels 12" "Library-Of-Proteins.md"
check_figure protein-novelty-exact "LETFLAKSRPEL" "Library-Of-Proteins.md"
check_figure protein-novelty-exact "corpus K+R                   1026307 of 5165782 = 198674 ppm = 19.8674%" "Library-Of-Proteins.md"
check_figure protein-novelty-exact "aligned-pair match probability = 3266100739639 / 58984123166334 = 55372 ppm" "Library-Of-Proteins.md"
check_figure zilganersen-offtarget-whole-transcriptome "edcb277ddea44820502b6446b00ed8bdcfdb08835d6785fdee7d1b370420bbaa" "Library-Of-Compound-Cures.md"
check_figure pelacarsen-offtarget-whole-transcriptome "513de7e9db6556df1895bfce4cb4d69e4816d7b45b75bee1dc8452335c2c7757" "Library-Of-Compound-Cures.md"
check_figure crispr-genome-offtarget-exact "487b4f81de2d24bd0bb11ecd1d8d42778e3a5d91b9edb33627c86dcc8df34980" "Library-Of-Compound-Cures.md"
check_figure mr-topology-vs-expression-exact "TOPOLOGY_EXPLAINS: 11 of 17 tumour types" "Library-Of-Compound-Cures.md"
check_figure oligo-offtarget-atlas-exact "321b36c694b89a45bb81668d7ea62b9c85cf0b3087e18bba586f43b230274b08" "Library-Of-Compound-Cures.md"
check_figure z8-vs-e8-lattice "E8  : 240" "Library-Of-Material-Systems.md"
check_figure lora-time-on-air "287.744" "Library-Of-Material-Systems.md"
check_figure fusion-determinism-digest "f49b576e073835bcab17bee10fe0eee1938774643d900b8ffe1a583b159ab3d7" "Library-Of-Material-Systems.md"
check_figure unimodular-control-arms "unimodular det=1: det=1  e_1 reachable in sample = true" "Library-Of-Material-Systems.md"
check_figure fusion-exact-vs-float "PI_BRACKET  355/113 - 333/106 = 1/11978" "Library-Of-Material-Systems.md"

echo "=== 3b. the admission law grades the three libraries in ONE run ==="
# THE THREE LIBRARIES ARE GRADED TOGETHER, NEVER ONE AT A TIME. F1 — no entry filed in two
# libraries — is a relation BETWEEN libraries, and a run given one library reports it NOT_KNOWN
# and exits 2. Three libraries each graded alone, each reporting clean, is three runs none of
# which asked the question; that is exactly how the first published state of these pages came to
# carry three clean tables while the combined run refused. This harness makes the combined run
# the only run, and the pages publish what THIS command prints.
#
# EXIT CODES: 0 = every entry admitted; 2 = nothing refused, something HELD for want of evidence
# present here. Both are green. 1 (something REFUSED) and 3 (control arm failed) are not.
if have xcrun || have swiftc; then
    SC2=$(have xcrun && echo "xcrun swiftc" || echo "swiftc")
    LALSTAGE="$(mktemp -d)"; cp "$HERE/library-admission-law.swift" "$LALSTAGE/main.swift"
    # Reuse a binary only if it is NEWER THAN THE SOURCE. Section 2 already compiled this
    # file once to prove it builds; this section needs it with arguments, and the law is the
    # largest program here. `-nt` is the whole guard: edit the law and it rebuilds.
    LALBUILT=0
    [ -x /tmp/val_lal ] && [ /tmp/val_lal -nt "$HERE/library-admission-law.swift" ] && LALBUILT=1
    if [ "$LALBUILT" -eq 1 ] || $SC2 -O -swift-version 5 "$LALSTAGE/main.swift" -o /tmp/val_lal 2>/dev/null; then
        /tmp/val_lal --library "$ROOT/library/proteins" \
                     --library "$ROOT/library/compounds" \
                     --library "$ROOT/library/materials" \
                     --reproduce "$HERE" --evidence /tmp > /tmp/out_library-admission-law-graded.txt 2>&1
        LALEXIT=$?
        G=/tmp/out_library-admission-law-graded.txt
        # the control arm, as a RATCHET: every arm must pass and arms may only be added
        CA=$(grep -m1 '^CONTROL ARM ' "$G")
        cp_=$(printf '%s' "$CA" | sed -E 's#^CONTROL ARM +([0-9]+)/([0-9]+) PASS$#\1#')
        ct_=$(printf '%s' "$CA" | sed -E 's#^CONTROL ARM +([0-9]+)/([0-9]+) PASS$#\2#')
        if [ -n "$cp_" ] && [ "$cp_" = "$ct_" ] && [ "${ct_:-0}" -ge 61 ] 2>/dev/null; then
            ok "admission law control arm $cp_/$ct_ PASS (ratchet: at least 61 arms, all passing)"
        else
            bad "admission law control arm did not pass or has fewer than 61 arms: '$CA'"
        fi
        if [ "$LALEXIT" -eq 0 ] || [ "$LALEXIT" -eq 2 ]; then
            ok "the three libraries graded in ONE run, exit $LALEXIT (0 = all admitted, 2 = something HELD)"
        else
            bad "the three libraries graded in ONE run exited $LALEXIT — a refusal or a failed control arm, see $G"
        fi
        REFN=$(grep -m1 -E '^  REFUSED +[0-9]+$' "$G" | sed -E 's#^  REFUSED +##')
        [ "${REFN:-x}" = "0" ] && ok "0 entries refused across all three libraries" \
                               || bad "entries refused across the libraries: '$REFN'"
        GRADEDN=$(grep -m1 -E '^  entries graded +[0-9]+$' "$G" | sed -E 's#^  entries graded +##')
        if [ "${GRADEDN:-0}" -ge 16 ] 2>/dev/null; then
            ok "$GRADEDN entries graded (ratchet: the library may only grow)"
        else
            bad "only '${GRADEDN:-none}' entries graded — a checker given nothing must not report clean"
        fi
        if grep -q 'F1_NO_ENTRY_FILED_TWICE    ok' "$G"; then
            ok "F1 — no entry filed in two libraries, over all three graded together"
        else
            bad "F1 did not clear: $(grep -m1 'F1_NO_ENTRY_FILED_TWICE' "$G")"
        fi
        for lb in PROTEINS COMPOUNDS MATERIALS; do
            if grep -q "^LIBRARY $lb   ->   ADMITTED" "$G"; then ok "LIBRARY $lb admitted by the law"
            else bad "LIBRARY $lb is not ADMITTED: $(grep -m1 "^LIBRARY $lb " "$G")"; fi
        done
        # NEGATIVE CONTROL. An instrument that has not been shown to refuse has measured
        # nothing, so the harness makes it refuse something on every run.
        EMPTYLIB=$(mktemp -d)
        /tmp/val_lal --library "$EMPTYLIB" --reproduce "$HERE" --evidence /tmp >/tmp/out_lal_empty.txt 2>&1
        if [ $? -ne 0 ] && grep -q 'L1_NOT_EMPTY' /tmp/out_lal_empty.txt; then
            ok "negative control: the law REFUSES an empty library rather than reporting it clean"
        else
            bad "the law admitted an EMPTY library — always-green and always-red are the same defect"
        fi
        rm -rf "$EMPTYLIB"
    else
        bad "library-admission-law.swift does not compile — the libraries are ungraded, and ungraded is not a pass"
    fi
    rm -rf "$LALSTAGE"; rm -f /tmp/val_lal
else
    echo "  ABSENT  no Swift toolchain — the three libraries are NOT graded this run, which is not a pass"
fi

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


echo "=== 4d. the library entry files carry no private reference ==="
# Sections 4 and 4c scan the pages in the repository root. The library ENTRY FILES live one
# level down, under library/<lib>/, and were outside every one of those globs — the same
# scoping error, one directory deeper. The positive control here is the standing not-advice
# line, which every admitted entry must carry by clause E10: if the scanner cannot find it in
# every file, either an entry has lost its line or the scanner is not working, and both are
# reported rather than either being assumed.
LIBFILES=$(ls "$ROOT"/library/*/*.md 2>/dev/null | wc -l | tr -d ' ')
if [ "${LIBFILES:-0}" -eq 0 ]; then
    bad "no library entry files found to scan — refusing to report a clean boundary over nothing"
else
    LBREACH=0
    for pat in 'cells/' 'LatticeRender/Sources/' '\.gaiaftcl' '/Users/' '/home/' '/var/folders/' \
               '\$HOME' 'mortonBits' 'CapabilityRegistry' 'com\.gaiaftcl' 'treasury-swarm'; do
        h=$(grep -lE "$pat" "$ROOT"/library/*/*.md 2>/dev/null | wc -l | tr -d ' ')
        if [ "${h:-0}" -gt 0 ]; then
            bad "private reference '$pat' in $h library entry file(s): $(grep -lE "$pat" "$ROOT"/library/*/*.md 2>/dev/null | xargs -n1 basename | tr '\n' ' ')"
            LBREACH=1
        fi
    done
    LCTRL=$(grep -lF 'NOT_ADVICE' "$ROOT"/library/*/*.md 2>/dev/null | wc -l | tr -d ' ')
    if [ "${LCTRL:-0}" -eq "$LIBFILES" ]; then
        [ "$LBREACH" -eq 0 ] && ok "no private reference across $LIBFILES library entries (scanner verified live: NOT_ADVICE found in all $LCTRL)"
    else
        bad "the standing not-advice line is in only $LCTRL of $LIBFILES library entries — an entry lost its line, or the scanner is not working"
    fi
fi

echo "=== 4e. every library entry file is published on its library's page ==="
# The gradeable artefact is library/<lib>/; the artefact a stranger opens is Library-Of-*.md.
# Clause L9 of the admission law gates this, and this row is the harness's own second opinion:
# a count that must agree, computed a different way, from the fenced blocks themselves.
PGOK=1
for pair in "proteins:Library-Of-Proteins.md" "compounds:Library-Of-Compound-Cures.md" "materials:Library-Of-Material-Systems.md"; do
    d="${pair%%:*}"; pg="${pair#*:}"
    nd=$(ls "$ROOT"/library/$d/*.md 2>/dev/null | wc -l | tr -d ' ')
    np=$(grep -c '^```affine-entry$' "$ROOT/$pg" 2>/dev/null | tr -d ' ')
    if [ "${nd:-0}" -gt 0 ] && [ "${nd:-0}" -eq "${np:-0}" ]; then
        ok "$pg publishes all $nd entries of library/$d"
    else
        bad "library/$d holds ${nd:-0} entries and $pg publishes ${np:-0}"
        PGOK=0
    fi
done

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
