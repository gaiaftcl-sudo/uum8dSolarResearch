#!/bin/bash
# =====================================================================================
# THE FLOAT GATE, AT BOTH LEVELS, WITH CONTROL ARMS.
#
# Constraint 3's own history is the argument for this shape: a gate that matched float
# LITERALS went blind to `public var s1: Float`, and a gate that matched `malloc(` went
# blind to every allocation Swift performs. So this one is scoped to the PROPERTY —
# floating point, in the source AND in the instructions the compiler actually emitted —
# and it proves it can fire before it reports that it did not.
# =====================================================================================
set -u
cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1
SRC=wasi-sandwiched.swift
BIN=wasi-sandwiched
fail=0; arms=0; pass=0

arm() { # name expect actual
  arms=$((arms+1))
  if [ "$2" = "$3" ]; then pass=$((pass+1)); printf 'ARM  PASS  %-52s expect %-28s got %s\n' "$1" "$2" "$3"
  else fail=$((fail+1)); printf 'ARM  FAIL  %-52s expect %-28s got %s\n' "$1" "$2" "$3"; fi
}

[ -f "$SRC" ] || { echo "GATE_GIVEN_NOTHING  source absent"; exit 3; }
[ -f "$BIN" ] || { echo "GATE_GIVEN_NOTHING  binary absent"; exit 3; }

FPAT=':[[:space:]]*(Double|Float|Float32|Float64|CGFloat)\b|\b(Double|Float|Float32|Float64|CGFloat)\(|<[[:space:]]*(Double|Float|CGFloat)[[:space:]]*>|\[[[:space:]]*(Double|Float|CGFloat)[[:space:]]*\]|\bTimeInterval\b'
LPAT='[^A-Za-z_.\"][0-9]+\.[0-9]+|[0-9]+[eE][-+][0-9]+'

# ---- source, float TYPES. The one sanctioned site is named, not exempted by silence.
srcHits=$(grep -cE "$FPAT" "$SRC")
sanctioned=$(grep -cE '^let wsTimeout: TimeInterval = TimeInterval\(WS_TIMEOUT_SECONDS_INT\)$|^let WS_TIMEOUT_SECONDS_INT = [0-9]+$' "$SRC")
arm "source_float_type_sites" "1" "$srcHits"
arm "and_that_one_site_is_the_declared_http_timeout" "1" "$(grep -cE '^let wsTimeout: TimeInterval = TimeInterval\(WS_TIMEOUT_SECONDS_INT\)$' "$SRC")"
arm "the_timeout_is_built_from_an_Int" "1" "$(grep -cE '^let WS_TIMEOUT_SECONDS_INT = [0-9]+$' "$SRC")"

# ---- source, float LITERALS (outside string bodies)
litHits=$(grep -nE "$LPAT" "$SRC" | grep -vE '^\s*[0-9]+:\s*(//|emit\(|kv\()' | grep -cE "$LPAT")
arm "source_float_literals" "0" "$litHits"

# ---- CONTROL ARMS. A gate that cannot fire has measured nothing.
DEC=$(mktemp -t wsfp).swift
printf 'let x: Double = 0.5\nlet y = Float(3)\nvar z: [Double] = []\n' > "$DEC"
arm "control_the_type_detector_FIRES_on_a_decoy" "3" "$(grep -cE "$FPAT" "$DEC")"
arm "control_the_literal_detector_FIRES_on_a_decoy" "1" "$(grep -cE "$LPAT" "$DEC")"
printf '// this comment says the words Double and Float and 0.5 without declaring any\nlet a = 1\n' > "$DEC"
arm "control_prose_about_floats_is_not_a_float_TYPE" "0" "$(grep -cE ':[[:space:]]*(Double|Float)\b|\b(Double|Float)\(' "$DEC")"
rm -f "$DEC"

# ---- the EMITTED IMAGE. Source scanning cannot see what the compiler chose to do.
ARITH='^(fadd|fsub|fmul|fdiv|fcvt|fcvtzs|fcvtzu|scvtf|ucvtf|fcmp|fcmpe|fmadd|fmsub|fnmul|fabs|fneg|fsqrt|frinta|frintm|frintp|frintz)'
arithCount=$(otool -tvV "$BIN" 2>/dev/null | awk -v p="$ARITH" '$2 ~ p' | wc -l | tr -d ' ')
arm "emitted_float_ARITHMETIC_instructions" "0" "$arithCount"

fconst=$(otool -tvV "$BIN" 2>/dev/null | awk '$2=="fmov" && $4 ~ /^#/' | wc -l | tr -d ' ')
arm "emitted_float_CONSTANTS" "1" "$fconst"
whichConst=$(otool -tvV "$BIN" 2>/dev/null | awk '$2=="fmov" && $4 ~ /^#/{print $4}' | tr -d ',')
arm "and_that_constant_is_the_25_second_timeout" "#25.00000000" "$whichConst"
holder=$(otool -tvV "$BIN" 2>/dev/null | awk '/^_?[A-Za-z_$].*:$/{fn=$0} $2=="fmov" && $4 ~ /^#/{print fn}' | tr -d ':' | head -1)
holderName=$(swift demangle "$holder" 2>/dev/null | sed 's/.*---> //')
arm "and_it_lives_in_the_HTTP_layer_not_a_money_path" "main.wsPost(Swift.String, Swift.String) -> main.WSResult" "$holderName"

# ---- CONTROL ARM on the image scanner: it must find float arithmetic when there is some.
TMPD=$(mktemp -d); printf 'import Foundation\nlet a = Double(CommandLine.argc)\nlet b = a * 1.5 + 2.25\nprint(b)\n' > "$TMPD/d.swift"
xcrun swiftc -O -swift-version 5 "$TMPD/d.swift" -o "$TMPD/d" 2>/dev/null
decoyArith=$(otool -tvV "$TMPD/d" 2>/dev/null | awk -v p="$ARITH" '$2 ~ p' | wc -l | tr -d ' ')
if [ "$decoyArith" -gt 0 ]; then arm "control_the_image_scanner_FIRES_on_a_float_program" "MORE_THAN_ZERO" "MORE_THAN_ZERO"
   echo "            (the decoy carries $decoyArith float-arithmetic instructions; this binary carries $arithCount)"
else arm "control_the_image_scanner_FIRES_on_a_float_program" "MORE_THAN_ZERO" "ZERO_THE_SCANNER_IS_BLIND"; fi
rm -rf "$TMPD"

echo
echo "arms_run     $arms"
echo "arms_passed  $pass"
echo "arms_failed  $fail"
if [ $fail -eq 0 ]; then echo "WASI_SANDWICHED_ZERO_FLOAT_ON_EVERY_DECISION_PATH"; exit 0; fi
echo "WASI_SANDWICHED_FLOAT_GATE_RED"; exit 1
