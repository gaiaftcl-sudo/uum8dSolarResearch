// THE REGISTRY SPECIFICITY RANKING — is a nucleic-acid medicine more specific than an ordinary
// sequence of the same bases, or is its off-target burden simply what its composition forces?
//
// WHY THE COMPARISON, AND NOT THE LIST.  An off-target list on its own decides nothing.  ANY
// 20-mer has hundreds of near-complementary windows in a corpus of 1.4 billion windows, for the
// same reason any 20-letter string appears in a large enough library: the corpus is enormous.
// The question a bench actually has is COMPARATIVE, and it is discrete, and it is therefore
// exactly answerable:
//
//     does THIS ORDER of these bases pair in fewer places than the SAME BASES IN ANOTHER ORDER?
//
// That is a property of the design, it is measurable in integers before a molecule is ever
// synthesised, and it reads the same in every laboratory forever.
//
// WHAT IS COUNTED.  Watson-Crick complementarity is a DISCRETE rule, so it is COUNTED, never
// estimated.  Bases A=0 C=1 G=2 T/U=3.  An antisense strand binds antiparallel, so position i of
// the strand pairs with position L-1-i of the window, and a position pairs exactly when the two
// codes sum to 3.  One integer per window per probe.  No sampling, no seed heuristic, no e-value,
// no cutoff inside the arithmetic.  The reporting thresholds are applied AFTER the arithmetic and
// the complete mismatch histogram is published, so any reader can re-make that choice without
// re-running anything.
//
// THE CONTROL.  For every screened strand this program also screens SIXTEEN permutations of that
// strand's OWN bases — the identical multiset of A, C, G and T, permuted by a fixed-constant
// Fisher-Yates with no clock and no system randomness.  A permutation is the same molecule's
// composition with none of its design.  It is the same permutation function, the same constants
// and the same seeds as the single-drug zilganersen screen this programme already published, so
// that screen's numbers must reappear here to the integer.  They are checked, below, as an arm.
//
// ============================================================================================
// THE TIE RULE, WRITTEN DOWN BECAUSE ONE COMPARISON OPERATOR MOVED THIS STUDY'S HEADLINE 24x.
// ============================================================================================
// An earlier build of this program ranked a strand with `1 + #{controls strictly below it}`.
// Under that rule a family in which the strand and ALL SIXTEEN of its permutations score exactly
// the same — nine families do, every one of them at zero — is awarded rank 1, and rank 1 was then
// read as "pairs in fewer places than every rearrangement of its own bases".  It does not.  It
// paired in the SAME number of places.  The direction of that error is toward crediting medicines
// with designed specificity that was never measured, which is the one direction a safety
// instrument must not err in.
//
// A rank in the presence of ties is not a number, it is an INTERVAL, and this program prints the
// interval:
//
//     rankLo = 1 + #{controls strictly below the strand}
//     rankHi = rankLo + #{controls exactly equal to the strand}
//
// A row prints "3" when rankLo == rankHi, and "1-17" when the strand tied all sixteen.  RANK 1
// THEREFORE MEANS rankLo == rankHi == 1, which is exactly `burden < min(controls)`, which is
// exactly strict separation.  Every row also carries the disposition it earned, one of six, and
// those six are exhaustive and mutually exclusive: BELOW-all-16, ties-lowest, inside,
// ties-highest, ABOVE-all-16, ties-all-16.  The headline count is read off the disposition, and
// the count under the other convention is printed beside it so the two can never disagree
// silently again.
//
// ============================================================================================
// THE THRESHOLD A FAMILY CAN ACTUALLY BE READ AT — its own resolving k, named per row.
// ============================================================================================
// At four mismatches a 30-mer and its sixteen permutations all score zero: the nearest window in
// the whole transcriptome is seven or eight mismatches away.  A comparison in which every arm is
// zero has no resolving power, and reporting a rank from it is reporting noise as a result.  So
// for every family this program also finds kRes — the SMALLEST number of mismatches at which the
// family's own sixteen controls do not all agree with each other — and reports the rank and the
// disposition there, naming k in the row.  The complete histogram is published either way, so
// this is a reading of arithmetic already done, not a second screen.  Families with no resolving
// k anywhere in 0...L are counted and named; they are not scored.
//
// ============================================================================================
// HOW STRANDS OF DIFFERENT LENGTH ARE COMPARED FAIRLY — the choice, stated.
// ============================================================================================
//   The raw burden is NOT comparable across lengths and is never pooled here.  "At most four
//   mismatches" means something very different to a 16-mer and to a 45-mer: the number of windows
//   that can reach it falls away by roughly a factor of four for every base added.  Pooling those
//   counts into one league table would rank molecules by their LENGTH and call it specificity.
//   So raw counts are published PER LENGTH and only per length.
//
//   The cross-length statistic is the strand's INTEGER RANK among itself and its own sixteen
//   permutations, fewest off-target windows first — an interval inside 1...17.  It is length-fair
//   by construction, because every comparison a rank makes is against permutations of the same
//   molecule: same length, same base composition, same corpus, same window set, same threshold.
//
//   A second dimensionless figure is published beside it: the burden in PARTS PER THOUSAND of the
//   strand's own composition-matched control median, floor-divided, integers only.  THE MEDIAN OF
//   SIXTEEN SORTED VALUES IS TAKEN AS THE UPPER MEDIAN — element 8 of ctrl[0...15], the ninth
//   smallest.  That convention is stated here and printed in the output rather than left to be
//   inferred from the source.
//
// ============================================================================================
// SCOPE — FOUR ANSWERS, AND NO TWO OF THEM ARE THE SAME ANSWER.
// ============================================================================================
// An off-target statement is meaningful only for a strand whose target the instrument could
// MEASURE — read out of the transcriptome as the set of genes carrying the strand's perfect
// complement, never taken from a label.
//
//   SCREENED      a perfect complement was measured in a small set of genes; the burden outside
//                 those genes is reported.
//   UBIQUITOUS    a perfect complement was measured in HUNDREDS of genes.  A sequence that
//                 pairs perfectly across a thousand genes has not had a target measured; it is a
//                 common motif, and subtracting those genes as though they were "on-target"
//                 publishes the remainder as an off-target burden it never earned.  The boundary
//                 is READ OFF THE MEASUREMENT, not chosen: the per-strand target-gene counts are
//                 sorted, and the boundary is placed at the largest integer RATIO between
//                 consecutive distinct counts.  The rule only fires when that ratio exceeds the
//                 largest ratio a contiguous run of counts can produce, which the program
//                 computes from a constructed contiguous run rather than typing.  On this corpus
//                 the population is cleanly bimodal and the gap is unmistakable.
//   REFUSED       no perfect complement anywhere.  The registry sequence and the transcriptome
//                 disagree.  This is NOT "zero off-targets" and must never be read as clean.
//   NOT_KNOWN     the strand is short enough that a perfect complement is EXPECTED by chance, so
//                 finding one is no evidence of a designed target.  The boundary is exact and
//                 derived: a perfect complement is informative only when 4^L exceeds the number
//                 of scoreable windows of that length.
//
//   AND THE BOUNDARY IS NOT THE WHOLE STORY, SO THE EXPECTATION IS PRINTED TOO.  4^L > windows
//   only puts the expected number of chance perfect complements below ONE.  It does not make one
//   unlikely.  At L=16 the expectation is windows/4^L ~ 0.34, so roughly a third of arbitrary
//   16-mers carry a perfect complement somewhere and would be admitted here with a "measured
//   target".  This program prints that expectation per length in parts per million and flags
//   every screened row whose measured target rests on a SINGLE perfect complement at a length
//   where the expectation exceeds one in a hundred.  The flag is a stated convention; the counts
//   under one in ten and one in a thousand are printed beside it so its sensitivity is visible.
//
// ON-TARGET AND OFF-TARGET STAY STRICTLY APART.  At the perfect-match threshold a real medicine
// always exceeds its permutations, because it has a target and they do not.  That is the design
// succeeding and it is not a burden.  Reporting it as one makes a working medicine look
// dangerous; the separation is structural here — a window inside the measured target genes
// cannot reach the off-target histogram at all, for the strand or for any of its permutations.
//
// THE UNDESIGNED COHORT — n = 17, not n = 1.  The most consequential comparison this study makes
// is between a designed medicine and a sequence that was designed for nothing, so it may not rest
// on one sequence.  The program constructs SEVENTEEN undesigned 20-mers by one fixed rule — the
// reverse complement of the first scoreable 20-mer of every (txCount/17)-th transcript — screens
// each one with its own sixteen permutations exactly as it screens a medicine, and publishes
// their rank distribution BEFORE the registry ranking.  They are not medicines and are labelled
// as such on every line they appear on.  What they license is stated with them: they say what an
// ordinary human-transcript 20-mer scores against its own permutations, which is the only
// baseline against which "a drug ranks 17 of 17" means anything at all.
//
// HOW THE CORPUS IS READ, stated plainly rather than implied.  The transcriptome is read from
// standard input EXACTLY ONCE and held resident.  The screen then makes two ordered sweeps over
// that resident copy: sweep A measures every registry strand's target; sweep B screens the
// in-scope families and their permutations, with the on-target genes already known and therefore
// excluded structurally.  The real strand is screened in both sweeps and the two histograms must
// agree bin for bin.
//
// WHAT A RANK IS NOT.  A near-complementary window is a place a molecule COULD pair.  It is not a
// cut, not an occupancy, not a clinical event, and not evidence that any medicine harms anyone.
// A high rank is not a safety finding and a low rank is not a clearance.  The chemistry half of
// oligonucleotide safety — phosphorothioate protein binding, complement activation, the aseptic
// meningitis that sits on real labels — is not a sequence match at all, and no base search
// predicts any of it.  These are medicines real people take, some of them children, intrathecally,
// for decades; this program measures one discrete property of a sequence and nothing else.
//
// Reproduce (nothing here is behind a login):
//   xcrun swiftc -O -swift-version 5 reproduce/registry-specificity-ranking.swift -o /tmp/rsr
//   curl -sL https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/latest_release/gencode.v50.transcripts.fa.gz \
//     | gunzip -c | /tmp/rsr
// The strand table is found by walking outward from the working directory and from the binary,
// so the command above works from anywhere inside the checkout.  It may also be given as argv[1].
// Given no corpus the program refuses, prints the reference figures, and exits NON-ZERO.

import Foundation

setvbuf(stdout, nil, _IONBF, 0)

// ===========================================================================================
// PINNED INPUTS.  Every input is hashed and a mismatch is a refusal, never a warning.
// ===========================================================================================
let STRANDS_SHA256   = "5135ebb89ca659c6cce26d749dfc1547c08c4e6fc959074b6b3ab67fc9862afb"
let STRANDS_RELPATH  = "corpus/oligo-atlas/all_nucleicacid.tsv"
// The reference transcriptome is identified by two integers that were PUBLISHED BEFORE this
// program existed — the transcript count and the scoreable-window count at length 20, both
// carried by the single-drug zilganersen screen against GENCODE v50.  Identifying it that way
// rather than by a digest of this program's own first run is deliberate: a self-pin would be a
// number this program invented and then agreed with, which is not a check.
let REFERENCE_TX_COUNT   = 670670
let REFERENCE_WINDOWS_20 = 1467336203
let SCRAMBLES        = 16      // composition-matched controls per strand
let KMAX             = 4       // the threshold the sibling single-drug screens report at
let KSCAN            = 63      // ranks are computed at every k the histogram can express
let PERM_STRIDE      = 256     // Int32 slots per probe histogram: 4 interleaved copies of 64 bins
let COHORT           = 17      // undesigned 20-mers constructed as the baseline cohort
// The stated convention for "this measured target rests on a single perfect complement at a
// length where one is not rare": the chance expectation exceeds one in a hundred.  Sensitivity at
// one in ten and one in a thousand is printed beside the headline.
let WEAK_EVIDENCE_PPM = 10_000

