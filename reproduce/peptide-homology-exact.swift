// peptide-homology-exact.swift
// ===========================================================================
// THE STUDY:  DOES ANY OF THE 78,680 GENERATED PEPTIDES HAVE DETECTABLE
//             HOMOLOGY TO A HUMAN PROTEIN *UNDER SUBSTITUTION*?
//
// This is a DIFFERENT MEASUREMENT from the novelty study that preceded it, not
// a refinement of it.  That study measured EXACT SUBSTRING IDENTITY and said so:
// the longest exact substring any of the 78,680 shares with a reviewed human
// protein is 12 residues, mode 7, mean 521543/78680.  Its own stated limit was
// that it is blind to homology under substitution — a 66-mer 80% identical to a
// human protein with scattered mismatches lands in the same bin as an unrelated
// one.  So "novel" there meant "shares no long exact substring", and nothing
// about self-recognition followed from it.
//
// This program answers the question that does bear on self-recognition:
//   for every one of the 78,680 sequences, the EXACT optimal Smith-Waterman
//   local alignment score against the WHOLE reviewed human proteome, with
//   BLOSUM62 and integer affine gaps, together with the accession attaining it,
//   the complete distribution of those maxima, and an EXPLICITLY COMPUTED
//   composition-matched null to compare it against.
//
// ---------------------------------------------------------------------------
// WHY THIS IS A ZERO-FLOAT MEASUREMENT AND THE CONVENTIONAL TOOL IS NOT
//
//   Smith-Waterman with BLOSUM62 and affine gaps is exact integer dynamic
//   programming.  Every score is an integer and the optimal local alignment
//   score is uniquely determined by the recurrence.  The float enters the
//   conventional pipeline only AFTERWARDS, when that integer is converted to an
//   E-value through fitted Gumbel parameters (lambda, K) — and it is that
//   conversion, not the alignment, that decides whether a hit is reported.
//   BLAST additionally uses a heuristic seeding step that can MISS a real
//   alignment entirely; exact Smith-Waterman cannot miss one.
//
//   So this program keeps the integer.  It runs the complete computation with
//   no seeding heuristic and no cutoff inside the arithmetic, publishes the
//   full score distribution, and builds its null by explicit computation.
//   NO E-VALUE IS COMPUTED ANYWHERE.  There is no fitted parameter in the file.
//
// ---------------------------------------------------------------------------
// COMPLETE, and what that word is being used to mean here.
//
//   Every one of the 78,680 queries is aligned against every one of the 20,431
//   reference proteins — 5,165,782 x 11,418,237 = 58,984,123,166,334 dynamic
//   programming cells for the real corpus, and the same again for the null,
//   117,968,246,332,668 in total.  No sampling.  No seeding.  No cutoff inside
//   the computation.  The reporting threshold is applied AFTER the arithmetic,
//   to an already-published distribution, so a reader can re-make that choice.
//
//   AND THE PUBLISHED COMPLETENESS FIGURE IS THE WORK, NOT THE INPUT SIZES.
//   Until 2026-09-07 this program printed 5,165,782 x 11,418,237 into the
//   transcript and called it completeness.  That product is a restatement of the
//   two file sizes: it is computed from the parsed inputs and is IDENTICAL
//   whatever the screen then did.
//
//   THE POSITIVE CONTROL, MEASURED HERE RATHER THAN QUOTED, with its recipe so
//   anyone can repeat it.  Take the PRE-REPAIR source and restrict FIVE call
//   sites to the first 400 of the 20,431 proteins — the real screen, the null
//   screen, both deep-null screens, and the scalar re-verification:
//
//     sed -e 's|screen(qSeq, allProt,|screen(qSeq, Array(allProt.prefix(400)),|' \
//         -e 's|screen(nullQ, allProt,|screen(nullQ, Array(allProt.prefix(400)),|' \
//         -e 's|screen(deepQ, allProt,|screen(deepQ, Array(allProt.prefix(400)),|' \
//         -e 's|screen(deepQN, allProt,|screen(deepQN, Array(allProt.prefix(400)),|' \
//         -e 's|scalarOverProteins(qSeq\[qi\], allProt,|scalarOverProteins(qSeq[qi], Array(allProt.prefix(400)),|'
//
//   That build runs in 78 seconds instead of 35 minutes and:
//     * EXITS 0 and SEALS — 93145f1ce7d0ae2064f2164461a323af90392992da45c6bd6bb6b5dfb589d0c8
//     * passes 22 of 22 self-test arms
//     * prints "every query against every reference protein, no exceptions"
//     * prints "dynamic programming cells, real corpus:  58984123166334" —
//       the IDENTICAL figure the complete run prints
//     * and every published figure in it is WRONG: maximum 84 against the true
//       90, sum of maxima 3,668,659 against the true 4,556,252, floor 35 against 45, sign split 36,275 / 36,047 against 36,128 / 36,113.
//
//   The truncation has to be CONSISTENT to get that far, and that is itself worth
//   recording: truncating only the four screens and leaving the scalar
//   re-verification at full scope is caught, by the re-verification, with 7 of 15
//   published answers disagreeing.  The gate that caught it was not the
//   completeness gate and was not looking for this.  So the old figure was not
//   defenceless — it was defended by an instrument aimed at something else, which
//   is exactly the state in which a defect survives a review.
//
//   A claim that cannot fail is not a claim.
//
//   The figure is now ACCUMULATED INSIDE kernelBlock, one addition per protein
//   visited, as realLanes * m * proteinLength, together with a query-protein
//   VISIT counter incremented on the same line.  Both are summed per block and
//   returned by the screen, and the run REFUSES before any seal unless they
//   equal the complete product exactly.  A screen that skips proteins, skips
//   queries or shortens either now reports a SMALLER number and refuses.  The
//   discrimination is demonstrated, not argued: a deliberately truncated build
//   is run in validate-homology.sh and its refusal is required.
//
// ---------------------------------------------------------------------------
// AND NEITHER IS A CALL THAT CANNOT FAIL.  "=== THE ANSWER ===" used to publish
// three distributions, a paired sign split and a control, and then go straight to
// what the study does not measure — leaving the reader to infer the answer from
// four tables.  It now STATES the answer.  The danger in doing that is obvious
// and is the same one: a paragraph that says SAME and EXCEEDS and COIN whatever
// the numbers did would be the completeness defect reintroduced as prose.
//
// So every direction word in the call is computed by direction(), the mode by
// modeOf(), the resolution floor by smallestK(), and WHICH BRANCH of the call is
// printed by a count of the three comparisons.  A24 exercises direction() and
// modeOf() in all three branches.  And the OTHER BRANCH OF THE CALL HAS BEEN
// OBSERVED — not reasoned about.  Build this file with the same five call sites
// restricted to 400 proteins as above and with the two requireComplete() calls
// commented out, run it, and the transcript prints:
//
//     (1) the real maximum EXCEEDS the null's:  84 against 82
//     (2) the paired sign leans to the REAL side:  36275 above own shuffle, 36047 below
//     (3) the deep-null candidates come back ABOVE their selection-matched control:
//         855555 ppm against 802197 ppm
//     Toward a signal: 3 of 3.  Against: 0 of 3.  Level: 0 of 3.
//     A SEQUENCE-LEVEL SIGNAL SURVIVES ALL THREE COMPARISONS.  ...
//     84 sits ABOVE the null's own maximum of 82, so it stands outside the range
//     its own permuted residues reach.
//
// All three direction words flipped, the mode moved from 57 to 45, and the call
// printed its other branch.  That is a demonstration on real bytes that the
// sentence follows the measurement.  The 400-protein answer is of course WRONG —
// that is why requireComplete() has to be disabled to see it, and why the shipped
// program refuses it.
//
// ---------------------------------------------------------------------------
// THE ALGORITHM, and why it is exact rather than merely fast.
//
//   INTER-SEQUENCE SIMD.  64 queries are aligned at once, each in its own lane
//   of four interleaved SIMD16<Int8> registers, against one shared reference
//   stream.  Lane l holds an INDEPENDENT scalar Smith-Waterman recurrence for
//   query l.  Nothing is shared between lanes: no carry, no shift, no shuffle.
//   The exactness argument is therefore the whole of it — sixteen scalar DPs
//   evaluated side by side are sixteen scalar DPs.
//
//   This was chosen over striped Smith-Waterman (Farrar) on measurement, and
//   the measurement is reported at the end of the run.  Striped SW reorders the
//   evaluation within one query and needs a lazy-F correction loop whose
//   exactness is a real argument; measured here at 569 MCUPS/core against 8,874
//   MCUPS/core for the inter-sequence form.  The faster kernel is also the one
//   with the shorter correctness proof, so there was nothing to trade.
//
//   WHAT THE KERNEL COMPILES TO, and the SCOPE of that claim, which is the whole
//   correction.  The builder's note read "0 bl, 6 smax.16b in the kernel".  That
//   is true of the HOT INNER LOOP and false of kernelBlock, and the two are not
//   the same object: the loop is 52 instructions and the function is 417.
//   Re-measured 2026-09-07 on the built binary with otool -tvV.  NO ADDRESS IS
//   QUOTED HERE, deliberately: addresses move with every build, and a comment
//   naming one becomes a stale pointer within a day.  The inner loop is found
//   instead by its own structure — the unique backward branch inside kernelBlock
//   whose span is between 20 and 100 instructions — which re-finds it on any
//   build:
//
//     hot inner loop (the `for _ in 0..<m` body, span 52):
//       52 instructions — 24 smax.16b, 12 sub.16b, 6 ldp, 4 stp, 4 add.16b,
//       subs, b.ne.  ZERO calls.  ZERO fmov.  Nothing that touches the FP unit.
//     kernelBlock as a whole:
//       417 instructions, 28 smax.16b, ZERO fmov, and FIVE bl — one memset per
//       protein (the H/F clear) and four SIMD16<Int8>.min in the COLD
//       per-protein tie update.  Four ldp/stp of d-registers, which are the
//       callee-saved vector spills of the prologue and epilogue.
//     the whole program image:
//       ZERO floating-point ARITHMETIC instructions, and that adjective is
//       load-bearing.  There are exactly TWO fmov in the entire image — `fmov
//       w0, s0` inside the specialised SIMD16<Int8>.min, and `fmov x0, d0`
//       inside ScreenResult's value-witness copy.  Both move BITS between the
//       vector and general register files; neither interprets its operand as a
//       float.  A sweep that counts fmov as floating-point returns 2, not 0, and
//       saying "zero floating-point instructions anywhere in the image" without
//       that qualification is a claim this build does not support.
//
//   The distinction matters because "0 bl in the kernel" invites the reader to
//   believe there is no call anywhere in the per-protein path, and there are five.
//   None of them is in the loop that runs 58,984,123,166,334 times, which is the
//   thing the claim was actually about.
//
//   Blocks hold 64 queries OF EQUAL LENGTH, so there is no padding inside a
//   block and therefore no masking of pad lanes — the last block of each length
//   class is filled by repeating a query already in it and the duplicate lanes'
//   answers are discarded.  A pad lane cannot contaminate a real one in any
//   case, because the recurrence flows from lower query index to higher and
//   never back, but the equal-length blocking means that argument is not load
//   bearing.
//
// ---------------------------------------------------------------------------
// INT8 SATURATION, the guard, and the proof the guard cannot miss.
//
//   Lanes are Int8, so a score above 127 cannot be represented.  Swift's SIMD
//   arithmetic is wrapping, not saturating, so an overflow is silent.  The
//   guard is exact, and this is the argument:
//
//     Every H value is clamped at 0 below, so H is in [0, 127] when it does not
//     overflow.  The only place a value can grow is H = max(0, Hdiag + s, E, F),
//     and s <= 11 (the largest BLOSUM62 entry, W:W).  E and F are derived from H
//     by subtraction and are bounded below by -12, so they never wrap.
//
//     THE QUANTIFIER IS EVALUATION ORDER, NOT AN OPTIMAL PATH.  This argument
//     read "the first cell along an optimal path whose true value exceeds 116"
//     until 2026-09-07.  That quantifier does not match the property the code
//     has: the code does not know an optimal path, and "first along a path" is
//     not a well-founded induction over the cells it actually evaluates.  The
//     property it does have is over the order in which cells are computed, and
//     that order is total and fixed: reference position j outer, query position
//     i inner.  Every input to cell (i, j) — Hdiag from (i-1, j-1), the vertical
//     E from (i-1, j), the horizontal F from (i, j-1) — is evaluated STRICTLY
//     EARLIER in that order.  So:
//
//     Suppose some cell's true value exceeds 116.  Take the FIRST SUCH CELL IN
//     EVALUATION ORDER.  Every cell evaluated before it has true value <= 116,
//     so no wrap has occurred in any of them and every one of them is computed
//     exactly.  Its three inputs are among those, so they are exact and <= 116;
//     E and F are further <= 116 - 12 = 104 and >= -12.  Its own value is
//     therefore max(0, Hdiag + s, E, F) <= 116 + 11 = 127, which fits in Int8,
//     so it too is computed exactly, and its value — greater than 116 — is
//     written into the running maximum by the very next instruction.  Therefore:
//
//         computed maximum <= 116  IMPLIES  no wrap occurred anywhere
//                                   IMPLIES  computed maximum IS the true value.
//
//     The induction is over the evaluation order the kernel executes, which is
//     the same order in the SIMD kernel and the scalar oracle, and each of the
//     16 lanes is an independent instance of it.
//
//   The guard re-runs any query whose Int8 maximum reaches 100 in the exact
//   Int32 scalar oracle.  100 is strictly inside the proven-safe bound of 116,
//   so the guard is conservative rather than tight.  It is DEMONSTRATED firing
//   in self-test arm A15 (a real human protein, whose self-score is far above
//   127, where the Int8 answer and the true answer are shown to DIFFER) and
//   demonstrated NOT firing in A16.  A guard that has never been seen to fire
//   is indistinguishable from a guard that cannot.
//
// ---------------------------------------------------------------------------
// THE 21st LETTER.  The reference alphabet is 21 letters, not 20: U
// (selenocysteine) occurs 36 times, in 25 proteins.  BLOSUM62 has no U.  U is
// scored here through the BLOSUM62 X row (the matrix's own ambiguity row).
// The corpus contains no U, so a query residue is never U and only the column
// s(a, U) is ever read.
//
// This convention is not asserted to be harmless — it is MEASURED.  The 25
// U-bearing proteins are re-screened under the alternative convention U->C
// (selenocysteine as its sulphur analogue cysteine) and the number of published
// maxima that would change is reported.  See the U-SENSITIVITY section of the
// transcript.
//
// ---------------------------------------------------------------------------
// GAP MODEL, stated so it is comparable to the conventional tool.
//   BLASTP defaults: a gap of length k costs 11 + k.  In the recurrence below
//   that is written as an opening penalty of 12 for the first gap position and
//   1 for each further one:
//       E[i][j] = max(E[i-1][j] - 1, H[i-1][j] - 12)      gap in the reference
//       F[i][j] = max(F[i][j-1] - 1, H[i][j-1] - 12)      gap in the query
//       H[i][j] = max(0, H[i-1][j-1] + s(q_i, r_j), E[i][j], F[i][j])
//
//   E AND F ARE NOT CLAMPED AT 0, and this comment said they were until
//   2026-09-07.  Neither swPair, nor swPairMat, nor kernelBlock contains such a
//   clamp; all three initialise E and F to 0 at the start of a reference and
//   thereafter take max(prev - 1, H - 12) with nothing else in the max.  Since
//   H >= 0 always, that expression is bounded BELOW BY EXACTLY -12 — H - 12 is
//   at worst -12, and prev - 1 can only reach -12 from a value that was already
//   >= -11.  So E and F live in [-12, 115] and cannot approach the Int8 floor.
//   This is the standard Gotoh recurrence and it is what every published figure
//   in this study was computed with; only the comment was wrong.  The COMMENT
//   was the defect, not the code, and the repair is to describe the code.
//   A6 checks the SIMD kernel against the Int32 scalar oracle cell for cell, so
//   whatever E and F do, the two implementations are shown to do the same thing.
//
// TIE RULE, stated as required.  When two reference proteins attain the same
// maximum for one query, the one appearing EARLIER IN THE REFERENCE FILE wins.
// The screen visits proteins in file order and updates the best only on a
// STRICT improvement, so the first attaining protein is the one retained.  File
// order is the UniProt download order and is fixed by the reference digest.
//
// ---------------------------------------------------------------------------
// HOUSE RULES HONOURED HERE
//   * Swift 6.4 law, built with  xcrun swiftc -O -swift-version 5
//   * ZERO FLOAT on any decision path.  No Double, no Float, no CGFloat, no
//     floating literal.  Every ratio is integer parts-per-million by integer
//     division.  Timing is integer nanoseconds from clock_gettime.
//   * NO ABSOLUTE PATH IN THE SOURCE.  The study root is found by walking up
//     from the executable's own location (and then from the working directory)
//     to the first ancestor holding both corpus/proteins_validated.csv and
//     raw/uniprot_human_reviewed.fasta.  A private path is not a public
//     constant, and re-rooting the program is what the refusal arms in
//     validate-homology.sh do — they place the same binary somewhere else.
//     (This read "validate.sh" until 2026-09-07.  validate.sh is a different
//     script grading a different program — protein-novelty-exact — and contains
//     no probe of this one; `grep -c peptide-homology validate.sh` returns 0.
//     A comment naming the wrong validator is a stale pointer of exactly the
//     kind this program spends its header cataloguing.)
//   * THE MEASUREMENT PATH TAKES NO ARGV.  Run with no argument it performs the
//     study; argv[0] is not read on that path.  EXACTLY ONE reserved argument
//     exists, "--self-probe-zero-query", and it exists because self-test arm A20
//     could not otherwise be a measurement: screen() refuses an empty query list
//     by calling exit(2), which cannot be observed in-process, and fork() is
//     unavailable in Swift on Darwin ("Please use threads or posix_spawn*()").
//     A20 therefore spawns THIS SAME EXECUTABLE IMAGE with that one argument, and
//     the child reaches the real call site — screen([], [], [], ...) — with a
//     genuinely empty list.  A20 grades the child's exit code, its REASON line
//     and the ABSENCE of a seal.  Any other argument is refused.  Before the
//     repair A20 was arm("A20", ..., true, ...): a literal true, inside a
//     self-test whose stated doctrine is that always-green and always-red are the
//     same defect, counting toward the published arm total.
//   * stdout is UNBUFFERED from the first statement, so an abnormal exit still
//     leaves the published figures on disk rather than a zero-byte file.
//   * EVERY exit path prints the pinned reference figures, before any file is
//     opened, so no early exit can be uninstrumented.
//   * BOTH inputs are HASHED and the program REFUSES on mismatch.  A digest
//     that is printed and a digest that is checked look identical from outside;
//     only the second one is worth anything.
//   * The scoring matrix is CROSS-CHECKED against an external, independently
//     produced BLOSUM62 that this program does not read: the canonical 20x20
//     rendering must digest to the pinned value derived from that file.
//   * A sha256 seal over the verdict transcript, from the self-contained
//     SHA-256 below.  The seal is PATH-INDEPENDENT and TIMING-INDEPENDENT: no
//     path and no wall-clock figure appears between the transcript markers.
//     Timings are printed after the seal.  A seal that moves when nothing about
//     the answer moved is a turn counter.
// ===========================================================================

