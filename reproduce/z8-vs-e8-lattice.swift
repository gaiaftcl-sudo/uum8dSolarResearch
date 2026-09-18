// E8 AS THE RANK-4 EISENSTEIN MODULE — the manifold court, by exact enumeration.
//
// AMENDMENT 2026-09-18, named by the founder LEDGER_SPEC_E8_JORDAN_PURGE. Until today this program
// was a comparison and its library entry refused "not a claim that E8 is the right lattice for any
// particular signal". That sentence was a category error. It imported the Shannon channel framing —
// a lattice as a modulation constellation competing to encode a noisy analog signal, judged by
// capacity and noise margin — into a court where there is no signal. In UUM-8D doctrine, E8 is the
// topological constraint manifold for M^8 = S^4 x C^4: a state transition closes on the lattice or
// is refused. The signal vocabulary is retired here. What follows separates three things and keeps
// them apart: what this program COUNTS, what it takes from a cited theorem (REPORTED), and what is
// DOCTRINE printed outside the seal.
//
// COUNTED, ALL OF IT IN INTEGERS.
//   1. Kissing numbers by direct enumeration over a doubled window: Z^8 touches 16, E8 touches 240.
//   2. Packing density at equal covolume, from the two COUNTED minimal norms: exactly 2^4 = 16.
//   3. Construction A over the Eisenstein integers with the ternary tetracode C_4 <= F_3^4:
//        L = { x in Z[omega]^4 : x mod theta in C_4 },  theta = 1 + 2 omega,  theta^2 = -3.
//      At minimal Eisenstein norm 3, L has exactly 240 minimal vectors — 216 lifts of the 8
//      weight-3 codewords (3^3 unit choices each) and 24 theta-multiples of unit basis vectors
//      (4 positions x 6 units). Index [Z[omega]^4 : L] = 81/9 = 9, from the 9 words counted.
//   4. L is closed under multiplication by omega on every one of its 240 minimal vectors, with
//      the norm preserved — the rank-4 Z[omega]-MODULE property, counted, not cited.
//   5. The Gram spectrum of one root against all 240, in the doubled real coordinates: exactly
//      (1, 56, 126, 56, 1) at inner products (+8, +4, 0, -4, -8) — the root system of E8.
//   6. The code's minimum distance is COUNTED for every code named here (tetracode 3; two
//      substitutes of distance 1 and 2), and the substitutes give 12 at norm 1 and 54 at norm 2,
//      neither 240. A first draft called the first substitute "distance 2"; it was distance 1,
//      and the arm now measures the distance instead of naming it.
//   7. Affine linking L(w) = (q, r) — the rule of AffineLink.linking in apps/AffineNPHard, a
//      Mac-only Jordan-bond surface, NOT the cell binary: even limbs sum to q, odd limbs to r, one
//      signed step per nonzero limb — applied to the 240 roots, and the exact rule under which a
//      linking word EMBEDDED AS (q + r*omega, 0, 0, 0) lifts into L. Printed as measured; this
//      program does not assert an injection it cannot count.
//
// REPORTED, NOT COUNTED HERE. That a rank-8 even unimodular lattice is E8 (Mordell / Witt), and
// that the 240-point configuration with the spectrum above is unique (Bannai–Sloane), are cited
// theorems — SPLAG chapters 4 and 7. This program counts the spectrum and the module closure and
// does not verify unimodularity. The identification "L is a scaled E8" rests on the count plus
// the citation, and the entry grades it that way.
//
// WHAT THIS DOES NOT SAY. It does not say any shipped frame carries E8 coordinates. The 42-byte
// frame with Z^8 integer deltas is the one FROZEN IN STUDY 30's CHARTER — no pod built, no tier
// run — and the only 42-byte frames in the substrate tree are ARP. It names no signal, no
// channel, no noise model and no decoder, because there is none. A gate token for the
// non-admitted residues is NOT shipped on any cell; the cell change that would create it is
// not this program.
//
// ZERO FLOAT. Every count, norm, residue and seal below is integer arithmetic. omega is never
// evaluated: Z[omega] is carried as pairs (a, b) meaning a + b*omega with omega^2 = -omega - 1,
// and the norm is a^2 - a*b + b^2. No printed count exceeds 240; the tallies are Int64 anyway.
//
// RUN_TERMINAL. A completed run prints RUN_TERMINAL  COMPLETE before its MARKER and seal. A run
// whose control arm breaks prints RUN_TERMINAL  REFUSED and emits NO SEAL: a refusal computed
// nothing, and a seal on it would be a seal over nothing.
//
// Run: swiftc -O -swift-version 5 z8-vs-e8-lattice.swift && ./z8-vs-e8-lattice
// It takes no argument and reads no file.
import Foundation

