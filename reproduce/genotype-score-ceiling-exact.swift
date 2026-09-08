// genotype-score-ceiling-exact.swift
// ===========================================================================
// THE QUESTION, and it has an exact answer:
//
//   Given a trait whose common-SNP heritability is h2, how often can the BEST
//   POSSIBLE genotype-only score put two people in their true order?
//
// For a trait Y and an additive genotype score S, bivariate normal at
// correlation rho, the probability that S ranks two independently drawn
// members of the stratum in their true Y order is EXACTLY
//
//        C(rho) = 1/2 + arcsin(rho) / pi                (Kendall tau identity)
//
// Taking rho = sqrt(h2_SNP) gives a CEILING: no score can correlate with the
// trait more strongly than the additive genetic value it is estimating.  C is
// therefore an upper bound on every present and future genotype-only score for
// that trait in that stratum — not a comparison against anything, not a
// benchmark, and not a claim about any person.
//
// HOUSE RULES HONOURED HERE
//   * ZERO FLOAT on every decision path.  No Double, no Float, no CGFloat, no
//     floating literal.  h2 and its standard error are parsed from decimal TEXT
//     into exact rationals by string arithmetic; C is reported as an integer
//     bracket over 10^12.  The transcendental is NEVER EVALUATED: the test
//     "C - 1/2 <= t" is reduced to "rho <= sin(pi*t)" and then to the exact
//     integer comparison  sin_hi(pi t)^2 * den(rho^2)  vs  num(rho^2) * 10^120,
//     so no square root and no arcsin is ever taken.  pi and sin are bracketed
//     by alternating series with per-term intervals and direction-correct
//     truncation: a partial sum ending on a SUBTRACTION is a lower bound, one
//     ending on an ADDITION an upper bound, of an alternating series with
//     strictly decreasing terms.
//   * NO ARGV, NO STDIN.  The published reference figures are printed as the
//     VERY FIRST ACTION, before any file is opened, so every refusal path
//     prints them and no early exit can be uninstrumented.
//   * SELF-VALIDATING, IN BOTH DIRECTIONS.  The arms below must find what is
//     there AND must fail to find what is not.  The count is derived from the
//     arms that ran, never written down.  One arm is a MUTANT that corrupts pi
//     to 3 and is REQUIRED TO MISS its target; the arm after it restores the
//     engine and requires the hit to come back, so the mutant is shown to be
//     the cause.  If any arm fails, no ceiling table and no seal are emitted.
//   * NO ABSOLUTE PATH IS BAKED IN.  The corpus root is discovered by walking
//     outward from the binary and from the working directory.  If the corpus is
//     absent the program says so in those words and still prints every
//     reference figure — a gate given nothing must not pass silently.
//   * THE ANSWER IS NOT IN THE INPUT.  corpus/genotype-ceiling/focal_labels.tsv
//     carries FAM, description, h2, z and the trait id, and NOTHING ELSE: the
//     C_lo / C_point / C_hi columns were removed from it before staging, so
//     this program cannot read the number it is supposed to compute.
//
// WHAT THIS PROGRAM DOES NOT DO, stated so nobody has to guess.
//   It does not score, rank, diagnose or predict any person.  It computes a
//   BOUND on an instrument.  h2 on an occupational phenotype is the heritability
//   of WHO ENDS UP IN THAT JOB — selection into the exposure — and is not
//   tolerance of the exposure; no column in this corpus separates the two.
// ===========================================================================
import Foundation   // exit, fputs, FileManager only.  No numeric use.

// ============================== BigU ==============================
struct BigU {
    var l: [UInt32]
    init() { l = [] }
    init(_ v: UInt64) { l = []; var v = v; while v != 0 { l.append(UInt32(truncatingIfNeeded: v)); v >>= 32 } }
    init(limbs: [UInt32]) { l = limbs; while let x = l.last, x == 0 { l.removeLast() } }
    var isZero: Bool { l.isEmpty }
}
func bcmp(_ a: BigU, _ b: BigU) -> Int {
    if a.l.count != b.l.count { return a.l.count < b.l.count ? -1 : 1 }
    var i = a.l.count - 1
    while i >= 0 { if a.l[i] != b.l[i] { return a.l[i] < b.l[i] ? -1 : 1 }; i -= 1 }
    return 0
}
func badd(_ a: BigU, _ b: BigU) -> BigU {
    var r = [UInt32](); r.reserveCapacity(max(a.l.count, b.l.count) + 1)
    var carry: UInt64 = 0
    for i in 0..<max(a.l.count, b.l.count) {
        let x = UInt64(i < a.l.count ? a.l[i] : 0) + UInt64(i < b.l.count ? b.l[i] : 0) + carry
        r.append(UInt32(truncatingIfNeeded: x)); carry = x >> 32
    }
    if carry != 0 { r.append(UInt32(carry)) }
    return BigU(limbs: r)
}
func bsub(_ a: BigU, _ b: BigU) -> BigU {
    precondition(bcmp(a, b) >= 0, "bsub underflow")
    var r = [UInt32](); r.reserveCapacity(a.l.count)
    var borrow: Int64 = 0
    for i in 0..<a.l.count {
        var x = Int64(a.l[i]) - Int64(i < b.l.count ? b.l[i] : 0) - borrow
        if x < 0 { x += 4294967296; borrow = 1 } else { borrow = 0 }
        r.append(UInt32(x))
    }
    precondition(borrow == 0, "bsub underflow")
    return BigU(limbs: r)
}
func bsubSat(_ a: BigU, _ b: BigU) -> BigU { bcmp(a, b) <= 0 ? BigU() : bsub(a, b) }
func bmul(_ a: BigU, _ b: BigU) -> BigU {
    if a.isZero || b.isZero { return BigU() }
    var r = [UInt32](repeating: 0, count: a.l.count + b.l.count)
    for i in 0..<a.l.count {
        var carry: UInt64 = 0
        let ai = UInt64(a.l[i])
        for j in 0..<b.l.count {
            let t = ai * UInt64(b.l[j]) + UInt64(r[i + j]) + carry
            r[i + j] = UInt32(truncatingIfNeeded: t); carry = t >> 32
        }
        var k = i + b.l.count
        while carry != 0 { let t = UInt64(r[k]) + carry; r[k] = UInt32(truncatingIfNeeded: t); carry = t >> 32; k += 1 }
    }
    return BigU(limbs: r)
}
func bdivSmall(_ a: BigU, _ d: UInt32) -> (q: BigU, r: UInt32) {
    precondition(d != 0)
    if a.isZero { return (BigU(), 0) }
    var q = [UInt32](repeating: 0, count: a.l.count)
    var rem: UInt64 = 0
    var i = a.l.count - 1
    while i >= 0 {
        let cur = (rem << 32) | UInt64(a.l[i])
        q[i] = UInt32(cur / UInt64(d)); rem = cur % UInt64(d)
        i -= 1
    }
    return (BigU(limbs: q), UInt32(rem))
}
func divSmallFloor(_ a: BigU, _ d: UInt32) -> BigU { bdivSmall(a, d).q }
func divSmallCeil(_ a: BigU, _ d: UInt32) -> BigU { let (q, r) = bdivSmall(a, d); return r != 0 ? badd(q, BigU(1)) : q }
func bdivPow10(_ a: BigU, _ k: Int) -> (q: BigU, lost: Bool) {
    var cur = a; var lost = false; var left = k
    while left >= 9 { let (q, r) = bdivSmall(cur, 1_000_000_000); cur = q; if r != 0 { lost = true }; left -= 9 }
    if left > 0 {
        var d: UInt32 = 1; for _ in 0..<left { d *= 10 }
        let (q, r) = bdivSmall(cur, d); cur = q; if r != 0 { lost = true }
    }
    return (cur, lost)
}
func bpow10raw(_ k: Int) -> BigU {
    var r = BigU(1); var left = k
    while left >= 9 { r = bmul(r, BigU(1_000_000_000)); left -= 9 }
    if left > 0 { var d: UInt64 = 1; for _ in 0..<left { d *= 10 }; r = bmul(r, BigU(d)) }
    return r
}
// memoised: bpow10 is called inside the bisection loop and rebuilding a 120-digit
// constant per probe dominated the run time.  Same values, computed once.
let POW10_CACHE: [BigU] = (0...400).map { bpow10raw($0) }
@inline(__always) func bpow10(_ k: Int) -> BigU { k <= 400 ? POW10_CACHE[k] : bpow10raw(k) }
func bdec(_ a: BigU) -> String {
    if a.isZero { return "0" }
    var s = ""; var cur = a
    while !cur.isZero {
        let (q, r) = bdivSmall(cur, 1_000_000_000); cur = q
        if cur.isZero { s = String(r) + s }
        else { var t = String(r); while t.count < 9 { t = "0" + t }; s = t + s }
    }
    return s
}
func bfromDec(_ s: String) -> BigU {
    var r = BigU()
    for ch in s { guard let a = ch.asciiValue, a >= 48, a <= 57 else { continue }
        r = badd(bmul(r, BigU(10)), BigU(UInt64(a - 48))) }
    return r
}

