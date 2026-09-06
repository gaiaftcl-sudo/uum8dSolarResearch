// Study 26 — Master Regulator Bonds
// THE EXACT DISCRIMINATION COURT: does the patient's expression data add anything to
// network topology, when recovering a published master-regulator set?
//
// The chartered gate S4 answered a neighbouring question by Monte Carlo: draw 1,000
// size-matched random sets and count how many reach sigma. That estimate MOVES when the
// seed moves. Under the uniform null the same quantity has a closed form — the
// hypergeometric upper tail — and this program evaluates it in EXACT INTEGER ARITHMETIC.
// It does not move. It is the same on every machine, forever.
//
//   P(X >= s) = ( sum_{k=s..min(n,K)} C(K,k) * C(P-K, n-k) ) / C(P,n)
//
//   P = regulators in the scoreable pool
//   K = published master regulators present in that pool
//   n = |top-N| , frozen at K by the charter
//   s = observed overlap
//
// Two arms are graded per tumour type, from the SAME counts and the SAME network:
//   EXPRESSION arm  — regulators ranked by activity computed from patient RNA counts
//   TOPOLOGY arm    — regulators ranked by regulon SIZE ALONE, expression never read
//
// Both tails share the denominator C(P,n), so the arms are compared by their NUMERATORS
// alone — an exact big-integer comparison with no division and no rounding. The smaller
// numerator is the more significant recovery.
//
// ZERO FLOAT. No Double, no Float, no libm. Every decimal printed below is rendered from
// the exact rational by integer long-comparison, never computed in floating point.
//
// Reproduce:  swiftc -O reproduce/mr-topology-vs-expression-exact.swift -o /tmp/mrx && /tmp/mrx

import Foundation

// Pure-Swift text helpers. No C format strings anywhere on the printing path:
// String(format:"%s", <Swift String>) is undefined behaviour, and this program
// prints no floating-point value at all, so it needs none of printf's machinery.
func padL(_ s: String, _ w: Int) -> String { s + String(repeating: " ", count: max(0, w - s.count)) }
func padR(_ s: String, _ w: Int) -> String { String(repeating: " ", count: max(0, w - s.count)) + s }
func padR(_ v: Int, _ w: Int) -> String { padR(String(v), w) }
func zpad(_ v: UInt32, _ w: Int) -> String {
    var s = String(v); while s.count < w { s = "0" + s }; return s
}
func hex8(_ v: UInt32) -> String {
    let d = Array("0123456789abcdef"); var s = ""
    for i in stride(from: 28, through: 0, by: -4) { s.append(d[Int((v >> UInt32(i)) & 0xf)]) }
    return s
}

// ---------------------------------------------------------------- exact big integers
// base 1e9, little-endian limbs. Non-negative only; that is all this law needs.
struct Big: Comparable, CustomStringConvertible {
    var l: [UInt32] = [0]                       // limbs, each < 1_000_000_000
    static let B: UInt64 = 1_000_000_000

    init(_ v: UInt64 = 0) {
        var v = v; l = []
        repeat { l.append(UInt32(v % Big.B)); v /= Big.B } while v > 0
    }
    private init(limbs: [UInt32]) { l = limbs; norm() }
    private mutating func norm() { while l.count > 1 && l.last == 0 { l.removeLast() } }
    var isZero: Bool { l.count == 1 && l[0] == 0 }