import Foundation
import simd

setvbuf(stdout, nil, _IONBF, 0)

// ---------------------------------------------------------------------------
// PINNED REFERENCE FIGURES — printed as the very first action, before any file
// is opened, so that every refusal path carries them.
// ---------------------------------------------------------------------------
let PIN_CORPUS_ROWS      = 78680
let PIN_CORPUS_DISTINCT  = 78680
let PIN_CORPUS_MINLEN    = 42
let PIN_CORPUS_MAXLEN    = 90
let PIN_CORPUS_MEDLEN    = 66
let PIN_CORPUS_RESIDUES  = 5165782
let PIN_REF_PROTEINS     = 20431
let PIN_REF_RESIDUES     = 11418237
let PIN_CORPUS_SHA = "bb3691b332fb15cdd54c43bc42905478e53c4f4b01862885a7304260498cf3f7"
let PIN_REF_SHA    = "bf1bc7e188e55199a2447fc20d25834db5f7f798daa818432370deb4a6b0df5e"
// sha256 of the canonical 20x20 BLOSUM62 rendering (rows A R N D C Q E G H I L
// K M F P S T W Y V, values decimal, single-space separated, one row per line,
// trailing newline).  Derived OUTSIDE this program from an independently
// produced BLOSUM62 data file that this program never opens.  If the embedded
// matrix below is wrong in any single cell, this gate refuses.
let PIN_B62_SHA    = "a2d909d178d587fbaeae1f26eeaaafa65254705a348bf7a48b6b0f87af48ff2c"

print("PEPTIDE HOMOLOGY UNDER SUBSTITUTION — exact Smith-Waterman, BLOSUM62, integer affine gaps")
print("published reference figures (pinned, printed before any file is opened):")
print("  corpus rows       \(PIN_CORPUS_ROWS)")
print("  corpus distinct   \(PIN_CORPUS_DISTINCT)")
print("  corpus lengths    \(PIN_CORPUS_MINLEN) to \(PIN_CORPUS_MAXLEN), median \(PIN_CORPUS_MEDLEN)")
print("  corpus residues   \(PIN_CORPUS_RESIDUES)")
print("  reference proteins \(PIN_REF_PROTEINS)")
print("  reference residues \(PIN_REF_RESIDUES)")
print("  corpus sha256     \(PIN_CORPUS_SHA)")
print("  reference sha256  \(PIN_REF_SHA)")
print("  blosum62 sha256   \(PIN_B62_SHA)")
print("  gap model         BLASTP default: a gap of length k costs 11 + k")
print("  no e-value is computed anywhere in this program")
print("")

// ---------------------------------------------------------------------------
// THE HARNESS PATH. Added 2026-09-07 after this program wedged reproduce/validate.sh.
//
// validate.sh compiles and RUNS every program in this directory with no argv. That is the right
// design and it is why every published figure is checkable. But the measurement path here is a
// 58,984,123,166,334-cell screen run TWICE, real and null, and once the corpus resolver was fixed
// so the program could find its inputs from a clean clone, the harness stopped refusing in a
// millisecond and started running the full 35-minute screen on every invocation — three copies were
// grinding at once before it was noticed.
//
// A fix in one place had a consequence in another, and the harness is the wrong place to discover
// it. So: with no argv this prints the published reference figures and the pinned verdict figures
// and exits 0. It NEVER prints a seal on this path, because it computed nothing — a seal for work
// not done is the defect this whole programme exists to prevent. The measurement runs under an
// explicit flag, which is what validate-homology.sh passes.
//
// This is the same shape pelacarsen and the atlas already use when handed no corpus: print what
// the published run measured, name how to reproduce it, emit no seal.
let MEASURE_FLAG = "--measure"
if CommandLine.arguments.count == 1 {
    print("HARNESS PATH — no argument given, so NO SCREEN WAS RUN and NO SEAL IS EMITTED.")
    print("The figures below are what the published run measured; the command that reproduces")
    print("them is at the bottom. This path exists so the harness stays fast: the measurement is")
    print("a 58,984,123,166,334-cell screen run twice and takes about 35 minutes.")
    print("")
    print("  paired against their own shuffles, real ABOVE shuffle  : 36128")
    print("  paired against their own shuffles, real BELOW shuffle  : 36113")
    print("  tied                                                   : 6439")
    print("  real corpus max score  : 90     null max score : 94")
    print("  real sum of maxima     : 4556252")
    print("  null sum of maxima     : 4554816")
    print("  dynamic programming cells COUNTED, per corpus          : 58984123166334")
    print("  query-protein visits COUNTED, per corpus               : 1607511080")
    print("  self-test arms                                         : 24 of 24 pass")
    print("  ROOT-INVARIANT of the published transcript             : b11fe3c9ee6dab0e98b9773a883b438e0cf102fcf4e34bd94ef7cb05a97e0313")
    print("")
    print("  reproduce:  swiftc -O -swift-version 5 reproduce/peptide-homology-exact.swift -o /tmp/ph")
    print("              /tmp/ph \(MEASURE_FLAG)")
    print("NO SEAL EMITTED on the harness path.")
    exit(0)
}

// ---------------------------------------------------------------------------
// transcript / refusal
// ---------------------------------------------------------------------------
var TX: [String] = []
func emit(_ s: String = "") { TX.append(s); print(s) }
func note(_ s: String = "") { print(s) }
func progress(_ s: String) {
    FileHandle.standardError.write(("[progress] " + s + "\n").data(using: .utf8)!)
}
func refuse(_ reason: String) -> Never {
    print("")
    print("REASON: \(reason)")
    print("NO SEAL EMITTED. No verdict is published on a refusal path.")
    exit(2)
}

// ---------------------------------------------------------------------------
// THE ONE RESERVED ARGUMENT.  Dispatched HERE — after the pinned figures have
// been printed, so the probe path carries them like every other path, and BEFORE
// the study root is resolved or any file is opened, so the child needs no inputs
// and answers in milliseconds.
//
// This is the real call site, reached with a real empty list, in the real binary.
// A test of a seam that screen() might or might not call is not a test of
// screen(); a subprocess that reaches screen() is.
// ---------------------------------------------------------------------------
let SELF_PROBE_ZERO_QUERY = "--self-probe-zero-query"
// The seal marker lives in ONE place, because A20 greps a child process for it.
// A detector spelt separately from the thing it detects drifts: the first version
// of A20 looked for "SEAL" and matched the refusal path's own
// "NO SEAL EMITTED", so a correct refusal read as a seal and the arm failed.
let SEAL_MARKER = "SEAL sha256(transcript) = "
do {
    let argv = CommandLine.arguments
    if argv.count == 2 && argv[1] == SELF_PROBE_ZERO_QUERY {
        _ = screen([], [], [], "self-probe-zero-query")
        refuse("the zero-query self-probe RETURNED. screen() answered an empty query list instead of refusing it, which is the defect this probe exists to detect.")
    }
    if argv.count > 1 && argv[1] != MEASURE_FLAG {
        refuse("this program takes no argument on its measurement path except \(MEASURE_FLAG). The only argument it recognises is \(SELF_PROBE_ZERO_QUERY), which self-test arm A20 spawns against this same image; \(argv.count - 1) other argument(s) were given.")
    }
}

func nowNs() -> Int {
    var t = timespec()
    clock_gettime(CLOCK_MONOTONIC, &t)
    return t.tv_sec * 1_000_000_000 + t.tv_nsec
}
let T_START = nowNs()

// ---------------------------------------------------------------------------
// SHA-256, self-contained.
// ---------------------------------------------------------------------------
struct SHA256Exact {
    static let k: [UInt32] = [
        0x428a2f98,0x71374491,0xb5c0fbcf,0xe9b5dba5,0x3956c25b,0x59f111f1,0x923f82a4,0xab1c5ed5,
        0xd807aa98,0x12835b01,0x243185be,0x550c7dc3,0x72be5d74,0x80deb1fe,0x9bdc06a7,0xc19bf174,
        0xe49b69c1,0xefbe4786,0x0fc19dc6,0x240ca1cc,0x2de92c6f,0x4a7484aa,0x5cb0a9dc,0x76f988da,
        0x983e5152,0xa831c66d,0xb00327c8,0xbf597fc7,0xc6e00bf3,0xd5a79147,0x06ca6351,0x14292967,
        0x27b70a85,0x2e1b2138,0x4d2c6dfc,0x53380d13,0x650a7354,0x766a0abb,0x81c2c92e,0x92722c85,
        0xa2bfe8a1,0xa81a664b,0xc24b8b70,0xc76c51a3,0xd192e819,0xd6990624,0xf40e3585,0x106aa070,
        0x19a4c116,0x1e376c08,0x2748774c,0x34b0bcb5,0x391c0cb3,0x4ed8aa4a,0x5b9cca4f,0x682e6ff3,
        0x748f82ee,0x78a5636f,0x84c87814,0x8cc70208,0x90befffa,0xa4506ceb,0xbef9a3f7,0xc67178f2]
    @inline(__always) static func rotr(_ x: UInt32, _ n: UInt32) -> UInt32 { (x >> n) | (x << (32 - n)) }

    static func hex(_ bytes: UnsafePointer<UInt8>, _ n: Int) -> String {
        var h: [UInt32] = [0x6a09e667,0xbb67ae85,0x3c6ef372,0xa54ff53a,
                           0x510e527f,0x9b05688c,0x1f83d9ab,0x5be0cd19]
        var w = [UInt32](repeating: 0, count: 64)
        // tail block(s)
        let bitLen = UInt64(n) &* 8
        var tail = [UInt8]()
        let rem = n % 64
        tail.reserveCapacity(128)
        for i in (n - rem)..<n { tail.append(bytes[i]) }
        tail.append(0x80)
        while tail.count % 64 != 56 { tail.append(0) }
        for i in (0..<8).reversed() { tail.append(UInt8((bitLen >> (UInt64(i) * 8)) & 0xff)) }

        func block(_ p: UnsafePointer<UInt8>) {
            for t in 0..<16 {
                w[t] = (UInt32(p[t*4]) << 24) | (UInt32(p[t*4+1]) << 16)
                     | (UInt32(p[t*4+2]) << 8) | UInt32(p[t*4+3])
            }
            for t in 16..<64 {
                let s0 = rotr(w[t-15],7) ^ rotr(w[t-15],18) ^ (w[t-15] >> 3)
                let s1 = rotr(w[t-2],17) ^ rotr(w[t-2],19) ^ (w[t-2] >> 10)
                w[t] = w[t-16] &+ s0 &+ w[t-7] &+ s1
            }
            var a = h[0], b = h[1], c = h[2], d = h[3]
            var e = h[4], f = h[5], g = h[6], hh = h[7]
            for t in 0..<64 {
                let S1 = rotr(e,6) ^ rotr(e,11) ^ rotr(e,25)
                let ch = (e & f) ^ (~e & g)
                let t1 = hh &+ S1 &+ ch &+ k[t] &+ w[t]
                let S0 = rotr(a,2) ^ rotr(a,13) ^ rotr(a,22)
                let mj = (a & b) ^ (a & c) ^ (b & c)
                let t2 = S0 &+ mj
                hh = g; g = f; f = e; e = d &+ t1
                d = c; c = b; b = a; a = t1 &+ t2
            }
            h[0] = h[0] &+ a; h[1] = h[1] &+ b; h[2] = h[2] &+ c; h[3] = h[3] &+ d
            h[4] = h[4] &+ e; h[5] = h[5] &+ f; h[6] = h[6] &+ g; h[7] = h[7] &+ hh
        }
        var off = 0
        while off + 64 <= n - rem { block(bytes + off); off += 64 }
        tail.withUnsafeBufferPointer { tb in
            var o = 0
            while o < tb.count { block(tb.baseAddress! + o); o += 64 }
        }
        var out = ""
        for v in h {
            for i in (0..<4).reversed() {
                let byte = UInt8((v >> (UInt32(i) * 8)) & 0xff)
                out += String(byte >> 4, radix: 16) + String(byte & 0xf, radix: 16)
            }
        }
        return out
    }
    static func hexOf(_ d: Data) -> String {
        return d.withUnsafeBytes { (raw: UnsafeRawBufferPointer) -> String in
            hex(raw.bindMemory(to: UInt8.self).baseAddress!, raw.count)
        }
    }
    static func hexOf(_ s: String) -> String {
        var a = Array(s.utf8)
        return a.withUnsafeMutableBufferPointer { hex($0.baseAddress!, $0.count) }
    }
    static func firstEightBytes(_ s: [UInt8]) -> UInt64 {
        var a = s
        let hx = a.withUnsafeMutableBufferPointer { hex($0.baseAddress!, $0.count) }
        var v: UInt64 = 0
        for c in hx.utf8.prefix(16) {
            let d: UInt64
            switch c {
            case 0x30...0x39: d = UInt64(c - 0x30)
            default:          d = UInt64(c - 0x61 + 10)
            }
            v = (v << 4) | d
        }
        return v
    }
}

// ---------------------------------------------------------------------------
// study root, found by walking up.  NO ABSOLUTE PATH IN THE SOURCE.
//
// TWO starting points, and the second one has a consequence a reader must know:
// the walk starts from the executable's own directory AND from the WORKING
// DIRECTORY.  The CWD start is what lets the binary be built and run from
// somewhere else against a study tree it is not inside.  It also means that
// MOVING THE BINARY IS NOT ON ITS OWN A RE-ROOT: a probe copied to an empty
// temporary tree, but launched from a shell sitting inside the real study tree,
// finds the real inputs through the CWD start and runs the whole study.
//
// That is not hypothetical.  It is what happened the first time this program's
// refusal arms were run (they lived in validate.sh then and live in
// validate-homology.sh now): the arm asserting "no study root anywhere" ran the complete
// 39-minute computation at 431% CPU instead of refusing in milliseconds, and the
// same arm had PASSED by hand ten minutes earlier only because that shell's
// working directory happened to lie outside the tree.  Same binary, same probe,
// same assertion, opposite result, decided by ambient state the arm never named.
// validate-homology.sh now sets the working directory for every probe invocation:
// every probe runs inside `( cd "$dir" && ./reproduce/probe )`.
// ---------------------------------------------------------------------------
enum Layout {
    // CORRECTED 2026-09-07. The predicate below looked for corpus/ and raw/ as SIBLINGS, which is
    // the scratchpad layout this program was written in. The repository ships the same bytes one
    // level deeper, at corpus/eric/ and corpus/eric/raw/, so a stranger cloning the repo reached
    // the refusal path and never the screen: the program could not find its own corpus in the tree
    // it ships in. Both layouts are accepted now and the resolved pair is recorded, so a reader can
    // see which one answered. A resolver that knows only the author.s layout is a private path
    // wearing a different name.
    static var CORPUS_REL = "/corpus/proteins_validated.csv"
    static var REF_REL    = "/raw/uniprot_human_reviewed.fasta"
}

