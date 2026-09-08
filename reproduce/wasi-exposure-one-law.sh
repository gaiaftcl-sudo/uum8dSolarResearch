#!/bin/bash
# =====================================================================================
# ONE LAW, ONE HOME — the gate that makes "the SAME code path, not a reimplementation" a
# MEASUREMENT rather than a claim in a comment.
#
# The brief's own words: "THE ARITHMETIC IS THE SAME ONE ALREADY WRITTEN and it must be
# the SAME CODE PATH, not a reimplementation — two implementations drift and this one has
# to be right for a stranger."
#
# Four things must hold:
#   1. the tool source DEFINES no conjunct, no pool arithmetic and no shortfall formula;
#   2. it DOES call them, and calls each load-bearing one BY NAME;
#   3. the slice it compiles alongside is a VERBATIM prefix of the detector's own source,
#      re-cut and re-hashed here, and the binary's compiled-in digest matches it;
#   4. the OTHER tool, built from the same file at the same marker, prints the SAME digest.
#
# 4 is the one that carries the claim, and it is a RELATION rather than a literal. An
# earlier version of this gate typed the published slice digest in and required equality
# with it; the detector grew from 2,688 lines to 3,011 the same afternoon and that arm
# went red over a change that broke nothing. A relation survives the law growing.
#
# Both directions are exercised on every detector: a decoy that DOES define a law function
# must be caught, and prose naming one must NOT be, or the gate has measured nothing.
# =====================================================================================
set -u
cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1
TOOL=wasi-exposure.swift
SRC=extraction-exact.swift
SLICE=.core-detector-exposure.swift
PIN=.core-pin-exposure.swift
arms=0; pass=0; fail=0
arm(){ arms=$((arms+1)); if [ "$2" = "$3" ]; then pass=$((pass+1)); printf 'ARM  PASS  %-50s expect %-22s got %s\n' "$1" "$2" "$3"; else fail=$((fail+1)); printf 'ARM  FAIL  %-50s expect %-22s got %s\n' "$1" "$2" "$3"; fi; }

for f in "$TOOL" "$SRC" "$SLICE" "$PIN"; do [ -f "$f" ] || { echo "GATE_GIVEN_NOTHING  $f absent"; exit 3; }; done
[ -x ./wasi-exposure ] || { echo "GATE_GIVEN_NOTHING  ./wasi-exposure not built"; exit 3; }

# THE BOUNDARY IS DERIVED FROM THE SAME NAMED MARKER the two build scripts derive it from.
# THE PATTERN IS ANCHORED AND CARRIES NO DOT, AND THAT IS A LOCALE FIX, NOT A STYLE ONE.
# The marker's dash is an EM DASH — three bytes in UTF-8. This harness and these scripts
# run with LANG and LC_ALL unset, so awk is in the C locale and `.` matches ONE BYTE: the
# old pattern /SECTION 11 . MAIN/ matched interactively, where the shell has a UTF-8
# locale, and matched NOTHING where it actually runs. The guard below then refused a
# correct tree — a false refusal, which is the always-red half of the same defect as a
# false pass. Anchored on the line start with no metacharacter over the dash, this
# returns the same line in both locales, verified in both.
END_LINE=$(awk '/^\/\/ SECTION 11 /{print NR-3; exit}' "$SRC")
[ -n "$END_LINE" ] || { echo "GATE_GIVEN_NOTHING  SECTION 11 MAIN marker not found in $SRC"; exit 3; }

LAWFN='v2Out|v2RecoverFeeInterval|v3Step|v3InvertStart|nextSqrtFromAmount0|nextSqrtFromAmount1|getAmount0Delta|getAmount1Delta|computeShortfall|identifyTokens|finishRatios|runCorpus|decU256'
DEFS=$(grep -cE "^[[:space:]]*(public |private |internal |static |@inline\(__always\) )*func ($LAWFN)\(" "$TOOL")
USES=$(grep -cE "($LAWFN)\(" "$TOOL")
arm "the_tool_DEFINES_no_law_function" "0" "$DEFS"
arm "and_it_DOES_call_them" "MORE_THAN_ZERO" "$([ "$USES" -gt 0 ] && echo MORE_THAN_ZERO || echo ZERO)"
echo "            ($USES call sites in the tool, 0 definitions)"

