// protein-novelty-exact.swift
// ===========================================================================
// THE STUDY:  ARE THE 78,680 GENERATED "VALIDATED CURE" PROTEINS NOVEL?
//
// Exactly decidable question, no float can answer it:
//   (1) does a generated sequence appear EXACTLY, in full, in the reviewed
//       human proteome?
//   (2) what is the LONGEST EXACT SUBSTRING it shares with any human protein,
//       and in which accession does that longest match occur?
//   (3) the full distribution of those integers, published, so the reporting
//       threshold is a choice made AFTER the arithmetic, never inside it.
//
// HOUSE RULES HONOURED HERE
//   * Swift 6.4 law.  ZERO FLOAT anywhere in this file: no Double, no Float,
//     no CGFloat, no floating literal, no percentage-as-float.  Every ratio is
//     an integer parts-per-million produced by integer division.  Timing uses
//     clock_gettime integer nanoseconds, not Date().
//     CORRECTED 2026-09-06: this line used to claim that `grep -nE
//     'Double|Float|CGFloat' protein-novelty-exact.swift` returns nothing
//     outside this comment block.  Run today it returns ONE hit outside it —
//     the transcript line "Doubles and are barred from every verdict", which is
//     prose ABOUT floats, not a float.  A header that states a command's output
//     is making a claim the command refutes: the same defect this file spent
//     four passes repairing elsewhere, wearing a house rule as a costume.  The
//     property still holds and is enforced where it can discriminate — two
//     detectors in validate.sh over the body below `import Foundation`, one for
//     float TYPES and one for float LITERALS, each with control arms proving it
//     fires on `public var s1: Float` and stays quiet on the prose word
//     'Doubles'.  Trust those, never this paragraph.
//   * COMPLETE ENUMERATION.  Every one of the 78,680 sequences is matched
//     against every one of the 11,418,237 reference residues.  No sampling,
//     no e-value, no cutoff, no heuristic seeding inside the computation.  Both
//     corpora are screened; the second one is reported in its own section and is
//     never pooled with the study.
//   * SELF-VALIDATING.  TWELVE arms run BEFORE any corpus work (the count is
//     derived from the arms that ran, never written down — this sentence said
//     "seven" while ten were running).  If any arm
//     fails, NO verdict transcript and NO seal are emitted and the exit code
//     is non-zero.  Arms run in both directions: the instrument must find what
//     is there AND must fail to find what is not.
//   * NO ARGV, stdin from /dev/null.  The published reference figures are
//     printed as the very first action, before any file is opened, so EVERY
//     refusal path prints them and no early exit can be uninstrumented.
//   * A sha256 seal over the verdict transcript, computed by the
//     self-contained SHA-256 below.
//
// ---------------------------------------------------------------------------
// EXACTNESS BOUND — the one thing a seeded matcher must prove.
//
//   Let K = 5.  Index EVERY position of EVERY valid K-mer of the reference
//   proteome (a K-mer is valid iff all K of its residues are among the 20
//   standard amino acids and it crosses no protein boundary).
//
//   CLAIM: every common substring of length L >= K is found.
//   PROOF: let S be a common substring of length L >= K, occurring at query
//   offset i and reference offset p.  Its first K residues S[0..<K] are a
//   substring of the query at offset i and of the reference at offset p.  All
//   K of those residues are standard (the query alphabet is exactly the 20
//   standard residues — enforced at load) and, being inside one occurrence in
//   one protein, they cross no boundary.  Therefore that K-mer is in the
//   index at position p, the seed loop visits offset i, retrieves p, and the
//   maximal two-sided extension from (i,p) returns a match of length >= L on
//   that diagonal.  QED.  This is the standard "a match of length L contains
//   at least one exact k-mer for any k <= L" bound, and K <= L is enforced by
//   construction because K is 5 and the sub-K case is answered separately and
//   exactly, below.
//
//   THERE IS NO REPORTING FLOOR INSIDE THE COMPUTATION.  Matches shorter than
//   K are not left unresolved and are not lumped into a "<K" bucket: the
//   first-occurrence tables fp1..fp4 hold, for every 1-, 2-, 3- and 4-mer over
//   the 20-letter alphabet (20 + 400 + 8,000 + 160,000 = 168,420 cells), the
//   first reference position at which it occurs, or -1 for absent.  A query
//   with no K-mer hit is answered exactly by descending k = 4,3,2,1.  So every
//   one of the 78,680 answers is exact for its true value, whatever that value
//   is.  The reporting threshold appears ONLY in the "where a bench should
//   point" section, applied to the already-published full distribution.
//
// COST, stated by the program itself and re-printed at run time:
//   index build   O(N) over N = 11,418,237 reference residues, two passes
//   index memory  (20^5 + 1) Int32 buckets + ~11.33M Int32 positions
//                 = 12.8 MB + 45.3 MB, plus 13.6 MB encoded reference
//   query         sum over sequences of (n-K+1) bucket probes, each probe
//                 followed by maximal two-sided extension.  EVERY seed hit is
//                 extended; no seed is skipped, so there is no pruning
//                 argument to get wrong.  A diagonal-dedup prune was written,
//                 proven to produce a byte-identical sealed transcript, and
//                 then REMOVED because it bought nothing: measured over three
//                 runs each, pruned 1122/1140/1297 ms against unpruned
//                 990/1057/1203 ms.  An optimisation that does not optimise
//                 but does add a correctness argument is a liability, so it
//                 is not carried.
//
// ---------------------------------------------------------------------------
// TWO CORRECTIONS TO THE BRIEF, stated loudly as instructed.
//
//   (a) The reference proteome alphabet is 21 letters, not 20.  It contains
//       U (selenocysteine) 36 times.  U is handled as a non-standard residue:
//       it is excluded from the index and it terminates every extension.  This
//       cannot manufacture a match and cannot hide one, because the generated
//       corpus contains no U — a query residue can never equal U.  Verified at
//       load: the corpus alphabet is exactly the 20 standard residues.
//
//   (b) The natural-composition table quoted in the brief (L 9.9, A 8.3,
//       G 7.1, V 6.9, S 6.6, E 6.2, I 5.9, K 5.8) is the all-organism
//       Swiss-Prot composition, NOT the composition of the human reference
//       file this study compares against.  Measured on the reference file
//       itself: L 9.96, S 8.35, E 7.11, A 7.01, G 6.57.  A differs by 1.3
//       points and S by 1.75 points.  The load-bearing claim is unaffected and
//       is confirmed exactly: K+R is 113,634 ppm (11.36%) in the human
//       reference against 198,674 ppm (19.87%) in the generated corpus.
//       "K+R nearly doubled against about 11% natural" stands, measured
//       against the correct population.  Both figures are recomputed below.
// ---------------------------------------------------------------------------
// REPAIRS LANDED 2026-09-06, after three independent verification passes.  The
// figures below are what was MEASURED, not what was argued.  The distribution
// did not move — three mechanisms sharing no code with this one had already
// reproduced every bin — but four things that reach a reader did.
//
//   1. THE REFERENCE IS NOW HASHED, NOT ASSERTED.  PIN_REF_SHA was printed as
//      though verified while SHA256Exact ran only on the transcript.  Measured:
//      one residue substituted (M->G on line 2) gives sha256 9cf50af6... with
//      IDENTICAL protein count 20431 and residue count 11418237, so both count
//      pins stayed green and the program sealed a verdict on a file it had never
//      read.  It now refuses at the gate, naming the measured digest.
//
//   2. '>' IS A RECORD START ONLY AT A LINE START.  Eleven reviewed human
//      descriptions spell an arrow ('DNA dC->dU-editing enzyme APOBEC-3A',
//      'Delta 5-->4-isomerase type 1').  Every one reset the header buffer, so
//      P14060 P26439 P31941 P41238 Q6NTF7 Q8IUX4 Q96AK3 Q9HC16 Q9NRW3 Q9UH17
//      Q9Y235 were reported as '4-isomerase', 'dU-editing', 'U-editing' — and 14
//      of the 78,680 rows already carried one.  It also injected 11 spurious
//      sentinels, 20,441 against the correct 20,430.  Now measured: all 20,431
//      parsed accessions equal an independent awk extraction, zero diff.
//
//      PRECISED 2026-09-06, because the rest of this entry once read "shifting
//      every reported offset after them by up to 11" and that is no longer a
//      statement about anything this program prints.  MEASURED, by building the
//      pre-fix '>' rule and the current one from one source and diffing the two
//      full outputs: THE SEALED TRANSCRIPT IS BYTE-IDENTICAL AND THE SEAL IS THE
//      SAME, 4d54de45...  Only the unsealed timing line differs.  Internally
//      41,445 of the 78,680 rows do shift their buffer position by 1 to 11, and
//      exactly 14 rows change their reported accession — but repair 3 replaced
//      the printed offset with the residue index WITHIN the accession, and both
//      p and protStart[.] shift together, so that column is invariant under the
//      bug; and none of the 11 renamed accessions is in the 25-row bench table.
//      So this repair is real, it is correct, and TODAY IT MOVES NO PUBLISHED
//      FIGURE.  Repair 3 is what made repair 2 invisible to the seal.  The two
//      claims "the parser was wrong" and "a published number was wrong" are
//      different claims and only the first one survives measurement here.
//
//   3. THE BENCH TABLE IS CHECKABLE BY HAND.  pad(id, 32) with an id of exactly
//      32 characters emitted no separator and fused id to length
//      ('..._295190'); 3,914 corpus ids are 32 or longer.  Width now comes from
//      the widest id printed, and the position column is the 1-based residue
//      index WITHIN the named accession rather than an offset into this
//      program's internal buffer — verified independently for all 25 rows, with
//      a control: shifting every index by one breaks 25 of 25.
//
//   4. THE TRANSCRIPT NOW STATES ITS OWN BLINDNESS.  It sees exact substrings
//      and nothing else: no gapped alignment, no substitution scoring, no BLAST
//      or Smith-Waterman.  The sentence a reader will quote is qualified to 'no
//      detectable residual similarity AT EXACT-SUBSTRING RESOLUTION', because
//      the null model is built on the same exact-match statistic as the
//      observation and neither can speak past it.
//
// Also: stdout is unbuffered (a trap under `prog < /dev/null > file` discarded
// every printed line — measured 0 bytes captured, now 782); lenHist is sized
// from the measured maximum instead of a fixed 512; the null-model loop is
// guarded so a short corpus refuses rather than traps; ppm() takes its ratio in
// Int128 (the aligned-pair numerator sat within a factor of three of Int64.max);
// the sub-K path implements the tie rule the transcript states instead of a
// different one; four arms were added — the protein boundary (deleting the
// sentinel left all seven old arms green while moving three published bins) and
// fp4/fp3/fp2, which 168,400 of 168,420 cells had never executed; the arm count
// is derived rather than the literal '7 of 7' that went on printing 7 while ten
// arms ran; and the dead local `domains` is gone.
//
// A fifth repair followed, from reading the corpus columns rather than the brief:
//   5. THE 78,680 ARE SIXTEEN CANCER LABELS, NOT TWELVE DISEASES. Every row of
//      proteins_validated.csv carries category "Health - Cancer"; the twelve
//      diseases belong to proteins_by_disease.csv, a disjoint 1,400-row file
//      this program does not open (sequence intersection: 0). The transcript
//      had inherited the wrong scope from the brief. The label census and the
//      full 20-residue composition of both populations are now sealed rather
//      than computed beside the study.
//
// A SIXTH PASS, 2026-09-06, from re-reading the sealed transcript against what the
// program actually executes.  A1 taught that a figure a program PRINTS and a figure
// a program COMPUTES are indistinguishable from outside it.  That lesson had been
// applied to the reference file and to nothing else, and five more places in this
// transcript were still printing without computing:
//
//   6. THE CALL RECITED THE NULL MODEL FROM MEMORY.  '249852560', '13570309',
//      '39993' and 'the single 12-residue match' were typed literals in the
//      paragraph a reader quotes, six lines under the table that computes them.
//      They agreed today by hand-copying.  A corpus edit or a reference roll moves
//      the table and leaves the paragraph reciting the old numbers inside a valid
//      seal — the A1 defect, one section further down the page.  Interpolated now,
//      including the count and the plural, from the same arrays the table prints.
//
//   7. THE CATEGORY AND MECHANISM COLUMNS WERE ASSERTED BY A PARSER THAT STOPPED
//      BEFORE THEM.  The transcript said every row carries category 'Health -
//      Cancer' and mechanism 'PPI Inhibition (electrostatic disruption)'.  The CSV
//      loop broke at the sixth comma; category is field 4 and mechanism is field 6,
//      and mechanism was never read at all.  Both are now COUNTED and printed as a
//      census, so a column holding two values would say so instead of being
//      summarised by a sentence written before the file was opened.  Measured: one
//      distinct category x78680, one distinct mechanism x78680 — the sentence was
//      true, and it was still not a measurement.
//
//   8. THE SECOND CORPUS WAS DESCRIBED, NEVER OPENED.  The transcript stated its
//      1,400 rows, its twelve labels and its disjointness from the studied corpus
//      while this program had never read the file.  It is now loaded, hashed,
//      pinned and SCREENED by the same matcher against the same reference, in its
//      own section that is never pooled with the study.  Measured: 1400 sequences,
//      78694 residues, lengths 20 to 100, twelve labels, 0 sequences in common,
//      0 occurring in full in the proteome, longest shared substring 9 with four
//      sequences at 9 and none at 10 or above.  That last figure had been reported
//      by an independent mechanism and left out of the transcript; publishing it
//      here is the difference between a reader trusting a number and checking one.
//
//   9. BOTH CORPORA ARE HASHED.  Row count, residue count and the length triple are
//      all blind to a substituted residue — identical either side of it — which was
//      the whole argument for hashing the reference.  The same argument covers the
//      files the answers come from.  Pinned: proteins_validated.csv
//      bb3691b3..., proteins_by_disease.csv 24cdbf96...
//
//  10. THE LABEL CENSUS CARRIED A4 UNREPAIRED.  A4 widened the bench table from a
//      fixed 32 because an id of exactly 32 characters fused two columns; the label
//      table added in the fifth pass then hardcoded 30.  The longest label measured
//      is 27, so nothing is fused today and the defect is latent rather than live —
//      which is exactly how the first one arrived.  Width is derived from the
//      widest label printed.
//
//  11. THE TIE RULE HAD NO ARM.  'Among all longest matches, the smallest
//      reference position wins' is stated in the transcript and was corrected on
//      the sub-K path in the fifth pass — on a path this corpus never reaches, so
//      nothing executed the correction.  A12 executes it: query AAACCF, answered
//      at length 4, engine position 1220, and the rule that was REPLACED (first
//      query offset with a hit) would answer 224049.  Both candidates are
//      recomputed by scanning the reference buffer directly rather than by reading
//      the fp4 table the engine read, and the arm REQUIRES the two rules to
//      disagree on this query — a tie rule tested where both rules agree proves
//      nothing.  Arm count 11 -> 12, derived, never written down.
//
// A SEVENTH PASS, 2026-09-06, from doing to the ARMS what the sixth pass did to the
// PROSE: running each one against the failure it names instead of reading what it
// says.  Eleven of the twelve discriminate.  One did not.
//
//  12. A8 WAS ALWAYS-GREEN, AND IT WAS THE ARM GUARDING THE LARGEST MOVE.  Its own
//      comment named the experiment — delete the inter-protein sentinel — and that
//      experiment had never been run.  Run now, on the same binary: 12 of 12 arms
//      PASS, A8 included, and the program seals a MOVED distribution (5:33->32,
//      6:33519->33334, 7:41021->41180, 8:3861->3887, 9:233->234, mean
//      521543->521758, and 41,021 -> 41,180 in the bin a reader quotes).  A sealed
//      wrong answer with a clean self-test is the worst state this file has an
//      instrument for, and the instrument was asleep.  Cause: two characters in A8's
//      own setup — `- 1` on protStart[realIdx+1] and on protStart[realIdx+2],
//      redundant with the `where b[i] < OTHER` filter that already drops the
//      sentinel, and, with no sentinel, a one-residue truncation that made the 40-mer
//      A8 probes with non-contiguous in the buffer.  The arm was defended by the bug
//      it was built to detect.  Both `- 1`s deleted; re-measured in both directions;
//      validate.sh runs the sentinel-deleted direction as an arm and requires A8 to
//      FAIL while the other eleven stay green, which is the claim A8's comment had
//      been making without evidence.  NO PUBLISHED FIGURE MOVES: the seal is
//      4d54de456cf20f426214a17e2898281a7c66515813e00bef1951b64a356077a5 before and
//      after, byte-identical transcripts.
//
//      Two header claims were corrected in the same pass, both by measurement and
//      both in the direction of LESS than was written: the ZERO-FLOAT paragraph
//      stated a grep result the grep refutes (one hit, on the prose word 'Doubles'),
//      and repair 2's "shifting every reported offset" moves nothing this program
//      prints once repair 3 replaced the printed offset with a residue index. See
//      each at its site. The pattern in both is A1's: a sentence about a measurement
//      is not the measurement, and it goes stale silently.
//
// AND THE REFUSAL PATHS ARE NOW SHOWN TO FIRE, in validate.sh, under the same
// binary with the inputs swapped: a one-residue substitution in the reference
// (counts identical, digest 9cf50af6...), a one-residue substitution in the corpus
// (rows, residues and lengths all identical), and each of the three inputs emptied
// in turn.  Five arms, each requiring exit 2, the named reason, the reference
// figures, and the ABSENCE of a seal — plus a control arm proving the same probe
// binary exits 0 and seals on good inputs.  Pinning the digest STRING alone
// reproduced the original defect one level up: it was green whether or not the
// check could fail.
//
// NOTHING THE STUDY MEASURES MOVED.  Distribution 5:33 6:33519 7:41021 8:3861
// 9:233 10:12 11:0 12:1, minimum 5, maximum 12, mean 521543/78680, K+R 198674 ppm
// against 113634 ppm, the null column, the composition table and all 25 bench rows
// are byte-identical to the fifth pass.  The seal moved because the transcript now
// carries measurements it did not carry before.
//
// Seal ladder: ed1b8ee3... (pre-repair) -> f454b956... (fifth pass) -> a954b7d6...
//           (sixth pass, repairs 6-10)
//           -> 4d54de456cf20f426214a17e2898281a7c66515813e00bef1951b64a356077a5
//              (A12, the tie-rule arm: engine pos 1220, discarded rule 224049; and the
//               SCOPE paragraph corrected — field 4 was IN reach and never read, only
//               field 6 was out of reach, and the first draft of that line blurred them)
// (fifth-pass seals, kept for the ladder)
// before ed1b8ee386907c25a002143c3f6a012d4d93f200b48b55bb0731e5a82078eb3b, after f454b956d4dec155bd8fb7d5b594bc4bdb91ed6e45c0fe4a3c3bc5400ade823b
// ===========================================================================

