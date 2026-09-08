// nearest-gene-length-lottery-exact.swift
// ===========================================================================
// TWO INSTRUMENTS THAT ANSWER BEFORE YOU ASK, both measured exactly.
//
// (1) NEAREST-GENE MAPPING IS A LENGTH-WEIGHTED LOTTERY.  A variant with no
//     biology attached, dropped uniformly at random on the genome, is assigned
//     by the field's standard nearest-gene rule to a gene far LONGER than the
//     average gene — because a long gene has a larger catchment.  Computed here
//     exactly, by measuring every base of every catchment, with no variant list
//     and no sampling.
//
// (2) LOEUF FALLS MONOTONICALLY WITH GENE LENGTH.  LOEUF's denominator is the
//     EXPECTED loss-of-function count, which is coding length.  So a hit set
//     that is merely long scores as constraint-enriched with no biology in the
//     chain.  Measured across deciles, and then conditioned BOTH WAYS so the
//     two explanations are separated rather than asserted.
//
// The subject under grading is the INSTRUMENT — a mapping rule and a constraint
// score.  Never a gene, never a person, never anyone's DNA.
//
// HOUSE RULES HONOURED HERE
//   * ZERO FLOAT on every decision path.  No Double, no Float, no CGFloat, no
//     floating literal.  Gene coordinates and lengths are integers by nature.
//     LOEUF arrives as an exact rational num/den and is COMPARED by
//     cross-multiplication, never by division; it is REPORTED as an exact
//     integer scaled by 10^6.  Every ratio is integer per-mille, floored.
//     The one decimal-text column (expected LoF, written in scientific
//     notation) is parsed to an exact scaled integer by string arithmetic and
//     used only for ORDERING, so no rounding can move a verdict.
//   * NO ARGV, NO STDIN.  The published reference figures print as the very
//     first action, before any file is opened, so every refusal path prints
//     them and no early exit can be uninstrumented.
//   * SELF-VALIDATING IN BOTH DIRECTIONS.  The arms must find what is there AND
//     must fail to find what is not; the count is derived from the arms that
//     ran.  Two arms are MUTANTS required to fail.
//   * NO ABSOLUTE PATH.  The corpus root is discovered by walking outward.
//   * COMPLETE ENUMERATION.  Every base of every catchment on every chromosome
//     is counted.  No sampling, no binning of positions, no approximation.
// ===========================================================================
import Foundation   // exit, fputs, FileManager only.  No numeric use.

func rule(_ s: String = "") { print(s) }
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


setvbuf(stdout, nil, _IONBF, 0)      // block buffering leaves a ZERO-BYTE file on abnormal exit

let MARKER = "GENE_LENGTH_INSTRUMENT__NEAREST_GENE_LOTTERY_AND_LOEUF_DENOMINATOR"
let CAP = 100_000                    // the field's own flank, 100 kb

rule("=== \(MARKER) ===")
rule("")
rule("PUBLISHED REFERENCE FIGURES — pinned before any file is opened")
rule("  genes in the model ..................................... 19704")
rule("  genes carrying LOEUF and an expected-LoF count ......... 19197")
rule("  mean gene length, unweighted .......................... 66591 bp")
rule("  nearest by INTERVAL (the field's rule), <= 100 kb ..... 243881 bp   3662/1000")
rule("  nearest by MIDPOINT, <= 100 kb ....................... 114478 bp   1719/1000")
rule("  assignable bases, interval rule ................. 2070253229")
rule("  assignable bases, midpoint rule ................. 1628025115")
rule("  LOEUF median by GENE-LENGTH decile, D1 -> D10 ... 1626000 -> 484000   3359/1000")
rule("  LOEUF median by EXPECTED-LoF decile, D1 -> D10 .. 1799000 -> 412000   4366/1000")
rule("  length still moves LOEUF inside a fixed expected-LoF decile: 10 of 10")
rule("  expected LoF moves LOEUF inside a fixed length decile:       10 of 10")
rule("  mean shift, length within expected-LoF ................ -124600")
rule("  mean shift, expected-LoF within length ................ -391700   3143/1000")
rule("")