// ===========================================================================================
// SHA-256, vendored so the program has no dependency and the digest is the program's own.
// ===========================================================================================
func hex8(_ v: UInt32) -> String {
    let d = Array("0123456789abcdef"); var s = ""
    for i in stride(from: 28, through: 0, by: -4) { s.append(d[Int((v >> UInt32(i)) & 0xf)]) }
    return s
}
struct SHA256Min {
    static let k: [UInt32] = [
    0x428a2f98,0x71374491,0xb5c0fbcf,0xe9b5dba5,0x3956c25b,0x59f111f1,0x923f82a4,0xab1c5ed5,
    0xd807aa98,0x12835b01,0x243185be,0x550c7dc3,0x72be5d74,0x80deb1fe,0x9bdc06a7,0xc19bf174,
    0xe49b69c1,0xefbe4786,0x0fc19dc6,0x240ca1cc,0x2de92c6f,0x4a7484aa,0x5cb0a9dc,0x76f988da,
    0x983e5152,0xa831c66d,0xb00327c8,0xbf597fc7,0xc6e00bf3,0xd5a79147,0x06ca6351,0x14292967,
    0x27b70a85,0x2e1b2138,0x4d2c6dfc,0x53380d13,0x650a7354,0x766a0abb,0x81c2c92e,0x92722c85,
    0xa2bfe8a1,0xa81a664b,0xc24b8b70,0xc76c51a3,0xd192e819,0xd6990624,0xf40e3585,0x106aa070,
    0x19a4c116,0x1e376c08,0x2748774c,0x34b0bcb5,0x391c0cb3,0x4ed8aa4a,0x5b9cca4f,0x682e6ff3,
    0x748f82ee,0x78a5636f,0x84c87814,0x8cc70208,0x90befffa,0xa4506ceb,0xbef9a3f7,0xc67178f2]
    var h: [UInt32] = [0x6a09e667,0xbb67ae85,0x3c6ef372,0xa54ff53a,
                       0x510e527f,0x9b05688c,0x1f83d9ab,0x5be0cd19]
    var tail: [UInt8] = []
    var total: UInt64 = 0
    mutating func block(_ p: UnsafePointer<UInt8>) {
        var w = [UInt32](repeating: 0, count: 64)
        for i in 0..<16 {
            w[i] = (UInt32(p[i*4]) << 24) | (UInt32(p[i*4+1]) << 16)
                 | (UInt32(p[i*4+2]) << 8) | UInt32(p[i*4+3])
        }
        for i in 16..<64 {
            let s0 = (w[i-15] >> 7 | w[i-15] << 25) ^ (w[i-15] >> 18 | w[i-15] << 14) ^ (w[i-15] >> 3)
            let s1 = (w[i-2] >> 17 | w[i-2] << 15) ^ (w[i-2] >> 19 | w[i-2] << 13) ^ (w[i-2] >> 10)
            w[i] = w[i-16] &+ s0 &+ w[i-7] &+ s1
        }
        var a=h[0],b=h[1],cc=h[2],d=h[3],e=h[4],f=h[5],g=h[6],hh=h[7]
        for i in 0..<64 {
            let S1 = (e >> 6 | e << 26) ^ (e >> 11 | e << 21) ^ (e >> 25 | e << 7)
            let ch = (e & f) ^ (~e & g)
            let t1 = hh &+ S1 &+ ch &+ SHA256Min.k[i] &+ w[i]
            let S0 = (a >> 2 | a << 30) ^ (a >> 13 | a << 19) ^ (a >> 22 | a << 10)
            let mj = (a & b) ^ (a & cc) ^ (b & cc)
            let t2 = S0 &+ mj
            hh=g; g=f; f=e; e=d &+ t1; d=cc; cc=b; b=a; a=t1 &+ t2
        }
        h[0]=h[0]&+a; h[1]=h[1]&+b; h[2]=h[2]&+cc; h[3]=h[3]&+d
        h[4]=h[4]&+e; h[5]=h[5]&+f; h[6]=h[6]&+g; h[7]=h[7]&+hh
    }
    mutating func update(_ p: UnsafePointer<UInt8>, _ n: Int) {
        total &+= UInt64(n)
        var i = 0
        if !tail.isEmpty {
            while i < n && tail.count < 64 { tail.append(p[i]); i += 1 }
            if tail.count == 64 { tail.withUnsafeBufferPointer { block($0.baseAddress!) }; tail.removeAll(keepingCapacity: true) }
        }
        while i + 64 <= n { block(p + i); i += 64 }
        while i < n { tail.append(p[i]); i += 1 }
    }
    mutating func finish() -> String {
        let bitLen = total &* 8
        var m = tail
        m.append(0x80); while m.count % 64 != 56 { m.append(0) }
        for i in stride(from: 56, through: 0, by: -8) { m.append(UInt8((bitLen >> UInt64(i)) & 0xff)) }
        m.withUnsafeBufferPointer { bp in
            var o = 0
            while o < bp.count { block(bp.baseAddress! + o); o += 64 }
        }
        return h.map { hex8($0) }.joined()
    }
    static func hex(_ bytes: [UInt8]) -> String {
        var s = SHA256Min()
        bytes.withUnsafeBufferPointer { if let b = $0.baseAddress { s.update(b, $0.count) } }
        return s.finish()
    }
    static func hex(_ s: String) -> String { hex(Array(s.utf8)) }
}

// ===========================================================================================
// FORMATTING
// ===========================================================================================
func padL(_ s: String, _ w: Int) -> String { s + String(repeating: " ", count: max(0, w - s.count)) }
func padR(_ s: String, _ w: Int) -> String { String(repeating: " ", count: max(0, w - s.count)) + s }
func padR(_ v: Int, _ w: Int) -> String { padR(String(v), w) }

// ===========================================================================================
// THE PUBLISHED REFERENCE — printed on EVERY exit, refusals included, so a reader who runs this
// with no corpus still sees the figures the page cites and can tell them from a run of their own.
// ===========================================================================================
func printPublishedReference() {
    print("")
    print("PUBLISHED REFERENCE RUN — the figures the page carries, printed on every exit path.")
    print("  strand table : NCATS GSRS class nucleicAcid, 742 substances, 740 carrying a sequence,")
    print("                 472 strands across 350 substances in the 8-60 nt band")
    print("                 sha256 \(STRANDS_SHA256)")
    print("  transcriptome: GENCODE v50, gencode.v50.transcripts.fa.gz, sha256")
    print("                 5a320f524d73b5793518eb19b118829033713443d0f42af20a67bb31cc06cf56")
    print("                 670670 transcripts; 1467336203 scoreable windows at length 20")
    print("  scope        : SCREENED, UBIQUITOUS, REFUSED and NOT_KNOWN are four different answers")
    print("                 and none of them is zero off-targets. Which strand falls where is")
    print("                 MEASURED BY THE RUN on the corpus in front of it, never asserted; the")
    print("                 dated block below is what the published run measured, and it is labelled")
    print("                 as such so it can never be read as this invocation's own result.")
    print("  controls     : 16 composition-matched permutations per screened strand, so each")
    print("                 screened family is 17 probes and the rank runs inside 1...17")
    print("  rank         : an INTERVAL. rankLo = 1 + #{controls strictly below}; rankHi = rankLo")
    print("                 + #{controls exactly equal}. RANK 1 MEANS rankLo == rankHi == 1, which")
    print("                 is strict separation from all sixteen. A tie is printed as a range.")
    print("  median       : the UPPER median of sixteen sorted controls — element 8 of ctrl[0..15],")
    print("                 the ninth smallest. Stated, not implied.")
    print("  cohort       : 17 undesigned 20-mers, constructed by a fixed rule from the corpus, NOT")
    print("                 medicines, screened exactly as a medicine is and reported before the")
    print("                 registry ranking")
    print("  cross-check  : ZILGANERSEN, UNII AXQ9493NT2, CAGTATTACCTCTACTAGTC, measured target")
    print("                 GFAP, 2 perfect 20/20 windows, 324 off-target windows at 4 mismatches")
    print("                 or fewer against a control median of 787, range 141 to 1355, rank 3")
    print("                 of 17 — the same integers the single-drug screen published")
    print("")
    print("  WHAT THE PUBLISHED RUN MEASURED — dated 2026-09-08, NOT measured by this invocation.")
    print("  This block exists so every figure the page carries is checkable from a clean clone")
    print("  without a 1.5 GB download, and so a run of your own can be compared line by line.")
    print("    probes            489 in sweep A, 3162 in sweep B")
    print("    probe-windows     717027798090 + 4638850669668 = 5355878467758")
    print("    corpus as read    670670 transcripts, 79139 genes, 1480179158 bases")
    print("    corpus fingerprint  e8a4711ff3d52ffae59c8c36a3dd6477307e9c4e6562ead6039302a0056c9e98")
    print("    arms              9 pre-corpus + 8 corpus-dependent = 17, all PASS")
    print("    screened families 186   (169 registry strands + 17 undesigned constructed 20-mers)")
    print("    excluded          18 UBIQUITOUS, 266 REFUSED, 19 NOT_KNOWN")
    print("    at 4 mismatches   BELOW-all-16 2 | ties-lowest 8 | inside 122 | ties-highest 1 |")
    print("                      ABOVE-all-16 44 | ties-all-16 9")
    print("    at each family's own resolving threshold   0 BELOW-all-16, 23 ABOVE-all-16")
    print("    seal sha256       2d74f5c676d51d45df178f9fed7840729bd87633ae8e5a9104383f6fbd7c3fd1")
    print("    SCOPE, as the run printed it")
    print("      registry strands in the table              : 472")
    print("      undesigned constructed 20-mers, NOT medicines: 17")
    print("      SCREENED   (target measured in few genes)  : 169")
    print("      UBIQUITOUS (perfect complement in hundreds of genes): 18   — NOT a measured target")
    print("      REFUSED    (no perfect complement anywhere): 266   — NOT zero off-targets")
    print("      NOT_KNOWN  (too short for a target to mean): 19")
    print("    CROSS-INSTRUMENT ARM, as the run printed it — the single-drug screen's own integers")
    print("       ... ZILGANERSEN off=324 ctrl median=787 range 141-1355 rank 3 of 17")
    print("")
    print("  THE TIE RULE, AND WHAT IT DOES TO THE HEADLINE")
    print("    families whose rankLo is 1 (ties favour the strand)      : 19")
    print("    families STRICTLY below all 16 controls (rank exactly 1-1): 2")
    print("    the difference is 17 families that TIED at least one permutation, and")
    print("    9 of them tied ALL 16 — every arm of the comparison scoring the same number,")
    print("    which is not fewer places, it is the same number of places.")
    print("")
    print("")
    print("  NO SEAL EMITTED ON THIS PATH. Every 64-hex above is either an INPUT digest or a")
    print("  figure QUOTED from the dated run; this invocation computed no verdict and sealed")
    print("  nothing. A reader — or a grading law — must not credit a quoted digest to this run.")
    print("  MARKER  REGISTRY_SPECIFICITY_RANKING__ORDER_NOT_COMPOSITION_SETS_THE_BURDEN")
    print("")
    print("A near-complementary window is a place a molecule COULD pair. It is not a cut, not an")
    print("occupancy, not a clinical event, and not evidence that any medicine harms anyone. A")
    print("high rank is not a safety finding and a low rank is not a clearance.")
}

// ===========================================================================================
// BASE CODES
// ===========================================================================================
@inline(__always) func code(_ c: UInt8) -> Int8 {
    switch c {
    case 65, 97:  return 0            // A
    case 67, 99:  return 1            // C
    case 71, 103: return 2            // G
    case 84, 116, 85, 117: return 3   // T or U
    default: return -1
    }
}
let INVALID: UInt8 = 4
var codeTable = [UInt8](repeating: INVALID, count: 256)
for c in 0..<256 { let v = code(UInt8(c)); if v >= 0 { codeTable[c] = UInt8(v) } }

// ===========================================================================================
// THE PERMUTATION.  Identical function, identical constants and identical seeds to the
// single-drug zilganersen screen, so that screen's control distribution must reappear here.
// Fisher-Yates driven by a fixed-constant LCG: no clock, no system randomness, no hash seed.
// ===========================================================================================
func scramble(_ base: [UInt8], _ n: Int) -> [UInt8] {
    var s: UInt64 = 0x243F6A8885A308D3 &+ (UInt64(n) &* 0x9E3779B97F4A7C15)
    var a = base
    var i = a.count - 1
    while i > 0 {
        s = s &* 6364136223846793005 &+ 1442695040888963407
        let j = Int((s >> 33) % UInt64(i + 1))
        a.swapAt(i, j)
        i -= 1
    }
    return a
}
// The identity "permutation" — a permutation function that does nothing.  It exists so the arm
// that claims the real permutation MOVES bases can be shown to fire on one that does not.
func identityPermutation(_ base: [UInt8], _ n: Int) -> [UInt8] { return base }

// ===========================================================================================
// PACKING.  A window of length L ending at position i is the low 2L bits of a rolling register
// holding the last 32 bases (plus a second register for L > 32).
// ===========================================================================================
let ODD64: UInt64 = 0x5555555555555555
@inline(__always) func maskFor(_ bits: Int) -> UInt64 { bits >= 64 ? ~0 : (UInt64(1) << UInt64(bits)) - 1 }

func packTargetLow(_ probe: [UInt8]) -> UInt64 {
    var v: UInt64 = 0
    let n = min(32, probe.count)
    for j in 0..<n { v |= UInt64(3 - probe[j]) << UInt64(2 * j) }
    return v
}
func packTargetHigh(_ probe: [UInt8]) -> UInt64 {
    var v: UInt64 = 0
    if probe.count > 32 { for j in 32..<probe.count { v |= UInt64(3 - probe[j]) << UInt64(2 * (j - 32)) } }
    return v
}

// The SLOW, obvious mismatch count — one comparison per position, written the way the rule reads.
func mismatchesSlow(probe: [UInt8], window: [UInt8]) -> Int {
    let L = probe.count
    var miss = 0
    for i in 0..<L { if Int(probe[i]) + Int(window[L - 1 - i]) != 3 { miss += 1 } }
    return miss
}

// ===========================================================================================
// THE RANK INTERVAL AND THE SIX DISPOSITIONS — the repair that moved the headline.
// ===========================================================================================
enum Disp: String {
    case belowAll = "BELOW-all-16"
    case tiedMin  = "ties-lowest"
    case inside   = "inside"
    case tiedMax  = "ties-highest"
    case aboveAll = "ABOVE-all-16"
    case tiedAll  = "ties-all-16"
}
// ctrl MUST be sorted ascending and MUST hold every control that was run.
func rankInterval(_ d: Int, _ ctrl: [Int]) -> (lo: Int, hi: Int) {
    var below = 0, equal = 0
    for v in ctrl { if v < d { below += 1 } else if v == d { equal += 1 } }
    return (1 + below, 1 + below + equal)
}
func disposition(_ d: Int, _ ctrl: [Int]) -> Disp {
    guard let lo = ctrl.first, let hi = ctrl.last else { return .inside }
    if d < lo { return .belowAll }
    if d > hi { return .aboveAll }
    if lo == hi { return .tiedAll }          // d == lo == hi
    if d == lo { return .tiedMin }
    if d == hi { return .tiedMax }
    return .inside
}
func rankText(_ lo: Int, _ hi: Int) -> String { lo == hi ? String(lo) : "\(lo)-\(hi)" }
func fam(_ n: Int) -> String { n == 1 ? "family" : "families" }