func findRoot() -> String? {
    let fm = FileManager.default
    func holds(_ d: String) -> Bool {
        for (c, r) in [("/corpus/proteins_validated.csv", "/raw/uniprot_human_reviewed.fasta"),
                       ("/corpus/eric/proteins_validated.csv", "/corpus/eric/raw/uniprot_human_reviewed.fasta")] {
            if fm.fileExists(atPath: d + c) && fm.fileExists(atPath: d + r) {
                Layout.CORPUS_REL = c; Layout.REF_REL = r; return true
            }
        }
        return false
    }
    var starts: [String] = []
    var size: UInt32 = 8192
    var buf = [CChar](repeating: 0, count: Int(size))
    if _NSGetExecutablePath(&buf, &size) == 0 {
        let exe = String(cString: buf)
        starts.append((exe as NSString).deletingLastPathComponent)
    }
    starts.append(fm.currentDirectoryPath)
    for s in starts {
        var d = (s as NSString).standardizingPath
        for _ in 0..<10 {
            if holds(d) { return d }
            let up = (d as NSString).deletingLastPathComponent
            if up == d || up.isEmpty { break }
            d = up
        }
    }
    return nil
}

guard let ROOT = findRoot() else {
    refuse("study root not found. Walked up from the executable's directory and from the working directory looking for an ancestor holding both corpus/proteins_validated.csv and raw/uniprot_human_reviewed.fasta, and found none within 10 levels.")
}
note("study root resolved by ancestor walk (not baked into the source); its path is NOT sealed.")

// ---------------------------------------------------------------------------
// BLOSUM62.  Order A R N D C Q E G H I L K M F P S T W Y V, then X at index 20.
// Index 20 is the matrix's own ambiguity row and is what U is scored through.
// ---------------------------------------------------------------------------
let AA = Array("ARNDCQEGHILKMFPSTWYVX".utf8)
let NA = 21
let B62: [Int8] = [
  4,-1,-2,-2, 0,-1,-1, 0,-2,-1,-1,-1,-1,-2,-1, 1, 0,-3,-2, 0, 0,
 -1, 5, 0,-2,-3, 1, 0,-2, 0,-3,-2, 2,-1,-3,-2,-1,-1,-3,-2,-3,-1,
 -2, 0, 6, 1,-3, 0, 0, 0, 1,-3,-3, 0,-2,-3,-2, 1, 0,-4,-2,-3,-1,
 -2,-2, 1, 6,-3, 0, 2,-1,-1,-3,-4,-1,-3,-3,-1, 0,-1,-4,-3,-3,-1,
  0,-3,-3,-3, 9,-3,-4,-3,-3,-1,-1,-3,-1,-2,-3,-1,-1,-2,-2,-1,-2,
 -1, 1, 0, 0,-3, 5, 2,-2, 0,-3,-2, 1, 0,-3,-1, 0,-1,-2,-1,-2,-1,
 -1, 0, 0, 2,-4, 2, 5,-2, 0,-3,-3, 1,-2,-3,-1, 0,-1,-3,-2,-2,-1,
  0,-2, 0,-1,-3,-2,-2, 6,-2,-4,-4,-2,-3,-3,-2, 0,-2,-2,-3,-3,-1,
 -2, 0, 1,-1,-3, 0, 0,-2, 8,-3,-3,-1,-2,-1,-2,-1,-2,-2, 2,-3,-1,
 -1,-3,-3,-3,-1,-3,-3,-4,-3, 4, 2,-3, 1, 0,-3,-2,-1,-3,-1, 3,-1,
 -1,-2,-3,-4,-1,-2,-3,-4,-3, 2, 4,-2, 2, 0,-3,-2,-1,-2,-1, 1,-1,
 -1, 2, 0,-1,-3, 1, 1,-2,-1,-3,-2, 5,-1,-3,-1, 0,-1,-3,-2,-2,-1,
 -1,-1,-2,-3,-1, 0,-2,-3,-2, 1, 2,-1, 5, 0,-2,-1,-1,-1,-1, 1,-1,
 -2,-3,-3,-3,-2,-3,-3,-3,-1, 0, 0,-3, 0, 6,-4,-2,-2, 1, 3,-1,-1,
 -1,-2,-2,-1,-3,-1,-1,-2,-2,-3,-3,-1,-2,-4, 7,-1,-1,-4,-3,-2,-2,
  1,-1, 1, 0,-1, 0, 0, 0,-1,-2,-2, 0,-1,-2,-1, 4, 1,-3,-2,-2, 0,
  0,-1, 0,-1,-1,-1,-1,-2,-2,-1,-1,-1,-1,-2,-1, 1, 5,-2,-2, 0, 0,
 -3,-3,-4,-4,-2,-2,-3,-2,-2,-3,-2,-3,-1, 1,-4,-3,-2,11, 2,-3,-2,
 -2,-2,-2,-3,-2,-1,-2,-3, 2,-1,-1,-2,-1, 3,-3,-2,-2, 2, 7,-1,-1,
  0,-3,-3,-3,-1,-2,-2,-3,-3, 3, 1,-2, 1,-1,-2,-2, 0,-3,-1, 4,-1,
  0,-1,-1,-1,-2,-1,-1,-1,-1,-1,-1,-1,-1,-1,-2, 0, 0,-2,-1,-1,-1]

// Alternative convention for U, used ONLY in the sensitivity measurement.
let IDX_C = 4   // cysteine's index in the order above
let IDX_X = 20

func canonicalB62_20x20(_ m: [Int8]) -> String {
    var s = ""
    for a in 0..<20 {
        for b in 0..<20 { if b > 0 { s += " " }; s += String(m[a*NA + b]) }
        s += "\n"
    }
    return s
}

var code = [Int8](repeating: -1, count: 256)
for (i, c) in AA.enumerated() { code[Int(c)] = Int8(i) }
code[Int(UInt8(ascii: "U"))] = Int8(IDX_X)   // selenocysteine scored through the X row

// ---------------------------------------------------------------------------
// SIMD kernel constants
// ---------------------------------------------------------------------------
typealias V = SIMD16<Int8>
let LANES = 16
let GROUPS = 4
let BLOCK = LANES * GROUPS          // 64 queries per reference pass
let VZ = V(repeating: 0)
let VGO = V(repeating: 12)          // first gap position costs 12  (= 11 + 1)
let VGE = V(repeating: 1)           // each further gap position costs 1
let GAP_OPEN: Int32 = 12
let GAP_EXT:  Int32 = 1
let SAT_THRESHOLD: Int8 = 100       // proven-safe bound is 116; 100 is conservative
@inline(__always) func vmax(_ a: V, _ b: V) -> V { simd_max(a, b) }

// ---------------------------------------------------------------------------
// SCALAR ORACLE — exact Int32 Smith-Waterman.  This is the reference the SIMD
// kernel is validated against (A6) and the fallback for saturating queries.
// A distinguished refusal: an EMPTY query is refused, never answered as 0.
// ---------------------------------------------------------------------------
enum SWAnswer { case refused(String); case score(Int32) }

func swPairAnswer(_ q: [Int8], _ r: [Int8]) -> SWAnswer {
    if q.isEmpty { return .refused("empty query: a zero-length peptide has no alignment; 0 would be an answer, and there is none") }
    if r.isEmpty { return .refused("empty reference: nothing to align against") }
    return .score(swPair(q, r))
}

func swPair(_ q: [Int8], _ r: [Int8]) -> Int32 {
    let m = q.count
    var H = [Int32](repeating: 0, count: m)
    var F = [Int32](repeating: 0, count: m)
    var best: Int32 = 0
    for j in 0..<r.count {
        let rj = Int(r[j])
        var diag: Int32 = 0
        var vert: Int32 = 0
        for i in 0..<m {
            let hPrev = H[i]
            var h = diag + Int32(B62[Int(q[i]) * NA + rj])
            if h < 0 { h = 0 }
            if vert > h { h = vert }
            if F[i] > h { h = F[i] }
            if h > best { best = h }
            let hgo = h - GAP_OPEN
            vert = max(vert - GAP_EXT, hgo)
            F[i] = max(F[i] - GAP_EXT, hgo)
            diag = hPrev
            H[i] = h
        }
    }
    return best
}

// ---------------------------------------------------------------------------
// reference proteome, loaded and hashed
// ---------------------------------------------------------------------------
progress("hashing reference fasta")
guard let refData = FileManager.default.contents(atPath: ROOT + Layout.REF_REL) else {
    refuse("reference file could not be read under the resolved study root")
}
let refSha = SHA256Exact.hexOf(refData)
if refSha != PIN_REF_SHA {
    note("  reference sha256 (computed)  \(refSha)")
    refuse("reference sha256 \(refSha) does not match the pinned \(PIN_REF_SHA). The reference file is not the one this study was measured on; a verdict will not be sealed over a file that was not read.")
}
note("  reference sha256 (computed)  \(refSha)")

var refSeq = [Int8]()
refSeq.reserveCapacity(11_500_000)
var accs = [String]()
var protStartArr = [Int32]()
var protHasU = [Bool]()
var uCount = 0
var refAlphaCount = [Int](repeating: 0, count: 256)
do {
    var atLineStart = true
    var inHeader = false
    var header = [UInt8]()
    var curHasU = false
    var started = false
    refData.withUnsafeBytes { (raw: UnsafeRawBufferPointer) in
        let p = raw.bindMemory(to: UInt8.self)
        for idx in 0..<p.count {
            let c = p[idx]
            if c == UInt8(ascii: "\n") {
                if inHeader {
                    // ">sp|ACC|NAME ..."  -> ACC
                    var acc = ""
                    var bars = 0
                    for b in header {
                        if b == UInt8(ascii: "|") { bars += 1; continue }
                        if bars == 1 { acc.append(Character(UnicodeScalar(b))) }
                        if bars >= 2 { break }
                    }
                    accs.append(acc.isEmpty ? "?" : acc)
                    inHeader = false
                }
                atLineStart = true
                continue
            }
            if atLineStart && c == UInt8(ascii: ">") {
                // '>' is a record start ONLY at a line start: eleven reviewed human
                // descriptions spell an arrow ("dC->dU-editing", "Delta 5-->4-isomerase").
                if started { protHasU.append(curHasU) }
                started = true
                curHasU = false
                protStartArr.append(Int32(refSeq.count))
                inHeader = true
                header.removeAll(keepingCapacity: true)
                atLineStart = false
                continue
            }
            atLineStart = false
            if inHeader { header.append(c); continue }
            if c == UInt8(ascii: "\r") { continue }
            refAlphaCount[Int(c)] += 1
            if c == UInt8(ascii: "U") { uCount += 1; curHasU = true }
            let e = code[Int(c)]
            if e < 0 {
                refuse("reference contains residue '\(Character(UnicodeScalar(c)))' which is outside the handled alphabet (20 standard + U)")
            }
            refSeq.append(e)
        }
    }
    if started { protHasU.append(curHasU) }
    protStartArr.append(Int32(refSeq.count))
}
let N_PROT = accs.count
if N_PROT != PIN_REF_PROTEINS { refuse("reference protein count \(N_PROT) != pinned \(PIN_REF_PROTEINS)") }
if refSeq.count != PIN_REF_RESIDUES { refuse("reference residue count \(refSeq.count) != pinned \(PIN_REF_RESIDUES)") }
if protStartArr.count != N_PROT + 1 { refuse("protein boundary table malformed") }
if protHasU.count != N_PROT { refuse("U-flag table malformed") }
let uProteinIdx: [Int] = (0..<N_PROT).filter { protHasU[$0] }

// ---------------------------------------------------------------------------
// THE RESOLUTION LIMIT'S ARITHMETIC, computed from this proteome's own residue
// composition rather than quoted.  Integer milli-units by integer division; no
// float anywhere.  s(a,a) is the score a PERFECT identity earns per residue, so
// the composition-weighted mean diagonal times k is what a perfect k-residue
// match is worth against this reference.  U has no BLOSUM62 diagonal of its own
// (it is scored through the X row) and is excluded from the weighting, which is
// why diagResidues is reported alongside the mean.
// ---------------------------------------------------------------------------
var diagWeighted = 0
var diagResidues = 0
for a in 0..<20 {
    let c = refAlphaCount[Int(AA[a])]
    diagWeighted += c * Int(B62[a * NA + a])
    diagResidues += c
}
if diagResidues <= 0 { refuse("reference carries no standard residues; the composition-weighted diagonal is undefined") }
let meanDiagMilli = diagWeighted * 1000 / diagResidues
// the floor and ceiling of s(a,a) over the 20 standard letters, read from the
// matrix rather than quoted: a perfect k-residue identity is bounded by these.
var minDiag = Int(B62[0]), maxDiag = Int(B62[0])
for a in 0..<20 {
    let d = Int(B62[a * NA + a])
    if d < minDiag { minDiag = d }
    if d > maxDiag { maxDiag = d }
}

// unsigned copy of the encoded reference for the SIMD kernel
var refU = [UInt8](repeating: 0, count: refSeq.count)
for i in 0..<refSeq.count { refU[i] = UInt8(refSeq[i]) }

// ---------------------------------------------------------------------------
// corpus, loaded and hashed
// ---------------------------------------------------------------------------
progress("hashing corpus csv")
guard let corpData = FileManager.default.contents(atPath: ROOT + Layout.CORPUS_REL) else {
    refuse("corpus file could not be read under the resolved study root")
}
let corpSha = SHA256Exact.hexOf(corpData)
if corpSha != PIN_CORPUS_SHA {
    note("  corpus sha256 (computed)     \(corpSha)")
    refuse("corpus sha256 \(corpSha) does not match the pinned \(PIN_CORPUS_SHA).")
}
note("  corpus sha256 (computed)     \(corpSha)")

var qIds = [String]()
var qSeqRaw = [[UInt8]]()
var qSeq = [[Int8]]()
var corpAlphaCount = [Int](repeating: 0, count: 256)
var corpCRLFRows = 0
// ---------------------------------------------------------------------------
// The corpus is parsed at BYTE level, splitting on 0x0A and stripping a
// trailing 0x0D, and this is not a stylistic choice.
//
// THIS FILE IS CRLF: 78,681 carriage returns, one per row plus the header.
// Swift's String.split(separator: "\n") operates on CHARACTERS, and "\r\n" is a
// SINGLE grapheme cluster which is not equal to "\n" — so splitting the decoded
// string on a newline returns ONE line for the whole 19.7 MB file. Measured:
// `lines 1, parsed 0`. The failure is silent in the worst way, because a corpus
// that parsed to zero rows and a corpus that is absent look identical, and both
// digests had already gone green above. The row-count and residue-count gates
// caught it here; the byte-level parse is what stops it happening at all.
// (The reference FASTA is LF-only — 0 carriage returns — so the two files do
// not share a convention and neither may be assumed from the other.)
// ---------------------------------------------------------------------------
do {
    corpData.withUnsafeBytes { (raw: UnsafeRawBufferPointer) in
        let p = raw.bindMemory(to: UInt8.self)
        var lineNo = 0
        var i = 0
        let n = p.count
        while i < n {
            var e = i
            while e < n && p[e] != 0x0A { e += 1 }
            var end = e
            if end > i && p[end - 1] == 0x0D { end -= 1; corpCRLFRows += 1 }
            if end > i {
                lineNo += 1
                if lineNo > 1 {
                    // columns: protein_id, sequence, length, ...
                    var f0 = i, f1 = -1, f2 = -1, f3 = -1
                    var k = i
                    while k < end {
                        if p[k] == 0x2C {
                            if f1 < 0 { f1 = k } else if f2 < 0 { f2 = k } else if f3 < 0 { f3 = k; break }
                        }
                        k += 1
                    }
                    if f1 < 0 || f2 < 0 || f3 < 0 { refuse("corpus row \(lineNo - 1) has fewer than 4 columns") }
                    var id = ""
                    for b in f0..<f1 { id.append(Character(UnicodeScalar(p[b]))) }
                    var rawSeq = [UInt8](); rawSeq.reserveCapacity(f2 - f1 - 1)
                    var enc = [Int8](); enc.reserveCapacity(f2 - f1 - 1)
                    for b in (f1 + 1)..<f2 {
                        let c = p[b]
                        corpAlphaCount[Int(c)] += 1
                        let ec = code[Int(c)]
                        if ec < 0 || ec == Int8(IDX_X) {
                            refuse("corpus sequence \(id) contains residue '\(Character(UnicodeScalar(c)))' outside the 20 standard amino acids")
                        }
                        rawSeq.append(c); enc.append(ec)
                    }
                    var declared = 0
                    for b in (f2 + 1)..<f3 {
                        let c = p[b]
                        if c < 0x30 || c > 0x39 { refuse("corpus row \(id) has a non-integer length column") }
                        declared = declared * 10 + Int(c - 0x30)
                    }
                    if declared != rawSeq.count {
                        refuse("corpus row \(id) declares length \(declared) but carries \(rawSeq.count) residues")
                    }
                    qIds.append(id); qSeqRaw.append(rawSeq); qSeq.append(enc)
                }
            }
            i = e + 1
        }
    }
}
let N_Q = qSeq.count
if N_Q != PIN_CORPUS_ROWS { refuse("corpus row count \(N_Q) != pinned \(PIN_CORPUS_ROWS)") }
let totalQResidues = qSeq.reduce(0) { $0 + $1.count }
if totalQResidues != PIN_CORPUS_RESIDUES { refuse("corpus residue count \(totalQResidues) != pinned \(PIN_CORPUS_RESIDUES)") }
do {
    var seen = Set<String>(); seen.reserveCapacity(N_Q * 2)
    for s in qSeqRaw { seen.insert(String(decoding: s, as: UTF8.self)) }
    if seen.count != PIN_CORPUS_DISTINCT { refuse("corpus distinct-sequence count \(seen.count) != pinned \(PIN_CORPUS_DISTINCT)") }
}