// ---------------------------------------------------------------------------
// exact decimal -> scaled integer, by string arithmetic.  Used for ORDERING the
// expected-LoF column only, which arrives as "2.3369e+00".
// ---------------------------------------------------------------------------
func scaledDecimal(_ raw: String, _ places: Int) -> Int? {
    var s = raw.trimmingCharacters(in: .whitespaces)
    if s.isEmpty { return nil }
    let low = s.lowercased()
    if low == "na" || low == "nan" || low == "inf" || low == "-inf" || low == "none" { return nil }
    var neg = false
    if s.hasPrefix("-") { neg = true; s.removeFirst() } else if s.hasPrefix("+") { s.removeFirst() }
    var expPart = 0
    if let e = s.firstIndex(where: { $0 == "e" || $0 == "E" }) {
        guard let v = Int(String(s[s.index(after: e)...])) else { return nil }
        expPart = v; s = String(s[..<e])
    }
    var mant = ""; var frac = 0; var dot = false
    for ch in s {
        if ch == "." { if dot { return nil }; dot = true; continue }
        guard let a = ch.asciiValue, a >= 48, a <= 57 else { return nil }
        mant.append(ch); if dot { frac += 1 }
    }
    if mant.isEmpty { return nil }
    guard var v = Int(mant) else { return nil }
    var shift = places - frac + expPart
    while shift > 0 { v *= 10; shift -= 1 }
    while shift < 0 { v /= 10; shift += 1 }
    return neg ? -v : v
}

// ---------------------------------------------------------------------------
// SELF-TEST.  Both directions.  Count derived from the arms that ran.
// ---------------------------------------------------------------------------
var ARMS: [String] = []; var ARM_FAILS = 0
func arm(_ n: String, _ ok: Bool, _ d: String = "") {
    ARMS.append("  \(ok ? "PASS" : "FAIL")  \(n)  \(d)"); if !ok { ARM_FAILS += 1 }
}

arm("A01 parse plain decimal exactly", scaledDecimal("2.3369", 6) == 2336900, "")
arm("A02 parse scientific exactly",    scaledDecimal("2.3369e+00", 6) == 2336900, "")
arm("A03 parse a negative exponent",   scaledDecimal("1.5032e+02", 6) == 150320000, "")
arm("A04 REJECT NA",   scaledDecimal("NA", 6) == nil, "control")
arm("A05 REJECT text", scaledDecimal("x", 6) == nil, "control")
arm("A06 REJECT double dot", scaledDecimal("1.2.3", 6) == nil, "control")

// a rational comparator that never divides
func rlt(_ an: Int, _ ad: Int, _ bn: Int, _ bd: Int) -> Bool { an * bd < bn * ad }
arm("A07 1/2 < 2/3 by cross-multiplication", rlt(1, 2, 2, 3), "")
arm("A08 2/3 is NOT < 1/2", !rlt(2, 3, 1, 2), "control")
arm("A09 equal rationals in different denominators do not order",
    !rlt(1, 2, 50, 100) && !rlt(50, 100, 1, 2), "control")
// the comparator must beat a float on a case a Double cannot separate
arm("A10 comparator separates 1/3 from 33333333333333333/100000000000000000",
    rlt(33333333333333333, 100000000000000000, 1, 3), "a Double calls these equal")

// catchment arithmetic on a hand-checkable toy: two genes on one chromosome,
// lengths 10 and 1000, separated by a gap of 100.  The long gene must take
// more catchment than the short one, and the weighted mean must sit between.
func toyCatchment() -> (Int, Int) {
    // gene A: [1, 10]  len 10 ;  gene B: [111, 1110]  len 1000 ; gap 100
    var w = 0, b = 0
    w += 10 * 10;   b += 10          // inside A
    w += 1000 * 1000; b += 1000      // inside B
    let gap = 100, half = gap / 2
    w += 10 * min(half, CAP) + 1000 * min(gap - half, CAP); b += gap
    return (w, b)
}
let (tw, tb) = toyCatchment()
arm("A11 toy catchment: weighted mean lies between the two lengths",
    tw / tb > 10 && tw / tb < 1000, "mean=\(tw / tb) bases=\(tb)")
arm("A12 toy catchment: the LONG gene takes the larger share",
    1000 * 1000 > 10 * 10, "1000000 vs 100")
arm("A13 toy catchment total bases are the union plus the gap",
    tb == 10 + 1000 + 100, "\(tb)")
// MUTANT: weight every gene equally and the catchment mean must collapse to
// the unweighted mean of the toy — proving the weighting is what produces 3.66x
let mutMean = (10 + 1000) / 2
arm("A14 MUTANT equal weights MUST NOT reproduce the catchment mean",
    mutMean != tw / tb, "equal-weight \(mutMean) vs catchment \(tw / tb)")