// ============================================================================================
// SECTION 0 — the transcript, and the seal over it
// ============================================================================================
var T: [String] = []
func out(_ s: String = "") { T.append(s); print(s) }

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
func seal() -> String { SHA256Min.hex(Array(T.joined(separator: "\n").utf8)) }

/// Integer to grouped decimal, by a digit loop — no Foundation formatting on any printed figure.
func gp(_ n: Int64) -> String {
    if n == 0 { return "0" }
    let neg = n < 0; var v = neg ? -n : n
    var digits: [Character] = []; var i = 0
    while v > 0 { if i > 0 && i % 3 == 0 { digits.append(",") }; digits.append(Character(String(v % 10))); v /= 10; i += 1 }
    return (neg ? "-" : "") + String(digits.reversed())
}
func pad(_ s: String, _ w: Int) -> String { s.count >= w ? s : s + String(repeating: " ", count: w - s.count) }

// ============================================================================================
// SECTION 1 — the real-coordinate enumeration, doubled so half-integers stay integral
// ============================================================================================
// x -> 2x. Under doubling a norm N becomes 4N: E8's minimal norm 2 -> 8, Z^8's minimal norm 1 -> 4.

/// Every vector of the doubled window {-2,-1,0,1,2}^8 whose doubled norm is `target`.
func doubledWindow(norm target: Int64) -> [[Int]] {
    var found: [[Int]] = []
    var v = [Int](repeating: 0, count: 8)
    func rec(_ i: Int, _ acc: Int64) {
        if acc > target { return }
        if i == 8 { if acc == target { found.append(v) }; return }
        for c in -2...2 { v[i] = c; rec(i + 1, acc + Int64(c * c)) }
        v[i] = 0
    }
    rec(0, 0)
    return found
}
/// Z^8 doubled: coordinates even, so a vector is in 2*Z^8 iff every coordinate is even.
func inZ8Doubled(_ v: [Int]) -> Bool { v.allSatisfy { $0 % 2 == 0 } }
/// E8 doubled: all coordinates of one parity, and the sum of ORIGINAL coordinates even.
func inE8Doubled(_ v: [Int]) -> Bool {
    let p = ((v[0] % 2) + 2) % 2
    if !v.allSatisfy({ (($0 % 2) + 2) % 2 == p }) { return false }
    let s = v.reduce(0, +)                       // sum of doubled = 2 x sum of originals
    return s % 4 == 0                            // original sum even
}
/// The least doubled norm at which the lattice has a nonzero vector, and those vectors.
func minimalVectors(_ member: ([Int]) -> Bool) -> (norm: Int64, vectors: [[Int]]) {
    for n in Int64(1)...16 {
        let vs = doubledWindow(norm: n).filter(member)
        if !vs.isEmpty { return (n, vs) }
    }
    return (0, [])
}