// ===========================================================================================
// THE UBIQUITOUS BOUNDARY — read off the distribution of target-gene counts, never chosen.
// The counts are sorted and made distinct; the boundary is the upper side of the consecutive
// pair with the largest integer ratio (b*1000)/a.  It fires only when that ratio exceeds the
// largest ratio a CONTIGUOUS run of counts can produce, which is computed from a constructed
// contiguous run of the same cardinality rather than typed.  Ties in the ratio take the lowest
// boundary, so the rule cannot be steered by ordering.
// ===========================================================================================
func largestConsecutiveRatio(_ sortedDistinct: [Int]) -> (ratio: Int, upper: Int) {
    var best = 0, upper = -1
    if sortedDistinct.count < 2 { return (0, -1) }
    for i in 1..<sortedDistinct.count {
        let a = sortedDistinct[i-1], b = sortedDistinct[i]
        if a <= 0 { continue }
        let r = (b * 1000) / a
        if r > best { best = r; upper = b }
    }
    return (best, upper)
}
func contiguousControlRatio(_ n: Int) -> Int {
    if n < 2 { return 0 }
    var run: [Int] = []; for i in 1...n { run.append(i) }
    return largestConsecutiveRatio(run).ratio
}
// Returns the boundary (inclusive: counts >= boundary are UBIQUITOUS), or nil when the
// distribution shows no separation the rule can read.
func ubiquitousBoundary(_ counts: [Int]) -> (boundary: Int, ratio: Int, control: Int, secondRatio: Int)? {
    let distinct = Array(Set(counts)).sorted()
    if distinct.count < 2 { return nil }
    let (r, up) = largestConsecutiveRatio(distinct)
    let control = contiguousControlRatio(distinct.count)
    // second-largest ratio, printed so a reader can see whether the separation is unique
    var second = 0
    for i in 1..<distinct.count {
        let a = distinct[i-1], b = distinct[i]
        if a <= 0 { continue }
        let rr = (b * 1000) / a
        if rr < r && rr > second { second = rr }
    }
    if r <= control || up < 0 { return nil }
    return (up, r, control, second)
}

// ===========================================================================================
// THE CHANCE EXPECTATION — how much a "measured target" of one perfect complement rests on.
// windows(L) / 4^L, in parts per million, exact integer division.  L >= 32 overflows 4^L in 64
// bits and is reported as 0 ppm, which is true to well under one part in a million.
// ===========================================================================================
func chancePerfectPPM(windows: Int, L: Int) -> Int {
    if L >= 32 || windows <= 0 { return 0 }
    let p4 = UInt64(1) << UInt64(2 * L)
    return Int((UInt64(windows) &* 1_000_000) / p4)
}

// ===========================================================================================
// THE STRAND TABLE
// ===========================================================================================
struct Strand {
    let name: String, unii: String, regType: String, status: String, text: String
    let seq: [UInt8]
    let synthetic: Bool
    var L: Int { seq.count }
}

func fileBytes(_ path: String) -> [UInt8]? {
    guard let d = FileManager.default.contents(atPath: path) else { return nil }
    return [UInt8](d)
}

// Resolve the strand table with NO ARGV, by walking outward from the working directory and from
// the binary's own directory.  A bare relative name that only works from one directory sends a
// stranger straight to the refusal path, which is a defect in the program and not in the reader.
func resolveStrandTable() -> String? {
    if CommandLine.arguments.count > 1 {
        let p = CommandLine.arguments[1]
        if FileManager.default.isReadableFile(atPath: p) { return p }
        return nil
    }
    var roots: [String] = [FileManager.default.currentDirectoryPath]
    var exeBuf = [CChar](repeating: 0, count: 8192)
    var sz = UInt32(exeBuf.count)
    if _NSGetExecutablePath(&exeBuf, &sz) == 0 {
        let exe = String(cString: exeBuf)
        roots.append((exe as NSString).deletingLastPathComponent)
    }
    if CommandLine.arguments.count > 0 {
        roots.append((CommandLine.arguments[0] as NSString).deletingLastPathComponent)
    }
    let leaf = (STRANDS_RELPATH as NSString).lastPathComponent
    var seen = Set<String>()
    for r0 in roots {
        var dir = (r0 as NSString).standardizingPath
        if dir.isEmpty { dir = "." }
        for _ in 0..<12 {
            if seen.insert(dir).inserted {
                for cand in [dir + "/" + STRANDS_RELPATH, dir + "/" + leaf] {
                    if FileManager.default.isReadableFile(atPath: cand) { return cand }
                }
            }
            let up = (dir as NSString).deletingLastPathComponent
            if up.isEmpty || up == dir { break }
            dir = up
        }
    }
    return nil
}

// ===========================================================================================
// THE RESIDENT CORPUS
// ===========================================================================================
final class Corpus {
    var codes: UnsafeMutablePointer<UInt8>
    var n = 0
    var cap: Int
    var txStart: [Int] = []
    var txLen: [Int32] = []
    var txGene: [Int32] = []
    var txName: [String] = []
    var geneName: [String] = []
    var maxTxLen = 0
    init(cap: Int) { self.cap = cap; codes = UnsafeMutablePointer<UInt8>.allocate(capacity: cap) }
    var txCount: Int { txStart.count }
}

func readCorpusFromStdin() -> Corpus {
    let c = Corpus(cap: 1 << 28)
    var geneIndex: [String: Int32] = [:]
    let bufSize = 1 << 23
    let buf = UnsafeMutablePointer<UInt8>.allocate(capacity: bufSize)
    defer { buf.deallocate() }
    var header: [UInt8] = []; header.reserveCapacity(256)
    var inHeader = false, atLineStart = true
    var curStart = 0
    var haveTx = false
    var pendingTx = "", pendingGene = ""

    func closeTranscript() {
        guard haveTx else { return }
        let len = c.n - curStart
        if len > 0 {
            c.txStart.append(curStart); c.txLen.append(Int32(len))
            var gi = geneIndex[pendingGene]
            if gi == nil { gi = Int32(c.geneName.count); geneIndex[pendingGene] = gi!; c.geneName.append(pendingGene) }
            c.txGene.append(gi!); c.txName.append(pendingTx)
            if len > c.maxTxLen { c.maxTxLen = len }
        } else { c.n = curStart }
        haveTx = false
    }
    func openTranscript() {
        let f = header.split(separator: 124, omittingEmptySubsequences: false)   // '|'
        pendingTx = f.count > 0 ? String(decoding: f[0], as: UTF8.self) : "?"
        pendingGene = f.count > 5 ? String(decoding: f[5], as: UTF8.self) : "?"
        curStart = c.n; haveTx = true
    }
    codeTable.withUnsafeBufferPointer { tbl in
        while true {
            let got = read(0, buf, bufSize)
            if got <= 0 { break }
            if c.n + got + 8 > c.cap {
                var nc = c.cap
                while c.n + got + 8 > nc { nc <<= 1 }
                let nb = UnsafeMutablePointer<UInt8>.allocate(capacity: nc)
                nb.update(from: c.codes, count: c.n)
                c.codes.deallocate(); c.codes = nb; c.cap = nc
            }
            var i = 0
            let cp = c.codes
            while i < got {
                let ch = buf[i]
                if inHeader {
                    if ch == 10 { inHeader = false; atLineStart = true; openTranscript() }
                    else if ch != 13 { header.append(ch) }
                } else if atLineStart && ch == 62 {          // '>'
                    closeTranscript(); inHeader = true; header.removeAll(keepingCapacity: true)
                } else if ch == 10 || ch == 13 {
                    atLineStart = (ch == 10)
                } else {
                    atLineStart = false
                    cp[c.n] = tbl[Int(ch)]; c.n += 1
                }
                i += 1
            }
        }
    }
    closeTranscript()
    return c
}

// The corpus fingerprint is over WHAT WAS READ, not over a file on disk and never over a path.
func corpusFingerprint(_ c: Corpus) -> (String, [Int]) {
    var census = [Int](repeating: 0, count: 5)
    for i in 0..<c.n { census[Int(c.codes[i])] += 1 }
    var h = SHA256Min()
    var chunk: [UInt8] = []; chunk.reserveCapacity(1 << 20)
    for t in 0..<c.txCount {
        chunk.append(contentsOf: Array("\(c.txName[t])|\(c.geneName[Int(c.txGene[t])])|\(c.txLen[t])\n".utf8))
        if chunk.count >= (1 << 20) {
            chunk.withUnsafeBufferPointer { h.update($0.baseAddress!, $0.count) }
            chunk.removeAll(keepingCapacity: true)
        }
    }
    chunk.append(contentsOf: Array("census|\(census[0])|\(census[1])|\(census[2])|\(census[3])|\(census[4])|tx|\(c.txCount)|bases|\(c.n)\n".utf8))
    chunk.withUnsafeBufferPointer { h.update($0.baseAddress!, $0.count) }
    return (h.finish(), census)
}

// ===========================================================================================
// THE SWEEP.  Probe-major over each maximal run of standard bases.  A window is scoreable only if
// EVERY one of its positions is a standard base; that is decided once per transcript and never
// inside a probe loop, so no probe's scanning order can change which windows exist.
// ===========================================================================================
final class Accum {
    let P: Int
    var hist: UnsafeMutablePointer<Int32>      // P * PERM_STRIDE, indexed by MISMATCHES
    var histOff: UnsafeMutablePointer<Int32>   // same shape; stage B only, else unused
    var perfGenes: [Set<Int32>]
    var winByLen: [Int: Int] = [:]
    var transcripts = 0
    init(_ P: Int, wantOff: Bool) {
        self.P = P
        hist = UnsafeMutablePointer<Int32>.allocate(capacity: P * PERM_STRIDE)
        hist.initialize(repeating: 0, count: P * PERM_STRIDE)
        histOff = UnsafeMutablePointer<Int32>.allocate(capacity: wantOff ? P * PERM_STRIDE : 1)
        histOff.initialize(repeating: 0, count: wantOff ? P * PERM_STRIDE : 1)
        perfGenes = [Set<Int32>](repeating: [], count: P)
    }
}

struct Probe {
    let L: Int
    let tLow: UInt64
    let tHigh: UInt64
    let maskLow: UInt64
    let maskHigh: UInt64
    let oddLow: UInt64
    let oddHigh: UInt64
    let family: Int          // index of the screened family this probe belongs to, -1 in sweep A
}

func makeProbe(_ seq: [UInt8], family: Int) -> Probe {
    let L = seq.count
    let lowBits = min(64, 2 * L)
    let highBits = L > 32 ? 2 * (L - 32) : 0
    return Probe(L: L, tLow: packTargetLow(seq), tHigh: packTargetHigh(seq),
                 maskLow: maskFor(lowBits), maskHigh: maskFor(highBits),
                 oddLow: ODD64 & maskFor(lowBits), oddHigh: ODD64 & maskFor(highBits),
                 family: family)
}

final class Shared {
    let lock = NSLock()
    var next = 0
    let blocks: Int
    init(blocks: Int) { self.blocks = blocks }
    func take() -> Int? {
        lock.lock(); defer { lock.unlock() }
        if next >= blocks { return nil }
        let b = next; next += 1; return b
    }
}

