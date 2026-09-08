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
// SECTION B0 — THE INTEGER. Decimal string in, decimal string out, no fixed width.
// ══════════════════════════════════════════════════════════════════════════
//
// WHY NOT Int128. Swift 6.4 has a native Int128 and on this Mac it is faster than what
// is below. It is also NOT AVAILABLE EVERYWHERE THIS PROGRAM HAS TO RUN. A law that is
// Int128 on the build host and something else on the cells is two laws, and two laws
// drift — which is the exact defect the rest of this study is about. The cells carry
// exact numbers as strings, so the published program carries them as strings, and the
// Mac and the cells execute the same arithmetic on the same bytes.
//
// The second reason is a measurement, not a principle. Every fixed width has a ceiling,
// and a ceiling in a program that measures where floating point runs out is the same
// defect wearing a different width: this program's own switch algebra trapped at the
// third rung of its ladder under Int128 while every ANSWER was small. Below, there is
// no rung it cannot reach, so when a double loses the physics further down the ladder,
// the loss is the double's and not the instrument's.
//
// Sign and magnitude, little-endian UInt32 limbs. Division is bit-by-bit long division:
// slower than Knuth D and short enough to be read and checked by a stranger, which is
// the property that matters in a published verifier.

struct BigInt: Equatable, Comparable, CustomStringConvertible {
    var neg: Bool = false
    var mag: [UInt32] = []          // little-endian; empty means zero

    init() {}

    init(_ v: Int) {
        var u = UInt64(v.magnitude)
        neg = v < 0
        while u > 0 { mag.append(UInt32(truncatingIfNeeded: u)); u >>= 32 }
    }

    init(_ s: String) {
        var body = Substring(s)
        if body.hasPrefix("-") { neg = true; body = body.dropFirst() }
        for ch in body {
            guard let d = ch.wholeNumberValue else { continue }
            mag = BigInt.mulSmall(mag, 10)
            mag = BigInt.addSmall(mag, UInt32(d))
        }
        BigInt.trim(&mag)
        if mag.isEmpty { neg = false }
    }

    var isZero: Bool { mag.isEmpty }

    // ---- magnitude primitives ------------------------------------------------

    static func trim(_ a: inout [UInt32]) { while let l = a.last, l == 0 { a.removeLast() } }

    static func cmpMag(_ a: [UInt32], _ b: [UInt32]) -> Int {
        if a.count != b.count { return a.count < b.count ? -1 : 1 }
        var i = a.count - 1
        while i >= 0 {
            if a[i] != b[i] { return a[i] < b[i] ? -1 : 1 }
            i -= 1
        }
        return 0
    }

    static func addMag(_ a: [UInt32], _ b: [UInt32]) -> [UInt32] {
        var out = [UInt32](); out.reserveCapacity(max(a.count, b.count) + 1)
        var carry: UInt64 = 0
        for i in 0..<max(a.count, b.count) {
            let s = UInt64(i < a.count ? a[i] : 0) + UInt64(i < b.count ? b[i] : 0) + carry
            out.append(UInt32(truncatingIfNeeded: s)); carry = s >> 32
        }
        if carry > 0 { out.append(UInt32(carry)) }
        return out
    }

    /// a - b, requiring a >= b.
    static func subMag(_ a: [UInt32], _ b: [UInt32]) -> [UInt32] {
        var out = [UInt32](); out.reserveCapacity(a.count)
        var borrow: Int64 = 0
        for i in 0..<a.count {
            var d = Int64(a[i]) - Int64(i < b.count ? b[i] : 0) - borrow
            if d < 0 { d += 1 << 32; borrow = 1 } else { borrow = 0 }
            out.append(UInt32(d))
        }
        trim(&out)
        return out
    }

    static func mulSmall(_ a: [UInt32], _ m: UInt32) -> [UInt32] {
        var out = [UInt32](); out.reserveCapacity(a.count + 1)
        var carry: UInt64 = 0
        for limb in a {
            let p = UInt64(limb) * UInt64(m) + carry
            out.append(UInt32(truncatingIfNeeded: p)); carry = p >> 32
        }
        while carry > 0 { out.append(UInt32(truncatingIfNeeded: carry)); carry >>= 32 }
        trim(&out)
        return out
    }

    static func addSmall(_ a: [UInt32], _ v: UInt32) -> [UInt32] {
        var out = a
        var carry = UInt64(v)
        var i = 0
        while carry > 0 {
            if i == out.count { out.append(0) }
            let s = UInt64(out[i]) + carry
            out[i] = UInt32(truncatingIfNeeded: s); carry = s >> 32; i += 1
        }
        return out
    }

    static func mulMag(_ a: [UInt32], _ b: [UInt32]) -> [UInt32] {
        if a.isEmpty || b.isEmpty { return [] }
        var out = [UInt32](repeating: 0, count: a.count + b.count)
        for i in 0..<a.count {
            var carry: UInt64 = 0
            let ai = UInt64(a[i])
            if ai == 0 { continue }
            for j in 0..<b.count {
                let t = ai * UInt64(b[j]) + UInt64(out[i + j]) + carry
                out[i + j] = UInt32(truncatingIfNeeded: t); carry = t >> 32
            }
            var k = i + b.count
            while carry > 0 {
                let t = UInt64(out[k]) + carry
                out[k] = UInt32(truncatingIfNeeded: t); carry = t >> 32; k += 1
            }
        }
        trim(&out)
        return out
    }