// ---------------------------------------------------------------------------
// THE PRODUCTION SCREEN
// ---------------------------------------------------------------------------
// One "screen" aligns a list of queries against a list of proteins, exactly.
// Blocks hold 64 queries of EQUAL length (so no padding, no masking).
// Int8 lanes with the proven saturation guard; saturating queries are resolved
// by the Int32 scalar oracle.
// ---------------------------------------------------------------------------

struct ScreenResult {
    var score: [Int32]
    var protIdx: [Int32]
    var saturatedCount: Int
    // COUNTED WORK, accumulated inside kernelBlock as it happens.  Not derived
    // from the input sizes; a screen that skips anything reports less.
    var cells: Int
    var visits: Int
}

// COUNTERS, the two the kernel accumulates.  Indices are named so that a reader
// of the transcript can find the line that increments the figure it is reading.
let CTR_CELLS = 0
let CTR_VISITS = 1

@inline(never)
func kernelBlock(_ m: Int,
                 _ prof: UnsafePointer<V>,
                 _ ref: UnsafePointer<UInt8>,
                 _ protList: UnsafePointer<Int32>,
                 _ protStart: UnsafePointer<Int32>,
                 _ nProt: Int,
                 _ realLanes: Int,
                 _ H: UnsafeMutablePointer<V>,
                 _ F: UnsafeMutablePointer<V>,
                 _ outScore: UnsafeMutablePointer<Int8>,
                 _ outProt: UnsafeMutablePointer<Int32>,
                 _ ctr: UnsafeMutablePointer<Int>) {
    var b0 = VZ, b1 = VZ, b2 = VZ, b3 = VZ
    for l in 0..<BLOCK { outProt[l] = -1 }
    var cells = 0
    var visits = 0
    let mG = m &* GROUPS
    for pi in 0..<nProt {
        let p = Int(protList[pi])
        let s = Int(protStart[p]), e = Int(protStart[p &+ 1])
        // THE COUNT HAPPENS HERE, on the protein this pass is about to align,
        // inside the loop that does the work.  realLanes is the number of
        // DISTINCT queries this block carries; pad lanes repeat a query already
        // present and their work is discarded, so they are not counted.
        cells &+= realLanes &* m &* (e &- s)
        visits &+= realLanes
        for i in 0..<mG { H[i] = VZ; F[i] = VZ }
        var m0 = VZ, m1 = VZ, m2 = VZ, m3 = VZ
        for j in s..<e {
            let base = prof + Int(ref[j]) &* mG
            var d0 = VZ, v0 = VZ, d1 = VZ, v1 = VZ, d2 = VZ, v2 = VZ, d3 = VZ, v3 = VZ
            var k = 0
            for _ in 0..<m {
                var h0 = vmax(d0 &+ base[k], VZ);      let f0 = F[k]
                var h1 = vmax(d1 &+ base[k &+ 1], VZ); let f1 = F[k &+ 1]
                var h2 = vmax(d2 &+ base[k &+ 2], VZ); let f2 = F[k &+ 2]
                var h3 = vmax(d3 &+ base[k &+ 3], VZ); let f3 = F[k &+ 3]
                h0 = vmax(h0, vmax(v0, f0)); h1 = vmax(h1, vmax(v1, f1))
                h2 = vmax(h2, vmax(v2, f2)); h3 = vmax(h3, vmax(v3, f3))
                m0 = vmax(m0, h0); m1 = vmax(m1, h1); m2 = vmax(m2, h2); m3 = vmax(m3, h3)
                let g0 = h0 &- VGO, g1 = h1 &- VGO, g2 = h2 &- VGO, g3 = h3 &- VGO
                v0 = vmax(v0 &- VGE, g0); v1 = vmax(v1 &- VGE, g1)
                v2 = vmax(v2 &- VGE, g2); v3 = vmax(v3 &- VGE, g3)
                F[k] = vmax(f0 &- VGE, g0);      F[k &+ 1] = vmax(f1 &- VGE, g1)
                F[k &+ 2] = vmax(f2 &- VGE, g2); F[k &+ 3] = vmax(f3 &- VGE, g3)
                d0 = H[k]; H[k] = h0;                   d1 = H[k &+ 1]; H[k &+ 1] = h1
                d2 = H[k &+ 2]; H[k &+ 2] = h2;         d3 = H[k &+ 3]; H[k &+ 3] = h3
                k &+= 4
            }
        }
        // strict improvement only -> the FIRST protein in file order attaining
        // the maximum is the one retained.  That is the stated tie rule.
        if any(m0 .> b0) { for l in 0..<LANES where m0[l] > b0[l] { outProt[l] = Int32(p) }; b0 = vmax(b0, m0) }
        if any(m1 .> b1) { for l in 0..<LANES where m1[l] > b1[l] { outProt[LANES &+ l] = Int32(p) }; b1 = vmax(b1, m1) }
        if any(m2 .> b2) { for l in 0..<LANES where m2[l] > b2[l] { outProt[2*LANES &+ l] = Int32(p) }; b2 = vmax(b2, m2) }
        if any(m3 .> b3) { for l in 0..<LANES where m3[l] > b3[l] { outProt[3*LANES &+ l] = Int32(p) }; b3 = vmax(b3, m3) }
    }
    for l in 0..<LANES {
        outScore[l] = b0[l]; outScore[LANES &+ l] = b1[l]
        outScore[2*LANES &+ l] = b2[l]; outScore[3*LANES &+ l] = b3[l]
    }
    ctr[CTR_CELLS] = cells
    ctr[CTR_VISITS] = visits
}

// scalar oracle over a protein list, parallel across proteins, with the same
// file-order tie rule.
func scalarOverProteins(_ q: [Int8], _ protList: [Int32], _ mat: [Int8]) -> (Int32, Int32) {
    if q.isEmpty { return (-1, -1) }
    let nChunk = min(protList.count, 64)
    var bestS = [Int32](repeating: 0, count: nChunk)
    var bestP = [Int32](repeating: -1, count: nChunk)
    let per = (protList.count + nChunk - 1) / nChunk
    bestS.withUnsafeMutableBufferPointer { bs in
      bestP.withUnsafeMutableBufferPointer { bp in
        DispatchQueue.concurrentPerform(iterations: nChunk) { c in
            var bs_: Int32 = 0, bp_: Int32 = -1
            let lo = c * per, hi = min(protList.count, lo + per)
            if lo >= hi { bs[c] = 0; bp[c] = -1; return }
            for pi in lo..<hi {
                let p = Int(protList[pi])
                let s = Int(protStartArr[p]), e = Int(protStartArr[p+1])
                var sub = [Int8](); sub.reserveCapacity(e - s)
                for j in s..<e { sub.append(refSeq[j]) }
                let sc = swPairMat(q, sub, mat)
                if sc > bs_ { bs_ = sc; bp_ = Int32(p) }
            }
            bs[c] = bs_; bp[c] = bp_
        }
      }
    }
    var gs: Int32 = 0, gp: Int32 = -1
    for c in 0..<nChunk {
        if bestS[c] > gs || (bestS[c] == gs && bestP[c] >= 0 && (gp < 0 || bestP[c] < gp)) {
            if bestS[c] > gs { gs = bestS[c]; gp = bestP[c] }
            else if bestP[c] >= 0 && (gp < 0 || bestP[c] < gp) { gp = bestP[c] }
        }
    }
    return (gs, gp)
}

func swPairMat(_ q: [Int8], _ r: [Int8], _ mat: [Int8]) -> Int32 {
    let m = q.count
    if m == 0 || r.isEmpty { return 0 }
    var H = [Int32](repeating: 0, count: m)
    var F = [Int32](repeating: 0, count: m)
    var best: Int32 = 0
    mat.withUnsafeBufferPointer { mp in
      q.withUnsafeBufferPointer { qp in
        r.withUnsafeBufferPointer { rp in
          H.withUnsafeMutableBufferPointer { hp in
            F.withUnsafeMutableBufferPointer { fp in
              for j in 0..<r.count {
                  let rj = Int(rp[j])
                  var diag: Int32 = 0
                  var vert: Int32 = 0
                  for i in 0..<m {
                      let hPrev = hp[i]
                      var h = diag + Int32(mp[Int(qp[i]) * NA + rj])
                      if h < 0 { h = 0 }
                      if vert > h { h = vert }
                      if fp[i] > h { h = fp[i] }
                      if h > best { best = h }
                      let hgo = h - GAP_OPEN
                      vert = max(vert - GAP_EXT, hgo)
                      fp[i] = max(fp[i] - GAP_EXT, hgo)
                      diag = hPrev
                      hp[i] = h
                  }
              }
            }
          }
        }
      }
    }
    return best
}

// The screen.  `queries` may be any list; `protList` any protein subset.
func screen(_ queries: [[Int8]], _ protList: [Int32], _ mat: [Int8], _ label: String) -> ScreenResult {
    let n = queries.count
    if n == 0 {
        refuse("screen '\(label)' was given ZERO queries. An empty input is refused, not answered with an empty distribution: a gate given nothing must not pass.")
    }
    var order = Array(0..<n)
    order.sort { (a, b) in
        let la = queries[a].count, lb = queries[b].count
        return la != lb ? la < lb : a < b
    }
    // blocks of 64 queries of EQUAL length
    var blocks: [[Int]] = []
    var blockReal: [Int] = []      // DISTINCT queries in the block; the rest are pad repeats
    var i = 0
    while i < n {
        let L = queries[order[i]].count
        var j = i
        while j < n && queries[order[j]].count == L { j += 1 }
        var k = i
        while k < j {
            let hi = min(j, k + BLOCK)
            var b = Array(order[k..<hi])
            blockReal.append(hi - k)
            while b.count < BLOCK { b.append(b[0]) }   // pad by repetition; duplicate lanes discarded
            blocks.append(b)
            k = hi
        }
        i = j
    }
    let nB = blocks.count
    var scoreOut = [Int32](repeating: -1, count: n)
    var protOut  = [Int32](repeating: -1, count: n)
    var satFlag  = [Bool](repeating: false, count: n)
    let done = UnsafeMutablePointer<Int32>.allocate(capacity: 1); done.pointee = 0
    defer { done.deallocate() }

    var ctrPerBlock = [Int](repeating: -1, count: nB * 2)
    scoreOut.withUnsafeMutableBufferPointer { so in
      protOut.withUnsafeMutableBufferPointer { po in
        satFlag.withUnsafeMutableBufferPointer { sf in
         ctrPerBlock.withUnsafeMutableBufferPointer { cb in
          refU.withUnsafeBufferPointer { rp in
            protStartArr.withUnsafeBufferPointer { psp in
              protList.withUnsafeBufferPointer { plp in
                mat.withUnsafeBufferPointer { mp in
                  DispatchQueue.concurrentPerform(iterations: nB) { bi in
                    let b = blocks[bi]
                    let m = queries[b[0]].count
                    let mG = m * GROUPS
                    var prof = [V](repeating: VZ, count: NA * mG)
                    for a in 0..<NA {
                        for pos in 0..<m {
                            for g in 0..<GROUPS {
                                var v = VZ
                                for l in 0..<LANES {
                                    let qi = b[g * LANES + l]
                                    v[l] = mp[Int(queries[qi][pos]) * NA + a]
                                }
                                prof[a * mG + pos * GROUPS + g] = v
                            }
                        }
                    }
                    var H = [V](repeating: VZ, count: mG)
                    var F = [V](repeating: VZ, count: mG)
                    var os = [Int8](repeating: 0, count: BLOCK)
                    var op = [Int32](repeating: -1, count: BLOCK)
                    prof.withUnsafeBufferPointer { pp in
                      H.withUnsafeMutableBufferPointer { hp in
                        F.withUnsafeMutableBufferPointer { fp in
                          os.withUnsafeMutableBufferPointer { osp in
                            op.withUnsafeMutableBufferPointer { opp in
                              kernelBlock(m, pp.baseAddress!, rp.baseAddress!, plp.baseAddress!,
                                          psp.baseAddress!, protList.count, blockReal[bi],
                                          hp.baseAddress!, fp.baseAddress!,
                                          osp.baseAddress!, opp.baseAddress!,
                                          cb.baseAddress! + bi * 2)
                            }
                          }
                        }
                      }
                    }
                    for l in 0..<BLOCK {
                        let qi = b[l]
                        if so[qi] >= 0 { continue }   // duplicate pad lane
                        so[qi] = Int32(os[l])
                        po[qi] = op[l]
                        if os[l] >= SAT_THRESHOLD { sf[qi] = true }
                    }
                    let d = OSAtomicIncrement32(done)
                    if d % 128 == 0 || d == Int32(nB) {
                        progress("\(label): \(d)/\(nB) blocks")
                    }
                  }
                }
              }
            }
          }
         }
        }
      }
    }
    // Sum the counters the kernel wrote.  A block whose counter was never
    // written still reads -1, so a block that did not run cannot look like a
    // block that did zero work.
    var cells = 0, visits = 0
    for bi in 0..<nB {
        let c = ctrPerBlock[bi * 2 + CTR_CELLS], v = ctrPerBlock[bi * 2 + CTR_VISITS]
        if c < 0 || v < 0 {
            refuse("screen '\(label)' block \(bi) of \(nB) left its work counters unwritten. A block that never ran must not be indistinguishable from a block that did no work.")
        }
        cells += c; visits += v
    }
    var satN = 0
    for qi in 0..<n where satFlag[qi] {
        satN += 1
        let (s, p) = scalarOverProteins(queries[qi], protList, mat)
        scoreOut[qi] = s
        protOut[qi] = p
    }
    return ScreenResult(score: scoreOut, protIdx: protOut, saturatedCount: satN,
                        cells: cells, visits: visits)
}

// ---------------------------------------------------------------------------
// COMPLETENESS, checked against the COUNTED work rather than asserted.
// Called on every screen whose completeness is published.  It compares the
// counters kernelBlock accumulated against the complete product; a screen that
// covered fewer proteins, fewer queries or shorter sequences reports less and
// this refuses.
// ---------------------------------------------------------------------------
func requireComplete(_ label: String, _ r: ScreenResult,
                     _ nQ: Int, _ qResidues: Int, _ nProt: Int, _ refResidues: Int) {
    let wantCells = qResidues * refResidues
    let wantVisits = nQ * nProt
    if r.cells != wantCells || r.visits != wantVisits {
        note("  screen '\(label)' COUNTED cells \(r.cells) visits \(r.visits)")
        note("  complete would be   cells \(wantCells) visits \(wantVisits)")
        refuse("screen '\(label)' is INCOMPLETE. The kernel COUNTED \(r.cells) dynamic programming cells over \(r.visits) query-protein visits, one addition per protein actually visited. A complete screen of \(nQ) queries totalling \(qResidues) residues against \(nProt) proteins totalling \(refResidues) residues is \(wantCells) cells over \(wantVisits) visits. The counted work does not equal the complete work, so no completeness is claimed and no verdict is sealed. This figure is the work performed; it is NOT the product of the two input file sizes, which is identical whatever the screen did.")
    }
}

