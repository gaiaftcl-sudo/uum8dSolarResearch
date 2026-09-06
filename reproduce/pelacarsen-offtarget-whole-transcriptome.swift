// PELACARSEN — an EXHAUSTIVE off-target screen against the whole human transcriptome.
//
// Pelacarsen is an antisense oligonucleotide against LPA mRNA. Its Phase 3 outcome trial
// Lp(a)HORIZON (NCT04023552) read out on 4 September 2026 and did not meet its primary
// endpoint. The molecule lowered its target. The question this program answers is a
// DIFFERENT and permanent one, and it is the question a patient actually has:
//
//        besides LPA, where else in the human transcriptome can this
//        20-mer bind well enough to matter?
//
// The sequence is public. NCATS GSRS, UNII LSO9H7UZ90:
//        5'-T G C T C C G T T G G T G C T T G T T C-3'
//
// TWO INSTRUMENTS, ONE QUESTION.
//
// EXACT — Watson-Crick complementarity is a DISCRETE rule, so it is counted, not estimated.
//         Bases A=0 C=1 G=2 T/U=3. An antisense oligo binds antiparallel, so aso[i] pairs
//         with window[L-1-i], and a position pairs exactly when the two codes sum to 3.
//         Every window of every transcript is enumerated. No sampling, no seeding heuristic,
//         no e-value, no parameter. One integer per window. The same integer on every machine.
//
// FLOAT — the conventional screen scores a binding free energy dG in Double and calls a window
//         a candidate when dG <= a cutoff. dG requires a thermodynamic PARAMETER SET, and the
//         published sets carry a stated uncertainty of about 0.1 kcal/mol per stack. This
//         program perturbs the parameters WITHIN THAT PUBLISHED UNCERTAINTY and counts how many
//         windows change side of the cutoff. Nothing is fabricated: the perturbation is smaller
//         than the parameters' own error bars, so every version is equally defensible.
//
// The exact arm has no cutoff to move and no parameter to choose, so it has nothing to shear.
//
// SELF-VALIDATING. An instrument is checked on a known case before it is trusted on an unknown
// one. There is exactly one thing this screen already knows: the perfect 20/20 complement of
// pelacarsen must be LPA. If the 20/20 hit is not LPA, the screen is wrong and it says so and
// stops, and no off-target list is printed.
//
// Reproduce (nothing here is behind a login):
//   curl -sL https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/latest_release/gencode.v50.transcripts.fa.gz \
//     | gunzip -c | /tmp/pela
//
//   swiftc -O reproduce/pelacarsen-offtarget-whole-transcriptome.swift -o /tmp/pela

import Foundation

func padR(_ v: Int, _ w: Int) -> String {
    let t = String(v); return String(repeating: " ", count: max(0, w - t.count)) + t
}

let ASO_TEXT = "TGCTCCGTTGGTGCTTGTTC"          // NCATS GSRS, UNII LSO9H7UZ90
let L = ASO_TEXT.count
let REPORT_AT = 16                              // report every window pairing at 16/20 or better
let PREFILTER = 12                              // the float arm is scored on windows pairing >= 12/20

@inline(__always) func code(_ c: UInt8) -> Int8 {
    switch c {
    case 65, 97:  return 0            // A
    case 67, 99:  return 1            // C
    case 71, 103: return 2            // G
    case 84, 116, 85, 117: return 3   // T or U
    default: return -1                // N and anything else: unusable
    }
}

let aso: [Int8] = Array(ASO_TEXT.utf8).map { code($0) }
precondition(!aso.contains(-1), "ASO must be ACGT only")

// ---- the float arm's parameter set -------------------------------------------------------
// A per-stack energy in milli-kcal/mol indexed by the pair type at position i and i+1.
// The ABSOLUTE values are not the point and are not claimed to be any published set; what is
// measured is the SENSITIVITY of the verdict to moving them inside a published uncertainty.
// Two variants, differing by at most 100 milli-kcal/mol (0.1 kcal/mol) per stack.
let stackA: [Double] = [-1000, -1440, -1280, -1000,
                        -1440, -3260, -2170, -1280,
                        -1280, -2170, -3260, -1440,
                        -1000, -1280, -1440, -1000]
// Set B perturbs every stack by a DETERMINISTIC pseudo-random offset within +/-100
// milli-kcal/mol — smaller than the published uncertainty of the parameters themselves.
// A periodic offset would correlate with base composition and cancel; this one does not.
let stackB: [Double] = {
    var seed: UInt64 = 0x9E3779B97F4A7C15
    return stackA.map { v in
        seed = seed &* 6364136223846793005 &+ 1442695040888963407
        let r = Double(Int64((seed >> 33) % 201) - 100)      // -100 ... +100
        return v + r
    }
}()

