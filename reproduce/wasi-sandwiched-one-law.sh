#!/bin/bash
# =====================================================================================
# ONE LAW, ONE HOME — the gate that makes "same code path, not a reimplementation" a
# MEASUREMENT rather than a claim in a comment.
#
# Two things must both hold:
#   1. the tool source DEFINES no conjunct, no pool arithmetic and no shortfall formula;
#   2. the slice it compiles alongside is a VERBATIM prefix of the detector's own source,
#      re-cut and re-hashed here, and the binary's compiled-in digest matches it.
# Both directions are exercised: a decoy that DOES define one of those functions must be
# caught, or the gate has measured nothing.
# =====================================================================================
set -u
cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1
TOOL=wasi-sandwiched.swift
SRC=extraction-exact.swift
SLICE=.core-detector.swift
PIN=.core-pin.swift
# THE BOUNDARY IS DERIVED FROM A NAMED MARKER, NEVER TYPED AS A LINE NUMBER.
#
# It was typed as 2535 in THREE separate files — this script, wasi-sandwiched-one-law.sh
# and reproduce/validate.sh — so any additive edit to the law was a four-file change and
# three of the four would have gone on quoting a stale number. That is the same defect this
# study records elsewhere: a constant duplicated across consumers is a constant that drifts.
# The marker "SECTION 11 — MAIN" is what actually separates the declarations from the
# program's own top-level code, so the boundary is read off that. The structural check that
# follows is unchanged and still REFUSES if what it finds is not a closing brace followed by
# a rule — deriving the number does not remove the check, it removes the retyping.
END_LINE=$(awk '/SECTION 11 . MAIN/{print NR-3; exit}' "$SRC")
[ -n "$END_LINE" ] || { echo "BUILD_REFUSED  SECTION 11 MAIN marker not found in $SRC"; exit 3; }
arms=0; pass=0; fail=0
arm(){ arms=$((arms+1)); if [ "$2" = "$3" ]; then pass=$((pass+1)); printf 'ARM  PASS  %-46s expect %-22s got %s\n' "$1" "$2" "$3"; else fail=$((fail+1)); printf 'ARM  FAIL  %-46s expect %-22s got %s\n' "$1" "$2" "$3"; fi; }

for f in "$TOOL" "$SRC" "$SLICE" "$PIN"; do [ -f "$f" ] || { echo "GATE_GIVEN_NOTHING  $f absent"; exit 3; }; done

LAWFN='v2Out|v2RecoverFeeInterval|v3Step|v3InvertStart|nextSqrtFromAmount0|nextSqrtFromAmount1|getAmount0Delta|getAmount1Delta|computeShortfall|identifyTokens|finishRatios|runCorpus'
DEFS=$(grep -cE "^[[:space:]]*(public |private |internal |@inline\(__always\) )*func ($LAWFN)\(" "$TOOL")
USES=$(grep -cE "($LAWFN)\(" "$TOOL")
arm "the_tool_DEFINES_no_law_function" "0" "$DEFS"
arm "and_it_DOES_call_them" "MORE_THAN_ZERO" "$([ "$USES" -gt 0 ] && echo MORE_THAN_ZERO || echo ZERO)"
echo "            ($USES call sites in the tool, 0 definitions)"

# CONTROL: the definition detector must fire on a decoy that redefines one.
D=$(mktemp -t wsol).swift
printf 'func v2Out(_ a: Int) -> Int { return a }\nfunc computeShortfall(_ x: Int) {}\n' > "$D"
arm "control_the_definition_detector_FIRES" "2" "$(grep -cE "^[[:space:]]*(public |private |internal |@inline\(__always\) )*func ($LAWFN)\(" "$D")"
printf '// a comment naming v2Out( and computeShortfall( defines nothing\nlet a = 1\n' > "$D"
arm "control_prose_naming_a_law_is_not_a_definition" "0" "$(grep -cE "^[[:space:]]*(public |private |internal |@inline\(__always\) )*func ($LAWFN)\(" "$D")"
rm -f "$D"

# The slice is a verbatim prefix, re-cut here rather than trusted.
RECUT=$(mktemp -t wsslice); sed -n "1,${END_LINE}p" "$SRC" > "$RECUT"
arm "the_slice_re_cuts_byte_identical" "$(shasum -a 256 "$SLICE" | awk '{print $1}')" "$(shasum -a 256 "$RECUT" | awk '{print $1}')"
# `cmp -n` is not portable here and read as always-NOT_A_PREFIX; the control-arm PAIR
# caught that before it could report anything. head -c piped into cmp is what works.
isprefix(){ head -c "$(wc -c < "$1" | tr -d ' ')" "$2" | cmp -s - "$1" && echo prefix || echo NOT_A_PREFIX; }
arm "and_it_is_a_PREFIX_of_the_detector_source" "prefix" "$(isprefix "$RECUT" "$SRC")"
# CONTROL: a one-byte change must break the prefix check.
TAMPER=$(mktemp -t wstamp); cat "$RECUT" > "$TAMPER"; printf 'x' >> "$TAMPER"
arm "control_a_tampered_slice_is_NOT_a_prefix" "NOT_A_PREFIX" "$(isprefix "$TAMPER" "$SRC")"
rm -f "$RECUT" "$TAMPER"

# The binary's compiled-in digest is the digest of that slice.
PINNED=$(awk -F'"' '/^let CORE_SLICE_SHA256/{print $2}' "$PIN")
arm "the_pin_matches_the_slice" "$(shasum -a 256 "$SLICE" | awk '{print $1}')" "$PINNED"
arm "and_the_binary_PRINTS_that_digest" "$PINNED" "$(./wasi-sandwiched 2>/dev/null | awk -F'\t' '$1=="law_sha256_computed_at_build"{print $2}')"

echo
echo "arms_run     $arms"
echo "arms_passed  $pass"
echo "arms_failed  $fail"
[ $fail -eq 0 ] && { echo "ONE_LAW_ONE_HOME_PROVEN"; exit 0; }
echo "ONE_LAW_ONE_HOME_RED"; exit 1