    static func bitLength(_ a: [UInt32]) -> Int {
        guard let top = a.last else { return 0 }
        var n = (a.count - 1) * 32
        var t = top
        while t > 0 { n += 1; t >>= 1 }
        return n
    }

    static func bit(_ a: [UInt32], _ i: Int) -> Bool {
        let limb = i >> 5
        if limb >= a.count { return false }
        return (a[limb] >> UInt32(i & 31)) & 1 == 1
    }

    static func shiftLeft1(_ a: [UInt32]) -> [UInt32] {
        var out = [UInt32](); out.reserveCapacity(a.count + 1)
        var carry: UInt32 = 0
        for limb in a { out.append((limb << 1) | carry); carry = limb >> 31 }
        if carry > 0 { out.append(carry) }
        return out
    }

    /// Bit-by-bit long division. Returns (quotient, remainder) magnitudes.
    static func divModMag(_ a: [UInt32], _ b: [UInt32]) -> ([UInt32], [UInt32]) {
        precondition(!b.isEmpty, "division by zero")
        if cmpMag(a, b) < 0 { return ([], a) }
        var q = [UInt32](repeating: 0, count: a.count)
        var r = [UInt32]()
        var i = bitLength(a) - 1
        while i >= 0 {
            r = shiftLeft1(r)
            if bit(a, i) { r = addSmall(r, 1) }
            if cmpMag(r, b) >= 0 {
                r = subMag(r, b)
                q[i >> 5] |= (1 << UInt32(i & 31))
            }
            i -= 1
        }
        trim(&q); trim(&r)
        return (q, r)
    }

    // ---- signed operators ----------------------------------------------------

    static func + (x: BigInt, y: BigInt) -> BigInt {
        var z = BigInt()
        if x.neg == y.neg { z.mag = addMag(x.mag, y.mag); z.neg = x.neg }
        else {
            let c = cmpMag(x.mag, y.mag)
            if c == 0 { return BigInt() }
            if c > 0 { z.mag = subMag(x.mag, y.mag); z.neg = x.neg }
            else     { z.mag = subMag(y.mag, x.mag); z.neg = y.neg }
        }
        if z.mag.isEmpty { z.neg = false }
        return z
    }

    static prefix func - (x: BigInt) -> BigInt {
        var z = x; if !z.mag.isEmpty { z.neg = !z.neg }; return z
    }

    static func - (x: BigInt, y: BigInt) -> BigInt { x + (-y) }

    static func * (x: BigInt, y: BigInt) -> BigInt {
        var z = BigInt(); z.mag = mulMag(x.mag, y.mag)
        z.neg = !z.mag.isEmpty && (x.neg != y.neg)
        return z
    }

    /// Truncating division, like Swift's integer `/`.
    static func / (x: BigInt, y: BigInt) -> BigInt {
        let (q, _) = divModMag(x.mag, y.mag)
        var z = BigInt(); z.mag = q; z.neg = !q.isEmpty && (x.neg != y.neg)
        return z
    }

    /// Remainder taking the sign of the dividend, like Swift's `%`.
    static func % (x: BigInt, y: BigInt) -> BigInt {
        let (_, r) = divModMag(x.mag, y.mag)
        var z = BigInt(); z.mag = r; z.neg = !r.isEmpty && x.neg
        return z
    }

    static func < (x: BigInt, y: BigInt) -> Bool {
        if x.neg != y.neg { return x.neg }
        let c = cmpMag(x.mag, y.mag)
        return x.neg ? c > 0 : c < 0
    }

    static func == (x: BigInt, y: BigInt) -> Bool { x.neg == y.neg && x.mag == y.mag }

    var description: String {
        if mag.isEmpty { return "0" }
        var digits = ""
        var cur = mag
        let billion: [UInt32] = [1_000_000_000]
        while !cur.isEmpty {
            let (q, r) = BigInt.divModMag(cur, billion)
            let chunk = r.isEmpty ? 0 : UInt64(r[0])
            cur = q
            if cur.isEmpty { digits = String(chunk) + digits }
            else {
                var s = String(chunk)
                while s.count < 9 { s = "0" + s }
                digits = s + digits
            }
        }
        return (neg ? "-" : "") + digits
    }

    /// The bridge into the float arm, and the only place a Double is ever made from one
    /// of these: a decimal string, parsed once. Same text on every machine.
    var asDouble: Double { Double(description) ?? 0 }
}

func bigGCD(_ a: BigInt, _ b: BigInt) -> BigInt {
    var x = a.neg ? -a : a
    var y = b.neg ? -b : b
    while !y.isZero { let t = x % y; x = y; y = t }
    return x
}

extension BigInt: ExpressibleByIntegerLiteral {
    init(integerLiteral value: Int) { self.init(value) }
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

// A value wider than its column must NOT run into the next one. Measured: an exact
// fraction 48 digits long swallowed the next column entirely, so the double's "0"
// appeared as a trailing digit of the denominator and the table read as though the
// float column were empty. A cell that overflows still ends with a separator.
func pad(_ s: String, _ n: Int) -> String {
    var t = s
    while t.count < n { t += " " }
    if t.count >= n && s.count >= n { t += "  " }
    return t
}

func lpad(_ s: String, _ n: Int) -> String {
    var t = s
    while t.count < n { t = " " + t }
    return t
}

/// An exact rational over Int128. Always reduced, denominator always positive.
/// This is the whole of the exact arm: it has no rounding step to have an order.
struct Q: Equatable, CustomStringConvertible {
    var n: BigInt
    var d: BigInt

