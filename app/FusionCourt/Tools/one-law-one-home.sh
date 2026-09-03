#!/usr/bin/env bash
# one-law-one-home.sh — the law's constants may be DEFINED in exactly one file.
#
# WHY THIS EXISTS: on 2026-09-02 the law was found forked three ways across
# reproduce/, and the copies DISAGREED — one returned NOMINAL where the others
# returned REFUSED_MALFORMED. A refusal had silently become a pass, and the
# published figure was drawn by the most permissive copy. A digest check would
# not have caught it: each fork was a deliberate context-specific edit.
# Only a "defined in one place" rule catches that.
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
REPO="$(cd "$HERE/../../.." && pwd)"
HOME_FILE="$HERE/../Sources/FusionLaw/LawConstants.swift"

# A DEFINITION, not a mention: `let NAME` / `NAME =` at a declaration site.
NAMES='ADC_MIN|ADC_MAX|ENVELOPE_ABS|GROWTH_WINDOW|GROWTH_TRIGGER|PERSIST|adcMin|adcMax|envelopeAbs|growthWindow|growthTrigger|persist'

scan() {  # scan <dir> — prints "file:line:text" for each definition found
    grep -rnE "(let|var)[[:space:]]+($NAMES)[[:space:]]*(:[^=]*)?=" \
        --include="*.swift" "$1" 2>/dev/null || true
}

violations="$(scan "$REPO/reproduce"; scan "$REPO/app" | grep -v "LawConstants.swift" || true)"

if [ "${1:-}" = "--self-test" ]; then
    # CONTROL ARM: plant a fourth copy and assert the gate refuses.
    tmp="$(mktemp -d)"; trap 'rm -rf "$tmp"' EXIT
    printf 'let GROWTH_TRIGGER = 900\n' > "$tmp/planted.swift"
    if grep -rnE "(let|var)[[:space:]]+($NAMES)[[:space:]]*(:[^=]*)?=" "$tmp" >/dev/null 2>&1; then
        echo "SELF-TEST PASS: the detector fires on a planted definition"
    else
        echo "SELF-TEST FAIL: the detector cannot see a planted definition" >&2; exit 1
    fi
    # and it must NOT fire on prose that merely names a constant
    printf '// GROWTH_TRIGGER is 900 counts\n' > "$tmp/prose.swift"
    rm "$tmp/planted.swift"
    if grep -rnE "(let|var)[[:space:]]+($NAMES)[[:space:]]*(:[^=]*)?=" "$tmp" >/dev/null 2>&1; then
        echo "SELF-TEST FAIL: the detector fires on prose" >&2; exit 1
    fi
    echo "SELF-TEST PASS: prose naming a constant is not a definition"
    exit 0
fi

if [ -n "$violations" ]; then
    echo "REFUSED_LAW_DEFINED_TWICE — the law's constants are defined outside their home:" >&2
    echo "$violations" | sed 's/^/  /' >&2
    echo "  home: Sources/FusionLaw/LawConstants.swift" >&2
    echo "  A law written twice IS a hop. Consume the law; do not re-declare it." >&2
    exit 1
fi
echo "ONE_LAW_ONE_HOME_PROVEN — the law's constants are defined in exactly one file"
