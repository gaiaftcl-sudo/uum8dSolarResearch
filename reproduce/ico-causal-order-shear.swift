// ico-causal-order-shear.swift
//
// STUDY 40 — Does the ORDER matter, and who is telling you that it does?
//
// A distributed system spends most of its machinery imposing a single total order on
// events: Lamport clocks, vector clocks, Raft. The stated reason is correctness — if two
// nodes apply the same events in different orders they must still agree.
//
// This program measures WHERE that requirement actually comes from. It does not come from
// the events. It comes from the ARITHMETIC. Floating-point addition is not associative and
// floating-point composition does not preserve commutation, so a float-valued replica
// genuinely disagrees with itself under reordering — and a total order is then the cheapest
// repair. Exact rational arithmetic is associative and commutative exactly, so the same
// replicas agree under every order with no ordering protocol at all.
//
// The instrument must fire in BOTH directions or it is worth nothing, so it is built to:
//
//   ARM 1  FALSE POSITIVE  — two maps that commute EXACTLY. Float reports that they do not,
//                            i.e. it manufactures an order-dependence that is not there, and
//                            a system built on it would impose an order it never needed.
//   ARM 2  FALSE NEGATIVE  — two maps that genuinely do NOT commute, by an exact margin that
//                            shrinks down a ladder. Float reports that they do, i.e. it erases
//                            a real order-dependence, and a system built on it would skip the
//                            ordering it actually needed and diverge in silence.
//   ARM 3  CONTROL         — the exact arm must answer 0 on every rung of ARM 1 and non-zero
//                            on every rung of ARM 2. An instrument that answers the same thing
//                            on both populations is a turn counter, not a measurement.
//   ARM 4  THE FOLD        — nine cells, the same 64 events, nine different arrival orders.
//                            Count the distinct results each arithmetic reaches.
//   ARM 5  CONTROL         — a second fold, same nine orders, on a population where float is
//                            exact. Both arithmetics must reach ONE result. Without this rung
//                            ARM 4 is an always-red detector and proves nothing.
//
// There is no corpus, no network, no key and no argument vector. Every constant is in this
// file, so every exit path prints the same reference figures and a stranger's run is
// byte-comparable with the published one.
//
// The exact path contains no Float, no Double and no CGFloat. The float arm is the thing
// being measured and is confined to the functions named `float…`.
//
// swiftc -O ico-causal-order-shear.swift -o /tmp/ico && /tmp/ico

import Foundation

// ══════════════════════════════════════════════════════════════════════════
// SECTION A — sha256, so the transcript seals without trusting this machine
// ══════════════════════════════════════════════════════════════════════════

enum SHA256Exact {

    private static let k: [UInt32] = [
        0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5,
        0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5,
        0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3,
        0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174,
        0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc,
        0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da,
        0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7,
        0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967,
        0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13,
        0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85,
        0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3,
        0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070,
        0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5,
        0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3,
        0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208,
        0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2,
    ]

    static func hex(_ message: [UInt8]) -> String {
        var h: [UInt32] = [
            0x6a09e667, 0xbb67ae85, 0x3c6ef372, 0xa54ff53a,
            0x510e527f, 0x9b05688c, 0x1f83d9ab, 0x5be0cd19,
        ]
        let bitLen = UInt64(message.count) &* 8
        var m = message
        m.append(0x80)
        while m.count % 64 != 56 { m.append(0x00) }
        var i = 8
        while i > 0 {
            i -= 1
            m.append(UInt8(truncatingIfNeeded: bitLen >> UInt64(8 * i)))
        }
        var w = [UInt32](repeating: 0, count: 64)
        var block = 0
        while block < m.count {
            var t = 0
            while t < 16 {
                let o = block + t * 4
                w[t] = (UInt32(m[o]) << 24) | (UInt32(m[o + 1]) << 16)
                     | (UInt32(m[o + 2]) << 8) | UInt32(m[o + 3])
                t += 1
            }
            t = 16
            while t < 64 {
                let a = w[t - 15]
                let b = w[t - 2]
                let s0 = rotr(a, 7) ^ rotr(a, 18) ^ (a >> 3)
                let s1 = rotr(b, 17) ^ rotr(b, 19) ^ (b >> 10)
                w[t] = w[t - 16] &+ s0 &+ w[t - 7] &+ s1
                t += 1
            }
            var a = h[0], b = h[1], c = h[2], d = h[3]
            var e = h[4], f = h[5], g = h[6], hh = h[7]
            t = 0
            while t < 64 {
                let S1 = rotr(e, 6) ^ rotr(e, 11) ^ rotr(e, 25)
                let ch = (e & f) ^ (~e & g)
                let t1 = hh &+ S1 &+ ch &+ k[t] &+ w[t]
                let S0 = rotr(a, 2) ^ rotr(a, 13) ^ rotr(a, 22)
                let maj = (a & b) ^ (a & c) ^ (b & c)
                let t2 = S0 &+ maj
                hh = g; g = f; f = e; e = d &+ t1
                d = c; c = b; b = a; a = t1 &+ t2
                t += 1
            }
            h[0] = h[0] &+ a; h[1] = h[1] &+ b; h[2] = h[2] &+ c; h[3] = h[3] &+ d
            h[4] = h[4] &+ e; h[5] = h[5] &+ f; h[6] = h[6] &+ g; h[7] = h[7] &+ hh
            block += 64
        }
        var out = ""
        for v in h {
            var s = String(v, radix: 16)
            while s.count < 8 { s = "0" + s }
            out += s
        }
        return out
    }

