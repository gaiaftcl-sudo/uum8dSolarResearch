#!/bin/bash
# validate-homology.sh — grades peptide-homology-exact.
#
# Runs the program with NO ARGV and stdin from /dev/null, and pins the published
# reference figures. Every refusal path of the program must still print those
# figures, so a refusal fails loudly on its REASON line rather than silently on a
# missing pin.
#
# Every detector in this file carries CONTROLS in both directions. A float gate
# that cannot fire and a body with no floats are indistinguishable without them,
# and "no match found" is the same output as "the pattern was malformed".
set -uo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
FAIL=0

check_figure() {   # check_figure <label> <expected substring> <file>
  if grep -qF -- "$2" "$3"; then printf '  [pin ] %-44s %s\n' "$1" "$2"
  else printf '  [MISS] %-44s %s\n' "$1" "$2"; FAIL=1; fi
}
check_absent() {   # check_absent <label> <string that must NOT appear> <file>
  if grep -qF -- "$2" "$3"; then printf '  [BAD ] %-44s found: %s\n' "$1" "$2"; FAIL=1
  else printf '  [pin ] %-44s absent: %s\n' "$1" "$2"; fi
}

echo "=== peptide-homology-exact ==="
SRC="$HERE/peptide-homology-exact.swift"
BIN="$HERE/.build-peptide-homology-exact"
xcrun swiftc -O -swift-version 5 "$SRC" -o "$BIN" || { echo "  [FAIL] compile"; exit 1; }
echo "  [pin ] compiles with xcrun swiftc -O -swift-version 5"

# ---------------------------------------------------------------------------
# ZERO FLOAT on the decision path: no float TYPE and no float LITERAL in the body.
#
# PORTABILITY, learned the hard way in the sibling study and repeated here so it
# is not relearned: this script runs under #!/bin/bash where grep is BSD grep. In
# a POSIX bracket expression a backslash is NOT an escape, so [^A-Za-z0-9_.)\]]
# closes the class at the \] and silently demands a literal ] afterwards. The
# detector then never fires, and "no float literal found" reads exactly the same
# as a clean body. ] must come FIRST inside the class instead: [^]A-Za-z0-9_.)]
#
# The controls below call the SAME functions the body check calls — a control
# that runs a different invocation is not a control of that detector.
# ---------------------------------------------------------------------------
TYP='(^|[^A-Za-z0-9_])(CGFloat|Double|Float)([0-9]+)?([^A-Za-z0-9]|$)'
LIT='(^|[^]A-Za-z0-9_.)])[0-9]+\.[0-9]+'
det_typ() { grep -qE "$TYP" "$1"; }
det_lit() { grep -qE  "$LIT" "$1"; }

BODY="$(mktemp)"
# Extract the body by MARKER, never by line number: the header comment grows when
# a repair is recorded in it, and an 'NR>N' that has drifted past the first line
# of real code would hide a float rather than find one.
awk 'f{print} /^import simd$/{f=1}' "$SRC" | grep -v '^[[:space:]]*//' > "$BODY"
if [ "$(wc -l < "$BODY")" -lt 400 ]; then
  echo "  [FAIL] body extraction returned $(wc -l < "$BODY") lines — the marker did not match"; FAIL=1
else
  echo "  [pin ] body extracted by marker: $(wc -l < "$BODY") lines of code scanned for floats"
fi
if det_typ "$BODY"; then echo "  [FAIL] float TYPE on the decision path"; grep -nE "$TYP" "$BODY"; FAIL=1
else echo "  [pin ] no float type in the body"; fi
if det_lit "$BODY"; then echo "  [FAIL] float LITERAL on the decision path"; grep -nE "$LIT" "$BODY"; FAIL=1
else echo "  [pin ] no float literal in the body"; fi

