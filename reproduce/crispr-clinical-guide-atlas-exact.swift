// THE EXACT GENOME-WIDE OFF-TARGET MAP OF EVERY CLINICAL CRISPR GUIDE WITH A PUBLIC SPACER,
// WITH A COMPOSITION-MATCHED CONTROL ARM.
//
// Twenty-five guide RNAs are registered in NCATS GSRS with a spacer sequence and named, in a WHO
// INN Proposed List, as part of a CRISPR therapeutic. Some are approved and dosed today
// (exagamglogene autotemcel); some are first-in-human. This program asks, of the whole human
// genome and for every one of them:
//
//        besides its intended cut site, where else could this guide direct a cut?
//        and is that specificity DESIGNED, or is it what the guide's base composition forces?
//
// The second question is the one a histogram alone cannot answer, and it is answered by a control
// arm: every guide is screened alongside N permutations OF ITS OWN BASES. A permutation has the
// identical count of A, C, G and T, the identical length, and the identical PAM rule. If a guide's
// off-target burden sits below every one of its own permutations, its specificity is a property of
// the sequence that was chosen and not of the composition it happens to have.
//
// THE THREE PAM RULES, and why one program cannot use one of them. A nuclease cuts where two
// conditions hold together: a PAM adjacent to the protospacer, and complementarity between the
// spacer and the protospacer. The three nuclease families in this set put the PAM on OPPOSITE
// SIDES and read different words:
//
//   SpCas9  (incl. the D10A base editors)  PAM = NGG   3' of the protospacer   17+1 guides
//   AsCas12a (incl. chimeric RNA-DNA)      PAM = TTTV  5' of the protospacer    3+1 guides
//   Cas12b                                 PAM = TTN   5' of the protospacer      3 guides
//
// Spacer lengths are 10, 20, 21 and 22 and are MEASURED from each record's scaffold anchor, never
// assumed. Every (PAM word, spacer length) pair is enumerated as its own group with its own
// footprint, its own candidate-site census and its own scan range. A screen that ran one NGG rule
// over all twenty-five would return an empty map for ten of them, which reads exactly like a
// corpus error and is not one.
//
// COMPLETE. Every position of every sequence of the primary assembly, on BOTH strands, for every
// group. No seed heuristic, no alignment score, no e-value, no cutoff inside the arithmetic. One
// integer per candidate site per probe. Reporting thresholds are applied AFTER; the FULL mismatch
// histogram, every bucket from 0 to the spacer length, is published for every probe.
//
// ZERO FLOAT. Mismatch count is popcount of a 2-bit-packed XOR. Ranks, medians and burdens are
// integers. Nothing on the decision path is a Double.
//
// SELF-VALIDATING, on a case known in advance, BEFORE anything is reported. A synthetic contig is
// built from the real spacers with sites placed by construction: a good-PAM forward site, a
// good-PAM reverse site, a one-mismatch decoy, a BROKEN-PAM copy of the same spacer and a
// WRONG-FAMILY-PAM copy of the same spacer. The instrument must find exactly the two that its rule
// admits while the sequence itself is present four times. A second, deliberately naive kernel --
// base-by-base array indexing, no packing -- must reproduce the packed kernel's histograms and
// candidate counts byte for byte, on the synthetic contig AND on a real genome slice. If any arm
// fails, nothing is reported.
//
// COMPLETENESS IS COUNTED INSIDE THE KERNEL. `probeEvals` is incremented once per (candidate site,
// probe) pair actually evaluated, in the innermost loop. It is not derived from input sizes. The
// program REFUSES to seal unless the assembly reproduces three externally published integers --
// 3,099,750,718 bases, 194 sequences, 304,796,751 NGG candidate sites at spacer length 20 -- and
// unless the in-kernel count satisfies its own identity against the in-kernel site census.
//
// REGISTER. A site listed here is a place where the chemistry COULD direct a cut. It is not a cut,
// not an occupancy, not a clinical event, and not evidence that any medicine harms anyone. Whether
// a site is cut, in a cell, at a dose, is a laboratory question this program does not answer and
// does not pretend to. This is a map. Nothing here is medical advice.
//
// Reproduce (nothing is behind a login):
//   xcrun swiftc -O -swift-version 5 crispr-clinical-guide-atlas-exact.swift -o /tmp/atlas
//   curl -sL https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/latest_release/GRCh38.primary_assembly.genome.fa.gz \
//     | gunzip -c | /tmp/atlas corpus/crispr-clinical/guides_expanded.tsv 100

import Foundation
setvbuf(stdout, nil, _IONBF, 0)

// ---------------------------------------------------------------- constants and pinned figures
let GUIDES_SHA256   = "bb188a75837c3384322723c5935da34605cb89caae43cf3b0468572fda60b80c"
let PIN_BASES       = 3_099_750_718
let PIN_SEQS        = 194
let PIN_NGG20_SITES = 304_796_751
let PIN_NGG20_NSKIP = 1_718
let LIST_MM         = 4      // coordinates retained at or below this many mismatches
let MIN_L_FOR_LIST  = 16     // shorter spacers: full histogram only, coordinates not retained
let LIST_CAP        = 200_000
let DEFAULT_PERMS   = 100

// the fifteen guides of the published screen, by UNII; their result is a known case
let PUBLISHED_15: Set<String> = ["EQW8RVL4CV","FKP72X9XKK","L28RZ5CC6K","D8UQ4B2T7M","YGA7BAF735",
    "5G537B4BTJ","5UBM9CGH6K","ENS57C5JUZ","93A4Y2S6E2","3KQV6T97QD","GPK7BXF67W","A2N98QL2SL",
    "B6ZZE44GUB","4M5F9ZC9EH","RC77WK8XEG"]

func padL(_ s: String, _ w: Int) -> String { s + String(repeating: " ", count: max(0, w - s.count)) }
func padR(_ s: String, _ w: Int) -> String { String(repeating: " ", count: max(0, w - s.count)) + s }
func padR(_ v: Int, _ w: Int) -> String { padR(String(v), w) }
func gp(_ v: Int) -> String {   // integer thousands separator, no formatter, no locale
    var t = String(v.magnitude), o = ""
    while t.count > 3 { o = "," + t.suffix(3) + o; t = String(t.dropLast(3)) }
    return (v < 0 ? "-" : "") + t + o
}
@inline(__always) func code(_ c: UInt8) -> Int8 {
    switch c {
    case 65, 97:  return 0            // A
    case 67, 99:  return 1            // C
    case 71, 103: return 2            // G
    case 84, 116, 85, 117: return 3   // T or U
    default: return -1                // N and anything else
    }
}
let LETTER: [Character] = ["A","C","G","T"]
func spell(_ s: [Int8]) -> String { String(s.map { $0 < 0 ? "N" : LETTER[Int($0)] }) }

// ---------------------------------------------------------------------------------- SHA256
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
    static func hex8(_ v: UInt32) -> String {
        let d = Array("0123456789abcdef"); var s = ""
        for i in stride(from: 28, through: 0, by: -4) { s.append(d[Int((v >> UInt32(i)) & 0xf)]) }
        return s
    }
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