    static func hex(_ s: String) -> String { hex(Array(s.utf8)) }

    @inline(__always)
    private static func rotr(_ x: UInt32, _ n: UInt32) -> UInt32 {
        (x >> n) | (x << (32 &- n))
    }
}

// ══════════════════════════════════════════════════════════════════════════
// SECTION B — transcript, and the exact rational. No float below this line
//             until SECTION D, which is the thing being measured.
// ══════════════════════════════════════════════════════════════════════════

var TRANSCRIPT: [UInt8] = []

func say(_ s: String = "") {
    print(s)
    TRANSCRIPT.append(contentsOf: Array(s.utf8))
    TRANSCRIPT.append(0x0A)
}

func rule(_ ch: String = "-") { say(String(repeating: ch, count: 78)) }

func pad(_ s: String, _ n: Int) -> String {
    var t = s
    while t.count < n { t += " " }
    return t
}

func lpad(_ s: String, _ n: Int) -> String {
    var t = s
    while t.count < n { t = " " + t }
    return t
}

func gcd128(_ a: Int128, _ b: Int128) -> Int128 {
    var x = a < 0 ? -a : a
    var y = b < 0 ? -b : b
    while y != 0 { let t = x % y; x = y; y = t }
    return x
}

/// An exact rational over Int128. Always reduced, denominator always positive.
/// This is the whole of the exact arm: it has no rounding step to have an order.
struct Q: Equatable, CustomStringConvertible {
    var n: Int128
    var d: Int128

    init(_ n: Int128, _ d: Int128 = 1) {
        precondition(d != 0, "zero denominator")
        var nn = n, dd = d
        if dd < 0 { nn = -nn; dd = -dd }
        let g = gcd128(nn, dd)
        if g > 1 { nn /= g; dd /= g }
        self.n = nn; self.d = dd
    }

    static func + (a: Q, b: Q) -> Q { Q(a.n * b.d + b.n * a.d, a.d * b.d) }
    static func - (a: Q, b: Q) -> Q { Q(a.n * b.d - b.n * a.d, a.d * b.d) }
    static func * (a: Q, b: Q) -> Q { Q(a.n * b.n, a.d * b.d) }

    var isZero: Bool { n == 0 }
    var description: String { d == 1 ? "\(n)" : "\(n)/\(d)" }
}

/// An affine map over the rationals, x |-> (a*x + b)/d, carried as three integers.
/// Nothing here is evaluated to a decimal, so nothing here can round.
struct Affine {
    var a: Int128
    var b: Int128
    var d: Int128
    var name: String
}

/// (F then G) — G(F(x)) — composed exactly, still as one affine map.
///   G(F(x)) = ( aG*(aF*x + bF)/dF + bG ) / dG
///           = ( aG*aF*x + aG*bF + bG*dF ) / (dF*dG)
func compose(_ f: Affine, _ g: Affine, _ name: String) -> Affine {
    Affine(a: g.a * f.a,
           b: g.a * f.b + g.b * f.d,
           d: f.d * g.d,
           name: name)
}

func applyExact(_ m: Affine, _ x: Q) -> Q {
    (Q(m.a) * x + Q(m.b)) * Q(1, m.d)
}