// ============================================================================================
// SECTION 2 — the Eisenstein integers, the tetracode, and Construction A. Integers only.
// ============================================================================================
// z = a + b*omega, omega^2 = -omega - 1.  N(z) = a^2 - a*b + b^2.
// theta = 1 + 2*omega, theta^2 = -3, so Z[omega]/theta = F_3. Since 2*omega = -1 (mod theta),
// omega = 1 (mod theta), and the residue of a + b*omega is (a + b) mod 3.
struct Eis: Equatable { var a: Int64; var b: Int64 }
@inline(__always) func norm(_ z: Eis) -> Int64 { z.a &* z.a &- z.a &* z.b &+ z.b &* z.b }
@inline(__always) func residue(_ z: Eis) -> Int64 { (((z.a &+ z.b) % 3) &+ 3) % 3 }
/// (a + b*omega) * omega = a*omega + b*omega^2 = -b + (a - b)*omega.
@inline(__always) func timesOmega(_ z: Eis) -> Eis { Eis(a: -z.b, b: z.a &- z.b) }

/// The tetracode C_4 <= F_3^4: the [4,2,3] code { (a, b, a+b, a+2b) : a, b in F_3 }.
func tetracode() -> [[Int64]] {
    var words: [[Int64]] = []
    for a in Int64(0)..<3 { for b in Int64(0)..<3 { words.append([a, b, (a &+ b) % 3, (a &+ 2 &* b) % 3]) } }
    return words
}
func weight(_ w: [Int64]) -> Int64 { Int64(w.filter { $0 != 0 }.count) }
/// The minimum distance of a linear code is its minimum nonzero weight — counted, never named.
func minDistance(_ code: [[Int64]]) -> Int64 { code.filter { weight($0) > 0 }.map(weight).min() ?? 0 }
func admitted(_ x: [Eis], _ code: [[Int64]]) -> Bool { code.contains(x.map(residue)) }

/// Every x in Z[omega]^4 with total Eisenstein norm exactly `target`; N(a + b*omega) <= 3 forces
/// |a|, |b| <= 2, so bound 3 misses nothing at or below norm 3.
func vectorsOfNorm(_ target: Int64, bound: Int64) -> [[Eis]] {
    var cell: [Eis] = []
    for a in -bound...bound { for b in -bound...bound { let z = Eis(a: a, b: b); if norm(z) <= target { cell.append(z) } } }
    var outv: [[Eis]] = []
    for z0 in cell { let n0 = norm(z0); if n0 > target { continue }
    for z1 in cell { let n1 = n0 &+ norm(z1); if n1 > target { continue }
    for z2 in cell { let n2 = n1 &+ norm(z2); if n2 > target { continue }
    for z3 in cell { if n2 &+ norm(z3) == target { outv.append([z0, z1, z2, z3]) } } } } }
    return outv
}

/// The minimal vectors of L(code) = { x : x mod theta in code }. `minNorm` 0 means nothing was
/// admitted at norms 1...6, and the caller must refuse rather than read it as a measurement.
func constructionA(_ code: [[Int64]]) -> (total: Int64, codewordLifts: Int64, thetaUnits: Int64, minNorm: Int64, vectors: [[Eis]]) {
    var minNorm: Int64 = 0
    for n in Int64(1)...6 { if vectorsOfNorm(n, bound: 3).contains(where: { admitted($0, code) }) { minNorm = n; break } }
    if minNorm == 0 { return (0, 0, 0, 0, []) }
    let vs = vectorsOfNorm(minNorm, bound: 3).filter { admitted($0, code) }
    var lifts: Int64 = 0, thetas: Int64 = 0
    for x in vs { if x.map(residue).allSatisfy({ $0 == 0 }) { thetas += 1 } else { lifts += 1 } }
    return (Int64(vs.count), lifts, thetas, minNorm, vs)
}

// ============================================================================================
// SECTION 3 — affine linking L(w) = (q, r), the rule of AffineLink.linking in apps/AffineNPHard
// ============================================================================================
func linking(_ v: [Int]) -> (q: Int64, r: Int64) {
    var q: Int64 = 0, r: Int64 = 0
    for i in 0..<8 { let step: Int64 = v[i] == 0 ? 0 : (v[i] < 0 ? -1 : 1); if i & 1 == 0 { q &+= step } else { r &+= step } }
    return (q, r)
}

