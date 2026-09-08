#!/usr/bin/env bash
# market-shear-fpscan.sh — scan the disassembly of named symbols for arm64 floating-point
# instructions, counting FP ARITHMETIC and FP MOVES as two different answers.
#
# WHY TWO COUNTS AND NOT ONE. `fmov` between registers is how a value-witness copy, an
# emission path or a closure moves 8 bytes; it decides nothing. The claim on the page is
# about the DECISION PATH: 0 fp arithmetic AND 0 fp moves there, against 25 fmov and 0 fp
# arithmetic over the whole binary. Collapsing the two into one number makes those two
# statements unsayable.
#
# AN INSTRUMENT MUST DISCRIMINATE. A scanner that reports zero on everything is worth
# exactly what one reporting a hit on everything is worth, so this script BUILDS ITS OWN
# CONTROL on every run — a two-line Double program — and refuses if the control does not
# fire. That control caught a real defect once: scoped to _main, it reported 0 FP
# arithmetic over a program that is nothing but FP arithmetic, because -O had inlined the
# arithmetic out of the symbol it was pointed at. A rule scoped to where you expect the
# violation will not catch it where it happens.
#
# PATH-INDEPENDENT: the control is built in a temporary directory and removed.
#
# usage: market-shear-fpscan.sh <binary> <symbol> [<symbol> ...]
#        market-shear-fpscan.sh --control-only
set -u
FPARITH='^[[:space:]]*[0-9a-f]+:.*[[:space:]](f(abs|add|cmp|cmpe|cvt[a-z]*|div|madd|max|min|msub|mul|neg|nmul|rint[a-z]*|sqrt|sub)|scvtf|ucvtf|fcsel|fccmp)[[:space:]]'
FPMOV='^[[:space:]]*[0-9a-f]+:.*[[:space:]]fmov[[:space:]]'

SCAN_SYMS=0; SCAN_TOTAL=0; SCAN_ARITH=0; SCAN_MOV=0
scan() { # $1=binary, rest=symbols. Symbols are DEDUPED: scanning one twice doubles its count.
  local BIN="$1"; shift
  local seen="" s d n a m
  SCAN_SYMS=0; SCAN_TOTAL=0; SCAN_ARITH=0; SCAN_MOV=0
  for s in "$@"; do
    case " $seen " in *" $s "*) continue ;; esac
    seen="$seen $s"
    d=$(objdump --disassemble-symbols="$s" --macho "$BIN" 2>/dev/null)
    n=$(printf '%s\n' "$d" | grep -cE '^[[:space:]]*[0-9a-f]+:')
    if [ "$n" -eq 0 ]; then echo "SYM_NOT_FOUND	$s"; continue; fi
    a=$(printf '%s\n' "$d" | grep -cE "$FPARITH")
    m=$(printf '%s\n' "$d" | grep -cE "$FPMOV")
    SCAN_SYMS=$((SCAN_SYMS+1)); SCAN_TOTAL=$((SCAN_TOTAL+n))
    SCAN_ARITH=$((SCAN_ARITH+a)); SCAN_MOV=$((SCAN_MOV+m))
    echo "SYM	$s	instructions	$n	fp_arithmetic	$a	fp_moves	$m"
    [ "$a" -gt 0 ] && printf '%s\n' "$d" | grep -E "$FPARITH" | head -10
  done
  echo "SYMBOLS_SCANNED	$SCAN_SYMS"
  echo "INSTRUCTIONS_SCANNED	$SCAN_TOTAL"
  echo "FP_ARITHMETIC	$SCAN_ARITH"
  echo "FP_MOVES	$SCAN_MOV"
  [ "$SCAN_SYMS" -eq 0 ] && { echo "REFUSE	A_GATE_GIVEN_NOTHING_MUST_NOT_PASS"; return 3; }
  [ "$SCAN_TOTAL" -eq 0 ] && { echo "REFUSE	ZERO_INSTRUCTIONS"; return 3; }
  return 0
}

referenceFigures() {
  echo
  echo "== REFERENCE FIGURES — published, from the pinned build =="
  echo "figures_below_are	PUBLISHED_REFERENCES_NOT_THIS_RUNS_MEASUREMENTS"
  echo "  whole binary   59,694 instructions ·  0 fp arithmetic · 25 fmov"
  echo "                 (value-witness copies, emission, self-test closures)"
  echo "  decision path  15,393 instructions across 93 symbols · 0 fp arithmetic · 0 fp moves"
  echo "  control        a two-line Double program ·  5 fp  (fmul 2, fdiv 1, fadd 1, scvtf 1)"
  echo
  echo "  The generic argument — reproducibility across machines and libm versions — is"
  echo "  true and weak. The specific one is decisive. The EXTRACTIVE filter is the entire"
  echo "  step taking 126 brackets to 108 and it is decided by the SIGN of two residuals;"
  echo "  the two nearest the boundary are -2 and -113 on operands of order 1e17-1e19,"
  echo "  where one unit in the last place of IEEE-754 binary64 is 2,048. In a double"
  echo "  pipeline that sign is not computed from the data — it is an artefact of the"
  echo "  rounding, and the same bracket classifies either way on two hosts."
}

# ------------------------------------------------------------------ the control, always
echo "== CONTROL — the scanner must FIRE on a program that is nothing but floating point =="
CTL="$(mktemp -d)"
cat > "$CTL/main.swift" <<'SWIFT'
func f(_ a: Double, _ b: Double) -> Double { a * b + a / b }
func g(_ n: Int) -> Double { Double(n) * 1.5 }
print(f(3.0, 4.0), g(7))
SWIFT
if xcrun swiftc -O -swift-version 5 "$CTL/main.swift" -o "$CTL/fpctrl" 2>/dev/null; then
    # Scoped to _main, which is where -O put the arithmetic in this program. The symbol
    # list is deduped by scan(), so naming _main twice cannot inflate the count.
    scan "$CTL/fpctrl" _main
    CA=$SCAN_ARITH
    if [ "${CA:-0}" -gt 0 ]; then
        echo "CONTROL	FIRED	fp_arithmetic	$CA	— the scanner works"
    else
        echo "CONTROL	DID_NOT_FIRE	— the scanner is not working; every reading below is void"
        rm -rf "$CTL"; referenceFigures; exit 3
    fi
else
    echo "CONTROL	NOT_BUILT	— no Swift toolchain; the scanner is UNVERIFIED this run"
    echo "UNVERIFIED is a third answer. It is not a pass."
    rm -rf "$CTL"; referenceFigures; exit 4
fi
rm -rf "$CTL"

if [ "${1:-}" = "--control-only" ] || [ "$#" -lt 2 ]; then
    referenceFigures
    echo
    echo "usage: market-shear-fpscan.sh <binary> <symbol> [<symbol> ...]"
    exit 0
fi

echo
echo "== SUBJECT =="
scan "$@"
rc=$?
referenceFigures
exit $rc