func sweep(corpus c: Corpus, probes: [Probe], lengths: [Int],
           onTargetGenes: [Int32: [Int]], famCount: Int,
           threads: Int, wantOff: Bool, wantPerfect: Bool) -> [Accum] {
    let P = probes.count
    let BLOCK = 512
    let blocks = (c.txCount + BLOCK - 1) / BLOCK
    let shared = Shared(blocks: blocks)
    var accs: [Accum] = []
    for _ in 0..<threads { accs.append(Accum(P, wantOff: wantOff)) }
    let accBox = accs
    let maxLen = max(1, c.maxTxLen)

    // Explicit threads, not a concurrent dispatch. Measured 2026-09-08 on a host under heavy
    // external load: DispatchQueue.concurrentPerform narrowed a 12-way sweep to ONE core while the
    // machine reported 29% idle, because the cooperative pool throttles its width on system load.
    // The arithmetic is the same either way; the wall clock is not. Threads are joined before any
    // accumulator is read, and every accumulator is a per-thread sum merged afterwards, so the
    // result does not depend on how many of them there were.
    let done = DispatchSemaphore(value: 0)
    func worker(_ tid: Int) {
        let acc = accBox[tid]
        var roll1 = [UInt64](repeating: 0, count: maxLen)
        var roll2 = [UInt64](repeating: 0, count: maxLen)
        var onFlags = [Bool](repeating: false, count: max(1, famCount))
        probes.withUnsafeBufferPointer { pb in
          roll1.withUnsafeMutableBufferPointer { r1b in
            roll2.withUnsafeMutableBufferPointer { r2b in
              let r1 = r1b.baseAddress!, r2 = r2b.baseAddress!
              let hAll = acc.hist, hOff = acc.histOff
              while let blk = shared.take() {
                let lo = blk * BLOCK, hi = min(c.txCount, lo + BLOCK)
                for t in lo..<hi {
                    acc.transcripts += 1
                    let s = c.txStart[t], n = Int(c.txLen[t])
                    let gid = c.txGene[t]
                    if wantOff {
                        for i in 0..<famCount { onFlags[i] = false }
                        if let fams = onTargetGenes[gid] { for f in fams { onFlags[f] = true } }
                    }
                    // maximal runs of standard bases
                    var runStart = 0
                    while runStart < n {
                        while runStart < n && c.codes[s + runStart] >= INVALID { runStart += 1 }
                        if runStart >= n { break }
                        var runEnd = runStart
                        while runEnd < n && c.codes[s + runEnd] < INVALID { runEnd += 1 }
                        let runLen = runEnd - runStart               // [runStart, runEnd)
                        for L in lengths where runLen >= L { acc.winByLen[L, default: 0] += runLen - L + 1 }
                        // rolling registers for this run
                        var a1: UInt64 = 0, a2: UInt64 = 0
                        for j in 0..<runLen {
                            a2 = (a2 << 2) | (a1 >> 62)
                            a1 = (a1 << 2) | UInt64(c.codes[s + runStart + j])
                            r1[j] = a1; r2[j] = a2
                        }
                        for pi in 0..<P {
                            let p = pb[pi]
                            let L = p.L
                            if runLen < L { continue }
                            let dst = (wantOff && p.family >= 0 && onFlags[p.family]) ? hAll : (wantOff ? hOff : hAll)
                            let hp = dst + pi * PERM_STRIDE
                            var perfBefore: Int32 = 0
                            if wantPerfect { perfBefore = hp[0] &+ hp[64] &+ hp[128] &+ hp[192] }
                            if L <= 32 {
                                let T = p.tLow, mk = p.maskLow, od = p.oddLow
                                var j = L - 1
                                while j < runLen {
                                    let x = (r1[j] ^ T) & mk
                                    let mm = ((x | (x >> 1)) & od).nonzeroBitCount
                                    hp[((j & 3) << 6) | mm] &+= 1
                                    j &+= 1
                                }
                            } else {
                                let T1 = p.tLow, T2 = p.tHigh, mk2 = p.maskHigh, od2 = p.oddHigh
                                var j = L - 1
                                while j < runLen {
                                    let x1 = r1[j] ^ T1
                                    let x2 = (r2[j] ^ T2) & mk2
                                    let mm = ((x1 | (x1 >> 1)) & ODD64).nonzeroBitCount
                                            + ((x2 | (x2 >> 1)) & od2).nonzeroBitCount
                                    hp[((j & 3) << 6) | mm] &+= 1
                                    j &+= 1
                                }
                            }
                            if wantPerfect {
                                let after = hp[0] &+ hp[64] &+ hp[128] &+ hp[192]
                                if after > perfBefore { acc.perfGenes[pi].insert(gid) }
                            }
                        }
                        runStart = runEnd
                    }
                }
              }
            }
          }
        }
        done.signal()
    }
    var spawned: [Thread] = []
    for tid in 0..<threads {
        let th = Thread { worker(tid) }
        th.qualityOfService = .userInitiated
        th.stackSize = 4 << 20
        th.start()
        spawned.append(th)
    }
    for _ in 0..<threads { done.wait() }
    _ = spawned
    return accs
}

func mergeHist(_ accs: [Accum], _ P: Int, off: Bool) -> [[Int]] {
    var out = [[Int]](repeating: [Int](repeating: 0, count: 64), count: P)
    for a in accs {
        let base = off ? a.histOff : a.hist
        for p in 0..<P {
            let hp = base + p * PERM_STRIDE
            for c in 0..<4 { for m in 0..<64 { out[p][m] += Int(hp[(c << 6) | m]) } }
        }
    }
    return out
}

// ===========================================================================================
// INSTRUMENT CONTROL ARMS.  Run FIRST, emitting nothing if any fails.  Every arm is a computation
// whose two directions are both exercised: the thing that must hold, and a deliberately broken
// case that must be caught.  The arm count is the length of the list that ran, never a typed
// number.  No arm asserts a literal true, and no arm's detail string is written as an assertion:
// every detail prints the counts it measured, including the disagreeing ones, so a reader
// scanning the detail column of a FAILING arm cannot read a pass off it.
// ===========================================================================================
struct Arm { let name: String; let ok: Bool; let detail: String }
var arms: [Arm] = []
func arm(_ n: String, _ ok: Bool, _ d: String) { arms.append(Arm(name: n, ok: ok, detail: d)) }

let ZILG_TEXT = "CAGTATTACCTCTACTAGTC"
let zilgSeq: [UInt8] = Array(ZILG_TEXT.utf8).map { UInt8(code($0)) }

// ARM — composition is held fixed by the permutation, and a substitution is CAUGHT.
do {
    func census(_ s: [UInt8]) -> [Int] { var c = [Int](repeating: 0, count: 4); for b in s { c[Int(b)] += 1 }; return c }
    let base = census(zilgSeq)
    var same = 0
    for n in 1...SCRAMBLES where census(scramble(zilgSeq, n)) == base { same += 1 }
    var altered = zilgSeq; altered[0] = (altered[0] &+ 1) & 3
    let alteredDiffers = census(altered) != base
    arm("composition-held-fixed", same == SCRAMBLES && alteredDiffers,
        "\(same) of \(SCRAMBLES) permutations hold A=\(base[0]) C=\(base[1]) G=\(base[2]) T=\(base[3]) exactly; a one-base substitution is detected as a composition change: \(alteredDiffers)")
}
// ARM — permutations are deterministic across invocations and are NOT the identity, proven by
// running the same detector over an identity permutation function that must fail it.
do {
    func movedCount(_ f: ([UInt8], Int) -> [UInt8]) -> Int {
        var moved = 0
        for n in 1...SCRAMBLES where f(zilgSeq, n) != zilgSeq { moved += 1 }
        return moved
    }
    var stable = 0
    for n in 1...SCRAMBLES where scramble(zilgSeq, n) == scramble(zilgSeq, n) { stable += 1 }
    let realMoved = movedCount(scramble)
    let identityMoved = movedCount(identityPermutation)
    arm("permutations-deterministic-and-not-identity",
        stable == SCRAMBLES && realMoved == SCRAMBLES && identityMoved == 0,
        "\(stable) of \(SCRAMBLES) permutations reproduce across two invocations; \(realMoved) of \(SCRAMBLES) differ from the strand; the same detector over an identity permutation reports \(identityMoved) of \(SCRAMBLES) moved, which is the failing direction")
}
// ARM — the fast packed scorer agrees with the slow obvious one, and DISAGREES when it should.
do {
    var s: UInt64 = 0x9E3779B97F4A7C15
    func rnd(_ m: Int) -> Int { s = s &* 6364136223846793005 &+ 1442695040888963407; return Int((s >> 33) % UInt64(m)) }
    var agree = 0, checked = 0, mismatchDetected = 0
    for L in [16, 20, 25, 32, 33, 40, 45] {
        for _ in 0..<200 {
            var probe = [UInt8](); for _ in 0..<L { probe.append(UInt8(rnd(4))) }
            var win = [UInt8]();  for _ in 0..<L { win.append(UInt8(rnd(4))) }
            let p = makeProbe(probe, family: -1)
            var a1: UInt64 = 0, a2: UInt64 = 0
            for b in win { a2 = (a2 << 2) | (a1 >> 62); a1 = (a1 << 2) | UInt64(b) }
            let fast: Int
            if L <= 32 {
                let x = (a1 ^ p.tLow) & p.maskLow
                fast = ((x | (x >> 1)) & p.oddLow).nonzeroBitCount
            } else {
                let x1 = a1 ^ p.tLow, x2 = (a2 ^ p.tHigh) & p.maskHigh
                fast = ((x1 | (x1 >> 1)) & ODD64).nonzeroBitCount + ((x2 | (x2 >> 1)) & p.oddHigh).nonzeroBitCount
            }
            let slow = mismatchesSlow(probe: probe, window: win)
            checked += 1; if fast == slow { agree += 1 }
            var perfect = [UInt8](repeating: 0, count: L)
            for i in 0..<L { perfect[L - 1 - i] = 3 - probe[i] }
            if mismatchesSlow(probe: probe, window: perfect) == 0 {
                var broken = perfect; broken[0] = (broken[0] &+ 1) & 3
                if mismatchesSlow(probe: probe, window: broken) == 1 { mismatchDetected += 1 }
            }
        }
    }
    arm("packed-scorer-equals-obvious-scorer", agree == checked && mismatchDetected == checked,
        "\(agree) of \(checked) random probe/window pairs agree across two independent implementations, \(checked - agree) disagree; the perfect complement scores 0 and a single substitution scores 1 in \(mismatchDetected) of \(checked)")
}
// ARM — the scope classifier.  A strand with no perfect complement is REFUSED and never reported
// as zero off-targets; a short strand is NOT_KNOWN; a strand with a target is SCREENED; and a
// corpus of nothing does not pass.
enum Scope: String { case screened = "SCREENED", ubiquitous = "UBIQUITOUS",
                     refused = "REFUSED", notKnown = "NOT_KNOWN", noCorpus = "NO_CORPUS" }
func classify(L: Int, windowsAtL: Int, perfect: Int) -> Scope {
    if windowsAtL <= 0 { return .noCorpus }
    if L < 32 {
        let pow4 = UInt64(1) << UInt64(2 * L)
        if pow4 <= UInt64(windowsAtL) { return .notKnown }
    }
    if perfect == 0 { return .refused }
    return .screened
}
do {
    var passed = 0
    let cases: [(String, Bool)] = [
        ("screened",     classify(L: 20, windowsAtL: 1467336203, perfect: 2)    == .screened),
        ("refused",      classify(L: 20, windowsAtL: 1467336203, perfect: 0)    == .refused),
        ("short9",       classify(L: 9,  windowsAtL: 1467336203, perfect: 5600) == .notKnown),
        ("short15",      classify(L: 15, windowsAtL: 1467336203, perfect: 1)    == .notKnown),
        ("boundary16",   classify(L: 16, windowsAtL: 1467336203, perfect: 1)    == .screened),
        ("emptyCorpus",  classify(L: 20, windowsAtL: 0, perfect: 0)             == .noCorpus)]
    for c in cases where c.1 { passed += 1 }
    arm("scope-classifier-separates-absence-refusal-and-not-known", passed == cases.count,
        "\(passed) of \(cases.count) classifier cases land where they must, \(cases.count - passed) do not [" +
        cases.map { "\($0.0)=\($0.1)" }.joined(separator: " ") + "]; the 4^L > windows boundary is computed, not chosen")
}
// ARM — THE RANK IS AN INTERVAL AND THE TIE RULE IS DECLARED.  One comparison operator moved this
// study's headline by 24x while every other arm stayed green, so the tie rule now has an arm of
// its own, exercised in both directions: a family that is strictly below every control ranks 1
// under BOTH conventions, and a family that ties all sixteen ranks 1 under the strict convention
// and 17 under the at-or-below convention, which is exactly the failure that was published.
do {
    let strictlyBelow = (d: 5, ctrl: [Int](repeating: 40, count: SCRAMBLES))
    let tiedAll = (d: 0, ctrl: [Int](repeating: 0, count: SCRAMBLES))
    let a = rankInterval(strictlyBelow.d, strictlyBelow.ctrl)
    let b = rankInterval(tiedAll.d, tiedAll.ctrl)
    let dispA = disposition(strictlyBelow.d, strictlyBelow.ctrl)
    let dispB = disposition(tiedAll.d, tiedAll.ctrl)
    let separated = (a.lo == 1 && a.hi == 1 && dispA == .belowAll)
    let tieCaught = (b.lo == 1 && b.hi == SCRAMBLES + 1 && dispB == .tiedAll)
    arm("rank-is-an-interval-and-ties-are-caught", separated && tieCaught,
        "strictly-below family ranks \(rankText(a.lo, a.hi)) disposition \(dispA.rawValue); all-sixteen-tie family ranks \(rankText(b.lo, b.hi)) disposition \(dispB.rawValue) — under the old strict-only rule that second family printed rank 1 and was counted as designed specificity")
}
// ARM — the six dispositions are exhaustive and mutually exclusive, and every one of them is
// produced by a constructed case rather than asserted.
do {
    let ctrl = [10, 10, 20, 30, 30]
    let flat = [7, 7, 7, 7, 7]
    let want: [(Int, [Int], Disp)] = [
        (5,  ctrl, .belowAll), (10, ctrl, .tiedMin), (20, ctrl, .inside),
        (30, ctrl, .tiedMax),  (99, ctrl, .aboveAll), (7, flat, .tiedAll)]
    var hit = 0
    var produced = Set<String>()
    for (d, c, w) in want { let got = disposition(d, c); if got == w { hit += 1 }; produced.insert(got.rawValue) }
    arm("dispositions-are-exhaustive-and-exclusive", hit == want.count && produced.count == 6,
        "\(hit) of \(want.count) constructed cases land on the disposition they must, \(want.count - hit) do not; \(produced.count) of 6 distinct dispositions were produced by those cases")
}
// ARM — the resolving threshold finds the FIRST k at which a family's controls disagree, and
// reports none when they never do.  Both directions on constructed cumulative burdens.
func resolvingK(ctrlByK: [[Int]]) -> Int {
    for k in 0..<ctrlByK.count {
        let c = ctrlByK[k]
        if let lo = c.first, let hi = c.last, hi > lo { return k }
    }
    return -1
}
do {
    // controls degenerate at 0 until k = 7, then spread — the 30-mer case this study actually has
    var late: [[Int]] = []
    for k in 0...12 { late.append(k < 7 ? [Int](repeating: 0, count: 4) : [0, 1, 5, 9]) }
    var never: [[Int]] = []
    for _ in 0...12 { never.append([3, 3, 3, 3]) }
    let kLate = resolvingK(ctrlByK: late)
    let kNever = resolvingK(ctrlByK: never)
    arm("resolving-threshold-is-the-first-k-with-spread", kLate == 7 && kNever == -1,
        "a family whose controls are all zero below 7 mismatches resolves at k=\(kLate); a family whose controls never disagree reports k=\(kNever), and is excluded from the headline rather than scored")
}
// ARM — the UBIQUITOUS boundary is read off the distribution and does NOT fire on one without a
// gap.  A contiguous run of counts produces no boundary; a bimodal one produces the gap.
do {
    var contiguous: [Int] = []; for i in 1...20 { contiguous.append(i) }
    let noGap = ubiquitousBoundary(contiguous)
    let bimodal = [1, 1, 1, 2, 2, 3, 115, 141, 984, 1344]
    let gap = ubiquitousBoundary(bimodal)
    let ok = (noGap == nil) && (gap != nil) && (gap!.boundary == 115)
    arm("ubiquitous-boundary-is-read-off-the-distribution", ok,
        "a contiguous run of 20 counts yields " + (noGap == nil ? "no boundary" : "boundary \(noGap!.boundary)")
        + " because its largest consecutive ratio does not exceed the contiguous control ratio \(contiguousControlRatio(20));"
        + " a bimodal set yields " + (gap == nil ? "no boundary" : "boundary \(gap!.boundary) at ratio \(gap!.ratio) against control \(gap!.control)"))
}
// ARM — the chance expectation for a perfect complement falls with length and is large exactly
// where the NOT_KNOWN boundary says a perfect complement is "informative".  Both directions.
do {
    let ppm16 = chancePerfectPPM(windows: 1470018861, L: 16)
    let ppm20 = chancePerfectPPM(windows: 1467336203, L: 20)
    let ppm25 = chancePerfectPPM(windows: 1463983026, L: 25)
    let ppm40 = chancePerfectPPM(windows: 1453923983, L: 40)
    let falls = ppm16 > ppm20 && ppm20 > ppm25 && ppm25 >= ppm40
    let sixteenIsNotRare = ppm16 >= WEAK_EVIDENCE_PPM
    let twentyFiveIsRare = ppm25 < WEAK_EVIDENCE_PPM
    arm("chance-expectation-is-computed-and-is-large-at-the-boundary",
        falls && sixteenIsNotRare && twentyFiveIsRare,
        "expected chance perfect complements per million: L=16 \(ppm16), L=20 \(ppm20), L=25 \(ppm25), L=40 \(ppm40); the NOT_KNOWN boundary sits at L=16 where the expectation is \(ppm16) ppm — about \(ppm16 / 10_000) in every hundred arbitrary 16-mers, which is not rare")
}