ctl() {   # ctl <fire|quiet> <detector> <line>
  local want="$1" det="$2" line="$3" f got
  f="$(mktemp)"; printf '%s\n' "$line" > "$f"
  if "$det" "$f"; then got=fire; else got=quiet; fi
  if [ "$got" = "$want" ]; then printf '  [pin ] control %-5s %-8s %s\n' "$want" "$det" "$line"
  else printf '  [FAIL] control %s wanted %s got %s on: %s\n' "$det" "$want" "$got" "$line"; FAIL=1; fi
}
ctl fire  det_typ 'let x: Double = 0'
ctl fire  det_typ 'var v: [Float32] = []'
ctl fire  det_typ 'public var s1: Float'
ctl fire  det_typ 'let a: [String: Double] = [:]'
ctl fire  det_typ 'Array<Double>()'
ctl fire  det_typ 'let c: CGFloat = 0'
ctl quiet det_typ 'Doubles are barred from every verdict'
ctl quiet det_typ 'let n: Int64 = 0'
ctl fire  det_lit 'let lambda = 0.267'
ctl fire  det_lit 'var d = 1.5e3'
ctl quiet det_lit 'let t = r1.0 == n'
ctl quiet det_lit 'SIMD16<Int8>(repeating: 0)'

# ---------------------------------------------------------------------------
# NO ABSOLUTE PATH BAKED INTO THE SOURCE. A private path is a private
# identifier in a public program. The detector is controlled in both directions.
# ---------------------------------------------------------------------------
det_abspath() { grep -qE '"(/Users|/private|/tmp|/var|/home)[^"]*"' "$1"; }
if det_abspath "$SRC"; then
  echo "  [FAIL] an absolute path is baked into the source"; grep -nE '"(/Users|/private|/tmp|/var|/home)[^"]*"' "$SRC"; FAIL=1
else
  echo "  [pin ] no absolute path anywhere in the source"
fi
ctl fire  det_abspath 'static let ROOT = "/private/tmp/claude-501/scratchpad/eric"'
ctl fire  det_abspath 'let p = "/Users/someone/data"'
ctl quiet det_abspath 'let rel = "corpus/proteins_validated.csv"'
ctl quiet det_abspath 'refuse("study root not found")'

# ---------------------------------------------------------------------------
# The program: NO ARGV, stdin from /dev/null.
#
# RUNTIME, stated so nobody kills it thinking it has hung: the canonical run is
# about 39 minutes — 117,968,246,332,668 dynamic programming cells at a MEASURED
# 60,558 MCUPS aggregate, on a machine that is also running the substrate's own
# daemons — and this script performs TWO full runs, the canonical one and one
# from a different root, because the path-independence of the seal cannot be
# measured without a second root. Budget about 80 minutes. Progress goes to
# stderr; the figures go to stdout unbuffered, so a kill still leaves them.
# ---------------------------------------------------------------------------
OUT="$HERE/peptide-homology-exact.out"
"$BIN" < /dev/null > "$OUT" 2> "$HERE/peptide-homology-exact.progress"; RC=$?
if [ ! -s "$OUT" ]; then
  echo "  [FAIL] $OUT is ZERO BYTES — a block-buffered program leaves exactly this"; FAIL=1
fi
echo "  exit code $RC"
[ "$RC" -eq 0 ] || { echo "  [FAIL] non-zero exit on the real corpus"; FAIL=1; }

# published reference figures — must appear on EVERY path, refusal included
check_figure "corpus rows"           "corpus rows       78680"     "$OUT"
check_figure "corpus distinct"       "corpus distinct   78680"     "$OUT"
check_figure "corpus lengths"        "42 to 90, median 66"         "$OUT"
check_figure "corpus residues"       "corpus residues   5165782"   "$OUT"
check_figure "reference proteins"    "reference proteins 20431"    "$OUT"
check_figure "reference residues"    "reference residues 11418237" "$OUT"
check_figure "gap model stated"      "a gap of length k costs 11 + k" "$OUT"
check_figure "no e-value"            "no e-value is computed anywhere in this program" "$OUT"

# digests must be COMPUTED, not merely printed. "(computed)" is emitted only on
# the path that ran SHA256Exact over the bytes.
check_figure "reference sha256 asserted" "reference sha256  bf1bc7e188e55199a2447fc20d25834db5f7f798daa818432370deb4a6b0df5e" "$OUT"
check_figure "reference sha256 COMPUTED" "reference sha256 (computed)  bf1bc7e188e55199a2447fc20d25834db5f7f798daa818432370deb4a6b0df5e" "$OUT"
check_figure "corpus sha256 COMPUTED"    "corpus sha256 (computed)     bb3691b332fb15cdd54c43bc42905478e53c4f4b01862885a7304260498cf3f7" "$OUT"
check_figure "blosum62 externally checked" "blosum62 sha256 (computed)   a2d909d178d587fbaeae1f26eeaaafa65254705a348bf7a48b6b0f87af48ff2c" "$OUT"