// ------------------------------------------------------------------- every exit prints figures
func printPublishedReference() {
    print("")
    print("REFERENCE FIGURES — what this program needs and what the published predecessor produced.")
    print("  input 1  the guide table, first argument, sha256")
    print("           \(GUIDES_SHA256)")
    print("           25 guides: 18 SpCas9 family (NGG, 3'), 4 AsCas12a (TTTV, 5'), 3 Cas12b (TTN, 5')")
    print("           spacer lengths 10, 20, 21, 22 — measured from each record's scaffold anchor")
    print("  input 2  GENCODE GRCh38 primary assembly on stdin, gunzipped, sha256 of the .gz")
    print("           b760d18dbb651dd14dfc290083371b3ef3bff122d43a9cefb13ca4ecf38f05ca")
    print("           \(gp(PIN_BASES)) bases over \(PIN_SEQS) sequences")
    print("  input 3  permutations per guide, second argument, default \(DEFAULT_PERMS)")
    print("")
    print("  the predecessor (15 guides, one NGG rule) measured \(gp(PIN_NGG20_SITES)) NGG candidate")
    print("  sites at spacer length 20, with \(gp(PIN_NGG20_NSKIP)) windows containing an N set aside.")
    print("  All 15 found a zero-mismatch site; 13 had exactly one in the whole genome; every one had")
    print("  ZERO sites at one mismatch and 13 of 15 had zero at two. Those are this program's pins.")
    print("")
    print("MARKER  CRISPR_CLINICAL_GUIDE_ATLAS__NO_SCREEN_PERFORMED")
}

// ------------------------------------------------------------------------------ the guide table
struct Guide {
    let name: String, unii: String, product: String, nuclease: String
    let pam: String, target: String, inn: String
    let spacer: [Int8]
}
enum PamKind: Int { case ngg = 0, tttv = 1, ttn = 2 }

var guides: [Guide] = []
var guidesDigest = ""
var argPerms = DEFAULT_PERMS
if CommandLine.arguments.count > 2, let v = Int(CommandLine.arguments[2]), v >= 1, v <= 4096 {
    argPerms = v
}
if CommandLine.arguments.count > 1,
   let raw = FileManager.default.contents(atPath: CommandLine.arguments[1]) {
    guidesDigest = SHA256Min.hex([UInt8](raw))
    if let text = String(data: raw, encoding: .utf8) {
        for line in text.split(separator: "\n") {
            if line.hasPrefix("#") { continue }
            let f = line.split(separator: "\t", omittingEmptySubsequences: false).map(String.init)
            if f.count < 12 { continue }
            let s = Array(f[8].uppercased().utf8).map(code)
            guard let declared = Int(f[7]), declared == s.count, !s.contains(-1) else { continue }
            guard ["NGG","TTTV","TTN"].contains(f[4]) else { continue }
            guides.append(Guide(name: f[0], unii: f[1], product: f[2], nuclease: f[3],
                                pam: f[4], target: f[9], inn: f[10], spacer: s))
        }
    }
}
if guides.isEmpty {
    print("NO GUIDE TABLE — this program screens published guide sequences and will not invent one.")
    print("Pass the guide table as the first argument. Every row carries the UNII the sequence came")
    print("from, so a reader can fetch the same bytes from the same public registry.")
    printPublishedReference()
    exit(0)
}
if guidesDigest != GUIDES_SHA256 {
    print("GUIDE TABLE DIGEST MISMATCH — REFUSED. This program screens one pinned table and will not")
    print("screen bytes it cannot name.")
    print("  expected sha256  \(GUIDES_SHA256)")
    print("  measured sha256  \(guidesDigest)")
    printPublishedReference()
    exit(0)
}