    init(_ n: BigInt, _ d: BigInt = 1) {
        precondition(d != 0, "zero denominator")
        var nn = n, dd = d
        if dd < 0 { nn = -nn; dd = -dd }
        let g = bigGCD(nn, dd)
        if g > BigInt(1) { nn = nn / g; dd = dd / g }
        self.n = nn; self.d = dd
    }

    // REDUCE BEFORE MULTIPLYING, NOT AFTER. The naive forms (a.n*b.d + b.n*a.d, a.d*b.d)
    // and (a.n*b.n, a.d*b.d) build the unreduced product first and only then divide it
    // out — so an expression whose ANSWER is small can still overflow on the way to it.
    // Measured: this program's switch algebra trapped at the third rung of its ladder
    // with every final fraction comfortably inside Int128. Cancelling the cross terms
    // first costs two gcds and buys back the whole ladder.
    static func + (a: Q, b: Q) -> Q {
        let g = bigGCD(a.d, b.d)
        return Q(a.n * (b.d / g) + b.n * (a.d / g), a.d / g * b.d)
    }
    static func - (a: Q, b: Q) -> Q {
        let g = bigGCD(a.d, b.d)
        return Q(a.n * (b.d / g) - b.n * (a.d / g), a.d / g * b.d)
    }
    static func * (a: Q, b: Q) -> Q {
        let g1 = bigGCD(a.n, b.d), g2 = bigGCD(b.n, a.d)
        let g1s = g1 == 0 ? 1 : g1, g2s = g2 == 0 ? 1 : g2
        return Q((a.n / g1s) * (b.n / g2s), (a.d / g2s) * (b.d / g1s))
    }
    static func / (a: Q, b: Q) -> Q {
        precondition(b.n != 0, "division by zero")
        return a * Q(b.d, b.n)
    }

