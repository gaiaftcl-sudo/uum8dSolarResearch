#!/bin/bash
# validate-ladder.sh — grades homology-detection-ladder, the CONTROL ARM of the
# peptide-homology study.
#
# The study's own validator is validate-homology.sh; this one grades the arm that
# makes the study's headline readable at all. A screen that reports "no homology"
# and a screen that CANNOT find homology produce the same output, so the ladder is
# the instrument that separates them and it needs grading in its own right.
#
# Runs the program with NO ARGV and stdin from /dev/null. Every refusal path must
# still print the published reference figures, so a refusal fails loudly on its
# REASON line rather than silently on a missing pin. Every detector carries
# CONTROLS IN BOTH DIRECTIONS: a float gate that cannot fire and a body with no
# floats are indistinguishable without them.
set -uo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
FAIL=0

check_figure() {   # <label> <expected substring> <file>
  if grep -qF -- "$2" "$3"; then printf '  [pin ] %-46s %s\n' "$1" "$2"
  else printf '  [MISS] %-46s %s\n' "$1" "$2"; FAIL=1; fi
}
check_absent() {   # <label> <string that must NOT appear> <file>
  if grep -qF -- "$2" "$3"; then printf '  [BAD ] %-46s found: %s\n' "$1" "$2"; FAIL=1
  else printf '  [pin ] %-46s absent: %s\n' "$1" "$2"; fi
}

echo "=== homology-detection-ladder (the control arm) ==="
SRC="$HERE/homology-detection-ladder.swift"
BIN="$HERE/.build-homology-detection-ladder"
xcrun swiftc -O -swift-version 5 "$SRC" -o "$BIN" || { echo "  [FAIL] compile"; exit 1; }
echo "  [pin ] compiles with xcrun swiftc -O -swift-version 5"

# --- ZERO FLOAT, and NO ABSOLUTE PATH, both with controls in both directions ---
# Bracket-expression portability note carried from the sibling validator: under
# BSD grep a backslash inside a POSIX bracket expression is NOT an escape, so
# ] must come FIRST inside the class or the detector silently never fires.
TYP='(^|[^A-Za-z0-9_])(CGFloat|Double|Float)([0-9]+)?([^A-Za-z0-9]|$)'
LIT='(^|[^]A-Za-z0-9_.)])[0-9]+\.[0-9]+'
det_typ() { grep -qE "$TYP" "$1"; }
det_lit() { grep -qE "$LIT" "$1"; }
det_abspath() { grep -qE '"(/Users|/private|/tmp|/var|/home)[^"]*"' "$1"; }

BODY="$(mktemp)"
awk 'f{print} /^setvbuf\(stdout, nil, _IONBF, 0\)$/{f=1}' "$SRC" | grep -v '^[[:space:]]*//' > "$BODY"
if [ "$(wc -l < "$BODY")" -lt 300 ]; then
  echo "  [FAIL] body extraction returned $(wc -l < "$BODY") lines — the marker did not match"; FAIL=1
else
  echo "  [pin ] body extracted by marker: $(wc -l < "$BODY") lines of code scanned for floats"
fi
if det_typ "$BODY"; then echo "  [FAIL] float TYPE on the decision path"; grep -nE "$TYP" "$BODY"; FAIL=1
else echo "  [pin ] no float type in the body"; fi
if det_lit "$BODY"; then echo "  [FAIL] float LITERAL on the decision path"; grep -nE "$LIT" "$BODY"; FAIL=1
else echo "  [pin ] no float literal in the body"; fi
if det_abspath "$SRC"; then echo "  [FAIL] an absolute path is baked into the source"; FAIL=1
else echo "  [pin ] no absolute path anywhere in the source"; fi