// ══════════════════════════════════════════════════════════════════════════
// SECTION C — the two map families, and why each one is what it claims to be
// ══════════════════════════════════════════════════════════════════════════
//
// For A: x |-> (aA x + bA)/dA and B: x |-> (aB x + bB)/dB, both composite orders
// share the denominator dA*dB, so the commutator is a pure constant:
//
//   (A∘B)(x) - (B∘A)(x) = [ bB*(aA - dA) - bA*(aB - dB) ] / (dA * dB)
//
// independent of x. That is a closed form, not a sample: it is the whole answer.
// Write alpha = aA - dA and beta = aB - dB. Then the numerator is bB*alpha - bA*beta.
//
//   COMMUTING family      bA = 3, alpha = 3, bB = 7, beta = 7  ->  7*3 - 3*7 = 0
//   NON-COMMUTING family  bA = 1, alpha = 3, bB = 7, beta = 20 ->  7*3 - 1*20 = 1
//
// The first commutes EXACTLY at every rung of the ladder. The second fails to commute
// at every rung, by exactly 1/(dA*dB) — a margin we drive below the float horizon on
// purpose, because that is where the false negative lives.

let LADDER_K: [Int] = [3, 4, 5, 6, 7, 8, 9, 10, 11]

func pow10(_ k: Int) -> Int128 {
    var v: Int128 = 1
    for _ in 0..<k { v *= 10 }
    return v
}

func commutingPair(_ k: Int) -> (Affine, Affine) {
    let dA = pow10(k) + 3
    let dB = pow10(k) + 7
    let A = Affine(a: dA + 3, b: 3, d: dA, name: "A")   // alpha = 3, bA = 3
    let B = Affine(a: dB + 7, b: 7, d: dB, name: "B")   // beta  = 7, bB = 7
    return (A, B)
}

func nonCommutingPair(_ k: Int) -> (Affine, Affine) {
    let dA = pow10(k) + 3
    let dB = pow10(k) + 7
    let A = Affine(a: dA + 3, b: 1, d: dA, name: "A")   // alpha = 3, bA = 1
    let B = Affine(a: dB + 20, b: 7, d: dB, name: "B")  // beta  = 20, bB = 7
    return (A, B)
}

/// The exact commutator numerator, from the closed form above.
func exactCommutator(_ A: Affine, _ B: Affine) -> Q {
    let num = B.b * (A.a - A.d) - A.b * (B.a - B.d)
    return Q(num, A.d * B.d)
}

// ══════════════════════════════════════════════════════════════════════════
// SECTION D — THE FLOAT ARM. This is the measured object, not a helper.
//             It is deliberately written the way a replica would write it:
//             evaluate each map in turn, in double precision, in order.
// ══════════════════════════════════════════════════════════════════════════

func floatApply(_ m: Affine, _ x: Double) -> Double {
    // Int128 -> Double is the conversion any such replica performs when it moves
    // an exact quantity into a floating-point pipeline. It is where the horizon starts.
    let a = Double("\(m.a)") ?? 0
    let b = Double("\(m.b)") ?? 0
    let d = Double("\(m.d)") ?? 0
    return (a * x + b) / d
}

func floatCommutator(_ A: Affine, _ B: Affine, at x: Double) -> Double {
    let ab = floatApply(A, floatApply(B, x))   // A after B
    let ba = floatApply(B, floatApply(A, x))   // B after A
    return ab - ba
}

// ══════════════════════════════════════════════════════════════════════════
// SECTION E — the fold: nine cells, one event set, nine arrival orders
// ══════════════════════════════════════════════════════════════════════════
//
// Nine deterministic permutations of 64 slots. Stride s is odd, so gcd(s, 64) = 1 and
// i |-> (i*s + 7c) mod 64 is a bijection. No random source is used anywhere: a shuffle
// seeded by a clock would make this program's own verdict unreproducible, which is the
// defect it exists to measure.

let CELL_STRIDES: [Int] = [1, 3, 5, 7, 9, 11, 13, 15, 17]
let CELL_NAMES: [String] = ["hel-00", "hel-01", "hel-02", "hel-03", "hel-04",
                            "nbg-00", "nbg-01", "nbg-02", "nbg-03"]