// ============================================================================================
// SECTION 4 — the run
// ============================================================================================
out("E8 AS THE RANK-4 EISENSTEIN MODULE — the manifold court, by exact enumeration")
out("AMENDMENT 2026-09-18: the signal framing is retired; what follows is counted, cited, or doctrine — and says which.")
out("")
out("REFERENCE FIGURES — public mathematics, REPORTED, and re-derived below where marked counted")
out("  E8: the even unimodular lattice in dimension 8; 240 roots; minimal norm 2          Conway & Sloane, SPLAG")
out("  Z[omega]: the Eisenstein integers, omega^2 = -omega - 1; theta = 1 + 2 omega, theta^2 = -3")
out("  C_4: the ternary tetracode, a [4,2,3] code over F_3 with 9 words")
out("  Construction A: L = { x in Z[omega]^4 : x mod theta in C_4 } is a scaled E8              SPLAG ch. 7 (REPORTED)")
out("  Uniqueness: an even unimodular rank-8 lattice is E8; the 240-point spectrum below is unique  SPLAG ch. 4 (REPORTED)")
out("  This program counts lattice arithmetic. It names no signal, no channel and no decoder.")
out("")

// ---- control arms, both directions; nothing is graded if one does not hold ----
out("SECTION 1 — CONTROL ARM (both directions; nothing is graded if one fails)")
var armsRun: Int64 = 0, armsFailed: Int64 = 0
var brokenName = ""
func arm(_ name: String, _ mustHold: Bool, _ held: Bool) {
    armsRun += 1
    let ok = (held == mustHold); if !ok { armsFailed += 1; if brokenName.isEmpty { brokenName = name } }
    out("  [\(ok ? "HOLDS" : "BROKEN")] \(pad(name, 70)) \(mustHold ? "must hold" : "must NOT hold")")
}

let C4 = tetracode()
let nonzero = C4.filter { weight($0) > 0 }
arm("A1 the tetracode has 9 words and every nonzero word has weight 3", true,
    C4.count == 9 && nonzero.count == 8 && nonzero.allSatisfy { weight($0) == 3 })

var thetaKills = true
for a in Int64(-4)...4 { for b in Int64(-4)...4 {
    // theta * z = (1 + 2w)(a + bw) = (a - 2b) + (2a - b) w
    if residue(Eis(a: a &- 2 &* b, b: 2 &* a &- b)) != 0 { thetaKills = false }
} }
arm("A2 theta * z has residue 0 for every z in a 9x9 window (theta divides it)", true, thetaKills)

let badV = [Eis(a: 1, b: 0), Eis(a: 1, b: 0), Eis(a: 0, b: 0), Eis(a: 0, b: 0)]   // residue (1,1,0,0)
arm("A3 a vector with residue (1,1,0,0), not in C_4, is REFUSED admission", true, !admitted(badV, C4))
let goodV = [Eis(a: 1, b: 0), Eis(a: 0, b: 0), Eis(a: 1, b: 0), Eis(a: 1, b: 0)]  // residue (1,0,1,1)
arm("A3-control a lift of the codeword (1,0,1,1) is refused admission", false, !admitted(goodV, C4))

let weak1: [[Int64]] = { var w: [[Int64]] = []; for a in Int64(0)..<3 { for b in Int64(0)..<3 { w.append([a, b, 0, 0]) } }; return w }()
let weak2: [[Int64]] = { var w: [[Int64]] = []; for a in Int64(0)..<3 { for b in Int64(0)..<3 { w.append([a, b, (a &+ b) % 3, 0]) } }; return w }()
let d4 = minDistance(C4), d1 = minDistance(weak1), d2 = minDistance(weak2)
arm("A4 counted minimum distances: tetracode 3, {(a,b,0,0)} 1, {(a,b,a+b,0)} 2", true, d4 == 3 && d1 == 1 && d2 == 2)
let cA = constructionA(C4), weakA = constructionA(weak1), weakB = constructionA(weak2)
arm("A4-control the counted distance-1 code in place of C_4 still yields 240", false, weakA.total == 240)
arm("A4-control the counted distance-2 code in place of C_4 still yields 240", false, weakB.total == 240)