// ============================== FIXED POINT ==============================
// value X denotes the exact rational X / 10^SCALE_D
let SCALE_D = 60
let SCALE: BigU = bpow10(SCALE_D)
func mulFixFloor(_ a: BigU, _ b: BigU) -> BigU { bdivPow10(bmul(a, b), SCALE_D).q }
func mulFixCeil(_ a: BigU, _ b: BigU) -> BigU {
    let (q, lost) = bdivPow10(bmul(a, b), SCALE_D); return lost ? badd(q, BigU(1)) : q
}

// ============================== atan(1/n), interval ==============================
// atan(1/n) = sum_{k>=0} (-1)^k / ((2k+1) n^(2k+1)).  Terms strictly decreasing.
func atanRecip(_ n: UInt32, terms K: Int) -> (lo: BigU, hi: BigU) {
    precondition(K % 2 == 0, "K even so the lo sum ends on a subtraction")
    let n2 = n * n
    var uLo = divSmallFloor(SCALE, n)
    var uHi = divSmallCeil(SCALE, n)
    var tLo = [BigU](); var tHi = [BigU]()
    for k in 0..<K {
        let d = UInt32(2 * k + 1)
        tLo.append(divSmallFloor(uLo, d))
        tHi.append(divSmallCeil(uHi, d))
        uLo = divSmallFloor(uLo, n2)
        uHi = divSmallCeil(uHi, n2)
    }
    var lo = BigU()                       // k = 0 .. K-1, last k odd -> ends on subtraction
    for k in 0..<K { lo = (k % 2 == 0) ? badd(lo, tLo[k]) : bsubSat(lo, tHi[k]) }
    var hi = BigU()                       // k = 0 .. K-2, last k even -> ends on addition
    for k in 0..<(K - 1) { hi = (k % 2 == 0) ? badd(hi, tHi[k]) : bsubSat(hi, tLo[k]) }
    return (lo, hi)
}
func computePi() -> (lo: BigU, hi: BigU) {
    let a5 = atanRecip(5, terms: 120)      // 5^241 >> 10^60
    let a239 = atanRecip(239, terms: 60)   // 239^121 >> 10^60
    return (bsub(bmul(BigU(16), a5.lo), bmul(BigU(4), a239.hi)),
            bsub(bmul(BigU(16), a5.hi), bmul(BigU(4), a239.lo)))
}
let PI = computePi()
var PI_ACTIVE = PI          // mutable ONLY so the V3 mutant arm can corrupt it

// ============================== sin, interval ==============================
// sin(y) = sum (-1)^k y^(2k+1)/(2k+1)!  for exact fixed-point y in [0, 2].
// M_{k+1} = M_k * y^2 / ((2k+2)(2k+3)).  Strictly decreasing for y < sqrt(6).
let SIN_TERMS = 40
func sinLoOf(_ y: BigU) -> BigU {
    var mLo = y; var mHi = y
    var lo = BigU()
    var ms: [(BigU, BigU)] = []
    for k in 0..<SIN_TERMS {
        ms.append((mLo, mHi))
        let d = UInt32((2 * k + 2) * (2 * k + 3))
        mLo = divSmallFloor(mulFixFloor(mulFixFloor(mLo, y), y), d)
        mHi = divSmallCeil(mulFixCeil(mulFixCeil(mHi, y), y), d)
    }
    for k in 0..<SIN_TERMS { lo = (k % 2 == 0) ? badd(lo, ms[k].0) : bsubSat(lo, ms[k].1) }
    return lo                                // SIN_TERMS even -> ends on a subtraction
}
func sinHiOf(_ y: BigU) -> BigU {
    var mLo = y; var mHi = y
    var hi = BigU()
    var ms: [(BigU, BigU)] = []
    for k in 0..<SIN_TERMS {
        ms.append((mLo, mHi))
        let d = UInt32((2 * k + 2) * (2 * k + 3))
        mLo = divSmallFloor(mulFixFloor(mulFixFloor(mLo, y), y), d)
        mHi = divSmallCeil(mulFixCeil(mulFixCeil(mHi, y), y), d)
    }
    for k in 0..<(SIN_TERMS - 1) { hi = (k % 2 == 0) ? badd(hi, ms[k].1) : bsubSat(hi, ms[k].0) }
    return hi                                // ends on an addition
}

