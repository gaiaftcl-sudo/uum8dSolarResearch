#!/usr/bin/env bash
# extraction-fpscan.sh — prove by DISASSEMBLY that no floating-point arithmetic touches a
# value computation in extraction-exact.
#
# WHY THIS EXISTS RATHER THAN A REUSE OF market-shear-fpscan.sh. That script scopes every
# scan with `objdump --disassemble-symbols=<sym> --macho <bin>`. On the toolchain here —
# Apple LLVM 21.0.0 — the Mach-O path IGNORES --disassemble-symbols and disassembles the
# WHOLE BINARY, silently. Measured: a symbol that does not exist at all returns 52,086
# instructions, which is the whole text section, and a real symbol returns the same 52,086.
# The scan therefore reports the whole binary under every symbol's name, and multiplies its
# instruction count by the number of symbols passed. Dropping --macho fixes it: the same
# real symbol then returns 146 instructions and the nonexistent one returns 0.
#
# THE ARM THAT CATCHES IT IS THE NEGATIVE CONTROL, and it is why this script has one.
# A scanner whose scope silently widens to everything still reports 0 on a clean binary, so
# a positive control alone — "the detector fires on a float program" — passes while the
# scoping is broken. Only asking for a symbol that CANNOT be there, and requiring the answer
# to be zero instructions, distinguishes a filter that works from a filter that is ignored.
#
# Two counts, never one. `fmov` between registers moves 8 bytes and decides nothing; FP
# ARITHMETIC is the claim. Collapsing them makes the real statement unsayable.
#
# PATH-INDEPENDENT. The controls are built and removed in a temporary directory.
# usage: extraction-fpscan.sh <binary> <symbol-file>
set -u

FPARITH='^[[:space:]]*[0-9a-f]+:.*[[:space:]](f(abs|add|cmp|cmpe|cvt[a-z]*|div|madd|max|min|msub|mul|neg|nmul|rint[a-z]*|sqrt|sub)|scvtf|ucvtf|fcsel|fccmp)[[:space:]]'
FPMOV='^[[:space:]]*[0-9a-f]+:.*[[:space:]]fmov[[:space:]]'
NINSTR='^[[:space:]]*[0-9a-f]+:'

dis()   { objdump -d --disassemble-symbols="$2" "$1" 2>/dev/null; }   # NO --macho: see header
disall(){ objdump -d "$1" 2>/dev/null; }

BIN="${1:-}"
SYMS="${2:-}"
if [ -z "$BIN" ] || [ ! -f "$BIN" ]; then
    echo "ABSENT	no binary at '${BIN}'"
    echo "ABSENT is not a REFUSAL and it is not a pass."
    exit 4
fi

echo "== CONTROL 1 (POSITIVE) — the detector must FIRE, THROUGH THE SAME PER-SYMBOL PATH =="
echo "The control's arithmetic is taken from argc so -O cannot fold it away, and the scanned"
echo "function is @inline(never) so it survives as a symbol. Scoping the control to _main"
echo "instead — which the earlier scanner did — reports 0 fp on a program that is nothing but"
echo "floating point, because -O moved the arithmetic out of _main."
CTL="$(mktemp -d)"
cat > "$CTL/main.swift" <<'SWIFT'
@inline(never) public func ctlFloatWork(_ a: Double, _ b: Double) -> Double { a * b + a / b - a }
let n = Double(CommandLine.argc)
print(ctlFloatWork(n, n + 1.0))
SWIFT
if ! xcrun swiftc -O -swift-version 5 "$CTL/main.swift" -o "$CTL/fpctrl" 2>/dev/null; then
    echo "CONTROL_1	NOT_BUILT — no Swift toolchain; every reading below is UNVERIFIED"
    echo "UNVERIFIED is a third answer. It is not a pass."
    rm -rf "$CTL"; exit 4
fi
CSYM=$(nm "$CTL/fpctrl" 2>/dev/null | awk '$2=="t"||$2=="T"{print $3}' | grep 'ctlFloatWork' | head -1)
if [ -z "$CSYM" ]; then
    echo "CONTROL_1	SYMBOL_NOT_EMITTED — cannot exercise the per-symbol path; readings are UNVERIFIED"
    rm -rf "$CTL"; exit 4
fi
CA=$(dis "$CTL/fpctrl" "$CSYM" | grep -cE "$FPARITH")
CN=$(dis "$CTL/fpctrl" "$CSYM" | grep -cE "$NINSTR")
CW=$(disall "$CTL/fpctrl" | grep -cE "$NINSTR")
echo "CONTROL_1	symbol	$CSYM"
echo "CONTROL_1	instructions	$CN	fp_arithmetic	$CA	whole_control_binary	$CW"
if [ "$CA" -gt 0 ] && [ "$CN" -lt "$CW" ]; then
    echo "CONTROL_1	FIRED_AND_SCOPED — the detector works and it looked at one function"