    static func + (a: Big, b: Big) -> Big {
        var r: [UInt32] = []; r.reserveCapacity(max(a.l.count, b.l.count) + 1)
        var c: UInt64 = 0
        for i in 0..<max(a.l.count, b.l.count) {
            let s = c + UInt64(i < a.l.count ? a.l[i] : 0) + UInt64(i < b.l.count ? b.l[i] : 0)
            r.append(UInt32(s % B)); c = s / B
        }
        if c > 0 { r.append(UInt32(c)) }
        return Big(limbs: r)
    }
    static func * (a: Big, b: Big) -> Big {
        if a.isZero || b.isZero { return Big(0) }
        var acc = [UInt64](repeating: 0, count: a.l.count + b.l.count)
        for i in 0..<a.l.count {
            var c: UInt64 = 0
            let ai = UInt64(a.l[i])
            for j in 0..<b.l.count {
                let cur = acc[i + j] + ai * UInt64(b.l[j]) + c
                acc[i + j] = cur % B; c = cur / B
            }
            var k = i + b.l.count
            while c > 0 && k < acc.count { let cur = acc[k] + c; acc[k] = cur % B; c = cur / B; k += 1 }
        }
        return Big(limbs: acc.map { UInt32($0) })
    }
    // multiply by a small scalar (< 1e9)
    func mulSmall(_ m: UInt64) -> Big {
        var r: [UInt32] = []; r.reserveCapacity(l.count + 2); var c: UInt64 = 0
        for x in l { let cur = UInt64(x) * m + c; r.append(UInt32(cur % Big.B)); c = cur / Big.B }
        while c > 0 { r.append(UInt32(c % Big.B)); c /= Big.B }
        return Big(limbs: r)
    }
    // exact division by a small scalar; the caller guarantees divisibility
    func divSmall(_ d: UInt64) -> Big {
        var r = [UInt32](repeating: 0, count: l.count); var rem: UInt64 = 0
        for i in stride(from: l.count - 1, through: 0, by: -1) {
            let cur = rem * Big.B + UInt64(l[i]); r[i] = UInt32(cur / d); rem = cur % d
        }
        return Big(limbs: r)
    }
    static func < (a: Big, b: Big) -> Bool {
        if a.l.count != b.l.count { return a.l.count < b.l.count }
        for i in stride(from: a.l.count - 1, through: 0, by: -1) where a.l[i] != b.l[i] {
            return a.l[i] < b.l[i]
        }
        return false
    }
    static func == (a: Big, b: Big) -> Bool { a.l == b.l }
    var description: String {
        var s = String(l[l.count - 1])
        for i in stride(from: l.count - 2, through: 0, by: -1) {
            s += zpad(l[i], 9)                          // digit padding only; no float
        }
        return s
    }
    var digitCount: Int { description.count }
}

// C(n,k), exact. The running product after i steps is divisible by i, so each divSmall is exact.
func comb(_ n: Int, _ k: Int) -> Big {
    if k < 0 || k > n { return Big(0) }
    let k = min(k, n - k)
    var r = Big(1)
    for i in 1...max(k, 1) where k > 0 {
        r = r.mulSmall(UInt64(n - k + i)).divSmall(UInt64(i))
    }
    return k == 0 ? Big(1) : r
}

// Hypergeometric upper-tail NUMERATOR over the common denominator C(P,n).
func tailNumerator(P: Int, K: Int, n: Int, s: Int) -> Big {
    var acc = Big(0)
    let hi = min(n, K)
    if s > hi { return Big(0) }
    for k in s...hi { acc = acc + comb(K, k) * comb(P - K, n - k) }
    return acc
}

// Render numer/denom as "d.ddde-j" using ONLY integer comparisons.
// Step 1: smallest j with numer*10^j >= denom.  Step 2: binary-search the 4 lead digits.
func renderExact(_ numer: Big, _ denom: Big) -> String {
    if numer.isZero { return "0 (exact)" }
    if !(numer < denom) { return "1.000e+0" }
    var j = 0; var scaled = numer
    while scaled < denom { scaled = scaled.mulSmall(10); j += 1 }
    // scaled = numer*10^j in [denom, 10*denom)  =>  numer/denom in [10^-j, 10^-j+1)
    let target = scaled.mulSmall(1000)              // want q = floor(target/denom), q in [1000,9999]
    var lo: UInt64 = 1000, hi: UInt64 = 9999, q: UInt64 = 1000
    while lo <= hi {
        let mid = (lo + hi) / 2
        if !(target < denom.mulSmall(mid)) { q = mid; lo = mid + 1 } else { hi = mid - 1 }
    }
    let d0 = q / 1000, rest = q % 1000
    return "\(d0).\(zpad(UInt32(rest), 3))e-\(j)"
}

// ---------------------------------------------------------------- the frozen board
struct Ctx { let cohort: String; let P: Int; let K: Int; let sigmaExpr: Int; let sigmaTopo: Int }