// ============================== C bracket ==============================
// rho^2 given as the exact rational  rnum / 10^rpow  in [0,1].
// Returns [cLo, cHi] as integers over 10^12, plus a flag.
let GRID_D = 12
let GRID: BigU = bpow10(GRID_D)            // 10^12
let HALFGRID: BigU = bpow10(GRID_D - 1)    // 10^11  ... times 5 = 5*10^11

enum Probe { case below, above, undetermined }

var UNDETERMINED_EVENTS = 0

// Is rho <= sin(pi * T/10^GRID_D) ?   T in [0, 5*10^11].
func probeT(_ T: BigU, rnum: BigU, rpow: Int, rhsPre: BigU? = nil, powRpre: BigU? = nil) -> Probe {
    // pi*t bracket, in fixed point
    let yLo = bdivPow10(bmul(PI_ACTIVE.lo, T), GRID_D).q
    let yHiR = bdivPow10(bmul(PI_ACTIVE.hi, T), GRID_D)
    let yHi = yHiR.lost ? badd(yHiR.q, BigU(1)) : yHiR.q
    let sLo = sinLoOf(yLo)
    let sHi = sinHiOf(yHi)
    // compare s^2 with rho^2 = rnum/10^rpow :  s^2 = S^2 / 10^(2*SCALE_D)
    //   s^2 <=> rho^2   <==>   S^2 * 10^rpow <=> rnum * 10^(2*SCALE_D)
    let rhs = rhsPre ?? bmul(rnum, bpow10(2 * SCALE_D))
    let pr = powRpre ?? bpow10(rpow)
    let lhsHi = bmul(bmul(sHi, sHi), pr)
    let lhsLo = bmul(bmul(sLo, sLo), pr)
    if bcmp(lhsHi, rhs) < 0 { return .below }      // sin(pi t) < rho  -> e > t
    if bcmp(lhsLo, rhs) > 0 { return .above }      // sin(pi t) > rho  -> e < t
    return .undetermined
}

struct CBracket { var lo: BigU; var hi: BigU; var flag: String }

func cBracket(rnum: BigU, rpow: Int, negative: Bool, overOne: Bool) -> CBracket {
    if negative { return CBracket(lo: bmul(BigU(5), HALFGRID), hi: bmul(BigU(5), HALFGRID), flag: "CLAMP0") }
    if overOne  { return CBracket(lo: GRID, hi: GRID, flag: "CLAMP1") }
    if rnum.isZero { return CBracket(lo: bmul(BigU(5), HALFGRID), hi: bmul(BigU(5), HALFGRID), flag: "EXACT_HALF") }
    // rho^2 == 1 exactly ?
    if bcmp(rnum, bpow10(rpow)) == 0 { return CBracket(lo: GRID, hi: GRID, flag: "EXACT_ONE") }
    // bisect e in [0, 5*10^11] over integers T
    var tLo = BigU()                       // e >= tLo/10^12
    var tHi = bmul(BigU(5), HALFGRID)      // e <= tHi/10^12
    var flag = "OK"
    var guardCount = 0
    let rhsPre = bmul(rnum, bpow10(2 * SCALE_D))
    let powRpre = bpow10(rpow)
    while bcmp(bsub(tHi, tLo), BigU(1)) > 0 {
        guardCount += 1; if guardCount > 200 { flag = "GUARD"; break }
        let mid = bdivSmall(badd(tLo, tHi), 2).q
        switch probeT(mid, rnum: rnum, rpow: rpow, rhsPre: rhsPre, powRpre: powRpre) {
        case .below: tLo = mid
        case .above: tHi = mid
        case .undetermined:
            UNDETERMINED_EVENTS += 1
            // sin(pi*mid) equals rho to within the sin bracket width (< 10^-40 by the
            // engine's own width check), so e differs from mid by less than one grid unit.
            tLo = bsubSat(mid, BigU(1)); tHi = badd(mid, BigU(1)); flag = "TIE"
            guardCount = 999
        }
        if guardCount == 999 { break }
    }
    let half = bmul(BigU(5), HALFGRID)
    return CBracket(lo: badd(half, tLo), hi: badd(half, tHi), flag: flag)
}

// ============================== decimal parsing ==============================
// exact, by string ops.  Never a float round-trip.
struct Dec { var neg: Bool; var digits: BigU; var pow: Int }   // value = (neg?-1:1)*digits/10^pow
func parseDec(_ raw: String) -> Dec? {
    var s = raw.trimmingCharactersASCII()
    if s.isEmpty { return nil }
    let low = s.lowercased()
    if low == "na" || low == "nan" || low == "inf" || low == "-inf" || low == "none" || low == "null" { return nil }
    var neg = false
    if s.hasPrefix("-") { neg = true; s.removeFirst() } else if s.hasPrefix("+") { s.removeFirst() }
    var expPart = 0
    if let eIdx = s.firstIndex(where: { $0 == "e" || $0 == "E" }) {
        let e = String(s[s.index(after: eIdx)...]); s = String(s[..<eIdx])
        guard let ev = Int(e) else { return nil }
        expPart = ev
    }
    var mant = ""; var pow = 0; var seenDot = false
    for ch in s {
        if ch == "." { if seenDot { return nil }; seenDot = true; continue }
        guard let a = ch.asciiValue, a >= 48, a <= 57 else { return nil }
        mant.append(ch); if seenDot { pow += 1 }
    }
    if mant.isEmpty { return nil }
    pow -= expPart
    var d = bfromDec(mant)
    if pow < 0 { d = bmul(d, bpow10(-pow)); pow = 0 }
    return Dec(neg: neg, digits: d, pow: pow)
}
extension String {
    func trimmingCharactersASCII() -> String {
        var s = Substring(self)
        while let f = s.first, f == " " || f == "\t" || f == "\r" || f == "\n" { s.removeFirst() }
        while let l = s.last, l == " " || l == "\t" || l == "\r" || l == "\n" { s.removeLast() }
        return String(s)
    }
}
// align two Decs to a common power
func alignPow(_ a: Dec, _ b: Dec) -> (BigU, Bool, BigU, Bool, Int) {
    let p = max(a.pow, b.pow)
    let av = bmul(a.digits, bpow10(p - a.pow))
    let bv = bmul(b.digits, bpow10(p - b.pow))
    return (av, a.neg, bv, b.neg, p)
}

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


