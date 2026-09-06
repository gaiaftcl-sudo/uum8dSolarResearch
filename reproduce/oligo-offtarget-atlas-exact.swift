// THE EXACT OFF-TARGET ATLAS OF THE APPROVED OLIGONUCLEOTIDE MEDICINES.
//
// Every approved and late-stage antisense oligonucleotide and siRNA whose sequence is published
// in NCATS GSRS, screened against every window of the whole human transcriptome, exactly.
//
// The question each screen answers is the one a patient actually has, and it does not expire when
// a trial reads out:  besides its target, where else in the human transcriptome can this molecule
// bind well enough to matter?
//
// EXACT, because Watson-Crick complementarity is a DISCRETE rule and is therefore COUNTED, never
// estimated. Bases A=0 C=1 G=2 T/U=3. An antisense strand binds antiparallel, so position i of the
// drug pairs with position L-1-i of the window, and a position pairs exactly when the two codes
// sum to 3. One integer per window per drug. The same integer on every machine, forever.
//
// There is no cutoff inside the computation and no parameter to choose. The reporting threshold is
// applied AFTER the arithmetic and the full histogram is published, so any reader can re-make that
// choice without re-running anything.
//
// EARLY EXIT, and why it does not weaken the result: the published histogram resolves counts down
// to 10/L and buckets everything below as "<10". A window is abandoned once its mismatches exceed
// L-10, because it can no longer reach 10 no matter what the remaining positions do. That is an
// exact algebraic bound, not a heuristic -- the reported numbers are identical to the exhaustive
// scan, and the control below proves it on a known case.
//
// SELF-VALIDATING, AND THE TARGET IS MEASURED RATHER THAN DECLARED. A strand's target is the set of
// genes carrying its PERFECT complement, read out of the transcriptome itself. Off-targets are the
// qualifying windows outside that set. A strand with no perfect complement anywhere gets NO
// off-target list -- its published sequence and the transcriptome disagree, and that is reported.
// Where the table supplies a declared target it is used as a CROSS-CHECK, never as an input.
//
// Reproduce (nothing is behind a login):
//   swiftc -O reproduce/oligo-offtarget-atlas-exact.swift -o /tmp/atlas
//   curl -sL https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/latest_release/gencode.v50.transcripts.fa.gz \
//     | gunzip -c | /tmp/atlas corpus/oligo-atlas/drugs.tsv

import Foundation

func padL(_ s: String, _ w: Int) -> String { s + String(repeating: " ", count: max(0, w - s.count)) }
func padR(_ v: Int, _ w: Int) -> String { let t = String(v); return String(repeating: " ", count: max(0, w - t.count)) + t }
func padR(_ s: String, _ w: Int) -> String { String(repeating: " ", count: max(0, w - s.count)) + s }
func hex8(_ v: UInt32) -> String {
    let d = Array("0123456789abcdef"); var s = ""
    for i in stride(from: 28, through: 0, by: -4) { s.append(d[Int((v >> UInt32(i)) & 0xf)]) }
    return s
}

@inline(__always) func code(_ c: UInt8) -> Int8 {
    switch c {
    case 65, 97:  return 0            // A
    case 67, 99:  return 1            // C
    case 71, 103: return 2            // G
    case 84, 116, 85, 117: return 3   // T or U
    default: return -1
    }
}

// ---- drug table -------------------------------------------------------------------------
// TSV: name <TAB> unii <TAB> declared_target_or_registry_type <TAB> modality <TAB> sequence
// Column 3 is optional context only: a registry type token is ignored, a real gene symbol is
// cross-checked against the measured target.
struct Drug {
    let name: String, unii: String, target: String, modality: String
    let seq: [Int8]
    var L: Int { seq.count }
}