// ---------------------------------------------------------------------------
// deterministic composition-matched shuffle.  No clock, no arc4random.
// The seed is derived from the SHA-256 of the sequence itself, so the shuffle
// is a function of the sequence CONTENT and is reproducible independently of
// the corpus row order.
// ---------------------------------------------------------------------------
struct SplitMix64 {
    var s: UInt64
    init(_ seed: UInt64) { s = seed }
    mutating func next() -> UInt64 {
        s = s &+ 0x9E3779B97F4A7C15
        var z = s
        z = (z ^ (z >> 30)) &* 0xBF58476D1CE4E5B9
        z = (z ^ (z >> 27)) &* 0x94D049BB133111EB
        return z ^ (z >> 31)
    }
    mutating func below(_ n: Int) -> Int { Int(next() % UInt64(n)) }
}

func shuffled(_ q: [Int8], _ raw: [UInt8], _ round: UInt64) -> [Int8] {
    var seedBytes = raw
    if round > 0 {
        var r = round
        for _ in 0..<8 { seedBytes.append(UInt8(r & 0xff)); r >>= 8 }
    }
    var rng = SplitMix64(SHA256Exact.firstEightBytes(seedBytes))
    var a = q
    var i = a.count - 1
    while i > 0 { let j = rng.below(i + 1); a.swapAt(i, j); i -= 1 }
    return a
}

// ===========================================================================
// SELF-TEST.  Runs BEFORE any measurement is emitted.  If any arm fails the
// program prints the failing arm and exits non-zero with NO transcript and NO
// seal.  Arms run in BOTH directions: the instrument must find what is there
// AND must fail to find what is not.
// ===========================================================================
var armPass = 0
var armFail = 0
var armLines: [String] = []
func arm(_ id: String, _ what: String, _ ok: Bool, _ detail: String) {
    if ok { armPass += 1; armLines.append("  [PASS] \(id) \(what) — \(detail)") }
    else  { armFail += 1; armLines.append("  [FAIL] \(id) \(what) — \(detail)") }
}

progress("self-test")

// A1 symmetry
do {
    var bad = 0
    for a in 0..<NA { for b in 0..<NA where B62[a*NA+b] != B62[b*NA+a] { bad += 1 } }
    arm("A1", "BLOSUM62 is symmetric", bad == 0, "\(bad) asymmetric cells of \(NA*NA)")
}
// A2 diagonal is the max of its row (over the 20 standard)
do {
    var bad = 0
    for a in 0..<20 { for b in 0..<20 where B62[a*NA+b] > B62[a*NA+a] { bad += 1 } }
    arm("A2", "diagonal is the maximum of its row", bad == 0,
        "\(bad) rows where an off-diagonal exceeds the diagonal; this is what bounds any local score by the query self-score")
}
// A3 external cross-check
let b62sha = SHA256Exact.hexOf(canonicalB62_20x20(B62))
arm("A3", "matrix matches an INDEPENDENT BLOSUM62", b62sha == PIN_B62_SHA,
    "canonical 20x20 sha256 \(b62sha)")
// A4 the digest gate discriminates
do {
    var m2 = B62
    m2[0] = m2[0] &+ 1
    let d2 = SHA256Exact.hexOf(canonicalB62_20x20(m2))
    arm("A4", "matrix digest gate DISCRIMINATES", d2 != b62sha,
        "one cell changed (A:A 4->5) gives \(String(d2.prefix(16)))…, not the pinned digest")
}
// A5 hand-computed alignments
do {
    func enc(_ s: String) -> [Int8] { Array(s.utf8).map { code[Int($0)] } }
    // (a) "AW" vs "AW":  s(A,A)=4 then +s(W,W)=11  -> 15
    // (b) "WWWW" vs "WWAWW": 11+11 -12(gap of length 1 costs 11+1) +11+11 -> 32,
    //     which beats the best ungapped stretch of 22, so this case exercises
    //     the affine gap and not merely the diagonal.
    // (c) "WAW" vs "WAW":  11 + 4 + 11 -> 26
    // (d) "WCW" vs "WAW":  11 + s(C,A)=0 + 11 -> 22
    // (e) "C" vs "W": s(C,W) = -2, local alignment clamps at 0 -> 0.
    //     A legitimate ZERO, and it is NOT the refusal of A8.
    let cases: [(String, String, Int32)] = [("AW","AW",15), ("WWWW","WWAWW",32),
                                            ("WAW","WAW",26), ("WCW","WAW",22), ("C","W",0)]
    var bad = 0
    var shown: [String] = []
    for (a, b, want) in cases {
        let got = swPair(enc(a), enc(b))
        shown.append("\(a)/\(b)=\(got)")
        if got != want { bad += 1 }
    }
    arm("A5", "hand-computed alignments agree exactly", bad == 0, shown.joined(separator: " "))
}
// A6 SIMD block kernel == scalar oracle, on a synthetic mini-proteome
var a6mismatch = 0
var a6cases = 0
// (cellsCounted, visitsCounted, cellsByHand, visitsByHand) per A6 block
var a23observed: [(Int, Int, Int, Int)] = []
do {
    var rng = SplitMix64(0x5DEECE66D)
    // synthetic proteome
    var sSeq = [Int8](); var sStart = [Int32]()
    var nSP = 0
    for _ in 0..<40 {
        sStart.append(Int32(sSeq.count))
        let L = 20 + rng.below(180)
        for _ in 0..<L { sSeq.append(Int8(rng.below(20))) }
        nSP += 1
    }
    sStart.append(Int32(sSeq.count))
    var sU = [UInt8](repeating: 0, count: sSeq.count)
    for i in 0..<sSeq.count { sU[i] = UInt8(sSeq[i]) }
    // 64 queries of one length, several lengths tested (including 1)
    for L in [1, 2, 7, 23, 66, 90] {
        var qs = [[Int8]]()
        for _ in 0..<BLOCK {
            var q = [Int8]()
            for _ in 0..<L { q.append(Int8(rng.below(20))) }
            qs.append(q)
        }
        let m = L, mG = m * GROUPS
        var prof = [V](repeating: VZ, count: NA * mG)
        for a in 0..<NA { for pos in 0..<m { for g in 0..<GROUPS {
            var v = VZ
            for l in 0..<LANES { v[l] = B62[Int(qs[g*LANES+l][pos]) * NA + a] }
            prof[a*mG + pos*GROUPS + g] = v
        } } }
        var H = [V](repeating: VZ, count: mG), F = H
        var os = [Int8](repeating: 0, count: BLOCK)
        var op = [Int32](repeating: -1, count: BLOCK)
        var plist = [Int32](); for p in 0..<nSP { plist.append(Int32(p)) }
        var ctr = [Int](repeating: -1, count: 2)
        prof.withUnsafeBufferPointer { pp in sU.withUnsafeBufferPointer { rp in
          plist.withUnsafeBufferPointer { plp in sStart.withUnsafeBufferPointer { ssp in
            H.withUnsafeMutableBufferPointer { hp in F.withUnsafeMutableBufferPointer { fp in
              os.withUnsafeMutableBufferPointer { osp in op.withUnsafeMutableBufferPointer { opp in
                ctr.withUnsafeMutableBufferPointer { cp in
                  kernelBlock(m, pp.baseAddress!, rp.baseAddress!, plp.baseAddress!, ssp.baseAddress!,
                              nSP, BLOCK, hp.baseAddress!, fp.baseAddress!,
                              osp.baseAddress!, opp.baseAddress!, cp.baseAddress!)
                }
              } }
            } }
          } }
        } }
        // A23's evidence, gathered here where the synthetic proteome's sizes are
        // known exactly: the counter must equal the hand product for this block.
        a23observed.append((ctr[CTR_CELLS], ctr[CTR_VISITS],
                            BLOCK * m * sSeq.count, BLOCK * nSP))
        for l in 0..<BLOCK {
            var truth: Int32 = 0
            var truthP: Int32 = -1
            for p in 0..<nSP {
                let s = Int(sStart[p]), e = Int(sStart[p+1])
                var sub = [Int8](); for j in s..<e { sub.append(sSeq[j]) }
                let sc = swPairMat(qs[l], sub, B62)
                if sc > truth { truth = sc; truthP = Int32(p) }
            }
            a6cases += 1
            if Int32(os[l]) != truth || op[l] != truthP { a6mismatch += 1 }
        }
    }
    arm("A6", "SIMD block kernel == Int32 scalar oracle", a6mismatch == 0,
        "\(a6cases) query/proteome pairs over lengths 1,2,7,23,66,90 — score AND argmax both compared, \(a6mismatch) mismatches")
}
// A7 the A6 comparator is not always-equal
do {
    let a = swPair([code[Int(UInt8(ascii: "W"))]], [code[Int(UInt8(ascii: "W"))]])
    let b = swPair([code[Int(UInt8(ascii: "W"))]], [code[Int(UInt8(ascii: "A"))]])
    arm("A7", "the equality comparator DOES fire on unequal input", a != b,
        "W/W=\(a) and W/A=\(b) compare unequal, so A6's zero-mismatch reading is a measurement rather than a tautology")
}
// A8 EMPTY input refused, never answered as 0
do {
    let r = swPairAnswer([], [code[Int(UInt8(ascii: "W"))]])
    var refused = false; var msg = ""
    if case .refused(let m) = r { refused = true; msg = m }
    arm("A8", "EMPTY query is REFUSED, not answered as 0", refused, msg)
}
// A9/A10 need the proteome — run after the proteome screen helpers exist
let allProt: [Int32] = (0..<N_PROT).map { Int32($0) }
let nonUProt: [Int32] = (0..<N_PROT).filter { !protHasU[$0] }.map { Int32($0) }
let uProt: [Int32] = uProteinIdx.map { Int32($0) }

func encStr(_ s: String) -> [Int8] { Array(s.utf8).map { code[Int($0)] } }
func proteinSeq(_ p: Int) -> [Int8] {
    let s = Int(protStartArr[p]), e = Int(protStartArr[p+1])
    var a = [Int8](); a.reserveCapacity(e - s)
    for j in s..<e { a.append(refSeq[j]) }
    return a
}
var accIndex = [String: Int]()
for (i, a) in accs.enumerated() { accIndex[a] = i }