// ===========================================================================
// PART 2 — THE PUBLISHED REFERENCE FIGURES.
// Printed as the very first action, before any file is opened, so that EVERY
// exit path — a missing corpus, a failed arm, a malformed row — still prints
// them.  An uninstrumented early exit would fail every pin in validate.sh, and
// that is the point: a program that can exit silently is a program whose
// figures nobody is checking.
// ===========================================================================
setvbuf(stdout, nil, _IONBF, 0)      // block buffering leaves a ZERO-BYTE file on abnormal exit

let MARKER = "GENOTYPE_SCORE_CEILING__EXACT_ARCSIN_BRACKET_OVER_1E12"

func rule(_ s: String = "") { print(s) }

rule("=== \(MARKER) ===")
rule("")
rule("PUBLISHED REFERENCE FIGURES — pinned before any file is opened")
rule("  phenotypes with an LDSC h2 and a standard error ......... 56")
rule("  a coin ................................................. C = 0.500000000000")
rule("  lower median ceiling ................................... C = 0.573212381656")
rule("  maximum ceiling ........................................ C = 0.602142835007")
rule("  maximum anywhere, top of a 2-SE interval ............... C = 0.610622725745")
rule("  minimum ceiling ........................................ C = 0.527947611149")
rule("  phenotypes reaching C = 0.62 at the top of their interval  0")
rule("  phenotypes reaching C = 0.65 at the top of their interval  0")
rule("  Job involves shift work (826) .......... [0.538042338431 .. 0.549890300690]")
rule("  Job involves shift work (826), point .................. 0.544353505508")
rule("  Length of working week (767_irnt), point .............. 0.541714427173")
rule("  Time employed in main current job (757_irnt), point ... 0.530300726943")
rule("")

// ===========================================================================
// PART 3 — SELF-TEST.  Both directions.  The count is derived from the arms
// that ran; nothing here is a literal `true`.
// ===========================================================================
var ARM_LINES: [String] = []
var ARM_FAILS = 0
func arm(_ name: String, _ ok: Bool, _ detail: String) {
    ARM_LINES.append("  \(ok ? "PASS" : "FAIL")  \(name)  \(detail)")
    if !ok { ARM_FAILS += 1 }
}

let piCanon = bfromDec("3141592653589793238462643383279502884197169399375105820974944")
// A wrong constant must be wrong AT THE INSTRUMENT'S OWN RESOLUTION or it is not a
// control: a value differing from pi only in the last 3 of 60 decimals sits INSIDE
// the engine bracket and cannot fail.  Both below differ at the 40th decimal.
let piWrongHi = badd(piCanon, bpow10(20))
let piWrongLo = bsub(piCanon, bpow10(20))
arm("A01 pi brackets the canonical constant",
    bcmp(PI.lo, piCanon) <= 0 && bcmp(PI.hi, piCanon) >= 0, "")
arm("A02 pi EXCLUDES a constant too HIGH by 1e-40",
    !(bcmp(PI.lo, piWrongHi) <= 0 && bcmp(PI.hi, piWrongHi) >= 0), "control")
arm("A03 pi EXCLUDES a constant too LOW by 1e-40",
    !(bcmp(PI.lo, piWrongLo) <= 0 && bcmp(PI.hi, piWrongLo) >= 0), "control")
arm("A04 pi bracket width < 1e-40",
    bcmp(bsub(PI.hi, PI.lo), bpow10(20)) < 0, "")
let yQ = bdivSmall(PI.lo, 4).q
arm("A05 sin bracket width < 1e-40  (the TIE branch rests on this)",
    bcmp(bsub(sinHiOf(yQ), sinLoOf(yQ)), bpow10(20)) < 0, "")
let ySix = bdivSmall(PI.lo, 6).q
let sLo6 = sinLoOf(ySix), sHi6 = sinHiOf(bdivSmall(PI.hi, 6).q)
let half59 = bmul(BigU(5), bpow10(59))
arm("A06 sin(pi/6) brackets one half exactly",
    bcmp(sLo6, half59) <= 0 && bcmp(sHi6, half59) >= 0, "")
arm("A07 sin(pi/6) EXCLUDES 0.51",
    !(bcmp(sLo6, bmul(BigU(51), bpow10(58))) <= 0 && bcmp(sHi6, bmul(BigU(51), bpow10(58))) >= 0),
    "control")

// C has exact rational images at these rho^2.  Each is a mathematical fact,
// hand-checkable, and NOT a literal of the code under test.
func armExact(_ nm: String, _ digits: String, _ pow: Int, _ lo: String, _ hi: String) {
    let cb = cBracket(rnum: bfromDec(digits), rpow: pow, negative: false, overOne: false)
    let inside = bcmp(cb.lo, bfromDec(lo)) <= 0 && bcmp(cb.hi, bfromDec(hi)) >= 0
    arm(nm, inside && bcmp(bsub(cb.hi, cb.lo), BigU(2)) <= 0,
        "got [\(bdec(cb.lo)), \(bdec(cb.hi))] flag=\(cb.flag)")
}
armExact("A08 rho^2 = 0   -> C = 1/2", "0",  0, "500000000000",  "500000000000")
armExact("A09 rho^2 = 1/4 -> C = 2/3", "25", 2, "666666666666",  "666666666667")
armExact("A10 rho^2 = 1/2 -> C = 3/4", "5",  1, "750000000000",  "750000000000")
armExact("A11 rho^2 = 3/4 -> C = 5/6", "75", 2, "833333333333",  "833333333334")
armExact("A12 rho^2 = 1   -> C = 1",   "1",  0, "1000000000000", "1000000000000")
let cQ = cBracket(rnum: bfromDec("25"), rpow: 2, negative: false, overOne: false)
arm("A13 rho^2 = 1/4 EXCLUDES 0.700000000000",
    !(bcmp(cQ.lo, bfromDec("700000000000")) <= 0 && bcmp(cQ.hi, bfromDec("700000000000")) >= 0),
    "control")

var monoPrev = BigU(); var mono = true
for h in ["0","1","2","5","10","20","50","95","250","500","750","1000"] {
    let cb = cBracket(rnum: bfromDec(h), rpow: 4, negative: false, overOne: false)
    if bcmp(cb.lo, monoPrev) < 0 { mono = false }
    monoPrev = cb.lo
}
arm("A14 C is monotone in h2 over 12 rungs, 0 .. 0.1", mono, "")