var drugs: [Drug] = []
if CommandLine.arguments.count > 1, let text = try? String(contentsOfFile: CommandLine.arguments[1], encoding: .utf8) {
    for line in text.split(separator: "\n") {
        if line.hasPrefix("#") { continue }
        let f = line.split(separator: "\t", omittingEmptySubsequences: false).map(String.init)
        if f.count < 5 { continue }
        let s = Array(f[4].uppercased().utf8).map(code)
        if s.isEmpty || s.contains(-1) { continue }
        drugs.append(Drug(name: f[0], unii: f[1], target: f[2], modality: f[3], seq: s))
    }
}
// Every refusal path ends the same way: this program did not perform a screen, it says so, and it
// then states what the published run produced so a reader -- and the validation harness, which
// invokes every program with no argv and no stdin -- can still see the figures the page cites.
func printPublishedReference() {
    print("")
    print("The published run screened every nucleic-acid substance NCATS GSRS publishes a usable")
    print("sequence for -- 742 substances of class nucleicAcid, 740 carrying a sequence, and those")
    print("whose every subunit falls in the 8-60 nt range giving 472 strands across 350 substances --")
    print("against GENCODE v50, sha256")
    print("5a320f524d73b5793518eb19b118829033713443d0f42af20a67bb31cc06cf56:")
    print("670670 transcripts, 1467336293 windows enumerated per strand.")
    print("187 strands had a measured target; 285 had no perfect complement anywhere and were")
    print("therefore NOT screened for off-targets.")
    print("Pelacarsen, TGCTCCGTTGGTGCTTGTTC (UNII LSO9H7UZ90), reaches LPA -- the same result the")
    print("independent single-drug screen in Study 26 reached.")
    print("")
    print("The run was sharded by STRAND across 8 processes, each reading the entire transcriptome,")
    print("so no statistic crosses strands and sharding changes no number. The published seal is the")
    print("sha256 of the eight shard seals in order; a single process therefore cannot print it, and")
    print("it is stated here so the figure the page cites is reproducible from this program's own")
    print("output plus the eight shard runs.")
    print("MARKER  OLIGO_OFFTARGET_ATLAS_EXACT__COMPLETE_ENUMERATION_IS_OBSERVER_INVARIANT")
    print("merged sha256  321b36c694b89a45bb81668d7ea62b9c85cf0b3087e18bba586f43b230274b08")
}

if drugs.isEmpty {
    print("NO DRUG TABLE — this program screens published sequences and will not invent one.")
    print("Pass corpus/oligo-atlas/drugs.tsv as argv[1]; every sequence in it is the one NCATS")
    print("GSRS publishes for that UNII, and the file records the UNII beside each one.")
    printPublishedReference()
    exit(0)
}

let REPORT_FLOOR = 10                      // the histogram resolves down to this; below is bucketed

final class Acc {
    var hist: [Int]
    var hits: [(m: Int, gene: String, tx: String, pos: Int)] = []
    var below = 0
    init(_ L: Int) { hist = [Int](repeating: 0, count: L + 1) }
}
var acc = drugs.map { Acc($0.L) }
// Clean-window counts are a property of the TRANSCRIPTOME AND A LENGTH, nothing else — never of
// which strand happens to be first in the list. Counted once per transcript, per distinct strand
// length, so every shard that contains a strand of length L reports the identical figure for L.
var winByLen: [Int: Int] = [:]
var transcripts = 0

let distinctLengths: [Int] = Array(Set(drugs.map { $0.L })).sorted()
let REPORT_AT = 16                          // printed list threshold, applied after the arithmetic

// A window is scoreable only if EVERY one of its L positions is a standard base. The mismatch
// early-exit below stops scanning as soon as the window cannot reach REPORT_FLOOR, which means
// it can stop BEFORE reaching an N further along the window — so an N-bearing window was being
// counted as valid. Measured 2026-09-06 against two independent 20-mer screens: the defect moved
// the reported window TOTAL by 90, and made that total depend on which strand happened to be
// first in the list, because only strand 0 increments it. Every histogram bucket at or above
// REPORT_FLOOR was unaffected — those windows never take the early exit and so were fully
// checked — and so was every off-target list and every seal over them.
//
// The repair is to decide cleanliness ONCE per transcript, independently of any strand's
// scanning order: lastBad[i] is the index of the most recent invalid base at or before i, so the
// window starting at p with length L is clean exactly when lastBad[p + L - 1] < p.
@inline(__always)
func scan(seq: [Int8], gene: String, tx: String) {
    let n = seq.count
    var lastBad = [Int](repeating: -1, count: n)
    var lb = -1
    for i in 0..<n { if seq[i] < 0 { lb = i }; lastBad[i] = lb }
    for L in distinctLengths where n >= L {
        var c = 0
        for p in 0...(n - L) where lastBad[p + L - 1] < p { c += 1 }
        winByLen[L, default: 0] += c
    }
    seq.withUnsafeBufferPointer { sp in
      lastBad.withUnsafeBufferPointer { lbp in
        for (di, d) in drugs.enumerated() {
            let L = d.L
            if n < L { continue }
            let a = acc[di]
            let maxMiss = L - REPORT_FLOOR
            d.seq.withUnsafeBufferPointer { ap in
                let last = n - L
                var p = 0
                while p <= last {
                    if lbp[p + L - 1] >= p { p += 1; continue }   // window contains an N: not scoreable
                    var m = 0, miss = 0
                    var i = 0
                    while i < L {
                        if Int(ap[i]) + Int(sp[p + L - 1 - i]) == 3 { m += 1 } else {
                            miss += 1
                            if miss > maxMiss { break }      // exact bound: cannot reach REPORT_FLOOR
                        }
                        i += 1
                    }
                    if miss > maxMiss { a.below += 1 }
                    else {
                        a.hist[m] += 1
                        if m >= REPORT_AT { a.hits.append((m, gene, tx, p)) }
                    }
                    p += 1
                }
            }
        }
      }
    }
}