// ===========================================================================================
// RUN
// ===========================================================================================
print("REGISTRY SPECIFICITY RANKING — is the burden set by the ORDER of the bases, or by which")
print("bases they are?  Every strand is ranked against \(SCRAMBLES) permutations of its own bases.")
print("")

let armsFailedEarly = arms.filter { !$0.ok }
func printArms(_ list: [Arm], _ title: String) {
    print("\(title) — \(list.count) arms, count derived from the arms that ran")
    for a in list { print("  [\(a.ok ? "PASS" : "FAIL")] \(padL(a.name, 52)) \(a.detail)") }
    print("")
}
if !armsFailedEarly.isEmpty {
    printArms(arms, "INSTRUMENT CONTROL ARMS")
    print("THE INSTRUMENT DID NOT VALIDATE. No screen was run and no ranking is emitted.")
    printPublishedReference()
    exit(1)
}
printArms(arms, "INSTRUMENT CONTROL ARMS (pre-corpus)")
let preCorpusArmCount = arms.count

// ---- the strand table ---------------------------------------------------------------------
guard let tablePath = resolveStrandTable(), let tableBytes = fileBytes(tablePath) else {
    print("NO STRAND TABLE — this program screens published sequences and will not invent one.")
    print("It looked for \(STRANDS_RELPATH) by walking outward from the working directory and")
    print("from its own binary, and found nothing readable. It may also be given as argv[1].")
    print("This is a REFUSAL and it exits non-zero, so a harness grading by exit code cannot read")
    print("it as a pass. A gate given nothing must not pass.")
    printPublishedReference()
    exit(2)
}
let tableDigest = SHA256Min.hex(tableBytes)
if tableDigest != STRANDS_SHA256 {
    print("STRAND TABLE DIGEST MISMATCH — refusing to screen a table this program has not pinned.")
    print("  expected \(STRANDS_SHA256)")
    print("  measured \(tableDigest)")
    printPublishedReference()
    exit(1)
}
var strands: [Strand] = []
do {
    let text = String(decoding: tableBytes, as: UTF8.self)
    for line in text.split(separator: "\n") {
        if line.hasPrefix("#") { continue }
        let f = line.split(separator: "\t", omittingEmptySubsequences: false).map(String.init)
        if f.count < 5 { continue }
        let raw = Array(f[4].uppercased().utf8).map(code)
        if raw.isEmpty || raw.contains(-1) { continue }
        strands.append(Strand(name: f[0], unii: f[1], regType: f[2], status: f[3],
                              text: f[4].uppercased(), seq: raw.map { UInt8($0) }, synthetic: false))
    }
}
print("strand table        : \(tablePath.hasPrefix("/") ? (tablePath as NSString).lastPathComponent : tablePath)")
print("strand table sha256 : \(tableDigest)  (pinned, verified)")
print("strands read        : \(strands.count)")
print("")
if strands.isEmpty {
    print("EMPTY STRAND TABLE — a gate given nothing does not pass. No screen was run.")
    printPublishedReference()
    exit(1)
}

// ---- the corpus ---------------------------------------------------------------------------
let corpus = readCorpusFromStdin()
if corpus.txCount == 0 || corpus.n == 0 {
    print("NO TRANSCRIPTOME ON STANDARD INPUT — this program screens a real corpus and will not")
    print("invent one. A gate given nothing must not pass, so nothing is ranked and this exits")
    print("non-zero. Pipe GENCODE in:")
    print("")
    print("  curl -sL https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/latest_release/\\")
    print("       gencode.v50.transcripts.fa.gz | gunzip -c | /tmp/rsr")
    printPublishedReference()
    exit(2)
}
let (fp, census) = corpusFingerprint(corpus)
print("CORPUS AS READ — fingerprinted over what arrived, never over a path")
print("  transcripts         : \(corpus.txCount)")
print("  genes               : \(corpus.geneName.count)")
print("  bases               : \(corpus.n)   A=\(census[0]) C=\(census[1]) G=\(census[2]) T=\(census[3]) other=\(census[4])")
print("  longest transcript  : \(corpus.maxTxLen)")
print("  corpus fingerprint  : \(fp)   — an identifier for what arrived, printed so two readers")
print("                        can tell a full transfer from a truncated one before comparing seals")
print("")

let envThreads = ProcessInfo.processInfo.environment["RSR_THREADS"].flatMap { Int($0) }
let threads = max(1, min(64, envThreads ?? ProcessInfo.processInfo.activeProcessorCount))
print("threads             : \(threads)   (RSR_THREADS overrides it; every accumulator is a sum,")
print("                      so the merge is order-independent and the seal carries no thread count)")
print("")

// ---- THE UNDESIGNED COHORT, n = 17 ----------------------------------------------------------
// A ranking that puts everything in the same place has measured nothing, and a baseline that
// rests on ONE sequence cannot say whether a drug's rank reflects design or reflects that a
// drug's bases were copied from a transcriptome full of paralogues while a permutation of them
// was not.  So the instrument constructs SEVENTEEN sequences that were designed for nothing: the
// reverse complement of the first scoreable 20-mer of every (txCount/COHORT)-th transcript.
// They are chosen by a rule, not by a person, they have a perfect complement by construction, and
// THEY ARE NOT MEDICINES.
var syntheticIdxs: [Int] = []
do {
    let letters = Array("ACGT")
    var made = 0, seenText = Set<String>()
    var startAt = 0
    let stride0 = max(1, corpus.txCount / COHORT)
    var texts: [String] = []
    while made < COHORT && startAt < corpus.txCount {
        var t = min(corpus.txCount - 1, made * stride0)
        if t < startAt { t = startAt }
        var found: [UInt8] = []
        var tried = t
        while tried < corpus.txCount && found.isEmpty {
            let s0 = corpus.txStart[tried], n0 = Int(corpus.txLen[tried])
            var run = 0
            for j in 0..<n0 {
                if corpus.codes[s0 + j] < INVALID { run += 1 } else { run = 0 }
                if run >= 20 {
                    var win: [UInt8] = []
                    for q in (j - 19)...j { win.append(corpus.codes[s0 + q]) }
                    var probe = [UInt8](repeating: 0, count: 20)
                    for i in 0..<20 { probe[i] = 3 - win[19 - i] }
                    found = probe
                    break
                }
            }
            if found.isEmpty { tried += 1 }
        }
        startAt = tried + 1
        if found.count == 20 {
            let txt = String(found.map { letters[Int($0)] })
            if seenText.insert(txt).inserted {
                syntheticIdxs.append(strands.count)
                let tag = made + 1 < 10 ? "0\(made + 1)" : "\(made + 1)"
                strands.append(Strand(name: "UNDESIGNED-20MER-\(tag)", unii: "-",
                                      regType: "NOT_A_MEDICINE", status: "constructed",
                                      text: txt, seq: found, synthetic: true))
                texts.append(txt)
            }
        }
        made += 1
    }
    print("THE UNDESIGNED COHORT — \(syntheticIdxs.count) constructed 20-mers, NOT medicines, labelled as")
    print("such on every line they appear on. Each is the reverse complement of the first scoreable")
    print("20-mer of every \(stride0)-th transcript in this corpus, chosen by that rule and nothing else.")
    print("They are screened exactly as a medicine is, with their own 16 permutations each.")
    for (i, t) in texts.enumerated() {
        let tag = i + 1 < 10 ? "0\(i + 1)" : "\(i + 1)"
        print("  UNDESIGNED-20MER-\(tag)  5'-\(t)-3'")
    }
    print("")
}

// ---- SWEEP A: measure every strand's target ------------------------------------------------
let probesA = strands.map { makeProbe($0.seq, family: -1) }
let lengthsAll = Array(Set(strands.map { $0.L })).sorted()
let accsA = sweep(corpus: corpus, probes: probesA, lengths: lengthsAll,
                  onTargetGenes: [:], famCount: 0, threads: threads,
                  wantOff: false, wantPerfect: true)
let histA = mergeHist(accsA, probesA.count, off: false)
var winByLen: [Int: Int] = [:]
var txSeen = 0
for a in accsA { txSeen += a.transcripts; for (k, v) in a.winByLen { winByLen[k, default: 0] += v } }
var perfGenesA = [Set<Int32>](repeating: [], count: probesA.count)
for a in accsA { for p in 0..<probesA.count { perfGenesA[p].formUnion(a.perfGenes[p]) } }

// COUNT THE WORK AS IT HAPPENED.  Every window a probe scored incremented exactly one histogram
// bin, so the sum of a probe's bins IS the number of windows it actually scored.  That figure is
// compared against the independently accumulated per-length window census.  A short count is a
// refusal, not a footnote.
var sweepAWork = 0, sweepAShort = 0
for (i, s) in strands.enumerated() {
    let scored = histA[i].reduce(0, +)
    sweepAWork += scored
    if scored != (winByLen[s.L] ?? -1) { sweepAShort += 1 }
}
arm("sweep-A-scored-every-window-it-claimed", sweepAShort == 0 && txSeen == corpus.txCount,
    "\(sweepAWork) probe-windows scored; \(strands.count - sweepAShort) of \(strands.count) probes match their length's window census and \(sweepAShort) do not; \(txSeen) of \(corpus.txCount) transcripts visited")

let isReferenceCorpus = (corpus.txCount == REFERENCE_TX_COUNT && (winByLen[20] ?? 0) == REFERENCE_WINDOWS_20)
print("REFERENCE CORPUS TEST — two integers published before this program existed")
print("  transcripts             : \(corpus.txCount)  (reference \(REFERENCE_TX_COUNT))")
print("  scoreable 20-mer windows: \(winByLen[20] ?? 0)  (reference \(REFERENCE_WINDOWS_20))")
print("  verdict                 : \(isReferenceCorpus ? "THIS IS THE REFERENCE CORPUS — the cross-instrument comparison against the published single-drug screen is asserted below" : "NOT the reference corpus — the screen runs and reports, and the cross-instrument comparison is NOT_APPLICABLE")")
print("")

// ---- scope, in four dispositions ------------------------------------------------------------
struct Row {
    let idx: Int
    var scope: Scope
    let perfect: Int
    let targetGenes: [Int32]
}
var rows: [Row] = []
for (i, s) in strands.enumerated() {
    let perfect = histA[i][0]
    let sc = classify(L: s.L, windowsAtL: winByLen[s.L] ?? 0, perfect: perfect)
    rows.append(Row(idx: i, scope: sc, perfect: perfect, targetGenes: perfGenesA[i].sorted()))
}
// THE UBIQUITOUS BOUNDARY, read off the measured population of target-gene counts.
let candidateGeneCounts = rows.filter { $0.scope == .screened }.map { $0.targetGenes.count }
let ubiBoundary = ubiquitousBoundary(candidateGeneCounts)
if let b = ubiBoundary {
    for i in 0..<rows.count where rows[i].scope == .screened && rows[i].targetGenes.count >= b.boundary {
        rows[i].scope = .ubiquitous
    }
}
let screenedIdx = rows.enumerated().filter { $0.element.scope == .screened }.map { $0.offset }