# --- MEASURED FIGURES -------------------------------------------------------
check_figure "self-test 22 of 22"        "SELF-TEST: 22 of 22 arms pass"            "$OUT"
check_figure "completeness, real cells"  "dynamic programming cells, real corpus:  58984123166334" "$OUT"
check_figure "completeness, null cells"  "dynamic programming cells, null corpus:  58984123166334" "$OUT"
check_figure "no query saturated int8"   "saturating queries resolved by the exact Int32 oracle: real 0, null 0" "$OUT"

# the guard is DEMONSTRATED firing, on a real protein, and shown load-bearing
check_figure "A15 guard fires"           "the raw Int8 kernel answers 127 for O00244 while the true score is 355" "$OUT"
check_figure "A16 guard does not fire"   "[PASS] A16"                               "$OUT"
check_figure "A11 self-score identity"   "sum of its BLOSUM62 diagonal is 355"      "$OUT"
check_figure "A13 homology IS found"     "P69905 vs HBB_HUMAN P68871 scores 285"    "$OUT"
check_figure "A13 scramble collapses"    "same beta chain scores 25"                "$OUT"
check_figure "A21 CRLF trap recorded"    "the Character-based split returns 1 line on the real corpus bytes" "$OUT"
check_figure "A14 predicted, not asserted" "1 residues have a proteome run >= 66 and every one attains its ceiling exactly" "$OUT"

# the two implementations agree on the PUBLISHED answers, not only on test cases
check_figure "scalar re-verify agreed"   "agreed 15 of 15"                          "$OUT"
check_figure "top answer re-verified"    "Lung_Cancer_343                    simd   90 @Q12873      scalar   90 @Q12873      AGREE" "$OUT"

# THE ANSWER
check_figure "real range"                "observed minimum 45, observed maximum 90" "$OUT"
check_figure "real sum of maxima"        "sum of maxima 4556252 over 78680"         "$OUT"
check_figure "null range EXCEEDS real"   "observed minimum 45, observed maximum 94" "$OUT"
check_figure "null sum of maxima"        "sum of maxima 4554816 over 78680"         "$OUT"
check_figure "real mode 57"              "     57       7350"                       "$OUT"
check_figure "null mode 57"              "     57       7412"                       "$OUT"
check_figure "real single 90"            "     90          1"                       "$OUT"
check_figure "paired up"                 "real > own shuffle   36128"               "$OUT"
check_figure "paired tie"                "real = own shuffle   6439"                "$OUT"
check_figure "paired down"               "real < own shuffle   36113"               "$OUT"
check_figure "delta zero is the mode"    "      0       6439"                       "$OUT"

# U convention, measured rather than asserted
check_figure "U argmax count"            "queries whose reported argmax protein contains U: 32" "$OUT"
check_figure "U raises one maximum"      "would RISE under the alternative convention U->C: 1"  "$OUT"
check_figure "U sensitivity decidable"   "not exactly decidable from these three screens: 0"    "$OUT"

# low-complexity control: the poly-Q ceiling is attained because a 79-long run exists
check_figure "poly-Q hits its ceiling"   "  Q           330                330  79" "$OUT"
check_figure "poly-W far below ceiling"  "  W           102                726  4"  "$OUT"

# the selection-matched control for the deep null must be PRESENT and non-vacuous
check_figure "deep null control present" "SELECTION-MATCHED CONTROL"                "$OUT"
check_figure "deep null candidates"     "exceeds ALL 128 of their own shuffles: 70 of 91  (769230 ppm)" "$OUT"
check_figure "deep null CONTROL is HIGHER" "CONTROL: shuffle-selected sequences exceeding ALL 128 of their own shuffles: 77 of 92  (836956 ppm)" "$OUT"
check_figure "only the difference is signal" "Only the DIFFERENCE between 769230 ppm and 836956 ppm could be signal" "$OUT"
check_figure "SEAL value"                 "SEAL sha256(transcript) = 419596194df25aa9c9a128e8a0d8511c2d65a35fc8adf7a3de141e2f5b1cbe2f" "$OUT"

