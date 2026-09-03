#!/usr/bin/env bash
# swift-only.sh — this app is Swift 6.4 and nothing else.
#
# Founder, 2026-09-03: "we are not python." A cold-start gate in this very
# directory had been timing with python3, which is both a foreign runtime on the
# measurement path and a second implementation of something Swift already does.
# The fix removed the dependency; this gate stops it returning.
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
PKG="$(cd "$HERE/.." && pwd)"

# An INVOCATION, not a mention. Prose explaining why python is absent is fine;
# a line that RUNS one is not.
PAT='(^|[^[:alnum:]_#])(python3?|node|npm|npx|ruby|perl|pip3?)([[:space:]]|$)'

detect() {
    grep -rnE "$PAT" --include="*.sh" --include="*.swift" --include="Package.swift" \
        "$PKG/Tools" "$PKG/Sources" "$PKG/Package.swift" 2>/dev/null |
        grep -vE ':[0-9]+:[[:space:]]*#' |          # shell comment
        grep -vE ':[0-9]+:[[:space:]]*(//|///|\*)' |   # swift comment
        grep -v 'Tools/swift-only.sh:' || true
        # SELF-EXCLUSION, and why it is not a loophole: this gate necessarily
        # CONTAINS the string it hunts, in its own planted-violation fixture.
        # Without this it flags itself and nothing else — an always-red gate,
        # which is the same defect as an always-green one. The detector is still
        # proven by --self-test, which plants the violation in a TEMP file
        # outside this exclusion and asserts it fires.
}

if [ "${1:-}" = "--self-test" ]; then
    tmp="$(mktemp -d)"; trap 'rm -rf "$tmp"' EXIT
    printf 'python3 -c "print(1)"\n' > "$tmp/planted.sh"
    if grep -rnE "$PAT" "$tmp" | grep -vE ':[0-9]+:[[:space:]]*#' >/dev/null; then
        echo "SELF-TEST PASS: fires on a real python3 invocation"
    else echo "SELF-TEST FAIL: blind to a python3 invocation" >&2; exit 1; fi
    printf '# no python here, deliberately\n' > "$tmp/planted.sh"
    if grep -rnE "$PAT" "$tmp" | grep -vE ':[0-9]+:[[:space:]]*#' >/dev/null; then
        echo "SELF-TEST FAIL: fires on a comment mentioning python" >&2; exit 1
    else echo "SELF-TEST PASS: prose naming python is not an invocation"; fi
    exit 0
fi

[ -d "$PKG/Sources" ] || { echo "REFUSED_EMPTY_SCOPE — no Sources to scan" >&2; exit 2; }
hits="$(detect)"
if [ -n "$hits" ]; then
    echo "REFUSED_FOREIGN_RUNTIME — a non-Swift runtime is invoked here:" >&2
    echo "$hits" | sed 's/^/  /' >&2
    exit 1
fi
echo "SWIFT_ONLY_PROVEN — no foreign runtime invoked in Tools, Sources or the manifest"