ctl() {   # <fire|quiet> <detector> <line>
  local want="$1" det="$2" line="$3" f got
  f="$(mktemp)"; printf '%s\n' "$line" > "$f"
  if "$det" "$f"; then got=fire; else got=quiet; fi
  if [ "$got" = "$want" ]; then printf '  [pin ] control %-5s %-12s %s\n' "$want" "$det" "$line"
  else printf '  [FAIL] control %s wanted %s got %s on: %s\n' "$det" "$want" "$got" "$line"; FAIL=1; fi
}
ctl fire  det_typ     'let x: Double = 0'
ctl fire  det_typ     'public var s1: Float'
ctl fire  det_typ     'Array<Double>()'
ctl quiet det_typ     'Doubles are barred from every verdict'
ctl quiet det_typ     'let n: Int32 = 0'
ctl fire  det_lit     'let lambda = 0.267'
ctl fire  det_lit     'var d = 1.5e3'
ctl quiet det_lit     'SIMD16<Int8>(repeating: 0)'
ctl fire  det_abspath 'static let ROOT = "/private/tmp/scratchpad/eric"'
ctl quiet det_abspath 'let rel = "raw/uniprot_human_reviewed.fasta"'

# --- THE RUN: no argv, stdin /dev/null ---------------------------------------
OUT="$HERE/homology-detection-ladder.out"
"$BIN" < /dev/null > "$OUT" 2> "$HERE/homology-detection-ladder.progress"; RC=$?
[ -s "$OUT" ] || { echo "  [FAIL] $OUT is ZERO BYTES — a block-buffered program leaves exactly this"; FAIL=1; }
echo "  exit code $RC"
[ "$RC" -eq 0 ] || { echo "  [FAIL] non-zero exit on good inputs"; FAIL=1; }

check_figure "reference proteins"      "reference proteins        20431"    "$OUT"
check_figure "reference residues"      "reference residues        11418237" "$OUT"
check_figure "window length is the corpus median" "window length             66" "$OUT"
check_figure "gap model stated"        "a gap of length k costs 11 + k"     "$OUT"
check_figure "no e-value"              "no e-value is computed anywhere in this program" "$OUT"
check_figure "reference sha256 COMPUTED" "reference sha256 (computed)  bf1bc7e188e55199a2447fc20d25834db5f7f798daa818432370deb4a6b0df5e" "$OUT"
check_figure "blosum62 externally checked" "blosum62 sha256 (computed)   a2d909d178d587fbaeae1f26eeaaafa65254705a348bf7a48b6b0f87af48ff2c" "$OUT"
check_figure "self-test 10 of 10"      "SELF-TEST: 10 of 10 arms pass"      "$OUT"
check_figure "two kernels agree"       "192 window/protein pairs compared, 0 disagreements" "$OUT"
check_figure "the agreement is not over zeros" "192 of 192 non-zero"        "$OUT"
check_figure "the comparator DOES fire" "W/W=11 and W/A=0 compare unequal"  "$OUT"
check_figure "empty query REFUSED, zero ANSWERED" "empty query refused; C vs W answered as score 0" "$OUT"
check_figure "schedule is a permutation" "66 distinct positions of 66"      "$OUT"
check_figure "completeness, ladder cells" "dynamic programming cells: 72345949632" "$OUT"
check_figure "96 queries x 20431 proteins" "ladder queries 96, every one against every one of the 20431 reference proteins" "$OUT"

# --- THE MEASURED LADDER, pinned row by row ----------------------------------
check_figure "intact 66-mer band"  "     0    66/66     342  367  352  352  329  335  351  356    329   367" "$OUT"
check_figure "40 subs still above the corpus max" "    40    26/66     106  143  140  117  121  105  148  131    105   148" "$OUT"
check_figure "46 subs band"        "    46    20/66      71  106   96   85   83   71  110   84     71   110" "$OUT"
check_figure "every residue substituted" "    66     0/66      56   51   57   55   70   56   60   55     51    70" "$OUT"
check_figure "shuffled window band" "  shuf     0/66      61   62   59   59   56   53   71   61     53    71" "$OUT"
check_figure "argmax is the source at 46 subs" "    46  self  self  self  self  self  self  self  self" "$OUT"
check_figure "argmax is NOT the source when order is destroyed — the column discriminates" "  shuf  O14686" "$OUT"
check_figure "detection floor, ALL 8"  "highest substitution count at which ALL 8 windows still outscore 90: 40  (identity 26/66)" "$OUT"
check_figure "detection floor, ANY"    "highest substitution count at which ANY window still outscores 90: 53  (identity 13/66)" "$OUT"
check_figure "negative rung"           "shuffled windows scoring above 90: 0 of 8" "$OUT"
check_figure "scope: does not measure" "DOES NOT MEASURE: any property of the generated corpus" "$OUT"