// A9 a 1-residue query returns a REAL score (so A8 is not always-refuse)
do {
    let r = screen([encStr("W")], allProt, B62, "selftest-A9")
    arm("A9", "a 1-residue query returns a real score", r.score[0] == 11,
        "query 'W' against the whole proteome scores \(r.score[0]) (= BLOSUM62 W:W), refusal is therefore not the only outcome")
}
// A10 a legitimate ZERO is distinguishable from the refusal of A8
do {
    let r = swPairAnswer(encStr("C"), encStr("W"))
    var isZero = false
    if case .score(let s) = r { isZero = (s == 0) }
    arm("A10", "a legitimate ZERO is answered, not refused", isZero,
        "C vs W scores 0 through .score(0) while the empty query returns .refused — ABSENCE and REFUSAL are different answers here")
}
// A11 self-score identity
let A11_ACC = "O00244"
var a11self: Int32 = -1
var a11diag: Int32 = -1
do {
    guard let p = accIndex[A11_ACC] else { refuse("self-test protein \(A11_ACC) absent from the reference") }
    let q = proteinSeq(p)
    var d: Int32 = 0
    for r in q { d += Int32(B62[Int(r) * NA + Int(r)]) }
    a11diag = d
    let r = screen([q], allProt, B62, "selftest-A11")
    a11self = r.score[0]
    let accOK = r.protIdx[0] >= 0 && accs[Int(r.protIdx[0])] == A11_ACC
    arm("A11", "a real human protein returns its own self-score EXACTLY", a11self == d && accOK,
        "\(A11_ACC) (\(q.count) aa) scores \(a11self) against the whole proteome; sum of its BLOSUM62 diagonal is \(d); argmax accession \(r.protIdx[0] >= 0 ? accs[Int(r.protIdx[0])] : "none")")
}
// A12 deterministic scramble scores far lower
var a12scr: Int32 = -1
do {
    guard let p = accIndex[A11_ACC] else { refuse("missing") }
    let q = proteinSeq(p)
    var raw = [UInt8](); for c in q { raw.append(AA[Int(c)]) }
    let sc = shuffled(q, raw, 0)
    let r = screen([sc], allProt, B62, "selftest-A12")
    a12scr = r.score[0]
    arm("A12", "a deterministic scramble of it scores FAR lower", a12scr * 4 < a11self,
        "scramble scores \(a12scr) against \(a11self) for the unscrambled protein — under a quarter, so the instrument is reading sequence order and not composition")
}
// A13 a known homologous family is FOUND
var a13hb: Int32 = -1
var a13scr: Int32 = -1
do {
    guard let pa = accIndex["P69905"], let pb = accIndex["P68871"] else {
        refuse("hemoglobin self-test proteins P69905 / P68871 absent from the reference")
    }
    let qa = proteinSeq(pa), qb = proteinSeq(pb)
    a13hb = swPair(qa, qb)
    var raw = [UInt8](); for c in qa { raw.append(AA[Int(c)]) }
    a13scr = swPair(shuffled(qa, raw, 0), qb)
    arm("A13", "a known homologous family IS found", a13hb >= 100 && a13hb > 4 * a13scr,
        "HBA_HUMAN P69905 vs HBB_HUMAN P68871 scores \(a13hb); the same alpha chain scrambled against the same beta chain scores \(a13scr) — the instrument is NOT always-null")
}
// ---------------------------------------------------------------------------
// A14  HOMOPOLYMERS.  The brief's arm was "a homopolymer must not produce a
// spuriously high score", and the first version of this arm asserted that by
// comparing against the hemoglobin pair. IT FAILED, and the instrument was
// right: a 66-mer homopolymer scores 330 against the reviewed human proteome,
// ABOVE the 285 of the hemoglobin pair.
//
// That score is NOT spurious. The human proteome genuinely carries low-
// complexity homopolymer tracts, and an exact aligner running with no SEG/DUST
// masking — which is deliberate here — finds them. So the arm is rewritten to
// check the thing that is actually true and is exactly predictable:
//
//   * By A2 the BLOSUM62 diagonal is the maximum of its row, so NO alignment of
//     a homopolymer can score above 66 * s(a,a). That is a hard ceiling.
//   * That ceiling is ATTAINED exactly when the proteome contains a run of 66
//     or more consecutive copies of that residue — a fact measured here
//     INDEPENDENTLY of the aligner, by scanning the reference for runs.
//
// So the arm predicts each score from a separate measurement and checks it, in
// both directions: residues with a long enough run must hit the ceiling exactly,
// residues without one must stay under it.
//
// This matters for reading the study, not just for testing it. The generated
// corpus is K/R-rich (K+R measured at 198,674 ppm against 113,634 ppm in the
// human reference), so some of its alignment score is available from
// COMPOSITION rather than from homology. The composition-matched null is
// exactly what removes that, and A22 below shows the removal is exact.
// ---------------------------------------------------------------------------
var a14 = [(String, Int32, Int32, Int)]()   // letter, score, ceiling, longest proteome run
do {
    var longestRun = [Int](repeating: 0, count: NA)
    var run = 0
    var prev: Int8 = -1
    for c in refSeq {
        if c == prev { run += 1 } else { run = 1; prev = c }
        if run > longestRun[Int(c)] { longestRun[Int(c)] = run }
    }
    var qs = [[Int8]]()
    for a in 0..<20 { qs.append([Int8](repeating: Int8(a), count: 66)) }
    let r = screen(qs, allProt, B62, "selftest-A14")
    var badCeiling = 0, badAttain = 0, nAttain = 0, nBelow = 0
    for a in 0..<20 {
        let ceiling = Int32(66 * Int(B62[a*NA + a]))
        a14.append((String(UnicodeScalar(AA[a])), r.score[a], ceiling, longestRun[a]))
        if r.score[a] > ceiling { badCeiling += 1 }
        if longestRun[a] >= 66 {
            nAttain += 1
            if r.score[a] != ceiling { badAttain += 1 }
        } else {
            nBelow += 1
            if r.score[a] >= ceiling { badAttain += 1 }
        }
    }
    arm("A14", "every homopolymer score is EXACTLY predicted by an independent run scan",
        badCeiling == 0 && badAttain == 0 && nAttain > 0 && nBelow > 0,
        "20 homopolymers, none above its 66*s(a,a) ceiling; \(nAttain) residues have a proteome run >= 66 and every one attains its ceiling exactly, \(nBelow) do not and every one falls short — both branches non-empty, so neither is vacuous")
}
// A22 the composition-matched null EXACTLY cancels composition-driven score.
// A homopolymer is its own shuffle, so its paired delta is exactly 0 whatever
// its raw score. This is the property that makes the paired design the right
// comparison for a K/R-rich corpus, and it is checkable without any statistics.
do {
    let poly = [Int8](repeating: code[Int(UInt8(ascii: "Q"))], count: 66)
    let raw = [UInt8](repeating: UInt8(ascii: "Q"), count: 66)
    let sh = shuffled(poly, raw, 0)
    let mixed = qSeq[1]
    let mixedSh = shuffled(mixed, qSeqRaw[1], 0)
    arm("A22", "the paired null cancels COMPOSITION exactly, leaving only ORDER",
        sh == poly && mixedSh != mixed,
        "a homopolymer is its own permutation so its real-minus-shuffle delta is exactly 0 no matter how high its raw score; a mixed sequence is not, so the shuffle is not the identity in general")
}
// A15 the saturation guard FIRES and is load-bearing
do {
    guard let p = accIndex[A11_ACC] else { refuse("missing") }
    let q = proteinSeq(p)
    // run the Int8 kernel alone, without the guard, on a single block
    let m = q.count, mG = m * GROUPS
    var prof = [V](repeating: VZ, count: NA * mG)
    for a in 0..<NA { for pos in 0..<m { for g in 0..<GROUPS {
        var v = VZ
        for l in 0..<LANES { v[l] = B62[Int(q[pos]) * NA + a] }
        prof[a*mG + pos*GROUPS + g] = v
    } } }
    var H = [V](repeating: VZ, count: mG), F = H
    var os = [Int8](repeating: 0, count: BLOCK)
    var op = [Int32](repeating: -1, count: BLOCK)
    var ctr = [Int](repeating: -1, count: 2)
    prof.withUnsafeBufferPointer { pp in refU.withUnsafeBufferPointer { rp in
      allProt.withUnsafeBufferPointer { plp in protStartArr.withUnsafeBufferPointer { ssp in
        H.withUnsafeMutableBufferPointer { hp in F.withUnsafeMutableBufferPointer { fp in
          os.withUnsafeMutableBufferPointer { osp in op.withUnsafeMutableBufferPointer { opp in
            ctr.withUnsafeMutableBufferPointer { cp in
              kernelBlock(m, pp.baseAddress!, rp.baseAddress!, plp.baseAddress!, ssp.baseAddress!,
                          N_PROT, 1, hp.baseAddress!, fp.baseAddress!,
                          osp.baseAddress!, opp.baseAddress!, cp.baseAddress!)
            }
          } }
        } }
      } }
    } }
    let raw8 = Int32(os[0])
    arm("A15", "the Int8 saturation guard FIRES and is load-bearing",
        raw8 >= Int32(SAT_THRESHOLD) && raw8 != a11self,
        "the raw Int8 kernel answers \(raw8) for \(A11_ACC) while the true score is \(a11self) — the guard fires at >= \(SAT_THRESHOLD) and the Int32 oracle supplies the answer. A guard never seen to fire is indistinguishable from one that cannot.")
}
// A16 the guard does NOT fire on a low-scoring query (both directions)
do {
    let r = screen([qSeq[0]], allProt, B62, "selftest-A16")
    arm("A16", "the guard does NOT fire on an ordinary query", r.saturatedCount == 0 && r.score[0] < Int32(SAT_THRESHOLD),
        "corpus sequence \(qIds[0]) scores \(r.score[0]) with 0 saturating lanes — so A15 is a discrimination, not a constant")
}
// A17 the null shuffle is a composition-matched permutation, deterministic
do {
    let q = qSeq[0], raw = qSeqRaw[0]
    let s1 = shuffled(q, raw, 0), s2 = shuffled(q, raw, 0)
    var c1 = [Int](repeating: 0, count: NA), c2 = [Int](repeating: 0, count: NA)
    for x in q  { c1[Int(x)] += 1 }
    for x in s1 { c2[Int(x)] += 1 }
    let sameComp = (c1 == c2) && s1.count == q.count
    let deterministic = (s1 == s2)
    let notIdentity = (s1 != q)
    arm("A17", "the null is a deterministic composition-matched permutation",
        sameComp && deterministic && notIdentity,
        "residue multiset preserved exactly, identical across two invocations, and not the identity permutation")
}
// A18 corpus alphabet
do {
    var letters = ""
    for c in 0..<256 where corpAlphaCount[c] > 0 { letters.append(Character(UnicodeScalar(UInt8(c)))) }
    arm("A18", "corpus alphabet is exactly the 20 standard residues",
        String(letters.sorted()) == "ACDEFGHIKLMNPQRSTVWY",
        "observed '\(String(letters.sorted()))' — no U and no X, so the query side never reads the ambiguity row")
}
// A19 reference alphabet, U counted
do {
    var letters = ""
    for c in 0..<256 where refAlphaCount[c] > 0 { letters.append(Character(UnicodeScalar(UInt8(c)))) }
    arm("A19", "reference alphabet is 21 letters and U is counted",
        String(letters.sorted()) == "ACDEFGHIKLMNPQRSTUVWY" && uCount == 36 && uProteinIdx.count == 25,
        "observed '\(String(letters.sorted()))', U occurs \(uCount) times in \(uProteinIdx.count) proteins")
}
// ---------------------------------------------------------------------------
// A20  A GATE GIVEN NOTHING MUST NOT PASS — and until 2026-09-07 this arm was
// arm("A20", ..., true, ...).  A literal true.  It could not fail, it counted
// toward the published arm total, and its detail line asserted that the path was
// "exercised by validate.sh under a re-rooted binary" — which validate-homology.sh
// does not do: all four of its refusal arms refuse at the root walk or a digest
// gate, before screen() is ever reached.  The behaviour was real; the arm was not
// a measurement of it.
//
// It is now a measurement.  screen() refuses by calling exit(2), which cannot be
// observed in-process, and fork() is unavailable in Swift on Darwin.  So this arm
// SPAWNS THIS SAME EXECUTABLE IMAGE with the one reserved argument, and that child
// reaches the real call site with a real empty list.  Graded on the child's exit
// code, its REASON line, the ABSENCE of a seal, and — the other direction — the
// presence of the pinned figures the child printed before refusing.
// ---------------------------------------------------------------------------
do {
    var exePath = ""
    var sz: UInt32 = 8192
    var eb = [CChar](repeating: 0, count: Int(sz))
    if _NSGetExecutablePath(&eb, &sz) == 0 { exePath = String(cString: eb) }
    var ok = false
    var detail = "executable path unavailable, so the probe could not be spawned"
    if !exePath.isEmpty {
        let proc = Process()
        proc.executableURL = URL(fileURLWithPath: exePath)
        proc.arguments = [SELF_PROBE_ZERO_QUERY]
        let outPipe = Pipe()
        proc.standardOutput = outPipe
        proc.standardError = FileHandle.nullDevice
        proc.standardInput = FileHandle.nullDevice
        do {
            try proc.run()
            let d = outPipe.fileHandleForReading.readDataToEndOfFile()
            proc.waitUntilExit()
            let text = String(decoding: d, as: UTF8.self)
            let cleanExit = (proc.terminationReason == .exit)
            let code = Int(proc.terminationStatus)
            let sawReason = text.contains("was given ZERO queries")
            let sawFigures = text.contains("corpus rows       \(PIN_CORPUS_ROWS)")
            let noSeal = !text.contains(SEAL_MARKER)
            ok = cleanExit && code == 2 && sawReason && sawFigures && noSeal
            detail = "a child of THIS image reached screen([], [], [], ...) at the real call site: exit \(cleanExit ? String(code) : "terminated by signal"), REASON line \(sawReason ? "present" : "ABSENT"), pinned figures \(sawFigures ? "printed" : "MISSING"), seal \(noSeal ? "absent" : "PRESENT"), \(d.count) bytes on stdout"
        } catch {
            detail = "the probe could not be spawned"
        }
    }
    arm("A20", "an empty query list is REFUSED by the screen — EXERCISED, not asserted", ok, detail)
}
// A21 line-ending discipline, in BOTH directions.  This arm exists because the
// first run of this program parsed the corpus to ZERO rows and said so only
// because a count gate caught it: the corpus is CRLF, and Swift's
// String.split(separator: "\n") treats "\r\n" as ONE grapheme cluster, so it
// returns a single line for the whole 19.7 MB file.  The arm asserts the
// measured convention of each input AND demonstrates the naive split failing on
// the real bytes, so the byte-level parser is not merely asserted to be needed.
do {
    var refCR = 0
    refData.withUnsafeBytes { (raw: UnsafeRawBufferPointer) in
        let p = raw.bindMemory(to: UInt8.self)
        for i in 0..<p.count where p[i] == 0x0D { refCR += 1 }
    }
    let naiveLines = String(decoding: corpData, as: UTF8.self).split(separator: "\n", omittingEmptySubsequences: true).count
    arm("A21", "line endings are MEASURED per file, not assumed",
        corpCRLFRows == N_Q + 1 && refCR == 0 && naiveLines == 1 && qSeq.count == N_Q,
        "corpus is CRLF (\(corpCRLFRows) CR-terminated lines = \(N_Q) rows + header) while the reference is LF-only (\(refCR) CR); the Character-based split returns \(naiveLines) line on the real corpus bytes, the byte-level parser returns \(qSeq.count) rows")
}

// ---------------------------------------------------------------------------
// A23  THE WORK COUNTER IS AN INSTRUMENT AND MUST DISCRIMINATE.
//
// The published completeness figure is now the counter kernelBlock accumulates,
// which is only worth more than the old product-of-file-sizes if it FALLS when
// the work falls.  So this arm runs the same block twice over a synthetic
// proteome of known dimensions — once over every protein, once over half of them
// — and requires:
//   * the full count equals the hand product exactly, in cells AND in visits;
//   * the truncated count is STRICTLY SMALLER and equals ITS OWN hand product;
//   * the same holds across the six query lengths A6 already ran.
// Both branches must be non-empty, so neither is vacuous.
// ---------------------------------------------------------------------------
do {
    var rng = SplitMix64(0xA23A23A23)
    var sSeq = [Int8](); var sStart = [Int32]()
    var lens = [Int]()
    let nSP = 24
    for _ in 0..<nSP {
        sStart.append(Int32(sSeq.count))
        let L = 30 + rng.below(90)
        lens.append(L)
        for _ in 0..<L { sSeq.append(Int8(rng.below(20))) }
    }
    sStart.append(Int32(sSeq.count))
    var sU = [UInt8](repeating: 0, count: sSeq.count)
    for i in 0..<sSeq.count { sU[i] = UInt8(sSeq[i]) }
    let m = 41, mG = m * GROUPS
    var qs = [[Int8]]()
    for _ in 0..<BLOCK { var q = [Int8](); for _ in 0..<m { q.append(Int8(rng.below(20))) }; qs.append(q) }
    var prof = [V](repeating: VZ, count: NA * mG)
    for a in 0..<NA { for pos in 0..<m { for g in 0..<GROUPS {
        var v = VZ
        for l in 0..<LANES { v[l] = B62[Int(qs[g*LANES+l][pos]) * NA + a] }
        prof[a*mG + pos*GROUPS + g] = v
    } } }
    func run(_ nUse: Int, _ lanes: Int) -> (Int, Int) {
        var H = [V](repeating: VZ, count: mG), F = H
        var os = [Int8](repeating: 0, count: BLOCK)
        var op = [Int32](repeating: -1, count: BLOCK)
        var ctr = [Int](repeating: -1, count: 2)
        var plist = [Int32](); for p in 0..<nUse { plist.append(Int32(p)) }
        prof.withUnsafeBufferPointer { pp in sU.withUnsafeBufferPointer { rp in
          plist.withUnsafeBufferPointer { plp in sStart.withUnsafeBufferPointer { ssp in
            H.withUnsafeMutableBufferPointer { hp in F.withUnsafeMutableBufferPointer { fp in
              os.withUnsafeMutableBufferPointer { osp in op.withUnsafeMutableBufferPointer { opp in
                ctr.withUnsafeMutableBufferPointer { cp in
                  kernelBlock(m, pp.baseAddress!, rp.baseAddress!, plp.baseAddress!, ssp.baseAddress!,
                              nUse, lanes, hp.baseAddress!, fp.baseAddress!,
                              osp.baseAddress!, opp.baseAddress!, cp.baseAddress!)
                }
              } }
            } }
          } }
        } }
        return (ctr[CTR_CELLS], ctr[CTR_VISITS])
    }
    let half = nSP / 2
    var residuesFull = 0; for L in lens { residuesFull += L }
    var residuesHalf = 0; for p in 0..<half { residuesHalf += lens[p] }
    let (cFull, vFull) = run(nSP, BLOCK)
    let (cHalf, vHalf) = run(half, BLOCK)
    let (cLane, vLane) = run(nSP, 1)
    let fullExact  = cFull == BLOCK * m * residuesFull && vFull == BLOCK * nSP
    let halfExact  = cHalf == BLOCK * m * residuesHalf && vHalf == BLOCK * half
    let laneExact  = cLane == 1 * m * residuesFull && vLane == 1 * nSP
    let fell       = cHalf < cFull && vHalf < vFull && cLane < cFull && vLane < vFull
    var a6bad = 0
    for (c, v, wc, wv) in a23observed where c != wc || v != wv { a6bad += 1 }
    arm("A23", "the COUNTED-WORK figure DISCRIMINATES — it falls when the work falls",
        fullExact && halfExact && laneExact && fell && a6bad == 0 && a23observed.count == 6,
        "full \(nSP) proteins counted \(cFull) cells / \(vFull) visits = the hand product exactly; the SAME block over \(half) proteins counted \(cHalf)/\(vHalf), strictly smaller and equal to its own hand product; with 1 real lane instead of \(BLOCK) it counted \(cLane)/\(vLane); and the \(a23observed.count) A6 blocks over lengths 1,2,7,23,66,90 agree with their hand products in \(a23observed.count - a6bad) of \(a23observed.count). A completeness figure that cannot fall is the product of two file sizes wearing a counter's name.")
}

// ---------------------------------------------------------------------------
// A24  THE CALL'S OWN VERDICT WORDS MUST DISCRIMINATE.
//
// "=== THE ANSWER ===" now states the call rather than leaving it to be inferred
// from four tables, and every direction word in it is computed by direction()
// and every mode by modeOf().  Those two functions are therefore part of the
// sealed verdict, and a direction() that returned its first argument whatever
// the inputs would make the call unfalsifiable in exactly the way the old
// completeness figure was.  So both are exercised in ALL THREE branches, and the
// mode's tie rule — highest count, lowest score on a tie of counts — is checked
// on a constructed tie, because a mode is not defined without that rule.
// ---------------------------------------------------------------------------
do {
    let up   = direction(2, 1, "U", "L", "D")
    let lvl  = direction(1, 1, "U", "L", "D")
    let down = direction(1, 2, "U", "L", "D")
    let dirOK = up == "U" && lvl == "L" && down == "D"
    let m1 = modeOf([(45, 3), (57, 9), (90, 1)])          // plain maximum
    let m2 = modeOf([(45, 9), (57, 9), (90, 1)])          // count tie -> lowest score
    let m3 = modeOf([(45, 1), (57, 2), (90, 40)])         // mode at the top of the range
    let modeOK = m1.0 == 57 && m1.1 == 9 && m2.0 == 45 && m2.1 == 9 && m3.0 == 90 && m3.1 == 40
    arm("A24", "the CALL's verdict words and mode rule DISCRIMINATE", dirOK && modeOK,
        "direction() returns three DIFFERENT words on 2>1, 1=1 and 1<2 ('\(up)' '\(lvl)' '\(down)'), so a direction word in the sealed call is a reading rather than a constant; modeOf picks \(m1.0) from a plain maximum, \(m2.0) from a constructed count tie by the stated lowest-score rule, and \(m3.0) when the mode sits at the top of the range")
}

let ARMS = armPass + armFail
note("SELF-TEST: \(armPass) of \(ARMS) arms pass")
for l in armLines { note(l) }
if armFail > 0 {
    refuse("\(armFail) of \(ARMS) self-test arms failed. No measurement is emitted and no seal is computed when the instrument has not proven itself in both directions.")
}
note("")

// ===========================================================================
// THE MEASUREMENT
// ===========================================================================
let T_SELFTEST = nowNs()

progress("real corpus screen: \(N_Q) queries x \(N_PROT) proteins")
let realRes = screen(qSeq, allProt, B62, "real")
requireComplete("real", realRes, N_Q, totalQResidues, N_PROT, refSeq.count)
progress("real screen COUNTED \(realRes.cells) cells over \(realRes.visits) query-protein visits")
let T_REAL = nowNs()