# the honest-scope section must survive edits
check_figure "scope: measures"           "MEASURES: the exact optimal local alignment score" "$OUT"
check_figure "scope: does not measure"   "DOES NOT MEASURE: cross-reactivity, MHC presentation" "$OUT"
check_figure "no masking, stated"        "No SEG/DUST low-complexity masking is applied anywhere in this program" "$OUT"
# PINS_END

# ---------------------------------------------------------------------------
# TIMINGS ARE NOT SEALED. What this means to assert is that no wall-clock figure
# appears BETWEEN the transcript markers, so it is scoped there and carries a
# control proving the detector fires outside them.
# ---------------------------------------------------------------------------
TRANS="$(mktemp)"
sed -n "/^BEGIN TRANSCRIPT\$/,/^END TRANSCRIPT\$/p" "$OUT" > "$TRANS"
if [ "$(wc -l < "$TRANS")" -lt 60 ]; then echo "  [FAIL] transcript extraction returned $(wc -l < "$TRANS") lines"; FAIL=1
else echo "  [pin ] transcript extracted between markers: $(wc -l < "$TRANS") lines"; fi
check_absent "no wall-clock inside the seal" " ms"          "$TRANS"
# Scope the path check to path-SHAPED strings. "/" alone is wrong: the transcript
# legitimately carries "521543/78680", "SEG/DUST" and "K/R-rich", so a bare-slash
# detector is red on a clean transcript — the always-red half of the defect.
for P in /Users /private /tmp /var/folders "$HOME"; do
  check_absent "no absolute path inside the seal" "$P" "$TRANS"
done
check_figure "timings printed, after the seal" "UNSEALED timings" "$OUT"
if grep -qF -- " ms" "$OUT"; then echo "  [pin ] control  the \" ms\" detector DOES fire on the full output"
else echo "  [FAIL] control: the \" ms\" detector never fires, so its absence proves nothing"; FAIL=1; fi
# control: the absolute-path detector fires when a path IS present
PTEST="$(mktemp)"; printf 'study root /private/tmp/whatever\n' > "$PTEST"
if grep -qF -- "/private" "$PTEST"; then echo "  [pin ] control  the absolute-path detector DOES fire when a path is present"
else echo "  [FAIL] control: the absolute-path detector never fires"; FAIL=1; fi

# THE SEAL IS A REAL SHA-256, not merely self-consistent.
CALC="$(shasum -a 256 < "$TRANS" | cut -d" " -f1)"
PRINTED="$(grep "^SEAL" "$OUT" | sed "s/.*= //")"
if [ -n "$CALC" ] && [ "$CALC" = "$PRINTED" ]; then printf '  [pin ] %-44s %s\n' "seal verified by coreutils shasum" "$CALC"
else printf '  [FAIL] %-44s program=%s coreutils=%s\n' "seal does not match an independent sha256" "$PRINTED" "$CALC"; FAIL=1; fi

# ---------------------------------------------------------------------------
# THE REFUSAL PATHS ARE SHOWN TO FIRE, and the SEAL IS SHOWN TO BE
# PATH-INDEPENDENT. A digest that is merely PRINTED and a digest that is CHECKED
# produce the same green line from outside the program, and pinning the digest
# string alone reproduces that defect one level up. These arms swap the inputs
# under the SAME binary and require the refusal, its reason, its exit code, and
# the ABSENCE of a seal.
#
# Re-rooting needs no source edit here, because no absolute path is baked in:
# the program finds its study root by walking up from its own location. Moving
# the binary IS the re-root.
# ---------------------------------------------------------------------------
REAL_FA="$HERE/../raw/uniprot_human_reviewed.fasta"
REAL_CSV="$HERE/../corpus/proteins_validated.csv"