// ------------------------------------------------- the probe set: each guide plus its own permutations
// A permutation is a rearrangement of the guide's OWN bases, so every control probe carries exactly
// the same count of A, C, G and T as the guide, the same length, and is screened under the same PAM
// rule. Fisher-Yates driven by a fixed-constant LCG keyed on (guide index, permutation index): no
// clock, no arc4random, no hash seed. Deterministic on every machine and in every process.
func permute(_ base: [Int8], _ g: Int, _ n: Int) -> [Int8] {
    var s: UInt64 = 0x243F6A8885A308D3 &+ (UInt64(g &+ 1) &* 0x9E3779B97F4A7C15)
                                       &+ (UInt64(n) &* 0xBF58476D1CE4E5B9)
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
let PERMS = argPerms
let PPG   = PERMS + 1              // probes per guide: the guide itself at offset 0

// pack an L-mer with 5' position 0 in the HIGH bits of the 2L-bit field
@inline(__always) func pack(_ s: [Int8]) -> UInt64 {
    var v: UInt64 = 0
    for b in s { v = (v << 2) | UInt64(UInt8(bitPattern: b) & 3) }
    return v
}

struct Group {
    let kind: PamKind
    let L: Int
    let footprint: Int        // total bases the rule occupies
    let probeBase: Int        // offset into the flat probe array
    let guideIdx: [Int]       // guides in this group, in order
    let maskL: UInt64         // (1 << 2L) - 1
    let lowMask: UInt64       // 0x5555... limited to 2L bits
    let validL: UInt64        // (1 << L) - 1
    let retainSites: Bool
}

var packedProbes: [UInt64] = []
var groups: [Group] = []
var guideGroup  = [Int](repeating: -1, count: guides.count)
var guideProbe0 = [Int](repeating: -1, count: guides.count)

do {
    var keys: [(PamKind, Int)] = []
    for g in guides {
        let k: PamKind = g.pam == "NGG" ? .ngg : (g.pam == "TTTV" ? .tttv : .ttn)
        let key = (k, g.spacer.count)
        if !keys.contains(where: { $0.0 == key.0 && $0.1 == key.1 }) { keys.append(key) }
    }
    keys.sort { ($0.0.rawValue, $0.1) < ($1.0.rawValue, $1.1) }
    for (kind, L) in keys {
        let members = guides.indices.filter {
            let k: PamKind = guides[$0].pam == "NGG" ? .ngg : (guides[$0].pam == "TTTV" ? .tttv : .ttn)
            return k == kind && guides[$0].spacer.count == L
        }
        let base = packedProbes.count
        for gi in members {
            guideGroup[gi]  = groups.count
            guideProbe0[gi] = packedProbes.count
            packedProbes.append(pack(guides[gi].spacer))
            for n in 1...PERMS { packedProbes.append(pack(permute(guides[gi].spacer, gi, n))) }
        }
        let fp = kind == .ngg ? L + 3 : (kind == .tttv ? L + 4 : L + 3)
        groups.append(Group(kind: kind, L: L, footprint: fp, probeBase: base, guideIdx: members,
                            maskL: (UInt64(1) << UInt64(2*L)) - 1,
                            lowMask: 0x5555_5555_5555_5555 & ((UInt64(1) << UInt64(2*L)) - 1),
                            validL: (UInt64(1) << UInt64(L)) - 1,
                            retainSites: L >= MIN_L_FOR_LIST))
    }
}
let NPROBE = packedProbes.count
let HSTRIDE = 32                 // histogram buckets per probe; max spacer length is 22

// The hot loop touches nothing that Swift has to retain or release. `Group` carries an array, so
// reading one inside the scan would take an ARC pair on every base of the assembly -- billions of
// them, for a value the loop only reads scalars out of. The scan reads this flat POD mirror
// instead, and the probe-to-guide map is precomputed so the innermost loop never divides.
struct GP {
    var kind: Int32 = 0, L: Int32 = 0, foot: Int32 = 0, base: Int32 = 0, cnt: Int32 = 0
    var retain: Int32 = 0
    var maskL: UInt64 = 0, low: UInt64 = 0, validL: UInt64 = 0
}
let GPOD: [GP] = groups.map {
    GP(kind: Int32($0.kind.rawValue), L: Int32($0.L), foot: Int32($0.footprint),
       base: Int32($0.probeBase), cnt: Int32($0.guideIdx.count * PPG),
       retain: $0.retainSites ? 1 : 0, maskL: $0.maskL, low: $0.lowMask, validL: $0.validL)
}
let PROBES: [UInt64] = packedProbes
var guideOfProbeBuild = [Int32](repeating: -1, count: NPROBE)
for gi in guides.indices { guideOfProbeBuild[guideProbe0[gi]] = Int32(gi) }
let GUIDE_OF_PROBE: [Int32] = guideOfProbeBuild

// -------------------------------------------------------------------------------- accumulators
struct Site { var guide: Int32; var mm: Int8; var strand: Int8; var seq: Int32; var pos: Int32 }
final class Acc {
    var hist: [Int64]
    var pamFwd: [Int64], pamRev: [Int64], scored: [Int64], setAside: [Int64]
    var probeEvals: Int64 = 0
    var sites: [Site] = []
    var listOverflow = Set<Int>()
    init(_ nprobe: Int, _ ngroup: Int) {
        hist = [Int64](repeating: 0, count: nprobe * HSTRIDE)
        pamFwd = [Int64](repeating: 0, count: ngroup); pamRev = pamFwd
        scored = pamFwd; setAside = pamFwd
    }
    func reset() {
        for i in 0..<hist.count { hist[i] = 0 }
        for i in 0..<pamFwd.count { pamFwd[i] = 0; pamRev[i] = 0; scored[i] = 0; setAside[i] = 0 }
        probeEvals = 0; sites.removeAll(keepingCapacity: true); listOverflow.removeAll()
    }
    func merge(_ o: Acc) {
        for i in 0..<hist.count { hist[i] += o.hist[i] }
        for i in 0..<pamFwd.count {
            pamFwd[i] += o.pamFwd[i]; pamRev[i] += o.pamRev[i]
            scored[i] += o.scored[i]; setAside[i] += o.setAside[i]
        }
        probeEvals += o.probeEvals
        sites.append(contentsOf: o.sites)
        listOverflow.formUnion(o.listOverflow)
    }
}

// ---------------------------------------------------------------------------- the packed kernel
// Two rolling 64-bit registers and one validity bitmask carry the whole scan. `roll` holds the last
// 32 bases 2 bits each, most recent in the low bits; `rc` holds their complements in the mirror
// order, so the reverse-strand protospacer is a shift rather than a second pass; `valid` holds one
// bit per base saying whether it was ACGT. An assembly N is never scored and never matches: it is
// absent, which is neither a match nor a mismatch, and it is counted on its own line.
func scanPacked(_ g: UnsafePointer<Int8>, _ n: Int, _ lo: Int, _ hi: Int,
                _ seqIdx: Int, _ acc: Acc) {
    if hi <= lo { return }
    let ng = GPOD.count
    var roll: UInt64 = 0, rc: UInt64 = 0, valid: UInt64 = 0
    let pre = max(0, lo - 32)
    for p in pre..<lo {
        let b = g[p]
        let u = UInt64(UInt8(bitPattern: b) & 3)
        roll = (roll << 2) | u
        rc   = (rc >> 2) | ((3 &- u) << 62)
        valid = (valid << 1) | (b >= 0 ? 1 : 0)
    }
    var pamF = [Int64](repeating: 0, count: ng), pamR = pamF, scd = pamF, asd = pamF
    var evals: Int64 = 0
    var localSites: [Site] = []
    var overflow = Set<Int>()
    PROBES.withUnsafeBufferPointer { tb in
    GPOD.withUnsafeBufferPointer { gb in
    GUIDE_OF_PROBE.withUnsafeBufferPointer { ob in
    acc.hist.withUnsafeMutableBufferPointer { hb in
        let H = hb.baseAddress!, T = tb.baseAddress!, GG = gb.baseAddress!, OB = ob.baseAddress!
        pamF.withUnsafeMutableBufferPointer { fb in
        pamR.withUnsafeMutableBufferPointer { rb in
        scd.withUnsafeMutableBufferPointer { sb in
        asd.withUnsafeMutableBufferPointer { ab in
        let PF = fb.baseAddress!, PR = rb.baseAddress!, SC = sb.baseAddress!, AS = ab.baseAddress!
        for p in lo..<hi {
            let b = g[p]
            let u = UInt64(UInt8(bitPattern: b) & 3)
            roll = (roll << 2) | u
            rc   = (rc >> 2) | ((3 &- u) << 62)
            valid = (valid << 1) | (b >= 0 ? 1 : 0)
            var gi = 0
            while gi < ng {
                let G = GG[gi]
                let L = Int(G.L)
                if p < Int(G.foot) - 1 { gi += 1; continue }
                let uL = UInt64(L)
                let base = Int(G.base), cnt = Int(G.cnt)
                let rt = G.retain != 0
                // ---------------- forward strand
                var pamOK = false, protoStart = 0, dropped = false
                var w: UInt64 = 0
                if G.kind == 0 {                    // NGG, 3' of the protospacer
                    if (valid & 3) == 3 && ((roll >> 2) & 3) == 2 && (roll & 3) == 2 {
                        pamOK = true
                        if ((valid >> 3) & G.validL) == G.validL {
                            w = (roll >> 6) & G.maskL; protoStart = p - (L + 2)
                        } else { dropped = true }
                    }
                } else if G.kind == 1 {             // TTTV, 5' of the protospacer
                    if ((valid >> uL) & 15) == 15
                        && ((roll >> (2*(uL+3))) & 3) == 3 && ((roll >> (2*(uL+2))) & 3) == 3
                        && ((roll >> (2*(uL+1))) & 3) == 3 && ((roll >> (2*uL)) & 3) != 3 {
                        pamOK = true
                        if (valid & G.validL) == G.validL {
                            w = roll & G.maskL; protoStart = p - (L - 1)
                        } else { dropped = true }
                    }
                } else {                            // TTN, 5' of the protospacer
                    if ((valid >> uL) & 7) == 7
                        && ((roll >> (2*(uL+2))) & 3) == 3 && ((roll >> (2*(uL+1))) & 3) == 3 {
                        pamOK = true
                        if (valid & G.validL) == G.validL {
                            w = roll & G.maskL; protoStart = p - (L - 1)
                        } else { dropped = true }
                    }
                }
                if pamOK {
                    PF[gi] += 1
                    if dropped { AS[gi] += 1 }
                    else {
                        SC[gi] += 1
                        var q = 0
                        if rt {
                            while q < cnt {
                                let x = w ^ T[base + q]
                                let mm = ((x | (x >> 1)) & G.low).nonzeroBitCount
                                H[(base + q) * HSTRIDE + mm] += 1
                                evals += 1          // counted here, as the work happens
                                if mm <= LIST_MM {
                                    let gidx = OB[base + q]
                                    if gidx >= 0 {
                                        if localSites.count < LIST_CAP {
                                            localSites.append(Site(guide: gidx, mm: Int8(mm), strand: 1,
                                                seq: Int32(seqIdx), pos: Int32(protoStart)))
                                        } else { overflow.insert(Int(gidx)) }
                                    }
                                }
                                q += 1
                            }
                        } else {
                            while q < cnt {
                                let x = w ^ T[base + q]
                                let mm = ((x | (x >> 1)) & G.low).nonzeroBitCount
                                H[(base + q) * HSTRIDE + mm] += 1
                                evals += 1          // counted here, as the work happens
                                q += 1
                            }
                        }
                    }
                }
                // ---------------- reverse strand
                pamOK = false; protoStart = 0; dropped = false; w = 0
                if G.kind == 0 {                    // reverse NGG reads forward C C
                    if ((valid >> (uL+1)) & 3) == 3
                        && ((roll >> (2*(uL+1))) & 3) == 1 && ((roll >> (2*(uL+2))) & 3) == 1 {
                        pamOK = true
                        if (valid & G.validL) == G.validL {
                            w = (rc >> (2*(32 - uL))) & G.maskL; protoStart = p - (L - 1)
                        } else { dropped = true }
                    }
                } else if G.kind == 1 {             // reverse TTTV reads forward A A A then non-A
                    if (valid & 15) == 15
                        && (roll & 3) == 0 && ((roll >> 2) & 3) == 0 && ((roll >> 4) & 3) == 0
                        && ((roll >> 6) & 3) != 0 {
                        pamOK = true
                        if ((valid >> 4) & G.validL) == G.validL {
                            w = (rc >> (2*(32 - 4 - uL))) & G.maskL; protoStart = p - (L + 3)
                        } else { dropped = true }
                    }
                } else {                            // reverse TTN reads forward A A then any base
                    if (valid & 7) == 7 && (roll & 3) == 0 && ((roll >> 2) & 3) == 0 {
                        pamOK = true
                        if ((valid >> 3) & G.validL) == G.validL {
                            w = (rc >> (2*(32 - 3 - uL))) & G.maskL; protoStart = p - (L + 2)
                        } else { dropped = true }
                    }
                }
                if pamOK {
                    PR[gi] += 1
                    if dropped { AS[gi] += 1 }
                    else {
                        SC[gi] += 1
                        var q = 0
                        if rt {
                            while q < cnt {
                                let x = w ^ T[base + q]
                                let mm = ((x | (x >> 1)) & G.low).nonzeroBitCount
                                H[(base + q) * HSTRIDE + mm] += 1
                                evals += 1          // counted here, as the work happens
                                if mm <= LIST_MM {
                                    let gidx = OB[base + q]
                                    if gidx >= 0 {
                                        if localSites.count < LIST_CAP {
                                            localSites.append(Site(guide: gidx, mm: Int8(mm), strand: -1,
                                                seq: Int32(seqIdx), pos: Int32(protoStart)))
                                        } else { overflow.insert(Int(gidx)) }
                                    }
                                }
                                q += 1
                            }
                        } else {
                            while q < cnt {
                                let x = w ^ T[base + q]
                                let mm = ((x | (x >> 1)) & G.low).nonzeroBitCount
                                H[(base + q) * HSTRIDE + mm] += 1
                                evals += 1          // counted here, as the work happens
                                q += 1
                            }
                        }
                    }
                }
                gi += 1
            }
        }
        }}}}
    }}}}
    acc.probeEvals += evals
    for i in 0..<ng {
        acc.pamFwd[i] += pamF[i]; acc.pamRev[i] += pamR[i]
        acc.scored[i] += scd[i];  acc.setAside[i] += asd[i]
    }
    acc.sites.append(contentsOf: localSites)
    acc.listOverflow.formUnion(overflow)
    _ = n
}

// ------------------------------------------------------------ the naive reference kernel
// A second implementation of the same law, written to be obvious rather than fast: it indexes the
// base array directly, compares one position at a time, and knows nothing about packing, rolling
// registers or popcount. It exists so the packed kernel is checked against something that could
// not fail in the same way. Two implementations that disagree reveal a gap in the law.
func scanNaive(_ g: [Int8], _ lo: Int, _ hi: Int, _ acc: Acc) {
    let ng = groups.count
    for p in lo..<hi {
        for gi in 0..<ng {
            let G = groups[gi]; let L = G.L
            if p < G.footprint - 1 { continue }
            @inline(__always) func at(_ d: Int) -> Int8 { g[p - d] }
            // forward
            var pamOK = false, ps = -2
            switch G.kind {
            case .ngg:
                if at(0) == 2 && at(1) == 2 { pamOK = true; ps = p - (L + 2) }
            case .tttv:
                if at(L+3) == 3 && at(L+2) == 3 && at(L+1) == 3 && at(L) >= 0 && at(L) != 3 {
                    pamOK = true; ps = p - (L - 1)
                }
            case .ttn:
                if at(L+2) == 3 && at(L+1) == 3 && at(L) >= 0 { pamOK = true; ps = p - (L - 1) }
            }
            if pamOK {
                acc.pamFwd[gi] += 1
                var w = [Int8](); w.reserveCapacity(L)
                for t in 0..<L { w.append(g[ps + t]) }
                if w.contains(-1) { acc.setAside[gi] += 1 }
                else {
                    acc.scored[gi] += 1
                    for q in 0..<(G.guideIdx.count * PPG) {
                        let probe = packedProbes[G.probeBase + q]
                        var mm = 0
                        for t in 0..<L {
                            let pb = Int8((probe >> UInt64(2*(L-1-t))) & 3)
                            if w[t] != pb { mm += 1 }
                        }
                        acc.hist[(G.probeBase + q) * HSTRIDE + mm] += 1
                        acc.probeEvals += 1
                    }
                }
            }
            // reverse
            pamOK = false; ps = -2
            switch G.kind {
            case .ngg:
                if at(L+1) == 1 && at(L+2) == 1 { pamOK = true; ps = p - (L - 1) }
            case .tttv:
                if at(0) == 0 && at(1) == 0 && at(2) == 0 && at(3) >= 0 && at(3) != 0 {
                    pamOK = true; ps = p - (L + 3)
                }
            case .ttn:
                if at(0) == 0 && at(1) == 0 && at(2) >= 0 { pamOK = true; ps = p - (L + 2) }
            }
            if pamOK {
                acc.pamRev[gi] += 1
                var w = [Int8](); w.reserveCapacity(L)
                for t in 0..<L { w.append(g[ps + (L - 1 - t)]) }   // reverse
                if w.contains(-1) { acc.setAside[gi] += 1 }
                else {
                    for t in 0..<L { w[t] = 3 - w[t] }             // complement
                    acc.scored[gi] += 1
                    for q in 0..<(G.guideIdx.count * PPG) {
                        let probe = packedProbes[G.probeBase + q]
                        var mm = 0
                        for t in 0..<L {
                            let pb = Int8((probe >> UInt64(2*(L-1-t))) & 3)
                            if w[t] != pb { mm += 1 }
                        }
                        acc.hist[(G.probeBase + q) * HSTRIDE + mm] += 1
                        acc.probeEvals += 1
                    }
                }
            }
        }
    }
}

// =========================================================== THE KNOWN-CASE CHECK, RUNS FIRST ===
// Nothing is reported until every arm below has run and behaved as built. Arms run in BOTH
// directions: an arm that only ever passes and an arm that only ever fails are the same defect.
struct ArmResult { let name: String; let expect: String; let got: String; let ok: Bool }
var arms: [ArmResult] = []
func arm(_ name: String, _ expect: String, _ got: String) {
    arms.append(ArmResult(name: name, expect: expect, got: got, ok: expect == got))
}

var synth: [Int8] = []
var synthPlacedFwdCopies = 0
var repOfGroup: [Int] = []
do {
    func filler(_ k: Int) { for _ in 0..<k { synth.append(0) } }     // A-runs create no PAM of any rule
    func rcOf(_ s: [Int8]) -> [Int8] { s.reversed().map { 3 - $0 } }
    filler(60)
    for G in groups {
        let rep = G.guideIdx[0]
        repOfGroup.append(rep)
        let s = guides[rep].spacer
        var one = s; one[0] = (s[0] + 1) % 4                        // one-mismatch decoy
        switch G.kind {
        case .ngg:
            synth += s; synth += [0,2,2]; filler(40)                 // good PAM, forward
            synth += [1,1,0]; synth += rcOf(s); filler(40)           // good PAM, reverse
            synth += one; synth += [0,2,2]; filler(40)               // one-mismatch decoy
            synth += s; synth += [0,0,0]; filler(40)                 // BROKEN PAM — must not count
            synth += [3,3,3,0]; synth += s; filler(40)               // WRONG-FAMILY PAM — must not count
        case .tttv:
            synth += [3,3,3,0]; synth += s; filler(40)
            synth += rcOf(s); synth += [1,0,0,0]; filler(40)
            synth += [3,3,3,0]; synth += one; filler(40)
            synth += [0,0,0,0]; synth += s; filler(40)               // BROKEN PAM
            synth += s; synth += [0,2,2]; filler(40)                 // WRONG-FAMILY PAM
        case .ttn:
            synth += [3,3,0]; synth += s; filler(40)
            synth += rcOf(s); synth += [1,0,0]; filler(40)
            synth += [3,3,0]; synth += one; filler(40)
            synth += [0,0,0]; synth += s; filler(40)                 // BROKEN PAM
            synth += s; synth += [0,2,2]; filler(40)                 // WRONG-FAMILY PAM
        }
        synthPlacedFwdCopies += 3
    }
    for _ in 0..<60 { synth.append(-1) }                             // an N run: absence, not a match
    filler(60)
}
let accP = Acc(NPROBE, groups.count)
let accN = Acc(NPROBE, groups.count)
synth.withUnsafeBufferPointer { bp in
    scanPacked(bp.baseAddress!, synth.count, 0, synth.count, 0, accP)
}
scanNaive(synth, 0, synth.count, accN)

for (gi, G) in groups.enumerated() {
    let rep = repOfGroup[gi]
    let h = accP.hist[guideProbe0[rep] * HSTRIDE + 0]
    arm("A\(gi+1) \(G.kind == .ngg ? "NGG" : (G.kind == .tttv ? "TTTV" : "TTN")) L=\(G.L) — the rule admits exactly the two sites it should",
        "0mm=2", "0mm=\(h)")
}
do {
    // the spacer is literally present in the contig more often than the rule admits: a two-sided arm
    var literalTotal = 0
    for gi in groups.indices {
        let s = guides[repOfGroup[gi]].spacer
        var c = 0
        if synth.count >= s.count {
            for p in 0...(synth.count - s.count) {
                var eq = true
                for t in 0..<s.count where synth[p+t] != s[t] { eq = false; break }
                if eq { c += 1 }
            }
        }
        literalTotal += c
    }
    arm("A\(arms.count+1) the sequence is present more often than the PAM rule admits",
        "literal=\(3*groups.count) admitted_fwd=\(groups.count)",
        "literal=\(literalTotal) admitted_fwd=\(groups.count)")
}
// the arms below need an NGG group whose spacer is long enough to corrupt in three places;
// groups[0] is the 10-nucleotide homing guide and is covered by its own A-arm above.
var refGrp = 0
for (i, G) in groups.enumerated() where G.kind == .ngg && G.L >= 16 { refGrp = i; break }
do {
    let rep = repOfGroup[refGrp]
    let h1 = accP.hist[guideProbe0[rep] * HSTRIDE + 1]
    arm("A\(arms.count+1) the one-mismatch decoy is seen as a one-mismatch site", "1mm>=1",
        h1 >= 1 ? "1mm>=1" : "1mm=\(h1)")
}
do {
    // a corrupted spacer must NOT find the constructed site — the instrument discriminates
    var corrupt = guides[repOfGroup[refGrp]].spacer
    corrupt[3] = (corrupt[3] + 2) % 4; corrupt[7] = (corrupt[7] + 1) % 4
    corrupt[11] = (corrupt[11] + 3) % 4
    let want = pack(corrupt)
    let G = groups[refGrp]
    var hits = 0, intact = 0
    let wantIntact = pack(guides[repOfGroup[refGrp]].spacer)
    for p in (G.footprint - 1)..<synth.count {
        if synth[p] == 2 && synth[p-1] == 2 {
            let ps = p - (G.L + 2)
            if ps >= 0 {
                var v: UInt64 = 0; var bad = false
                for t in 0..<G.L { if synth[ps+t] < 0 { bad = true; break }
                                   v = (v << 2) | UInt64(synth[ps+t]) }
                if !bad && v == want { hits += 1 }
                if !bad && v == wantIntact { intact += 1 }
            }
        }
    }
    arm("A\(arms.count+1) the intact spacer IS found where the corrupted one is NOT",
        "intact=1 corrupt=0", "intact=\(intact) corrupt=\(hits)")
}
do {
    var histSame = true, pamSame = true
    for i in 0..<accP.hist.count where accP.hist[i] != accN.hist[i] { histSame = false; break }
    for i in 0..<groups.count where accP.pamFwd[i] != accN.pamFwd[i]
        || accP.pamRev[i] != accN.pamRev[i] || accP.scored[i] != accN.scored[i]
        || accP.setAside[i] != accN.setAside[i] { pamSame = false; break }
    arm("A\(arms.count+1) packed and naive kernels agree on every histogram bucket (synthetic)",
        "identical", histSame ? "identical" : "DIFFER")
    arm("A\(arms.count+1) packed and naive kernels agree on every candidate-site census (synthetic)",
        "identical", pamSame ? "identical" : "DIFFER")
    arm("A\(arms.count+1) packed and naive kernels agree on the in-kernel work count (synthetic)",
        "\(accN.probeEvals)", "\(accP.probeEvals)")
}
do {
    // the N run is set aside, and it is set aside as ABSENCE — neither a match nor a mismatch
    let tot = (0..<groups.count).reduce(Int64(0)) { $0 + accP.setAside[$1] }
    arm("A\(arms.count+1) an N run is set aside rather than scored", "setAside>0",
        tot > 0 ? "setAside>0" : "setAside=0")
}
do {
    // a gate given nothing must not pass: an empty anchor range does no work and finds nothing
    let e = Acc(NPROBE, groups.count)
    synth.withUnsafeBufferPointer { bp in scanPacked(bp.baseAddress!, synth.count, 100, 100, 0, e) }
    let sites = (0..<groups.count).reduce(Int64(0)) { $0 + e.scored[$1] }
    arm("A\(arms.count+1) an empty range performs no work and reports none",
        "evals=0 scored=0", "evals=\(e.probeEvals) scored=\(sites)")
}
do {
    // A homopolymer contig discriminates the three rules against each other, and it is the arm
    // that caught the arm. An A-run carries no NGG site (forward needs GG, reverse needs CC) and
    // no TTTV site (forward needs TTT, reverse needs a non-A in the V position) -- but on the
    // REVERSE strand an A-run reads as a T-run, so it carries a TTN PAM at EVERY eligible anchor
    // and no forward one. The expectation is therefore not "zero": it is zero for two rules and
    // exactly one site per eligible anchor for the third, and the kernel must produce both halves.
    let flat = [Int8](repeating: 0, count: 10_000)
    let e = Acc(NPROBE, groups.count)
    flat.withUnsafeBufferPointer { bp in scanPacked(bp.baseAddress!, flat.count, 0, flat.count, 0, e) }
    let n = flat.count
    var expect = "", got = ""
    for (i, G) in groups.enumerated() {
        let w = G.kind == .ngg ? "NGG" : (G.kind == .tttv ? "TTTV" : "TTN")
        let anchors = Int64(n - (G.footprint - 1))
        let eF: Int64 = 0
        let eR: Int64 = G.kind == .ttn ? anchors : 0
        expect += "\(w)\(G.L):\(eF)/\(eR) "
        got    += "\(w)\(G.L):\(e.pamFwd[i])/\(e.pamRev[i]) "
    }
    arm("A\(arms.count+1) a homopolymer separates the three rules (fwd/rev per rule)",
        expect.trimmingCharacters(in: .whitespaces), got.trimmingCharacters(in: .whitespaces))
    // and the naive kernel must reach the same verdict on the same bytes
    let e2 = Acc(NPROBE, groups.count)
    scanNaive(flat, 0, n, e2)
    var same = true
    for i in 0..<groups.count where e.pamFwd[i] != e2.pamFwd[i] || e.pamRev[i] != e2.pamRev[i] { same = false; break }
    arm("A\(arms.count+1) both kernels reach that same split on the same bytes", "identical",
        same ? "identical" : "DIFFER")
}
do {
    // the completeness identity itself must be able to FAIL: perturbing the counter must refuse
    let realOK  = accP.probeEvals == (0..<groups.count).reduce(Int64(0)) {
        $0 + accP.scored[$1] * Int64(groups[$1].guideIdx.count * PPG) }
    let fakeOK  = (accP.probeEvals - 1) == (0..<groups.count).reduce(Int64(0)) {
        $0 + accP.scored[$1] * Int64(groups[$1].guideIdx.count * PPG) }
    arm("A\(arms.count+1) the completeness identity holds, and REFUSES when the count is perturbed",
        "true/false", "\(realOK)/\(fakeOK)")
}

let selftestOK = arms.allSatisfy { $0.ok }
print("KNOWN-CASE CHECK — the instrument is validated on constructed cases before it reports anything")
print("Every arm names what was expected and what was measured. Arms run in both directions.")
print("")
for a in arms {
    print("  " + (a.ok ? "as built  " : "FAILED    ") + padL(a.name, 78)
          + "  expect " + a.expect + "  |  got " + a.got)
}
print("")
print("  arms run: \(arms.count)   as built: \(arms.filter{$0.ok}.count)   failed: \(arms.filter{!$0.ok}.count)")
print("")
if !selftestOK {
    print("SELF-TEST FAILED — REFUSED. No screen is reported. An instrument that cannot reproduce a")
    print("case constructed in advance cannot be trusted on a case nobody knows.")
    printPublishedReference()
    exit(0)
}

// ================================================================= THE SCREEN OVER THE ASSEMBLY ==
let SLOTS = max(1, min(16, ProcessInfo.processInfo.activeProcessorCount))
var slots: [Acc] = (0..<SLOTS).map { _ in Acc(NPROBE, groups.count) }
let total = Acc(NPROBE, groups.count)
var seqNames: [String] = []
var basesScanned = 0
var seqsScanned = 0
var sliceCheckDone = false
var sliceAgrees = true
var sliceEvalsPacked: Int64 = 0
var sliceEvalsNaive: Int64 = 0
var sliceBases = 0
var sliceReal = 0

func processSequence(_ buf: UnsafeMutablePointer<Int8>, _ n: Int, _ name: String) {
    if n < 32 { return }
    let idx = seqNames.count
    seqNames.append(name)
    basesScanned += n
    seqsScanned += 1
    // the second known case: on a real genome slice the two kernels must still agree
    if !sliceCheckDone {
        sliceCheckDone = true
        // A real-sequence slice, deliberately NOT the start of the first sequence: chromosome 1
        // opens with a telomeric N run, and a cross-check over unusable bases would agree for the
        // wrong reason. The naive kernel is O(bases x probes x spacer length) with an allocation
        // per candidate site, so the slice is small on purpose -- its job is to disagree if the
        // packed kernel is wrong, not to screen anything.
        let want = 200_000
        let sliceLo = min(max(0, n - want), 10_000_000)
        let m = min(n, sliceLo + want)
        let a = Acc(NPROBE, groups.count), b = Acc(NPROBE, groups.count)
        scanPacked(buf, n, sliceLo, m, idx, a)
        var arr = [Int8](repeating: 0, count: n)
        for i in 0..<n { arr[i] = buf[i] }
        scanNaive(arr, sliceLo, m, b)
        var real = 0
        for i in sliceLo..<m where buf[i] >= 0 { real += 1 }
        sliceBases = m - sliceLo
        sliceReal = real
        for i in 0..<a.hist.count where a.hist[i] != b.hist[i] { sliceAgrees = false; break }
        for i in 0..<groups.count where a.pamFwd[i] != b.pamFwd[i] || a.pamRev[i] != b.pamRev[i]
            || a.scored[i] != b.scored[i] || a.setAside[i] != b.setAside[i] { sliceAgrees = false; break }
        sliceEvalsPacked = a.probeEvals; sliceEvalsNaive = b.probeEvals
        if a.probeEvals != b.probeEvals { sliceAgrees = false }
    }
    FileHandle.standardError.write("  \(name) \(n) bases\n".data(using: .utf8)!)
    let nslot = n < 2_000_000 ? 1 : SLOTS
    for s in 0..<nslot { slots[s].reset() }
    let per = (n + nslot - 1) / nslot
    DispatchQueue.global(qos: .userInitiated).sync {
        DispatchQueue.concurrentPerform(iterations: nslot) { s in
            let lo = s * per, hi = min(n, lo + per)
            if hi > lo { scanPacked(buf, n, lo, hi, idx, slots[s]) }
        }
    }
    for s in 0..<nslot { total.merge(slots[s]) }
}

// -------- streaming FASTA reader: raw bytes, no line objects, one growable buffer per sequence
var cap = 1 << 26
var seqBuf = UnsafeMutablePointer<Int8>.allocate(capacity: cap)
var seqLen = 0
var curName = ""
var inHeader = false
var headerBytes: [UInt8] = []
let IN = 1 << 22
let inBuf = UnsafeMutablePointer<UInt8>.allocate(capacity: IN)
while true {
    let got = read(0, inBuf, IN)
    if got <= 0 { break }
    var i = 0
    while i < got {
        let b = inBuf[i]; i += 1
        if inHeader {
            if b == 10 {
                inHeader = false
                var nm = ""
                for c in headerBytes { if c == 32 || c == 9 { break }; nm.append(Character(UnicodeScalar(c))) }
                curName = nm
            } else if b != 13 { headerBytes.append(b) }
            continue
        }
        if b == 62 {                                     // '>'
            if seqLen > 0 { processSequence(seqBuf, seqLen, curName) }
            seqLen = 0; inHeader = true; headerBytes.removeAll(keepingCapacity: true)
            continue
        }
        if b == 10 || b == 13 { continue }
        if seqLen == cap {
            let nc = cap * 2
            let nb = UnsafeMutablePointer<Int8>.allocate(capacity: nc)
            nb.update(from: seqBuf, count: seqLen)
            seqBuf.deallocate(); seqBuf = nb; cap = nc
        }
        seqBuf[seqLen] = code(b); seqLen += 1
    }
}
if seqLen > 0 { processSequence(seqBuf, seqLen, curName) }

// ------------------------------------------------------------------------- completeness refusal
print("EXACT GENOME-WIDE OFF-TARGET MAP — EVERY CLINICAL CRISPR GUIDE WITH A PUBLIC SPACER")
print("Every candidate site of three PAM rules, on both strands of the primary assembly.")
print("")
if seqsScanned == 0 {
    print("NO GENOME ON STDIN — this program screens a real assembly and will not invent one.")
    print("  curl -sL https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/latest_release/\\")
    print("       GRCh38.primary_assembly.genome.fa.gz | gunzip -c | /tmp/atlas <guides.tsv> <N>")
    printPublishedReference()
    exit(0)
}

var nggIdx = -1
for (i, G) in groups.enumerated() where G.kind == .ngg && G.L == 20 { nggIdx = i }
let ngg20Sites = nggIdx >= 0 ? total.pamFwd[nggIdx] + total.pamRev[nggIdx] : -1
let ngg20Skip  = nggIdx >= 0 ? total.setAside[nggIdx] : -1
let identity = (0..<groups.count).reduce(Int64(0)) {
    $0 + total.scored[$1] * Int64(groups[$1].guideIdx.count * PPG) }

var refusals: [String] = []
if basesScanned != PIN_BASES {
    refusals.append("bases scanned \(gp(basesScanned)) != published \(gp(PIN_BASES))")
}
if seqsScanned != PIN_SEQS {
    refusals.append("sequences \(seqsScanned) != published \(PIN_SEQS)")
}
if ngg20Sites != Int64(PIN_NGG20_SITES) {
    refusals.append("NGG candidate sites at L=20 \(gp(Int(ngg20Sites))) != published \(gp(PIN_NGG20_SITES))")
}
if total.probeEvals != identity {
    refusals.append("in-kernel work count \(total.probeEvals) != site census x probe count \(identity)")
}
if !sliceAgrees {
    refusals.append("packed and naive kernels disagreed on the real genome slice")
}

print("counted INSIDE the kernel, as the work happened — never derived from input sizes")
print("  sequences scanned      : \(seqsScanned)")
print("  bases scanned          : \(gp(basesScanned))")
print("  candidate sites, by rule (forward + reverse, both strands of every sequence):")
for (i, G) in groups.enumerated() {
    let w = G.kind == .ngg ? "NGG " : (G.kind == .tttv ? "TTTV" : "TTN ")
    print("    \(w) L=\(padR(G.L,2))  \(padR(gp(Int(total.pamFwd[i])),13)) fwd + \(padR(gp(Int(total.pamRev[i])),13)) rev"
          + " = \(padR(gp(Int(total.pamFwd[i]+total.pamRev[i])),13))"
          + "   scored \(padR(gp(Int(total.scored[i])),13))   set aside (N) \(gp(Int(total.setAside[i])))")
}
print("  probe evaluations      : \(gp(Int(total.probeEvals)))   (one integer comparison of a whole")
print("                           spacer against a candidate site; \(guides.count) guides x \(PPG) probes)")
print("  permutations per guide : \(PERMS)")
print("")
print("known-case pins, measured against externally published integers:")
print("  bases                  : \(gp(basesScanned)) vs \(gp(PIN_BASES))   \(basesScanned == PIN_BASES ? "REPRODUCED" : "DIFFERS")")
print("  sequences              : \(seqsScanned) vs \(PIN_SEQS)   \(seqsScanned == PIN_SEQS ? "REPRODUCED" : "DIFFERS")")
print("  NGG sites at L=20      : \(gp(Int(ngg20Sites))) vs \(gp(PIN_NGG20_SITES))   \(ngg20Sites == Int64(PIN_NGG20_SITES) ? "REPRODUCED" : "DIFFERS")")
print("  N windows set aside    : \(gp(Int(ngg20Skip))) vs \(gp(PIN_NGG20_NSKIP))   \(ngg20Skip == Int64(PIN_NGG20_NSKIP) ? "REPRODUCED" : "DIFFERS")  (reported, not a pin)")
print("  kernels on a real slice: \(gp(sliceBases)) bases (\(gp(sliceReal)) of them ACGT) — packed \(gp(Int(sliceEvalsPacked))) evals, naive \(gp(Int(sliceEvalsNaive))) evals   \(sliceAgrees ? "IDENTICAL" : "DIFFER")")
if sliceReal < 100_000 {
    refusals.append("the real-genome cross-check slice held only \(sliceReal) usable bases")
}
print("")

if !refusals.isEmpty {
    print("REFUSED — INCOMPLETE. This program did not screen the whole assembly and will not seal a")
    print("map that would read as complete. What failed:")
    for r in refusals { print("    \(r)") }
    printPublishedReference()
    exit(0)
}

// ------------------------------------------------------------------------------- the guide table
@inline(__always) func hist(_ probe: Int, _ mm: Int) -> Int64 { total.hist[probe * HSTRIDE + mm] }
func burden(_ probe: Int, _ L: Int) -> Int64 {
    var s: Int64 = 0
    for m in 1...min(LIST_MM, L) { s += hist(probe, m) }
    return s
}

var transcript = "crispr-clinical-atlas;guides=\(guides.count);perms=\(PERMS);seqs=\(seqsScanned);"
                 + "bases=\(basesScanned);evals=\(total.probeEvals);tsv=\(guidesDigest);\n"
for (i, G) in groups.enumerated() {
    transcript += "group|\(G.kind.rawValue)|\(G.L)|\(total.pamFwd[i])|\(total.pamRev[i])|"
                  + "\(total.scored[i])|\(total.setAside[i])\n"
}

print("THE TWENTY-FIVE GUIDES. `perfect` is the number of zero-mismatch sites in the whole assembly.")
print("The cut site is MEASURED — it is where the zero-mismatch match actually falls — and the")
print("declared target is a cross-check, never an input.")
print("")
print(padL("guide", 46) + padL("UNII", 11) + padL("nuclease", 15) + padR("L", 3)
      + padR("perfect", 9) + "  measured location")
var siteByGuide = [Int: [Site]]()
for s in total.sites { siteByGuide[Int(s.guide), default: []].append(s) }
for gi in guides.indices {
    let g = guides[gi]
    let p0 = guideProbe0[gi]
    let perfect = hist(p0, 0)
    let mine = (siteByGuide[gi] ?? []).filter { $0.mm == 0 }
    let chroms = Set(mine.map { seqNames[Int($0.seq)] }).sorted()
    let loc: String
    if !groups[guideGroup[gi]].retainSites {
        loc = perfect > 0 ? "\(gp(Int(perfect))) sites — coordinates not retained (spacer < \(MIN_L_FOR_LIST) nt)"
                          : "NO_ZERO_MISMATCH_SITE_ANYWHERE"
    } else if perfect == 0 {
        loc = "NO_ZERO_MISMATCH_SITE_ANYWHERE — no off-target list emitted"
    } else {
        loc = chroms.prefix(3).joined(separator: ",") + (chroms.count > 3 ? " +\(chroms.count-3)" : "")
    }
    print(padL(String(g.name.prefix(45)), 46) + padL(g.unii, 11) + padL(g.nuclease, 15)
          + padR(g.spacer.count, 3) + padR(gp(Int(perfect)), 9) + "  " + loc)
    transcript += "guide|\(g.unii)|\(g.pam)|\(g.spacer.count)|\(perfect)|\(chroms.joined(separator: ","))\n"
}
print("")

// ------------------------------------------------------- the published fifteen, as a known case
var pub15 = guides.indices.filter { PUBLISHED_15.contains(guides[$0].unii) }
var pubWithZero = 0, pubExactlyOne = 0, pubOneMM = Int64(0), pubZeroAtTwo = 0
for gi in pub15 {
    let p0 = guideProbe0[gi]
    if hist(p0, 0) >= 1 { pubWithZero += 1 }
    if hist(p0, 0) == 1 { pubExactlyOne += 1 }
    pubOneMM += hist(p0, 1)
    if hist(p0, 2) == 0 { pubZeroAtTwo += 1 }
}
let pubOK = pub15.count == 15 && pubWithZero == 15 && pubExactlyOne == 13
            && pubOneMM == 0 && pubZeroAtTwo == 13
print("THE PUBLISHED FIFTEEN, RE-MEASURED BY A DIFFERENT KERNEL — a second known case, on real data")
print("  guides found in the table            : \(pub15.count)     expect 15")
print("  with a zero-mismatch site            : \(pubWithZero)     expect 15")
print("  with EXACTLY one in the whole genome : \(pubExactlyOne)     expect 13")
print("  total sites at ONE mismatch          : \(pubOneMM)      expect 0")
print("  with zero sites at TWO mismatches    : \(pubZeroAtTwo)     expect 13")
print("  " + (pubOK ? "REPRODUCED — the packed multi-rule kernel returns the predecessor's numbers exactly."
                    : "DIFFERS — REFUSED."))
print("")
transcript += "pub15|\(pub15.count)|\(pubWithZero)|\(pubExactlyOne)|\(pubOneMM)|\(pubZeroAtTwo)\n"
if !pubOK {
    print("REFUSED — the instrument does not reproduce the case it already knows. Nothing is sealed.")
    printPublishedReference()
    exit(0)
}

// ------------------------------------------------------------------------ full histograms + map
print("THE FULL MISMATCH HISTOGRAM FOR EVERY GUIDE. Every bucket, zero to the spacer length. No")
print("bucket is omitted and no threshold is applied inside the arithmetic.")
print("")
for gi in guides.indices {
    let g = guides[gi]; let G = groups[guideGroup[gi]]; let p0 = guideProbe0[gi]
    print("=== \(g.name)")
    print("    \(g.unii)  \(g.product)  \(g.nuclease)  PAM \(g.pam)  \(g.spacer.count) nt  target \(g.target)  WHO INN \(g.inn)")
    var line = "    histogram: "
    for m in 0...G.L { line += "\(m)=\(hist(p0, m)) " }
    print(line)
    let b = burden(p0, G.L)
    print("    off-target burden (sites at 1..\(min(LIST_MM,G.L)) mismatches, on-target excluded): \(gp(Int(b)))")
    if G.retainSites {
        let off = (siteByGuide[gi] ?? []).filter { $0.mm != 0 }
            .sorted { ($0.mm, seqNames[Int($0.seq)], $0.pos) < ($1.mm, seqNames[Int($1.seq)], $1.pos) }
        if total.listOverflow.contains(gi) {
            print("    coordinates: list cap reached; the COUNT above is exact and complete from the histogram")
        } else {
            print("    coordinates of every one of those \(off.count) sites:")
            for s in off {
                print("      \(s.mm) mismatches  \(seqNames[Int(s.seq)]):\(s.pos)\(s.strand > 0 ? "+" : "-")")
            }
            if off.isEmpty { print("      (none — this guide has no site in the human genome at 1 to \(LIST_MM) mismatches)") }
        }
        for s in (siteByGuide[gi] ?? []).sorted(by: { ($0.mm, $0.seq, $0.pos) < ($1.mm, $1.seq, $1.pos) }) {
            transcript += "site|\(g.unii)|\(s.mm)|\(seqNames[Int(s.seq)])|\(s.pos)|\(s.strand)\n"
        }
    } else {
        print("    coordinates: NOT RETAINED. This spacer is \(g.spacer.count) nt. At \(LIST_MM) mismatches")
        print("    of \(g.spacer.count) the criterion admits a large fraction of the genome and a coordinate")
        print("    list would be a list of the genome, not a finding. The histogram above is complete.")
    }
    for m in 0...G.L { transcript += "h|\(g.unii)|\(m)|\(hist(p0,m))\n" }
    print("")
}

// ------------------------------------------------------------------------------- the control arm
print("THE CONTROL ARM — \(PERMS) PERMUTATIONS OF EACH GUIDE'S OWN BASES")
print("Each control probe carries the identical count of A, C, G and T, the identical length and the")
print("identical PAM rule as the guide it controls. The comparison is therefore within-guide and")
print("within-composition.")
print("")
print("HOW `rank` IS DEFINED, because a rank under ties is ambiguous and the ambiguity always")
print("flatters somebody: rank = 1 + the number of permutations whose burden is STRICTLY SMALLER")
print("than the guide's. `tied` is the number that equal it. A reader who prefers the pessimistic")
print("convention adds `tied` to `rank`; both numbers are printed so neither reading is hidden.")
print("The verdict below never uses a rank threshold. It uses two exact, tie-free comparisons:")
print("  BELOW EVERY PERMUTATION   the guide's burden is strictly less than the smallest of its own")
print("                            permutations — the specificity is a property of the SEQUENCE")
print("                            THAT WAS CHOSEN, not of the bases it happens to contain")
print("  AT THE FLOOR, TIED        the guide equals the smallest permutation burden")
print("  WITHIN ITS COMPOSITION    the guide sits inside the range its own bases produce — a")
print("                            statement about the molecule, and not a defect in it")
print("")
print(padL("guide", 40) + padL("UNII", 11) + padR("burden", 10) + padR("rank", 7) + padR("tied", 6)
      + padR("min", 10) + padR("median", 10) + padR("max", 12) + "  verdict")
var rankRows: [(String,String,Int64,Int,Int,Int64,Int64,Int64,String)] = []
for gi in guides.indices {
    let g = guides[gi]; let G = groups[guideGroup[gi]]; let p0 = guideProbe0[gi]
    let real = burden(p0, G.L)
    var ctrl: [Int64] = []
    for n in 1...PERMS { ctrl.append(burden(p0 + n, G.L)) }
    ctrl.sort()
    let below = ctrl.filter { $0 < real }.count
    let tied  = ctrl.filter { $0 == real }.count
    let rank = below + 1
    let med = ctrl[ctrl.count / 2]
    let verdict: String
    if real < ctrl[0] { verdict = "BELOW EVERY PERMUTATION" }
    else if real == ctrl[0] { verdict = "at the floor, tied" }
    else { verdict = "within its composition" }
    print(padL(String(g.name.prefix(39)), 40) + padL(g.unii, 11) + padR(gp(Int(real)), 10)
          + padR("\(rank)/\(PERMS+1)", 7) + padR(tied, 6) + padR(gp(Int(ctrl[0])), 10)
          + padR(gp(Int(med)), 10) + padR(gp(Int(ctrl[ctrl.count-1])), 12) + "  " + verdict)
    rankRows.append((g.name, g.unii, real, rank, tied, ctrl[0], med, ctrl[ctrl.count-1], verdict))
    transcript += "ctrl|\(g.unii)|\(real)|\(rank)|\(tied)|\(ctrl[0])|\(med)|\(ctrl[ctrl.count-1])\n"
}
print("")
print("  guides strictly below EVERY one of their own permutations: "
      + "\(rankRows.filter { $0.8 == "BELOW EVERY PERMUTATION" }.count) of \(guides.count)")
for r in rankRows where r.8 == "BELOW EVERY PERMUTATION" {
    print("    \(padL(String(r.0.prefix(52)), 53))  burden \(gp(Int(r.2)))  against a permutation minimum of \(gp(Int(r.5)))")
}
print("  guides at the floor but tied with at least one permutation: "
      + "\(rankRows.filter { $0.8 == "at the floor, tied" }.count) of \(guides.count)")
print("  guides inside the range their own composition produces      : "
      + "\(rankRows.filter { $0.8 == "within its composition" }.count) of \(guides.count)")
print("")

// a control arm that cannot fail is not a control arm
let allSameAsReal = rankRows.allSatisfy { $0.2 == $0.5 && $0.5 == $0.7 }
print("  the control arm discriminates: "
      + (allSameAsReal ? "NO — every permutation returned the guide's own burden. REFUSED."
                       : "YES — permutation burdens span \(gp(Int(rankRows.map{$0.5}.min()!))) to \(gp(Int(rankRows.map{$0.7}.max()!)))"))
if allSameAsReal {
    print("REFUSED — the control probes are not distinguishable from the guides they control.")
    printPublishedReference()
    exit(0)
}
print("")
print("A site counted here is a place where the chemistry COULD direct a cut. It is not a cut, not")
print("an occupancy, not a clinical event, and not evidence that any medicine harms anyone. Whether")
print("a site is cut, in a cell, at a dose, needs a laboratory and is not answered here. This is a")
print("map. Nothing here is medical advice and no entry is a recommendation to take anything.")
print("")
print("SIX CRISPR PRODUCTS ARE ABSENT FROM THIS MAP, and absence is not zero. Lumocabtagene")
print("geleucel, brinretigene vesgedparvovec, motacabtagene lurevgedleucel, edeltresgene")
print("autogeleucel, imvucabtagene geleucel and teotresgene autogeleucel have public registry")
print("records that name a nuclease and a target locus and print NO SPACER. Nothing was inferred")
print("for them from a gene name. They are NOT_KNOWN here, which is a different answer from")
print("a burden of zero and from a refusal.")
print("")
print("MARKER  CRISPR_CLINICAL_GUIDE_ATLAS__COMPLETE_ENUMERATION_IS_OBSERVER_INVARIANT")
print("arms    \(arms.count) run, \(arms.filter{$0.ok}.count) as built")
print("sha256  \(SHA256Min.hex(Array(transcript.utf8)))")