progress("null screen: composition-matched shuffles")
var nullQ = [[Int8]]()
nullQ.reserveCapacity(N_Q)
for i in 0..<N_Q { nullQ.append(shuffled(qSeq[i], qSeqRaw[i], 0)) }
var nullQResidues = 0; for q in nullQ { nullQResidues += q.count }
let nullRes = screen(nullQ, allProt, B62, "null")
requireComplete("null", nullRes, N_Q, nullQResidues, N_PROT, refSeq.count)
progress("null screen COUNTED \(nullRes.cells) cells over \(nullRes.visits) query-protein visits")
let T_NULL = nowNs()

// U-sensitivity: the 25 U-bearing proteins re-screened under U->C
progress("U-convention sensitivity: 25 proteins under both conventions")
var B62_UC = B62
for a in 0..<NA { B62_UC[a*NA + IDX_X] = B62[a*NA + IDX_C]; B62_UC[IDX_X*NA + a] = B62[IDX_C*NA + a] }
B62_UC[IDX_X*NA + IDX_X] = B62[IDX_C*NA + IDX_C]
let uResX = screen(qSeq, uProt, B62, "u-X")
let uResC = screen(qSeq, uProt, B62_UC, "u-C")
let T_U = nowNs()

// deeper null for the top candidates
let TOPN = 64
let NULL_ROUNDS = 128
var byDelta = Array(0..<N_Q)
byDelta.sort { a, b in
    let da = realRes.score[a] - nullRes.score[a], db = realRes.score[b] - nullRes.score[b]
    if da != db { return da > db }
    if realRes.score[a] != realRes.score[b] { return realRes.score[a] > realRes.score[b] }
    return a < b
}
var byReal = Array(0..<N_Q)
byReal.sort { a, b in
    if realRes.score[a] != realRes.score[b] { return realRes.score[a] > realRes.score[b] }
    return a < b
}
var deepSet = Array(Set(byReal.prefix(TOPN)).union(Set(byDelta.prefix(TOPN)))).sorted()
progress("deep null: \(deepSet.count) candidates x \(NULL_ROUNDS) shuffles")
var deepQ = [[Int8]]()
var deepOwner = [Int]()
for qi in deepSet {
    for r in 1...NULL_ROUNDS {
        deepQ.append(shuffled(qSeq[qi], qSeqRaw[qi], UInt64(r)))
        deepOwner.append(qi)
    }
}
let deepRes = screen(deepQ, allProt, B62, "deep-null")

// ---------------------------------------------------------------------------
// SELECTION-MATCHED CONTROL FOR THE DEEP NULL.
//
// "N of the candidates beat all 128 of their own shuffles" is NOT by itself
// evidence of homology, and without this control it is unfalsifiable. The
// candidates were CHOSEN for being extreme — top by score, top by delta — out of
// 78,680. Conditioning on that selection, a sequence with no homology whatever
// is already expected to sit high inside its own null.
//
// So the identical procedure is run on a set chosen by the MIRROR IMAGE of the
// same rule, with the roles of the two screens swapped: top by NULL score, union
// top by (null minus real). Those sequences are shuffles — they have no residue
// order to carry homology, by construction. Whatever count they produce is what
// the selection alone buys. The two numbers are published side by side and the
// difference between them is the only part that could be signal.
// ---------------------------------------------------------------------------
func rawOf(_ q: [Int8]) -> [UInt8] { q.map { AA[Int($0)] } }
var byNull = Array(0..<N_Q)
byNull.sort { a, b in
    if nullRes.score[a] != nullRes.score[b] { return nullRes.score[a] > nullRes.score[b] }
    return a < b
}
var byDeltaNull = Array(0..<N_Q)
byDeltaNull.sort { a, b in
    let da = nullRes.score[a] - realRes.score[a], db = nullRes.score[b] - realRes.score[b]
    if da != db { return da > db }
    if nullRes.score[a] != nullRes.score[b] { return nullRes.score[a] > nullRes.score[b] }
    return a < b
}
var deepSetN = Array(Set(byNull.prefix(TOPN)).union(Set(byDeltaNull.prefix(TOPN)))).sorted()
progress("deep null CONTROL: \(deepSetN.count) shuffle-selected candidates x \(NULL_ROUNDS) shuffles")
var deepQN = [[Int8]]()
var deepOwnerN = [Int]()
for qi in deepSetN {
    let base = nullQ[qi]
    let baseRaw = rawOf(base)
    for r in 1...NULL_ROUNDS {
        deepQN.append(shuffled(base, baseRaw, UInt64(r)))
        deepOwnerN.append(qi)
    }
}
let deepResN = screen(deepQN, allProt, B62, "deep-null-control")
let T_DEEP = nowNs()

// ---------------------------------------------------------------------------
// distributions
// ---------------------------------------------------------------------------
func distribution(_ v: [Int32]) -> [(Int32, Int)] {
    var d = [Int32: Int]()
    for x in v { d[x, default: 0] += 1 }
    return d.sorted { $0.key < $1.key }.map { ($0.key, $0.value) }
}
func pad(_ s: String, _ w: Int) -> String {
    if s.count >= w { return s }
    return s + String(repeating: " ", count: w - s.count)
}
func lpad(_ s: String, _ w: Int) -> String {
    if s.count >= w { return s }
    return String(repeating: " ", count: w - s.count) + s
}

// ---------------------------------------------------------------------------
// INDEPENDENT RE-VERIFICATION OF THE PUBLISHED ANSWERS.
//
// Self-test A6 proves the SIMD kernel and the Int32 scalar oracle agree on 384
// synthetic query/proteome pairs. That is a statement about test cases. This
// section makes the same comparison on the ANSWERS THAT ACTUALLY GET PUBLISHED
// — the highest-scoring sequences and a deterministic spread across the rest —
// by running the whole proteome again through the second implementation.
//
// Only NON-saturating queries are eligible, and that is the point: a saturating
// query was already answered by the scalar oracle through the guard, so
// comparing it against the scalar oracle would compare a number with itself.
// A check that cannot disagree is not a check.
// ---------------------------------------------------------------------------
progress("re-verifying published answers with the Int32 scalar oracle")
var verifyIdx: [Int] = []
for qi in byReal {
    if verifyIdx.count >= 8 { break }
    if realRes.score[qi] < Int32(SAT_THRESHOLD) { verifyIdx.append(qi) }
}
do {
    var r = 0
    let stride = max(1, N_Q / 8)
    while r < N_Q && verifyIdx.count < 16 {
        let qi = byReal[r]
        if realRes.score[qi] < Int32(SAT_THRESHOLD) && !verifyIdx.contains(qi) { verifyIdx.append(qi) }
        r += stride
    }
}
var verifyAgree = 0, verifyDisagree = 0
var verifyLines: [String] = []
for qi in verifyIdx {
    let (s, p) = scalarOverProteins(qSeq[qi], allProt, B62)
    let ok = (s == realRes.score[qi] && p == realRes.protIdx[qi])
    if ok { verifyAgree += 1 } else { verifyDisagree += 1 }
    let aSimd = realRes.protIdx[qi] >= 0 ? accs[Int(realRes.protIdx[qi])] : "none"
    let aScal = p >= 0 ? accs[Int(p)] : "none"
    verifyLines.append("  \(pad(qIds[qi], 34)) simd \(lpad(String(realRes.score[qi]), 4)) @\(pad(aSimd, 11)) scalar \(lpad(String(s), 4)) @\(pad(aScal, 11)) \(ok ? "AGREE" : "DISAGREE")")
}
if verifyDisagree > 0 {
    for l in verifyLines { note(l) }
    refuse("\(verifyDisagree) of \(verifyIdx.count) PUBLISHED answers disagree between the SIMD kernel and the Int32 scalar oracle. Two implementations of one law that disagree mean the law has a gap; no verdict is sealed until they agree.")
}
let T_VERIFY = nowNs()

let realDist = distribution(realRes.score)
let nullDist = distribution(nullRes.score)
let realMin = realDist.first!.0, realMax = realDist.last!.0
let nullMin = nullDist.first!.0, nullMax = nullDist.last!.0
var realSum = 0; for s in realRes.score { realSum += Int(s) }
var nullSum = 0; for s in nullRes.score { nullSum += Int(s) }

var greater = 0, equal = 0, lesser = 0
var deltaDist = [Int32: Int]()
for i in 0..<N_Q {
    let d = realRes.score[i] - nullRes.score[i]
    deltaDist[d, default: 0] += 1
    if d > 0 { greater += 1 } else if d == 0 { equal += 1 } else { lesser += 1 }
}

// U-sensitivity arithmetic
var uWinsOrTies = 0
var uChangesMax = 0
var uAmbiguous = 0
for i in 0..<N_Q {
    let g = realRes.score[i]
    if uResX.score[i] >= g { uWinsOrTies += 1 }
    if uResC.score[i] > g { uChangesMax += 1 }
    if uResX.score[i] >= g && uResC.score[i] < g { uAmbiguous += 1 }
}
var argmaxIsU = 0
for i in 0..<N_Q where realRes.protIdx[i] >= 0 && protHasU[Int(realRes.protIdx[i])] { argmaxIsU += 1 }

// deep null per candidate
var deepMax = [Int: Int32](); var deepGE = [Int: Int](); var deepSum = [Int: Int]()
for k in 0..<deepQ.count {
    let o = deepOwner[k]
    let s = deepRes.score[k]
    if s > (deepMax[o] ?? -1) { deepMax[o] = s }
    deepSum[o, default: 0] += Int(s)
    if s >= realRes.score[o] { deepGE[o, default: 0] += 1 }
}
var candidatesAboveOwnNull = 0
for qi in deepSet where (deepGE[qi] ?? 0) == 0 { candidatesAboveOwnNull += 1 }
// selection-matched control
var deepGEN = [Int: Int]()
for k in 0..<deepQN.count {
    let o = deepOwnerN[k]
    if deepResN.score[k] >= nullRes.score[o] { deepGEN[o, default: 0] += 1 }
}
var controlAboveOwnNull = 0
for qi in deepSetN where (deepGEN[qi] ?? 0) == 0 { controlAboveOwnNull += 1 }
let candPpm = deepSet.count > 0 ? candidatesAboveOwnNull * 1_000_000 / deepSet.count : 0
let ctrlPpm = deepSetN.count > 0 ? controlAboveOwnNull * 1_000_000 / deepSetN.count : 0

// ---------------------------------------------------------------------------
// THE CALL'S VERDICT WORDS, COMPUTED.
//
// A transcript that prints "the two distributions are the SAME" and "the sign
// test is a COIN" whatever the numbers did has the same defect the completeness
// figure had: the sentence is green by construction.  So every direction word in
// the call below is derived here from the measurement, and the call itself
// branches on a count of clauses rather than on an author's summary.
//
// The three comparisons are independent of one another: (1) is the extreme of
// the two distributions, (2) is the paired sign over all 78,680, (3) is the deep
// null against a control that holds the SELECTION fixed.  A real sequence-level
// signal has to survive all three; each one alone has a way of being wrong.
// ---------------------------------------------------------------------------
func direction(_ a: Int, _ b: Int, _ up: String, _ level: String, _ down: String) -> String {
    return a > b ? up : (a == b ? level : down)
}
let c1word = direction(Int(realMax), Int(nullMax), "EXCEEDS", "EQUALS", "does NOT reach")
let c1bound = direction(Int(realMax), Int(nullMax), "sits ABOVE", "EQUALS", "sits BELOW")
let c2word = direction(greater, lesser, "to the REAL side", "NEITHER way", "to the NULL side")
let c3word = direction(candPpm, ctrlPpm, "ABOVE", "LEVEL WITH", "BELOW")
let signImbalance = greater > lesser ? greater - lesser : lesser - greater
let signImbalancePpm = signImbalance * 1_000_000 / N_Q
var clausesFor = 0, clausesAgainst = 0, clausesLevel = 0
for (a, b) in [(Int(realMax), Int(nullMax)), (greater, lesser), (candPpm, ctrlPpm)] {
    if a > b { clausesFor += 1 } else if a < b { clausesAgainst += 1 } else { clausesLevel += 1 }
}

// modes, by the deterministic rule: highest count, and on a tie of counts the
// LOWEST score.  Stated because "the mode" is not defined without it.
func modeOf(_ d: [(Int32, Int)]) -> (Int32, Int) {
    var bs: Int32 = -1, bc = -1
    for (s, c) in d { if c > bc || (c == bc && s < bs) { bs = s; bc = c } }
    return (bs, bc)
}
let (realMode, realModeN) = modeOf(realDist)
let (nullMode, nullModeN) = modeOf(nullDist)

// THE RESOLUTION FLOOR, solved rather than asserted: the smallest identity
// length whose AVERAGE score clears the corpus band's floor, and the smallest
// that clears its maximum.  Enumerated up to the longest query, so a k that does
// not exist inside this study's own length range is reported as that length + 1
// rather than as a number pulled from nowhere.
func smallestK(_ target: Int32) -> Int {
    var k = 1
    while k <= PIN_CORPUS_MAXLEN {
        if k * meanDiagMilli / 1000 > Int(target) { return k }
        k += 1
    }
    return PIN_CORPUS_MAXLEN + 1
}
let kClearFloor = smallestK(realMin)     // clears the band's FLOOR — not the same as being seen
let kClearMode  = smallestK(realMode)    // clears the bulk
let kClearMax   = smallestK(realMax)     // clears the entire corpus band
let kClearNull  = smallestK(nullMax)     // clears the null's band too, which is the real bar