# Every one of the five load-bearing law functions must be reached by name, not just some.
for f in v2Out v3Step v3InvertStart computeShortfall runCorpus; do
  arm "calls_${f}_by_its_own_name" "YES" "$(grep -qE "\b${f}\(" "$TOOL" && echo YES || echo NO)"
done

# CONTROL: the definition detector must fire on a decoy that redefines one.
D=$(mktemp -t wxol).swift
printf 'func v2Out(_ a: Int) -> Int { return a }\nfunc computeShortfall(_ x: Int) {}\n' > "$D"
arm "control_the_definition_detector_FIRES" "2" "$(grep -cE "^[[:space:]]*(public |private |internal |static |@inline\(__always\) )*func ($LAWFN)\(" "$D")"
printf '// a comment naming v2Out( and computeShortfall( defines nothing\nlet a = 1\n' > "$D"
arm "control_prose_naming_a_law_is_not_a_definition" "0" "$(grep -cE "^[[:space:]]*(public |private |internal |static |@inline\(__always\) )*func ($LAWFN)\(" "$D")"
rm -f "$D"

# The slice is a verbatim prefix, re-cut here rather than trusted from the pin.
RECUT=$(mktemp -t wxslice); sed -n "1,${END_LINE}p" "$SRC" > "$RECUT"
arm "the_slice_re_cuts_byte_identical" "$(shasum -a 256 "$SLICE" | awk '{print $1}')" "$(shasum -a 256 "$RECUT" | awk '{print $1}')"
# `cmp -n` is not portable here and reads as always-NOT_A_PREFIX; head -c into cmp works.
isprefix(){ head -c "$(wc -c < "$1" | tr -d ' ')" "$2" | cmp -s - "$1" && echo prefix || echo NOT_A_PREFIX; }
arm "and_it_is_a_PREFIX_of_the_detector_source" "prefix" "$(isprefix "$RECUT" "$SRC")"
# CONTROL: a one-byte change must break the prefix check.
TAMPER=$(mktemp -t wxtamp); cat "$RECUT" > "$TAMPER"; printf 'x' >> "$TAMPER"
arm "control_a_tampered_slice_is_NOT_a_prefix" "NOT_A_PREFIX" "$(isprefix "$TAMPER" "$SRC")"
rm -f "$RECUT" "$TAMPER"

# The binary's compiled-in digest is the digest of that slice.
PINNED=$(awk -F'"' '/^let CORE_SLICE_SHA256/{print $2}' "$PIN")
arm "the_pin_matches_the_slice" "$(shasum -a 256 "$SLICE" | awk '{print $1}')" "$PINNED"
arm "and_the_binary_PRINTS_that_digest" "$PINNED" "$(./wasi-exposure 2>/dev/null | awk -F'\t' '$1=="law_sha256_computed_at_build"{print $2}')"

# THE CLAIM ITSELF: two tools, one law, one digest — read out of both binaries.
if [ -x ./wasi-sandwiched ]; then
  arm "the_other_tool_carries_the_SAME_law_digest" "$PINNED" \
      "$(./wasi-sandwiched 2>/dev/null | awk -F'\t' '$1=="law_sha256_computed_at_build"{print $2}')"
else
  # ABSENT IS NOT A PASS. The arm that carries the whole claim cannot be allowed to read
  # green because the other binary was never built.
  arm "the_other_tool_carries_the_SAME_law_digest" "$PINNED" \
      "NOT_BUILT__run_wasi-sandwiched-build.sh_first"
fi

# ZERO FLOAT ON THE MONEY PATH — the source must declare no float type outside the one
# documented timeout.
#
# THE DETECTOR IS SCOPED TO CODE, NOT TO WORDING. Its first version excluded the specific
# sentences it expected to see ('one Double', 'no float', ...) and then fired on the line
# 'The one and only Double in this program' — prose it had not anticipated. A rule scoped
# to the spelling you last saw will not catch it where it happens, and worse, it fires
# where nothing is wrong. So: strip comments first, then match.
strip_comments(){ sed -e 's://.*::' "$1"; }
FL=$(strip_comments "$TOOL" | grep -nE '\b(Double|Float|Float32|Float64|CGFloat)\b' | grep -viE 'TimeInterval' | wc -l | tr -d ' ')
arm "no_float_type_in_CODE_outside_the_documented_timeout" "0" "$FL"
# CONTROL A: a real float declaration must be caught.
D2=$(mktemp -t wxfl).swift; printf 'let r: Double = 0.5\n' > "$D2"
arm "control_a_real_float_declaration_IS_caught" "1" \
    "$(strip_comments "$D2" | grep -cE '\b(Double|Float|Float32|Float64|CGFloat)\b')"
# CONTROL B: prose naming a float in a comment must NOT be — this is the arm that the
# first version of this gate failed.
printf '// The one and only Double in this program, and a CGFloat too.\nlet a = 1\n' > "$D2"
arm "control_prose_naming_a_float_is_NOT_caught" "0" \
    "$(strip_comments "$D2" | grep -cE '\b(Double|Float|Float32|Float64|CGFloat)\b')"
# CONTROL C: and the exempted timeout must still be the ONLY exemption.
printf 'let t: TimeInterval = TimeInterval(25)\nlet bad: Double = 1.0\n' > "$D2"
arm "control_the_exemption_does_not_hide_a_real_float" "1" \
    "$(strip_comments "$D2" | grep -nE '\b(Double|Float|Float32|Float64|CGFloat)\b' | grep -viE 'TimeInterval' | wc -l | tr -d ' ')"
rm -f "$D2"

echo
echo "arms_run     $arms"
echo "arms_passed  $pass"
echo "arms_failed  $fail"
[ $fail -eq 0 ] && { echo "ONE_LAW_ONE_HOME_PROVEN"; exit 0; }
echo "ONE_LAW_ONE_HOME_RED"; exit 1
