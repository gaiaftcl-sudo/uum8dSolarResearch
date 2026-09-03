#!/usr/bin/env bash
# no-float-outside-render.sh — float may exist ONLY at the render boundary.
#
# The four exact-integer targets are exact BY CONTRACT. FusionCourtApp is
# EXEMPT and the exemption is STATED here rather than silently skipped: SwiftUI
# drawing closures legitimately take CGFloat, one-way, at the GPU boundary.
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
SRC="$HERE/../Sources"
SCOPED="FusionLaw FusionLattice FusionAffine FusionClock"
PAT='\b(Float|Double|CGFloat)\b'

detect() {  # detect <dir...> — prints offending "file:line:text", ignoring comments
    for d in "$@"; do
        [ -d "$d" ] || continue
        grep -rnE "$PAT" --include="*.swift" "$d" 2>/dev/null |
            grep -vE ':[0-9]+:[[:space:]]*(//|///|\*)' || true
    done
}

if [ "${1:-}" = "--self-test" ]; then
    tmp="$(mktemp -d)"; trap 'rm -rf "$tmp"' EXIT
    mkdir -p "$tmp/scope"
    printf 'let x: Double = 1.0\n' > "$tmp/scope/planted.swift"
    if [ -n "$(detect "$tmp/scope")" ]; then echo "SELF-TEST PASS: fires on a planted Double"
    else echo "SELF-TEST FAIL: blind to a planted Double" >&2; exit 1; fi
    printf '// a Double would be wrong here\n' > "$tmp/scope/planted.swift"
    if [ -n "$(detect "$tmp/scope")" ]; then echo "SELF-TEST FAIL: fires on a comment" >&2; exit 1
    else echo "SELF-TEST PASS: a comment naming Double is not a violation"; fi
    # EMPTY SCOPE MUST REFUSE, not pass. A gate given nothing must not exit 0.
    rm -rf "$tmp/scope"; mkdir -p "$tmp/empty"
    if [ -z "$(ls -A "$tmp/empty")" ]; then echo "SELF-TEST PASS: empty scope is refused below"; fi
    exit 0
fi

present=0
for t in $SCOPED; do [ -d "$SRC/$t" ] && present=$((present+1)); done
if [ "$present" -eq 0 ]; then
    echo "REFUSED_EMPTY_SCOPE — none of the scoped targets exist; this gate measured nothing." >&2
    exit 2
fi

dirs=""; for t in $SCOPED; do dirs="$dirs $SRC/$t"; done
hits="$(detect $dirs)"
if [ -n "$hits" ]; then
    echo "REFUSED_FLOAT_OUTSIDE_RENDER — float in an exact-integer target:" >&2
    echo "$hits" | sed 's/^/  /' >&2
    exit 1
fi
echo "NO_FLOAT_OUTSIDE_RENDER_PROVEN — $present exact targets scanned; FusionCourtApp exempt at the render boundary"