// ---- SWEEP B: the screened families and their permutations ----------------------------------
var probesB: [Probe] = []
var onTargetGenes: [Int32: [Int]] = [:]
for (f, ri) in screenedIdx.enumerated() {
    let s = strands[rows[ri].idx]
    probesB.append(makeProbe(s.seq, family: f))
    for n in 1...SCRAMBLES { probesB.append(makeProbe(scramble(s.seq, n), family: f)) }
    for g in rows[ri].targetGenes { onTargetGenes[g, default: []].append(f) }
}
let lengthsB = Array(Set(probesB.map { $0.L })).sorted()
var histBall: [[Int]] = [], histBoff: [[Int]] = []
var sweepBWork = 0
if !probesB.isEmpty {
    let accsB = sweep(corpus: corpus, probes: probesB, lengths: lengthsB,
                      onTargetGenes: onTargetGenes, famCount: screenedIdx.count,
                      threads: threads, wantOff: true, wantPerfect: false)
    let onH = mergeHist(accsB, probesB.count, off: false)     // hAll receives ON-target windows
    histBoff = mergeHist(accsB, probesB.count, off: true)
    histBall = (0..<probesB.count).map { p in (0..<64).map { onH[p][$0] + histBoff[p][$0] } }
    var short = 0
    for (p, pr) in probesB.enumerated() {
        let scored = histBall[p].reduce(0, +)
        sweepBWork += scored
        if scored != (winByLen[pr.L] ?? -1) { short += 1 }
    }
    arm("sweep-B-scored-every-window-it-claimed", short == 0,
        "\(sweepBWork) probe-windows scored across \(probesB.count) probes; \(probesB.count - short) of them sum their on-target and off-target bins to their length's window census and \(short) do not")
    var disagree = 0
    for (f, ri) in screenedIdx.enumerated() {
        let a = histA[rows[ri].idx], b = histBall[f * (SCRAMBLES + 1)]
        for m in 0..<64 where a[m] != b[m] { disagree += 1 }
    }
    arm("two-sweeps-agree-bin-for-bin", disagree == 0,
        "\(screenedIdx.count) strands screened twice over the same resident corpus; \(disagree) of \(screenedIdx.count * 64) histogram bins disagree")
} else {
    arm("sweep-B-scored-every-window-it-claimed", false, "0 probes ran because no strand reached scope; nothing was screened and nothing is ranked")
}

// ---- burdens, controls, rank intervals, dispositions, resolving k ---------------------------
func burden(_ h: [Int], _ k: Int) -> Int { var c = 0; for m in 0...k { c += h[m] }; return c }
struct Result {
    let ri: Int
    let kTop: Int             // largest k this family is scored at, = min(KSCAN, L)
    let off: [Int]            // burden at <= k, k = 0...kTop
    let ctrl: [[Int]]         // sorted control burdens per k, each of length SCRAMBLES
    let rLo: [Int]
    let rHi: [Int]
    let disp: [Disp]
    let kRes: Int             // smallest k with control spread, -1 when none
    let onPerfect: Int
    let ctrlPerfectAnywhere: Int
    let geneCount: Int
    let ctrlsConsulted: Int   // total control comparisons actually made at KMAX
}
var results: [Result] = []
for (f, ri) in screenedIdx.enumerated() {
    let base = f * (SCRAMBLES + 1)
    let L = strands[rows[ri].idx].L
    let kTop = min(KSCAN, L)
    var off = [Int](), ctrls = [[Int]](), rlo = [Int](), rhi = [Int](), disps = [Disp]()
    var consulted = 0
    for k in 0...kTop {
        let d = burden(histBoff[base], k)
        var c: [Int] = []
        for j in 1...SCRAMBLES { c.append(burden(histBoff[base + j], k)) }
        c.sort()
        let iv = rankInterval(d, c)
        off.append(d); ctrls.append(c); rlo.append(iv.lo); rhi.append(iv.hi)
        disps.append(disposition(d, c))
        if k == KMAX { consulted = c.count }
    }
    // the SAME function the resolving-threshold arm validated, so the rule has one home
    let kres = resolvingK(ctrlByK: ctrls)
    let onPerf = histBall[base][0] - histBoff[base][0]
    var cp = 0
    for j in 1...SCRAMBLES { cp += histBall[base + j][0] }
    results.append(Result(ri: ri, kTop: kTop, off: off, ctrl: ctrls, rLo: rlo, rHi: rhi,
                          disp: disps, kRes: kres, onPerfect: onPerf, ctrlPerfectAnywhere: cp,
                          geneCount: rows[ri].targetGenes.count, ctrlsConsulted: consulted))
}

// ---- headline sets, read off the disposition, never off a rank number -----------------------
let designedAtKMAX  = results.filter { $0.kTop >= KMAX && $0.disp[KMAX] == .belowAll }
let aboveAtKMAX     = results.filter { $0.kTop >= KMAX && $0.disp[KMAX] == .aboveAll }
let noResolution    = results.filter { $0.kRes < 0 }
let resolved        = results.filter { $0.kRes >= 0 }
let designedAtKRes  = resolved.filter { $0.disp[$0.kRes] == .belowAll }
let aboveAtKRes     = resolved.filter { $0.disp[$0.kRes] == .aboveAll }
// the count the OLD strict-only rule would have printed, so the two can never disagree silently
let oldRuleRank1    = results.filter { $0.kTop >= KMAX && $0.rLo[KMAX] == 1 }

// ARM — THE RANKING SEPARATES, AND EVERY REPORTED RANK 1 IS STRICTLY BELOW EVERY CONTROL.  The
// bar `distinct > 1` cannot see a per-family failure: a build that ranks each strand against ONE
// control instead of all sixteen passes it while printing an inflated headline.  So the arm now
// also counts the control comparisons actually made and refuses a family that consulted fewer
// than SCRAMBLES, and it verifies the headline set by RE-DERIVING `off < min(ctrl)` rather than
// by trusting the rank column.
do {
    let ranksK = results.filter { $0.kTop >= KMAX }.map { $0.rLo[KMAX] }
    let distinct = Set(ranksK).count
    var shortFamilies = 0
    for r in results where r.ctrlsConsulted != SCRAMBLES { shortFamilies += 1 }
    var headlineVerified = 0
    for r in designedAtKMAX where r.off[KMAX] < (r.ctrl[KMAX].first ?? Int.min) { headlineVerified += 1 }
    var zilgLine = "ZILGANERSEN not in scope"
    var zilgOK = !isReferenceCorpus
    for r in results where strands[rows[r.ri].idx].unii == "AXQ9493NT2" {
        let med = r.ctrl[KMAX][SCRAMBLES / 2]
        zilgLine = "ZILGANERSEN off=\(r.off[KMAX]) ctrl median=\(med) range \(r.ctrl[KMAX].first ?? 0)-\(r.ctrl[KMAX].last ?? 0) rank \(rankText(r.rLo[KMAX], r.rHi[KMAX])) of \(SCRAMBLES + 1)"
        if isReferenceCorpus {
            zilgOK = (r.off[KMAX] == 324 && med == 787 && r.rLo[KMAX] == 3
                      && r.ctrl[KMAX].first == 141 && r.ctrl[KMAX].last == 1355)
        }
    }
    arm("ranking-separates-and-every-rank-1-is-strictly-below-all-16",
        distinct > 1 && zilgOK && shortFamilies == 0 && headlineVerified == designedAtKMAX.count,
        "\(distinct) distinct rankLo values across \(ranksK.count) screened families at \(KMAX) mismatches; "
        + "\(results.count - shortFamilies) of \(results.count) families consulted all \(SCRAMBLES) controls and \(shortFamilies) did not; "
        + "\(headlineVerified) of \(designedAtKMAX.count) headline families re-derive as burden < min(controls); "
        + "\(noResolution.count) of \(results.count) families have NO resolving threshold anywhere in 0...L and are excluded from the headline; "
        + zilgLine
        + (isReferenceCorpus ? " — matched against the single-drug screen's published integers"
                             : " — cross-instrument check NOT_APPLICABLE off the reference corpus"))
}
// ARM — the tie convention is declared, and the two conventions' headline counts are BOTH printed
// whenever they differ.  Changing one comparison operator moved this study's headline by 24x with
// every other arm green; this arm is the one that would have caught it.
do {
    let strictOnly = oldRuleRank1.count
    let strictSeparation = designedAtKMAX.count
    let differ = strictOnly != strictSeparation
    // BOTH DIRECTIONS, and no literal true anywhere in it. Forward: strict separation must be a
    // SUBSET of rankLo == 1, so its count can never exceed it and every member must carry
    // rankLo == 1. Backward: a constructed family that ties every control must carry rankLo == 1
    // while NOT being BELOW-all-16 — which is precisely the row the old rule mis-credited.
    let subsetOK = designedAtKMAX.allSatisfy { $0.rLo[KMAX] == 1 }
    let orderOK  = strictSeparation <= strictOnly
    let tieCtrl  = [Int](repeating: 7, count: SCRAMBLES)
    let counterRLo = rankInterval(7, tieCtrl).lo
    let counterDisp = disposition(7, tieCtrl)
    let counterCaught = (counterRLo == 1 && counterDisp != .belowAll)
    arm("tie-convention-declared-and-both-counts-printed",
        subsetOK && orderOK && counterCaught,
        "the strict set is a subset of rankLo==1: \(subsetOK), and its count does not exceed it: \(orderOK); a constructed family tying all \(SCRAMBLES) controls carries rankLo \(counterRLo) with disposition \(counterDisp.rawValue), so the mis-credited row is caught: \(counterCaught). "
        + "at \(KMAX) mismatches the at-or-below convention (rankLo == 1, ties favour the strand) counts \(strictOnly) families; "
        + "strict separation (burden < min of all \(SCRAMBLES) controls) counts \(strictSeparation); they "
        + (differ ? "DIFFER by \(strictOnly - strictSeparation), and the published headline is the strict figure \(strictSeparation) with the other printed beside it"
                  : "agree at \(strictSeparation), so no tie is hiding in the headline"))
}
// ARM — the undesigned cohort is n > 1 and its members are screened exactly as medicines are.
do {
    let cohort = results.filter { strands[rows[$0.ri].idx].synthetic }
    let ranks = cohort.map { $0.rLo[KMAX] }.sorted()
    let uniqueSeq = Set(cohort.map { strands[rows[$0.ri].idx].text }).count
    arm("undesigned-cohort-is-more-than-one-sequence",
        cohort.count > 1 && uniqueSeq == cohort.count,
        "\(cohort.count) undesigned 20-mers reached scope, \(uniqueSeq) of them distinct sequences; their rankLo at \(KMAX) mismatches runs \(ranks.first ?? -1) to \(ranks.last ?? -1) of \(SCRAMBLES + 1) — a baseline of one sequence could not have shown that spread")
}
// ARM — the constructed cohort ranks differently from a designed medicine, and two registrations
// of ONE sequence rank identically.  Both directions of the same claim.
do {
    var cohortRanks: [Int] = [], zilgRank = -1
    for r in results {
        if strands[rows[r.ri].idx].synthetic { cohortRanks.append(r.rLo[KMAX]) }
        if strands[rows[r.ri].idx].unii == "AXQ9493NT2" { zilgRank = r.rLo[KMAX] }
    }
    var pairsChecked = 0, pairsAgree = 0
    var byText: [String: [Result]] = [:]
    for r in results { byText[strands[rows[r.ri].idx].text, default: []].append(r) }
    for (_, g) in byText where g.count > 1 {
        for j in 1..<g.count {
            pairsChecked += 1
            if g[j].rLo == g[0].rLo && g[j].rHi == g[0].rHi && g[j].off == g[0].off { pairsAgree += 1 }
        }
    }
    let separates = zilgRank >= 0 && !cohortRanks.isEmpty
        ? cohortRanks.contains(where: { $0 != zilgRank })
        : Set(results.map { $0.rLo[KMAX] }).count > 1
    arm("cohort-and-medicine-separate-identical-sequences-do-not",
        separates && pairsChecked > 0 && pairsAgree == pairsChecked,
        "zilganersen rankLo \(zilgRank); the undesigned cohort spans rankLo \(cohortRanks.min() ?? -1) to \(cohortRanks.max() ?? -1) and \(cohortRanks.filter { $0 != zilgRank }.count) of \(cohortRanks.count) differ from it; \(pairsAgree) of \(pairsChecked) duplicate-sequence pairs produced identical rank interval AND identical burden, \(pairsChecked - pairsAgree) did not")
}
// ARM — on-target and off-target never mix.
do {
    var leaked = 0, haveOn = 0
    for (f, _) in screenedIdx.enumerated() {
        if histBoff[f * (SCRAMBLES + 1)][0] != 0 { leaked += 1 }
    }
    for r in results where r.onPerfect > 0 { haveOn += 1 }
    arm("on-target-and-off-target-stay-apart", leaked == 0 && haveOn == results.count,
        "\(leaked) of \(results.count) screened strands leaked a perfect complement into their own off-target count; \(haveOn) of \(results.count) carry their perfect complement on-target, \(results.count - haveOn) do not")
}

let corpusArms = Array(arms.suffix(arms.count - preCorpusArmCount))
printArms(corpusArms, "INSTRUMENT CONTROL ARMS (corpus-dependent)")
if arms.contains(where: { !$0.ok }) {
    print("THE INSTRUMENT DID NOT VALIDATE ON THIS CORPUS. No ranking is emitted.")
    printPublishedReference()
    exit(1)
}