# --- THE SEAL: path-independent, timing-independent, coreutils-reproducible ---
TX="$(mktemp)"
sed -n '/^BEGIN LADDER TRANSCRIPT$/,/^END LADDER TRANSCRIPT$/p' "$OUT" > "$TX"
echo "  [pin ] transcript extracted between markers:      $(wc -l < "$TX" | tr -d ' ') lines"
check_absent "no wall-clock inside the seal"    " ms"        "$TX"
check_absent "no absolute path inside the seal" "/Users"     "$TX"
check_absent "no absolute path inside the seal" "/private"   "$TX"
check_absent "no absolute path inside the seal" "/tmp"       "$TX"
check_absent "no absolute path inside the seal" "/var/folders" "$TX"
check_figure "timings printed, after the seal"  "UNSEALED timings" "$OUT"
# CONTROLS: both detectors must be shown able to fire, or "absent" is worthless.
if grep -qF -- " ms" "$OUT"; then echo "  [pin ] control  the \" ms\" detector DOES fire on the full output"
else echo "  [FAIL] control: the \" ms\" detector cannot fire at all"; FAIL=1; fi
PATHPROBE="$(mktemp)"; printf 'x /Users/somebody/y\n' > "$PATHPROBE"
if grep -qF -- "/Users" "$PATHPROBE"; then echo "  [pin ] control  the absolute-path detector DOES fire when a path is present"
else echo "  [FAIL] control: the absolute-path detector cannot fire at all"; FAIL=1; fi
COMPUTED="$(shasum -a 256 < "$TX" | cut -d' ' -f1)"
PRINTED="$(grep '^SEAL' "$OUT" | sed 's/.*= //')"
if [ -n "$PRINTED" ] && [ "$COMPUTED" = "$PRINTED" ]; then
  printf '  [pin ] %-46s %s\n' "seal verified by coreutils shasum" "$COMPUTED"
else
  printf '  [FAIL] %-46s program=%s coreutils=%s\n' "seal mismatch" "$PRINTED" "$COMPUTED"; FAIL=1
fi

# --- REFUSAL PATHS, and the control proving they discriminate ----------------
REAL_FA="$HERE/../raw/uniprot_human_reviewed.fasta"
REAL_CSV="$HERE/../corpus/proteins_validated.csv"
mk_probe() { mkdir -p "$1/raw" "$1/corpus" "$1/reproduce"; cp "$BIN" "$1/reproduce/probe"; }
link_all() {
  rm -f "$1/raw/uniprot_human_reviewed.fasta" "$1/corpus/proteins_validated.csv"
  ln -s "$REAL_FA"  "$1/raw/uniprot_human_reviewed.fasta"
  ln -s "$REAL_CSV" "$1/corpus/proteins_validated.csv"
}
# Every probe runs with its CWD set to the probe root: the root walk starts from
# the WORKING DIRECTORY as well as the executable's directory, so moving the
# binary alone is not a re-root. This cost the sibling study a 39-minute run on
# an arm whose whole purpose was to prove a fast refusal.
arm_refuses() {   # <dir> <label> <expected REASON substring>
  local dir="$1" label="$2" want="$3" o rc
  o="$(mktemp)"
  ( cd "$dir" && ./reproduce/probe < /dev/null ) > "$o" 2>/dev/null; rc=$?
  if [ "$rc" -ne 2 ]; then printf '  [FAIL] %-46s exit %s, wanted 2\n' "$label" "$rc"; FAIL=1; return; fi
  grep -qF -- "$want" "$o" || { printf '  [FAIL] %-46s reason line missing: %s\n' "$label" "$want"; FAIL=1; return; }
  grep -q '^SEAL' "$o" && { printf '  [FAIL] %-46s a seal was emitted on a refusal path\n' "$label"; FAIL=1; return; }
  grep -qF -- "reference proteins        20431" "$o" || { printf '  [FAIL] %-46s refusal path did not print the reference figures\n' "$label"; FAIL=1; return; }
  [ -s "$o" ] || { printf '  [FAIL] %-46s refusal left a ZERO-BYTE file\n' "$label"; FAIL=1; return; }
  printf '  [pin ] %-46s refused, exit 2, no seal, figures printed\n' "$label"
}

