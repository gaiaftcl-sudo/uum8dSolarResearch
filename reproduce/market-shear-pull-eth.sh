#!/bin/bash
# Stage a contiguous Ethereum block range: full blocks + full receipts.
# Stored form = jq -S -c of the RPC `result` (key-sorted, whitespace-normalised).
# Lossless: eth JSON-RPC carries every quantity as a hex STRING (verified: 0 bare numbers).
set -u -o pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT="${CORPUS:-$ROOT/corpus/market-shear}/eth"; LOG="$(dirname "${BASH_SOURCE[0]}")/logs-market-shear"; mkdir -p "$OUT" "$LOG"
START=${START:-14000000}; COUNT=${COUNT:-1000}
PRIMARY="https://rpc.mevblocker.io"
BLK_B=25; RCP_B=10
BF="$OUT/blocks.ndjson"; RF="$OUT/receipts.ndjson"
: > "$BF"; : > "$RF"; : > "$LOG/pull.err"

req() { # $1=payload-file $2=endpoint
  curl -s --max-time 180 -X POST -H 'content-type: application/json' --data @"$1" "$2"
}

pull() { # $1=method $2=batchsize $3=outfile $4=params_mode
  local method="$2" ; local bs="$3"; local out="$4"; local pmode="$5"
  local i=$1 end=$(( $1 + COUNT ))
  while [ $i -lt $end ]; do
    local n=$bs; [ $(( i + n )) -gt $end ] && n=$(( end - i ))
    local pay="$OUT/.req.json" ; { printf '['; local k=0
      while [ $k -lt $n ]; do
        local h; h=$(printf '0x%x' $(( i + k )))
        [ $k -gt 0 ] && printf ','
        if [ "$pmode" = "blk" ]; then printf '{"jsonrpc":"2.0","id":%d,"method":"%s","params":["%s",true]}' $(( i + k )) "$method" "$h"
        else printf '{"jsonrpc":"2.0","id":%d,"method":"%s","params":["%s"]}' $(( i + k )) "$method" "$h"; fi
        k=$(( k + 1 ))
      done; printf ']'; } > "$pay"
    local ok=0 try=0 body=""
    while [ $try -lt 6 ]; do
      body=$(req "$pay" "$PRIMARY")
      local len; len=$(printf '%s' "$body" | jq -r 'if type=="array" then ([.[]|select(.result!=null)]|length) else 0 end' 2>/dev/null)
      if [ "${len:-0}" = "$n" ]; then ok=1; break; fi
      try=$(( try + 1 )); echo "retry $method $i try=$try got=${len:-parse_fail}" >> "$LOG/pull.err"; sleep $(( try * 3 ))
    done
    if [ $ok -ne 1 ]; then echo "FATAL $method at $i" >> "$LOG/pull.err"; return 1; fi
    printf '%s' "$body" | jq -S -c 'sort_by(.id)[] | .result' >> "$out" || return 1
    i=$(( i + n ))
    [ $(( (i - $1) % 200 )) -eq 0 ] && echo "$method $((i-$1))/$COUNT $(date -u +%H:%M:%S)" >> "$LOG/pull.progress"
  done
  return 0
}

echo "START=$START COUNT=$COUNT ep=$PRIMARY $(date -u)" > "$LOG/pull.progress"
pull $START eth_getBlockByNumber $BLK_B "$BF" blk || { echo BLOCKS_FAILED; exit 1; }
echo "BLOCKS_DONE $(wc -l < "$BF")" >> "$LOG/pull.progress"
pull $START eth_getBlockReceipts  $RCP_B "$RF" rcp || { echo RECEIPTS_FAILED; exit 1; }
echo "RECEIPTS_DONE $(wc -l < "$RF")" >> "$LOG/pull.progress"
rm -f "$OUT/.req.json"
echo DONE