elif [ "$CA" -gt 0 ]; then
    echo "CONTROL_1	FIRED_BUT_UNSCOPED — it saw the whole control binary. REFUSED."
    rm -rf "$CTL"; exit 3
else
    echo "CONTROL_1	DID_NOT_FIRE — the detector is broken; every reading below is void"
    rm -rf "$CTL"; exit 3
fi

echo
echo "== CONTROL 2 (NEGATIVE) — the SCOPE must be a scope, not a pass-through =="
echo "A symbol that cannot exist must return ZERO instructions. If it returns the whole"
echo "text section, --disassemble-symbols is being ignored and every per-symbol figure"
echo "below is really a whole-binary figure wearing a symbol's name."
GHOST='_$s4main_this_symbol_cannot_exist_00000000F'
GN=$(dis "$BIN" "$GHOST" | grep -cE "$NINSTR")
WHOLE=$(disall "$BIN" | grep -cE "$NINSTR")
echo "CONTROL_2	ghost_symbol_instructions	$GN"
echo "CONTROL_2	whole_binary_instructions	$WHOLE"
if [ "$GN" -eq 0 ]; then
    echo "CONTROL_2	SCOPE_IS_A_SCOPE"
elif [ "$GN" -eq "$WHOLE" ]; then
    echo "CONTROL_2	SCOPE_IGNORED — the filter returns the whole binary for a symbol that"
    echo "CONTROL_2	does not exist. Per-symbol figures are REFUSED on this toolchain."
    rm -rf "$CTL"; exit 3
else
    echo "CONTROL_2	UNEXPECTED — a ghost symbol returned $GN instructions. REFUSED."
    rm -rf "$CTL"; exit 3
fi
rm -rf "$CTL"

echo
echo "== WHOLE BINARY — the claim that cannot be scoped wrong =="
D=$(disall "$BIN")
WA=$(printf '%s\n' "$D" | grep -cE "$FPARITH")
WM=$(printf '%s\n' "$D" | grep -cE "$FPMOV")
echo "whole_binary_instructions	$WHOLE"
echo "whole_binary_fp_arithmetic	$WA"
echo "whole_binary_fp_moves	$WM"
if [ "$WHOLE" -eq 0 ]; then echo "REFUSE	ZERO_INSTRUCTIONS_A_GATE_GIVEN_NOTHING_MUST_NOT_PASS"; exit 3; fi
if [ "$WA" -eq 0 ]; then
    echo "WHOLE_BINARY	NO_FP_ARITHMETIC_ANYWHERE"
    echo "This is stronger than any decision-path claim and it needs no scope argument: an"
    echo "instruction that is not in the image cannot execute on a value."
else
    printf '%s\n' "$D" | grep -E "$FPARITH" | head -20
fi

if [ -z "$SYMS" ] || [ ! -f "$SYMS" ]; then
    echo
    echo "SYMBOL_LIST	ABSENT	— whole-binary figures above stand on their own"
    exit 0
fi

echo
echo "== DECISION PATH — the value functions, named, deduped =="
seen=""; N=0; T=0; A=0; M=0; MISSING=0
while IFS= read -r s; do
    [ -z "$s" ] && continue
    case " $seen " in *" $s "*) continue ;; esac
    seen="$seen $s"
    d=$(dis "$BIN" "$s")
    n=$(printf '%s\n' "$d" | grep -cE "$NINSTR")
    if [ "$n" -eq 0 ]; then echo "SYM_NOT_FOUND	$s"; MISSING=$((MISSING+1)); continue; fi
    a=$(printf '%s\n' "$d" | grep -cE "$FPARITH")
    m=$(printf '%s\n' "$d" | grep -cE "$FPMOV")
    N=$((N+1)); T=$((T+n)); A=$((A+a)); M=$((M+m))
    echo "SYM	$s	instructions	$n	fp_arithmetic	$a	fp_moves	$m"
    [ "$a" -gt 0 ] && printf '%s\n' "$d" | grep -E "$FPARITH" | head -5
done < "$SYMS"
echo "SYMBOLS_SCANNED	$N"
echo "SYMBOLS_NOT_FOUND	$MISSING"
echo "INSTRUCTIONS_SCANNED	$T"
echo "FP_ARITHMETIC	$A"
echo "FP_MOVES	$M"
[ "$N" -eq 0 ] && { echo "REFUSE	A_GATE_GIVEN_NOTHING_MUST_NOT_PASS"; exit 3; }
[ "$T" -ge "$WHOLE" ] && { echo "REFUSE	SCOPED_TOTAL_REACHED_THE_WHOLE_BINARY — the scope is not scoping"; exit 3; }
echo "DECISION_PATH	$( [ "$A" -eq 0 ] && echo NO_FP_ARITHMETIC || echo FP_ARITHMETIC_PRESENT )"
exit 0