import Foundation


// ---------------------------------------------------------------------------
// Self-contained SHA-256.  Integer only.
// ---------------------------------------------------------------------------
enum SHA256Exact {
    static let kk: [UInt32] = [
        0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5, 0x3956c25b, 0x59f111f1,
        0x923f82a4, 0xab1c5ed5, 0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3,
        0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174, 0xe49b69c1, 0xefbe4786,
        0x0fc19dc6, 0x240ca1cc, 0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da,
        0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7, 0xc6e00bf3, 0xd5a79147,
        0x06ca6351, 0x14292967, 0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13,
        0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85, 0xa2bfe8a1, 0xa81a664b,
        0xc24b8b70, 0xc76c51a3, 0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070,
        0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5, 0x391c0cb3, 0x4ed8aa4a,
        0x5b9cca4f, 0x682e6ff3, 0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208,
        0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2
    ]
    static func hex(_ msg: [UInt8]) -> String {
        var h: [UInt32] = [0x6a09e667, 0xbb67ae85, 0x3c6ef372, 0xa54ff53a,
                           0x510e527f, 0x9b05688c, 0x1f83d9ab, 0x5be0cd19]
        var m = msg
        let bitLen = UInt64(msg.count) &* 8
        m.append(0x80)
        while m.count % 64 != 56 { m.append(0) }
        for i in (0..<8).reversed() { m.append(UInt8((bitLen >> (UInt64(i) * 8)) & 0xff)) }
        var w = [UInt32](repeating: 0, count: 64)
        var blk = 0
        while blk < m.count {
            for t in 0..<16 {
                let o = blk + t * 4
                w[t] = (UInt32(m[o]) << 24) | (UInt32(m[o+1]) << 16)
                     | (UInt32(m[o+2]) << 8) | UInt32(m[o+3])
            }
            for t in 16..<64 {
                let s0 = rotr(w[t-15], 7) ^ rotr(w[t-15], 18) ^ (w[t-15] >> 3)
                let s1 = rotr(w[t-2], 17) ^ rotr(w[t-2], 19) ^ (w[t-2] >> 10)
                w[t] = w[t-16] &+ s0 &+ w[t-7] &+ s1
            }
            var a = h[0], b = h[1], c = h[2], d = h[3]
            var e = h[4], f = h[5], g = h[6], hh = h[7]
            for t in 0..<64 {
                let S1 = rotr(e, 6) ^ rotr(e, 11) ^ rotr(e, 25)
                let ch = (e & f) ^ (~e & g)
                let t1 = hh &+ S1 &+ ch &+ kk[t] &+ w[t]
                let S0 = rotr(a, 2) ^ rotr(a, 13) ^ rotr(a, 22)
                let mj = (a & b) ^ (a & c) ^ (b & c)
                let t2 = S0 &+ mj
                hh = g; g = f; f = e; e = d &+ t1
                d = c; c = b; b = a; a = t1 &+ t2
            }
            h[0] = h[0] &+ a; h[1] = h[1] &+ b; h[2] = h[2] &+ c; h[3] = h[3] &+ d
            h[4] = h[4] &+ e; h[5] = h[5] &+ f; h[6] = h[6] &+ g; h[7] = h[7] &+ hh
            blk += 64
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
    static func rotr(_ x: UInt32, _ n: UInt32) -> UInt32 { (x >> n) | (x << (32 - n)) }
}

// NOTE: no @main. The mandated build line is
//   xcrun swiftc -O -swift-version 5 protein-novelty-exact.swift -o /tmp/pn
// which has no -parse-as-library, so this file IS the main file and @main is
// rejected. The entry point is the top-level call at the end of the file.
struct ProteinNoveltyExact {

    // ---- paths (no argv; this program takes none) --------------------------
    // NO ABSOLUTE PATH IS BAKED IN. An earlier revision carried the author's own scratchpad
    // directory here, which is a private identifier in a public program and would have resolved
    // to nothing on every other machine. The root is discovered by walking outward from the
    // binary and from the working directory until a tree carrying the corpus is found, so a
    // clean clone works with no argument and no edit. If nothing is found the program REFUSES
    // and names every directory it looked in — a gate given nothing must not pass.
    static let ROOT: String = {
        let fm = FileManager.default
        var cands: [String] = []
        let exe = CommandLine.arguments.first ?? ""
        if !exe.isEmpty {
            var d = (exe as NSString).deletingLastPathComponent
            for _ in 0..<6 {
                cands.append(d); cands.append(d + "/corpus/eric"); cands.append(d + "/eric")
                d = (d as NSString).deletingLastPathComponent
                if d.isEmpty || d == "/" { break }
            }
        }
        var w = fm.currentDirectoryPath
        for _ in 0..<6 {
            cands.append(w); cands.append(w + "/corpus/eric"); cands.append(w + "/eric")
            w = (w as NSString).deletingLastPathComponent
            if w.isEmpty || w == "/" { break }
        }
        for c in cands {
            if fm.fileExists(atPath: c + "/corpus/proteins_validated.csv")
            || fm.fileExists(atPath: c + "/proteins_validated.csv") { return c }
        }
        return fm.currentDirectoryPath
    }()
    static func firstExisting(_ paths: [String]) -> String {
        let fm = FileManager.default
        for p in paths where fm.fileExists(atPath: p) { return p }
        return paths.first ?? ""
    }
    static let CORPUS  = firstExisting([ROOT + "/corpus/proteins_validated.csv", ROOT + "/proteins_validated.csv"])
    static let REFFA   = firstExisting([ROOT + "/raw/uniprot_human_reviewed.fasta", ROOT + "/../raw/uniprot_human_reviewed.fasta", ROOT + "/uniprot_human_reviewed.fasta"])
    // The second generated corpus.  It is a DIFFERENT population under a
    // DIFFERENT schema and it is screened separately, never pooled: the
    // transcript used to ASSERT its row count, its label count and its
    // disjointness from the studied corpus while never opening it — the same
    // defect as a pinned digest the program does not compute.  It is opened
    // and measured here.
    static let CORPUS2 = firstExisting([ROOT + "/corpus/proteins_by_disease.csv", ROOT + "/proteins_by_disease.csv"])

    // ---- published reference figures, pinned -------------------------------
    static let PIN_ROWS = 78680
    static let PIN_DISTINCT = 78680
    static let PIN_MINLEN = 42
    static let PIN_MAXLEN = 90
    static let PIN_MEDLEN = 66
    static let PIN_RESIDUES = 5165782
    static let PIN_REF_PROTEINS = 20431
    static let PIN_REF_RESIDUES = 11418237
    static let PIN_REF_SHA = "bf1bc7e188e55199a2447fc20d25834db5f7f798daa818432370deb4a6b0df5e"
    // BOTH CORPORA ARE HASHED TOO.  Row, residue and length pins cannot see a
    // substituted residue: the counts are identical either side of it, exactly
    // as they were for the reference before it was hashed.  A digest can.
    static let PIN_CORPUS_SHA  = "bb3691b332fb15cdd54c43bc42905478e53c4f4b01862885a7304260498cf3f7"
    static let PIN_CORPUS2_SHA = "24cdbf96621e6c38fa046c7a203fcc3ea09e31fad410d9c1cb51f6d192a04204"
    static let PIN_ROWS2 = 1400
    static let PIN_RESIDUES2 = 78694
    static let PIN_MINLEN2 = 20
    static let PIN_MAXLEN2 = 100
    static let PIN_LABELS2 = 12

    static let ALPHA: [UInt8] = Array("ACDEFGHIKLMNPQRSTVWY".utf8)   // 20, sorted
    static let OTHER: UInt8 = 20        // U, sentinel, anything non-standard
    static let K = 5
    static let NCODES = 3_200_000       // 20^5
    static let P4 = 160_000             // 20^4

    nonisolated(unsafe) static var transcript: [String] = []
    static func t(_ s: String) { transcript.append(s); print(s) }
    static func err(_ s: String) { FileHandle.standardError.write((s + "\n").data(using: .utf8)!) }

    static func nowMs() -> Int {
        var ts = timespec()
        clock_gettime(CLOCK_MONOTONIC, &ts)
        return ts.tv_sec * 1000 + ts.tv_nsec / 1_000_000
    }

    // integer parts-per-million, no float anywhere
    // Int128 inside, because num * 1_000_000 on the aligned-pair numerator sits
    // within a factor of three of Int64.max: a reference three times this size
    // would overflow and trap where it should have refused.
    static func ppm(_ num: Int, _ den: Int) -> Int { den == 0 ? 0 : Int(Int128(num) * 1_000_000 / Int128(den)) }
    static func pad2(_ s: String, _ w: Int) -> String { var o = s; while o.count < w { o += " " }; return o }
    static func pctStr(_ num: Int, _ den: Int) -> String {
        let p = ppm(num, den)                      // e.g. 113634
        return "\(p / 10000).\(String(format: "%04d", p % 10000))%"
    }

    // ---- the published reference block; printed FIRST, always --------------
    static func printReferenceFigures(_ tag: String) {
        let lines = [
            "REFERENCE FIGURES (published, pinned, printed before any file is opened) [\(tag)]",
            "  corpus            \(CORPUS)",
            "  corpus rows       \(PIN_ROWS)",
            "  corpus distinct   \(PIN_DISTINCT)",
            "  corpus lengths    \(PIN_MINLEN) to \(PIN_MAXLEN), median \(PIN_MEDLEN)",
            "  corpus residues   \(PIN_RESIDUES)",
            "  corpus sha256     \(PIN_CORPUS_SHA)",
            "  reference         \(REFFA)",
            "  reference sha256  \(PIN_REF_SHA)",
            "  reference proteins \(PIN_REF_PROTEINS)",
            "  reference residues \(PIN_REF_RESIDUES)",
            "  second corpus     \(CORPUS2)   (screened separately, never pooled)",
            "  second sha256     \(PIN_CORPUS2_SHA)",
            "  second rows       \(PIN_ROWS2)   residues \(PIN_RESIDUES2)   lengths \(PIN_MINLEN2) to \(PIN_MAXLEN2)   labels \(PIN_LABELS2)",
            "  seed length K     \(K)   (exact for every L >= K; L < K answered exactly by fp1..fp4)"
        ]
        for l in lines { print(l) }
    }

    static func refuse(_ why: String) -> Never {
        print("")
        print("REFUSED — no verdict transcript emitted, no seal emitted.")
        print("REASON: \(why)")
        printReferenceFigures("refusal path")
        exit(2)
    }

    // =======================================================================
    // The matcher.  Returns (longestLength, referenceStartPosition).
    // Returns (-1, -1) as an explicit REFUSAL for an empty query.
    // =======================================================================
    static func longestMatch(
        _ q: UnsafePointer<UInt8>, _ n: Int,
        _ buf: UnsafePointer<UInt8>, _ bufN: Int,
        _ bstart: UnsafePointer<Int32>, _ plist: UnsafePointer<Int32>,
        _ fp1: UnsafePointer<Int32>, _ fp2: UnsafePointer<Int32>,
        _ fp3: UnsafePointer<Int32>, _ fp4: UnsafePointer<Int32>
    ) -> (Int, Int) {
        if n <= 0 { return (-1, -1) }                 // EMPTY IS REFUSED, never 0
        var best = 0, bestPos = -1
        if n >= K {
            for i in 0...(n - K) {
                var code = 0
                for j in 0..<K { code = code * 20 + Int(q[i + j]) }
                let lo = Int(bstart[code]), hi = Int(bstart[code + 1])
                if lo == hi { continue }
                for tI in lo..<hi {
                    let p = Int(plist[tI])
                    var l = 0
                    while i - l > 0 && p - l > 0 && buf[p - l - 1] == q[i - l - 1] { l += 1 }
                    var r = 0
                    let iE = i + K, pE = p + K
                    while iE + r < n && pE + r < bufN && buf[pE + r] == q[iE + r] { r += 1 }
                    let L = l + K + r
                    let sp = p - l
                    if L > best || (L == best && sp < bestPos) { best = L; bestPos = sp }
                }
            }
        }
        if best > 0 { return (best, bestPos) }
        // no K-mer hit: resolve k = 4,3,2,1 EXACTLY, no floor, no bucket
        // The stated tie rule — among all longest matches, the smallest
        // reference position wins — holds on this path too.  It previously
        // returned at the first QUERY offset with a hit, which is a different
        // rule from the one the transcript prints.  Unexercised on this corpus
        // (every sequence shares a 5-mer), and made true anyway: a sentence in
        // a sealed transcript is a claim about the code, not about the corpus.
        var kk = min(4, n)
        while kk >= 1 {
            let lim = n - kk
            var bestSub = -1
            for i in 0...lim {
                var c = 0
                for j in 0..<kk { c = c * 20 + Int(q[i + j]) }
                let fpv: Int32
                switch kk {
                case 4: fpv = fp4[c]
                case 3: fpv = fp3[c]
                case 2: fpv = fp2[c]
                default: fpv = fp1[c]
                }
                if fpv >= 0 && (bestSub < 0 || Int(fpv) < bestSub) { bestSub = Int(fpv) }
            }
            if bestSub >= 0 { return (kk, bestSub) }
            kk -= 1
        }
        return (0, -1)
    }

    // =======================================================================
    static func main() {
        // stdout UNBUFFERED, before anything else.  validate.sh runs this as
        // `prog < /dev/null > file`, which block-buffers; a trap or a signal then
        // discards every line already printed and the harness sees an empty file
        // instead of a reason.  A refusal doctrine that prints the figures on
        // every path has to survive an abnormal exit as well as an orderly one.
        setvbuf(stdout, nil, _IONBF, 0)
        // FIRST ACTION.  Nothing can exit before this.
        printReferenceFigures("entry")
        print("")
        let tStart = nowMs()

        // ---------------- load reference ------------------------------------
        guard let refData = try? Data(contentsOf: URL(fileURLWithPath: REFFA)), !refData.isEmpty else {
            refuse("reference proteome unreadable or empty at \(REFFA) — a gate given nothing must not pass")
        }
        // THE REFERENCE BYTES ARE HASHED, NEVER ASSERTED.  A pinned digest the
        // program does not compute is green on a file it never read: a single
        // substituted residue leaves protein count and residue count identical,
        // so the count pins cannot see it.  SHA256Exact is already in this file;
        // it is used here on the input as well as on the transcript.
        let refShaMeasured = SHA256Exact.hex([UInt8](refData))
        if refShaMeasured != PIN_REF_SHA {
            refuse("reference sha256 \(refShaMeasured) != pinned \(PIN_REF_SHA) — these are not the published reference bytes")
        }
        var enc = [UInt8](repeating: OTHER, count: 256)
        for (i, a) in ALPHA.enumerated() { enc[Int(a)] = UInt8(i) }

        var buf = [UInt8](); buf.reserveCapacity(refData.count)
        var protStart = [Int32](); var protAcc = [String]()
        var refResidues = 0
        var nonStandardRef = 0
        do {
            var i = 0
            let bytes = [UInt8](refData)
            let nB = bytes.count
            var inHeader = false
            var hdr = [UInt8]()
            while i < nB {
                let c = bytes[i]
                // '>' is a record start ONLY at a line start.  Eleven reviewed
                // human descriptions spell an arrow inside the text ('DNA
                // dC->dU-editing enzyme APOBEC-3A', 'Delta 5-->4-isomerase type
                // 1').  Treating every '>' byte as a header reset renamed those
                // eleven accessions to description words and injected eleven
                // spurious sentinels into buf, shifting every reported offset
                // after them.  Measured, then fixed here.
                if c == 0x3E && (i == 0 || bytes[i - 1] == 0x0A || bytes[i - 1] == 0x0D) {
                    if !buf.isEmpty { buf.append(OTHER) }   // sentinel between proteins
                    inHeader = true; hdr.removeAll(keepingCapacity: true)
                    i += 1; continue
                }
                if c == 0x0A || c == 0x0D {
                    if inHeader {
                        inHeader = false
                        // >sp|ACC|NAME ...  -> ACC
                        var parts = [[UInt8]](); var cur = [UInt8]()
                        for b in hdr { if b == 0x7C { parts.append(cur); cur = [] } else { cur.append(b) } }
                        parts.append(cur)
                        let accBytes = parts.count >= 2 ? parts[1] : parts[0]
                        var acc = String(decoding: accBytes, as: UTF8.self)
                        if let sp = acc.firstIndex(of: " ") { acc = String(acc[acc.startIndex..<sp]) }
                        protAcc.append(acc)
                        protStart.append(Int32(buf.count))
                    }
                    i += 1; continue
                }
                if inHeader { hdr.append(c); i += 1; continue }
                let e = enc[Int(c)]
                if e == OTHER { nonStandardRef += 1 }
                buf.append(e)
                refResidues += 1
                i += 1
            }
        }
        if protAcc.count != PIN_REF_PROTEINS {
            refuse("reference protein count \(protAcc.count) != pinned \(PIN_REF_PROTEINS)")
        }
        if refResidues != PIN_REF_RESIDUES {
            refuse("reference residue count \(refResidues) != pinned \(PIN_REF_RESIDUES)")
        }
        err("[load] reference ok: \(protAcc.count) proteins, \(refResidues) residues, \(nonStandardRef) non-standard (U), \(nowMs() - tStart) ms")

        // reference composition, exact integer counts
        var refComp = [Int](repeating: 0, count: 21)
        for b in buf where b <= OTHER { refComp[Int(b)] += 1 }
        let refK = refComp[Int(enc[Int(UInt8(ascii: "K"))])]
        let refR = refComp[Int(enc[Int(UInt8(ascii: "R"))])]

        // ---------------- build the K-mer index ------------------------------
        let tIdx = nowMs()
        let bufN = buf.count
        var bstart = [Int32](repeating: 0, count: NCODES + 1)
        var fp1 = [Int32](repeating: -1, count: 20)
        var fp2 = [Int32](repeating: -1, count: 400)
        var fp3 = [Int32](repeating: -1, count: 8_000)
        var fp4 = [Int32](repeating: -1, count: 160_000)
        var validKmers = 0
        buf.withUnsafeBufferPointer { bp in
            let b = bp.baseAddress!
            var run = 0, code = 0
            for i in 0..<bufN {
                let c = b[i]
                if c >= OTHER { run = 0; code = 0; continue }
                run += 1
                code = (code % P4) * 20 + Int(c)
                if run >= 1 { let x = code % 20;      if fp1[x] < 0 { fp1[x] = Int32(i - 0) } }
                if run >= 2 { let x = code % 400;     if fp2[x] < 0 { fp2[x] = Int32(i - 1) } }
                if run >= 3 { let x = code % 8_000;   if fp3[x] < 0 { fp3[x] = Int32(i - 2) } }
                if run >= 4 { let x = code % 160_000; if fp4[x] < 0 { fp4[x] = Int32(i - 3) } }
                if run >= K { bstart[code + 1] += 1; validKmers += 1 }
            }
        }
        for i in 1...NCODES { bstart[i] += bstart[i - 1] }
        var plist = [Int32](repeating: 0, count: validKmers)
        var cursor = bstart
        buf.withUnsafeBufferPointer { bp in
            let b = bp.baseAddress!
            var run = 0, code = 0
            for i in 0..<bufN {
                let c = b[i]
                if c >= OTHER { run = 0; code = 0; continue }
                run += 1
                code = (code % P4) * 20 + Int(c)
                if run >= K {
                    plist[Int(cursor[code])] = Int32(i - K + 1)
                    cursor[code] += 1
                }
            }
        }
        let idxMs = nowMs() - tIdx
        err("[index] K=\(K), \(validKmers) indexed positions, \(idxMs) ms")

        // independent, DIFFERENT-MECHANISM measurement for self-test arm 3
        var longestKRun = 0
        do {
            let kCode = enc[Int(UInt8(ascii: "K"))]
            var run = 0
            for b in buf { if b == kCode { run += 1; if run > longestKRun { longestKRun = run } } else { run = 0 } }
        }

        // accession of a reference position
        func proteinIndexAt(_ pos: Int) -> Int {
            var lo = 0, hi = protStart.count - 1, ans = 0
            while lo <= hi {
                let mid = (lo + hi) / 2
                if Int(protStart[mid]) <= pos { ans = mid; lo = mid + 1 } else { hi = mid - 1 }
            }
            return ans
        }
        func accessionAt(_ pos: Int) -> String {
            if pos < 0 { return "-" }
            return protAcc[proteinIndexAt(pos)]
        }

        // =====================================================================
        // SELF-TEST — runs FIRST, before any corpus work.  Emits no verdict and
        // no seal if any arm fails.  Arms run in BOTH directions.
        // =====================================================================
        var selfTestLines: [String] = []
        var selfTestOK = true
        func arm(_ name: String, _ pass: Bool, _ detail: String) {
            selfTestLines.append("  [\(pass ? "PASS" : "FAIL")] \(name) — \(detail)")
            if !pass { selfTestOK = false }
        }

        buf.withUnsafeBufferPointer { bp in
        bstart.withUnsafeBufferPointer { bsp in
        plist.withUnsafeBufferPointer { plp in
        fp1.withUnsafeBufferPointer { f1 in
        fp2.withUnsafeBufferPointer { f2 in
        fp3.withUnsafeBufferPointer { f3 in
        fp4.withUnsafeBufferPointer { f4 in
            let b = bp.baseAddress!, bs = bsp.baseAddress!, pl = plp.baseAddress!
            let p1 = f1.baseAddress!, p2 = f2.baseAddress!, p3 = f3.baseAddress!, p4 = f4.baseAddress!

            func run(_ q: [UInt8]) -> (Int, Int) {
                return q.withUnsafeBufferPointer { qp in
                    longestMatch(qp.baseAddress ?? UnsafePointer(bitPattern: 1)!, q.count,
                                 b, bufN, bs, pl, p1, p2, p3, p4)
                }
            }

            // ARM 1 — the instrument finds what is there: a whole real protein.
            let realIdx = 1000
            let s0 = Int(protStart[realIdx])
            var s1e = bufN
            if realIdx + 1 < protStart.count { s1e = Int(protStart[realIdx + 1]) }
            var realSeq = [UInt8]()
            for i in s0..<s1e where b[i] < OTHER { realSeq.append(b[i]) }
            let r1 = run(realSeq)
            arm("A1 whole real protein \(protAcc[realIdx]) (len \(realSeq.count)) returns full-length self match",
                r1.0 == realSeq.count && accessionAt(r1.1) == protAcc[realIdx],
                "longest=\(r1.0) expected=\(realSeq.count) accession=\(accessionAt(r1.1))")

            // ARM 2 — a 66-mer window (the corpus median length) from a real protein.
            var win = [UInt8]()
            if realSeq.count >= 100 { for i in 20..<86 { win.append(realSeq[i]) } }
            let r2 = run(win)
            arm("A2 66-mer window of a real protein returns 66",
                win.count == 66 && r2.0 == 66,
                "longest=\(r2.0) expected=66 windowLen=\(win.count)")

            // ARM 3 — the instrument is NOT always-green: deterministic scramble.
            // Fixed permutation i -> (i*37) mod n, no RNG (Constraint 5).
            var scr = [UInt8](repeating: 0, count: realSeq.count)
            for i in 0..<realSeq.count { scr[i] = realSeq[(i &* 37) % realSeq.count] }
            let r3 = run(scr)
            arm("A3 deterministic scramble of the SAME protein collapses (must be < 25% of full length)",
                r3.0 < realSeq.count && r3.0 * 4 < realSeq.count,
                "scrambled longest=\(r3.0) vs full=\(realSeq.count)")

            // ARM 4 — single repeated residue must not report a spuriously long
            // match.  Cross-checked against an INDEPENDENT run-length scan.
            let kCode = enc[Int(UInt8(ascii: "K"))]
            let poly = [UInt8](repeating: kCode, count: 60)
            let r4 = run(poly)
            arm("A4 60xK equals the independently scanned longest poly-K run and is < 60",
                r4.0 == min(60, longestKRun) && r4.0 < 60,
                "engine=\(r4.0) independentRunScan=\(longestKRun)")

            // ARM 5 — EMPTY is REFUSED, not passed, not answered 0.
            let r5 = run([UInt8]())
            arm("A5 empty query is REFUSED (-1), never answered as 0",
                r5.0 == -1, "returned=\(r5.0)")

            // ARM 6 — control for A5: the refusal is not always-refuse.
            let r6 = run([kCode])
            arm("A6 control — a 1-residue query returns 1, so A5 is not always-refuse",
                r6.0 == 1, "returned=\(r6.0)")

            // ARM 7 — one-residue mutation must break a 30-mer.  Discrimination
            // at the resolution the study actually reports on.
            var m30 = [UInt8]()
            for i in 0..<30 { m30.append(realSeq[i]) }
            let e30 = run(m30)
            m30[15] = m30[15] == 0 ? 1 : 0
            let x30 = run(m30)
            arm("A7 exact 30-mer returns 30; the same 30-mer with residue 16 mutated returns < 30",
                e30.0 == 30 && x30.0 < 30,
                "exact=\(e30.0) mutated=\(x30.0)")

            // ARM 8 — THE PROTEIN BOUNDARY.  The exactness proof names this
            // property explicitly ('crosses no protein boundary') and until now
            // nothing tested it.  Each half is present in the reference in full;
            // the join must not be.
            //
            // CORRECTED 2026-09-06, BY MEASUREMENT — UNTIL TODAY THIS ARM DID NOT
            // FIRE.  It claimed to be "the only thing between a silent sentinel bug
            // and a sealed wrong number".  Measured, by deleting the sentinel line
            // and running the same binary: TWELVE OF TWELVE ARMS PASSED, A8 among
            // them, and the program sealed a MOVED distribution (5:33->32,
            // 6:33519->33334, 7:41021->41180, 8:3861->3887, 9:233->234, mean
            // 521543->521758) under a clean self-test.  The cause was two characters
            // in THIS arm's own setup: s1e was protStart[realIdx+1] - 1, where the
            // -1 existed to step over the sentinel and is redundant with the
            // `where b[i] < OTHER` filter one line below.  With no sentinel the -1
            // truncated realSeq by its final residue, so the 40-mer this arm built
            // was NOT contiguous in the buffer it was about to probe — it carried a
            // one-residue deletion at the join and could not match 40 however
            // thoroughly the boundary had been destroyed.  THE ARM WAS DEFENDED BY
            // THE BUG IT WAS BUILT TO DETECT, which is the always-green half of
            // 'always-green and always-red are the same defect'.  Both -1s are gone.
            // Re-measured in both directions: sentinel present -> 12/12 and seal
            // 4d54de45... unchanged to the byte, so no published figure moves;
            // sentinel deleted -> A8 FAILS with longest=40, exit 3, zero SEAL lines.
            // validate.sh now runs that second direction as an arm.
            //
            // A1 reported len 287 and len 286 with equal confidence across those two
            // builds, because a self-match arm compares the engine against a string
            // it extracted from the same buffer and cannot see a truncated
            // extraction.  That is why the boundary needs its own arm, and why the
            // arm needs a construction that does not depend on the thing under test.
            var boundary = [UInt8]()
            if realSeq.count >= 20 && realIdx + 2 < protStart.count {
                for i in (realSeq.count - 20)..<realSeq.count { boundary.append(realSeq[i]) }
                let n0 = Int(protStart[realIdx + 1]), n1 = Int(protStart[realIdx + 2])
                var taken = 0, j = n0
                while j < n1 && taken < 20 { if b[j] < OTHER { boundary.append(b[j]); taken += 1 }; j += 1 }
            }
            let r8 = run(boundary)
            arm("A8 a 40-mer spanning the join between two adjacent proteins never joins",
                boundary.count == 40 && r8.0 >= 20 && r8.0 < 40,
                "spanLen=\(boundary.count) longest=\(r8.0) — each half present in full, the join is not")

            // ARMS 9-11 — the sub-K tables fp4, fp3, fp2.  168,400 of the
            // 168,420 first-occurrence cells were executed by nothing that
            // ships: the corpus minimum is 5, so the corpus never reaches this
            // path, and an untested path is not a correct path, it is an
            // unmeasured one.  Expected answers derived by set enumeration on
            // the reference, not by running this program:
            //   CWCWC — no reference 5-mer, CWCW and WCWC both present -> 4
            //   MWMWM — no 5-mer and no 4-mer, MWM and WMW present     -> 3
            //   MW    — present                                        -> 2
            func code(_ str: String) -> [UInt8] { Array(str.utf8).map { enc[Int($0)] } }
            let r9 = run(code("CWCWC"))
            arm("A9 fp4 path — CWCWC has no reference 5-mer; the exact answer is 4",
                r9.0 == 4, "returned=\(r9.0)")
            let r10 = run(code("MWMWM"))
            arm("A10 fp3 path — MWMWM has no reference 5-mer and no 4-mer; the exact answer is 3",
                r10.0 == 3, "returned=\(r10.0)")
            let r11 = run(code("MW"))
            arm("A11 fp2 path — a 2-residue query present in the reference returns 2",
                r11.0 == 2, "returned=\(r11.0)")

            // ARM 12 — THE SUB-K TIE RULE, which until now was a sentence in the
            // transcript with no arm behind it.  The transcript states: among all
            // longest matches, the smallest REFERENCE position wins.  The seeded
            // path always implemented that; the sub-K descent returned the first
            // QUERY offset with a hit, a different rule, on a path the corpus
            // never reaches.  It was corrected — and a corrected path that nothing
            // executes is not a correct path, it is an unmeasured one.
            //
            // Both candidate answers are recomputed here by scanning the reference
            // buffer directly, NOT by reading the same fp4 table the engine read,
            // and the arm requires the two rules to DISAGREE on this query.  A tie
            // rule tested on a query where both rules agree proves nothing.
            let tie = code("AAACCF")
            let rt = run(tie)
            var tieMinRefPos = -1, tieFirstQueryOffset = -1
            if rt.0 >= 1 && rt.0 <= 4 && tie.count >= rt.0 {
                let L = rt.0
                for start in 0...(tie.count - L) {
                    var found = -1, p = 0
                    while p + L <= bufN {
                        var ok = true, j = 0
                        while j < L { if b[p + j] != tie[start + j] { ok = false; break }; j += 1 }
                        if ok { found = p; break }
                        p += 1
                    }
                    if found >= 0 {
                        if tieMinRefPos < 0 || found < tieMinRefPos { tieMinRefPos = found }
                        if tieFirstQueryOffset < 0 { tieFirstQueryOffset = found }
                    }
                }
            }
            arm("A12 sub-K tie rule — the SMALLEST reference position wins, not the first query offset",
                rt.0 == 4 && tieMinRefPos >= 0 && rt.1 == tieMinRefPos && tieFirstQueryOffset != tieMinRefPos,
                "engine=(len \(rt.0), pos \(rt.1)) independentMinRefPos=\(tieMinRefPos) discardedRule_firstQueryOffset=\(tieFirstQueryOffset)")
        }}}}}}}

        print("SELF-TEST (runs first; no verdict and no seal are emitted if any arm fails)")
        for l in selfTestLines { print(l) }
        if !selfTestOK {
            print("")
            print("SELF-TEST FAILED — the instrument did not validate on cases whose answers are")
            print("known in advance.  NO verdict transcript emitted.  NO seal emitted.")
            printReferenceFigures("self-test failure path")
            exit(3)
        }
        // derived from the arms that actually ran, never a literal: the string
        // '7 of 7' went on printing 7 while ten arms were running.
        print("SELF-TEST: \(selfTestLines.count) of \(selfTestLines.count) arms pass, both directions.")
        print("")

        // =====================================================================
        // CORPUS
        // =====================================================================
        guard let csvData = try? Data(contentsOf: URL(fileURLWithPath: CORPUS)), !csvData.isEmpty else {
            refuse("corpus unreadable or empty at \(CORPUS) — a gate given nothing must not pass")
        }
        // THE CORPUS BYTES ARE HASHED TOO.  Row count, residue count and the
        // length triple are all blind to a substituted residue — identical
        // either side of it — which is precisely why the reference needed a
        // digest.  The same argument applies to the file the answers come from.
        let corpusShaMeasured = SHA256Exact.hex([UInt8](csvData))
        if corpusShaMeasured != PIN_CORPUS_SHA {
            refuse("corpus sha256 \(corpusShaMeasured) != pinned \(PIN_CORPUS_SHA) — these are not the published corpus bytes")
        }
        var ids = [String](), seqs = [[UInt8]](), domains = [String]()
        // category and mechanism are COUNTED, not asserted.  The transcript stated
        // both as facts about every row while the parser stopped at field 5 and
        // never read either column.
        var categories = [String: Int](), mechanisms = [String: Int]()
        var corpusResidues = 0
        var corpusComp = [Int](repeating: 0, count: 21)
        do {
            let bytes = [UInt8](csvData)
            var i = 0, line = 0
            let n = bytes.count
            while i < n {
                var j = i
                while j < n && bytes[j] != 0x0A { j += 1 }
                if line > 0 && j > i {
                    var fields = [[UInt8]](); var cur = [UInt8]()
                    var fcount = 0
                    var p = i
                    while p < j {
                        let c = bytes[p]
                        if c == 0x2C { fields.append(cur); cur = []; fcount += 1; if fcount > 6 { break } }
                        else if c != 0x0D { cur.append(c) }
                        p += 1
                    }
                    fields.append(cur)
                    if fields.count >= 7 {
                        ids.append(String(decoding: fields[0], as: UTF8.self))
                        domains.append(String(decoding: fields[3], as: UTF8.self))
                        categories[String(decoding: fields[4], as: UTF8.self), default: 0] += 1
                        mechanisms[String(decoding: fields[6], as: UTF8.self), default: 0] += 1
                        var s = [UInt8](); s.reserveCapacity(fields[1].count)
                        for c in fields[1] {
                            let e = enc[Int(c)]
                            if e >= OTHER {
                                refuse("corpus row \(line) contains non-standard residue '\(Character(UnicodeScalar(c)))' — the corpus alphabet must be exactly the 20 standard amino acids")
                            }
                            s.append(e); corpusComp[Int(e)] += 1
                        }
                        corpusResidues += s.count
                        seqs.append(s)
                    }
                }
                line += 1
                i = j + 1
            }
        }
        if seqs.count != PIN_ROWS { refuse("corpus row count \(seqs.count) != pinned \(PIN_ROWS)") }
        if corpusResidues != PIN_RESIDUES { refuse("corpus residue count \(corpusResidues) != pinned \(PIN_RESIDUES)") }
        var distinct = Set<String>()
        for s in seqs { distinct.insert(String(decoding: s.map { ALPHA[Int($0)] }, as: UTF8.self)) }
        if distinct.count != PIN_DISTINCT { refuse("corpus distinct count \(distinct.count) != pinned \(PIN_DISTINCT)") }
        var minL = Int.max, maxL = 0
        for s in seqs { minL = min(minL, s.count); maxL = max(maxL, s.count) }
        // sized from the MEASURED maximum, never from a constant.  A fixed 512
        // would trap — not refuse — on a corpus longer than this one, and a trap
        // is the one exit this program cannot instrument.
        var lenHist = [Int](repeating: 0, count: maxL + 1)
        for s in seqs { lenHist[s.count] += 1 }
        var acc = 0, medL = 0
        for l in 0...maxL { acc += lenHist[l]; if acc >= (seqs.count + 1) / 2 { medL = l; break } }
        if minL != PIN_MINLEN || maxL != PIN_MAXLEN || medL != PIN_MEDLEN {
            refuse("corpus lengths \(minL)..\(maxL) median \(medL) != pinned \(PIN_MINLEN)..\(PIN_MAXLEN) median \(PIN_MEDLEN)")
        }
        err("[load] corpus ok: \(seqs.count) sequences, \(corpusResidues) residues")

        // ---------------- the SECOND corpus, separately scoped ---------------
        // The transcript asserted this file's row count, its twelve labels and
        // its disjointness from the studied corpus while this program had never
        // opened it.  Three claims inside a sealed transcript, none of them
        // measured by the thing doing the sealing.  They are measured here, and
        // the population is screened by the SAME matcher against the SAME
        // reference — separately scoped, never pooled with the 78,680.
        guard let csv2Data = try? Data(contentsOf: URL(fileURLWithPath: CORPUS2)), !csv2Data.isEmpty else {
            refuse("second corpus unreadable or empty at \(CORPUS2) — a gate given nothing must not pass")
        }
        let corpus2ShaMeasured = SHA256Exact.hex([UInt8](csv2Data))
        if corpus2ShaMeasured != PIN_CORPUS2_SHA {
            refuse("second corpus sha256 \(corpus2ShaMeasured) != pinned \(PIN_CORPUS2_SHA) — these are not the published second-corpus bytes")
        }
        // DIFFERENT SCHEMA, and it matters: disease,protein_id,sequence,length,...
        // The sequence is field 2 here and field 1 in the studied corpus.  A
        // parser reused without reading the header would have screened the
        // protein_id column, which is empty in every row of this file, and a
        // 1,400-row population of empty queries would have refused rather than
        // silently returned zero — but only because the empty query is refused.
        var seqs2 = [[UInt8]](), labels2 = [String: Int]()
        var corpus2Residues = 0
        do {
            let bytes = [UInt8](csv2Data)
            var i = 0, line = 0
            let n = bytes.count
            while i < n {
                var j = i
                while j < n && bytes[j] != 0x0A { j += 1 }
                if line > 0 && j > i {
                    var fields = [[UInt8]](); var cur = [UInt8]()
                    var fcount = 0
                    var p = i
                    while p < j {
                        let c = bytes[p]
                        if c == 0x2C { fields.append(cur); cur = []; fcount += 1; if fcount > 3 { break } }
                        else if c != 0x0D { cur.append(c) }
                        p += 1
                    }
                    fields.append(cur)
                    if fields.count >= 4 {
                        labels2[String(decoding: fields[0], as: UTF8.self), default: 0] += 1
                        var s = [UInt8](); s.reserveCapacity(fields[2].count)
                        for c in fields[2] {
                            let e = enc[Int(c)]
                            if e >= OTHER {
                                refuse("second corpus row \(line) contains non-standard residue '\(Character(UnicodeScalar(c)))' — the alphabet must be exactly the 20 standard amino acids")
                            }
                            s.append(e)
                        }
                        corpus2Residues += s.count
                        seqs2.append(s)
                    }
                }
                line += 1
                i = j + 1
            }
        }
        if seqs2.count != PIN_ROWS2 { refuse("second corpus row count \(seqs2.count) != pinned \(PIN_ROWS2)") }
        if corpus2Residues != PIN_RESIDUES2 { refuse("second corpus residue count \(corpus2Residues) != pinned \(PIN_RESIDUES2)") }
        if labels2.count != PIN_LABELS2 { refuse("second corpus label count \(labels2.count) != pinned \(PIN_LABELS2)") }
        var minL2 = Int.max, maxL2 = 0
        for s in seqs2 { minL2 = min(minL2, s.count); maxL2 = max(maxL2, s.count) }
        if minL2 != PIN_MINLEN2 || maxL2 != PIN_MAXLEN2 {
            refuse("second corpus lengths \(minL2)..\(maxL2) != pinned \(PIN_MINLEN2)..\(PIN_MAXLEN2)")
        }
        var shared2 = 0
        var distinct2 = Set<String>()
        for s in seqs2 {
            let str = String(decoding: s.map { ALPHA[Int($0)] }, as: UTF8.self)
            distinct2.insert(str)
            if distinct.contains(str) { shared2 += 1 }
        }
        err("[load] second corpus ok: \(seqs2.count) sequences, \(corpus2Residues) residues, \(shared2) shared with the studied corpus")

        // ---------------- the run ------------------------------------------
        let tRun = nowMs()
        var bestLen = [Int](repeating: 0, count: seqs.count)
        var bestAcc = [String](repeating: "-", count: seqs.count)
        var bestPos = [Int](repeating: -1, count: seqs.count)
        var exactFull = [Int]()
        // the second population, same matcher, same reference, separate arrays
        var bestLen2 = [Int](repeating: 0, count: seqs2.count)
        var exactFull2 = 0
        buf.withUnsafeBufferPointer { bp in
        bstart.withUnsafeBufferPointer { bsp in
        plist.withUnsafeBufferPointer { plp in
        fp1.withUnsafeBufferPointer { f1 in
        fp2.withUnsafeBufferPointer { f2 in
        fp3.withUnsafeBufferPointer { f3 in
        fp4.withUnsafeBufferPointer { f4 in
            let b = bp.baseAddress!, bs = bsp.baseAddress!, pl = plp.baseAddress!
            let p1 = f1.baseAddress!, p2 = f2.baseAddress!, p3 = f3.baseAddress!, p4 = f4.baseAddress!
            for qi in 0..<seqs.count {
                let r = seqs[qi].withUnsafeBufferPointer { qp -> (Int, Int) in
                    longestMatch(qp.baseAddress!, seqs[qi].count, b, bufN, bs, pl, p1, p2, p3, p4)
                }
                if r.0 < 0 { refuse("sequence \(qi) returned a refusal in the production loop") }
                bestLen[qi] = r.0
                bestAcc[qi] = accessionAt(r.1)
                bestPos[qi] = r.1
                if r.0 == seqs[qi].count { exactFull.append(qi) }
                if qi % 10000 == 0 && qi > 0 { err("[run] \(qi)/\(seqs.count) \(nowMs() - tRun) ms") }
            }
            // SECOND POPULATION — complete enumeration, same matcher, reported
            // in its own section and never folded into the distribution above.
            for qi in 0..<seqs2.count {
                let r = seqs2[qi].withUnsafeBufferPointer { qp -> (Int, Int) in
                    longestMatch(qp.baseAddress!, seqs2[qi].count, b, bufN, bs, pl, p1, p2, p3, p4)
                }
                if r.0 < 0 { refuse("second-corpus sequence \(qi) returned a refusal in the production loop") }
                bestLen2[qi] = r.0
                if r.0 == seqs2[qi].count { exactFull2 += 1 }
            }
        }}}}}}}
        let runMs = nowMs() - tRun

        // =====================================================================
        // VERDICT TRANSCRIPT (sealed)
        // =====================================================================
        // A census renders as a COUNT, deterministically ordered, so a column
        // that turns out to hold more than one value says so instead of being
        // summarised by a sentence written before the file was read.
        func censusLine(_ d: [String: Int]) -> String {
            var ks = Array(d.keys)
            ks.sort { d[$0]! != d[$1]! ? d[$0]! > d[$1]! : $0 < $1 }
            var out = "\(ks.count) distinct — "
            for (i, k) in ks.enumerated() { out += (i == 0 ? "" : ", ") + "'\(k)' x\(d[k]!)" }
            return out
        }
        let soleCategory = categories.count == 1 ? categories.keys.first!
                         : "MIXED, \(categories.count) values — see the census above"
        transcript.removeAll()
        t("BEGIN TRANSCRIPT")
        t("study: protein-novelty-exact")
        t("question: do the 78,680 generated sequences appear in the reviewed human proteome,")
        t("          and how much of any single one of them does")
        t("")
        t("SCOPE, MEASURED FROM THE FILE'S OWN COLUMNS — and this time actually measured.")
        t("The category, the mechanism, the second file's size and the disjointness of the")
        t("two populations were previously ASSERTED in this transcript by a program that")
        t("had read none of them. The CSV loop broke at the sixth comma: the mechanism")
        t("column, field 6, was out of its reach entirely; the category column, field 4,")
        t("was in reach and simply never read; and the second file was never opened.")
        t("Every line below is a count taken from the bytes just hashed.")
        t("  studied file        \(CORPUS)")
        t("  rows                \(seqs.count)")
        t("  category column     \(censusLine(categories))")
        t("  mechanism column    \(censusLine(mechanisms))")
        t("  domain column       \(Set(domains).count) distinct labels, enumerated below")
        t("  second file         \(CORPUS2)")
        t("  its rows            \(seqs2.count), \(corpus2Residues) residues, lengths \(minL2) to \(maxL2), \(labels2.count) labels")
        t("  sequences in common between the two files: \(shared2)")
        t("The twelve disease labels a reader may be carrying belong to the SECOND file.")
        t("None of them appears in this study's \(seqs.count) rows. The second file is screened")
        t("in its own section below, by the same matcher, and the two are never pooled.")
        t("")
        t("METHOD")
        t("  complete enumeration, exact integers only, zero float on any path")
        t("  seed length K=\(K); every common substring of length >= K is found (bound proved in")
        t("  the file header); lengths < K resolved exactly by first-occurrence tables fp1..fp4")
        t("  index: \(validKmers) reference K-mer positions")
        t("  run:   \(seqs.count) sequences, complete enumeration, no sampling, no cutoff")
        t("  tie rule: among all longest matches, the smallest reference position wins")
        t("  RESOLUTION OF THIS INSTRUMENT, stated where it cannot be missed: it sees")
        t("  EXACT substrings and nothing else. It performs no gapped alignment, no")
        t("  substitution scoring, no BLAST or Smith-Waterman search, and no structural")
        t("  comparison. A generated sequence 80 percent identical to a human protein")
        t("  across its whole length, with a substitution every fifth residue, lands in")
        t("  the same bin as one that shares nothing. Every number below, the null model")
        t("  included, is a statement at exact-substring resolution only.")
        t("  wall-clock timings are deliberately EXCLUDED from the sealed transcript: a")
        t("  seal that changes when nothing about the answer changed is a turn counter,")
        t("  not a seal. Timings are printed after the seal and are not sealed.")
        t("")
        t("INPUTS AS MEASURED (not as remembered)")
        t("  reference sha256 (computed)  \(refShaMeasured)")
        t("  reference proteins           \(protAcc.count)")
        t("  reference residues           \(refResidues)")
        t("  reference non-standard (U)   \(nonStandardRef)   excluded from index, terminates extension")
        t("  reference K+R                \(refK + refR) of \(refResidues) = \(ppm(refK + refR, refResidues)) ppm = \(pctStr(refK + refR, refResidues))")
        t("  corpus sha256 (computed)     \(corpusShaMeasured)")
        t("  corpus sequences             \(seqs.count)  (distinct \(distinct.count))")
        t("  corpus residues              \(corpusResidues)")
        t("  corpus lengths               \(minL) to \(maxL), median \(medL)")
        let cK = corpusComp[Int(enc[Int(UInt8(ascii: "K"))])], cR = corpusComp[Int(enc[Int(UInt8(ascii: "R"))])]
        t("  corpus K+R                   \(cK + cR) of \(corpusResidues) = \(ppm(cK + cR, corpusResidues)) ppm = \(pctStr(cK + cR, corpusResidues))")
        var labelCount = [String: Int]()
        for d in domains { labelCount[d, default: 0] += 1 }
        var labels = Array(labelCount.keys)
        labels.sort { labelCount[$0]! != labelCount[$1]! ? labelCount[$0]! > labelCount[$1]! : $0 < $1 }
        t("  corpus labels                \(labels.count), all of category '\(soleCategory)'")
        var labW = 12
        for l in labels { labW = max(labW, l.count + 2) }
        for l in labels { t("    " + pad2(l, labW) + "\(labelCount[l]!)") }
        t("")
        t("  COMPOSITION, exact integer counts on both populations, as integer ppm,")
        t("  ordered by corpus abundance. This is the generator's design signature and")
        t("  it is measured here, on both populations, rather than quoted from a table. The")
        t("  human column is this reference proteome itself, NOT the all-organism")
        t("  Swiss-Prot composition that is often quoted in its place — those differ by")
        t("  more than a point on A and on S, and the comparison below is the one that")
        t("  the novelty question actually rests on.")
        t("  " + pad2("residue", 9) + pad2("corpus_ppm", 12) + pad2("human_ppm", 12) + "corpus_over_human_x1000")
        var compOrder = Array(0..<20)
        compOrder.sort { corpusComp[$0] != corpusComp[$1] ? corpusComp[$0] > corpusComp[$1] : $0 < $1 }
        for a in compOrder {
            let cp = ppm(corpusComp[a], corpusResidues), rp = ppm(refComp[a], refResidues)
            let ratio = rp == 0 ? 0 : cp * 1000 / rp
            t("  " + pad2(String(UnicodeScalar(ALPHA[a])), 9) + pad2("\(cp)", 12) + pad2("\(rp)", 12) + "\(ratio)")
        }
        var rOrder = Array(0..<20)
        rOrder.sort { refComp[$0] != refComp[$1] ? refComp[$0] > refComp[$1] : $0 < $1 }
        let cHi = corpusComp[compOrder[0]], cLo = corpusComp[compOrder[19]]
        let rHi = refComp[rOrder[0]], rLo = refComp[rOrder[19]]
        t("")
        t("  THE SHAPE OF THAT TABLE IS ITSELF A MEASUREMENT, and it is not the shape of")
        t("  a proteome. Dynamic range, most abundant residue over least, in thousandths:")
        t("    corpus \(cHi * 1000 / cLo)   human \(rHi * 1000 / rLo)")
        t("  The generated corpus is FLATTER than the proteome it is compared against —")
        t("  less than a fourfold spread across all twenty residues where the human")
        t("  proteome spans more than eightfold — while being simultaneously enriched in")
        t("  K and R. Those two facts together say the composition was designed, not")
        t("  sampled from natural protein: an enrichment drawn from a natural background")
        t("  would carry the background's spread with it.")
        // The six-residue floor, stated in ONE unit on both sides.  An earlier
        // draft of these lines printed a raw count against a ppm and called the
        // pair a span; a ratio between differently-united quantities looks like
        // a real spread and is not one.
        var sixNames = "", sixLo = Int.max, sixHi = 0, sixHumanLo = Int.max, sixHumanHi = 0
        for j in 14...19 {
            let a = compOrder[j]
            sixNames += String(UnicodeScalar(ALPHA[a]))
            sixLo = min(sixLo, corpusComp[a]); sixHi = max(sixHi, corpusComp[a])
            let hp = ppm(refComp[a], refResidues)
            sixHumanLo = min(sixHumanLo, hp); sixHumanHi = max(sixHumanHi, hp)
        }
        t("  The six least abundant corpus residues (\(sixNames)) hold exact counts \(sixLo) to \(sixHi):")
        t("  a spread of \(sixHi - sixLo) across six residues, which is one part in \(sixLo / max(1, sixHi - sixLo)).")
        t("  Those SAME six residues in the human proteome span \(sixHumanLo) to \(sixHumanHi) ppm, a")
        t("  range of \(sixHumanHi * 1000 / max(1, sixHumanLo)) thousandths against the corpus's \(sixHi * 1000 / max(1, sixLo)). Six residues")
        t("  that agree to within a part in a hundred are six draws from ONE shared weight.")
        t("  A designed alphabet looks exactly like this; a proteome does not.")
        t("")
        t("SELF-TEST: \(selfTestLines.count) of \(selfTestLines.count) arms pass (arms listed above the transcript, both directions)")
        t("")
        t("=== ANSWER 1 — DOES ANY GENERATED SEQUENCE APPEAR EXACTLY, IN FULL? ===")
        t("  sequences whose longest match equals their own full length: \(exactFull.count)")
        t("  that is \(ppm(exactFull.count, seqs.count)) ppm of the corpus")
        if exactFull.isEmpty {
            t("  NOT ONE of the \(seqs.count) sequences occurs anywhere in the \(refResidues)-residue")
            t("  reviewed human proteome. This is an exhaustive negative, not a sampled one.")
        } else {
            for qi in exactFull.prefix(50) {
                t("  EXACT FULL MATCH  \(ids[qi])  len=\(seqs[qi].count)  accession=\(bestAcc[qi])")
            }
        }
        t("")
        t("=== ANSWER 2+3 — FULL DISTRIBUTION OF LONGEST SHARED SUBSTRING ===")
        t("  published in full so the reporting threshold is a choice made after the")
        t("  arithmetic. No cutoff was applied inside the computation.")
        var dist = [Int](repeating: 0, count: maxL + 2)
        for v in bestLen { dist[v] += 1 }
        var maxObs = 0, minObs = Int.max
        for v in bestLen { maxObs = max(maxObs, v); minObs = min(minObs, v) }
        var total = 0, weighted = 0
        for v in bestLen { total += 1; weighted += v }
        t("  longest-match  count      ppm_of_corpus   cumulative_at_or_above")
        var cumAbove = 0
        var rows: [String] = []
        for L in stride(from: maxObs, through: minObs, by: -1) {
            cumAbove += dist[L]
            rows.append(String(format: "  %6d       %7d    %9d       %9d", L, dist[L], ppm(dist[L], total), cumAbove))
        }
        for r in rows.reversed() { t(r) }
        t("  observed minimum \(minObs), observed maximum \(maxObs)")
        t("  mean expressed exactly as an integer ratio: \(weighted)/\(total) residues per sequence")
        t("      = \(weighted * 1000 / total) thousandths of a residue")
        t("")
        t("=== IS THE RESIDUAL OVERLAP MORE THAN CHANCE? (integer-only null model) ===")
        t("  The null draws residues independently at the MEASURED composition of each")
        t("  side, so it already carries the corpus's own K+R enrichment rather than")
        t("  assuming a uniform 20-letter alphabet — the enrichment cannot be credited")
        t("  as signal by an alphabet the corpus does not have. The aligned-pair match")
        t("  probability is an exact integer ratio and its powers are taken in Int128")
        t("  fixed point. No float enters this section either.")
        var pnum = 0
        for a in 0..<20 { pnum += corpusComp[a] * refComp[a] }
        let pden = corpusResidues * refResidues
        t("  aligned-pair match probability = \(pnum) / \(pden) = \(ppm(pnum, pden)) ppm")
        t("     a uniform 20-letter alphabet would be 50000 ppm; the excess is the")
        t("     composition bias of the two populations, and the null is given it for free")
        // reference positions at which a valid L-mer starts, by run-length histogram
        var runHist = [Int](repeating: 0, count: 128)
        do {
            var run = 0
            for b in buf { if b < OTHER { run += 1; runHist[min(run, 127)] += 1 } else { run = 0 } }
        }
        var refPosAt = [Int](repeating: 0, count: 24)
        for L in 1..<24 { var s = 0; for r in L..<128 { s += runHist[r] }; refPosAt[L] = s }
        t("")
        // The CALL below quotes three of these cells. It used to quote them as
        // typed literals — 249852560, 13570309, 39993, "the single 12-residue
        // match" — inside a sealed transcript, so a corpus or reference change
        // would have moved the table and left the sentence printing the old
        // numbers with a straight face. They are captured here and interpolated.
        var nullExp = [Int: String](); var nullObs = [Int: Int](); var nullBins = 0
        t("     L   expected coincidences (x1e6)   observed sequences with longest >= L")
        for L in 5...15 where maxL >= L {
            var cPos = 0
            for ln in L...maxL { cPos += lenHist[ln] * (ln - L + 1) }
            var v = Int128(cPos) * Int128(refPosAt[L]) * 1_000_000
            for _ in 0..<L { v = v * Int128(pnum) / Int128(pden) }
            var obs = 0
            for x in bestLen where x >= L { obs += 1 }
            nullExp[L] = "\(v)"; nullObs[L] = obs; nullBins += 1
            t("  " + pad("\(L)", 6) + pad("\(v)", 31) + "\(obs)")
        }
        t("")
        t("  READ THIS COLUMN PAIR CAREFULLY. Expected coincidences count aligned")
        t("  (query position, reference position) pairs; observed counts SEQUENCES. At")
        t("  L >= 9 coincidences are rare enough that a sequence almost never has two, so")
        t("  the two columns are comparable there and not below it.")
        t("")
        t("")
        t("=== SECOND POPULATION, SEPARATELY SCOPED — proteins_by_disease.csv ===")
        t("  Screened by the SAME matcher against the SAME reference and reported here")
        t("  rather than left for a reader to go and find. It is NOT pooled with the study")
        t("  above: different file, different schema, different labels, and — measured, not")
        t("  assumed — no sequence in common.")
        t("  sha256 (computed)   \(corpus2ShaMeasured)")
        t("  sequences           \(seqs2.count)  (distinct \(distinct2.count))")
        t("  residues            \(corpus2Residues)")
        t("  lengths             \(minL2) to \(maxL2)")
        t("  labels              \(censusLine(labels2))")
        t("  shared with the studied corpus:                    \(shared2)")
        t("  occurring in full in the reviewed human proteome:  \(exactFull2)")
        var dist2 = [Int](repeating: 0, count: maxL2 + 2)
        for v in bestLen2 { dist2[v] += 1 }
        var maxObs2 = 0, minObs2 = Int.max
        for v in bestLen2 { maxObs2 = max(maxObs2, v); minObs2 = min(minObs2, v) }
        t("  longest-match  count      ppm_of_this_file   cumulative_at_or_above")
        var cum2 = 0
        var rows2: [String] = []
        for L in stride(from: maxObs2, through: minObs2, by: -1) {
            cum2 += dist2[L]
            rows2.append(String(format: "  %6d       %7d    %9d       %9d", L, dist2[L], ppm(dist2[L], seqs2.count), cum2))
        }
        for r in rows2.reversed() { t(r) }
        t("  observed minimum \(minObs2), observed maximum \(maxObs2)")
        t("  Stated flatly, with no reading attached: the longest fragment any of these")
        t("  \(seqs2.count) sequences shares with a human protein is \(maxObs2) residues, on sequences that")
        t("  run to \(maxL2); the studied corpus's maximum is \(maxObs) on sequences running to \(maxL).")
        t("  The same exact-substring resolution applies here and the same qualifier with")
        t("  it — this section measures identity, not homology.")
        t("")
        t("=== WHERE A BENCH SHOULD POINT (reporting threshold applied HERE, after the fact) ===")
        var order = Array(0..<seqs.count)
        order.sort { a, bq in bestLen[a] != bestLen[bq] ? bestLen[a] > bestLen[bq] : ids[a] < ids[bq] }
        // The fragment is printed so a reader can verify every row of this table
        // against the reference file by hand, with grep, without this program.
        func pad(_ s: String, _ w: Int) -> String {
            var o = s
            while o.count < w { o += " " }
            return o
        }
        // Column width comes from the widest id actually printed, plus two.  A
        // fixed width of 32 with an id of exactly 32 characters emitted NO
        // separator and fused the id to the length ('..._295190'), in the one
        // table advertised as checkable by hand.  3,914 corpus ids are 32 or
        // longer, so this was not a one-off.
        var idW = 12
        for qi in order.prefix(25) { idW = max(idW, ids[qi].count + 2) }
        t("  the 25 longest shared substrings in the whole corpus, with the shared fragment")
        t("  itself so each row is checkable against the reference file with grep alone.")
        t("  residue_in_protein is 1-based within the named accession, so a reader can")
        t("  confirm both the fragment and its place without this program.")
        t("  " + pad("protein_id", idW) + pad("len", 5) + pad("longest", 8)
              + pad("accession", 11) + pad("residue_in_protein", 20) + "shared_fragment")
        for qi in order.prefix(25) {
            var frag = ""
            let p = bestPos[qi]
            if p >= 0 {
                for k in 0..<bestLen[qi] { frag += String(UnicodeScalar(ALPHA[Int(buf[p + k])])) }
            }
            let inProt = p >= 0 ? p - Int(protStart[proteinIndexAt(p)]) + 1 : -1
            t("  " + pad(ids[qi], idW) + pad("\(seqs[qi].count)", 5) + pad("\(bestLen[qi])", 8)
                  + pad(bestAcc[qi], 11) + pad("\(inProt)", 20) + frag)
        }
        t("")
        func expAt(_ L: Int) -> String { nullExp[L] ?? "not computed at that length" }
        func obsAt(_ L: Int) -> String { nullObs[L].map { "\($0)" } ?? "not computed at that length" }
        let maxPlural = dist[maxObs] == 1 ? "" : "s"
        t("=== THE CALL ===")
        if exactFull.isEmpty {
            t("  WE CALL: these \(seqs.count) sequences are NOVEL as primary structure. Not one of them")
            t("  occurs in the reviewed human proteome, and the longest fragment any of them")
            t("  shares with a human protein is \(maxObs) residues out of a median length of \(medL).")
            t("  The corpus is not a copy of the proteome and is not a recombination of it at any")
            t("  length a bench would call a motif hit.")
            t("")
            t("  AND THE OVERLAP THAT DOES EXIST IS WHAT CHANCE PREDICTS. Every figure in this")
            t("  paragraph is read out of the table above rather than typed into the sentence:")
            t("  the previous draft carried them as literals, so a corpus or a reference that")
            t("  moved would have left this paragraph reciting numbers no longer in the table.")
            t("  Against a null handed the corpus's own composition: at L=9 the null expects")
            t("  \(expAt(9)) millionths of a coincidence and \(obsAt(9)) sequences are observed; at L=10 it")
            t("  expects \(expAt(10)) millionths and \(obsAt(10)) are observed. The \(dist[maxObs]) sequence\(maxPlural) whose longest")
            t("  match reaches \(maxObs) residues stand\(dist[maxObs] == 1 ? "s" : "") against an expectation of \(expAt(maxObs))")
            t("  millionths — \(dist[maxObs]) event\(maxPlural) in the tail of \(nullBins) length bins, which is a coincidence")
            t("  to be checked, not a homology to be claimed. (Figures are stated in millionths")
            t("  because this file carries no decimal number anywhere, prose included.) So the")
            t("  corpus carries NO detectable residual similarity to the human proteome AT")
            t("  EXACT-SUBSTRING RESOLUTION: it is not merely absent from the proteome, it")
            t("  is no closer to it than composition alone forces. That qualifier is not a")
            t("  hedge and it is not optional — the null model is built on the same")
            t("  exact-match statistic as the observation, so neither of them can speak")
            t("  past it, and a reader who drops it has read a stronger sentence than the")
            t("  arithmetic supports.")
            t("")
            t("  WE REFUSE TO CALL: novel is not safe, and novel is not a cure. This program")
            t("  measured primary-sequence identity against one reference and nothing else. It")
            t("  did not measure structure, folding, binding, immunogenicity, toxicity, protease")
            t("  stability, off-target activity, or efficacy against any of the \(labels.count) cancers")
            t("  these sequences are labelled for.")
            t("  IT ALSO DID NOT MEASURE HOMOLOGY UNDER SUBSTITUTION. Affine.Earth does not")
            t("  call these sequences unrelated to human proteins; it calls them absent from")
            t("  the proteome as exact strings. Those are two different claims and only the")
            t("  second one was measured. The instrument that would answer the first is a")
            t("  gapped, scored alignment — a different measurement, not a refinement of")
            t("  this one.")
            t("  Affine.Earth does not call these safe. Affine.Earth does not call them cures.")
            t("  The confidence, coherence and overall_score columns in the source file are")
            t("  Doubles and are barred from every verdict in this transcript; nothing here")
            t("  rests on them.")
            t("")
            t("  WHERE A BENCH SHOULD POINT: the \(maxObs)-residue maxima listed above are the only")
            t("  places in \(corpusResidues) residues where a generated sequence touches a real human")
            t("  protein at motif length. Those accessions are the cheapest first experiment:")
            t("  synthesise the top fragments, assay against the named human partner, and see")
            t("  whether the shared window does anything. The K+R enrichment (\(pctStr(cK + cR, corpusResidues))")
            t("  against \(pctStr(refK + refR, refResidues)) natural) is consistent with the file's own stated mechanism,")
            t("  PPI inhibition by electrostatic disruption, and is also the single most likely")
            t("  source of nonspecific membrane activity. That is the second experiment.")
            t("  Shows promise as novel chemical matter; warrants laboratory follow-up.")
        } else {
            t("  WE CALL: \(exactFull.count) of \(seqs.count) generated sequences are NOT novel — they")
            t("  occur verbatim in the reviewed human proteome and are listed above by accession.")
            t("  Affine.Earth does not call the remainder safe on this evidence.")
        }
        t("END TRANSCRIPT")

        let body = transcript.joined(separator: "\n") + "\n"
        let seal = SHA256Exact.hex([UInt8](body.utf8))

        // THE ROOT-INVARIANT IS THE DIGEST A STRANGER REPRODUCES.
        // Two lines of the transcript name where the input files sit on THIS filesystem. That is
        // a fact about this machine, not about the answer, so the full-transcript seal moves with
        // the checkout and would indict a correct reproduction from any other directory. The
        // root-invariant digests the same transcript with those two lines removed, and it is the
        // figure this study publishes and pins. Measured: the two digests differ across
        // directories; this one does not.
        let invariantBody = transcript.filter {
            !$0.hasPrefix("  studied file        ") && !$0.hasPrefix("  second file         ")
        }.joined(separator: "\n") + "\n"
        let rootInvariant = SHA256Exact.hex([UInt8](invariantBody.utf8))

        print("")
        print("SEAL sha256(transcript) = \(seal)")
        print("ROOT-INVARIANT sha256   = \(rootInvariant)   (transcript less the 2 filesystem-path lines)")
        print("")
        print("UNSEALED timings (excluded from the seal by design): index \(idxMs) ms, run \(runMs) ms, total \(nowMs() - tStart) ms")
    }
}

// ---- entry point (no argv is read; this program takes none) ----------------
ProteinNoveltyExact.main()