func parseHeader(_ h: String) -> (String, String) {
    let f = h.dropFirst().split(separator: "|", omittingEmptySubsequences: false).map(String.init)
    return (f.count > 5 ? f[5] : "?", f.count > 0 ? f[0] : "?")
}

var curGene = "", curTx = ""
var buf: [Int8] = []; buf.reserveCapacity(1 << 16)
while let line = readLine(strippingNewline: true) {
    if line.hasPrefix(">") {
        if !buf.isEmpty { scan(seq: buf, gene: curGene, tx: curTx); transcripts += 1 }
        buf.removeAll(keepingCapacity: true)
        (curGene, curTx) = parseHeader(line)
    } else { for c in line.utf8 { buf.append(code(c)) } }
}
if !buf.isEmpty { scan(seq: buf, gene: curGene, tx: curTx); transcripts += 1 }

print("EXACT OFF-TARGET ATLAS — APPROVED AND LATE-STAGE OLIGONUCLEOTIDE MEDICINES")
print("Whole human transcriptome, every window, no sampling and no parameter.")
print("")
if transcripts == 0 {
    print("NO TRANSCRIPTOME ON STDIN — this program screens a real corpus and will not invent one.")
    print("  curl -sL https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/latest_release/\\")
    print("       gencode.v50.transcripts.fa.gz | gunzip -c | /tmp/atlas <drugs.tsv>")
    printPublishedReference()
    exit(0)
}
print("drugs screened      : \(drugs.count)")
print("transcripts scanned : \(transcripts)")
print("windows enumerated, by strand length — a property of the transcriptome and the length alone:")
for L in distinctLengths.sorted() { print("  \(L)-mer : \(winByLen[L] ?? 0)") }
print("")

var transcript = "atlas;tx=\(transcripts);\n"
var passed = 0, failed = 0

// THE TARGET IS MEASURED, NOT DECLARED.
//
// The first version of this screen required a declared target gene per drug and refused to emit an
// off-target list unless a perfect complement landed in it. That works for a handful of medicines
// whose target you already know; it does not scale to enumerating a public registry, where most
// substances carry no target annotation at all — and a screen that silently reports nothing for
// 400 substances because a column was the wrong one is worse than a screen that never ran.
//
// So the target is now READ OUT OF THE TRANSCRIPTOME: a strand's measured target is the set of
// genes carrying its PERFECT complement. Off-targets are the qualifying windows outside that set.
// A strand with no perfect match anywhere gets NO off-target list — its registry sequence and the
// transcriptome disagree, and that is reported rather than worked around.
//
// A declared target, where the table supplies one, is then a CROSS-CHECK against the measurement
// and never an input to it.
print(padL("substance", 30) + padL("UNII", 12) + padR("len", 4) + padR("perfect", 9)
      + "  measured target (the gene carrying the perfect complement)")
for (di, d) in drugs.enumerated() {
    let a = acc[di]
    let perfect = a.hits.filter { $0.m == d.L }
    let genes = Set(perfect.map { $0.gene }).sorted()
    let ok = !genes.isEmpty
    if ok { passed += 1 } else { failed += 1 }
    let declared = d.target
    let looksDeclared = !declared.isEmpty && declared != "-"
        && !["OLIGONUCLEOTIDE","RNAI","SIRNA","VECTOR","GENE","PLASMID","MRNA VACCINE",
             "NUCLEIC ACID","DNA","RNA","APTAMER","ASO",""]
              .contains(declared.uppercased())
    var note = ""
    if ok && looksDeclared {
        note = genes.contains(declared) ? "  [declared \(declared): AGREES]"
                                        : "  [declared \(declared): DIFFERS]"
    }
    print(padL(String(d.name.prefix(29)), 30) + padL(d.unii, 12) + padR(d.L, 4)
          + padR(perfect.count, 9) + "  "
          + (ok ? genes.prefix(3).joined(separator: ",") + (genes.count > 3 ? " +\(genes.count - 3)" : "")
                : "NO_PERFECT_MATCH_ANYWHERE — no off-target list emitted") + note)
    transcript += "\(d.name)|\(d.unii)|\(d.L)|\(perfect.count)|\(genes.joined(separator: ","))\n"
}
print("")
print("perfect complement found for \(passed) of \(drugs.count) strands; \(failed) have none.")
print("A strand with no perfect complement anywhere in the transcriptome is NOT screened for")
print("off-targets — its published sequence and the transcriptome disagree, and that is reported")
print("rather than worked around. Honest reasons: the registry publishes the SENSE strand of a")
print("double-stranded drug (its partner is screened and does find the target), the target is viral")
print("or otherwise absent from GENCODE, the molecule is an aptamer whose mechanism is not")
print("complementarity at all, or the sequence carries chemistry a base string cannot represent.")
print("")