// Every row below is MEASURED, from public data only:
//   P, K  — the scoreable pool and the published master regulators present in it
//   sigmaExpr — overlap when regulators are ranked by activity from GDC open RNA counts
//   sigmaTopo — overlap when regulators are ranked by REGULON SIZE alone (no expression read)
let BOARD: [Ctx] = [
    Ctx(cohort: "blca", P: 5923, K: 141, sigmaExpr: 21, sigmaTopo: 16),
    Ctx(cohort: "brca", P: 5735, K: 129, sigmaExpr: 9, sigmaTopo: 7),
    Ctx(cohort: "coad", P: 5913, K: 118, sigmaExpr: 7, sigmaTopo: 18),
    Ctx(cohort: "gbm", P: 6050, K: 118, sigmaExpr: 10, sigmaTopo: 14),
    Ctx(cohort: "hnsc", P: 5896, K: 140, sigmaExpr: 6, sigmaTopo: 14),
    Ctx(cohort: "kirc", P: 5861, K: 86, sigmaExpr: 7, sigmaTopo: 6),
    Ctx(cohort: "lihc", P: 5977, K: 56, sigmaExpr: 1, sigmaTopo: 2),
    Ctx(cohort: "luad", P: 5900, K: 233, sigmaExpr: 38, sigmaTopo: 56),
    Ctx(cohort: "lusc", P: 5889, K: 55, sigmaExpr: 4, sigmaTopo: 5),
    Ctx(cohort: "ov", P: 5921, K: 256, sigmaExpr: 60, sigmaTopo: 46),
    Ctx(cohort: "paad", P: 6036, K: 148, sigmaExpr: 25, sigmaTopo: 26),
    Ctx(cohort: "prad", P: 5792, K: 68, sigmaExpr: 3, sigmaTopo: 4),
    Ctx(cohort: "read", P: 6039, K: 135, sigmaExpr: 14, sigmaTopo: 17),
    Ctx(cohort: "sarc", P: 6030, K: 68, sigmaExpr: 7, sigmaTopo: 8),
    Ctx(cohort: "stad", P: 6021, K: 147, sigmaExpr: 22, sigmaTopo: 27),
    Ctx(cohort: "thca", P: 5758, K: 28, sigmaExpr: 0, sigmaTopo: 0),
    Ctx(cohort: "ucec", P: 5998, K: 73, sigmaExpr: 3, sigmaTopo: 2),
]

// ---------------------------------------------------------------- minimal SHA-256 (no float)
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

// ---------------------------------------------------------------- self-test
// An instrument must discriminate, and must be checked on a KNOWN case before it is
// trusted on an unknown one. Every value below is checkable by hand.
func selfTest() {
    var fails = 0
    func want(_ got: String, _ exp: String, _ what: String) {
        if got != exp { print("SELFTEST FAIL \(what): got \(got) want \(exp)"); fails += 1 }
    }
    want(comb(10, 3).description, "120", "C(10,3)")
    want(comb(52, 5).description, "2598960", "C(52,5)")
    want(comb(100, 50).description,
         "100891344545564193334812497256", "C(100,50)")
    want((Big(999_999_999).mulSmall(1_000_000_000) + Big(999_999_999)).description,
         "999999999999999999", "limb carry")
    want((comb(60, 30) * comb(60, 30)).description,
         String(describing: comb(60,30) * comb(60,30)), "mul stable")
    // a hypergeometric that can be checked by hand:
    // P=10,K=5,n=5,s=5  =>  numerator C(5,5)C(5,0)=1, denominator C(10,5)=252
    want(tailNumerator(P: 10, K: 5, n: 5, s: 5).description, "1", "tail numerator")
    want(comb(10, 5).description, "252", "tail denominator")
    // whole tail must be 1 when s = 0
    want(tailNumerator(P: 10, K: 5, n: 5, s: 0).description, "252", "tail sums to denominator")
    // rendering: 1/252 = 0.003968..., so 3.968e-3
    want(renderExact(Big(1), Big(252)), "3.968e-3", "render 1/252")
    want(renderExact(Big(1), Big(1000000)), "1.000e-6", "render 1e-6")
    if fails == 0 {
        print("SELFTEST PASS — exact arithmetic, combinatorics, tail and rendering all check.")
        print("  C(10,3)   = \(comb(10, 3))")
        print("  C(52,5)   = \(comb(52, 5))")
        print("  C(100,50) = \(comb(100, 50))")
        print("  C(5923,141) has \(comb(5923, 141).digitCount) digits")
        print("  hypergeometric tail at s=0 equals its own denominator: "
              + "\(tailNumerator(P: 10, K: 5, n: 5, s: 0)) = \(comb(10, 5))")
        print("  1/252 renders as \(renderExact(Big(1), Big(252)))")
    }
    else { print("SELFTEST FAILED with \(fails) error(s); no verdict is emitted."); exit(1) }
}
selfTest()
print("")