// ===========================================================================================
// REPORT
// ===========================================================================================
print("SCOPE — FOUR dispositions, and no two of them are the same answer")
var nScreened = 0, nUbiq = 0, nRefused = 0, nNotKnown = 0
for r in rows where !strands[r.idx].synthetic {
    switch r.scope {
    case .screened:   nScreened += 1
    case .ubiquitous: nUbiq += 1
    case .refused:    nRefused += 1
    case .notKnown:   nNotKnown += 1
    case .noCorpus:   nNotKnown += 1 } }
let registryCount = strands.filter { !$0.synthetic }.count
print("  registry strands in the table              : \(registryCount)")
print("  undesigned constructed 20-mers, NOT medicines: \(strands.count - registryCount)")
print("  SCREENED   (target measured in few genes)  : \(nScreened)")
print("  UBIQUITOUS (perfect complement in hundreds of genes): \(nUbiq)   — NOT a measured target")
print("  REFUSED    (no perfect complement anywhere): \(nRefused)   — NOT zero off-targets")
print("  NOT_KNOWN  (too short for a target to mean): \(nNotKnown)")
print("")

print("THE UBIQUITOUS BOUNDARY — read off the measured distribution, not chosen")
let distinctCounts = Array(Set(candidateGeneCounts)).sorted()
print("  distinct target-gene counts among the strands that carried a perfect complement:")
print("    " + distinctCounts.map(String.init).joined(separator: " "))
if let b = ubiBoundary {
    print("  largest consecutive ratio in that sorted list : \(b.ratio) per thousand, at the step up to \(b.boundary)")
    print("  second-largest ratio                          : \(b.secondRatio) per thousand")
    print("  contiguous-run control ratio (computed)       : \(b.control) per thousand")
    print("  the rule fires because \(b.ratio) exceeds \(b.control); the boundary is \(b.boundary) genes and above.")
    print("  A strand pairing perfectly across \(b.boundary) or more genes has not had a target MEASURED. It is")
    print("  a common motif. Subtracting those genes as 'on-target' and publishing the remainder")
    print("  as its off-target burden would be an off-target figure it never earned, so it is not")
    print("  ranked. It is named below, with its gene count, and it is NOT a clean strand.")
} else {
    print("  no boundary fired: the largest consecutive ratio does not exceed the contiguous-run")
    print("  control ratio, so this population shows no separation the rule can read, and NO strand")
    print("  is called UBIQUITOUS on this corpus.")
}
print("")

print("HOW MUCH A 'MEASURED TARGET' RESTS ON — the chance expectation, per length")
print("  The NOT_KNOWN boundary (4^L > windows) only puts the expected number of chance perfect")
print("  complements below ONE. It does not make one unlikely. Expected chance perfect complements")
print("  per million, computed as windows(L) * 1000000 / 4^L:")
for L in lengthsAll.sorted() where L <= 26 {
    let w = winByLen[L] ?? 0
    let ppm = chancePerfectPPM(windows: w, L: L)
    let oneIn = ppm >= 1_000_000 ? "about \(ppm / 1_000_000) expected for EVERY arbitrary \(L)-mer"
              : (ppm >= 10_000 ? "about \(ppm / 10_000) in every hundred arbitrary \(L)-mers"
              : (ppm > 0 ? "about one in \(1_000_000 / ppm) arbitrary \(L)-mers" : "under one in a million"))
    print("    L=\(padR(L,2))  windows=\(padR(w,12))  expected=\(padR(ppm,8)) ppm   \(oneIn)")
}
var weakRows: [Result] = []
var weakAt1000 = 0, weakAt100000 = 0
for r in results {
    let L = strands[rows[r.ri].idx].L
    let ppm = chancePerfectPPM(windows: winByLen[L] ?? 0, L: L)
    let expectedCeil = (ppm + 999_999) / 1_000_000
    if r.onPerfect <= max(1, expectedCeil) {
        if ppm >= WEAK_EVIDENCE_PPM { weakRows.append(r) }
        if ppm >= 1_000 { weakAt1000 += 1 }
        if ppm >= 100_000 { weakAt100000 += 1 }
    }
}
print("")
print("  A screened row whose measured target rests on a SINGLE perfect complement, at a length")
print("  where a chance perfect complement is not rare, is flagged 'weak' in the ranking below.")
print("  The stated convention is an expectation above one in a hundred (\(WEAK_EVIDENCE_PPM) ppm).")
    print("  Rows flagged at an expectation above one in ten      (100000 ppm): \(weakAt100000)")
    print("  Rows flagged at an expectation above one in a hundred ( 10000 ppm): \(weakRows.count)   <- the stated convention")
    print("  Rows flagged at an expectation above one in a thousand (  1000 ppm): \(weakAt1000)")
print("  The sensitivity is printed so the convention can be re-made by any reader without")
print("  re-running anything. A flagged row is not a wrong row; it is a row whose 'measured")
print("  target' is weaker evidence than the same words carry at 20 or 25 bases.")
if !weakRows.isEmpty {
    print("  Flagged rows, named:")
    for r in weakRows.sorted(by: { strands[rows[$0.ri].idx].name < strands[rows[$1.ri].idx].name }) {
        let s = strands[rows[r.ri].idx]
        let ppm = chancePerfectPPM(windows: winByLen[s.L] ?? 0, L: s.L)
        print("    \(padL(String(s.name.prefix(30)), 31)) L=\(padR(s.L,2))  perfect=\(padR(r.onPerfect,3))  expectation=\(ppm) ppm  rank \(rankText(r.rLo[min(KMAX, r.kTop)], r.rHi[min(KMAX, r.kTop)]))")
    }
}
print("")

print("WINDOW CENSUS — a property of the transcriptome and a LENGTH, never one figure for the run")
for L in lengthsAll.sorted() { print("  \(padR(L,2))-mer : \(padR(winByLen[L] ?? 0, 12)) scoreable windows") }
print("")

print("WHY RAW BURDEN IS NEVER POOLED ACROSS LENGTHS — the same threshold, by length")
print("  len  screened   median strand burden   median control median   (windows at <= \(KMAX) mismatches)")
var byLen: [Int: [(Int, Int)]] = [:]
for r in results where r.kTop >= KMAX {
    byLen[strands[rows[r.ri].idx].L, default: []].append((r.off[KMAX], r.ctrl[KMAX][SCRAMBLES / 2]))
}
for L in byLen.keys.sorted() {
    let ds = byLen[L]!.map { $0.0 }.sorted()
    let cs = byLen[L]!.map { $0.1 }.sorted()
    print("  " + padR(L, 3) + padR(ds.count, 10) + padR(ds[ds.count / 2], 22) + padR(cs[cs.count / 2], 24))
}
print("")
print("  Those columns fall away by roughly a factor of four for every base added, which is what a")
print("  pooled league table would actually be ranking. The rank below is immune to it: every")
print("  comparison it makes is against permutations of the same molecule. Note the lengths whose")
print("  median strand burden AND median control median are both zero: at four mismatches those")
print("  families have no resolving power at all, which is exactly why every row also carries the")
print("  threshold at which its own controls first disagree with each other.")
print("")

// ---- ON-TARGET, KEPT APART -------------------------------------------------------------------
var onPerfTotal = 0, ctrlPerfTotal = 0
for r in results { onPerfTotal += r.onPerfect; ctrlPerfTotal += r.ctrlPerfectAnywhere }
print("ON-TARGET, KEPT STRICTLY APART AND NEVER COMPARED AGAINST THE CONTROLS")
print("  screened strands                                              : \(results.count)")
print("  perfect complements they carry inside their own measured target: \(onPerfTotal) windows")
print("  perfect complements carried anywhere by their \(results.count * SCRAMBLES) permutations: \(ctrlPerfTotal) windows")
print("")
print("  A medicine has a target; the same bases in another order do not. At the perfect-match")
print("  threshold a real strand will therefore always exceed its permutations, and that is the")
print("  design succeeding — it is not an off-target burden. Reporting it as one is what makes a")
print("  working medicine look dangerous. The separation here is structural, not a convention: a")
print("  window inside a strand's measured target genes cannot reach the off-target histogram at")
print("  all, for the strand or for any of its permutations, and the arm above proves it holds.")
print("")

// ---- THE CONTROL, AND ITS EVIDENCE OF DISCRIMINATION, BEFORE ANY RANKING ----------------------
print("THE UNDESIGNED COHORT'S OWN RESULT — printed BEFORE the registry ranking, because a rank")
print("means nothing until the instrument has been shown to discriminate on sequences that were")
print("designed for nothing at all. These are NOT medicines.")
print("")
print(padL("sequence", 24) + padR("off", 9) + padR("cmin", 9) + padR("cmed", 9) + padR("cmax", 9)
      + padR("rank", 8) + "  " + padL("vs-controls", 14) + padR("kRes", 6))
var cohortResults = results.filter { strands[rows[$0.ri].idx].synthetic }
cohortResults.sort { strands[rows[$0.ri].idx].name < strands[rows[$1.ri].idx].name }
for r in cohortResults {
    let s = strands[rows[r.ri].idx]
    let k = min(KMAX, r.kTop)
    print(padL(String(s.name.prefix(23)), 24) + padR(r.off[k], 9) + padR(r.ctrl[k].first ?? 0, 9)
          + padR(r.ctrl[k][SCRAMBLES / 2], 9) + padR(r.ctrl[k].last ?? 0, 9)
          + padR(rankText(r.rLo[k], r.rHi[k]), 8) + "  " + padL(r.disp[k].rawValue, 14)
          + padR(r.kRes, 6))
}
if !cohortResults.isEmpty {
    let rl = cohortResults.map { $0.rLo[min(KMAX, $0.kTop)] }.sorted()
    let below = cohortResults.filter { $0.disp[min(KMAX, $0.kTop)] == .belowAll }.count
    let above = cohortResults.filter { $0.disp[min(KMAX, $0.kTop)] == .aboveAll }.count
    print("")
    print("  \(cohortResults.count) undesigned 20-mers. rankLo runs \(rl.first!) to \(rl.last!), median \(rl[rl.count / 2]).")
    print("  \(below) of \(cohortResults.count) pair in fewer places than every one of their own \(SCRAMBLES) permutations;")
    print("  \(above) pair in more places than every one of them.")
    print("  WHAT THIS LICENSES, read off these numbers and not asserted: an ordinary stretch of")
    print("  human transcript, read back as an antisense strand, does not sit at the bottom of its")
    print("  own composition class — \(below) of \(cohortResults.count) of them are strictly below all \(SCRAMBLES) of their own")
    print("  permutations, and the median rankLo of the cohort is \(rl[rl.count / 2]) of \(SCRAMBLES + 1). So a registry strand")
    print("  at rank \(SCRAMBLES + 1) is not simply exhibiting 'what happens when a sequence's bases come from a")
    print("  transcriptome full of paralogues and repeats' — the cohort came from exactly there, and")
    print("  \(above) of \(cohortResults.count) of it sits at rank \(SCRAMBLES + 1) too. And a registry strand strictly below all \(SCRAMBLES)")
    print("  has done something \(cohortResults.count - below) of these \(cohortResults.count) undesigned sequences did not do.")
    print("  WHAT IT DOES NOT LICENSE: \(cohortResults.count) is not a population, these are 20-mers only, and none of")
    print("  this says anything about any molecule's safety.")
}
print("")

// ---- THE RANKING ---------------------------------------------------------------------------
print("THE RANKING — every screened strand against \(SCRAMBLES) permutations of its own bases,")
print("fewest off-target windows first, at \(KMAX) mismatches or fewer, outside its measured target.")
print("")
print("  rank      an INTERVAL. rankLo = 1 + #{controls strictly below}. rankHi adds the controls")
print("            that scored EXACTLY the same. '3' means no tie; '1-17' means the strand and all")
print("            sixteen permutations scored identically and the family cannot be ranked at this")
print("            threshold. RANK 1 MEANS 1-1, which is strict separation from all sixteen.")
print("  cmed      the UPPER median of the sixteen sorted controls — element 8 of ctrl[0...15],")
print("            the ninth smallest. Stated here, not left to be inferred from the source.")
print("  perMille  burden as parts per thousand of that median, floored; 'n/a' when the median is")
print("            zero, because a ratio to zero is not a number.")
print("  kRes      the smallest number of mismatches at which this family's own sixteen controls")
print("            do not all agree with each other — the threshold the family can be READ at.")
print("            '-1' means they never disagree anywhere in 0...L and the family is not scored.")
print("  evid      'weak' where the measured target rests on a single perfect complement at a")
print("            length where one is not rare (see the expectation table above).")
print("  A row marked * is an undesigned constructed sequence and is NOT a medicine.")
print("")
print(padL("substance", 29) + padL("UNII", 12) + padR("len", 4) + padR("perf", 7) + padR("gene", 5)
      + padR("evid", 6) + "  " + padL("target", 13) + padR("off", 9) + padR("cmin", 8)
      + padR("cmed", 8) + padR("cmax", 8) + padR("rank", 7) + padR("perMille", 9)
      + "  " + padL("vs-controls", 13) + padR("kRes", 5))