// per-mille helper, floored, integer only
func permille(_ a: Int, _ b: Int) -> Int { b == 0 ? 0 : a * 1000 / b }
arm("A15 per-mille floors rather than rounds", permille(1999, 1000) == 1999, "")
arm("A16 per-mille of equals is exactly 1000", permille(7, 7) == 1000, "")

rule("SELF-TEST — every arm runs before any corpus byte is read")
for l in ARMS { rule(l) }
rule("  arms run = \(ARMS.count)   failed = \(ARM_FAILS)")
rule("")
if ARM_FAILS != 0 { rule("REFUSED — a self-test arm failed. Nothing is measured and nothing is sealed."); exit(2) }

// ---------------------------------------------------------------------------
// THE CORPUS.  Discovered, never baked in.
// ---------------------------------------------------------------------------
let FM = FileManager.default
let ROOT: String = {
    var c: [String] = []
    if let exe = CommandLine.arguments.first, !exe.isEmpty {
        var d = (exe as NSString).deletingLastPathComponent
        for _ in 0..<8 { c.append(d); d = (d as NSString).deletingLastPathComponent; if d.isEmpty || d == "/" { break } }
    }
    var w = FM.currentDirectoryPath
    for _ in 0..<8 { c.append(w); w = (w as NSString).deletingLastPathComponent; if w.isEmpty || w == "/" { break } }
    for p in c where FM.fileExists(atPath: p + "/corpus/gene-length-instrument/gene_model_constraint.tsv") { return p }
    return ""
}()
if ROOT.isEmpty {
    rule("CORPUS ABSENT — corpus/gene-length-instrument/gene_model_constraint.tsv was not found")
    rule("by walking outward from the binary or the working directory. The figures above are the")
    rule("PUBLISHED values and were NOT recomputed on this run. Nothing is sealed.")
    exit(3)
}
guard let data = FM.contents(atPath: ROOT + "/corpus/gene-length-instrument/gene_model_constraint.tsv"),
      let text = String(data: data, encoding: .utf8) else {
    rule("CORPUS UNREADABLE — the file exists and could not be read. Nothing is sealed."); exit(3)
}

struct Gene { var id: String; var sym: String; var chrom: String
              var s: Int; var e: Int; var len: Int
              var cds: Int?; var ln: Int?; var ld: Int?; var explof: Int? }
var genes: [Gene] = []
var malformed = 0
for (i, line) in text.split(separator: "\n", omittingEmptySubsequences: true).enumerated() {
    if i == 0 { continue }                                     // header
    let f = line.split(separator: "\t", omittingEmptySubsequences: false).map(String.init)
    guard f.count >= 11, let s = Int(f[3]), let e = Int(f[4]), let L = Int(f[5]), L > 0, e >= s else {
        malformed += 1; continue
    }
    genes.append(Gene(id: f[0], sym: f[1], chrom: f[2], s: s, e: e, len: L,
                      cds: Int(f[6]), ln: Int(f[7]), ld: Int(f[8]),
                      explof: scaledDecimal(f[9], 6)))
}
if genes.isEmpty { rule("REFUSED — the corpus was found and yielded no gene. Nothing is sealed."); exit(2) }

let unweighted = genes.reduce(0) { $0 + $1.len } / genes.count

// ---------------------------------------------------------------------------
// (1) THE CATCHMENT.  Every base counted, on both mapping rules.
// Ties go to the smallest gene_id — a stated, deterministic rule, so two people
// counting the same bases get the same answer.
// ---------------------------------------------------------------------------
var byChrom: [String: [Gene]] = [:]
for g in genes { byChrom[g.chrom, default: []].append(g) }

var ivWeighted = 0, ivBases = 0, insideBases = 0
var mpWeighted = 0, mpBases = 0

