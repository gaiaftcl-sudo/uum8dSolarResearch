#!/usr/bin/env bash
# one-law-one-home.sh — the law's constants may be DEFINED in exactly one file.
#
# WHY THIS EXISTS: on 2026-09-02 the law was found forked three ways across
# reproduce/, and the copies DISAGREED — one returned NOMINAL where the others
# returned REFUSED_MALFORMED. A refusal had silently become a pass, and the
# published figure was drawn by the most permissive copy. A digest check would
# not have caught it: each fork was a deliberate context-specific edit.
# Only a "defined in one place" rule catches that.
#
# TWO LAWS, TWO HOMES (widened 2026-10-03). The streaming law's constants live in
# Sources/FusionLaw/LawConstants.swift. The operating-point court's constants —
# the Troyon ceiling, the q_min floor, the Greenwald margin and the pi bracket —
# live in Sources/FusionOperatingPoint/FusionOperatingPointLaw.swift. Until this
# date the gate named only the first set, so a second copy of the court's
# constants (one sat in another repository, uncalled) was invisible to it.
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
REPO="$(cd "$HERE/../../.." && pwd)"

# A DEFINITION, not a mention: `let NAME` / `NAME =` at a declaration site.
NAMES='ADC_MIN|ADC_MAX|ENVELOPE_ABS|GROWTH_WINDOW|GROWTH_TRIGGER|PERSIST|adcMin|adcMax|envelopeAbs|growthWindow|growthTrigger|persist'
OP_NAMES='troyonCeilingMilli|qMinFloorMilli|greenwaldMarginPercent|piLo|piHi'

detect() {  # detect <names> <dir> — prints "file:line:text" for each definition found
    grep -rnE "(let|var)[[:space:]]+($1)[[:space:]]*(:[^=]*)?=" \
        --include="*.swift" "$2" 2>/dev/null || true
}

if [ "${1:-}" = "--self-test" ]; then
    # CONTROL ARMS: plant a copy of each law's constant and assert the gate refuses.
    tmp="$(mktemp -d)"; trap 'rm -rf "$tmp"' EXIT
    printf 'let GROWTH_TRIGGER = 900\n' > "$tmp/planted.swift"
    if [ -n "$(detect "$NAMES" "$tmp")" ]; then
        echo "SELF-TEST PASS: the detector fires on a planted streaming-law definition"
    else
        echo "SELF-TEST FAIL: the detector cannot see a planted definition" >&2; exit 1
    fi
    printf 'static let piHi = (num: Int128(355), den: Int128(113))\n' > "$tmp/planted.swift"
    if [ -n "$(detect "$OP_NAMES" "$tmp")" ]; then
        echo "SELF-TEST PASS: the detector fires on a planted operating-point definition"
    else
        echo "SELF-TEST FAIL: the detector cannot see a planted piHi" >&2; exit 1
    fi
    # and it must NOT fire on prose that merely names a constant, or on a consumer
    printf '// GROWTH_TRIGGER is 900 counts; piHi is 355/113\nlet hi = FusionOperatingPointLaw.piHi\nlet piHiNum = 355\n' > "$tmp/planted.swift"
    if [ -n "$(detect "$NAMES" "$tmp")$(detect "$OP_NAMES" "$tmp")" ]; then
        echo "SELF-TEST FAIL: the detector fires on prose or a consumer" >&2; exit 1
    fi
    echo "SELF-TEST PASS: prose naming a constant, and a consumer of it, are not definitions"
    exit 0
fi

violations="$( { detect "$NAMES" "$REPO/reproduce"
                 detect "$NAMES" "$REPO/app" | grep -v "/Sources/FusionLaw/LawConstants.swift:" || true
                 detect "$OP_NAMES" "$REPO/reproduce"
                 detect "$OP_NAMES" "$REPO/app" | grep -v "/Sources/FusionOperatingPoint/FusionOperatingPointLaw.swift:" || true
               } )"

if [ -n "$violations" ]; then
    echo "REFUSED_LAW_DEFINED_TWICE — the law's constants are defined outside their home:" >&2
    echo "$violations" | sed 's/^/  /' >&2
    echo "  homes: Sources/FusionLaw/LawConstants.swift (streaming law)" >&2
    echo "         Sources/FusionOperatingPoint/FusionOperatingPointLaw.swift (operating-point court)" >&2
    echo "  A law written twice IS a hop. Consume the law; do not re-declare it." >&2
    exit 1
fi
echo "ONE_LAW_ONE_HOME_PROVEN — the law's constants are defined in exactly one file each"