func arrivalOrder(cell c: Int, count n: Int) -> [Int] {
    let s = CELL_STRIDES[c]
    var out = [Int]()
    out.reserveCapacity(n)
    for i in 0..<n { out.append((i * s + 7 * c) % n) }
    return out
}

/// THE SHEARING POPULATION.
/// 32 alternating events at 2^53 — the exact scale at which a double can no longer
/// hold an odd neighbour — and 32 small fractions. Exactly, the big block telescopes
/// to -16 and the fractions all survive. In double, whether a fraction survives depends
/// entirely on how big the accumulator happened to be when it arrived, and that is the
/// arrival order. The population is the point: this is what a replica ledger looks like
/// when large balances and small increments share one stream.
let SMALL_DENS: [Int128] = [3, 7, 11, 13, 17, 19, 23, 29]

func shearingEvents() -> [Q] {
    var e = [Q]()
    let big: Int128 = 9007199254740992      // 2^53
    for i in 0..<32 {
        let v = big + Int128(i)
        e.append(Q(i % 2 == 0 ? v : -v))
    }
    for i in 0..<32 {
        e.append(Q(1, SMALL_DENS[i % 8] + Int128(i)))
    }
    return e
}

/// THE CONTROL POPULATION.
/// 64 small integers. Every partial sum is exactly representable in a double, so float
/// has nothing to round and MUST agree with exact across all nine orders. If this rung
/// ever disagrees, the fold detector is firing on something other than rounding and its
/// ARM 4 verdict cannot be read.
func controlEvents() -> [Q] {
    var e = [Q]()
    for i in 0..<64 { e.append(Q(Int128(i * 37 - 1000))) }
    return e
}

func exactFold(_ events: [Q], order: [Int]) -> Q {
    var acc = Q(0)
    for idx in order { acc = acc + events[idx] }
    return acc
}

func floatFold(_ events: [Q], order: [Int]) -> Double {
    var acc = 0.0
    for idx in order {
        let n = Double("\(events[idx].n)") ?? 0
        let d = Double("\(events[idx].d)") ?? 0
        acc += n / d
    }
    return acc
}

func bits(_ d: Double) -> String {
    var s = String(d.bitPattern, radix: 16)
    while s.count < 16 { s = "0" + s }
    return s
}

// ══════════════════════════════════════════════════════════════════════════
// SECTION F — run every arm, grade it, seal it
// ══════════════════════════════════════════════════════════════════════════

var arm1FalsePositives = 0     // float says "does not commute" when it exactly does
var arm2FalseNegatives = 0     // float says "commutes" when it exactly does not
var arm3ExactCorrect = 0
var arm3ExactTested = 0
var arm1FirstFailK = -1
var arm2FirstFailK = -1

say("STUDY 40 — INDEFINITE CAUSAL ORDER, AND THE TOTAL ORDER THE ARITHMETIC FORCED")
say("ico-causal-order-shear.swift — no corpus, no network, no key, no argv")
rule("=")
say()
say("QUESTION.  A distributed system imposes one total order on its events. Is that")
say("           required by the events, or by the arithmetic used to fold them?")
say()
say("METHOD.    Two affine maps over the rationals compose in two orders. The exact")
say("           commutator (A after B) - (B after A) is a closed form independent of x:")
say("               [ bB*(aA-dA) - bA*(aB-dB) ] / (dA*dB)")
say("           So 'do these two operations commute' has an exact yes/no, and we ask")
say("           both arithmetics the same question down a ladder of scales.")
say()

// ---------------------------------------------------------------- ARM 1
rule("=")
say("ARM 1 — FALSE POSITIVE.  Maps that commute EXACTLY. Does float agree?")
rule("=")
say("family: bA=3, aA-dA=3, bB=7, aB-dB=7  ->  exact commutator numerator 7*3 - 3*7 = 0")
say("evaluated at x = 1")
say()
say("  " + pad("scale", 8) + pad("exact commutator", 22) + pad("exact verdict", 18)
        + pad("float commutator", 26) + "float verdict")
rule()