// MUTANT.  Required to MISS.  If it hits, the engine is not discriminating and
// every figure above it is a turn counter rather than a measurement.
let savedPi = PI_ACTIVE
PI_ACTIVE = (bmul(BigU(3), SCALE), bmul(BigU(3), SCALE))
let mut = cBracket(rnum: bfromDec("25"), rpow: 2, negative: false, overOne: false)
let mutHit = bcmp(mut.lo, bfromDec("666666666666")) <= 0 && bcmp(mut.hi, bfromDec("666666666667")) >= 0
PI_ACTIVE = savedPi
arm("A15 MUTANT pi := 3 MUST MISS 2/3", !mutHit, "mutant gave [\(bdec(mut.lo)), \(bdec(mut.hi))]")
let restored = cBracket(rnum: bfromDec("25"), rpow: 2, negative: false, overOne: false)
arm("A16 restored engine hits 2/3 again — the mutant was the cause",
    bcmp(restored.lo, bfromDec("666666666666")) <= 0 && bcmp(restored.hi, bfromDec("666666666667")) >= 0, "")

func parseArm(_ nm: String, _ s: String, _ shouldParse: Bool) {
    arm(nm, (parseDec(s) != nil) == shouldParse, "input='\(s)'")
}
parseArm("A17 parse plain decimal",  "0.09500686812137578", true)
parseArm("A18 parse scientific",     "4.9e-08",             true)
parseArm("A19 parse negative",       "-0.002257916096237472", true)
parseArm("A20 REJECT NA",            "NA",                  false)
parseArm("A21 REJECT nan",           "nan",                 false)
parseArm("A22 REJECT inf",           "inf",                 false)
parseArm("A23 REJECT malformed",     "0.1.2",               false)
parseArm("A24 REJECT empty",         "",                    false)
let bigP = parseDec("0.123456789012345678901234567890123456789")
arm("A25 parse 39 significant digits — more than a Double holds",
    bigP != nil && bdec(bigP!.digits) == "123456789012345678901234567890123456789", "")

rule("SELF-TEST — every arm runs before any corpus byte is read")
for l in ARM_LINES { rule(l) }
rule("  arms run = \(ARM_LINES.count)   failed = \(ARM_FAILS)")
rule("")
if ARM_FAILS != 0 {
    rule("REFUSED — a self-test arm failed. No ceiling table and no seal are emitted.")
    exit(2)
}

// ===========================================================================
// PART 4 — THE CORPUS.  Discovered, never baked in.
// ===========================================================================
let FM = FileManager.default
let CORPUS_ROOT: String = {
    var cands: [String] = []
    let exe = CommandLine.arguments.first ?? ""
    if !exe.isEmpty {
        var d = (exe as NSString).deletingLastPathComponent
        for _ in 0..<8 { cands.append(d); d = (d as NSString).deletingLastPathComponent
                         if d.isEmpty || d == "/" { break } }
    }
    var w = FM.currentDirectoryPath
    for _ in 0..<8 { cands.append(w); w = (w as NSString).deletingLastPathComponent
                     if w.isEmpty || w == "/" { break } }
    for c in cands where FM.fileExists(atPath: c + "/corpus/genotype-ceiling/focal_h2se.tsv") { return c }
    return ""
}()

func readLines(_ p: String) -> [String]? {
    guard let d = FM.contents(atPath: p), let s = String(data: d, encoding: .utf8) else { return nil }
    return s.split(separator: "\n", omittingEmptySubsequences: true).map(String.init)
}

if CORPUS_ROOT.isEmpty {
    rule("CORPUS ABSENT — corpus/genotype-ceiling/focal_h2se.tsv was not found by walking")
    rule("outward from the binary or the working directory. The reference figures above are")
    rule("the PUBLISHED values and were NOT recomputed on this run. Nothing is sealed.")
    exit(3)
}

guard let h2Rows = readLines(CORPUS_ROOT + "/corpus/genotype-ceiling/focal_h2se.tsv"),
      let labRows = readLines(CORPUS_ROOT + "/corpus/genotype-ceiling/focal_labels.tsv") else {
    rule("CORPUS UNREADABLE — the files exist and could not be read. Nothing is sealed.")
    exit(3)
}

// labels: FAM \t DESCRIPTION \t h2 \t z \t TRAIT   (the C columns were removed before staging)
var famOf: [String: String] = [:]
var descOf: [String: String] = [:]
var zOf: [String: String] = [:]
for (i, l) in labRows.enumerated() {
    if i == 0 { continue }                       // header
    let f = l.split(separator: "\t", omittingEmptySubsequences: false).map(String.init)
    if f.count < 5 { continue }
    famOf[f[4]] = f[0]; descOf[f[4]] = f[1]; zOf[f[4]] = f[3]
}
// THE ANSWER MUST NOT BE IN THE INPUT.  Refuse if the staged label file still
// carries a C column — a program that can read its own verdict is not measuring.
if let hdr = labRows.first, hdr.contains("C_lo") || hdr.contains("C_point") || hdr.contains("C_hi") {
    rule("REFUSED — focal_labels.tsv carries a C column. This program must COMPUTE C,")
    rule("never read it. Restage the corpus with the answer columns removed.")
    exit(2)
}

// ===========================================================================
// PART 5 — THE CEILING, COMPUTED.
// h2 and its standard error are parsed from decimal TEXT to exact rationals.
// The bracket is h2 - 1ulp - 2se .. h2 + 1ulp + 2se, each end pushed through
// the same exact arcsin bracket.  A negative lower end clamps at the coin,
// because a score that estimates a non-positive genetic variance ranks no
// better than chance; an upper end above 1 clamps at C = 1.
// ===========================================================================
struct SInt { var neg: Bool; var m: BigU }
func sAdd(_ a: SInt, _ b: SInt) -> SInt {
    if a.neg == b.neg { return SInt(neg: a.neg, m: badd(a.m, b.m)) }
    if bcmp(a.m, b.m) >= 0 { return SInt(neg: a.neg, m: bsub(a.m, b.m)) }
    return SInt(neg: b.neg, m: bsub(b.m, a.m))
}
func sNeg(_ a: SInt) -> SInt { a.m.isZero ? a : SInt(neg: !a.neg, m: a.m) }
func cFromSigned(_ v: SInt, _ p: Int) -> CBracket {
    if v.neg && !v.m.isZero { return cBracket(rnum: BigU(), rpow: p, negative: true,  overOne: false) }
    if bcmp(v.m, bpow10(p)) > 0 { return cBracket(rnum: BigU(), rpow: p, negative: false, overOne: true) }
    return cBracket(rnum: v.m, rpow: p, negative: false, overOne: false)
}
// print an integer over 10^12 as a 12-place decimal, by string surgery only
func asC(_ v: BigU) -> String {
    var s = bdec(v)
    while s.count < 13 { s = "0" + s }
    let cut = s.index(s.endIndex, offsetBy: -12)
    return String(s[s.startIndex..<cut]) + "." + String(s[cut...])
}