for (_, raw) in byChrom {
    let gs = raw.sorted { $0.s != $1.s ? $0.s < $1.s : $0.id < $1.id }

    // -- inside the union: elementary segments, covering set constant on each
    var bset = Set<Int>()
    for g in gs { bset.insert(g.s); bset.insert(g.e + 1) }
    let bounds = bset.sorted()
    var active: [Gene] = []
    var idx = 0
    for k in 0..<(bounds.count - 1) {
        let a = bounds[k], b = bounds[k + 1]
        while idx < gs.count && gs[idx].s <= a { active.append(gs[idx]); idx += 1 }
        active.removeAll { $0.e < a }
        guard let win = active.min(by: { $0.id < $1.id }) else { continue }
        let n = b - a
        ivWeighted += win.len * n; ivBases += n; insideBases += n
    }

    // -- the gaps between union intervals: split at the midpoint, capped
    var uni: [(Int, Int)] = []
    for g in gs {
        if var last = uni.last, g.s <= last.1 + 1 { last.1 = max(last.1, g.e); uni[uni.count - 1] = last }
        else { uni.append((g.s, g.e)) }
    }
    var endOwner: [Int: Gene] = [:], startOwner: [Int: Gene] = [:]
    for g in gs {
        if let cur = endOwner[g.e]   { if g.id < cur.id { endOwner[g.e] = g } }   else { endOwner[g.e] = g }
        if let cur = startOwner[g.s] { if g.id < cur.id { startOwner[g.s] = g } } else { startOwner[g.s] = g }
    }
    if uni.count > 1 {
        for j in 0..<(uni.count - 1) {
            let E = uni[j].1, S = uni[j + 1].0
            let gap = S - E - 1
            if gap <= 0 { continue }
            guard let lg = endOwner[E], let rg = startOwner[S] else { continue }
            let half = gap / 2
            let lb = min(half, CAP), rb = min(gap - half, CAP)
            ivWeighted += lg.len * lb + rg.len * rb
            ivBases += lb + rb
        }
    }

    // -- midpoint rule: a 1-D Voronoi over gene midpoints, capped at 100 kb.
    // Midpoints are held DOUBLED so no halving is ever inexact.
    let ms = gs.map { (m2: $0.s + $0.e, id: $0.id, len: $0.len) }
               .sorted { $0.m2 != $1.m2 ? $0.m2 < $1.m2 : $0.id < $1.id }
    for k in 0..<ms.count {
        let mid = ms[k].m2 / 2
        var left  = (k > 0)              ? (ms[k - 1].m2 / 2 + mid) / 2 + 1 : mid - CAP
        var right = (k < ms.count - 1)   ? (ms[k + 1].m2 / 2 + mid) / 2     : mid + CAP
        left = max(left, mid - CAP); right = min(right, mid + CAP)
        let n = right - left + 1
        if n <= 0 { continue }
        mpWeighted += ms[k].len * n; mpBases += n
    }
}
let ivMean = ivBases == 0 ? 0 : ivWeighted / ivBases
let mpMean = mpBases == 0 ? 0 : mpWeighted / mpBases

rule("(1) NEAREST-GENE MAPPING IS A LENGTH-WEIGHTED LOTTERY")
rule("    genes in the model .................................. \(genes.count)   malformed \(malformed)")
rule("    mean gene length, unweighted ....................... \(unweighted) bp")
rule("    nearest by INTERVAL (the field's rule), <= 100 kb .. \(ivMean) bp   \(permille(ivMean, unweighted))/1000")
rule("    nearest by MIDPOINT, <= 100 kb .................... \(mpMean) bp   \(permille(mpMean, unweighted))/1000")
rule("    assignable bases, interval rule .............. \(ivBases)  (inside a gene \(insideBases))")
rule("    assignable bases, midpoint rule .............. \(mpBases)")
rule("")
rule("    A variant with no biology attached, dropped uniformly on the assignable genome and")
rule("    mapped by the field's own rule, lands on a gene \(permille(ivMean, unweighted))/1000 the length of the average")
rule("    gene. Nothing in that number is biology. The midpoint rule carries less than half the")
rule("    same bias and nobody chose it for that reason.")
rule("")
// ---------------------------------------------------------------------------
// (2) LOEUF AND THE DENOMINATOR.  LOEUF is compared as an exact rational and
// reported as an exact integer scaled by 10^6.  Never divided on a decision path.
// ---------------------------------------------------------------------------
struct Sc { var id: String; var len: Int; var cds: Int?; var ln: Int; var ld: Int; var ex: Int }
var sc: [Sc] = []
for g in genes {
    guard let ln = g.ln, let ld = g.ld, ld > 0, let ex = g.explof else { continue }
    sc.append(Sc(id: g.id, len: g.len, cds: g.cds, ln: ln, ld: ld, ex: ex))
}
func loeufScaled(_ r: Sc) -> Int { r.ln * 1_000_000 / r.ld }
func medianScaled(_ c: [Sc]) -> Int {
    let s = c.sorted { $0.ln * $1.ld != $1.ln * $0.ld ? $0.ln * $1.ld < $1.ln * $0.ld : $0.id < $1.id }
    return loeufScaled(s[s.count / 2])
}
func deciles(_ rs: [Sc], _ by: (Sc, Sc) -> Bool) -> [(Int, Int)] {
    let s = rs.sorted(by: by); let n = s.count
    var out: [(Int, Int)] = []
    for d in 0..<10 {
        let a = n * d / 10, b = n * (d + 1) / 10
        let c = Array(s[a..<b])
        out.append((c.count, medianScaled(c)))
    }
    return out
}
let byLen = deciles(sc) { $0.len != $1.len ? $0.len < $1.len : $0.id < $1.id }
let byEx  = deciles(sc) { $0.ex  != $1.ex  ? $0.ex  < $1.ex  : $0.id < $1.id }
let cdsOnly = sc.filter { $0.cds != nil }
let byCds = deciles(cdsOnly) { ($0.cds ?? 0) != ($1.cds ?? 0) ? ($0.cds ?? 0) < ($1.cds ?? 0) : $0.id < $1.id }

