#!/usr/bin/env bash
# coldstart-budget.sh — exec-to-exit must stay inside the budget.
#
# NO PYTHON. The measurement is Swift, performed by the app itself with its own
# ControlClock (--selftest-coldstart), because this programme is Swift 6.4 and
# an instrument written in another language is a second implementation.
# An earlier version of this gate timed with two separate python3 invocations
# and returned a NEGATIVE duration, which passed every budget — the self-test
# caught it, and the fix removed the dependency rather than patching it.
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
PKG="$(cd "$HERE/.." && pwd)"
BIN="$PKG/.build/release/FusionCourt"

[ -x "$BIN" ] || (cd "$PKG" && xcrun swift build -c release >/dev/null 2>&1) || true
[ -x "$BIN" ] || { echo "REFUSED_NO_BINARY — nothing to measure at $BIN" >&2; exit 2; }

if [ "${1:-}" = "--self-test" ]; then
    if FUSION_COLDSTART_BUDGET_NS=1 "$BIN" --selftest-coldstart >/dev/null 2>&1; then
        echo "SELF-TEST FAIL: the gate passed an impossible 1 ns budget" >&2; exit 1
    else
        echo "SELF-TEST PASS: a 1 ns budget makes the gate refuse"
    fi
    if "$BIN" --selftest-coldstart >/dev/null 2>&1; then
        echo "SELF-TEST PASS: the real budget passes — the gate discriminates"
    else
        echo "SELF-TEST FAIL: the real budget did not pass" >&2; exit 1
    fi
    exit 0
fi

out="$("$BIN" --selftest-coldstart)" || {
    echo "REFUSED_COLDSTART — $out" >&2; exit 1; }
echo "COLDSTART_WITHIN_BUDGET — $out"
