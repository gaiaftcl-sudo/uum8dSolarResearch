#!/usr/bin/env bash
# fetch-recovered-state.sh — read, from the free public wire, the one quantity each
# NOT_KNOWN row is missing.
#
# INPUT   needs.tsv, written by  extraction-exact --emit-needs --emit-needs-to <file>
#         columns: victim_tx  block  pool_address  status  selector
# OUTPUT  recovered.tsv, consumed by  extraction-exact --recovered <file>
#         columns: victim_tx  sqrtPriceX96_or_dash  feePips_or_dash  source
#
# WHAT IS READ, AND WHY IT IS THE RIGHT STATE
#
#   slot0()  0x3850c7bd  at block N-1
#       The Uniswap V3 pool's price at the END of the block before the sandwich. It is
#       the price at the START of block N, and therefore the price before the front leg
#       — but ONLY if nothing touched that pool earlier in block N. This script does not
#       and cannot check that. The kernel does: it runs the front leg FORWARD from this
#       price and keeps the row NOT_KNOWN unless the leg reproduces exactly. A price that
#       is wrong because an earlier swap moved it will not reproduce, and will be
#       rejected by name. That is the whole safety of this route.
#
#   fee()    0xddca3f43  at latest
#       Immutable on a V3 pool, so the block does not matter. Read once and re-verified
#       against the victim's own leg by the kernel.
#
# NOTHING HERE IS PAID FOR. The endpoint is public and takes no key. If it refuses or
# rate-limits, the row is written as a REFUSAL and stays NOT_KNOWN — a missing answer is
# recorded as missing, never as zero and never as a retry that quietly succeeded on a
# different question.
#
# EVERY EXIT PATH PRINTS THE REFERENCE FIGURES.
set -u
here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
EP="${RPC:-https://rpc.mevblocker.io}"
NEEDS="${1:-$here/needs.tsv}"
OUT="${2:-$here/recovered.tsv}"

reference() {
    echo "== REFERENCE FIGURES =="
    echo "reference_not_known_rows	21"
    echo "reference_class_LIQUIDITY_CHANGED_BETWEEN_LEGS	11"
    echo "reference_class_FRONT_NOT_INVERTIBLE	6"
    echo "reference_class_LEG_NOT_REPRODUCIBLE	3"
    echo "reference_class_FEE_NOT_RECOVERABLE	1"
    echo "reference_slot0_selector	0x3850c7bd"
    echo "reference_fee_selector	0xddca3f43"
    echo "reference_endpoint_is_free	yes, no key, no account"
    echo "reference_published_floor_wei	28889398990674697077"
    echo "reference_published_floor_is_a_FLOOR	a row that closes RAISES it; it was never a ceiling"
}

if [ ! -f "$NEEDS" ]; then
    echo "NEEDS_ABSENT	$NEEDS"
    echo "ABSENT is not a failure and it is not a pass. Produce it with:"
    echo "  extraction-exact --dir <corpus> --start 14000000 --count 1000 --emit-needs --emit-needs-to $NEEDS"
    reference
    exit 4
fi

call() { # $1 = to, $2 = data, $3 = block tag
    curl -s --max-time 45 -X POST -H 'content-type: application/json' \
      --data "{\"jsonrpc\":\"2.0\",\"id\":1,\"method\":\"eth_call\",\"params\":[{\"to\":\"$1\",\"data\":\"$2\"},\"$3\"]}" \
      "$EP"
}

# 32-byte big-endian hex word -> decimal, exactly, with no shell arithmetic:
# bc in base 16 is integer and unbounded. Shell $(( )) is 64-bit and would silently wrap
# a uint160 price, which is the single most likely way to publish a wrong number here.
hex2dec() { echo "ibase=16; $(echo "$1" | tr 'a-f' 'A-F')" | bc; }

: > "$OUT"
echo "# victim_tx	sqrtPriceX96	feePips	source" >> "$OUT"
n=0; ok=0; refused=0; skipped=0
while IFS=$'\t' read -r tx blk pool status sel; do
    case "$tx" in \#*|"") continue;; esac
    n=$((n+1))
    case "$status" in
      NOT_KNOWN_FRONT_NOT_INVERTIBLE)
        tag=$(printf '0x%x' $((blk-1)))
        body=$(call "$pool" "0x3850c7bd" "$tag")
        res=$(printf '%s' "$body" | sed -n 's/.*"result":"0x\([0-9a-f]*\)".*/\1/p')
        if [ -z "$res" ] || [ ${#res} -lt 64 ]; then
            echo "REFUSAL	$tx	slot0	$(printf '%s' "$body" | head -c 160)"
            refused=$((refused+1)); continue
        fi
        dec=$(hex2dec "$(echo "$res" | cut -c1-64)")
        printf '%s\t%s\t-\tslot0()@block_%s\n' "$tx" "$dec" "$((blk-1))" >> "$OUT"
        ok=$((ok+1))
        ;;
      NOT_KNOWN_LEG_NOT_REPRODUCIBLE)
        body=$(call "$pool" "0xddca3f43" "latest")
        res=$(printf '%s' "$body" | sed -n 's/.*"result":"0x\([0-9a-f]*\)".*/\1/p')
        if [ -z "$res" ] || [ ${#res} -lt 64 ]; then
            echo "REFUSAL	$tx	fee	$(printf '%s' "$body" | head -c 160)"
            refused=$((refused+1)); continue
        fi
        dec=$(hex2dec "$res")
        printf '%s\t-\t%s\tfee()@latest_immutable\n' "$tx" "$dec" >> "$OUT"
        ok=$((ok+1))
        ;;
      *)
        # The other two classes do not name a single readable state. They are skipped
        # here on purpose and stay NOT_KNOWN, with the reason already printed by the
        # kernel. Skipping is not the same as failing and is counted separately.
        skipped=$((skipped+1))
        ;;
    esac
done < "$NEEDS"

echo "needs_rows_read	$n"
echo "states_fetched	$ok"
echo "endpoint_REFUSALS	$refused"
echo "rows_with_no_single_readable_state_SKIPPED	$skipped"
echo "written_to	$OUT"
reference
[ "$ok" -gt 0 ] && exit 0
echo "NO_STATE_FETCHED"
exit 4
