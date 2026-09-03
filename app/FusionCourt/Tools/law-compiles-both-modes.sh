#!/usr/bin/env bash
# law-compiles-both-modes.sh — the law MUST typecheck under -swift-version 5 AND 6.
#
# WHY: reproduce/ scripts build the law at -swift-version 5 while the package
# uses language mode 6. A law that compiles in only one mode breaks either the
# app or the reproduce harness, and which one breaks would depend on who ran it.
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
LAW="$HERE/../Sources/FusionLaw"
SC="xcrun swiftc"

check() { $SC -swift-version "$1" -typecheck "$2"/*.swift 2>&1 | grep -c "error:" || true; }

if [ "${1:-}" = "--self-test" ]; then
    tmp="$(mktemp -d)"; trap 'rm -rf "$tmp"' EXIT
    cp "$LAW"/*.swift "$tmp/"
    # CORRECTION, 2026-09-03: the first version of this arm planted `Int128` and
    # expected the v5 leg to refuse it. It did not, and that was the arm being
    # wrong rather than the gate: -swift-version selects LANGUAGE SEMANTICS, not
    # stdlib availability, so Int128 is visible in both modes. The construct that
    # actually differs is global mutable state — an error under v6 strict
    # concurrency, permitted under v5. So the arm now exercises the V6 leg.
    printf 'public var _plantedGlobal = 0\n' > "$tmp/planted.swift"
    v6="$(check 6 "$tmp")"
    if [ "$v6" -gt 0 ]; then echo "SELF-TEST PASS: the v6 leg refuses global mutable state ($v6 errors)"
    else echo "SELF-TEST FAIL: the v6 leg accepted global mutable state" >&2; exit 1; fi
    # and the same file must be ACCEPTED by v5 — proving the gate discriminates
    # BY MODE rather than just refusing everything.
    v5="$(check 5 "$tmp")"
    if [ "$v5" -eq 0 ]; then echo "SELF-TEST PASS: the v5 leg accepts it — the gate discriminates by mode"
    else echo "SELF-TEST FAIL: v5 also refused; the gate is not mode-sensitive" >&2; exit 1; fi
    exit 0
fi

[ -d "$LAW" ] || { echo "REFUSED_EMPTY_SCOPE — no law directory at $LAW" >&2; exit 2; }
n=$(ls -1 "$LAW"/*.swift 2>/dev/null | wc -l | tr -d ' ')
[ "$n" -gt 0 ] || { echo "REFUSED_EMPTY_SCOPE — no law sources found" >&2; exit 2; }

e5="$(check 5 "$LAW")"; e6="$(check 6 "$LAW")"
if [ "$e5" -gt 0 ] || [ "$e6" -gt 0 ]; then
    echo "REFUSED_LAW_MODE_DRIFT — v5 errors=$e5  v6 errors=$e6" >&2
    exit 1
fi
echo "LAW_COMPILES_BOTH_MODES_PROVEN — $n law sources clean under -swift-version 5 and 6"