struct Row { var trait: String; var fam: String; var desc: String; var z: String
             var lo: BigU; var pt: BigU; var hi: BigU; var flag: String; var h2: String }
var rows: [Row] = []
var malformed = 0
for l in h2Rows {
    let f = l.split(separator: "\t", omittingEmptySubsequences: false).map(String.init)
    guard f.count >= 3, let h = parseDec(f[1]), let se = parseDec(f[2]), !se.neg else {
        malformed += 1; continue
    }
    let p = max(h.pow, se.pow)
    let hS    = SInt(neg: h.neg, m: bmul(h.digits, bpow10(p - h.pow)))
    let seS   = SInt(neg: false, m: bmul(se.digits, bpow10(p - se.pow)))
    let ulp   = SInt(neg: false, m: bpow10(p - h.pow))
    let twoSe = SInt(neg: false, m: bmul(BigU(2), seS.m))
    let cl = cFromSigned(sAdd(sAdd(hS, sNeg(ulp)), sNeg(twoSe)), p)
    let cp = cFromSigned(hS, p)
    let ch = cFromSigned(sAdd(sAdd(hS, ulp), twoSe), p)
    rows.append(Row(trait: f[0], fam: famOf[f[0]] ?? "?", desc: descOf[f[0]] ?? "?",
                    z: zOf[f[0]] ?? "?", lo: cl.lo, pt: cp.lo, hi: ch.hi,
                    flag: cp.flag, h2: f[1]))
}

if rows.isEmpty {
    rule("REFUSED — the corpus was found and yielded no scoreable row. Nothing is sealed.")
    exit(2)
}

// ---- the table, sorted by the computed point ceiling, descending ----------
rows.sort { bcmp($0.pt, $1.pt) > 0 }
rule("THE CEILING, COMPUTED FROM THE CORPUS — \(rows.count) phenotypes, \(malformed) malformed")
rule("")
rule("  C_lo          C_point       C_hi          h2_z        trait        description")
for r in rows {
    var z = r.z; if z.count > 10 { z = String(z.prefix(10)) }
    while z.count < 10 { z += " " }
    var t = r.trait; while t.count < 12 { t += " " }
    rule("  \(asC(r.lo))  \(asC(r.pt))  \(asC(r.hi))  \(z)  \(t) \(r.desc)")
}
rule("")
// ===========================================================================
// PART 6 — THE SUMMARY.  Every figure below is DERIVED FROM THE ROWS JUST
// COMPUTED, never from a literal and never from the input's own size.  The
// median is taken as the LOWER median of an even count, stated so, because a
// mean of two ceilings is not a ceiling.
// ===========================================================================
let sortedPt = rows.map { $0.pt }.sorted { bcmp($0, $1) < 0 }
let sortedHi = rows.map { $0.hi }.sorted { bcmp($0, $1) < 0 }
let lowerMedianIdx = (rows.count % 2 == 0) ? (rows.count / 2 - 1) : (rows.count / 2)
let medPt = sortedPt[lowerMedianIdx]
let maxPt = sortedPt[sortedPt.count - 1]
let minPt = sortedPt[0]
let maxHi = sortedHi[sortedHi.count - 1]
let maxRow = rows.first { bcmp($0.pt, maxPt) == 0 }
let minRow = rows.first { bcmp($0.pt, minPt) == 0 }
let medRow = rows.first { bcmp($0.pt, medPt) == 0 }

func countAtLeast(_ threshold: String) -> Int {
    let t = bfromDec(threshold)
    return rows.reduce(0) { $0 + (bcmp($1.hi, t) >= 0 ? 1 : 0) }
}
let n62 = countAtLeast("620000000000")
let n65 = countAtLeast("650000000000")

rule("SUMMARY — derived from the \(rows.count) rows above")
rule("  a coin ....................................... C = 0.500000000000")
rule("  lower median ceiling ......................... C = \(asC(medPt))   \(medRow?.desc ?? "")")
rule("  maximum ceiling .............................. C = \(asC(maxPt))   \(maxRow?.desc ?? "")")
rule("  maximum anywhere, top of a 2-SE interval ..... C = \(asC(maxHi))")
rule("  minimum ceiling .............................. C = \(asC(minPt))   \(minRow?.desc ?? "")")
rule("  phenotypes reaching C = 0.62 at the top of their interval  \(n62)")
rule("  phenotypes reaching C = 0.65 at the top of their interval  \(n65)")
rule("")

// ---- the three work-exposure phenotypes, named ---------------------------
rule("THE WORK-EXPOSURE PHENOTYPES")
for id in ["826", "767_irnt", "757_irnt"] {
    guard let r = rows.first(where: { $0.trait == id }) else {
        rule("  \(id)  ABSENT from the corpus"); continue
    }
    rule("  \(r.desc) (\(id))")
    rule("      [\(asC(r.lo)) .. \(asC(r.hi))]   point \(asC(r.pt))")
}
rule("")
rule("  A PERFECT genotype-only score for shift-work status ranks two people in their")
rule("  true order about 54.4 times in 100, against 50 for a coin. That is the CEILING")
rule("  on the instrument, not a measurement of any person, and h2 on an occupational")
rule("  phenotype is the heritability of WHO ENDS UP IN THAT JOB — selection into the")
rule("  exposure — never tolerance of it.")
rule("")