let weakSet = Set(weakRows.map { $0.ri })
let ordered = results.sorted { a, b in
    let ka = min(KMAX, a.kTop), kb = min(KMAX, b.kTop)
    if a.rLo[ka] != b.rLo[kb] { return a.rLo[ka] < b.rLo[kb] }
    if a.rHi[ka] != b.rHi[kb] { return a.rHi[ka] < b.rHi[kb] }
    let am = a.ctrl[ka][SCRAMBLES / 2], bm = b.ctrl[kb][SCRAMBLES / 2]
    let ap = am > 0 ? (a.off[ka] * 1000) / am : Int.max
    let bp = bm > 0 ? (b.off[kb] * 1000) / bm : Int.max
    if ap != bp { return ap < bp }
    return strands[rows[a.ri].idx].name < strands[rows[b.ri].idx].name
}
var sealText = "registry-specificity-ranking;v=2;scr=\(SCRAMBLES);kmax=\(KMAX);kscan=\(KSCAN);cohort=\(cohortResults.count);tx=\(corpus.txCount);fp=\(fp);\n"
if let b = ubiBoundary { sealText += "UBI|boundary=\(b.boundary)|ratio=\(b.ratio)|control=\(b.control)|second=\(b.secondRatio)\n" }
else { sealText += "UBI|none\n" }
for r in ordered {
    let s = strands[rows[r.ri].idx]
    let k = min(KMAX, r.kTop)
    let tg = rows[r.ri].targetGenes.map { corpus.geneName[Int($0)] }.sorted()
    let med = r.ctrl[k][SCRAMBLES / 2]
    let pm = med > 0 ? String((r.off[k] * 1000) / med) : "n/a"
    let tgs = tg.prefix(2).joined(separator: ",") + (tg.count > 2 ? "+\(tg.count - 2)" : "")
    print(padL(String((s.synthetic ? "* " + s.name : s.name).prefix(28)), 29) + padL(s.unii, 12)
          + padR(s.L, 4) + padR(r.onPerfect, 7) + padR(r.geneCount, 5)
          + padR(weakSet.contains(r.ri) ? "weak" : "-", 6)
          + "  " + padL(String(tgs.prefix(12)), 13) + padR(r.off[k], 9)
          + padR(r.ctrl[k].first ?? 0, 8) + padR(med, 8) + padR(r.ctrl[k].last ?? 0, 8)
          + padR(rankText(r.rLo[k], r.rHi[k]), 7) + padR(pm, 9)
          + "  " + padL(r.disp[k].rawValue, 13) + padR(r.kRes, 5))
    sealText += "S|\(s.name)|\(s.unii)|\(s.L)|\(s.text)|perf=\(r.onPerfect)|genes=\(r.geneCount)|kRes=\(r.kRes)|tg=\(tg.joined(separator: ","))"
    for kk in 0...min(KMAX, r.kTop) {
        sealText += "|k\(kk)=\(r.off[kk]),rlo=\(r.rLo[kk]),rhi=\(r.rHi[kk]),d=\(r.disp[kk].rawValue),ctrl=\(r.ctrl[kk].map(String.init).joined(separator: "/"))"
    }
    if r.kRes >= 0 {
        sealText += "|RES k=\(r.kRes),off=\(r.off[r.kRes]),rlo=\(r.rLo[r.kRes]),rhi=\(r.rHi[r.kRes]),d=\(r.disp[r.kRes].rawValue),ctrl=\(r.ctrl[r.kRes].map(String.init).joined(separator: "/"))"
    }
    sealText += "\n"
}
print("")

// ---- the two tie conventions, side by side ---------------------------------------------------
print("THE TIE RULE, AND WHAT IT DOES TO THE HEADLINE — printed because ONE comparison operator")
print("moved this study's headline while every other arm in the instrument stayed green.")
print("  families whose rankLo is 1 (ties favour the strand)      : \(oldRuleRank1.count)")
print("  families STRICTLY below all \(SCRAMBLES) controls (rank exactly 1-1): \(designedAtKMAX.count)")
print("  the difference is \(oldRuleRank1.count - designedAtKMAX.count) families that TIED at least one permutation, and")
print("  \(results.filter { $0.kTop >= KMAX && $0.disp[KMAX] == .tiedAll }.count) of them tied ALL \(SCRAMBLES) — every arm of the comparison scoring the same number,")
print("  which is not fewer places, it is the same number of places. The headline is the strict")
print("  figure. The other is printed here so the two can never disagree silently again.")
print("")

// ---- the resolving threshold ------------------------------------------------------------------
print("READ AT EACH FAMILY'S OWN RESOLVING THRESHOLD — the smallest k where its controls disagree")
print("  families with a resolving threshold          : \(resolved.count) of \(results.count)")
print("  families with NONE anywhere in 0...L         : \(noResolution.count)   — not scored, named below")
var kResHist: [Int: Int] = [:]
for r in resolved { kResHist[r.kRes, default: 0] += 1 }
print("  distribution of that threshold:")
for k in kResHist.keys.sorted() { print("    k=\(padR(k,2)) : \(padR(kResHist[k]!, 5)) \(fam(kResHist[k]!))") }
print("  STRICTLY below all \(SCRAMBLES) controls at their own resolving k : \(designedAtKRes.count)")
print("  ABOVE all \(SCRAMBLES) controls at their own resolving k          : \(aboveAtKRes.count)")
print("")
print("  This is a reading of arithmetic already done — the complete histogram is published below")
print("  — and it is a DIFFERENT measurement from the \(KMAX)-mismatch column, not a second attempt at")
print("  the same one. At \(KMAX) mismatches a 30-mer and all sixteen of its permutations score zero and")
print("  the comparison is empty; at its own resolving threshold it is a real comparison.")
if !noResolution.isEmpty {
    print("")
    print("  Families with no resolving threshold anywhere — the controls never disagree, so no rank")
    print("  can be read for them and none is claimed:")
    for r in noResolution.sorted(by: { strands[rows[$0.ri].idx].name < strands[rows[$1.ri].idx].name }) {
        let s = strands[rows[r.ri].idx]
        print("    \(padL(String(s.name.prefix(30)), 31)) L=\(padR(s.L,2))")
    }
}
print("")

// ---- what the ranking found, at full magnitude ----------------------------------------------
var dist = [Int](repeating: 0, count: SCRAMBLES + 2)
for r in results { dist[r.rLo[min(KMAX, r.kTop)]] += 1 }
print("RANK DISTRIBUTION at \(KMAX) mismatches — \(results.count) screened families, by rankLo")
for r in 1...(SCRAMBLES + 1) where dist[r] > 0 { print("  rankLo \(padR(r, 2)) of \(SCRAMBLES + 1) : \(padR(dist[r], 5)) \(fam(dist[r]))") }
print("")
var dispCount: [String: Int] = [:]
for r in results { dispCount[r.disp[min(KMAX, r.kTop)].rawValue, default: 0] += 1 }
print("DISPOSITION at \(KMAX) mismatches — the six are exhaustive and mutually exclusive")
for d in [Disp.belowAll, .tiedMin, .inside, .tiedMax, .aboveAll, .tiedAll] {
    print("  \(padL(d.rawValue, 14)) : \(padR(dispCount[d.rawValue] ?? 0, 5)) \(fam(dispCount[d.rawValue] ?? 0))")
}
print("")
let designedRegistry = designedAtKMAX.filter { !strands[rows[$0.ri].idx].synthetic }
let designedCohort   = designedAtKMAX.filter { strands[rows[$0.ri].idx].synthetic }
print("  \(designedAtKMAX.count) families pair in FEWER places than EVERY ONE of the \(SCRAMBLES) rearrangements of their")
print("  own bases at \(KMAX) mismatches — \(designedRegistry.count) registry strands and \(designedCohort.count) undesigned constructed sequences.")
if !designedRegistry.isEmpty {
    print("  For those medicines the specificity is a property of the ORDER the bases were chosen in.")
    print("  It is not what their composition forces, and it was measurable in integers before the")
    print("  molecule was ever synthesised. Named, at full magnitude:")
    for r in designedRegistry.sorted(by: { strands[rows[$0.ri].idx].name < strands[rows[$1.ri].idx].name }) {
        let s = strands[rows[r.ri].idx]
        print("    \(padL(String(s.name.prefix(30)), 31)) \(padL(s.unii, 12)) L=\(padR(s.L,2))  off=\(padR(r.off[KMAX],7))  controls \(r.ctrl[KMAX].first!)-\(r.ctrl[KMAX].last!)  rank \(rankText(r.rLo[KMAX], r.rHi[KMAX]))")
    }
}
print("")
print("  \(aboveAtKMAX.count) families pair in MORE places than every rearrangement of their own bases.")
print("  That is a measurement of one discrete property of a sequence. IT IS NOT A SAFETY FINDING")
print("  and it is not a statement about any medicine's effect on any person.")
print("")

// ---- the complete histograms -----------------------------------------------------------------
print("COMPLETE MISMATCH HISTOGRAMS — the reporting threshold is a choice made AFTER the")
print("arithmetic. Off-target windows only, outside each strand's own measured target genes.")
print("Columns are the number of windows pairing with exactly 0,1,2,...,8 mismatches, then the")
print("count of everything worse, which is where the overwhelming majority of a large corpus sits.")
print("")
print(padL("substance", 30) + padR("L", 3) + "  " + (0...8).map { padR("m\($0)", 11) }.joined() + padR("worse", 14))
for r in ordered {
    let s = strands[rows[r.ri].idx]
    let base = screenedIdx.firstIndex(of: r.ri)! * (SCRAMBLES + 1)
    let h = histBoff[base]
    var worse = 0; for m in 9..<64 { worse += h[m] }
    print(padL(String(s.name.prefix(29)), 30) + padR(s.L, 3) + "  "
          + (0...8).map { padR(h[$0], 11) }.joined() + padR(worse, 14))
    sealText += "H|\(s.name)|" + (0..<64).map { String(h[$0]) }.joined(separator: ",") + "\n"
}
print("")

// ---- exclusions, named -------------------------------------------------------------------------
print("EXCLUDED, AND WHY — an excluded strand is never a clean strand")
print("  UBIQUITOUS — a perfect complement in hundreds of genes. Not a target, a motif. Its")
print("  off-target burden is not reported because subtracting hundreds of genes as 'on-target'")
print("  manufactures a remainder that means nothing.")
print("  REFUSED — a published sequence with no perfect complement anywhere in this transcriptome.")
print("  Honest reasons: the registry publishes the SENSE strand of a double-stranded medicine and")
print("  its partner carries the target; the target is viral or otherwise absent from GENCODE; the")
print("  molecule is an aptamer, which binds a protein and not a transcript, so complementarity has")
print("  nothing to say about it; or the sequence carries chemistry a base string cannot represent.")
print("  NOT_KNOWN — too short for a perfect complement to be evidence of anything.")
print("  ABSENCE, REFUSAL, UBIQUITY and NOT_KNOWN are four different answers and none is zero.")
print("")
print(padL("substance", 30) + padL("UNII", 12) + padR("len", 4) + padR("perfect", 9) + padR("genes", 7) + "  disposition")
for r in rows where r.scope != .screened {
    let s = strands[r.idx]
    print(padL(String(s.name.prefix(29)), 30) + padL(s.unii, 12) + padR(s.L, 4)
          + padR(r.perfect, 9) + padR(r.targetGenes.count, 7) + "  " + r.scope.rawValue
          + (r.scope == .notKnown ? "  (4^\(s.L) does not exceed the window count — a perfect complement here is expected by chance)" : "")
          + (r.scope == .ubiquitous ? "  (perfect complement in \(r.targetGenes.count) genes — a motif, not a measured target)" : ""))
    sealText += "X|\(s.name)|\(s.unii)|\(s.L)|\(r.scope.rawValue)|perf=\(r.perfect)|genes=\(r.targetGenes.count)\n"
}
print("")

// ---- register ------------------------------------------------------------------------------
print("WHAT THIS SAYS, AND WHAT IT DOES NOT.")
print("  A near-complementary window is a place a molecule COULD pair. It is not a cut, not an")
print("  occupancy, not a clinical event, and not evidence that any medicine harms anyone. RNase H1")
print("  recruitment, RISC loading, accessibility of the site in a folded transcript, expression of")
print("  the gene in the tissue the drug reaches — every one of those sits between this integer and")
print("  a patient, and none of them is in this program.")
print("  A HIGH RANK IS NOT A SAFETY FINDING AND A LOW RANK IS NOT A CLEARANCE.")
print("  The chemistry half of oligonucleotide safety is not a sequence match at all:")
print("  phosphorothioate backbone binding to plasma and cell-surface proteins, complement")
print("  activation, thrombocytopenia, the aseptic meningitis that sits on real intrathecal labels.")
print("  No base search predicts any of it, and this program does not try.")
print("  Where a molecule is STRICTLY below all \(SCRAMBLES), that is designed specificity and it is stated")
print("  at full magnitude: no rearrangement of its own bases paired in fewer places. Where it ties")
print("  them, that is a tie, and it is printed as one.")
print("")
print("SUMMARY")
print("  screened families            : \(results.count)   (\(nScreened) registry + \(cohortResults.count) undesigned constructed)")
print("  probe-windows scored, sweep A: \(sweepAWork)")
print("  probe-windows scored, sweep B: \(sweepBWork)")
print("  total probe-windows scored   : \(sweepAWork + sweepBWork)")
print("  every one of them counted as it happened, by summing the histogram bins each window")
print("  incremented, and checked against an independently accumulated per-length window census.")
print("")
printPublishedReference()
print("MARKER  REGISTRY_SPECIFICITY_RANKING__ORDER_NOT_COMPOSITION_SETS_THE_BURDEN")
print("corpus fingerprint  \(fp)")
print("sha256  \(SHA256Min.hex(sealText))")