mk_probe() {  # mk_probe <dir>
  mkdir -p "$1/raw" "$1/corpus" "$1/reproduce"
  cp "$BIN" "$1/reproduce/probe"
}
link_all() {  # link_all <dir>
  rm -f "$1/raw/uniprot_human_reviewed.fasta" "$1/corpus/proteins_validated.csv"
  ln -s "$REAL_FA"  "$1/raw/uniprot_human_reviewed.fasta"
  ln -s "$REAL_CSV" "$1/corpus/proteins_validated.csv"
}
# RE-ROOTING MEANS CONTROLLING THE WORKING DIRECTORY TOO, and this line is here
# because the first version of this script did not, and the arm below did not
# test what it claimed.
#
# The program finds its study root by walking up from TWO starting points: the
# executable's own directory, and the WORKING DIRECTORY. validate.sh is run from
# inside the real study tree, so a probe binary copied to an empty temporary root
# still found the real corpus and the real reference through the CWD start — and
# instead of refusing in milliseconds it ran the entire 39-minute study. Measured:
# one probe at 431% CPU for 13 minutes on an arm whose whole purpose was to prove
# a fast refusal.
#
# The arm passed when it was run by hand earlier ONLY because that shell's working
# directory happened to be outside the study tree. Same binary, same probe, same
# assertion, opposite result, decided by ambient state the arm never mentioned.
# So every probe invocation below runs with its CWD set to the probe root.
arm_refuses() {   # arm_refuses <dir> <label> <expected REASON substring>
  local dir="$1" label="$2" want="$3" o rc
  o="$(mktemp)"
  ( cd "$dir" && ./reproduce/probe < /dev/null ) > "$o" 2>/dev/null; rc=$?
  if [ "$rc" -ne 2 ]; then printf '  [FAIL] %-44s exit %s, wanted 2\n' "$label" "$rc"; FAIL=1; return; fi
  grep -qF -- "$want" "$o" || { printf '  [FAIL] %-44s reason line missing: %s\n' "$label" "$want"; FAIL=1; return; }
  grep -q '^SEAL' "$o" && { printf '  [FAIL] %-44s a seal was emitted on a refusal path\n' "$label"; FAIL=1; return; }
  grep -qF -- "corpus rows       78680" "$o" || { printf '  [FAIL] %-44s refusal path did not print the reference figures\n' "$label"; FAIL=1; return; }
  [ -s "$o" ] || { printf '  [FAIL] %-44s refusal left a ZERO-BYTE file\n' "$label"; FAIL=1; return; }
  printf '  [pin ] %-44s refused, exit 2, no seal, figures printed\n' "$label"
}

PROBE="$(mktemp -d)"; mk_probe "$PROBE"

# ARM: no study root at all. The walk must refuse, not invent a default.
arm_refuses "$PROBE" "no study root anywhere" "REASON: study root not found"

# ARM: reference substituted by ONE residue. Counts stay identical; only the
# digest moves. This is the exact case that let the sibling study seal a verdict
# over a file it had never read.
link_all "$PROBE"
rm -f "$PROBE/raw/uniprot_human_reviewed.fasta"
awk 'NR==2{ n=index($0,"M"); if(n>0){ $0 = substr($0,1,n-1) "G" substr($0,n+1) } } {print}' "$REAL_FA" > "$PROBE/raw/uniprot_human_reviewed.fasta"
if [ "$(wc -c < "$REAL_FA")" = "$(wc -c < "$PROBE/raw/uniprot_human_reviewed.fasta")" ]; then
  echo "  [pin ] control  mutated reference is byte-for-byte the same SIZE (a substitution, not an edit)"
else
  echo "  [FAIL] mutated reference changed size — not a substitution"; FAIL=1
fi
arm_refuses "$PROBE" "reference digest gate fires" "REASON: reference sha256 9cf50af6daa50fd2737975c90ab9e206de91bbb6a61011b691bf15f7dd5dc3ae"

# ARM: corpus substituted by ONE residue. Rows, residues and lengths all identical.
link_all "$PROBE"
rm -f "$PROBE/corpus/proteins_validated.csv"
perl -pe 'if ($. == 2) { s/K/R/ }' "$REAL_CSV" > "$PROBE/corpus/proteins_validated.csv"
if [ "$(wc -c < "$REAL_CSV")" = "$(wc -c < "$PROBE/corpus/proteins_validated.csv")" ]; then
  echo "  [pin ] control  mutated corpus is byte-for-byte the same SIZE"
else
  echo "  [FAIL] mutated corpus changed size — not a substitution"; FAIL=1