// ===========================================================================
// PART 6b — HOW MUCH HEADROOM THE FIELD HAS LEFT.
// Complete enumeration of the staged PGS Catalog performance rows.  The
// selection rule is STATED, not curated:
//
//   * the reported trait must be named in corpus/genotype-ceiling/trait_pins.tsv,
//     which was written before any comparison ran;
//   * the evaluated ancestry must be European;
//   * the metric must be a partial correlation (read as rho) or an R2 of the
//     incremental / partial / PGS-only families (read as rho^2).  A percentage
//     scale, a Nagelkerke pseudo-R2, an AUROC and a bare unqualified "R2" are
//     NOT comparable quantities and are counted and excluded, not silently
//     dropped;
//   * a claim whose ceiling-converted C exceeds the trait's OWN 2-SE ceiling is
//     reported separately and excluded from the best, because a score cannot
//     beat the additive genetic value it estimates — such a row is evidence
//     about the metric or the evaluation sample, not about the score.
//
// CAPTURED = the share of the achievable excess over a coin that the best
// published score already holds, as exact integer per-mille, floored.
// ===========================================================================
func clsOf(_ lab: String) -> String {
    let t = lab.lowercased()
    if t.contains("*100") || t.contains("percent") || t.contains("%")      { return "PCT_SCALE" }
    if t.contains("nagelkerke")                                            { return "NAGELKERKE" }
    if t.contains("partial correlation") || t.contains("(partial-r)")      { return "RCORR" }
    if t.contains("pearson") || t.contains("spearman")                     { return "RCORR" }
    if t.contains("incremental r2") || t.contains("incremental r\u{b2}")   { return "R2" }
    if t.contains("partial-r2") || t.contains("partial r2")
       || t.contains("partial-r\u{b2}") || t.contains("partial r\u{b2}")   { return "R2" }
    if t.contains("pgs r2") || t.contains("pgs r\u{b2}")                   { return "R2" }
    if t.contains("auroc") || t.contains("auc") || t.contains("c-index")
       || t.contains("cindex") || t.contains("concordance") || t.contains("youden") { return "AUROC" }
    let tt = t.trimmingCharactersASCII()
    if tt.hasPrefix("r\u{b2}") || tt.hasPrefix("r2")
       || t.contains("adjusted r2") || t.contains("variance explained")    { return "R2_AMBIGUOUS" }
    return "OTHER"
}
func leadingNumber(_ s: String) -> String? {
    var out = ""; var seenDigit = false; var seenDot = false; var i = s.startIndex
    if i < s.endIndex, s[i] == "-" { out.append("-"); i = s.index(after: i) }
    while i < s.endIndex, let a = s[i].asciiValue, a >= 48, a <= 57 { out.append(s[i]); seenDigit = true; i = s.index(after: i) }
    if !seenDigit { return nil }
    if i < s.endIndex, s[i] == "." {
        var j = s.index(after: i); var frac = ""
        while j < s.endIndex, let a = s[j].asciiValue, a >= 48, a <= 57 { frac.append(s[j]); j = s.index(after: j) }
        if !frac.isEmpty { out += "." + frac; i = j; seenDot = true }
    }
    _ = seenDot
    if i < s.endIndex, s[i] == "e" || s[i] == "E" {
        var j = s.index(after: i); var ex = ""
        if j < s.endIndex, s[j] == "+" || s[j] == "-" { ex.append(s[j]); j = s.index(after: j) }
        var d = ""
        while j < s.endIndex, let a = s[j].asciiValue, a >= 48, a <= 57 { d.append(s[j]); j = s.index(after: j) }
        if !d.isEmpty { out += String(s[i]) + ex + d }
    }
    return out
}
// split on commas that are OUTSIDE brackets, WITHOUT deleting any text
func splitTopLevel(_ raw: String) -> [String] {
    var parts: [String] = []; var cur = ""; var depth = 0
    for ch in raw {
        if ch == "[" || ch == "(" { depth += 1 }
        else if ch == "]" || ch == ")" { depth -= 1 }
        if ch == "," && depth <= 0 { parts.append(cur); cur = "" } else { cur.append(ch) }
    }
    parts.append(cur); return parts
}

var pinOf: [String: String] = [:]
if let pinRows = readLines(CORPUS_ROOT + "/corpus/genotype-ceiling/trait_pins.tsv") {
    for l in pinRows {
        let f = l.split(separator: "\t", omittingEmptySubsequences: false).map(String.init)
        if f.count >= 2 { pinOf[f[0]] = f[1] }
    }
}
struct Claim { var c: BigU; var pgs: String; var metric: String; var value: String }
var bestOf: [String: Claim] = [:]
var aboveCeiling: [Claim] = []
var aboveTrait: [String] = []
var perfRows = 0, metricsSeen = 0, notComparable: [String: Int] = [:]
var pgsScoresSeen = Set<String>()

if let perf = readLines(CORPUS_ROOT + "/corpus/genotype-ceiling/pgs_perf_fam.tsv") {
    for l in perf {
        let f = l.split(separator: "\t", omittingEmptySubsequences: false).map(String.init)
        if f.count < 13 { continue }
        perfRows += 1
        pgsScoresSeen.insert(f[2])
        guard let trait = pinOf[f[3]] else { continue }
        guard f[11].contains("European") else { continue }
        for p in splitTopLevel(f[7]) {
            guard let eq = p.firstIndex(of: "=") else { continue }
            let lab = String(p[p.startIndex..<eq]).trimmingCharactersASCII()
            var val = String(p[p.index(after: eq)...]).trimmingCharactersASCII()
            if val.hasPrefix("["), let close = val.firstIndex(of: "]") {
                val = String(val[val.index(after: close)...]).trimmingCharactersASCII()
            }
            guard let numStr = leadingNumber(val), let d = parseDec(numStr) else { continue }
            metricsSeen += 1
            let k = clsOf(lab)
            if k != "RCORR" && k != "R2" { notComparable[k, default: 0] += 1; continue }
            if d.neg || d.digits.isZero { notComparable["NON_POSITIVE", default: 0] += 1; continue }
            // RCORR is rho; R2 is rho^2
            let r2num = (k == "RCORR") ? bmul(d.digits, d.digits) : d.digits
            let r2pow = (k == "RCORR") ? 2 * d.pow : d.pow
            let cb = cBracket(rnum: r2num, rpow: r2pow,
                              negative: false, overOne: bcmp(r2num, bpow10(r2pow)) > 0)
            let claim = Claim(c: cb.lo, pgs: f[2], metric: lab, value: numStr)
            // above its own trait's 2-SE ceiling?
            if let row = rows.first(where: { $0.trait == trait }), bcmp(cb.lo, row.hi) > 0 {
                aboveCeiling.append(claim); aboveTrait.append(trait); continue
            }
            if let cur = bestOf[trait], bcmp(cur.c, cb.lo) >= 0 { continue }
            bestOf[trait] = claim
        }
    }
}

// CAPTURED, exact integer per-mille, floored.  Both C values are integers over
// 10^12, so this is integer arithmetic end to end.
func capturedPerMille(_ best: BigU, _ ceil: BigU) -> String {
    let coin = bmul(BigU(5), bpow10(11))
    if bcmp(best, coin) <= 0 { return "0" }
    if bcmp(ceil, coin) <= 0 { return "-" }
    let num = bmul(bsub(best, coin), BigU(1000))
    // floor divide by (ceil - coin) via repeated subtraction on limbs: use the
    // schoolbook long division already in the file, generalised to a BigU divisor.
    let den = bsub(ceil, coin)
    var q = BigU(); var rem = BigU()
    let bits = num.l.count * 32
    var i = bits - 1
    while i >= 0 {
        // rem = rem*2 + bit i of num
        rem = badd(rem, rem)
        let limb = i / 32, off = UInt32(i % 32)
        if limb < num.l.count, (num.l[limb] >> off) & 1 == 1 { rem = badd(rem, BigU(1)) }
        q = badd(q, q)
        if bcmp(rem, den) >= 0 { rem = bsub(rem, den); q = badd(q, BigU(1)) }
        i -= 1
    }
    return bdec(q)
}