PROBE="$(mktemp -d)"; mk_probe "$PROBE"
arm_refuses "$PROBE" "no study root anywhere" "REASON: study root not found"

link_all "$PROBE"
rm -f "$PROBE/raw/uniprot_human_reviewed.fasta"
awk 'NR==2{ n=index($0,"M"); if(n>0){ $0 = substr($0,1,n-1) "G" substr($0,n+1) } } {print}' "$REAL_FA" > "$PROBE/raw/uniprot_human_reviewed.fasta"
if [ "$(wc -c < "$REAL_FA")" = "$(wc -c < "$PROBE/raw/uniprot_human_reviewed.fasta")" ]; then
  echo "  [pin ] control  mutated reference is byte-for-byte the same SIZE (a substitution, not an edit)"
else
  echo "  [FAIL] mutated reference changed size — not a substitution"; FAIL=1
fi
REFMUT="$(shasum -a 256 < "$PROBE/raw/uniprot_human_reviewed.fasta" | cut -d' ' -f1)"
arm_refuses "$PROBE" "reference digest gate fires" "REASON: reference sha256 $REFMUT"

link_all "$PROBE"
rm -f "$PROBE/corpus/proteins_validated.csv"
arm_refuses "$PROBE" "one input missing refuses the walk" "REASON: study root not found"

# CONTROL + PATH-INDEPENDENCE + TIMING-INDEPENDENCE, in one further full run from
# a different root at a different directory depth, over symlinks to the same bytes.
PROBE2="$(mktemp -d)/a/deeper/tree"; mkdir -p "$PROBE2"; mk_probe "$PROBE2"; link_all "$PROBE2"
PO2="$(mktemp)"; ( cd "$PROBE2" && ./reproduce/probe < /dev/null ) > "$PO2" 2>/dev/null; PRC2=$?
PSEAL2="$(grep '^SEAL' "$PO2" | sed 's/.*= //')"
if [ "$PRC2" -eq 0 ] && [ -n "$PSEAL2" ]; then
  echo "  [pin ] control  probe binary on good inputs exits 0 and seals — the refusals above discriminate"
else
  echo "  [FAIL] control: probe binary did not complete on good inputs (exit $PRC2)"; FAIL=1
fi
if [ -n "$PSEAL2" ] && [ "$PSEAL2" = "$PRINTED" ]; then
  printf '  [pin ] %-46s %s\n' "seal PATH-INDEPENDENT and DETERMINISTIC" "$PSEAL2"
else
  printf '  [FAIL] %-46s root2=%s canonical=%s\n' "seal moved between roots or runs" "$PSEAL2" "$PRINTED"; FAIL=1
fi
if grep -qF -- "$PROBE2" "$PO2"; then echo "  [FAIL] the probe printed its own absolute path"; FAIL=1
else echo "  [pin ] the program never prints its resolved root"; fi
timing_total() { sed -n '/^UNSEALED timings/,$p' "$1" | grep -E '^  total +[0-9]+ ms$' | head -1; }
T1="$(timing_total "$OUT")"; T2="$(timing_total "$PO2")"
if [ -z "$T1" ] || [ -z "$T2" ]; then
  echo "  [FAIL] control: the timing detector extracted nothing (T1='$T1' T2='$T2') — absence is not a difference"; FAIL=1
elif [ "$T1" != "$T2" ]; then
  echo "  [pin ] control  two runs, DIFFERENT wall-clock totals ($(echo "$T1" | tr -s ' ') vs $(echo "$T2" | tr -s ' ')), identical seal"
else
  echo "  [FAIL] control: the two runs reported the same total ($T1); timing-independence is untested"; FAIL=1
fi

echo ""
if [ "$FAIL" -eq 0 ]; then echo "VALIDATE-LADDER: PASS"; else echo "VALIDATE-LADDER: FAIL"; fi
exit "$FAIL"