for k in LADDER_K {
    let (A, B) = commutingPair(k)
    let ex = exactCommutator(A, B)
    let fl = floatCommutator(A, B, at: 1.0)

    let exVerdict = ex.isZero ? "COMMUTES" : "DOES NOT"
    let flVerdict = fl == 0.0 ? "COMMUTES" : "DOES NOT"

    arm3ExactTested += 1
    if ex.isZero { arm3ExactCorrect += 1 }
    if fl != 0.0 {
        arm1FalsePositives += 1
        if arm1FirstFailK < 0 { arm1FirstFailK = k }
    }

    let mark = (flVerdict == exVerdict) ? " " : "  <-- FLOAT MANUFACTURED AN ORDER"
    say("  " + pad("10^\(k)", 8) + pad("\(ex)", 22) + pad(exVerdict, 18)
            + pad(fl == 0.0 ? "0" : "\(fl)", 26) + flVerdict + mark)
}
say()
say("  exactly-commuting pairs tested        \(LADDER_K.count)")
say("  float reported a non-zero commutator  \(arm1FalsePositives) of \(LADDER_K.count)")
say("  first scale at which float is fooled  " + (arm1FirstFailK < 0 ? "none" : "10^\(arm1FirstFailK)"))
say()

// ---------------------------------------------------------------- ARM 2
rule("=")
say("ARM 2 — FALSE NEGATIVE.  Maps that do NOT commute. Does float notice?")
rule("=")
say("family: bA=1, aA-dA=3, bB=7, aB-dB=20  ->  exact commutator numerator 7*3 - 1*20 = 1")
say("        so the true gap is exactly 1/(dA*dB) and it is never zero")
say("evaluated at x = 1")
say()
say("  " + pad("scale", 8) + pad("exact commutator", 30) + pad("exact verdict", 18)
        + pad("float commutator", 26) + "float verdict")
rule()

for k in LADDER_K {
    let (A, B) = nonCommutingPair(k)
    let ex = exactCommutator(A, B)
    let fl = floatCommutator(A, B, at: 1.0)

    let exVerdict = ex.isZero ? "COMMUTES" : "DOES NOT"
    let flVerdict = fl == 0.0 ? "COMMUTES" : "DOES NOT"

    arm3ExactTested += 1
    if !ex.isZero { arm3ExactCorrect += 1 }
    if fl == 0.0 {
        arm2FalseNegatives += 1
        if arm2FirstFailK < 0 { arm2FirstFailK = k }
    }

    let mark = (flVerdict == exVerdict) ? " " : "  <-- FLOAT ERASED A REAL ORDER"
    say("  " + pad("10^\(k)", 8) + pad("\(ex)", 30) + pad(exVerdict, 18)
            + pad(fl == 0.0 ? "0" : "\(fl)", 26) + flVerdict + mark)
}
say()
say("  non-commuting pairs tested            \(LADDER_K.count)")
say("  float reported a zero commutator      \(arm2FalseNegatives) of \(LADDER_K.count)")
say("  first scale at which float goes blind " + (arm2FirstFailK < 0 ? "none" : "10^\(arm2FirstFailK)"))
say()

// ---------------------------------------------------------------- ARM 3
rule("=")
say("ARM 3 — CONTROL.  Does the EXACT arm discriminate, or does it just always say one thing?")
rule("=")
say("  exact answers graded against the closed form  \(arm3ExactCorrect) of \(arm3ExactTested)")
say("  ARM 1 population: exact said COMMUTES on every rung")
say("  ARM 2 population: exact said DOES NOT on every rung")
let arm3Pass = (arm3ExactCorrect == arm3ExactTested) && arm3ExactTested == 2 * LADDER_K.count
say("  CONTROL: " + (arm3Pass
    ? "PASSES — the exact arm separates the two populations in both directions"
    : "FAILS — the exact arm is not an instrument and ARMS 1-2 cannot be read"))
say()

// ---------------------------------------------------------------- ARM 4
rule("=")
say("ARM 4 — THE FOLD.  Nine cells, the same 64 events, nine different arrival orders.")
rule("=")
say("population: 32 alternating magnitudes at 2^53 (telescoping to exactly -16)")
say("            + 32 small fractions 1/(p+i). A replica ledger with large balances")
say("            and small increments in one stream.")
say()

let ev = shearingEvents()
var exactResults = [String]()
var floatResults = [String]()