// ---------------------------------------------------------------- the court
print("STUDY 26 — MASTER REGULATOR BONDS · EXACT DISCRIMINATION COURT")
print("Exact hypergeometric upper tail in integer arithmetic. Zero float on the decision path.")
print("")
print("  EXPRESSION arm : regulators ranked by activity from GDC open RNA-seq integer counts")
print("  TOPOLOGY  arm : regulators ranked by regulon SIZE ALONE — the counts are never read")
print("")
print(padL("cohort",8) + padR("pool",6) + padR("N",5) + padR("sigE",6) + padR("sigT",6)
      + "  " + padL("P(>=sigE)",13) + padL("P(>=sigT)",13) + "verdict")

var transcript = ""
var topologyExplains = 0, expressionAdds = 0, noRecovery = 0, tie = 0

for c in BOARD {
    let denom = comb(c.P, c.K)
    let nE = tailNumerator(P: c.P, K: c.K, n: c.K, s: c.sigmaExpr)
    let nT = tailNumerator(P: c.P, K: c.K, n: c.K, s: c.sigmaTopo)
    // same denominator on both arms => compare numerators exactly, no division at all
    // A context where NEITHER arm recovers anything is not evidence for either arm.
    // Grading it as TOPOLOGY_EXPLAINS would inflate that count on a tie at zero.
    let verdict: String
    if c.sigmaExpr == 0 && c.sigmaTopo == 0 {
        verdict = "NO_RECOVERY"; noRecovery += 1
    } else if nE == nT {
        verdict = "TIE"; tie += 1
    } else if !(nE < nT) {
        verdict = "TOPOLOGY_EXPLAINS"; topologyExplains += 1
    } else {
        verdict = "EXPRESSION_ADDS"; expressionAdds += 1
    }
    let pE = renderExact(nE, denom), pT = renderExact(nT, denom)
    print(padL(c.cohort,8) + padR(c.P,6) + padR(c.K,5) + padR(c.sigmaExpr,6) + padR(c.sigmaTopo,6)
          + "  " + padL(pE,13) + padL(pT,13) + verdict)
    transcript += "\(c.cohort)|\(c.P)|\(c.K)|\(c.sigmaExpr)|\(c.sigmaTopo)|\(nE)|\(nT)|\(denom)|\(verdict)\n"
}

print("")
print("TOPOLOGY_EXPLAINS: \(topologyExplains) of \(BOARD.count) tumour types")
print("EXPRESSION_ADDS  : \(expressionAdds) of \(BOARD.count) tumour types")
print("TIE              : \(tie)")
print("NO_RECOVERY      : \(noRecovery)  (neither arm recovered anything; evidence for neither)")
print("")
print("In a TOPOLOGY_EXPLAINS context, ranking regulators by how many edges they carry in the")
print("network recovers the published master-regulator set AT LEAST AS SIGNIFICANTLY as ranking")
print("them by the patient expression data. The expression arm is not adding the discrimination.")
print("")
print("This is a statement about what these numbers support. It is not a claim that the published")
print("sets are wrong, and it is not a claim about any patient. It is the exact probability, and")
print("anyone can re-derive it from the public bytes.")
print("")
print("MARKER  MR_TOPOLOGY_VS_EXPRESSION__EXACT_TAIL_IS_OBSERVER_INVARIANT")
print("sha256  \(SHA256Min.hex(Array(transcript.utf8)))")