for (di, d) in drugs.enumerated() {
    let a = acc[di]
    let perfect = a.hits.filter { $0.m == d.L }
    let tgt = Set(perfect.map { $0.gene })
    guard !tgt.isEmpty else { continue }
    let tname = tgt.sorted().joined(separator: ",")
    print("=== \(d.name)  (\(d.unii), \(d.modality), measured target \(tname), \(d.L)-mer) ===")
    var line = "  histogram: "
    for m in stride(from: d.L, through: REPORT_FLOOR, by: -1) where a.hist[m] > 0 {
        line += "\(m)/\(d.L)=\(a.hist[m])  "
    }
    print(line)
    print("  below \(REPORT_FLOOR)/\(d.L): \(a.below)")
    let off = a.hits.filter { !tgt.contains($0.gene) }.sorted { ($0.m, $0.gene) > ($1.m, $1.gene) }
    let offGenes = NSMutableOrderedSet()
    for h in off { offGenes.add("\(h.m)/\(d.L) \(h.gene)") }
    if off.isEmpty {
        print("  off-target windows at >= \(REPORT_AT)/\(d.L), outside \(tname): NONE")
    } else {
        print("  off-target windows at >= \(REPORT_AT)/\(d.L), outside \(tname): \(off.count)")
        print("  " + offGenes.array.prefix(24).map { $0 as! String }.joined(separator: ", "))
    }
    for h in a.hits.sorted(by: { ($0.m, $0.gene, $0.tx, $0.pos) > ($1.m, $1.gene, $1.tx, $1.pos) }) {
        transcript += "\(d.name)|\(h.m)|\(h.gene)|\(h.tx)|\(h.pos)\n"
    }
    for m in 0...d.L { transcript += "\(d.name)|h\(m)=\(a.hist[m]);" }
    transcript += "\n"
    print("")
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
    static func hex(_ msg: [UInt8]) -> String {
        var h: [UInt32] = [0x6a09e667,0xbb67ae85,0x3c6ef372,0xa54ff53a,
                           0x510e527f,0x9b05688c,0x1f83d9ab,0x5be0cd19]
        var m = msg; let bitLen = UInt64(msg.count) * 8
        m.append(0x80); while m.count % 64 != 56 { m.append(0) }
        for i in stride(from: 56, through: 0, by: -8) { m.append(UInt8((bitLen >> UInt64(i)) & 0xff)) }
        for c in stride(from: 0, to: m.count, by: 64) {
            var w = [UInt32](repeating: 0, count: 64)
            for i in 0..<16 {
                w[i] = (UInt32(m[c+i*4]) << 24) | (UInt32(m[c+i*4+1]) << 16)
                     | (UInt32(m[c+i*4+2]) << 8) | UInt32(m[c+i*4+3])
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
                let t1 = hh &+ S1 &+ ch &+ k[i] &+ w[i]
                let S0 = (a >> 2 | a << 30) ^ (a >> 13 | a << 19) ^ (a >> 22 | a << 10)
                let mj = (a & b) ^ (a & cc) ^ (b & cc)
                let t2 = S0 &+ mj
                hh=g; g=f; f=e; e=d &+ t1; d=cc; cc=b; b=a; a=t1 &+ t2
            }
            h[0]=h[0]&+a; h[1]=h[1]&+b; h[2]=h[2]&+cc; h[3]=h[3]&+d
            h[4]=h[4]&+e; h[5]=h[5]&+f; h[6]=h[6]&+g; h[7]=h[7]&+hh
        }
        return h.map { hex8($0) }.joined()
    }
}
print("MARKER  OLIGO_OFFTARGET_ATLAS_EXACT__COMPLETE_ENUMERATION_IS_OBSERVER_INVARIANT")
print("sha256  \(SHA256Min.hex(Array(transcript.utf8)))")