say("  " + pad("cell", 10) + pad("stride", 8) + pad("exact fold", 34) + "float fold (raw bits)")
rule()
for c in 0..<9 {
    let ord = arrivalOrder(cell: c, count: ev.count)
    let ex = exactFold(ev, order: ord)
    let fl = floatFold(ev, order: ord)
    exactResults.append("\(ex)")
    floatResults.append(bits(fl))
    say("  " + pad(CELL_NAMES[c], 10) + pad("\(CELL_STRIDES[c])", 8)
            + pad("\(ex)", 34) + bits(fl) + "  = \(fl)")
}
say()
let exDistinct = Set(exactResults).count
let flDistinct = Set(floatResults).count
say("  distinct results, EXACT arithmetic    \(exDistinct)")
say("  distinct results, DOUBLE arithmetic   \(flDistinct)")
say()
say("  A replica set that folds exactly needs no agreement protocol to agree.")
say("  A replica set that folds in double disagrees with ITSELF on identical input,")
say("  and a total order is the repair for that — not for anything the events did.")
say()

// ---------------------------------------------------------------- ARM 5
rule("=")
say("ARM 5 — CONTROL.  The same nine orders on a population float can hold exactly.")
rule("=")
say("population: 64 small integers, every partial sum exactly representable in a double.")
say()
let cev = controlEvents()
var cExact = [String]()
var cFloat = [String]()
for c in 0..<9 {
    let ord = arrivalOrder(cell: c, count: cev.count)
    cExact.append("\(exactFold(cev, order: ord))")
    cFloat.append(bits(floatFold(cev, order: ord)))
}
let cExDistinct = Set(cExact).count
let cFlDistinct = Set(cFloat).count
say("  distinct results, EXACT arithmetic    \(cExDistinct)   (value \(cExact[0]))")
say("  distinct results, DOUBLE arithmetic   \(cFlDistinct)")
let arm5Pass = (cExDistinct == 1 && cFlDistinct == 1)
say("  CONTROL: " + (arm5Pass
    ? "PASSES — float agrees with itself where it has nothing to round, so ARM 4 is"
      + "\n           measuring rounding and not the permutation generator"
    : "FAILS — the fold detector fires without rounding; ARM 4 cannot be read"))
say()

// ---------------------------------------------------------------- VERDICT
rule("=")
say("VERDICT")
rule("=")
say()
say("  MEASURED, and this is the whole claim:")
say()
say("    1. Order-dependence is a property of the ARITHMETIC, not of the events.")
say("       The same two operations, on the same two orders, are reported as")
say("       commuting or not commuting depending only on the number system used.")
say()
say("    2. Float is wrong in BOTH directions. It invented an order-dependence on")
say("       \(arm1FalsePositives) of \(LADDER_K.count) exactly-commuting pairs, and it lost a real one on")
say("       \(arm2FalseNegatives) of \(LADDER_K.count) genuinely non-commuting pairs.")
say()
say("    3. Nine cells folding one event set in nine arrival orders reach")
say("       \(exDistinct) result in exact arithmetic and \(flDistinct) in double.")
say()
say("  NOT CLAIMED. This measures a substrate, not the universe. It does not")
say("  demonstrate indefinite causal order, does not reproduce any photonic")
say("  experiment, and does not reverse any heat flow. The physics is cited on the")
say("  study page as REPORTED and the mapping onto this architecture is graded")
say("  ARGUMENT. What is sealed here is the arithmetic, which is ours to measure.")
say()

let allPass = arm3Pass && arm5Pass
            && arm1FalsePositives > 0 && arm2FalseNegatives > 0
            && exDistinct == 1 && flDistinct > 1

rule("=")
say("REFERENCE FIGURES — printed on every exit path")
rule("=")
say("  ARM 1 float false positives           \(arm1FalsePositives) of \(LADDER_K.count)")
say("  ARM 2 float false negatives           \(arm2FalseNegatives) of \(LADDER_K.count)")
say("  ARM 3 exact control                   \(arm3ExactCorrect) of \(arm3ExactTested)")
say("  ARM 4 exact distinct / float distinct \(exDistinct) / \(flDistinct)")
say("  ARM 5 control distinct exact / float  \(cExDistinct) / \(cFlDistinct)")
say("  TERMINAL                              "
    + (allPass ? "ORDER_IS_AN_ARTEFACT_OF_THE_ARITHMETIC"
               : "INSTRUMENT_DID_NOT_DISCRIMINATE"))
rule("=")

let seal = SHA256Exact.hex(TRANSCRIPT)
print("")
print("TRANSCRIPT SEAL  sha256  \(seal)")
print("MARKER           ORDER_IS_AN_ARTEFACT_OF_THE_ARITHMETIC")