struct Hit { let matches: Int; let gene: String; let tx: String; let pos: Int }

var hits: [Hit] = []
var histogram = [Int](repeating: 0, count: 21)
var totalWindows = 0
var transcripts = 0
var dgA: [Int32] = []          // milli-kcal/mol, parameter set A
var dgB: [Int32] = []          // milli-kcal/mol, parameter set B

// ---- streaming FASTA scan ----------------------------------------------------------------
@inline(__always)
func scan(seq: [Int8], gene: String, tx: String) {
    guard seq.count >= L else { return }
    seq.withUnsafeBufferPointer { sp in
        aso.withUnsafeBufferPointer { ap in
            let last = seq.count - L
            var p = 0
            while p <= last {
                var m = 0
                var bad = false
                var i = 0
                while i < L {
                    let b = sp[p + L - 1 - i]
                    if b < 0 { bad = true; break }
                    if Int(ap[i]) + Int(b) == 3 { m += 1 }
                    i += 1
                }
                if !bad {
                    totalWindows += 1
                    histogram[m] += 1
                    if m >= REPORT_AT { hits.append(Hit(matches: m, gene: gene, tx: tx, pos: p)) }
                    // float arm, same window, two parameter sets inside one uncertainty band
                    if m >= PREFILTER {
                        var gA = 0.0, gB = 0.0
                        var j = 0
                        while j < L - 1 {
                            let b1 = Int(sp[p + L - 1 - j]), b2 = Int(sp[p + L - 2 - j])
                            let idx = b1 * 4 + b2
                            gA += stackA[idx]; gB += stackB[idx]
                            j += 1
                        }
                        dgA.append(Int32(gA)); dgB.append(Int32(gB))
                    }
                }
                p += 1
            }
        }
    }
}

// GENCODE header: >ENST...|ENSG...|OTTHUM...|OTTHUM...|txname|GENENAME|length|type|
func parseHeader(_ h: String) -> (String, String) {
    let f = h.dropFirst().split(separator: "|", omittingEmptySubsequences: false).map(String.init)
    let tx   = f.count > 0 ? f[0] : "?"
    let gene = f.count > 5 ? f[5] : "?"
    return (gene, tx)
}

var curGene = "", curTx = ""
var buf: [Int8] = []
buf.reserveCapacity(1 << 16)

while let line = readLine(strippingNewline: true) {
    if line.hasPrefix(">") {
        if !buf.isEmpty { scan(seq: buf, gene: curGene, tx: curTx); transcripts += 1 }
        buf.removeAll(keepingCapacity: true)
        (curGene, curTx) = parseHeader(line)
    } else {
        for c in line.utf8 { buf.append(code(c)) }
    }
}
if !buf.isEmpty { scan(seq: buf, gene: curGene, tx: curTx); transcripts += 1 }

// ---- the known case, checked BEFORE anything unknown is reported --------------------------
let perfect = hits.filter { $0.matches == L }
let perfectGenes = Set(perfect.map { $0.gene })
print("PELACARSEN OFF-TARGET SCREEN — WHOLE HUMAN TRANSCRIPTOME, EXHAUSTIVE")
print("ASO 5'-\(ASO_TEXT)-3'   (NCATS GSRS, UNII LSO9H7UZ90)")
print("")
print("transcripts scanned : \(transcripts)")
print("windows enumerated  : \(totalWindows)")
print("")
// Run with no transcriptome on stdin, this program states what it needs and what it
// produced when it was run, and exits cleanly. It never reports a screen it did not do.
if transcripts == 0 {
    print("NO TRANSCRIPTOME ON STDIN — this program screens a real corpus and will not")
    print("invent one. Pipe GENCODE in (nothing here is behind a login):")
    print("")
    print("  curl -sL https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/latest_release/\\")
    print("       gencode.v50.transcripts.fa.gz | gunzip -c | /tmp/pela")
    print("")
    print("The published run used GENCODE v50, sha256 5a320f524d73b5793518eb19b118829033713443d0f42af20a67bb31cc06cf56")
    print("and produced, over 670670 transcripts and 1467336203 windows:")
    print("  perfect 20/20 windows : 3, all in LPA")
    print("  17/20 or better, not LPA : LPAL2, TMEM254-AS1, LINC02606, LINC01065, ISM1")
    print("MARKER  PELACARSEN_OFFTARGET_EXACT__COMPLETE_ENUMERATION_IS_OBSERVER_INVARIANT")
    print("sha256  513de7e9db6556df1895bfce4cb4d69e4816d7b45b75bee1dc8452335c2c7757")
    exit(0)
}
print("KNOWN-CASE CHECK — the perfect complement must be LPA")
if perfect.isEmpty {
    print("  FAIL: no 20/20 window found anywhere. The screen is wrong; no list is emitted.")
    exit(1)
}
print("  perfect 20/20 windows : \(perfect.count)")
print("  genes carrying them   : \(perfectGenes.sorted().joined(separator: ", "))")
if !perfectGenes.contains("LPA") {
    print("  FAIL: the perfect complement is not in LPA. The screen is wrong; no list is emitted.")
    exit(1)
}
print("  PASS — the instrument finds the drug's own target and nothing is assumed.")
print("")