// A5 — the real-coordinate enumeration: minimal norms COUNTED, and the counts.
let z8 = minimalVectors(inZ8Doubled), e8 = minimalVectors(inE8Doubled)
arm("A5 doubled window: Z^8 minimal norm 4 with 16 vectors; E8 minimal norm 8 with 240", true,
    z8.norm == 4 && z8.vectors.count == 16 && e8.norm == 8 && e8.vectors.count == 240)

// A6 — L is a Z[omega]-module: every minimal vector times omega is admitted at the same norm.
var omegaClosed = cA.minNorm == 3
for x in cA.vectors {
    let y = x.map(timesOmega)
    if !admitted(y, C4) || y.map(norm).reduce(0, &+) != 3 { omegaClosed = false }
}
arm("A6 omega * x is admitted at norm 3 for all 240 minimal vectors (Z[omega]-module)", true, omegaClosed)

// A7 — the Gram spectrum of one root against all 240, doubled coordinates: (1, 56, 126, 56, 1).
var spectrum: [Int64: Int64] = [:]
if let r0 = e8.vectors.first {
    for v in e8.vectors { var d: Int64 = 0; for i in 0..<8 { d &+= Int64(r0[i] &* v[i]) }; spectrum[d, default: 0] += 1 }
}
let want: [Int64: Int64] = [8: 1, 4: 56, 0: 126, -4: 56, -8: 1]
arm("A7 Gram spectrum of one root against all 240 is (1, 56, 126, 56, 1) at (+8, +4, 0, -4, -8)", true, spectrum == want)

out("  arms run \(armsRun), broken \(armsFailed)")
if armsFailed != 0 {
    out("")
    out("VERDICT : REFUSED — control arm '\(brokenName)' did not hold, so no figure below is graded.")
    out("RUN_TERMINAL  REFUSED  control arm broken")
    out("MARKER  E8_RANK4_EISENSTEIN_MODULE__CONTROL_ARM_REFUSED")
    out("NO SEAL EMITTED. A refusal computed nothing; a seal on it would be a seal over nothing.")
    exit(2)
}
out("")

// ---- the figures ----
out("=== kissing number, by exact enumeration over the doubled window {-2..2}^8 ===")
out("  Z^8 : \(gp(Int64(z8.vectors.count)))")
out("  E8  : \(gp(Int64(e8.vectors.count)))")
out("")
out("=== packing density ratio, EXACT, from the two counted minimal norms ===")
out("  both lattices are unimodular: covolume 1 (REPORTED)")
out("  Z^8 minimal norm 1 -> minimal distance 1        (counted: doubled norm \(z8.norm))")
out("  E8  minimal norm 2 -> minimal distance sqrt(2)  (counted: doubled norm \(e8.norm))")
let ratioSq = e8.norm / z8.norm                                   // 2, the ratio of squared distances
let density = ratioSq &* ratioSq &* ratioSq &* ratioSq             // (sqrt2)^8 = 2^4, from the counts
out("  density ratio = (sqrt2)^8 = 2^4 = \(density)  — EXACTLY 16x, an integer")
out("")
out("  So in the SAME dimension, at the SAME covolume, E8 packs \(density)x denser")
out("  and touches \(Int64(e8.vectors.count) / Int64(z8.vectors.count))x as many neighbours.")
out("")