fi
CORPMUT="$(shasum -a 256 < "$PROBE/corpus/proteins_validated.csv" | cut -d' ' -f1)"
arm_refuses "$PROBE" "corpus digest gate fires" "REASON: corpus sha256 $CORPMUT"

# ARM: reference present, corpus absent. The walk requires BOTH, so this refuses
# at the root walk rather than half-running.
link_all "$PROBE"
rm -f "$PROBE/corpus/proteins_validated.csv"
arm_refuses "$PROBE" "one input missing refuses the walk" "REASON: study root not found"

# ONE further FULL run, at a DIFFERENT root and a different directory depth,
# over symlinks to the same bytes. It carries three arms at once:
#   (a) CONTROL — the probe binary is NOT always-refuse: on good inputs it
#       exits 0 and seals, so the four refusals above are discriminations.
#   (b) the SEAL IS PATH-INDEPENDENT — byte-identical to the canonical run's
#       seal from a different root. This is what "never digest an absolute path"
#       has to mean from outside the program.
#   (c) the SEAL IS DETERMINISTIC and TIMING-INDEPENDENT — it is a second,
#       independent execution with different wall-clock timings throughout.
# This is the second of the two full runs the runtime note above budgets for.
PROBE2="$(mktemp -d)/a/deeper/tree"; mkdir -p "$PROBE2"; mk_probe "$PROBE2"; link_all "$PROBE2"
PO2="$(mktemp)"; ( cd "$PROBE2" && ./reproduce/probe < /dev/null ) > "$PO2" 2>/dev/null; PRC2=$?
PSEAL2="$(grep '^SEAL' "$PO2" | sed 's/.*= //')"
if [ "$PRC2" -eq 0 ] && [ -n "$PSEAL2" ]; then
  echo "  [pin ] control  probe binary on good inputs exits 0 and seals — the refusals above discriminate"
else
  echo "  [FAIL] control: probe binary did not complete on good inputs (exit $PRC2)"; FAIL=1
fi
if [ -n "$PSEAL2" ] && [ "$PSEAL2" = "$PRINTED" ]; then
  printf '  [pin ] %-44s %s\n' "seal PATH-INDEPENDENT and DETERMINISTIC" "$PSEAL2"
else
  printf '  [FAIL] %-44s root2=%s canonical=%s\n' "seal moved between roots or runs" "$PSEAL2" "$PRINTED"; FAIL=1
fi
if grep -qF -- "$PROBE2" "$PO2"; then echo "  [FAIL] the probe printed its own absolute path"; FAIL=1
else echo "  [pin ] the program never prints its resolved root"; fi
# The two runs' timings must DIFFER, or "timing-independent" is untested.
#
# GRADE THE LINE YOU MEAN. The first version of this arm used grep '^  total '
# and took head -1. That pattern matches TWO lines: the sealed transcript's
# "  total deep-null alignments computed: 11648" and the unsealed
# "  total              2322230 ms". head -1 picked the transcript one, which is
# identical in every run BY DESIGN, so the control reported "the two runs
# reported the same total" and failed the gate on a line that was never a timing.
# The detector is now scoped to the UNSEALED section and to the ms shape, and it
# is checked for having extracted anything at all — an empty T1 and two equal
# timings are the same string comparison and must not read the same.
timing_total() { sed -n '/^UNSEALED timings/,$p' "$1" | grep -E '^  total +[0-9]+ ms$' | head -1; }
T1="$(timing_total "$OUT")"
T2="$(timing_total "$PO2")"
if [ -z "$T1" ] || [ -z "$T2" ]; then
  echo "  [FAIL] control: the timing detector extracted nothing (T1='$T1' T2='$T2') — absence is not a difference"; FAIL=1
elif [ "$T1" != "$T2" ]; then
  echo "  [pin ] control  two runs, DIFFERENT wall-clock totals ($(echo "$T1" | tr -s ' ') vs $(echo "$T2" | tr -s ' ')), identical seal"
else
  echo "  [FAIL] control: the two runs reported the same total ($T1); timing-independence is untested"; FAIL=1
fi

echo ""
if [ "$FAIL" -eq 0 ]; then echo "VALIDATE: PASS"; else echo "VALIDATE: FAIL"; fi
exit "$FAIL"