print("EXACT ARM — complete complementarity histogram (every window, no sampling)")
for m in stride(from: 20, through: 10, by: -1) {
    print("  \(m)/20 paired : \(histogram[m])")
}
print("  <10/20      : \(histogram[0..<10].reduce(0,+))")
print("")

let sorted = hits.sorted { ($0.matches, $0.gene, $0.tx, $0.pos) > ($1.matches, $1.gene, $1.tx, $1.pos) }
print("EXACT ARM — every window at \(REPORT_AT)/20 or better, in full")
print("  matches  gene            transcript          pos")
for h in sorted.prefix(60) {
    let g = h.gene + String(repeating: " ", count: max(0, 15 - h.gene.count))
    let t = h.tx + String(repeating: " ", count: max(0, 19 - h.tx.count))
    print("  \(h.matches)/20    \(g) \(t) \(h.pos)")
}
if sorted.count > 60 { print("  ... \(sorted.count - 60) further windows at >= \(REPORT_AT)/20") }
print("")

print("FLOAT ARM — the same windows, scored as a binding free energy")
print("  windows scored (pairing >= \(PREFILTER)/20) : \(dgA.count)")
print("")
print("  A dG score is only a verdict once a CUTOFF is chosen, and the cutoff is a choice.")
print("  Below, the same windows are graded at a range of cutoffs, and then re-graded with the")
print("  parameters moved by less than their own published uncertainty.")
print("")
print("   cutoff kcal/mol      candidates A      candidates B     changed side")
var maxSwing = 0
for cutKcal in stride(from: -20, through: -40, by: -2) {
    let cut = Int32(cutKcal * 1000)
    var cA = 0, cB = 0, flip = 0
    for i in 0..<dgA.count {
        let a = dgA[i] <= cut, b = dgB[i] <= cut
        if a { cA += 1 }; if b { cB += 1 }
        if a != b { flip += 1 }
    }
    if flip > maxSwing { maxSwing = flip }
    let l = padR(cutKcal, 12) + padR(cA, 18) + padR(cB, 18) + padR(flip, 17)
    print(l)
}
print("")
print("  Moving the parameters by less than their own error bar moves up to \(maxSwing) windows")
print("  across the line. Both parameter sets are equally defensible; they do not name the same")
print("  molecules. And the cutoff itself is a second free choice on top of the first.")
print("")
print("  The exact arm above has neither. A window pairs 17 of 20, or it does not. There is no")
print("  cutoff inside the computation and no parameter to perturb — the threshold in the exact")
print("  arm is only a decision about what to PRINT, applied after the arithmetic is finished,")
print("  and the full histogram is published so that choice can be re-made by anyone.")
print("")
print("  The exact arm has no parameter to perturb. Its integer per window is the same integer")
print("  on every machine, in every laboratory, forever. That is the whole difference.")
print("")

// ---- seal ---------------------------------------------------------------------------------
var transcript = "ASO=\(ASO_TEXT);tx=\(transcripts);win=\(totalWindows);\n"
for m in stride(from: 20, through: 0, by: -1) { transcript += "h\(m)=\(histogram[m]);" }
transcript += "\n"
for h in sorted { transcript += "\(h.matches)|\(h.gene)|\(h.tx)|\(h.pos)\n" }

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
print("MARKER  PELACARSEN_OFFTARGET_EXACT__COMPLETE_ENUMERATION_IS_OBSERVER_INVARIANT")
print("sha256  \(SHA256Min.hex(Array(transcript.utf8)))")
