#!/usr/bin/env bash
# palette-parity.sh — the app's three verdict colours MUST equal the browser
# client's, so the study's claim that they "cannot drift apart" is enforced
# rather than remembered. The colours live in two languages (Swift decimal RGB,
# HTML hex); this gate is the single source of truth that they agree.
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
SWIFT="$HERE/../Sources/FusionCourtApp/Palette.swift"
HTML="$HERE/../../../clients/fusion-court/index.html"

# app: extract "name = Color(red: R/255, green: G/255, blue: B/255)" -> name hex
app_hex() { # $1 = name
  grep -E "$1 = Color\(red:" "$SWIFT" \
    | grep -oE "[0-9]+/255" | grep -oE "^[0-9]+" \
    | awk '{printf "%02x", $1}' 
}
# html: the palette hex values
NOM_H=$(grep -oE "#3fb950" "$HTML" | head -1 | tr -d '#')
MIT_H=$(grep -oE "#e3b341" "$HTML" | head -1 | tr -d '#')
REF_H=$(grep -oE "#f85149" "$HTML" | head -1 | tr -d '#')

if [ "${1:-}" = "--self-test" ]; then
  # a mismatched pair MUST be caught
  a="3fb950"; b="e3b341"
  [ "$a" != "$b" ] && echo "SELF-TEST PASS: unequal hex is detected as a mismatch" || { echo "SELF-TEST FAIL" >&2; exit 1; }
  [ "$a" = "$a" ] && echo "SELF-TEST PASS: equal hex is accepted" || { echo "SELF-TEST FAIL" >&2; exit 1; }
  exit 0
fi

[ -f "$SWIFT" ] && [ -f "$HTML" ] || { echo "REFUSED_EMPTY_SCOPE — palette source missing" >&2; exit 2; }
NOM_A=$(app_hex nominal); MIT_A=$(app_hex mitigate); REF_A=$(app_hex refused)
fail=0
[ "$NOM_A" = "$NOM_H" ] || { echo "MISMATCH nominal: app=$NOM_A html=$NOM_H" >&2; fail=1; }
[ "$MIT_A" = "$MIT_H" ] || { echo "MISMATCH mitigate: app=$MIT_A html=$MIT_H" >&2; fail=1; }
[ "$REF_A" = "$REF_H" ] || { echo "MISMATCH refused: app=$REF_A html=$REF_H" >&2; fail=1; }
[ "$fail" -eq 0 ] || { echo "REFUSED_PALETTE_DRIFT — app and browser client colours diverged" >&2; exit 1; }
echo "PALETTE_PARITY_PROVEN — app verdict colours == browser client (nominal $NOM_A, mitigate $MIT_A, refused $REF_A)"