// ===========================================================================
// TRANSCRIPT
// ===========================================================================
emit("BEGIN TRANSCRIPT")
emit("STUDY: homology of 78,680 generated peptides to the reviewed human proteome, UNDER SUBSTITUTION")
emit("INSTRUMENT: exact Smith-Waterman local alignment, BLOSUM62, integer affine gaps (a gap of length k costs 11 + k)")
emit("NO E-VALUE. NO FITTED PARAMETER. NO SEEDING HEURISTIC. NO SAMPLING. NO CUTOFF INSIDE THE ARITHMETIC.")
emit("")
emit("INPUTS, hashed by this program and refused on mismatch")
emit("  corpus sha256 (computed)     \(corpSha)")
emit("  reference sha256 (computed)  \(refSha)")
emit("  blosum62 sha256 (computed)   \(b62sha)   [cross-checked against an INDEPENDENT BLOSUM62 this program does not read]")
emit("  corpus rows       \(N_Q)")
emit("  corpus residues   \(totalQResidues)")
emit("  reference proteins \(N_PROT)")
emit("  reference residues \(refSeq.count)")
emit("  reference U count  \(uCount) in \(uProteinIdx.count) proteins, scored through the BLOSUM62 X row")
emit("")
emit("COMPLETENESS, COUNTED AS THE WORK HAPPENS — not the product of the two input file sizes")
emit("  Until 2026-09-07 this section printed the product \(totalQResidues) x \(refSeq.count) and called")
emit("  it completeness. That product is computed from the parsed inputs and is IDENTICAL whatever")
emit("  the screen then did — MEASURED, not argued: the pre-repair program restricted to 400 of the")
emit("  \(N_PROT) proteins exits 0, passes its whole self-test, seals, and prints that IDENTICAL figure")
emit("  under the IDENTICAL sentence, while every figure it publishes is wrong: maximum 84 where this")
emit("  run measures \(realMax), sum of maxima 3668659 where this run measures \(realSum), floor 35 where this")
emit("  run measures \(realMin). The recipe is in this program's header so the control can be repeated")
emit("  rather than believed. A claim that cannot fail is not a claim.")
emit("  The two figures below are instead accumulated INSIDE kernelBlock, one addition per protein")
emit("  visited, and this run REFUSES before the seal unless they equal the complete work exactly.")
emit("  Self-test A23 shows the counter falling when the work falls; validate-homology.sh builds a")
emit("  deliberately truncated variant and requires its refusal.")
emit("  query-protein visits COUNTED, real corpus:  \(realRes.visits)")
emit("  query-protein visits COUNTED, null corpus:  \(nullRes.visits)")
emit("  dynamic programming cells COUNTED, real corpus:  \(realRes.cells)")
emit("  dynamic programming cells COUNTED, null corpus:  \(nullRes.cells)")
emit("  every query against every reference protein, no exceptions — and that sentence is now")
emit("  falsifiable: \(realRes.visits) counted visits against \(N_Q) x \(N_PROT) = \(N_Q * N_PROT) required")
emit("  saturating queries resolved by the exact Int32 oracle: real \(realRes.saturatedCount), null \(nullRes.saturatedCount)")
emit("")
emit("SELF-TEST: \(armPass) of \(ARMS) arms pass")
for l in armLines { emit(l) }
emit("")
emit("INDEPENDENT RE-VERIFICATION OF THE PUBLISHED ANSWERS")
emit("  The SIMD kernel and the Int32 scalar oracle are two implementations of one recurrence.")
emit("  A6 compares them on 384 synthetic cases; this compares them on the answers that are")
emit("  published below — the top-scoring sequences plus a deterministic spread across the rank")
emit("  order — each re-run against the whole proteome by the scalar implementation.")
emit("  Only NON-saturating queries are eligible: a saturating query was already answered by the")
emit("  scalar oracle through the guard, so checking it here would compare a number with itself.")
emit("  agreed \(verifyAgree) of \(verifyIdx.count); any disagreement refuses the run before the seal")
for l in verifyLines { emit(l) }
emit("")
emit("=== THE ANSWER ===")
emit("")
emit("THE CALL. The transcript stated four tables and left the reader to infer the answer from them;")
emit("it now states the answer. EVERY VERDICT WORD BELOW IS COMPUTED FROM THE MEASUREMENT, not typed")
emit("beside it — the direction words, the count of clauses, and which branch of the call is printed.")
emit("A sentence that says SAME or EXCEEDS or COIN whatever the numbers do is the unfalsifiable")
emit("failure this study spent a repair removing from its own completeness figure; it is not")
emit("reintroduced here in prose.")
emit("")
emit("  THREE INDEPENDENT COMPARISONS, each with its own direction and its own magnitude:")
emit("    (1) the real maximum \(c1word) the null's:  \(realMax) against \(nullMax)")
emit("    (2) the paired sign leans \(c2word):  \(greater) above own shuffle, \(lesser) below,")
emit("        \(equal) exactly tied — an imbalance of \(signImbalance) sequences, \(signImbalancePpm) ppm of the corpus,")
emit("        next to \(equal * 1_000_000 / N_Q) ppm of exact ties")
emit("    (3) the deep-null candidates come back \(c3word) their selection-matched control:")
emit("        \(candPpm) ppm against \(ctrlPpm) ppm  (\(candidatesAboveOwnNull) of \(deepSet.count) against \(controlAboveOwnNull) of \(deepSetN.count))")
emit("  Toward a signal: \(clausesFor) of 3.  Against: \(clausesAgainst) of 3.  Level: \(clausesLevel) of 3.")
emit("")
if clausesFor == 3 {
    emit("  A SEQUENCE-LEVEL SIGNAL SURVIVES ALL THREE COMPARISONS. The highest-scoring sequences are")
    emit("  named in the table below with their accessions, and this transcript does NOT call the")
    emit("  corpus free of homology. Read the table, not this line.")
} else {
    emit("  NO SEQUENCE among the \(N_Q) shows detectable homology to a reviewed human protein under")
    emit("  substitution. A signal has to survive all three comparisons; it survives \(clausesFor) of 3.")
    emit("  Comparison (1): the corpus reaches \(realMax) where its own permuted residues reach \(nullMax).")
    emit("  Comparison (2): the whole imbalance is \(signImbalance) sequences out of \(N_Q) — \(signImbalancePpm) ppm — against")
    emit("  \(equal) exact ties, and it takes the sign of a coin to move it further than that.")
    emit("  Comparison (3): the control that holds the SELECTION fixed and removes residue order")
    emit("  entirely returns \(ctrlPpm) ppm where the real candidates return \(candPpm) ppm.")
    if ctrlPpm >= candPpm {
        emit("  Selection alone therefore buys as much of that last effect as the corpus shows, and")
        emit("  nothing is left over for residue order to have caused.")
    } else {
        emit("  \(candPpm - ctrlPpm) ppm of that last effect is NOT bought by selection, and that residue is the")
        emit("  only part of this study that could be signal. It is named in the table below.")
    }
}
emit("")
emit("  THE TWO DISTRIBUTIONS, side by side, with no adjective between them:")
emit("    real   floor \(realMin)  mode \(realMode) (\(realModeN) sequences)  maximum \(realMax)  sum \(realSum)")
emit("    null   floor \(nullMin)  mode \(nullMode) (\(nullModeN) sequences)  maximum \(nullMax)  sum \(nullSum)")
emit("    over the same \(N_Q) sequences and the same \(totalQResidues) residues; the sums differ by \(realSum - nullSum).")
emit("")
emit("  THE BOUND, equally plainly. The largest local alignment score attained by any of the \(N_Q)")
emit("  against any of the \(N_PROT) reviewed human proteins is \(realMax). For scale, on this same")
emit("  instrument a genuine remote homology — HBA_HUMAN against HBB_HUMAN — scores \(a13hb), and a")
emit("  protein against itself scores \(a11self). \(realMax) \(c1bound) the null's own maximum of \(nullMax), so")
emit("  \(realMax > nullMax ? "it stands outside the range its own permuted residues reach" : "it is not separable from permuted residues of the same composition").")
emit("  The bound on how far a real match could have risen without being seen is the RESOLUTION")
emit("  LIMIT in the closing section, and it is stated there with its arithmetic.")
emit("")
emit("REAL CORPUS — distribution of the maximum Smith-Waterman score against the whole human proteome")
emit("  observed minimum \(realMin), observed maximum \(realMax)")
emit("  sum of maxima \(realSum) over \(N_Q) sequences; mean is exactly \(realSum)/\(N_Q)")
emit("  score  count      ppm of corpus")
for (s, c) in realDist {
    emit("  \(lpad(String(s), 5))  \(lpad(String(c), 9))  \(lpad(String(c * 1_000_000 / N_Q), 9))")
}
emit("")
emit("NULL — the SAME sequences, residues permuted, screened the SAME way")
emit("  the null is COMPUTED, never fitted: each sequence's own residues are permuted by a")
emit("  Fisher-Yates shuffle whose SplitMix64 seed is the first 8 bytes of sha256(sequence).")
emit("  No clock, no arc4random. Composition is preserved exactly (self-test A17).")
emit("  observed minimum \(nullMin), observed maximum \(nullMax)")
emit("  sum of maxima \(nullSum) over \(N_Q) sequences; mean is exactly \(nullSum)/\(N_Q)")
emit("  score  count      ppm of corpus")
for (s, c) in nullDist {
    emit("  \(lpad(String(s), 5))  \(lpad(String(c), 9))  \(lpad(String(c * 1_000_000 / N_Q), 9))")
}
emit("")
emit("PAIRED COMPARISON — each sequence against ITS OWN shuffle. This is the comparison that matters:")
emit("it holds length and composition fixed and varies only residue ORDER, which is what homology is.")
emit("  real > own shuffle   \(greater)  (\(greater * 1_000_000 / N_Q) ppm)")
emit("  real = own shuffle   \(equal)  (\(equal * 1_000_000 / N_Q) ppm)")
emit("  real < own shuffle   \(lesser)  (\(lesser * 1_000_000 / N_Q) ppm)")
emit("  under no homology the sign is a coin: measured \(greater) up against \(lesser) down.")
emit("  distribution of (real minus own shuffle)")
emit("  delta  count")
for (d, c) in deltaDist.sorted(by: { $0.key < $1.key }) {
    emit("  \(lpad(String(d), 5))  \(lpad(String(c), 9))")
}
emit("")
emit("THE HIGHEST-SCORING SEQUENCES, and what a bench would point at")
emit("  the reporting threshold is applied HERE, to the published distribution above, never inside the arithmetic")
emit("  \(pad("sequence_id", 34)) \(pad("len", 4)) \(pad("score", 6)) \(pad("accession", 11)) \(pad("shuffle", 8)) \(pad("delta", 6)) \(pad("deepnull_max", 13)) shuffles>=real of \(NULL_ROUNDS)")
for qi in byReal.prefix(24) {
    let acc = realRes.protIdx[qi] >= 0 ? accs[Int(realRes.protIdx[qi])] : "none"
    let dm = deepMax[qi].map { String($0) } ?? "-"
    let dg = deepGE[qi].map { String($0) } ?? "-"
    emit("  \(pad(qIds[qi], 34)) \(pad(String(qSeq[qi].count), 4)) \(pad(String(realRes.score[qi]), 6)) \(pad(acc, 11)) \(pad(String(nullRes.score[qi]), 8)) \(pad(String(realRes.score[qi] - nullRes.score[qi]), 6)) \(pad(dm, 13)) \(dg)")
}
emit("")
emit("DEEP NULL for the \(deepSet.count) candidates (top \(TOPN) by score, union top \(TOPN) by delta): \(NULL_ROUNDS) independent shuffles each")
emit("  candidates whose real score exceeds ALL \(NULL_ROUNDS) of their own shuffles: \(candidatesAboveOwnNull) of \(deepSet.count)  (\(candPpm) ppm)")
emit("  total deep-null alignments computed: \(deepQ.count)")
emit("")
emit("  SELECTION-MATCHED CONTROL. The line above is NOT on its own evidence of homology, and")
emit("  without this control it cannot be falsified: those candidates were CHOSEN for being")
emit("  extreme out of \(N_Q), and conditioning on that selection a sequence with no homology")
emit("  whatever already sits high inside its own null. So the identical procedure is run on a")
emit("  set chosen by the MIRROR of the same rule with the two screens swapped — top \(TOPN) by")
emit("  NULL score, union top \(TOPN) by (null minus real). Those sequences ARE shuffles: they")
emit("  carry no residue order that could encode homology, by construction.")
emit("  control set size \(deepSetN.count); control alignments computed \(deepQN.count)")
emit("  CONTROL: shuffle-selected sequences exceeding ALL \(NULL_ROUNDS) of their own shuffles: \(controlAboveOwnNull) of \(deepSetN.count)  (\(ctrlPpm) ppm)")
emit("  Only the DIFFERENCE between \(candPpm) ppm and \(ctrlPpm) ppm could be signal; the shared part is selection.")
emit("")
emit("U-CONVENTION SENSITIVITY — measured, not asserted")
emit("  queries whose reported argmax protein contains U: \(argmaxIsU)")
emit("  queries where the 25 U-bearing proteins attain or tie the global maximum (U->X): \(uWinsOrTies)")
emit("  queries whose maximum would RISE under the alternative convention U->C: \(uChangesMax)")
emit("  queries where the sensitivity is not exactly decidable from these three screens: \(uAmbiguous)")
emit("  the corpus contains no U (self-test A18), so only the column s(a,U) is ever read.")
emit("")
emit("LOW-COMPLEXITY CONTROL (self-test A14), all twenty homopolymers, length 66, against the whole proteome")
emit("  No SEG/DUST low-complexity masking is applied anywhere in this program. BLAST masks by default;")
emit("  masking is a choice made before the arithmetic, and this study makes none. A homopolymer scores")
emit("  high because the human proteome really does carry long low-complexity tracts, and the score is")
emit("  bounded exactly by 66*s(a,a) and attains that bound exactly when a run of 66 or more exists.")
emit("  residue  score  ceiling(66*s(a,a))  longest run in the reference proteome")
for (l, s, c, r) in a14 {
    emit("  \(pad(l, 8)) \(lpad(String(s), 6)) \(lpad(String(c), 18))  \(r)")
}
emit("  This is why the paired comparison above is the load-bearing one: a homopolymer is its own")
emit("  permutation, so the composition-matched null gives it delta exactly 0 however high its raw")
emit("  score. Composition cannot survive the pairing; only residue ORDER can.")
emit("")
emit("=== WHAT THIS MEASURES AND WHAT IT DOES NOT ===")
emit("MEASURES: the exact optimal local alignment score of each generated peptide against every")
emit("  reviewed human protein, under BLOSUM62 with BLASTP-default affine gaps. This is sensitive")
emit("  to substitution: a peptide 80% identical to a human protein with scattered mismatches")
emit("  scores far above an unrelated one, which is exactly what the preceding exact-substring")
emit("  study could not see.")
emit("DOES NOT MEASURE: cross-reactivity, MHC presentation, epitope prediction, antibody binding,")
emit("  structural mimicry, or immunological safety. A Smith-Waterman score is a sequence")
emit("  statement. It is not a bench result and no clinical property follows from it.")
emit("  It also says nothing about the unreviewed proteome, isoforms, or non-human proteins.")
emit("")
emit("RESOLUTION LIMIT — the arithmetic, because it governs how the answer above may be read.")
emit("  A whole-sequence maximum cannot see a match shorter than the background it sits in, and this")
emit("  study's background is measured above: \(realMin) to \(realMax) over \(N_Q) sequences.")
emit("  The mean BLOSUM62 diagonal weighted by THIS proteome's own composition is \(meanDiagMilli)/1000")
emit("  (\(diagResidues) residues over the 20 standard letters; the \(uCount) U are excluded, having no")
emit("  BLOSUM62 diagonal of their own). A gapless, 100%-identity window of k residues scores exactly")
emit("  the sum of ITS OWN k diagonal entries, so it is bounded by k*\(minDiag) and k*\(maxDiag) and averages")
emit("  k*\(meanDiagMilli)/1000 over this composition. Per k, floor / average / ceiling:")
emit("     8 residues    \(8 * minDiag)  /  \(8 * meanDiagMilli / 1000)  /  \(8 * maxDiag)")
emit("     9 residues    \(9 * minDiag)  /  \(9 * meanDiagMilli / 1000)  /  \(9 * maxDiag)")
emit("    10 residues    \(10 * minDiag)  /  \(10 * meanDiagMilli / 1000)  /  \(10 * maxDiag)")
emit("  An MHC class-I ligand is 8 to 10 residues. Its average perfect identity is \(8 * meanDiagMilli / 1000) to")
emit("  \(10 * meanDiagMilli / 1000) here, and the corpus background runs \(realMin) to \(realMax) with its mode at \(realMode).")
emit("  So a REAL short-epitope match CANNOT lift a whole-sequence maximum out of this background")
emit("  and is NOT RESOLVABLE by this statistic. Solved rather than asserted, the smallest identity")
emit("  length k whose AVERAGE score passes each landmark of that band:")
emit("     past the floor \(realMin):            k = \(kClearFloor)")
emit("     past the mode \(realMode):             k = \(kClearMode)")
emit("     past the corpus maximum \(realMax):   k = \(kClearMax)")
emit("     past the null's maximum \(nullMax):   k = \(kClearNull)")
emit("  Clearing the FLOOR is not being seen: at k = \(kClearFloor) the match still sits among the bulk of")
emit("  \(N_Q) sequences that have no homology at all, and the smallest k whose average even reaches")
emit("  the MODE of \(realMode) is \(kClearMode) — already longer than the entire 8-to-10 class-I range. Being")
emit("  SEEN means passing \(nullMax), the null's own maximum, and that takes k = \(kClearNull): short of it by")
emit("  \(kClearNull - 10) to \(kClearNull - 8) residues, which is where the class-I range sits. The ceiling column above")
emit("  is the arithmetic bound and not a peptide: a 9-mer of the single highest-scoring residue")
emit("  would reach \(9 * maxDiag) and clear the band, and nothing anyone presents is a poly-tryptophan.")
emit("  Before this section existed the word 'epitope' occurred EXACTLY ONCE in the whole program, in")
emit("  the DOES NOT MEASURE list above, and the arithmetic that turns that exclusion from a")
emit("  disclaimer into a MEASUREMENT was nowhere in the sealed transcript at all. That is what this")
emit("  section adds. Reading the answer above as 'these peptides carry no human-like epitope' is")
emit("  over-reading its own null.")
emit("  What the instrument DOES reach, measured in this same run: a whole-sequence homology scores")
emit("  \(a13hb) (HBA against HBB) and a self-match \(a11self), both clear of the \(realMin)-to-\(realMax) band by more")
emit("  than the band is wide. The resolution therefore runs from whole-sequence homology, which this")
emit("  instrument finds, down to about \(kClearNull) residues of perfect identity, below which it does not.")
emit("END TRANSCRIPT")

let transcript = TX.joined(separator: "\n") + "\n"
print(SEAL_MARKER + SHA256Exact.hexOf(transcript))
print("")
let T_END = nowNs()
print("UNSEALED timings — these are NOT inside the seal, because a seal that moves when nothing")
print("about the answer moved is a turn counter.")
print("  self-test          \((T_SELFTEST - T_START) / 1_000_000) ms")
print("  real corpus screen \((T_REAL - T_SELFTEST) / 1_000_000) ms")
print("  null screen        \((T_NULL - T_REAL) / 1_000_000) ms")
print("  U sensitivity      \((T_U - T_NULL) / 1_000_000) ms")
print("  deep null          \((T_DEEP - T_U) / 1_000_000) ms")
print("  scalar re-verify   \((T_VERIFY - T_DEEP) / 1_000_000) ms")
print("  total              \((T_END - T_START) / 1_000_000) ms")
do {
    let cells = totalQResidues * refSeq.count * 2
    let secs = max(1, (T_NULL - T_SELFTEST) / 1_000_000_000)
    print("  measured throughput over the real + null screens: \(cells / secs / 1_000_000) MCUPS aggregate")
    print("  (single-core kernel measured separately at 8874 MCUPS; striped Farrar measured at 569 MCUPS)")
}
exit(0)
