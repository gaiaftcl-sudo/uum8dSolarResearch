#!/bin/bash
# POSITIVE ARM — every one of the 108 published detections, re-run through the tool over the
# live network and compared field by field against the published row. One awk pass per file:
# under heavy load the fork count, not the tool, was the bottleneck.
set -u
cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1
OUT=logs/wasi; mkdir -p "$OUT"
: > "$OUT/verify-positive.tsv"
awk -F'\t' 'NF==15 && $2 ~ /^0x[0-9a-f]{64}$/ {print $1"\t"$2"\t"$3"\t"$9"\t"$10"\t"$11"\t"$15}' logs/extraction.txt \
| while IFS=$'\t' read -r blk tx kind short lossbp sizebp status; do
  f="$OUT/pos-${tx:2:10}.txt"
  ./wasi-sandwiched "$tx" > "$f" 2>&1; rc=$?
  awk -F'\t' -v blk="$blk" -v tx="$tx" -v kind="$kind" -v short="$short" -v lossbp="$lossbp" \
             -v sizebp="$sizebp" -v status="$status" -v rc="$rc" '
    /^################  VERDICT:  SANDWICHED/ {v=1}
    $1=="SHORTFALL_base_units_exactly" && gs=="" {gs=$2}
    $1=="shortfall_as_ten_thousandths_of_what_you_were_due" && gl=="" {gl=$2}
    $1=="your_swap_as_ten_thousandths_of_the_pool_input_reserve" && gz=="" {gz=$2}
    $1=="block" && gb=="" {gb=$2}
    $1=="reason" && gr=="" {gr=$2}
    $1=="SHORTFALL" && $2=="NOT_KNOWN" {nk++}
    $1=="cross_confirmation" && $2 ~ /^AGREE/ {xc=1}
    END{
      v=v+0; xc=xc+0; nk=nk+0
      if (status=="EXACT" || status=="EXACT_INTERVAL") {
        ok = (v==1 && rc==10 && gs==short && gl==lossbp && gz==sizebp && gb==blk && xc==1)
        if (ok) print "PASS\t"blk"\t"tx"\t"kind"\t"status"\t"gs
        else print "FAIL\t"blk"\t"tx"\t"kind"\t"status"\twant("short","lossbp","sizebp",blk="blk") got("gs","gl","gz",blk="gb") verdict="v" rc="rc" xconf="xc
      } else {
        ok = (v==1 && rc==10 && nk>=1 && gr==status && gb==blk && xc==1)
        if (ok) print "PASS\t"blk"\t"tx"\t"kind"\t"status"\tNOT_KNOWN_reason_matches"
        else print "FAIL\t"blk"\t"tx"\t"kind"\t"status"\tgot_reason="gr" verdict="v" rc="rc" nk="nk" xconf="xc
      }
    }' "$f" >> "$OUT/verify-positive.tsv"
done
echo "POSITIVE ARM: $(grep -c '^PASS' "$OUT/verify-positive.tsv") pass / $(grep -c '^FAIL' "$OUT/verify-positive.tsv") fail of $(wc -l < "$OUT/verify-positive.tsv")"