out("=== E8 as a free Z[omega]-module of rank 4: Construction A over the tetracode, enumerated ===")
out("  L = { x in Z[omega]^4 : x mod theta in C_4 }")
out("  index [Z[omega]^4 : L]                       : \(gp(81 / Int64(C4.count)))   (81 residue classes, \(C4.count) admitted)")
out("  minimal Eisenstein norm of L                 : \(cA.minNorm)")
out("  minimal vectors of L, counted                : \(gp(cA.total))")
out("    lifts of the 8 weight-3 codewords (3^3 each): \(gp(cA.codewordLifts))")
out("    theta-multiples of unit basis vectors (4x6)  : \(gp(cA.thetaUnits))")
out("  omega-closure: all \(gp(cA.total)) minimal vectors stay admitted at norm 3 under x -> omega*x — L is a Z[omega]-module, counted")
out("  Gram spectrum of one E8 root against all 240 (doubled): (1, 56, 126, 56, 1) at (+8, +4, 0, -4, -8) — counted")
out("  residue rule: a + b*omega is 0 mod theta iff a + b is 0 mod 3; a vector is admitted iff its residues form a tetracode word")
out("  the minimum distance is counted, not named: tetracode \(d4), {(a,b,0,0)} \(d1), {(a,b,a+b,0)} \(d2)")
out("  in place of C_4, the distance-1 code gives \(gp(weakA.total)) minimal vectors at norm \(weakA.minNorm); the distance-2 code gives \(gp(weakB.total)) at norm \(weakB.minNorm); neither is 240")
out("  what is counted: 240 minimal vectors at norm 3, split 216 + 24, index 9, omega-closure, the spectrum")
out("  what is cited (REPORTED, SPLAG): that this configuration is E8's root system and L a scaled E8 — unimodularity is not verified here")
out("")

out("=== affine linking L(w) = (q, r) on the 240 roots — the rule of AffineLink.linking, apps/AffineNPHard — measured ===")
var images = Set<String>(); var qmin: Int64 = 0, qmax: Int64 = 0, rmin: Int64 = 0, rmax: Int64 = 0
for v in e8.vectors { let (q, r) = linking(v); images.insert("\(q),\(r)"); qmin = min(qmin, q); qmax = max(qmax, q); rmin = min(rmin, r); rmax = max(rmax, r) }
out("  rule: even limbs sum to q, odd limbs to r, one signed step per nonzero limb (a Mac-only Jordan-bond surface, not the cell binary)")
out("  240 roots map to \(gp(Int64(images.count))) distinct linking words (q, r); q in [\(qmin), \(qmax)], r in [\(rmin), \(rmax)]")
out("  the map roots -> Z^2 is NOT injective: 240 roots cannot embed one-to-one in \(gp((qmax - qmin + 1) * (rmax - rmin + 1))) words")
var lifts: Int64 = 0, words: Int64 = 0
for q in Int64(-4)...4 { for r in Int64(-4)...4 {
    words += 1
    if admitted([Eis(a: q, b: r), Eis(a: 0, b: 0), Eis(a: 0, b: 0), Eis(a: 0, b: 0)], C4) { lifts += 1 }
} }
out("  embedded as (q + r*omega, 0, 0, 0), a linking word lifts into L iff q + r is 0 mod 3 — that embedding, not any other")
out("  over |q|, |r| <= 4: \(gp(lifts)) of \(gp(words)) words lift without remainder; the other \(gp(words - lifts)) do not lift (residue not a tetracode word)")
out("")

out("=== WHAT THIS DOES NOT SAY ===")
out("  It does not say any shipped frame carries E8 coordinates: the 42-byte frame with Z^8 deltas is Study 30's CHARTER — no pod built, no tier run.")
out("  It names no signal, no channel, no noise model and no decoder. A transition is admitted by residue or it is not.")
out("  It does not assert an injection it cannot count; the linking-word figures above are what was measured.")
out("  No gate token for a non-admitted residue is shipped on any cell; the cell change that would create one is not this program.")
out("")
out("RUN_TERMINAL  COMPLETE")
out("MARKER  E8_RANK4_EISENSTEIN_MODULE__THE_TETRACODE_IS_THE_LAW")
print("SEAL    sha256 \(seal())")
// DOCTRINE, outside the seal: the reading the founder gives these counts. Printed, not sealed.
print("")
print("DOCTRINE (not sealed, not counted here): in UUM-8D, E8 is the manifold the joint vQbit register")
print("closes on — the same six-fold unit symmetry as one vQbit, in eight dimensions — and admission")
print("is a residue check in F_3. What the seal above covers is the arithmetic that doctrine rests on.")