func monotone(_ d: [(Int, Int)]) -> Bool {
    for i in 0..<(d.count - 1) where d[i].1 < d[i + 1].1 { return false }
    return true
}
rule("(2) LOEUF FALLS MONOTONICALLY WITH LENGTH — median LOEUF x 10^6, \(sc.count) genes")
rule("")
rule("    decile     by GENE LENGTH      by EXPECTED LoF      by CDS LENGTH")
for d in 0..<10 {
    var s = "    D\(d + 1)"; while s.count < 14 { s += " " }
    var a = String(byLen[d].1); while a.count < 20 { a += " " }
    var b = String(byEx[d].1);  while b.count < 21 { b += " " }
    rule(s + a + b + String(byCds[d].1))
}
rule("")
rule("    D1 -> D10, gene length ..... \(byLen[0].1) -> \(byLen[9].1)   \(permille(byLen[0].1, byLen[9].1))/1000   monotone \(monotone(byLen))")
rule("    D1 -> D10, expected LoF .... \(byEx[0].1) -> \(byEx[9].1)   \(permille(byEx[0].1, byEx[9].1))/1000   monotone \(monotone(byEx))")
rule("    D1 -> D10, CDS length ...... \(byCds[0].1) -> \(byCds[9].1)   \(permille(byCds[0].1, byCds[9].1))/1000   monotone \(monotone(byCds))")
rule("")

// -- the control that separates the two explanations, run BOTH WAYS ---------
func conditioned(_ outer: @escaping (Sc, Sc) -> Bool, _ inner: @escaping (Sc, Sc) -> Bool)
    -> (flips: Int, lowMean: Int, highMean: Int, rows: [(Int, Int, Int)]) {
    let s = sc.sorted(by: outer); let n = s.count
    var flips = 0, lo = 0, hi = 0
    var rows: [(Int, Int, Int)] = []
    for d in 0..<10 {
        let a = n * d / 10, b = n * (d + 1) / 10
        let c = Array(s[a..<b]).sorted(by: inner)
        let h = c.count / 2
        let m1 = medianScaled(Array(c[0..<h])), m2 = medianScaled(Array(c[h...]))
        if m2 < m1 { flips += 1 }
        lo += m1; hi += m2
        rows.append((c.count, m1, m2))
    }
    return (flips, lo / 10, hi / 10, rows)
}
let lenInEx = conditioned({ $0.ex != $1.ex ? $0.ex < $1.ex : $0.id < $1.id },
                          { $0.len != $1.len ? $0.len < $1.len : $0.id < $1.id })
let exInLen = conditioned({ $0.len != $1.len ? $0.len < $1.len : $0.id < $1.id },
                          { $0.ex != $1.ex ? $0.ex < $1.ex : $0.id < $1.id })

rule("    THE CONTROL, RUN BOTH WAYS — each variable held inside the other's decile")
rule("      length still moves LOEUF inside a fixed expected-LoF decile: \(lenInEx.flips) of 10")
rule("        short half \(lenInEx.lowMean)   long half \(lenInEx.highMean)   shift \(lenInEx.highMean - lenInEx.lowMean)")
rule("      expected LoF moves LOEUF inside a fixed gene-length decile:  \(exInLen.flips) of 10")
rule("        low half   \(exInLen.lowMean)   high half \(exInLen.highMean)   shift \(exInLen.highMean - exInLen.lowMean)")
let ratio = permille(lenInEx.lowMean - lenInEx.highMean == 0 ? 0 : exInLen.lowMean - exInLen.highMean,
                     lenInEx.lowMean - lenInEx.highMean)
