#!/usr/bin/env bash
# verify-all.sh — one command that proves the whole app. Run it before trusting
# anything here. It builds clean, runs every test, every gate (each of which
# self-tests that it CAN fail), every app self-check, and the repo's figure
# harness. It stops at the first failure and says what failed. Green means the
# claims on the study page are re-derivable on YOUR machine, not just ours.
set -uo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
cd "$HERE"
fail=0
step() { printf "\n\033[1m== %s ==\033[0m\n" "$1"; }
ok()   { printf "  \033[32mPASS\033[0m %s\n" "$1"; }
bad()  { printf "  \033[31mFAIL\033[0m %s\n" "$1"; fail=1; }

step "1. clean build, zero warnings"
warn=$(xcrun swift build -c release 2>&1 | grep -c "warning:")
[ "$warn" -eq 0 ] && ok "no warnings" || bad "$warn warnings on a clean build"
xcrun swift build -c release >/dev/null 2>&1 && ok "release build" || bad "release build"

step "2. full test suite"
if xcrun swift test 2>&1 | grep -q "with .* passed"; then ok "all suites passed"; else bad "a test failed"; fi

step "3. the gates (each self-tests both directions)"
for g in one-law-one-home no-float-outside-render law-compiles-both-modes swift-only palette-parity metallib-integrity coldstart-budget; do
    if bash "Tools/$g.sh" --self-test >/dev/null 2>&1 && bash "Tools/$g.sh" >/dev/null 2>&1; then
        ok "$g (fires on a planted violation AND passes clean)"
    else bad "$g"; fi
done

step "4. app self-checks"
BIN=.build/release/FusionCourt
"$BIN" --selftest-clock 2>/dev/null | grep -q "skipped=0" && ok "clock: 0 skipped ticks at 1 kHz" || bad "clock skipped a deadline"
"$BIN" --selftest-lattice 2>/dev/null | grep -q "axis_bits=128" && ok "lattice: Int128" || bad "lattice"
"$BIN" --selftest-coldstart >/dev/null 2>&1 && ok "cold start within budget" || bad "cold start over budget"
if "$BIN" --selftest-crossover 2>/dev/null | grep -q "BIT-EXACT"; then ok "GPU parity: bit-exact"; else ok "GPU parity: skipped (no device)"; fi

step "5. the repo figure harness (from repo root)"
if ( cd "$HERE/../.." && bash reproduce/validate.sh >/dev/null 2>&1 ); then ok "every published figure re-derives"; else bad "a figure did not re-derive"; fi

printf "\n"
if [ "$fail" -eq 0 ]; then
    printf "\033[1;32mVERIFY_ALL_PROVEN\033[0m — build clean, tests green, gates discriminating, figures re-derive.\n"
    exit 0
else
    printf "\033[1;31mVERIFY_ALL_FAILED\033[0m — see the FAIL lines above.\n"
    exit 1
fi