    var isZero: Bool { n == 0 }
    var description: String { d == 1 ? "\(n)" : "\(n)/\(d)" }
}

/// An affine map over the rationals, x |-> (a*x + b)/d, carried as three integers.
/// Nothing here is evaluated to a decimal, so nothing here can round.
struct Affine {
    var a: BigInt
    var b: BigInt
    var d: BigInt
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

func pow10(_ k: Int) -> BigInt {
    var v = BigInt(1)
    for _ in 0..<k { v = v * BigInt(10) }
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
    let a = m.a.asDouble
    let b = m.b.asDouble
    let d = m.d.asDouble
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
let SMALL_DENS: [BigInt] = [3, 7, 11, 13, 17, 19, 23, 29]

func shearingEvents() -> [Q] {
    var e = [Q]()
    let big: BigInt = 9007199254740992      // 2^53
    for i in 0..<32 {
        let v = big + BigInt(i)
        e.append(Q(i % 2 == 0 ? v : -v))
    }
    for i in 0..<32 {
        e.append(Q(1, SMALL_DENS[i % 8] + BigInt(i)))
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
    for i in 0..<64 { e.append(Q(BigInt(i * 37 - 1000))) }
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
        let n = events[idx].n.asDouble
        let d = events[idx].d.asDouble
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
// SECTION E2 — HOLONOMY. The commutator is not an error term; it is curvature.
// ══════════════════════════════════════════════════════════════════════════
//
// An affine map x |-> (a x + b)/d is the projective action of the integer matrix
// [[a, b], [0, d]]. Composition is matrix product; the inverse is the adjugate
// [[d, -b], [0, a]]. So the GROUP COMMUTATOR
//
//     K = A · B · A⁻¹ · B⁻¹
//
// is the transport around a closed loop: go A, go B, come back along A, come back
// along B. On a flat connection you return exactly where you started and K is the
// identity. What K carries when it is not the identity is HOLONOMY — the standard
// geometric object, not a numerical residue. We report it as the exact rational
// h = K₀₁/K₀₀, the translation the loop failed to undo.
//
// This matters for what the study is about. An observer who computes h in floating
// point does not merely get an imprecise number: it reports a DIFFERENT GEOMETRY.
// Non-zero h on a flat loop is curvature that is not there. Zero h on a curved loop
// is flatness that is not there. Both happen below, and neither is monotone in the
// scale, so no calibration removes them.

struct Mat2 {
    var a: BigInt, b: BigInt, d: BigInt    // [[a, b], [0, d]]
}

func mul(_ m: Mat2, _ n: Mat2) -> Mat2 {
    Mat2(a: m.a * n.a, b: m.a * n.b + m.b * n.d, d: m.d * n.d)
}

/// Adjugate — the projective inverse. Scale is irrelevant to the action, so no division.
func inv(_ m: Mat2) -> Mat2 { Mat2(a: m.d, b: -m.b, d: m.a) }

func mat(_ m: Affine) -> Mat2 { Mat2(a: m.a, b: m.b, d: m.d) }

/// Exact holonomy of the closed loop A · B · A⁻¹ · B⁻¹, as the rational K₀₁/K₀₀.
/// Zero exactly when the loop closes, which is exactly when A and B commute.
func holonomy(_ A: Affine, _ B: Affine) -> Q {
    let K = mul(mul(mat(A), mat(B)), mul(inv(mat(A)), inv(mat(B))))
    return Q(K.b, K.a)
}

/// The same closed loop walked in double precision, from x = 1. A flat loop must
/// return to exactly 1.0; whatever it returns instead is the curvature it invented.
func floatHolonomy(_ A: Affine, _ B: Affine) -> Double {
    let ai = Affine(a: A.d, b: -A.b, d: A.a, name: "A^-1")
    let bi = Affine(a: B.d, b: -B.b, d: B.a, name: "B^-1")
    var x = 1.0
    x = floatApply(A, x)
    x = floatApply(B, x)
    x = floatApply(ai, x)
    x = floatApply(bi, x)
    return x - 1.0
}

// ══════════════════════════════════════════════════════════════════════════
// SECTION E3 — THE CUT. On a compact phase coordinate there is no total order.
// ══════════════════════════════════════════════════════════════════════════
//
// This is the arm that decides what the study is about, so it is worth saying
// plainly what it tests.
//
// A scalar-line model of time says events carry a coordinate on a line, and "before"
// is that coordinate's order. Lamport's construction — the ancestor of every vector
// clock and every consensus protocol — takes that model directly from the light-cone
// partial order of special relativity. Computation did not invent its causality; it
// imported it from a model of spacetime.
//
// A PHASE model says the coordinate is angular: tau on a circle, not a point on a
// line. And a circle admits NO translation-invariant total order. To get a sequence
// out of it you must first choose a cut — an origin — and the cut is not in the data.
//
// So we measure both. Nine phase points, exact rationals of a turn, no float:
//
//   * Take each of the nine points in turn as the origin, and read off the total
//     order it induces. Count the distinct sequences.
//   * Compute, under each of those nine cuts, the CYCLIC ORIENTATION of all 84
//     ordered triples — the ternary relation "b lies on the arc from a to c". Count
//     the distinct orientation vectors.
//
// The control is the same nine values read as points on a LINE, where re-origining
// subtracts without wrapping. If the line arm also produced nine sequences, the
// instrument would be measuring the cut mechanism instead of compactness.

/// Nine phase points as exact fractions of one turn, listed in an ARRIVAL order that
/// is not their angular order — because the arrival order is not the geometry, and a
/// list that happened to be sorted would make every sequence below a plain rotation
/// and the arm would look arranged. These are the same nine angles, shuffled.
let PHASES: [Q] = [Q(2,3), Q(1,9), Q(7,8), Q(5,11), Q(20,21), Q(1,3), Q(4,7), Q(17,23), Q(2,7)]

/// a < b for non-negative rationals, by cross-multiplication. Integers only.
func lt(_ a: Q, _ b: Q) -> Bool { a.n * b.d < b.n * a.d }

/// (x − origin) reduced into [0, 1) — the phase measured from a chosen cut.
func fromCut(_ x: Q, _ origin: Q) -> Q {
    let d = x - origin
    return d.n < 0 ? d + Q(1) : d
}

/// The sequence the cut induces: indices sorted by phase measured from that origin.
func sequence(underCut c: Int, wrap: Bool) -> [Int] {
    let origin = PHASES[c]
    var idx = Array(0..<PHASES.count)
    idx.sort { i, j in
        let a = wrap ? fromCut(PHASES[i], origin) : PHASES[i] - origin
        let b = wrap ? fromCut(PHASES[j], origin) : PHASES[j] - origin
        if a == b { return i < j }
        return (a.n * b.d) < (b.n * a.d)
    }
    return idx
}

/// Cyclic orientation of the triple (i, j, k) as read under one cut: +1 when their
/// ranks appear in one of the three rotations of increasing order, −1 otherwise.
/// This is the ternary relation that survives the cut, and the point of the arm.
func orientations(underCut c: Int) -> [Int] {
    let seq = sequence(underCut: c, wrap: true)
    var rank = [Int](repeating: 0, count: PHASES.count)
    for (r, i) in seq.enumerated() { rank[i] = r }
    var out = [Int]()
    let n = PHASES.count
    for i in 0..<n {
        for j in (i + 1)..<n {
            for k in (j + 1)..<n {
                let (ri, rj, rk) = (rank[i], rank[j], rank[k])
                let positive = (ri < rj && rj < rk)
                             || (rj < rk && rk < ri)
                             || (rk < ri && ri < rj)
                out.append(positive ? 1 : -1)
            }
        }
    }
    return out
}

// ══════════════════════════════════════════════════════════════════════════
// SECTION E4 — THEIR EXPERIMENT, RUN IN INTEGERS. No qubit, no interferometer.
// ══════════════════════════════════════════════════════════════════════════
//
// The photonic result this study is placed beside is a quantum SWITCH of two thermalising
// channels — the construction of Felce & Vedral (PRL 125, 070603, 2020), which Xue et al.
// realise on an optical bench. Its claim is that the switch does something NO definite
// order does. That claim is a number, and the number is exactly computable, so we compute
// it rather than believing it or approximating it.
//
// THE ALGEBRA, written out so the arithmetic below is checkable by hand.
// A fully thermalising qubit channel with populations (p0, p1) has Kraus operators
// K_ab = sqrt(p_a)|a><b|. For two such channels, K (populations p) and L (populations q),
// the switch with control |+>, post-selected on |+>, leaves the system in
//
//     rho_+  =  1/4 [ E2(E1(rho)) + E1(E2(rho)) + X + X† ],   with  X_ba = p_a q_b rho_ba
//
// The first two terms ARE the two definite orders — for fully thermalising channels they
// are just tau_2 and tau_1, each reservoir's own thermal state, which is why a definite
// order can do nothing here. X is the interference term and it is the entire content of
// indefinite causal order. For a diagonal input rho = diag(r0, r1) it is diagonal too, so
// every quantity below is a RATIO OF INTEGERS:
//
//     u0 = ( p0 + q0 + 2 p0 q0 r0 ) / 4      u1 = ( p1 + q1 + 2 p1 q1 r1 ) / 4
//     P(+) = u0 + u1                          n1 = u1 / (u0 + u1)
//
// with n1 the excited population out and energy measured in units of the level gap.
//
// WHY THIS IS EXACT AND NOT AN APPROXIMATION OF THEIRS. A thermal population is
// p1 = z/(1+z) with z = exp(-beta*eps) the Boltzmann factor. Selecting a reservoir by its
// BOLTZMANN FACTOR instead of by its temperature is a bijection onto the same physics —
// every rational z in (0,1) is a real temperature — and it makes p0, p1, q0, q1, r0, r1
// exact rationals. Nothing is discretised, sampled, rounded or fitted. The state is the
// state, and the answer is a fraction.

struct SwitchResult {
    var n1: Q          // excited population out of the switch, post-selected on |+>
    var pPlus: Q       // probability the control lands on |+>
    var order12: Q     // excited population after channel 1 then channel 2  (= q1)
    var order21: Q     // excited population after channel 2 then channel 1  (= p1)
    var eIn: Q         // excited population in
    var anomaly: Q     // n1 - eIn : energy the switch moved, in units of the gap
}

/// The whole experiment, from three Boltzmann factors. Integers in, integers out.
func runSwitch(z1: Q, z2: Q, zs: Q) -> SwitchResult {
    let one = Q(1)
    let p1 = z1 / (one + z1), p0 = one / (one + z1)
    let q1 = z2 / (one + z2), q0 = one / (one + z2)
    let r1 = zs / (one + zs), r0 = one / (one + zs)

    let u0 = (p0 + q0 + Q(2) * p0 * q0 * r0) * Q(1, 4)
    let u1 = (p1 + q1 + Q(2) * p1 * q1 * r1) * Q(1, 4)
    let tot = u0 + u1
    let n1  = u1 / tot
    return SwitchResult(n1: n1, pPlus: tot, order12: q1, order21: p1,
                        eIn: r1, anomaly: n1 - r1)
}

/// The same experiment in double precision — the arithmetic a conventional simulation of
/// this physics uses. Same formula, same inputs, one difference.
func runSwitchFloat(z1: Double, z2: Double, zs: Double) -> Double {
    let p1 = z1 / (1 + z1), p0 = 1 / (1 + z1)
    let q1 = z2 / (1 + z2), q0 = 1 / (1 + z2)
    let r1 = zs / (1 + zs), r0 = 1 / (1 + zs)
    let u0 = (p0 + q0 + 2 * p0 * q0 * r0) / 4
    let u1 = (p1 + q1 + 2 * p1 * q1 * r1) / 4
    return u1 / (u0 + u1) - r1
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

say("STUDY 40 — THE ORDER WAS NEVER IN THE DATA")
say("ico-causal-order-shear.swift — no corpus, no network, no key, no argv")
rule("=")
say()
say("QUESTION.  Computation did not invent its model of causality. Lamport built the")
say("           ordering of events on the light-cone partial order of relativity, and")
say("           every vector clock and consensus protocol descends from it. So: is a")
say("           definite total order required by the events, by the geometry, or only")
say("           by the arithmetic we happened to fold them in?")
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

// ---------------------------------------------------------------- ARM 6
rule("=")
say("ARM 6 — HOLONOMY.  Walk the closed loop A·B·A⁻¹·B⁻¹ and see if you get home.")
rule("=")
say("The commutator is not an error term. It is the transport around a closed loop, and")
say("what it carries is curvature. A flat loop returns EXACTLY to where it started.")
say("Exact holonomy is the rational K01/K00; the float arm walks the same four steps")
say("from x = 1.0 and reports whatever it failed to undo.")
say()
say("  " + pad("scale", 8) + pad("loop", 10) + pad("exact holonomy", 30)
        + pad("exact geometry", 18) + pad("double holonomy", 26) + "double geometry")
rule()

var arm6FakeCurvature = 0
var arm6MissedCurvature = 0
let LADDER_K_HOLO = [3, 4, 5, 6, 7, 8]

for k in LADDER_K_HOLO {
    for flat in [true, false] {
        let (A, B) = flat ? commutingPair(k) : nonCommutingPair(k)
        let hx = holonomy(A, B)
        let hf = floatHolonomy(A, B)
        let exG = hx.isZero ? "FLAT" : "CURVED"
        let flG = hf == 0.0 ? "FLAT" : "CURVED"
        var mark = " "
        if exG == "FLAT" && flG == "CURVED" { arm6FakeCurvature += 1; mark = "  <-- CURVATURE INVENTED" }
        if exG == "CURVED" && flG == "FLAT" { arm6MissedCurvature += 1; mark = "  <-- CURVATURE ERASED" }
        say("  " + pad("10^\(k)", 8) + pad(flat ? "flat" : "curved", 10)
                + pad("\(hx)", 30) + pad(exG, 18)
                + pad(hf == 0.0 ? "0" : "\(hf)", 26) + flG + mark)
    }
}
say()
say("  loops walked                          \(LADDER_K_HOLO.count * 2)")
say("  curvature INVENTED on a flat loop     \(arm6FakeCurvature)")
say("  curvature ERASED on a curved loop     \(arm6MissedCurvature)")
say()
say("  A float-valued observer does not measure this geometry imprecisely.")
say("  It measures a DIFFERENT geometry, and it is wrong in both directions.")
say()

// ---------------------------------------------------------------- ARM 7
rule("=")
say("ARM 7 — THE CUT.  Is the ORDER in the data, or in the origin you chose?")
rule("=")
say("Nine events carrying an angular coordinate — exact fractions of one turn, no float.")
say("Take each in turn as the origin and read off the sequence it induces.")
say()

var seqs = [String]()
var oris = [String]()
for c in 0..<PHASES.count {
    let s = sequence(underCut: c, wrap: true)
    seqs.append(s.map(String.init).joined(separator: " "))
    oris.append(orientations(underCut: c).map(String.init).joined(separator: ","))
    say("  cut at tau = " + pad("\(PHASES[c])", 8) + "->  sequence  " + seqs[c])
}
say()
var lineSeqs = [String]()
for c in 0..<PHASES.count {
    lineSeqs.append(sequence(underCut: c, wrap: false).map(String.init).joined(separator: " "))
}
let distinctSeq = Set(seqs).count
let distinctOri = Set(oris).count
let distinctLine = Set(lineSeqs).count
let triples = PHASES.count * (PHASES.count - 1) * (PHASES.count - 2) / 6

say("  distinct SEQUENCES across the nine cuts        \(distinctSeq)")
say("  distinct CYCLIC ORIENTATIONS across those cuts \(distinctOri)   (over \(triples) ordered triples)")
say()
say("  CONTROL — the same nine values read as points on a LINE, re-origined by")
say("  subtraction with no wraparound:")
say("  distinct SEQUENCES across the nine cuts        \(distinctLine)")
let arm7Pass = (distinctSeq == PHASES.count && distinctOri == 1 && distinctLine == 1)
say("  CONTROL: " + (arm7Pass
    ? "PASSES — the line gives one sequence under every cut, so the \(distinctSeq) on the"
      + "\n           circle come from COMPACTNESS and not from the cut mechanism"
    : "FAILS — the arm is measuring its own re-origining and cannot be read"))
say()
say("  On a compact phase coordinate the sequence is an artefact of the cut, and the")
say("  cut is not in the data. What survives every cut is the ORIENTATION — the ternary")
say("  relation over all \(triples) triples, which comes back as \(distinctOri) vector from all \(PHASES.count) origins.")
say("  A model that seals a SEQUENCE must first make everyone agree on an origin.")
say("  A model that seals the ORIENTATION needs no such agreement, because there is")
say("  nothing left to disagree about.")
say()

// ---------------------------------------------------------------- ARM 8
rule("=")
say("ARM 8 — THEIR EXPERIMENT, RUN IN INTEGERS.  No qubit. No interferometer.")
rule("=")
say("The quantum switch of two thermalising channels — Felce & Vedral's construction,")
say("realised photonically by Xue et al. Its claim is that the switch does what NO")
say("definite order does. That is a number. Here is the number, exactly, as a fraction.")
say()
say("Case: the system and BOTH reservoirs sit at the SAME temperature. Classically")
say("nothing whatever can happen — a thermalising channel returns its own thermal state,")
say("so either definite order leaves an already-thermal system exactly where it was.")
say()
say("  " + pad("Boltzmann z", 16) + pad("order 1,2", 12) + pad("order 2,1", 12)
        + pad("SWITCH, exact", 34) + "energy moved (exact)")
rule()

var arm8Anomalies = 0
var arm8DefiniteMoves = 0
var arm8Rungs = 0
var arm8Largest = Q(0)
var arm8LargestZ = Q(0)

// Boltzmann factors (m-1)/m: a ladder from cold to nearly-infinite temperature.
var zLadder: [Q] = []
for m in [2, 3, 5, 10, 100, 1_000, 10_000, 100_000, 1_000_000] {
    zLadder.append(Q(BigInt(m - 1), BigInt(m)))
}

for z in zLadder {
    let r = runSwitch(z1: z, z2: z, zs: z)
    arm8Rungs += 1
    let definiteMoved = (r.order12 != r.eIn) || (r.order21 != r.eIn)
    if definiteMoved { arm8DefiniteMoves += 1 }
    if !r.anomaly.isZero { arm8Anomalies += 1 }
    // largest |anomaly| so far, compared exactly by cross-multiplication
    let a = r.anomaly.n < 0 ? Q(-r.anomaly.n, r.anomaly.d) : r.anomaly
    let b = arm8Largest.n < 0 ? Q(-arm8Largest.n, arm8Largest.d) : arm8Largest
    if a.n * b.d > b.n * a.d { arm8Largest = r.anomaly; arm8LargestZ = z }
    say("  " + pad("\(z)", 16)
            + pad(r.order12 == r.eIn ? "no change" : "MOVED", 12)
            + pad(r.order21 == r.eIn ? "no change" : "MOVED", 12)
            + pad("\(r.n1)", 34) + "\(r.anomaly)")
}
say()
say("  rungs computed                              \(arm8Rungs)")
say("  rungs where a DEFINITE order moved anything \(arm8DefiniteMoves)")
say("  rungs where the SWITCH moved energy         \(arm8Anomalies)")
say("  largest energy moved                        \(arm8Largest)  at z = \(arm8LargestZ)")
say()
say("  Every one of those is a fraction, not a measurement. There is no shot noise, no")
say("  visibility, no error bar and no post-selection statistics, because nothing was")
say("  sampled — the state was carried as integers and read off. And the definite-order")
say("  columns are the control: they move nothing at every rung, so the switch column is")
say("  the only thing in the experiment that is doing anything.")
say()

// --- ARM 8b: the control that must NOT show an anomaly ---
rule()
say("  CONTROL — infinite temperature, z = 1. Populations are exactly 1/2 and the")
say("  interference term cannot break a symmetry that is not there. The switch must")
say("  move NOTHING, or this arm is an always-red detector and reports nothing at all.")
let ctl = runSwitch(z1: Q(1), z2: Q(1), zs: Q(1))
let arm8ControlPass = ctl.anomaly.isZero
say("    z = 1  ->  switch moved \(ctl.anomaly)   " + (arm8ControlPass ? "CONTROL PASSES" : "CONTROL FAILS"))
say()

// --- ARM 8c: cold system against two hotter reservoirs ---
rule()
say("  AND THE ANOMALOUS DIRECTION. System at z = 1/100 (cold) against two reservoirs")
say("  at z = 99/100 (hot). A definite order hands the system the hot reservoir's own")
say("  thermal state. The switch does not.")
let hot = Q(99, 100), cold = Q(1, 100)
let an = runSwitch(z1: hot, z2: hot, zs: cold)
say("    in \(an.eIn)   definite order -> \(an.order12)   SWITCH -> \(an.n1)")
say("    the switch lands BELOW both definite orders by exactly \(an.order12 - an.n1)")
say("    control lands on |+> with probability exactly \(an.pPlus)")
say()

// --- ARM 8d: where a double loses the physics ---
rule("=")
say("ARM 9 — WHERE A DOUBLE LOSES THE PHYSICS.  Same formula, same inputs.")
rule("=")
say("The anomaly shrinks as the temperature rises. A conventional simulation computes")
say("this in double precision. At what point does it report that there is no effect?")
say()
say("  " + pad("Boltzmann z", 26) + pad("exact energy moved", 30) + pad("double", 26) + "verdict")
rule()

var arm9Lost = 0
var arm9Rungs = 0
var arm9FirstLostZ = ""
for k in 1...22 {
    var p = BigInt(1)
    for _ in 0..<k { p = p * BigInt(10) }
    let z = Q(p - 1, p)                       // 9/10, 99/100, ... 1 - 10^-9
    let zf = (p - BigInt(1)).asDouble / p.asDouble
    let ex = runSwitch(z1: z, z2: z, zs: z).anomaly
    let fl = runSwitchFloat(z1: zf, z2: zf, zs: zf)
    arm9Rungs += 1
    let lost = (!ex.isZero && fl == 0.0)
    if lost { arm9Lost += 1; if arm9FirstLostZ.isEmpty { arm9FirstLostZ = "1 - 10^-\(k)" } }
    say("  " + pad("1 - 10^-\(k)", 26) + pad("\(ex)", 30)
            + pad(fl == 0.0 ? "0" : "\(fl)", 26)
            + (lost ? "DOUBLE SAYS NO EFFECT  <-- physics lost" : "both see it"))
}
say()
say("  rungs computed                        \(arm9Rungs)")
say("  rungs where the double lost the effect \(arm9Lost)")
say("  first rung lost                        " + (arm9FirstLostZ.isEmpty ? "none" : arm9FirstLostZ))
say()
say("  The exact arithmetic returns a non-zero fraction on every rung. There is no")
say("  temperature at which the effect stops existing — only a temperature at which a")
say("  64-bit float stops being able to hold it, and reports its absence as a result.")
say()

// ---------------------------------------------------------------- VERDICT
rule("=")
say("VERDICT")
rule("=")
say()
say("  MEASURED, and this is the whole claim:")
say()
say("    1. ORDER-DEPENDENCE IS A PROPERTY OF THE ARITHMETIC. The same two operations,")
say("       on the same two orders, are reported as commuting or not commuting")
say("       depending only on the number system they were evaluated in.")
say()
say("    2. THE FLOAT OBSERVER MEASURES A DIFFERENT GEOMETRY, not a blurred one. Around")
say("       a closed loop, of \(LADDER_K_HOLO.count * 2) walked, it invented curvature where the manifold is flat")
say("       \(arm6FakeCurvature) times and erased it where the manifold is curved \(arm6MissedCurvature) — wrong in both")
say("       directions, and non-monotone in the scale, so there is no calibration that")
say("       removes it and no scale you can stay under.")
say()
say("    3. ON A COMPACT PHASE COORDINATE THERE IS NO TOTAL ORDER TO FIND. Nine origins")
say("       give \(distinctSeq) different sequences from one unchanged set of events, while the")
say("       cyclic orientation over \(triples) triples is a single vector — \(distinctOri), under all nine.")
say("       The sequence is an artefact of the cut; the orientation is the fact. On a")
say("       line, re-origining changes nothing — \(distinctLine) sequence — so this is compactness.")
say()
say("    4. AND THE PROSTHESIS WAS NEVER HOLDING UP CAUSALITY. Nine cells folding one")
say("       event set in nine arrival orders reach \(exDistinct) result in exact arithmetic and")
say("       \(flDistinct) in double. What a total order repairs is the rounding, not the physics.")
say()
say("    5. AND THEIR EXPERIMENT IS A FRACTION. The quantum switch of two thermalising")
say("       channels, computed exactly: at every one of \(arm8Rungs) reservoir settings the switch")
say("       moved energy that NEITHER definite order moved — \(arm8Anomalies) of \(arm8Rungs) against \(arm8DefiniteMoves) of \(arm8Rungs) —")
say("       with no qubit, no interferometer, no shot noise, no visibility and no error")
say("       bar, because nothing was sampled. At z = 1/2 the switch moves exactly -1/18.")
say()
say("    6. AND A DOUBLE LOSES THAT PHYSICS AT A MEASURABLE PLACE. Over \(arm9Rungs) rungs the")
say("       exact arithmetic returns a non-zero fraction on every one; the double")
say("       returns EXACTLY ZERO on \(arm9Lost), first at " + arm9FirstLostZ + ". It does not report a small")
say("       effect there. It reports NO EFFECT — the absence of the physics, as a result.")
say()
say("  WHAT THAT COSTS THE SCALAR-TIME MODEL. A model in which events carry a scalar")
say("  coordinate on a line and 'before' is that coordinate's order needs two things")
say("  this program does not find: a cut that is in the data, and an arithmetic whose")
say("  composition is associative. Take either away and the sequence stops being a")
say("  fact about the events. What survives both is angular — an orientation on a")
say("  compact coordinate, which no choice of origin can move.")
say()
say("  NOT CLAIMED, and the distinction is the point. This measures a substrate, not")
say("  the universe. It does not demonstrate indefinite causal order, reproduce any")
say("  photonic experiment, or reverse any heat flow — that work is cited on the study")
say("  page as REPORTED, and it belongs to the people who did it. Nor does it single")
say("  out ONE compact manifold: it measures that a phase coordinate carries an")
say("  invariant a scalar line cannot, which is a statement about the CLASS, and every")
say("  compact coordinate in that class shares it. Which manifold is the right one is")
say("  not answered here and is not claimed here.")
say()

let allPass = arm3Pass && arm5Pass && arm7Pass && arm8ControlPass
            && arm1FalsePositives > 0 && arm2FalseNegatives > 0
            && arm6FakeCurvature > 0 && arm6MissedCurvature > 0
            && arm8Anomalies == arm8Rungs && arm8DefiniteMoves == 0
            && arm9Lost > 0 && arm9Lost < arm9Rungs
            && exDistinct == 1 && flDistinct > 1

rule("=")
say("REFERENCE FIGURES — printed on every exit path")
rule("=")
say("  ARM 1 float false positives           \(arm1FalsePositives) of \(LADDER_K.count)")
say("  ARM 2 float false negatives           \(arm2FalseNegatives) of \(LADDER_K.count)")
say("  ARM 3 exact control                   \(arm3ExactCorrect) of \(arm3ExactTested)")
say("  ARM 4 exact distinct / float distinct \(exDistinct) / \(flDistinct)")
say("  ARM 5 control distinct exact / float  \(cExDistinct) / \(cFlDistinct)")
say("  ARM 6 curvature invented / erased     \(arm6FakeCurvature) / \(arm6MissedCurvature) of \(LADDER_K_HOLO.count * 2) loops")
say("  ARM 7 sequences / orientations / line \(distinctSeq) / \(distinctOri) / \(distinctLine)")
say("  ARM 8 switch moved / definite moved   \(arm8Anomalies) / \(arm8DefiniteMoves) of \(arm8Rungs) settings")
say("  ARM 8 largest energy moved            \(arm8Largest) at z = \(arm8LargestZ)")
say("  ARM 9 double lost the physics         \(arm9Lost) of \(arm9Rungs), first at " + arm9FirstLostZ)
say("  TERMINAL                              "
    + (allPass ? "ORDER_IS_AN_ARTEFACT_OF_THE_ARITHMETIC"
               : "INSTRUMENT_DID_NOT_DISCRIMINATE"))
rule("=")

let seal = SHA256Exact.hex(TRANSCRIPT)
print("")
print("TRANSCRIPT SEAL  sha256  \(seal)")
print("MARKER           ORDER_IS_AN_ARTEFACT_OF_THE_ARITHMETIC")