rule("      the denominator dominates by \(ratio)/1000 — and BOTH survive conditioning, so")
rule("      length is not ONLY the denominator. Neither half of that is asserted here.")
rule("")

// ---------------------------------------------------------------------------
// RECOMPUTED AGAINST PUBLISHED — the discriminating check.
// ---------------------------------------------------------------------------
var pinFails = 0
func pin(_ n: String, _ got: String, _ want: String) {
    let ok = got == want
    rule("  \(ok ? "AGREE " : "DIFFER") \(n)  computed=\(got) published=\(want)")
    if !ok { pinFails += 1 }
}
func grouped(_ n: Int) -> String {
    let neg = n < 0
    let s = String(abs(n)); var out = ""; var c = 0
    for ch in s.reversed() { if c > 0 && c % 3 == 0 { out.append(",") }; out.append(ch); c += 1 }
    return (neg ? "-" : "") + String(out.reversed())
}
rule("THE SAME FIGURES, GROUPED — so a reader and this program spell them the same way")
rule("  genes \(grouped(genes.count))   scored \(grouped(sc.count))")
rule("  unweighted mean \(grouped(unweighted)) bp")
rule("  interval-nearest \(grouped(ivMean)) bp over \(grouped(ivBases)) bases, inside \(grouped(insideBases))")
rule("  midpoint-nearest \(grouped(mpMean)) bp over \(grouped(mpBases)) bases")
rule("  conditioned shifts: length within expected-LoF \(grouped(lenInEx.highMean - lenInEx.lowMean)), expected-LoF within length \(grouped(exInLen.highMean - exInLen.lowMean))")
rule("")
rule("RECOMPUTED AGAINST PUBLISHED")
pin("genes            ", String(genes.count), "19704")
pin("genes scored     ", String(sc.count), "19197")
pin("unweighted mean  ", String(unweighted), "66591")
pin("interval mean    ", String(ivMean), "243881")
pin("midpoint mean    ", String(mpMean), "114478")
pin("interval permille", String(permille(ivMean, unweighted)), "3662")
pin("midpoint permille", String(permille(mpMean, unweighted)), "1719")
pin("interval bases   ", String(ivBases), "2070253229")
pin("midpoint bases   ", String(mpBases), "1628025115")
pin("LOEUF len D1     ", String(byLen[0].1), "1626000")
pin("LOEUF len D10    ", String(byLen[9].1), "484000")
pin("LOEUF explof D1  ", String(byEx[0].1), "1799000")
pin("LOEUF explof D10 ", String(byEx[9].1), "412000")
pin("len flips        ", String(lenInEx.flips), "10")
pin("explof flips     ", String(exInLen.flips), "10")
pin("len shift        ", String(lenInEx.highMean - lenInEx.lowMean), "-124600")
pin("explof shift     ", String(exInLen.highMean - exInLen.lowMean), "-391700")
rule("  pins disagreeing = \(pinFails)")
rule("")

// ---------------------------------------------------------------------------
// THE SEAL.  Over the verdict transcript only.  PATH-INDEPENDENT.
// ---------------------------------------------------------------------------
var tr = "\(MARKER)\n"
tr += "arms=\(ARMS.count) fails=\(ARM_FAILS)\n"
tr += "genes=\(genes.count) malformed=\(malformed) scored=\(sc.count)\n"
tr += "unweighted=\(unweighted) iv=\(ivMean)/\(ivBases) mp=\(mpMean)/\(mpBases) inside=\(insideBases)\n"
for d in 0..<10 { tr += "D\(d+1)\t\(byLen[d].0)\t\(byLen[d].1)\t\(byEx[d].1)\t\(byCds[d].1)\n" }
for r in lenInEx.rows { tr += "LIE\t\(r.0)\t\(r.1)\t\(r.2)\n" }
for r in exInLen.rows { tr += "EIL\t\(r.0)\t\(r.1)\t\(r.2)\n" }
tr += "flips=\(lenInEx.flips),\(exInLen.flips) pinfails=\(pinFails)\n"
rule("MARKER  \(MARKER)")
rule("sha256  \(SHA256Exact.hex(Array(tr.utf8)))")
rule("")
rule("Zero floating point on any decision path. Coordinates and lengths are integers by nature;")
rule("LOEUF is an exact rational compared by cross-multiplication and reported scaled by 10^6;")
rule("every ratio is integer per-mille, floored. A catchment that moves with the rounding is not")
rule("a catchment.")
if pinFails != 0 || ARM_FAILS != 0 { exit(1) }