func grouped(_ n: Int) -> String {
    let s = String(n); var out = ""; var c = 0
    for ch in s.reversed() { if c > 0 && c % 3 == 0 { out.append(",") }; out.append(ch); c += 1 }
    return String(out.reversed())
}
rule("HOW MUCH HEADROOM THE FIELD HAS LEFT")
rule("  PGS Catalog performance rows staged ......... \(grouped(perfRows))")
rule("  distinct scores in those rows .............. \(grouped(pgsScoresSeen.count))")
rule("  metrics classified, pinned traits, European  \(metricsSeen)")
var ncKeys = Array(notComparable.keys); ncKeys.sort()
rule("  of those, NOT COMPARABLE and excluded ...... " + ncKeys.map { "\($0)=\(notComparable[$0]!)" }.joined(separator: " "))
rule("  of those, COMPARABLE and scored ............ \(metricsSeen - notComparable.values.reduce(0, +))")
rule("")
rule("  trait         ceiling C       best published C  captured   score")
let capOrder = ["1180", "1160", "20127_irnt", "2178", "1200", "1190", "1210", "1170", "2040",
                "1220", "826", "767_irnt", "757_irnt"]
var capLines: [String] = []
for t in capOrder {
    guard let row = rows.first(where: { $0.trait == t }) else { continue }
    var name = t; while name.count < 12 { name += " " }
    if let b = bestOf[t] {
        let pm = capturedPerMille(b.c, row.pt)
        capLines.append("\(t)\t\(bdec(row.pt))\t\(bdec(b.c))\t\(pm)\t\(b.pgs)")
        rule("  \(name)  \(asC(row.pt))  \(asC(b.c))    \(pm)/1000    \(b.pgs)  \(b.metric) = \(b.value)")
    } else {
        capLines.append("\(t)\t\(bdec(row.pt))\tABSENT\t-\t-")
        rule("  \(name)  \(asC(row.pt))  ABSENT            -          no published score of a comparable family")
    }
}
rule("")
if aboveCeiling.isEmpty {
    rule("  claims above their own 2-SE ceiling: 0")
} else {
    rule("  CLAIMS ABOVE THEIR OWN 2-SE CEILING — reported, never used, never averaged in:")
    for (i, a) in aboveCeiling.enumerated() {
        rule("    \(a.pgs)  trait \(aboveTrait[i])  \(a.metric) = \(a.value)  -> C = \(asC(a.c))")
    }
    rule("  Three readings, all printed, none chosen here: the metric is not the quantity its")
    rule("  name states; the evaluation sample overlaps the data the score was trained on; or")
    rule("  the LDSC h2 underestimates the common-SNP heritability for that trait.")
}
rule("")
rule("  ABSENCE, stated as absence and not as zero: no polygenic score of any kind, of any")
rule("  metric family, exists in these rows for shift work, night shift work, length of")
rule("  working week or hours worked.")
rule("")
// ===========================================================================
// PART 7 — RECOMPUTED AGAINST PUBLISHED.  The discriminating check: the
// figures printed in PART 2 were written before this run; the figures in
// PART 6 were computed during it. They must agree, digit for digit.
// ===========================================================================
var pinFails = 0
func pin(_ name: String, _ got: String, _ want: String) {
    let ok = got == want
    rule("  \(ok ? "AGREE " : "DIFFER") \(name)  computed=\(got) published=\(want)")
    if !ok { pinFails += 1 }
}
rule("RECOMPUTED AGAINST PUBLISHED")
pin("count           ", String(rows.count), "56")
pin("lower median    ", asC(medPt), "0.573212381656")
pin("maximum         ", asC(maxPt), "0.602142835007")
pin("maximum interval", asC(maxHi), "0.610622725745")
pin("minimum         ", asC(minPt), "0.527947611149")
pin("shift work point", rows.first(where: { $0.trait == "826" }).map { asC($0.pt) } ?? "-", "0.544353505508")
pin("shift work lo   ", rows.first(where: { $0.trait == "826" }).map { asC($0.lo) } ?? "-", "0.538042338431")
pin("shift work hi   ", rows.first(where: { $0.trait == "826" }).map { asC($0.hi) } ?? "-", "0.549890300690")
pin("working week    ", rows.first(where: { $0.trait == "767_irnt" }).map { asC($0.pt) } ?? "-", "0.541714427173")
pin("time employed   ", rows.first(where: { $0.trait == "757_irnt" }).map { asC($0.pt) } ?? "-", "0.530300726943")
pin("reaching 0.62   ", String(n62), "0")
pin("reaching 0.65   ", String(n65), "0")
rule("  pins disagreeing = \(pinFails)")
rule("")

// ===========================================================================
// PART 8 — THE SEAL.  Over the verdict transcript only.  PATH-INDEPENDENT:
// no absolute path, no timing and no hostname enters the digest, so two people
// on two machines get the same sixty-four characters or the arithmetic moved.
// ===========================================================================
var transcript = "\(MARKER)\n"
transcript += "arms=\(ARM_LINES.count) fails=\(ARM_FAILS) undetermined=\(UNDETERMINED_EVENTS)\n"
transcript += "rows=\(rows.count) malformed=\(malformed)\n"
for r in rows {
    transcript += "\(r.trait)\t\(r.fam)\t\(r.h2)\t\(bdec(r.lo))\t\(bdec(r.pt))\t\(bdec(r.hi))\t\(r.flag)\n"
}
transcript += "median=\(bdec(medPt)) max=\(bdec(maxPt)) maxhi=\(bdec(maxHi)) min=\(bdec(minPt))\n"
transcript += capLines.joined(separator: "\n") + "\n"
transcript += "perf_rows=\(perfRows) metrics=\(metricsSeen) above_ceiling=\(aboveCeiling.count)\n"
transcript += "n62=\(n62) n65=\(n65) pinfails=\(pinFails)\n"
let seal = SHA256Exact.hex(Array(transcript.utf8))

rule("MARKER  \(MARKER)")
rule("sha256  \(seal)")
rule("")
rule("Zero floating point on any decision path. h2 and its standard error are parsed from")
rule("decimal text into exact rationals; pi and sin are integer intervals; the comparison is")
rule("a cross-multiplication of integers. A ceiling that moves with the rounding is not a ceiling.")
if pinFails != 0 || ARM_FAILS != 0 { exit(1) }
