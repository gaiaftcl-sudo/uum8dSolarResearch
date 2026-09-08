#!/bin/bash
# NEGATIVE ARM — ordinary swaps taken from the SAME blocks in which the tool answers
# SANDWICHED for someone else. A tool that says yes to everything is worse than no tool.
set -u
cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1
OUT=logs/wasi; mkdir -p "$OUT"
: > "$OUT/verify-negative.tsv"
while IFS=$'\t' read -r blk tx; do
  f="$OUT/neg-${tx:2:10}.txt"
  ./wasi-sandwiched "$tx" > "$f" 2>&1; rc=$?
  awk -F'\t' -v blk="$blk" -v tx="$tx" -v rc="$rc" '
    /^----------------  VERDICT:  NOT SANDWICHED/ {c=1}
    /^################  VERDICT:  SANDWICHED/ {s=1}
    /^!!!!!!!!!!!!!!!!  VERDICT:  REFUSED/ {r=1}
    $1=="extractive_brackets_anywhere_in_this_block" && e=="" {e=$2}
    $1=="cross_confirmation" && $2 ~ /^AGREE/ {xc=1}
    END{
      c=c+0; s=s+0; r=r+0; xc=xc+0
      if (c==1 && s==0 && rc==0 && xc==1) print "PASS\t"blk"\t"tx"\textractive_in_this_block="e
      else print "FAIL\t"blk"\t"tx"\tclear="c" sand="s" refused="r" rc="rc" xconf="xc
    }' "$f" >> "$OUT/verify-negative.tsv"
done < "$OUT/negatives-run.tsv"
echo "NEGATIVE ARM: $(grep -c '^PASS' "$OUT/verify-negative.tsv") pass / $(grep -c '^FAIL' "$OUT/verify-negative.tsv") fail of $(wc -l < "$OUT/verify-negative.tsv")"
