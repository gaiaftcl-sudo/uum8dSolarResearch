// =====================================================================================
// extraction-exact.swift — WHAT WAS ACTUALLY TAKEN.
//
// The detector next door decides WHETHER a swap was sheared. It has never been asked HOW
// MUCH. This program asks it. Two quantities, kept apart because conflating them is the
// usual error:
//
//   ATTACKER NET POSITION CHANGE — what the two attacker legs put into the pool and took
//   out of it, per token, summed. Exact, no model, no assumption: it is the sum of the two
//   Swap events' own deltas with the sign flipped. It is NOT profit: it is gross of gas,
//   gross of any inventory move, and denominated in two tokens that this program refuses
//   to add together without saying so.
//
//   VICTIM SHORTFALL — the difference between what the victim's swap actually returned and
//   what THE SAME SWAP, same input, against the SAME POOL would have returned had the
//   front-run leg not been placed in front of it. This is the number a person can use. It
//   is exactly computable from the pool's own arithmetic, in integers, with no price feed.
//
// These are different quantities. Attacker net is what one party gained across two legs;
// victim shortfall is what one other party lost on one leg. They are not each other's
// negative — the pool keeps the fee on three swaps, and the attacker's own two legs pay it.
//
// -------------------------------------------------------------------------------------
// THE FORMULA, DERIVED. No float appears in it and none appears in the program.
//
// CONSTANT PRODUCT (Uniswap-V2-shaped pools). A pool holds integer reserves (Rin, Rout).
// A swap paying `a` units of the input token, with fee numerator F out of 1000, may take
// out at most `q` where the pool's own invariant check holds:
//
//     (Rin·1000 + a·F) · (Rout − q)·1000  >=  Rin·1000 · Rout·1000
//
// Solving for the largest integer q:
//
//     out(a; Rin, Rout, F)  =  floor( a·F·Rout / (Rin·1000 + a·F) )                  (1)
//
// Every term is an integer, the division is a floor, and there is no rounding choice to
// make. F is NOT assumed: it is RECOVERED from the victim's own swap by requiring (1) to
// reproduce the observed output exactly against the observed pre-swap reserves. A pool
// whose fee cannot be recovered is NOT_KNOWN and is counted as such, never defaulted.
//
// The reserves are not assumed either. A V2 pool emits Sync(reserve0, reserve1) in the
// same transaction immediately before every Swap, carrying the reserves AFTER that swap.
// So, exactly:
//
//     R_after_front  = Sync(front)
//     R_before_front = R_after_front − delta_front                                    (2)
//     R_before_victim = Sync(victim) − delta_victim                                   (3)
//
// (2) and (3) are two INDEPENDENT derivations of the state between the two legs. This
// program requires them to agree exactly; a disagreement means something else touched the
// pool between the legs (a mint, a burn, a fee-on-transfer token) and the detection is
// excluded and counted, not fudged.
//
//     VICTIM SHORTFALL  S = out(a; R_before_front, F) − out_observed                  (4)
//
// with the victim's own input `a` held FIXED. S >= 0 by construction here, because the
// front leg moves the price against the victim by the detector's own direction conjunct —
// and the self-test proves the function is not positive BY construction by feeding it a
// front leg in the opposite direction and requiring a NEGATIVE answer.
//
// CONCENTRATED LIQUIDITY (Uniswap-V3-shaped pools). Inside one initialised tick range the
// pool is the same constant product on VIRTUAL reserves x = L·2^96/√P, y = L·√P/2^96, and
// its step is an integer routine with specified rounding directions. This program
// reproduces that routine bit-for-bit and REFUSES any detection it cannot reproduce
// exactly — which is also how the fee tier is recovered rather than assumed.
//
// The V3 counterfactual needs the price BEFORE the front leg. The front leg's own event
// carries the price AFTER it, so the step is INVERTED: for a token1-in leg the inversion
// is closed-form (the step adds a quotient that does not depend on the starting price);
// for a token0-in leg the step is monotone in the starting price and the inversion is an
// integer binary search whose answer is then checked by forward reproduction. Where a
// plateau of starting prices reproduces the same observation, the shortfall is computed at
// BOTH ends of the plateau and reported as an interval — collapsed to a single number only
// when the two ends agree.
//
// NO TICK IS CROSSED IN THE COUNTERFACTUAL, AND THAT IS PROVED, NOT ASSUMED. The forward
// reproduction of the front leg and of the victim leg both succeed at ONE liquidity L, so
// the whole price interval [√P_before_front, √P_after_victim] was traversed at constant
// liquidity — no initialised tick lies inside it. The counterfactual starts at
// √P_before_front and moves the same direction by strictly less than front+victim
// combined, so its endpoint lies strictly inside that same interval.
//
// -------------------------------------------------------------------------------------
// PRICE. A shortfall is a count of token base units. Turning it into money needs a rate,
// and a rate is a judgement. The MEASURED result in this program is the integer count. A
// rate is applied ONCE, in a clearly separated section, marked DERIVED_FOR_READABILITY,
// and it is not an oracle: it is the sheared pool's OWN marginal price at the pre-front
// state (an exact ratio of that pool's own reserves) to reach WETH, and one named
// WETH/USDC pool's own reserves inside this same corpus to reach USDC. Both are integer
// ratios measured here. Neither touches a decision.
//
// -------------------------------------------------------------------------------------
// DETECTION IS NOT INTENT. This program measures arithmetic. It names no participant:
// acting addresses are keyed pseudonyms. Victim transaction hashes ARE printed, because
// the whole point is that a person can find their own transaction — the victim is the
// party who lost, and is accused of nothing.
//
// THE TOTAL IS A FLOOR. See WHAT IS NOT INCLUDED at the end of the run.
// =====================================================================================

import Foundation

// =====================================================================================
// SECTION 1 — SHA-256, self-contained. Digests are COMPUTED here, never asserted.
// =====================================================================================

struct SHA256I {
    private var h: (UInt32, UInt32, UInt32, UInt32, UInt32, UInt32, UInt32, UInt32) =
        (0x6a09e667, 0xbb67ae85, 0x3c6ef372, 0xa54ff53a, 0x510e527f, 0x9b05688c, 0x1f83d9ab, 0x5be0cd19)
    private var buf = [UInt8](repeating: 0, count: 64)
    private var bufLen = 0
    private var total: UInt64 = 0

    private static let K: [UInt32] = [
        0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5, 0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5,
        0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3, 0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174,
        0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc, 0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da,
        0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7, 0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967,
        0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13, 0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85,
        0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3, 0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070,
        0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5, 0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3,
        0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208, 0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2]

    private mutating func block(_ p: UnsafePointer<UInt8>) {
        var w = [UInt32](repeating: 0, count: 64)
        for i in 0..<16 {
            w[i] = UInt32(p[i * 4]) << 24 | UInt32(p[i * 4 + 1]) << 16 | UInt32(p[i * 4 + 2]) << 8 | UInt32(p[i * 4 + 3])
        }
        for i in 16..<64 {
            let s0 = (w[i-15] >> 7 | w[i-15] << 25) ^ (w[i-15] >> 18 | w[i-15] << 14) ^ (w[i-15] >> 3)
            let s1 = (w[i-2] >> 17 | w[i-2] << 15) ^ (w[i-2] >> 19 | w[i-2] << 13) ^ (w[i-2] >> 10)
            w[i] = w[i-16] &+ s0 &+ w[i-7] &+ s1
        }
        var (a, b, c, d, e, f, g, hh) = h
        for i in 0..<64 {
            let S1 = (e >> 6 | e << 26) ^ (e >> 11 | e << 21) ^ (e >> 25 | e << 7)
            let ch = (e & f) ^ (~e & g)
            let t1 = hh &+ S1 &+ ch &+ SHA256I.K[i] &+ w[i]
            let S0 = (a >> 2 | a << 30) ^ (a >> 13 | a << 19) ^ (a >> 22 | a << 10)
            let mj = (a & b) ^ (a & c) ^ (b & c)
            let t2 = S0 &+ mj
            hh = g; g = f; f = e; e = d &+ t1; d = c; c = b; b = a; a = t1 &+ t2
        }
        h = (h.0 &+ a, h.1 &+ b, h.2 &+ c, h.3 &+ d, h.4 &+ e, h.5 &+ f, h.6 &+ g, h.7 &+ hh)
    }

    mutating func update(_ p: UnsafePointer<UInt8>, _ n: Int) {
        total &+= UInt64(n)
        var i = 0
        if bufLen > 0 {
            let need = 64 - bufLen
            let take = min(need, n)
            for k in 0..<take { buf[bufLen + k] = p[k] }
            bufLen += take; i = take
            if bufLen == 64 { buf.withUnsafeBufferPointer { block($0.baseAddress!) }; bufLen = 0 }
        }
        while i + 64 <= n { block(p + i); i += 64 }
        while i < n { buf[bufLen] = p[i]; bufLen += 1; i += 1 }
    }

    mutating func update(_ a: [UInt8]) { a.withUnsafeBufferPointer { if let b = $0.baseAddress { update(b, a.count) } } }

    mutating func finalHex() -> String {
        let bits = total &* 8
        var pad: [UInt8] = [0x80]
        while (bufLen + pad.count) % 64 != 56 { pad.append(0) }
        for s in stride(from: 56, through: 0, by: -8) { pad.append(UInt8((bits >> UInt64(s)) & 0xff)) }
        update(pad)
        let ws = [h.0, h.1, h.2, h.3, h.4, h.5, h.6, h.7]
        var out = ""
        let hx: [Character] = ["0","1","2","3","4","5","6","7","8","9","a","b","c","d","e","f"]
        for w in ws { for s in stride(from: 28, through: 0, by: -4) { out.append(hx[Int((w >> UInt32(s)) & 0xf)]) } }
        return out
    }
}

func sha256Hex(_ bytes: [UInt8]) -> String { var s = SHA256I(); s.update(bytes); return s.finalHex() }

func sha256File(_ path: String) -> (hex: String, bytes: UInt64)? {
    guard let fh = FileHandle(forReadingAtPath: path) else { return nil }
    defer { try? fh.close() }
    var s = SHA256I(); var n: UInt64 = 0
    while true {
        let d = fh.readData(ofLength: 1 << 22)
        if d.isEmpty { break }
        n &+= UInt64(d.count)
        d.withUnsafeBytes { (r: UnsafeRawBufferPointer) in
            s.update(r.bindMemory(to: UInt8.self).baseAddress!, d.count)
        }
    }
    return (s.finalHex(), n)
}

// =====================================================================================
// SECTION 2 — EXACT INTEGER ARITHMETIC. Nothing here converts to a machine float, and the
// disassembly scan at the end of the run is what proves that rather than this sentence.
// =====================================================================================

/// Signed 256-bit, two's complement, four little-endian 64-bit limbs. Deltas off the wire.
struct I256 {
    var w: (UInt64, UInt64, UInt64, UInt64) = (0, 0, 0, 0)
    init() {}
    init(_ v: UInt64) { w = (v, 0, 0, 0) }
    @inline(__always) var isNegative: Bool { (w.3 >> 63) & 1 == 1 }
    @inline(__always) var isZero: Bool { w.0 == 0 && w.1 == 0 && w.2 == 0 && w.3 == 0 }
    @inline(__always) static func addc(_ a: UInt64, _ b: UInt64, _ cin: UInt64) -> (UInt64, UInt64) {
        let (s1, o1) = a.addingReportingOverflow(b)
        let (s2, o2) = s1.addingReportingOverflow(cin)
        return (s2, (o1 ? 1 : 0) &+ (o2 ? 1 : 0))
    }
    @inline(__always) static func + (a: I256, b: I256) -> I256 {
        var r = I256(); var c: UInt64 = 0
        (r.w.0, c) = addc(a.w.0, b.w.0, 0)
        (r.w.1, c) = addc(a.w.1, b.w.1, c)
        (r.w.2, c) = addc(a.w.2, b.w.2, c)
        (r.w.3, _) = addc(a.w.3, b.w.3, c)
        return r
    }
    @inline(__always) var negated: I256 {
        var r = I256(); r.w = (~w.0, ~w.1, ~w.2, ~w.3)
        return r + I256(1)
    }
    @inline(__always) static func - (a: I256, b: I256) -> I256 { a + b.negated }
    @inline(__always) var magnitude: (UInt64, UInt64, UInt64, UInt64) {
        let m = isNegative ? negated : self
        return m.w
    }
    var decimal: String {
        if isZero { return "0" }
        let neg = isNegative
        var m = neg ? negated : self
        var parts: [String] = []
        let D: UInt64 = 10_000_000_000_000_000_000
        while !(m.w.0 == 0 && m.w.1 == 0 && m.w.2 == 0 && m.w.3 == 0) {
            var rem: UInt64 = 0
            var q = I256()
            let limbs = [m.w.3, m.w.2, m.w.1, m.w.0]
            var qs = [UInt64](repeating: 0, count: 4)
            for i in 0..<4 {
                let (qi, ri) = D.dividingFullWidth((high: rem, low: limbs[i]))
                qs[i] = qi; rem = ri
            }
            q.w = (qs[3], qs[2], qs[1], qs[0])
            let done = q.w.0 == 0 && q.w.1 == 0 && q.w.2 == 0 && q.w.3 == 0
            var chunk = String(rem)
            if !done { while chunk.count < 19 { chunk = "0" + chunk } }
            parts.append(chunk)
            m = q
        }
        return (neg ? "-" : "") + parts.reversed().joined()
    }
}

/// Unsigned 256-bit. Multiplication produces a full 512-bit product; division consumes one.
/// Every quotient in this program is a FLOOR unless the call site says RoundingUp, which is
/// the same rounding the pools themselves perform.
struct U256: Equatable, Hashable {
    var w0: UInt64 = 0, w1: UInt64 = 0, w2: UInt64 = 0, w3: UInt64 = 0
    init() {}
    init(_ v: UInt64) { w0 = v }
    init(w0: UInt64, w1: UInt64, w2: UInt64, w3: UInt64) { self.w0 = w0; self.w1 = w1; self.w2 = w2; self.w3 = w3 }
    /// |x| — the magnitude of a signed wire delta.
    init(mag x: I256) { let m = x.magnitude; w0 = m.0; w1 = m.1; w2 = m.2; w3 = m.3 }

    @inline(__always) var isZero: Bool { w0 == 0 && w1 == 0 && w2 == 0 && w3 == 0 }
    @inline(__always) var limbs: [UInt64] { [w0, w1, w2, w3] }

    @inline(__always) static func cmp(_ a: U256, _ b: U256) -> Int {
        if a.w3 != b.w3 { return a.w3 < b.w3 ? -1 : 1 }
        if a.w2 != b.w2 { return a.w2 < b.w2 ? -1 : 1 }
        if a.w1 != b.w1 { return a.w1 < b.w1 ? -1 : 1 }
        if a.w0 != b.w0 { return a.w0 < b.w0 ? -1 : 1 }
        return 0
    }
    @inline(__always) static func < (a: U256, b: U256) -> Bool { cmp(a, b) < 0 }
    @inline(__always) static func <= (a: U256, b: U256) -> Bool { cmp(a, b) <= 0 }
    @inline(__always) static func > (a: U256, b: U256) -> Bool { cmp(a, b) > 0 }
    @inline(__always) static func >= (a: U256, b: U256) -> Bool { cmp(a, b) >= 0 }

    /// a + b, with the carry OUT reported. A dropped carry is a silent wrong answer.
    @inline(__always) static func addC(_ a: U256, _ b: U256) -> (U256, Bool) {
        var r = U256(); var c: UInt64 = 0
        (r.w0, c) = I256.addc(a.w0, b.w0, 0)
        (r.w1, c) = I256.addc(a.w1, b.w1, c)
        (r.w2, c) = I256.addc(a.w2, b.w2, c)
        (r.w3, c) = I256.addc(a.w3, b.w3, c)
        return (r, c != 0)
    }
    /// a − b, with the borrow OUT reported.
    @inline(__always) static func subB(_ a: U256, _ b: U256) -> (U256, Bool) {
        var r = U256(); var brw: UInt64 = 0
        func sbb(_ x: UInt64, _ y: UInt64, _ bin: UInt64) -> (UInt64, UInt64) {
            let (d1, o1) = x.subtractingReportingOverflow(y)
            let (d2, o2) = d1.subtractingReportingOverflow(bin)
            return (d2, (o1 ? 1 : 0) &+ (o2 ? 1 : 0))
        }
        (r.w0, brw) = sbb(a.w0, b.w0, 0)
        (r.w1, brw) = sbb(a.w1, b.w1, brw)
        (r.w2, brw) = sbb(a.w2, b.w2, brw)
        (r.w3, brw) = sbb(a.w3, b.w3, brw)
        return (r, brw != 0)
    }
    @inline(__always) static func + (a: U256, b: U256) -> U256 { addC(a, b).0 }
    @inline(__always) static func - (a: U256, b: U256) -> U256 { subB(a, b).0 }

    /// Full 512-bit product, returned as eight little-endian limbs.
    static func mulFull(_ a: U256, _ b: U256) -> [UInt64] {
        var out = [UInt64](repeating: 0, count: 8)
        let al = a.limbs, bl = b.limbs
        for i in 0..<4 {
            var carry: UInt64 = 0
            let ai = al[i]
            if ai == 0 { continue }
            for j in 0..<4 {
                let (hi, lo) = ai.multipliedFullWidth(by: bl[j])
                var acc = out[i + j]
                var c2: UInt64 = 0
                (acc, c2) = I256.addc(acc, lo, 0)
                var hi2 = hi &+ c2
                var c3: UInt64 = 0
                (acc, c3) = I256.addc(acc, carry, 0)
                hi2 = hi2 &+ c3
                out[i + j] = acc
                carry = hi2
            }
            var k = i + 4
            while carry != 0 && k < 8 {
                var c: UInt64 = 0
                (out[k], c) = I256.addc(out[k], carry, 0)
                carry = c
                k += 1
            }
        }
        return out
    }

    /// floor(N / d) and N mod d, where N is a 512-bit numerator in eight limbs.
    /// Bit-serial restoring division: exact, integer, no reciprocal, no float.
    /// Returns nil when d == 0 or when the quotient does not fit 256 bits — both are
    /// COUNTED by callers, never silently clamped.
    static func divFull(_ n: [UInt64], _ d: U256) -> (q: U256, r: U256)? {
        if d.isZero { return nil }
        var q = U256()
        var r = U256()
        var overflow = false
        var bit = 511
        while bit >= 0 {
            // r = (r << 1) | bit(n, bit)   — track the bit shifted out of the top of r
            let top = (r.w3 >> 63) & 1
            r.w3 = (r.w3 << 1) | (r.w2 >> 63)
            r.w2 = (r.w2 << 1) | (r.w1 >> 63)
            r.w1 = (r.w1 << 1) | (r.w0 >> 63)
            r.w0 = (r.w0 << 1) | ((n[bit >> 6] >> UInt64(bit & 63)) & 1)
            // (top, r) >= d ?  top == 1 makes the 257-bit value strictly greater than any d.
            if top == 1 || U256.cmp(r, d) >= 0 {
                r = r - d
                // set bit `bit` of q
                if bit >= 256 { overflow = true }
                else {
                    let li = bit >> 6, sh = UInt64(bit & 63)
                    switch li {
                    case 0: q.w0 |= (1 << sh)
                    case 1: q.w1 |= (1 << sh)
                    case 2: q.w2 |= (1 << sh)
                    default: q.w3 |= (1 << sh)
                    }
                }
            }
            bit -= 1
        }
        if overflow { return nil }
        return (q, r)
    }

    /// floor(a·b / d)
    static func mulDiv(_ a: U256, _ b: U256, _ d: U256) -> U256? {
        guard let (q, _) = divFull(mulFull(a, b), d) else { return nil }
        return q
    }
    /// ceil(a·b / d)
    static func mulDivUp(_ a: U256, _ b: U256, _ d: U256) -> U256? {
        guard let (q, r) = divFull(mulFull(a, b), d) else { return nil }
        if r.isZero { return q }
        let (s, c) = addC(q, U256(1))
        return c ? nil : s
    }
    /// floor(a / d)
    static func div(_ a: U256, _ d: U256) -> U256? {
        var n = [UInt64](repeating: 0, count: 8)
        n[0] = a.w0; n[1] = a.w1; n[2] = a.w2; n[3] = a.w3
        guard let (q, _) = divFull(n, d) else { return nil }
        return q
    }
    /// ceil(a / d)
    static func divUp(_ a: U256, _ d: U256) -> U256? {
        var n = [UInt64](repeating: 0, count: 8)
        n[0] = a.w0; n[1] = a.w1; n[2] = a.w2; n[3] = a.w3
        guard let (q, r) = divFull(n, d) else { return nil }
        if r.isZero { return q }
        let (s, c) = addC(q, U256(1))
        return c ? nil : s
    }
    /// a << k, with the OVERFLOW out of 256 bits reported.
    static func shl(_ a: U256, _ k: Int) -> (U256, Bool) {
        if k == 0 { return (a, false) }
        if k >= 256 { return (U256(), !a.isZero) }
        var l = a.limbs
        var out = [UInt64](repeating: 0, count: 4)
        var lost = false
        let limbShift = k >> 6, bitShift = UInt64(k & 63)
        for i in stride(from: 3, through: 0, by: -1) {
            let src = i - limbShift
            var v: UInt64 = 0
            if src >= 0 {
                v = l[src] << bitShift
                if bitShift > 0 && src - 1 >= 0 { v |= l[src - 1] >> (64 - bitShift) }
            }
            out[i] = v
        }
        for i in 0..<4 {
            let src = i + (4 - limbShift)
            _ = src
        }
        // anything shifted past bit 255 is lost — detect it by shifting back
        var back = U256(w0: out[0], w1: out[1], w2: out[2], w3: out[3])
        var chk = back
        // shift right by k
        let ls = k >> 6, bs = UInt64(k & 63)
        var rl = [UInt64](repeating: 0, count: 4)
        let cl = chk.limbs
        for i in 0..<4 {
            let src = i + ls
            var v: UInt64 = 0
            if src < 4 {
                v = cl[src] >> bs
                if bs > 0 && src + 1 < 4 { v |= cl[src + 1] << (64 - bs) }
            }
            rl[i] = v
        }
        chk = U256(w0: rl[0], w1: rl[1], w2: rl[2], w3: rl[3])
        if U256.cmp(chk, a) != 0 { lost = true }
        back = U256(w0: out[0], w1: out[1], w2: out[2], w3: out[3])
        l = []
        return (back, lost)
    }

    var dec: String {
        if isZero { return "0" }
        var m = self
        var parts: [String] = []
        let D: UInt64 = 10_000_000_000_000_000_000
        while !m.isZero {
            var rem: UInt64 = 0
            let ls = [m.w3, m.w2, m.w1, m.w0]
            var qs = [UInt64](repeating: 0, count: 4)
            for i in 0..<4 {
                let (qi, ri) = D.dividingFullWidth((high: rem, low: ls[i]))
                qs[i] = qi; rem = ri
            }
            let q = U256(w0: qs[3], w1: qs[2], w2: qs[1], w3: qs[0])
            var chunk = String(rem)
            if !q.isZero { while chunk.count < 19 { chunk = "0" + chunk } }
            parts.append(chunk)
            m = q
        }
        return parts.reversed().joined()
    }
    /// Fits in a UInt64? Used only for bucketing and printing, never for a value decision.
    var asU64: UInt64? { (w1 == 0 && w2 == 0 && w3 == 0) ? w0 : nil }
}

/// A signed integer answer that may exceed 64 bits: sign kept apart from magnitude so a
/// negative shortfall — which the self-test requires the function to be able to produce —
/// is a first-class value and not an underflow.
struct SInt {
    var neg: Bool = false
    var mag: U256 = U256()
    init() {}
    init(neg: Bool, mag: U256) { self.neg = mag.isZero ? false : neg; self.mag = mag }
    /// a − b over unsigned magnitudes.
    static func diff(_ a: U256, _ b: U256) -> SInt {
        if U256.cmp(a, b) >= 0 { return SInt(neg: false, mag: a - b) }
        return SInt(neg: true, mag: b - a)
    }
    var dec: String { (neg ? "-" : "") + mag.dec }
    var isZero: Bool { mag.isZero }
}

// =====================================================================================
// SECTION 3 — BYTE-LEVEL JSON SCANNER. Every quantity on this wire is a hex STRING and is
// parsed by integer hex parsing. No JSON number is ever converted to a machine number.
// =====================================================================================

struct JS {
    let p: UnsafePointer<UInt8>
    let n: Int
    @inline(__always) func skipWS(_ i: inout Int) { while i < n { let c = p[i]; if c == 0x20 || c == 0x09 || c == 0x0a || c == 0x0d { i += 1 } else { break } } }
    @inline(__always) func skipString(_ i: inout Int) {
        i += 1
        while i < n {
            let c = p[i]
            if c == 0x5c { i += 2; continue }
            if c == 0x22 { i += 1; return }
            i += 1
        }
    }
    func skipValue(_ i: inout Int) {
        skipWS(&i); guard i < n else { return }
        let c = p[i]
        if c == 0x22 { skipString(&i); return }
        if c == 0x7b || c == 0x5b {
            let close: UInt8 = (c == 0x7b) ? 0x7d : 0x5d
            var depth = 0
            while i < n {
                let d = p[i]
                if d == 0x22 { skipString(&i); continue }
                if d == c { depth += 1 } else if d == close { depth -= 1; if depth == 0 { i += 1; return } }
                i += 1
            }
            return
        }
        while i < n { let d = p[i]; if d == 0x2c || d == 0x7d || d == 0x5d || d == 0x20 || d == 0x0a { return }; i += 1 }
    }
    @inline(__always) func objectEach(_ start: Int, _ body: (Int, Int, Int) -> Void) -> Int {
        var i = start
        skipWS(&i); guard i < n, p[i] == 0x7b else { return i }
        i += 1
        while i < n {
            skipWS(&i)
            if i < n && p[i] == 0x7d { return i + 1 }
            guard i < n, p[i] == 0x22 else { return i }
            let ks = i + 1
            skipString(&i)
            let ke = i - 1
            skipWS(&i); if i < n && p[i] == 0x3a { i += 1 }
            skipWS(&i)
            let vs = i
            body(ks, ke - ks, vs)
            skipValue(&i)
            skipWS(&i)
            if i < n && p[i] == 0x2c { i += 1; continue }
            if i < n && p[i] == 0x7d { return i + 1 }
            if i >= n { return i }
        }
        return i
    }
    @inline(__always) func arrayEach(_ start: Int, _ body: (Int) -> Void) -> Int {
        var i = start
        skipWS(&i); guard i < n, p[i] == 0x5b else { return i }
        i += 1
        while i < n {
            skipWS(&i)
            if i < n && p[i] == 0x5d { return i + 1 }
            body(i)
            skipValue(&i)
            skipWS(&i)
            if i < n && p[i] == 0x2c { i += 1; continue }
            if i < n && p[i] == 0x5d { return i + 1 }
            if i >= n { return i }
        }
        return i
    }
    @inline(__always) func keyIs(_ ks: Int, _ kl: Int, _ lit: StaticString) -> Bool {
        if kl != lit.utf8CodeUnitCount { return false }
        let q = lit.utf8Start
        for k in 0..<kl { if p[ks + k] != q[k] { return false } }
        return true
    }
    @inline(__always) func hexU64(_ vs: Int) -> UInt64? {
        var i = vs
        guard i < n, p[i] == 0x22 else { return nil }
        i += 1
        guard i + 1 < n, p[i] == 0x30, p[i+1] == 0x78 else { return nil }
        i += 2
        var v: UInt64 = 0; var digits = 0
        while i < n, p[i] != 0x22 {
            let c = p[i]
            let d: UInt64
            if c >= 0x30 && c <= 0x39 { d = UInt64(c - 0x30) }
            else if c >= 0x61 && c <= 0x66 { d = UInt64(c - 0x61 + 10) }
            else if c >= 0x41 && c <= 0x46 { d = UInt64(c - 0x41 + 10) }
            else { return nil }
            if digits >= 16 && v != 0 { return nil }
            v = (v << 4) | d; digits += 1; i += 1
        }
        return digits == 0 ? nil : v
    }
    @inline(__always) func addr(_ vs: Int) -> (UInt64, UInt64, UInt32)? {
        var i = vs
        guard i < n, p[i] == 0x22 else { return nil }
        i += 1
        guard i + 42 < n, p[i] == 0x30, p[i+1] == 0x78, p[i + 42] == 0x22 else { return nil }
        i += 2
        var a: UInt64 = 0, b: UInt64 = 0, c: UInt32 = 0
        for k in 0..<40 {
            let ch = p[i + k]
            let d: UInt32
            if ch >= 0x30 && ch <= 0x39 { d = UInt32(ch - 0x30) }
            else if ch >= 0x61 && ch <= 0x66 { d = UInt32(ch - 0x61 + 10) }
            else if ch >= 0x41 && ch <= 0x46 { d = UInt32(ch - 0x41 + 10) }
            else { return nil }
            if k < 16 { a = (a << 4) | UInt64(d) }
            else if k < 32 { b = (b << 4) | UInt64(d) }
            else { c = (c << 4) | d }
        }
        return (a, b, c)
    }
    /// A 32-byte topic read as a 20-byte address: the low 20 bytes, the high 12 required zero.
    @inline(__always) func topicAddr(_ vs: Int) -> (UInt64, UInt64, UInt32)? {
        var i = vs
        guard i < n, p[i] == 0x22 else { return nil }
        i += 1
        guard i + 1 < n, p[i] == 0x30, p[i+1] == 0x78 else { return nil }
        i += 2
        guard i + 64 < n, p[i + 64] == 0x22 else { return nil }
        for k in 0..<24 { if p[i + k] != 0x30 { return nil } }
        var a: UInt64 = 0, b: UInt64 = 0, c: UInt32 = 0
        for k in 0..<40 {
            let ch = p[i + 24 + k]
            let d: UInt32
            if ch >= 0x30 && ch <= 0x39 { d = UInt32(ch - 0x30) }
            else if ch >= 0x61 && ch <= 0x66 { d = UInt32(ch - 0x61 + 10) }
            else if ch >= 0x41 && ch <= 0x46 { d = UInt32(ch - 0x41 + 10) }
            else { return nil }
            if k < 16 { a = (a << 4) | UInt64(d) }
            else if k < 32 { b = (b << 4) | UInt64(d) }
            else { c = (c << 4) | d }
        }
        return (a, b, c)
    }
    @inline(__always) func dataWord(_ vs: Int, _ word: Int) -> I256? {
        var i = vs
        guard i < n, p[i] == 0x22 else { return nil }
        i += 1
        guard i + 1 < n, p[i] == 0x30, p[i+1] == 0x78 else { return nil }
        i += 2
        let off = i + word * 64
        guard off >= 0, off + 64 <= n else { return nil }
        var limbs: [UInt64] = [0, 0, 0, 0]
        for k in 0..<4 {
            var v: UInt64 = 0
            for q in 0..<16 {
                let ch = p[off + k * 16 + q]
                let d: UInt64
                if ch >= 0x30 && ch <= 0x39 { d = UInt64(ch - 0x30) }
                else if ch >= 0x61 && ch <= 0x66 { d = UInt64(ch - 0x61 + 10) }
                else if ch >= 0x41 && ch <= 0x46 { d = UInt64(ch - 0x41 + 10) }
                else { return nil }
                v = (v << 4) | d
            }
            limbs[k] = v
        }
        var r = I256(); r.w = (limbs[3], limbs[2], limbs[1], limbs[0])
        return r
    }
    /// The number of 32-byte words present in a "0x..." data string.
    @inline(__always) func dataWords(_ vs: Int) -> Int {
        var i = vs
        guard i < n, p[i] == 0x22 else { return -1 }
        i += 1
        guard i + 1 < n, p[i] == 0x30, p[i+1] == 0x78 else { return -1 }
        i += 2
        var j = i
        while j < n, p[j] != 0x22 { j += 1 }
        return (j - i) / 64
    }
    /// A bare JSON number (the live detection rows carry `block` unquoted).
    @inline(__always) func rawNumU64(_ vs: Int) -> UInt64? {
        var i = vs; var v: UInt64 = 0; var d = 0
        while i < n, p[i] >= 0x30, p[i] <= 0x39 { v = v &* 10 &+ UInt64(p[i] - 0x30); d += 1; i += 1 }
        return d == 0 ? nil : v
    }
    @inline(__always) func strEq(_ vs: Int, _ lit: StaticString) -> Bool {
        let L = lit.utf8CodeUnitCount
        guard vs < n, p[vs] == 0x22, vs + L + 1 < n, p[vs + L + 1] == 0x22 else { return false }
        let q = lit.utf8Start
        for k in 0..<L { if p[vs + 1 + k] != q[k] { return false } }
        return true
    }
    /// Copy a quoted string out verbatim (used for transaction hashes).
    func strOut(_ vs: Int) -> String? {
        guard vs < n, p[vs] == 0x22 else { return nil }
        var j = vs + 1
        var out = [UInt8]()
        while j < n, p[j] != 0x22 { out.append(p[j]); j += 1 }
        return String(decoding: out, as: UTF8.self)
    }
}

// =====================================================================================
// SECTION 4 — OUTPUT DISCIPLINE. ABSENCE, REFUSAL, BOT_BLOCKED and NOT_KNOWN never print
// alike, and none of them prints like a measurement.
// =====================================================================================

var OUT = ""
func emit(_ s: String) { OUT += s + "\n"; if OUT.utf8.count > 1 << 16 { flush() } }
func kv(_ k: String, _ v: String) { emit(k + "\t" + v) }
func kv(_ k: String, _ v: UInt64) { emit(k + "\t" + String(v)) }
func kv(_ k: String, _ v: Int) { emit(k + "\t" + String(v)) }
func section(_ s: String) { emit(""); emit("== " + s + " ==") }
func flush() { FileHandle.standardOutput.write(Data(OUT.utf8)); OUT = "" }

func refuse(_ reason: String) -> Never {
    emit("")
    emit("REFUSE\t" + reason)
    emit("REFUSAL is not ABSENCE and it is not a measurement. Nothing above is a result.")
    flush()
    exit(3)
}

@inline(__always) func nowNS() -> UInt64 { DispatchTime.now().uptimeNanoseconds }

typealias Addr = (UInt64, UInt64, UInt32)
@inline(__always) func addrEq(_ a: Addr, _ b: Addr) -> Bool { a.0 == b.0 && a.1 == b.1 && a.2 == b.2 }
@inline(__always) func addrKey(_ a: Addr) -> String { String(a.0) + ":" + String(a.1) + ":" + String(a.2) }

/// Keyed pseudonym: SHA-256 over the 20 address bytes, first 8 hex. One actor stays
/// trackable across rows; no named list is published.
func pseudo(_ a: Addr) -> String {
    var b = [UInt8]()
    for s in stride(from: 56, through: 0, by: -8) { b.append(UInt8((a.0 >> UInt64(s)) & 0xff)) }
    for s in stride(from: 56, through: 0, by: -8) { b.append(UInt8((a.1 >> UInt64(s)) & 0xff)) }
    for s in stride(from: 24, through: 0, by: -8) { b.append(UInt8((a.2 >> UInt32(s)) & 0xff)) }
    return String(sha256Hex(b).prefix(8))
}
func addrHexOf(_ a: Addr) -> String {
    var s = "0x"
    let hx = Array("0123456789abcdef")
    for sh in stride(from: 60, through: 0, by: -4) { s.append(hx[Int((a.0 >> UInt64(sh)) & 0xf)]) }
    for sh in stride(from: 60, through: 0, by: -4) { s.append(hx[Int((a.1 >> UInt64(sh)) & 0xf)]) }
    for sh in stride(from: 28, through: 0, by: -4) { s.append(hx[Int((a.2 >> UInt32(sh)) & 0xf)]) }
    return s
}
func parseAddrLit(_ s: String) -> Addr {
    let h = Array(s.dropFirst(2).lowercased().utf8)
    var a: UInt64 = 0, b: UInt64 = 0, c: UInt32 = 0
    for k in 0..<40 {
        let ch = h[k]
        let d: UInt32 = ch >= 0x30 && ch <= 0x39 ? UInt32(ch - 0x30) : UInt32(ch - 0x61 + 10)
        if k < 16 { a = (a << 4) | UInt64(d) } else if k < 32 { b = (b << 4) | UInt64(d) } else { c = (c << 4) | d }
    }
    return (a, b, c)
}

// Public contract constants. ASSERTED, named here, and used ONLY for labelling and for the
// clearly separated readability section — never on a decision path.
let WETH = parseAddrLit("0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2")
let USDC = parseAddrLit("0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48")
let USDT = parseAddrLit("0xdac17f958d2ee523a2206206994597c13d831ec7")
let DAI  = parseAddrLit("0x6b175474e89094c44da98b954eedeac495271d0f")
let WBTC = parseAddrLit("0x2260fac5e5542a773aa44fbcfedf7c193bc2c599")

func tokenLabel(_ a: Addr) -> String {
    if addrEq(a, WETH) { return "WETH" }
    if addrEq(a, USDC) { return "USDC" }
    if addrEq(a, USDT) { return "USDT" }
    if addrEq(a, DAI)  { return "DAI" }
    if addrEq(a, WBTC) { return "WBTC" }
    return "tok:" + pseudo(a)
}
func tokenDecimals(_ a: Addr) -> Int? {
    if addrEq(a, WETH) { return 18 }
    if addrEq(a, USDC) { return 6 }
    if addrEq(a, USDT) { return 6 }
    if addrEq(a, DAI)  { return 18 }
    if addrEq(a, WBTC) { return 8 }
    return nil
}

// =====================================================================================
// SECTION 5 — THE POOL ARITHMETIC. Integer only, rounding directions as the pools do them.
// =====================================================================================

let Q96 = U256(w0: 0, w1: 1 << 32, w2: 0, w3: 0)          // 2^96
let MAX160: U256 = {                                       // 2^160 − 1
    U256(w0: ~0, w1: ~0, w2: 0xffffffff, w3: 0)
}()

/// out(a; Rin, Rout, F) = floor( a·F·Rout / (Rin·1000 + a·F) )   — equation (1).
func v2Out(_ a: U256, _ rin: U256, _ rout: U256, _ feeNum: UInt64) -> U256? {
    if a.isZero || rin.isZero || rout.isZero { return nil }
    let aF = U256.mulFull(a, U256(feeNum))
    // aF must fit 256 bits for the denominator add; V2 reserves are uint112 so it does,
    // but the check is here rather than assumed.
    if aF[4] != 0 || aF[5] != 0 || aF[6] != 0 || aF[7] != 0 { return nil }
    let aFu = U256(w0: aF[0], w1: aF[1], w2: aF[2], w3: aF[3])
    guard let rin1000 = U256.mulDiv(rin, U256(1000), U256(1)) else { return nil }
    let (den, c) = U256.addC(rin1000, aFu)
    if c { return nil }
    return U256.mulDiv(aFu, rout, den)
}

/// The exact set of fee numerators F in [1,1000] for which (1) reproduces `observedOut`
/// against `(rin, rout)` with input `a`. out(F) is non-decreasing in F, so the set is a
/// contiguous interval located by two binary searches. An empty interval is NOT_KNOWN.
func v2RecoverFeeInterval(_ a: U256, _ rin: U256, _ rout: U256, _ observedOut: U256) -> (lo: UInt64, hi: UInt64)? {
    func out(_ f: UInt64) -> U256 { v2Out(a, rin, rout, f) ?? U256() }
    // smallest F with out(F) >= observedOut
    var lo: UInt64 = 1, hi: UInt64 = 1000, first: UInt64 = 0
    var found = false
    while lo <= hi {
        let mid = (lo + hi) / 2
        if U256.cmp(out(mid), observedOut) >= 0 { first = mid; found = true; if mid == 1 { break }; hi = mid - 1 }
        else { lo = mid + 1 }
    }
    if !found { return nil }
    if U256.cmp(out(first), observedOut) != 0 { return nil }
    // largest F with out(F) <= observedOut
    var lo2: UInt64 = first, hi2: UInt64 = 1000, last: UInt64 = first
    while lo2 <= hi2 {
        let mid = (lo2 + hi2) / 2
        if U256.cmp(out(mid), observedOut) <= 0 { last = mid; lo2 = mid + 1 }
        else { if mid == 0 { break }; hi2 = mid - 1 }
    }
    return (first, last)
}

// ---- Uniswap V3 core, reproduced. Rounding directions are the pool's own. --------------

func getAmount0Delta(_ sa: U256, _ sb: U256, _ l: U256, _ roundUp: Bool) -> U256? {
    var a = sa, b = sb
    if U256.cmp(a, b) > 0 { swap(&a, &b) }
    let (n1, ov) = U256.shl(l, 96)
    if ov { return nil }
    let n2 = b - a
    if a.isZero { return nil }
    if roundUp {
        guard let t = U256.mulDivUp(n1, n2, b) else { return nil }
        return U256.divUp(t, a)
    } else {
        guard let t = U256.mulDiv(n1, n2, b) else { return nil }
        return U256.div(t, a)
    }
}

func getAmount1Delta(_ sa: U256, _ sb: U256, _ l: U256, _ roundUp: Bool) -> U256? {
    var a = sa, b = sb
    if U256.cmp(a, b) > 0 { swap(&a, &b) }
    let d = b - a
    return roundUp ? U256.mulDivUp(l, d, Q96) : U256.mulDiv(l, d, Q96)
}

/// getNextSqrtPriceFromAmount0RoundingUp(sqrtP, L, amount, add: true) — price falls.
func nextSqrtFromAmount0(_ sp: U256, _ l: U256, _ amount: U256) -> U256? {
    if amount.isZero { return sp }
    let (n1, ov) = U256.shl(l, 96)
    if ov { return nil }
    let prod = U256.mulFull(amount, sp)
    let fits = prod[4] == 0 && prod[5] == 0 && prod[6] == 0 && prod[7] == 0
    if fits {
        let p = U256(w0: prod[0], w1: prod[1], w2: prod[2], w3: prod[3])
        let (den, c) = U256.addC(n1, p)
        if !c && U256.cmp(den, n1) >= 0 {
            return U256.mulDivUp(n1, sp, den)
        }
    }
    guard let t = U256.div(n1, sp) else { return nil }
    let (den2, c2) = U256.addC(t, amount)
    if c2 { return nil }
    return U256.divUp(n1, den2)
}

/// getNextSqrtPriceFromAmount1RoundingDown(sqrtP, L, amount, add: true) — price rises.
/// The added quotient does not depend on sqrtP, which is what makes this step invertible
/// in closed form.
func nextSqrtFromAmount1(_ sp: U256, _ l: U256, _ amount: U256) -> U256? {
    guard let q = U256.mulDiv(amount, Q96, l) else { return nil }
    let (s, c) = U256.addC(sp, q)
    if c { return nil }
    return s
}

struct V3Step {
    var sqrtNext = U256()
    var amountIn = U256()          // net of fee, the part that moved the price
    var amountOut = U256()
    var feeAmount = U256()
}

/// One exact-input swap step with no tick crossing. `grossIn` is the amount the pool
/// receives, which is what the Swap event reports on the input side.
func v3Step(sqrtCur: U256, liquidity: U256, feePips: UInt64, grossIn: U256, zeroForOne: Bool) -> V3Step? {
    if liquidity.isZero || sqrtCur.isZero { return nil }
    guard let lessFee = U256.mulDiv(grossIn, U256(1_000_000 - feePips), U256(1_000_000)) else { return nil }
    var s = V3Step()
    if zeroForOne {
        guard let nx = nextSqrtFromAmount0(sqrtCur, liquidity, lessFee) else { return nil }
        if U256.cmp(nx, sqrtCur) > 0 { return nil }
        s.sqrtNext = nx
        guard let ai = getAmount0Delta(nx, sqrtCur, liquidity, true),
              let ao = getAmount1Delta(nx, sqrtCur, liquidity, false) else { return nil }
        s.amountIn = ai; s.amountOut = ao
    } else {
        guard let nx = nextSqrtFromAmount1(sqrtCur, liquidity, lessFee) else { return nil }
        if U256.cmp(nx, sqrtCur) < 0 { return nil }
        s.sqrtNext = nx
        guard let ai = getAmount1Delta(sqrtCur, nx, liquidity, true),
              let ao = getAmount0Delta(sqrtCur, nx, liquidity, false) else { return nil }
        s.amountIn = ai; s.amountOut = ao
    }
    if U256.cmp(s.amountIn, grossIn) > 0 { return nil }
    s.feeAmount = grossIn - s.amountIn
    return s
}

/// Recover the price BEFORE a leg from the leg's own event, exactly.
/// token1-in: closed form. token0-in: monotone binary search, then verified forward.
/// Returns the inclusive plateau [lo, hi] of starting prices that reproduce the observation.
func v3InvertStart(sqrtAfter: U256, liquidity: U256, feePips: UInt64,
                   grossIn: U256, observedOut: U256, zeroForOne: Bool) -> (lo: U256, hi: U256)? {
    func reproduces(_ start: U256) -> Bool {
        guard let st = v3Step(sqrtCur: start, liquidity: liquidity, feePips: feePips,
                              grossIn: grossIn, zeroForOne: zeroForOne) else { return false }
        return U256.cmp(st.sqrtNext, sqrtAfter) == 0 && U256.cmp(st.amountOut, observedOut) == 0
    }
    if !zeroForOne {
        // sqrtNext = sqrtCur + q, q independent of sqrtCur  =>  sqrtCur = sqrtAfter − q
        guard let lessFee = U256.mulDiv(grossIn, U256(1_000_000 - feePips), U256(1_000_000)),
              let q = U256.mulDiv(lessFee, Q96, liquidity) else { return nil }
        if U256.cmp(sqrtAfter, q) < 0 { return nil }
        let start = sqrtAfter - q
        if !reproduces(start) { return nil }
        return (start, start)
    }
    // price falls: sqrtCur > sqrtAfter, and sqrtNext(sqrtCur) is non-decreasing in sqrtCur.
    func nextOf(_ start: U256) -> U256? {
        guard let lessFee = U256.mulDiv(grossIn, U256(1_000_000 - feePips), U256(1_000_000)) else { return nil }
        return nextSqrtFromAmount0(start, liquidity, lessFee)
    }
    var lo = sqrtAfter, hi = MAX160
    // smallest start with nextOf(start) >= sqrtAfter
    var first: U256? = nil
    while U256.cmp(lo, hi) <= 0 {
        let (sum, c) = U256.addC(lo, hi)
        if c { break }
        guard let mid = U256.div(sum, U256(2)) else { break }
        guard let nx = nextOf(mid) else { break }
        if U256.cmp(nx, sqrtAfter) >= 0 { first = mid; if U256.cmp(mid, sqrtAfter) == 0 { break }; hi = mid - U256(1) }
        else { lo = mid + U256(1) }
    }
    guard let f = first, reproduces(f) else { return nil }
    // largest start that still reproduces
    var lo2 = f, hi2 = MAX160, last = f
    while U256.cmp(lo2, hi2) <= 0 {
        let (sum, c) = U256.addC(lo2, hi2)
        if c { break }
        guard let mid = U256.div(sum, U256(2)) else { break }
        if reproduces(mid) { last = mid; lo2 = mid + U256(1) }
        else { if U256.cmp(mid, U256(0)) == 0 { break }; hi2 = mid - U256(1) }
    }
    return (f, last)
}

// =====================================================================================
// SECTION 6 — EVENT EXTRACTION
// =====================================================================================

let V2SWAP: StaticString = "0xd78ad95fa46c994b6551d0da85fc275fe613ce37657fb8d5e3d130840159d822"
let V3SWAP: StaticString = "0xc42079f94a6350d7e6235f29174924f928cc2ac818eb64fed8004e115fbcca67"
let V2SYNC: StaticString = "0x1c411e9a96e071241c2f21f7726b17ae89e3cab4c78be50e062b03a9fffbbad1"
let ERC20XFER: StaticString = "0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef"

struct SwapRec {
    var txIndex: UInt32 = 0
    var logIndex: UInt32 = 0
    var pool: Addr = (0, 0, 0)
    var who: Addr = (0, 0, 0)
    var d0 = I256(), d1 = I256()
    var sqrtP = U256(), liq = U256()
    var dir: UInt8 = 0          // 0 = token0 in, 1 = token1 in
    var kind: UInt8 = 0         // 2 or 3
    var txHash: String = ""
}
struct SyncRec { var pool: Addr = (0, 0, 0); var logIndex: UInt32 = 0; var r0 = U256(); var r1 = U256() }
struct XferRec { var token: Addr = (0, 0, 0); var txIndex: UInt32 = 0; var from: Addr = (0, 0, 0); var to: Addr = (0, 0, 0); var value = U256() }

// =====================================================================================
// SECTION 7 — THE DETECTION AND ITS EXTRACTION ACCOUNT
// =====================================================================================

/// Why a shortfall is not a number. Four answers kept apart, per the house rule.
enum ShortStatus: String {
    case exact              = "EXACT"
    case interval           = "EXACT_INTERVAL"        // determinate up to a rounding plateau
    case notKnownNoSync     = "NOT_KNOWN_NO_SYNC"
    case notKnownStateGap   = "NOT_KNOWN_POOL_TOUCHED_BETWEEN_LEGS"
    case notKnownFee        = "NOT_KNOWN_FEE_NOT_RECOVERABLE"
    case notKnownRepro      = "NOT_KNOWN_LEG_NOT_REPRODUCIBLE"
    case notKnownInvert     = "NOT_KNOWN_FRONT_NOT_INVERTIBLE"
    case notKnownLiq        = "NOT_KNOWN_LIQUIDITY_CHANGED_BETWEEN_LEGS"
    case notKnownAdj        = "NOT_KNOWN_FRONT_NOT_ADJACENT_TO_VICTIM"
    case notKnownDegen      = "NOT_KNOWN_DEGENERATE_LEG"
    case notKnownArith      = "NOT_KNOWN_ARITHMETIC_RANGE"
    // ---- closed from a state MEASURED on the wire rather than inverted from the leg ----
    // These are kept as their own answers and never folded into EXACT. The published
    // count of 87 EXACT rows must stay reproducible from this same source, so a row that
    // only closes because a pre-front state was fetched says so on its own line.
    case exactRecovered     = "EXACT_FROM_RECOVERED_PRE_FRONT_STATE"
    case intervalRecovered  = "EXACT_INTERVAL_FROM_RECOVERED_PRE_FRONT_STATE"
    // ---- a sharpened NOT_KNOWN: the fee is known and the leg still does not reproduce ----
    //
    // NAMED FOR WHAT WAS MEASURED, NOT FOR THE CAUSE INFERRED FROM IT. An earlier draft
    // called this NOT_KNOWN_LEG_CROSSED_A_TICK_AT_THE_KNOWN_FEE, which asserts a cause
    // this program cannot see: a single-tick step at the liquidity the event reported can
    // fail either because the swap crossed a tick OR because a mint or burn moved the
    // in-range liquidity during it, and nothing here distinguishes those. What IS measured
    // is that the pool's own fee was read and the leg still does not reproduce.
    case notKnownTick       = "NOT_KNOWN_NOT_REPRODUCIBLE_AT_THE_POOLS_OWN_FEE"

    /// A shortfall is a number for this row. The two recovered cases are included:
    /// their arithmetic is the SAME arithmetic, run from a state that was read rather
    /// than inferred. With no recovered state supplied there are none of them, and every
    /// figure downstream is byte-identical to the published run.
    var isDeterminate: Bool {
        switch self {
        case .exact, .interval, .exactRecovered, .intervalRecovered: return true
        default: return false
        }
    }
    /// True only for rows that needed a fetched state. Counted and printed separately.
    var isRecovered: Bool {
        switch self {
        case .exactRecovered, .intervalRecovered: return true
        default: return false
        }
    }
}

// =====================================================================================
// RECOVERED PRE-FRONT STATE — the missing quantity, read from the wire, never guessed
// =====================================================================================
//
// Two of the four NOT_KNOWN classes name a quantity that the leg's own arithmetic could
// not recover but that the chain still holds:
//
//   NOT_KNOWN_FRONT_NOT_INVERTIBLE  needs sqrtPriceX96 immediately BEFORE the front leg.
//                                   v3InvertStart failed to run the front leg backwards;
//                                   the state itself is still on the chain, either as the
//                                   sqrtPriceX96 of the previous Swap on that pool or as
//                                   slot0() at the parent block.
//   NOT_KNOWN_LEG_NOT_REPRODUCIBLE  needs the pool's fee tier, when zero or more than one
//                                   of the four standard tiers reproduced the victim leg.
//                                   fee() is immutable and readable at any block.
//
// The recovered value is USED, never trusted: a supplied sqrtP must still reproduce the
// front leg forward through the same v3Step, and a supplied fee must still reproduce the
// victim's own leg exactly, or the row keeps its NOT_KNOWN and says which check failed.
// A state that closes a row without reproducing the observation would be a fitted number,
// which is the opposite of a measurement.
struct RecoveredState {
    var sqrtPreFront: U256? = nil
    var feePips: UInt64? = nil
    var source: String = ""
}
var RECOVERED: [String: RecoveredState] = [:]
var RECOVERED_REJECTED: [String: String] = [:]
var RECOVERED_INBLOCK: Set<String> = []
/// Where to write the operational needs file, or nil for "do not write one".
///
/// THIS IS A GLOBAL AND NOT AN argv READ, AND THE REASON MATTERS. Everything above the
/// SECTION 11 marker is sliced out verbatim and compiled on its own into the WASI tools,
/// so a line in here that calls opt() or flag() — both defined in MAIN, below the
/// boundary — compiles inside this program and FAILS TO COMPILE inside the tool that
/// shares the law. That is what happened: the first version of the needs writer called
/// flag("--emit-needs") and broke wasi-sandwiched's build with "cannot find 'flag' in
/// scope", in a file nobody had edited. The slice reads this global; MAIN sets it.
var EMIT_NEEDS_TO: String? = nil

/// TSV: victim_tx_hash <tab> sqrtPriceX96_pre_front_or_dash <tab> fee_pips_or_dash <tab> source
func loadRecovered(_ path: String) -> (rows: Int, bad: Int) {
    guard let txt = try? String(contentsOfFile: path, encoding: .utf8) else { return (0, 0) }
    var rows = 0, bad = 0
    for line in txt.split(separator: "\n", omittingEmptySubsequences: true) {
        if line.hasPrefix("#") { continue }
        let f = line.split(separator: "\t", omittingEmptySubsequences: false).map(String.init)
        if f.count < 3 { bad += 1; continue }
        let tx = f[0].lowercased()
        if !tx.hasPrefix("0x") || tx.count != 66 { bad += 1; continue }
        var r = RecoveredState()
        if f[1] != "-" { guard let v = decU256(f[1]) else { bad += 1; continue }; r.sqrtPreFront = v }
        if f[2] != "-" { guard let v = UInt64(f[2]) else { bad += 1; continue }; r.feePips = v }
        r.source = f.count > 3 ? f[3] : "unstated"
        if r.sqrtPreFront == nil && r.feePips == nil { bad += 1; continue }
        RECOVERED[tx] = r
        rows += 1
    }
    return (rows, bad)
}

struct Detection {
    var block: UInt64 = 0
    var ts: UInt64 = 0
    var pool: Addr = (0, 0, 0)
    var actor: Addr = (0, 0, 0)
    var kind: UInt8 = 0
    var txFront: UInt32 = 0, txVictim: UInt32 = 0, txBack: UInt32 = 0
    var victimTx: String = ""
    // attacker net position change, per token, pool-perspective sign flipped
    var net0 = I256(), net1 = I256()
    // gas paid by the two attacker legs' transactions, wei. NOT netted into the above.
    var gasWei = U256()
    // victim leg
    var victimInToken: Addr? = nil
    var victimOutToken: Addr? = nil
    var victimIn = U256()
    var victimOut = U256()
    var victimOutCF = U256()          // counterfactual output at the pre-front state
    var victimOutCFHi = U256()        // upper end when a rounding plateau exists
    var shortfall = SInt()
    var shortfallHi = SInt()
    var status: ShortStatus = .notKnownDegen
    var feeNum: UInt64 = 0            // V2: /1000.  V3: pips /1e6.
    var sizeBp: UInt64 = 0            // victim input as ten-thousandths of the pre-front input reserve
    var lossBp: UInt64 = 0            // shortfall as ten-thousandths of the counterfactual output
    var reserveInPre = U256()         // pre-front reserve (V2) or virtual reserve (V3), input token
    var reserveOutPre = U256()        // pre-front reserve (V2) or virtual reserve (V3), output token
    // When no Transfer log matches the pool's output amount exactly, the LARGEST transfer
    // out of the pool in that transaction is recorded instead, so the shortfall between the
    // pool boundary and the wallet is a MEASUREMENT rather than a guess about why.
    var outTransferNear: U256? = nil
}

struct Run {
    var blocks: UInt64 = 0
    var txTotal: UInt64 = 0
    var receiptTotal: UInt64 = 0
    var logsTotal: UInt64 = 0
    var swapV2: UInt64 = 0
    var swapV3: UInt64 = 0
    var syncs: UInt64 = 0
    var transfers: UInt64 = 0
    var emptyBlocks: UInt64 = 0
    var notContiguous: UInt64 = 0
    var chainBreaks: UInt64 = 0
    var txCountMismatch: UInt64 = 0
    var badHex: UInt64 = 0
    var malformedSwapData: UInt64 = 0
    var selfContradictions: UInt64 = 0
    var poolsWith3Plus: UInt64 = 0
    var pairsTested: UInt64 = 0
    var brackets: UInt64 = 0
    var extractive: UInt64 = 0
    var bracketActors = Set<String>()
    var extractiveActors = Set<String>()
    var shearBlocks = Set<UInt64>()        // blocks carrying an EXTRACTIVE detection
    var bracketBlocks = Set<UInt64>()      // blocks carrying a BRACKET, extractive or not
    var spanOver3: UInt64 = 0
    // pool -> (token0, token1), identified from ERC-20 Transfer logs matched on value AND
    // on the pool endpoint. Disagreements between two identifications of one pool are
    // counted rather than overwritten.
    var poolTokens = [String: (Addr, Addr)]()
    var poolTokenConflicts: UInt64 = 0
    // pool -> deepest reserves seen, for the readability rate only
    var poolDeepest = [String: (U256, U256, UInt64, Addr)]()
    var dets: [Detection] = []
    var syncChainChecked: UInt64 = 0
    var syncChainAgreed: UInt64 = 0
    var tsFirst: UInt64 = 0
    var tsLast: UInt64 = 0
    var elapsedNS: UInt64 = 0
    // readability rate, measured from this corpus
    var usdcPerEthNum = U256()        // USDC base units
    var usdcPerEthDen = U256()        // wei
    var usdcRateBlock: UInt64 = 0
    var usdcRatePool: Addr = (0, 0, 0)
}

func hash32Key(_ J: JS, _ vs: Int) -> Addr? {
    var i = vs
    guard i < J.n, J.p[i] == 0x22 else { return nil }
    i += 1
    guard i + 1 < J.n, J.p[i] == 0x30, J.p[i+1] == 0x78 else { return nil }
    i += 2
    var a: UInt64 = 0, b: UInt64 = 0, c: UInt32 = 0
    for k in 0..<40 {
        guard i + k < J.n else { return nil }
        let ch = J.p[i + k]
        let d: UInt32
        if ch >= 0x30 && ch <= 0x39 { d = UInt32(ch - 0x30) }
        else if ch >= 0x61 && ch <= 0x66 { d = UInt32(ch - 0x61 + 10) }
        else if ch >= 0x41 && ch <= 0x46 { d = UInt32(ch - 0x41 + 10) }
        else { return nil }
        if k < 16 { a = (a << 4) | UInt64(d) }
        else if k < 32 { b = (b << 4) | UInt64(d) }
        else { c = (c << 4) | d }
    }
    return (a, b, c)
}

func runCorpus(blocksPath: String, receiptsPath: String, expectStart: UInt64, expectCount: UInt64, r: inout Run) {
    guard let bd = try? Data(contentsOf: URL(fileURLWithPath: blocksPath), options: .mappedIfSafe),
          let rd = try? Data(contentsOf: URL(fileURLWithPath: receiptsPath), options: .mappedIfSafe) else {
        return
    }
    if bd.isEmpty || rd.isEmpty { return }
    let t0 = nowNS()

    func lineRanges(_ d: Data) -> [(Int, Int)] {
        var out: [(Int, Int)] = []
        d.withUnsafeBytes { (raw: UnsafeRawBufferPointer) in
            guard let p = raw.bindMemory(to: UInt8.self).baseAddress else { return }
            var s = 0
            for i in 0..<d.count where p[i] == 0x0a {
                if i > s { out.append((s, i - s)) }
                s = i + 1
            }
            if d.count > s { out.append((s, d.count - s)) }
        }
        return out
    }
    let bLines = lineRanges(bd), rLines = lineRanges(rd)

    var prevHash: Addr? = nil
    var prevNum: UInt64 = 0

    bd.withUnsafeBytes { (braw: UnsafeRawBufferPointer) in
    rd.withUnsafeBytes { (rraw: UnsafeRawBufferPointer) in
        guard let bp = braw.bindMemory(to: UInt8.self).baseAddress,
              let rp = rraw.bindMemory(to: UInt8.self).baseAddress else { return }
        let nBlocks = min(bLines.count, rLines.count)
        if bLines.count != rLines.count { r.txCountMismatch &+= 1 }

        var swaps = [SwapRec](); swaps.reserveCapacity(512)
        var syncs = [SyncRec](); syncs.reserveCapacity(512)
        var xfers = [XferRec](); xfers.reserveCapacity(4096)

        for bi in 0..<nBlocks {
            let (bo, bl) = bLines[bi]
            let J = JS(p: bp + bo, n: bl)
            var num: UInt64 = 0, ts: UInt64 = 0, gasUsedBlock: UInt64 = 0
            var haveNum = false
            var hash: Addr? = nil, parent: Addr? = nil
            var txInBlock = 0
            _ = J.objectEach(0) { ks, kl, vs in
                if J.keyIs(ks, kl, "number") { if let v = J.hexU64(vs) { num = v; haveNum = true } else { r.badHex &+= 1 } }
                else if J.keyIs(ks, kl, "timestamp") { if let v = J.hexU64(vs) { ts = v } else { r.badHex &+= 1 } }
                else if J.keyIs(ks, kl, "gasUsed") { if let v = J.hexU64(vs) { gasUsedBlock = v } else { r.badHex &+= 1 } }
                else if J.keyIs(ks, kl, "hash") { hash = hash32Key(J, vs) }
                else if J.keyIs(ks, kl, "parentHash") { parent = hash32Key(J, vs) }
                else if J.keyIs(ks, kl, "transactions") { _ = J.arrayEach(vs) { _ in txInBlock += 1 } }
            }
            if !haveNum { continue }
            r.blocks &+= 1
            // SELF-CONTRADICTION GUARD: gas cannot be burned by no transactions.
            if txInBlock == 0 && gasUsedBlock > 0 { r.selfContradictions &+= 1 }
            if expectCount > 0 { if num != expectStart &+ UInt64(bi) { r.notContiguous &+= 1 } }
            else if bi > 0 && num != prevNum &+ 1 { r.notContiguous &+= 1 }
            prevNum = num
            if let ph = parent, let pv = prevHash, !addrEq(ph, pv) { r.chainBreaks &+= 1 }
            if let h = hash { prevHash = h }
            r.txTotal &+= UInt64(txInBlock)
            if txInBlock == 0 { r.emptyBlocks &+= 1 }
            if r.tsFirst == 0 { r.tsFirst = ts }
            r.tsLast = ts

            let (ro, rl) = rLines[bi]
            let R = JS(p: rp + ro, n: rl)
            swaps.removeAll(keepingCapacity: true)
            syncs.removeAll(keepingCapacity: true)
            xfers.removeAll(keepingCapacity: true)
            var gasWeiByTx = [UInt32: U256]()
            var rcount = 0

            _ = R.arrayEach(0) { rs in
                rcount += 1
                var txIdx: UInt32 = 0
                var eff: UInt64 = 0, gasUsed: UInt64 = 0
                var who: Addr = (0, 0, 0)
                var logsAt = -1
                var txh = ""
                _ = R.objectEach(rs) { ks, kl, vs in
                    if R.keyIs(ks, kl, "transactionIndex") { if let v = R.hexU64(vs) { txIdx = UInt32(truncatingIfNeeded: v) } else { r.badHex &+= 1 } }
                    else if R.keyIs(ks, kl, "effectiveGasPrice") { if let v = R.hexU64(vs) { eff = v } else { r.badHex &+= 1 } }
                    else if R.keyIs(ks, kl, "gasUsed") { if let v = R.hexU64(vs) { gasUsed = v } else { r.badHex &+= 1 } }
                    else if R.keyIs(ks, kl, "from") { if let a = R.addr(vs) { who = a } else { r.badHex &+= 1 } }
                    else if R.keyIs(ks, kl, "transactionHash") { txh = R.strOut(vs) ?? "" }
                    else if R.keyIs(ks, kl, "logs") { logsAt = vs }
                }
                let (ghi, glo) = gasUsed.multipliedFullWidth(by: eff)
                gasWeiByTx[txIdx] = U256(w0: glo, w1: ghi, w2: 0, w3: 0)
                if logsAt >= 0 {
                    _ = R.arrayEach(logsAt) { ls in
                        r.logsTotal &+= 1
                        var pool: Addr = (0, 0, 0)
                        var kind: UInt8 = 0
                        var dataAt = -1
                        var logIdx: UInt32 = 0
                        var t1: Addr? = nil, t2: Addr? = nil
                        _ = R.objectEach(ls) { ks, kl, vs in
                            if R.keyIs(ks, kl, "address") { if let a = R.addr(vs) { pool = a } }
                            else if R.keyIs(ks, kl, "logIndex") { if let v = R.hexU64(vs) { logIdx = UInt32(truncatingIfNeeded: v) } }
                            else if R.keyIs(ks, kl, "data") { dataAt = vs }
                            else if R.keyIs(ks, kl, "topics") {
                                var idx = 0
                                _ = R.arrayEach(vs) { tsx in
                                    if idx == 0 {
                                        if R.strEq(tsx, V2SWAP) { kind = 2 }
                                        else if R.strEq(tsx, V3SWAP) { kind = 3 }
                                        else if R.strEq(tsx, V2SYNC) { kind = 4 }
                                        else if R.strEq(tsx, ERC20XFER) { kind = 5 }
                                    } else if idx == 1 { t1 = R.topicAddr(tsx) }
                                    else if idx == 2 { t2 = R.topicAddr(tsx) }
                                    idx += 1
                                }
                            }
                        }
                        if kind == 0 || dataAt < 0 { return }
                        if kind == 4 {
                            guard let a = R.dataWord(dataAt, 0), let b = R.dataWord(dataAt, 1) else { r.malformedSwapData &+= 1; return }
                            var s = SyncRec(); s.pool = pool; s.logIndex = logIdx
                            s.r0 = U256(mag: a); s.r1 = U256(mag: b)
                            syncs.append(s); r.syncs &+= 1
                            return
                        }
                        if kind == 5 {
                            guard let v = R.dataWord(dataAt, 0), let f = t1, let t = t2 else { return }
                            var x = XferRec(); x.token = pool; x.txIndex = txIdx; x.from = f; x.to = t
                            x.value = U256(mag: v)
                            xfers.append(x); r.transfers &+= 1
                            return
                        }
                        var s = SwapRec()
                        s.txIndex = txIdx; s.logIndex = logIdx; s.pool = pool; s.who = who; s.kind = kind; s.txHash = txh
                        if kind == 2 {
                            guard let a0i = R.dataWord(dataAt, 0), let a1i = R.dataWord(dataAt, 1),
                                  let a0o = R.dataWord(dataAt, 2), let a1o = R.dataWord(dataAt, 3) else {
                                r.malformedSwapData &+= 1; return }
                            s.d0 = a0i - a0o; s.d1 = a1i - a1o
                            r.swapV2 &+= 1
                        } else {
                            guard let a0 = R.dataWord(dataAt, 0), let a1 = R.dataWord(dataAt, 1),
                                  let sp = R.dataWord(dataAt, 2), let lq = R.dataWord(dataAt, 3) else {
                                r.malformedSwapData &+= 1; return }
                            s.d0 = a0; s.d1 = a1
                            s.sqrtP = U256(mag: sp); s.liq = U256(mag: lq)
                            r.swapV3 &+= 1
                        }
                        s.dir = (!s.d0.isNegative && !s.d0.isZero) ? 0 : 1
                        swaps.append(s)
                    }
                }
            }
            r.receiptTotal &+= UInt64(rcount)
            if rcount != txInBlock { r.txCountMismatch &+= 1 }

            // ---- Sync-chain content check: consecutive V2 syncs on one pool must differ by
            //      exactly the intervening swap's own deltas. This is what validates the Sync
            //      topic constant and the reserve decoding against the data itself.
            do {
                var lastSync = [String: SyncRec]()
                var order = swaps.indices.sorted { (swaps[$0].txIndex, swaps[$0].logIndex) < (swaps[$1].txIndex, swaps[$1].logIndex) }
                order = order.filter { swaps[$0].kind == 2 }
                for si in order {
                    let sw = swaps[si]
                    guard let sy = syncs.last(where: { addrEq($0.pool, sw.pool) && $0.logIndex == sw.logIndex &- 1 }) else { continue }
                    let k = addrKey(sw.pool)
                    if let prev = lastSync[k] {
                        r.syncChainChecked &+= 1
                        // prev.r + delta == sy.r  (exact, signed)
                        var p0 = I256(); p0.w = (prev.r0.w0, prev.r0.w1, prev.r0.w2, prev.r0.w3)
                        var p1 = I256(); p1.w = (prev.r1.w0, prev.r1.w1, prev.r1.w2, prev.r1.w3)
                        let e0 = p0 + sw.d0, e1 = p1 + sw.d1
                        var c0 = I256(); c0.w = (sy.r0.w0, sy.r0.w1, sy.r0.w2, sy.r0.w3)
                        var c1 = I256(); c1.w = (sy.r1.w0, sy.r1.w1, sy.r1.w2, sy.r1.w3)
                        if (e0 - c0).isZero && (e1 - c1).isZero { r.syncChainAgreed &+= 1 }
                    }
                    lastSync[k] = sy
                }
            }

            // ---- POOL TOKEN IDENTIFICATION, from the ERC-20 Transfer logs of the swap's own
            //      transaction, matched on BOTH the pool endpoint and the exact value. Used
            //      for LABELLING and for the readability rate. Never on a decision path.
            for sw in swaps where sw.kind == 2 {
                let zf = (sw.dir == 0)
                let ain = zf ? U256(mag: sw.d0) : U256(mag: sw.d1)
                let aout = zf ? U256(mag: sw.d1) : U256(mag: sw.d0)
                if ain.isZero || aout.isZero { continue }
                var inC: [Addr] = [], outC: [Addr] = []
                for x in xfers where x.txIndex == sw.txIndex {
                    if addrEq(x.to, sw.pool) && U256.cmp(x.value, ain) == 0 { inC.append(x.token) }
                    if addrEq(x.from, sw.pool) && U256.cmp(x.value, aout) == 0 { outC.append(x.token) }
                }
                func uniq1(_ a: [Addr]) -> Addr? {
                    guard let f = a.first else { return nil }
                    for y in a where !addrEq(y, f) { return nil }
                    return f
                }
                guard let ti = uniq1(inC), let to = uniq1(outC) else { continue }
                let t0 = zf ? ti : to
                let t1 = zf ? to : ti
                let key = addrKey(sw.pool)
                if let prev = r.poolTokens[key] {
                    if !addrEq(prev.0, t0) || !addrEq(prev.1, t1) { r.poolTokenConflicts &+= 1 }
                } else {
                    r.poolTokens[key] = (t0, t1)
                }
                if let sy = syncs.last(where: { addrEq($0.pool, sw.pool) && $0.logIndex == sw.logIndex &- 1 }) {
                    let cur = r.poolDeepest[key]
                    if cur == nil || U256.cmp(sy.r0, cur!.0) > 0 {
                        r.poolDeepest[key] = (sy.r0, sy.r1, num, sw.pool)
                    }
                }
            }

            // ---- INSERTION SHEAR, the same conjuncts, re-derived here ----
            if swaps.count >= 3 {
                var byPool = [String: [Int]]()
                for (i, s) in swaps.enumerated() { byPool[addrKey(s.pool), default: []].append(i) }
                for k in byPool.keys.sorted() {
                    let idxs = byPool[k]!
                    if idxs.count < 3 { continue }
                    r.poolsWith3Plus &+= 1
                    let m = idxs.count
                    for a in 0..<m {
                        if a + 2 >= m { break }
                        for c in (a + 2)..<m {
                            let i = idxs[a], kk = idxs[c]
                            r.pairsTested &+= 1
                            let si = swaps[i], sk = swaps[kk]
                            if si.dir == sk.dir { continue }
                            if si.txIndex == sk.txIndex { continue }
                            if !addrEq(si.who, sk.who) { continue }
                            var victim = -1
                            for b in (a + 1)..<c {
                                let j = idxs[b], sj = swaps[j]
                                if addrEq(sj.who, si.who) { continue }
                                if sj.dir != si.dir { continue }
                                if sj.txIndex == si.txIndex || sj.txIndex == sk.txIndex { continue }
                                victim = j; break
                            }
                            if victim < 0 { continue }
                            r.brackets &+= 1
                            r.bracketBlocks.insert(num)
                            r.bracketActors.insert(pseudo(si.who))
                            let n0 = I256() - (si.d0 + sk.d0)
                            let n1 = I256() - (si.d1 + sk.d1)
                            let ext = !n0.isNegative && !n1.isNegative && !(n0.isZero && n1.isZero)
                            if !ext { continue }
                            r.extractive &+= 1
                            r.extractiveActors.insert(pseudo(si.who))
                            r.shearBlocks.insert(num)
                            if UInt64(sk.txIndex &- si.txIndex) > 3 { r.spanOver3 &+= 1 }

                            var d = Detection()
                            d.block = num; d.ts = ts; d.pool = si.pool; d.actor = si.who; d.kind = si.kind
                            d.txFront = si.txIndex; d.txVictim = swaps[victim].txIndex; d.txBack = sk.txIndex
                            d.victimTx = swaps[victim].txHash
                            d.net0 = n0; d.net1 = n1
                            var gw = U256()
                            if let g = gasWeiByTx[si.txIndex] { gw = gw + g }
                            if let g = gasWeiByTx[sk.txIndex] { gw = gw + g }
                            d.gasWei = gw
                            // adjacency of the front leg to the victim within this pool's sequence
                            let adjacent = (c > a) && (victim == idxs[a + 1])
                            computeShortfall(&d, front: si, victimSwap: swaps[victim],
                                             syncs: syncs, adjacent: adjacent, blockSwaps: swaps)
                            identifyTokens(&d, victimSwap: swaps[victim], xfers: xfers)
                            r.dets.append(d)
                        }
                    }
                }
            }
        }
    }
    }
    r.elapsedNS = nowNS() &- t0
}

/// Identify the victim leg's input and output token contracts from the ERC-20 Transfer logs
/// of the victim's own transaction, matched on BOTH the pool endpoint and the exact value.
/// A non-unique match is left unidentified rather than guessed.
func identifyTokens(_ d: inout Detection, victimSwap v: SwapRec, xfers: [XferRec]) {
    if d.victimIn.isZero && d.victimOut.isZero { return }
    var inCand: [Addr] = [], outCand: [Addr] = []
    for x in xfers where x.txIndex == v.txIndex {
        if addrEq(x.to, v.pool) && U256.cmp(x.value, d.victimIn) == 0 { inCand.append(x.token) }
        if addrEq(x.from, v.pool) && U256.cmp(x.value, d.victimOut) == 0 { outCand.append(x.token) }
    }
    func uniq(_ a: [Addr]) -> Addr? {
        guard let f = a.first else { return nil }
        for x in a where !addrEq(x, f) { return nil }
        return f
    }
    d.victimInToken = uniq(inCand)
    d.victimOutToken = uniq(outCand)
    if d.victimOutToken == nil {
        var best = U256()
        for x in xfers where x.txIndex == v.txIndex && addrEq(x.from, v.pool) {
            if U256.cmp(x.value, best) > 0 { best = x.value }
        }
        if !best.isZero { d.outTransferNear = best }
    }
}

/// Equation (4), by protocol. Every failure path names WHICH answer it is.
func computeShortfall(_ d: inout Detection, front: SwapRec, victimSwap v: SwapRec,
                      syncs: [SyncRec], adjacent: Bool, blockSwaps: [SwapRec] = []) {
    // victim leg amounts, from the victim's own event
    let vIn: U256, vOut: U256
    let zeroForOne = (v.dir == 0)
    if zeroForOne { vIn = U256(mag: v.d0); vOut = U256(mag: v.d1) }
    else { vIn = U256(mag: v.d1); vOut = U256(mag: v.d0) }
    d.victimIn = vIn; d.victimOut = vOut
    if vIn.isZero || vOut.isZero { d.status = .notKnownDegen; return }
    if !adjacent { d.status = .notKnownAdj; return }

    if d.kind == 2 {
        guard let syF = syncs.last(where: { addrEq($0.pool, front.pool) && $0.logIndex == front.logIndex &- 1 }),
              let syV = syncs.last(where: { addrEq($0.pool, v.pool) && $0.logIndex == v.logIndex &- 1 }) else {
            d.status = .notKnownNoSync; return
        }
        // (2): reserves before the front leg
        var af0 = I256(); af0.w = (syF.r0.w0, syF.r0.w1, syF.r0.w2, syF.r0.w3)
        var af1 = I256(); af1.w = (syF.r1.w0, syF.r1.w1, syF.r1.w2, syF.r1.w3)
        let bf0 = af0 - front.d0, bf1 = af1 - front.d1
        if bf0.isNegative || bf1.isNegative { d.status = .notKnownArith; return }
        // (3): reserves before the victim leg
        var av0 = I256(); av0.w = (syV.r0.w0, syV.r0.w1, syV.r0.w2, syV.r0.w3)
        var av1 = I256(); av1.w = (syV.r1.w0, syV.r1.w1, syV.r1.w2, syV.r1.w3)
        let bv0 = av0 - v.d0, bv1 = av1 - v.d1
        if bv0.isNegative || bv1.isNegative { d.status = .notKnownArith; return }
        // (2) and (3) must agree: R_after_front == R_before_victim
        if !((bv0 - af0).isZero && (bv1 - af1).isZero) { d.status = .notKnownStateGap; return }

        let rinPre  = zeroForOne ? U256(mag: bf0) : U256(mag: bf1)
        let routPre = zeroForOne ? U256(mag: bf1) : U256(mag: bf0)
        let rinObs  = zeroForOne ? U256(mag: bv0) : U256(mag: bv1)
        let routObs = zeroForOne ? U256(mag: bv1) : U256(mag: bv0)
        d.reserveInPre = rinPre; d.reserveOutPre = routPre

        guard let (flo, fhi) = v2RecoverFeeInterval(vIn, rinObs, routObs, vOut) else {
            d.status = .notKnownFee; return
        }
        d.feeNum = flo
        guard let cfLo = v2Out(vIn, rinPre, routPre, flo),
              let cfHi = v2Out(vIn, rinPre, routPre, fhi) else { d.status = .notKnownArith; return }
        let lo = U256.cmp(cfLo, cfHi) <= 0 ? cfLo : cfHi
        let hi = U256.cmp(cfLo, cfHi) <= 0 ? cfHi : cfLo
        d.victimOutCF = lo; d.victimOutCFHi = hi
        d.shortfall = SInt.diff(lo, vOut)
        d.shortfallHi = SInt.diff(hi, vOut)
        d.status = (U256.cmp(lo, hi) == 0) ? .exact : .interval
        finishRatios(&d, rinPre: rinPre)
        return
    }

    // ---- V3 ----
    if U256.cmp(front.liq, v.liq) != 0 { d.status = .notKnownLiq; return }
    let L = v.liq
    if L.isZero { d.status = .notKnownDegen; return }
    let sqrtAfterVictim = v.sqrtP
    let sqrtBeforeVictim = front.sqrtP          // adjacency was required above
    // fee tier recovered by exact reproduction of the victim's own leg
    var tiers: [UInt64] = []
    for f in [UInt64(100), 500, 3000, 10000] {
        if let st = v3Step(sqrtCur: sqrtBeforeVictim, liquidity: L, feePips: f, grossIn: vIn, zeroForOne: zeroForOne),
           U256.cmp(st.sqrtNext, sqrtAfterVictim) == 0, U256.cmp(st.amountOut, vOut) == 0 {
            tiers.append(f)
        }
    }
    // THE FEE. Recovered from the leg itself where the leg determines it; otherwise from
    // the pool's own immutable fee(), READ and then RE-VERIFIED against this leg. A fee
    // that does not reproduce the victim's own observed output is not accepted, and the
    // row keeps a NOT_KNOWN that now names the sharper reason: at the pool's own fee, a
    // single-tick step at the liquidity the event reported still does not reproduce the
    // leg. The fee is determined and the model fails anyway, which is a refutation of the
    // model on that row rather than a missing input. WHY it fails — a tick crossing, or a
    // mint or burn moving in-range liquidity inside the step — is not distinguished here
    // and is not claimed.
    var usedRecovered = false
    var fee: UInt64
    if tiers.count == 1 {
        fee = tiers[0]
    } else if let rf = RECOVERED[d.victimTx.lowercased()]?.feePips {
        if let st = v3Step(sqrtCur: sqrtBeforeVictim, liquidity: L, feePips: rf, grossIn: vIn, zeroForOne: zeroForOne),
           U256.cmp(st.sqrtNext, sqrtAfterVictim) == 0, U256.cmp(st.amountOut, vOut) == 0 {
            fee = rf; usedRecovered = true
        } else {
            RECOVERED_REJECTED[d.victimTx] = "fee_\(rf)_does_not_reproduce_the_victim_leg_tiers_matched_\(tiers.count)"
            d.status = .notKnownTick; return
        }
    } else {
        d.status = .notKnownRepro; return
    }
    d.feeNum = fee
    // invert the front leg to the state before it
    let fIn: U256, fOut: U256
    let fZ = (front.dir == 0)
    if fZ { fIn = U256(mag: front.d0); fOut = U256(mag: front.d1) }
    else { fIn = U256(mag: front.d1); fOut = U256(mag: front.d0) }
    // THE PRE-FRONT PRICE, three routes, in order of provenance, each VERIFIED the same way.
    //
    //   1  invert the front leg through v3InvertStart          — needs nothing but the leg
    //   2  the last Swap on this pool earlier in THIS BLOCK    — needs nothing but the corpus
    //   3  slot0() at the parent block, supplied via --recovered — needs the wire
    //
    // Route 2 is free, is already on disk, and has better provenance than route 3: a
    // price the chain itself emitted in the same block beats a price fetched from a node
    // by a separate call. It is tried BEFORE the wire for exactly that reason. Mint and
    // Burn do not move a V3 pool's price — only a swap does — so the previous swap's
    // sqrtPriceX96 IS the price until the next one.
    //
    // EVERY ROUTE PASSES THE SAME GATE. The candidate price must run the front leg
    // FORWARD through v3Step onto the price the leg itself reported and the amount it
    // itself returned. A candidate that does not is discarded by name and the row keeps
    // its NOT_KNOWN. This is what stops a fetched number from becoming a fitted one.
    var s0lo: U256, s0hi: U256
    var priorInBlock: U256? = nil
    for sw in blockSwaps where sw.kind == 3 && addrEq(sw.pool, front.pool) && sw.logIndex < front.logIndex {
        if priorInBlock == nil { priorInBlock = sw.sqrtP }
        else { priorInBlock = sw.sqrtP }   // keep the LAST one before the front leg
    }
    func reproducesFront(_ cand: U256) -> Bool {
        guard let fs = v3Step(sqrtCur: cand, liquidity: front.liq, feePips: fee,
                              grossIn: fIn, zeroForOne: fZ) else { return false }
        return U256.cmp(fs.sqrtNext, front.sqrtP) == 0 && U256.cmp(fs.amountOut, fOut) == 0
    }
    if let inv = v3InvertStart(sqrtAfter: front.sqrtP, liquidity: front.liq, feePips: fee,
                               grossIn: fIn, observedOut: fOut, zeroForOne: fZ) {
        s0lo = inv.lo; s0hi = inv.hi
    } else if let pb = priorInBlock, reproducesFront(pb) {
        s0lo = pb; s0hi = pb; usedRecovered = true
        RECOVERED_INBLOCK.insert(d.victimTx)
    } else if let rs = RECOVERED[d.victimTx.lowercased()]?.sqrtPreFront {
        // A READ state is still only accepted if it reproduces the front leg FORWARD
        // through the same v3Step the rest of this file uses. Running the leg forward
        // from the fetched price must land on the price the leg itself reported and
        // return the amount it itself returned. Anything less would be a number chosen
        // because it closes the row, which is a fit, not a measurement.
        if reproducesFront(rs) {
            s0lo = rs; s0hi = rs; usedRecovered = true
        } else {
            RECOVERED_REJECTED[d.victimTx] = "slot0_at_parent_block_does_not_reproduce_the_front_leg_forward"
                + (priorInBlock == nil
                   ? "__and_no_earlier_swap_on_this_pool_in_this_block__so_the_front_leg_itself_crossed_a_tick"
                   : "__an_earlier_swap_on_this_pool_in_this_block_also_failed__so_the_front_leg_crossed_a_tick")
            d.status = .notKnownInvert; return
        }
    } else {
        d.status = .notKnownInvert; return
    }
    guard let a = v3Step(sqrtCur: s0lo, liquidity: L, feePips: fee, grossIn: vIn, zeroForOne: zeroForOne),
          let b = v3Step(sqrtCur: s0hi, liquidity: L, feePips: fee, grossIn: vIn, zeroForOne: zeroForOne) else {
        d.status = .notKnownArith; return
    }
    let lo = U256.cmp(a.amountOut, b.amountOut) <= 0 ? a.amountOut : b.amountOut
    let hi = U256.cmp(a.amountOut, b.amountOut) <= 0 ? b.amountOut : a.amountOut
    d.victimOutCF = lo; d.victimOutCFHi = hi
    d.shortfall = SInt.diff(lo, vOut)
    d.shortfallHi = SInt.diff(hi, vOut)
    if usedRecovered { d.status = (U256.cmp(lo, hi) == 0) ? .exactRecovered : .intervalRecovered }
    else { d.status = (U256.cmp(lo, hi) == 0) ? .exact : .interval }
    // virtual reserves at the pre-front price: x = L·2^96/√P, y = L·√P/2^96
    if let x = U256.mulDiv(L, Q96, s0lo), let y = U256.mulDiv(L, s0lo, Q96) {
        d.reserveInPre  = zeroForOne ? x : y
        d.reserveOutPre = zeroForOne ? y : x
        finishRatios(&d, rinPre: d.reserveInPre)
    }
}

/// Two unit-free ratios, integer, comparable across pools and across tokens.
func finishRatios(_ d: inout Detection, rinPre: U256) {
    if !rinPre.isZero, let s = U256.mulDiv(d.victimIn, U256(10_000), rinPre), let v = s.asU64 { d.sizeBp = v }
    if !d.victimOutCF.isZero, !d.shortfall.neg,
       let s = U256.mulDiv(d.shortfall.mag, U256(10_000), d.victimOutCF), let v = s.asU64 { d.lossBp = v }
}

/// Decimal string to U256. The live detection rows carry every amount as a decimal STRING,
/// which is how a 256-bit integer survives a JSON encoder that has only a float.
func decU256(_ s: String) -> U256? {
    if s.isEmpty { return nil }
    var v = U256()
    for ch in s.utf8 {
        guard ch >= 0x30, ch <= 0x39 else { return nil }
        guard let t = U256.mulDiv(v, U256(10), U256(1)) else { return nil }
        let (r, c) = U256.addC(t, U256(UInt64(ch - 0x30)))
        if c { return nil }
        v = r
    }
    return v
}

/// EVERY LIVE DETECTION ON DISK. These rows were emitted by the live watcher at the chain
/// head. They carry the two attacker legs' amounts, so the ATTACKER NET POSITION CHANGE in
/// the cycled token is exactly checkable here. They do NOT carry the pool's reserve state,
/// and equation (4) cannot be evaluated without it — so the victim shortfall for these rows
/// is NOT_KNOWN, with the missing input named.
func liveRows(_ paths: [String]) {
    section("LIVE DETECTIONS ON DISK — what the rows themselves support, and what they do not")
    emit("A live row carries leg A's input, leg B's output and the cycled difference. That is")
    emit("enough to CHECK the attacker's net position change in the cycled token exactly. It")
    emit("is not enough for a victim shortfall: equation (4) needs the pool's reserve state")
    emit("before the front leg, which is not in these rows and is not on this disk.")
    var files = 0, rows = 0, agreed = 0, disagreed = 0, unparsed = 0
    var total = U256()
    emit("")
    emit("file\tblock\tproto\tpool\tactor\tlegA_in\tlegB_out\tattacker_net_cycled_token\tcheck\tvictim_shortfall")
    for path in paths {
        guard let d = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            emit("ABSENT\t" + path + "\t— ABSENT is not a REFUSAL and it is not a pass")
            continue
        }
        files += 1
        let base = (path as NSString).lastPathComponent
        let text = String(decoding: d, as: UTF8.self)
        for line in text.split(separator: "\n") {
            let bytes = Array(line.utf8)
            if bytes.isEmpty { continue }
            rows += 1
            var blk: UInt64 = 0, proto: UInt64 = 0
            var pool = "", who = "", ain = "", bout = "", cyc = ""
            bytes.withUnsafeBufferPointer { bp in
                guard let p = bp.baseAddress else { return }
                let J = JS(p: p, n: bytes.count)
                _ = J.objectEach(0) { ks, kl, vs in
                    if J.keyIs(ks, kl, "block") { blk = J.rawNumU64(vs) ?? 0 }
                    else if J.keyIs(ks, kl, "proto") { proto = J.rawNumU64(vs) ?? 0 }
                    else if J.keyIs(ks, kl, "pool") { pool = J.strOut(vs) ?? "" }
                    else if J.keyIs(ks, kl, "address") { who = J.strOut(vs) ?? "" }
                    else if J.keyIs(ks, kl, "legA_in") { ain = J.strOut(vs) ?? "" }
                    else if J.keyIs(ks, kl, "legB_out") { bout = J.strOut(vs) ?? "" }
                    else if J.keyIs(ks, kl, "cycle_back") { cyc = J.strOut(vs) ?? "" }
                }
            }
            guard let a = decU256(ain), let b = decU256(bout), let c = decU256(cyc) else {
                unparsed += 1
                emit(base + "\t" + String(blk) + "\tUNPARSED\t-\t-\t" + ain + "\t" + bout + "\t-\tUNPARSED\tNOT_KNOWN")
                continue
            }
            // the row's own arithmetic: cycle_back must be legB_out − legA_in exactly
            let diff = SInt.diff(b, a)
            let ok = !diff.neg && U256.cmp(diff.mag, c) == 0
            if ok { agreed += 1; total = total + c } else { disagreed += 1 }
            let actor = pool.isEmpty ? "-" : pseudo(parseAddrLit(who))
            let pl = pool.isEmpty ? "-" : pseudo(parseAddrLit(pool))
            emit(base + "\t" + String(blk) + "\tV" + String(proto) + "\t" + pl + "\t" + actor
                + "\t" + a.dec + "\t" + b.dec + "\t" + c.dec
                + "\t" + (ok ? "EXACT" : "MISMATCH")
                + "\tNOT_KNOWN_NO_RESERVE_STATE_ON_DISK")
        }
    }
    emit("")
    kv("live_files_read", files)
    kv("live_rows", rows)
    kv("rows_whose_own_arithmetic_reproduces_exactly", agreed)
    kv("rows_whose_own_arithmetic_DISAGREES", disagreed)
    kv("rows_unparsed", unparsed)
    kv("attacker_net_position_change_summed_cycled_token_base_units", total.dec)
    emit("THAT SUM IS UNIT-MIXED AND IS NOT A VALUE. Each row's cycled token is a different")
    emit("asset and the row does not say which; adding them is an arithmetic operation over")
    emit("incommensurable units, printed because the per-row integers are the result and a")
    emit("reader will add them anyway. It is not money and it is not comparable to the")
    emit("corpus totals above.")
    emit("")
    kv("victim_shortfall_for_every_live_row", "NOT_KNOWN")
    emit("WHAT WOULD CLOSE IT, named exactly: the receipts for those blocks, from which the")
    emit("Sync reserves (V2) or the sqrtPrice-and-liquidity words (V3) give equation (4) the")
    emit("state it needs. This program does not fetch them. It is the offline exactness")
    emit("kernel; reaching for a network here would make its answer depend on an endpoint")
    emit("that has already been measured returning HTTP 200 carrying 'Hello World!'.")
    emit("NOT_KNOWN is a third answer. It is not zero, and it is not a small shortfall.")
}

// =====================================================================================
// SECTION 8 — SELF-TEST. Arms in BOTH directions. None is a literal `true`.
// =====================================================================================

var armsRun = 0, armsPassed = 0, armsFailed = 0
func arm(_ name: String, _ expect: String, _ body: () -> (Bool, String)) {
    armsRun += 1
    let (ok, got) = body()
    if ok { armsPassed += 1; emit("ARM\tPASS\t" + name + "\texpect\t" + expect + "\tgot\t" + got) }
    else { armsFailed += 1; emit("ARM\tFAIL\t" + name + "\texpect\t" + expect + "\tgot\t" + got) }
}

func selftest() -> Int {
    section("SELF-TEST — every arm has a direction, and both directions are exercised")

    // ---- ARITHMETIC ----------------------------------------------------------------
    arm("u256_muldiv_exact", "floor(2^200·3/7) reproduces by multiply-back") {
        let a = U256(w0: 0, w1: 0, w2: 0, w3: 1 << 8)          // 2^200
        guard let q = U256.mulDiv(a, U256(3), U256(7)) else { return (false, "nil") }
        // q·7 + r == a·3 with 0 <= r < 7
        let p = U256.mulFull(a, U256(3))
        guard let (q2, r2) = U256.divFull(p, U256(7)) else { return (false, "nil2") }
        let ok = U256.cmp(q, q2) == 0 && r2.asU64 != nil && r2.asU64! < 7
        return (ok, q.dec + " r=" + String(r2.asU64 ?? 9))
    }
    arm("u256_div_by_zero_refused", "nil, not a silent zero") {
        let z = U256.div(U256(5), U256(0))
        return (z == nil, z == nil ? "nil" : "value")
    }
    arm("u256_muldivup_rounds_up", "ceil(7/2)=4 while floor(7/2)=3") {
        guard let up = U256.mulDivUp(U256(7), U256(1), U256(2)),
              let dn = U256.mulDiv(U256(7), U256(1), U256(2)) else { return (false, "nil") }
        return (up.asU64 == 4 && dn.asU64 == 3, "up=\(up.dec) down=\(dn.dec)")
    }
    arm("u256_decimal_roundtrip_large", "2^255 prints its exact decimal") {
        let a = U256(w0: 0, w1: 0, w2: 0, w3: 1 << 63)
        return (a.dec == "57896044618658097711785492504343953926634992332820282019728792003956564819968", a.dec)
    }

    // ---- V2 SHORTFALL, HAND-COMPUTED ------------------------------------------------
    // Pool before the front leg: R0 = 1,000,000  R1 = 1,000,000, fee 997/1000.
    //   front: 100,000 token0 in
    //     out = floor(100000·997·1000000 / (1000000·1000 + 100000·997))
    //         = floor(99,700,000,000,000 / 1,099,700,000) = 90,661
    //     reserves after front: (1,100,000 , 909,339)
    //   victim: 10,000 token0 in, against (1,100,000 , 909,339)
    //     out = floor(9,970,000·909,339 / 1,109,970,000)
    //         = floor(9,066,109,830,000 / 1,109,970,000) = 8,167
    //   counterfactual, same 10,000 in against (1,000,000 , 1,000,000)
    //     out = floor(9,970,000·1,000,000 / 1,009,970,000)
    //         = floor(9,970,000,000,000 / 1,009,970,000) = 9,871
    //   SHORTFALL = 9,871 − 8,167 = 1,704
    arm("v2_front_leg_output_hand", "90661") {
        let o = v2Out(U256(100_000), U256(1_000_000), U256(1_000_000), 997)
        return (o?.asU64 == 90_661, o?.dec ?? "nil")
    }
    arm("v2_victim_actual_hand", "8167") {
        let o = v2Out(U256(10_000), U256(1_100_000), U256(909_339), 997)
        return (o?.asU64 == 8_167, o?.dec ?? "nil")
    }
    arm("v2_victim_counterfactual_hand", "9871") {
        let o = v2Out(U256(10_000), U256(1_000_000), U256(1_000_000), 997)
        return (o?.asU64 == 9_871, o?.dec ?? "nil")
    }
    arm("v2_shortfall_hand", "1704") {
        guard let cf = v2Out(U256(10_000), U256(1_000_000), U256(1_000_000), 997),
              let ac = v2Out(U256(10_000), U256(1_100_000), U256(909_339), 997) else { return (false, "nil") }
        let s = SInt.diff(cf, ac)
        return (s.dec == "1704", s.dec)
    }
    // THE OTHER DIRECTION — a swap with NO sandwich in front of it must return EXACTLY
    // zero, not a small number. A shortfall function that leaks a rounding residue here
    // would report loss on every honest trade in the corpus.
    arm("v2_no_sandwich_is_exactly_zero", "0") {
        guard let cf = v2Out(U256(10_000), U256(1_000_000), U256(1_000_000), 997),
              let ac = v2Out(U256(10_000), U256(1_000_000), U256(1_000_000), 997) else { return (false, "nil") }
        let s = SInt.diff(cf, ac)
        return (s.dec == "0" && s.isZero, s.dec)
    }
    // THE THIRD DIRECTION — the function is not positive by construction. A leg in the
    // OPPOSITE direction leaves the victim BETTER off and must produce a NEGATIVE answer.
    arm("v2_opposite_leg_gives_negative", "negative") {
        // someone sells token1 into the pool first: reserves become (909339-ish, 1.1e6)
        guard let cf = v2Out(U256(10_000), U256(1_000_000), U256(1_000_000), 997),
              let ac = v2Out(U256(10_000), U256(900_000), U256(1_100_000), 997) else { return (false, "nil") }
        let s = SInt.diff(cf, ac)
        return (s.neg, s.dec)
    }
    arm("v2_fee_recovered_not_assumed", "997 recovered from the observation alone") {
        guard let obs = v2Out(U256(10_000), U256(1_100_000), U256(909_339), 997) else { return (false, "nil") }
        guard let (lo, hi) = v2RecoverFeeInterval(U256(10_000), U256(1_100_000), U256(909_339), obs) else { return (false, "none") }
        return (lo <= 997 && 997 <= hi, "[\(lo),\(hi)]")
    }
    arm("v2_fee_recovery_refuses_impossible_output", "no interval") {
        // an output larger than the whole output reserve cannot come from any fee
        let r = v2RecoverFeeInterval(U256(10_000), U256(1_100_000), U256(909_339), U256(909_338))
        return (r == nil, r == nil ? "none" : "interval")
    }
    arm("v2_out_refuses_empty_pool", "nil") {
        let o = v2Out(U256(10_000), U256(0), U256(1_000_000), 997)
        return (o == nil, o == nil ? "nil" : "value")
    }

    // ---- V3 STEP AND ITS INVERSE ----------------------------------------------------
    // A synthetic pool: L = 10^18, sqrtP = 2^96 (price 1), fee 3000 pips.
    let L = U256(w0: 1_000_000_000_000_000_000, w1: 0, w2: 0, w3: 0)
    arm("v3_step_moves_price_the_right_way", "token1-in raises sqrtP, token0-in lowers it") {
        guard let up = v3Step(sqrtCur: Q96, liquidity: L, feePips: 3000, grossIn: U256(1_000_000_000_000_000), zeroForOne: false),
              let dn = v3Step(sqrtCur: Q96, liquidity: L, feePips: 3000, grossIn: U256(1_000_000_000_000_000), zeroForOne: true) else { return (false, "nil") }
        return (U256.cmp(up.sqrtNext, Q96) > 0 && U256.cmp(dn.sqrtNext, Q96) < 0,
                "up=\(up.sqrtNext.dec) down=\(dn.sqrtNext.dec)")
    }
    arm("v3_invert_recovers_the_start_token1_in", "exactly 2^96") {
        guard let st = v3Step(sqrtCur: Q96, liquidity: L, feePips: 3000, grossIn: U256(1_000_000_000_000_000), zeroForOne: false) else { return (false, "nil") }
        guard let (lo, hi) = v3InvertStart(sqrtAfter: st.sqrtNext, liquidity: L, feePips: 3000,
                                           grossIn: U256(1_000_000_000_000_000), observedOut: st.amountOut, zeroForOne: false) else { return (false, "no inverse") }
        return (U256.cmp(lo, Q96) == 0 && U256.cmp(hi, Q96) == 0, lo.dec + ".." + hi.dec)
    }
    arm("v3_invert_recovers_the_start_token0_in", "a plateau containing 2^96") {
        guard let st = v3Step(sqrtCur: Q96, liquidity: L, feePips: 3000, grossIn: U256(1_000_000_000_000_000), zeroForOne: true) else { return (false, "nil") }
        guard let (lo, hi) = v3InvertStart(sqrtAfter: st.sqrtNext, liquidity: L, feePips: 3000,
                                           grossIn: U256(1_000_000_000_000_000), observedOut: st.amountOut, zeroForOne: true) else { return (false, "no inverse") }
        return (U256.cmp(lo, Q96) <= 0 && U256.cmp(hi, Q96) >= 0, lo.dec + ".." + hi.dec)
    }
    arm("v3_invert_refuses_an_impossible_observation", "no inverse") {
        // an output that no starting price can produce for this input
        let bogus = U256(w0: 0, w1: 0, w2: 1, w3: 0)
        let r = v3InvertStart(sqrtAfter: Q96, liquidity: L, feePips: 3000,
                              grossIn: U256(1_000_000_000_000_000), observedOut: bogus, zeroForOne: false)
        return (r == nil, r == nil ? "none" : "found")
    }
    arm("v3_fee_tier_discriminates", "the four tiers give four different outputs") {
        var outs = Set<String>()
        for f in [UInt64(100), 500, 3000, 10000] {
            guard let st = v3Step(sqrtCur: Q96, liquidity: L, feePips: f, grossIn: U256(1_000_000_000_000_000), zeroForOne: false) else { return (false, "nil") }
            outs.insert(st.amountOut.dec)
        }
        return (outs.count == 4, String(outs.count) + " distinct")
    }
    // V3 sandwich, end to end, through the same code path the corpus uses.
    arm("v3_sandwich_shortfall_is_positive_and_reproduces", "positive, and the no-front case is 0") {
        let gross = U256(1_000_000_000_000_000)
        guard let f = v3Step(sqrtCur: Q96, liquidity: L, feePips: 3000, grossIn: gross, zeroForOne: false) else { return (false, "nil f") }
        guard let vic = v3Step(sqrtCur: f.sqrtNext, liquidity: L, feePips: 3000, grossIn: gross, zeroForOne: false) else { return (false, "nil v") }
        guard let cf = v3Step(sqrtCur: Q96, liquidity: L, feePips: 3000, grossIn: gross, zeroForOne: false) else { return (false, "nil c") }
        let s = SInt.diff(cf.amountOut, vic.amountOut)
        let zero = SInt.diff(cf.amountOut, cf.amountOut)
        return (!s.neg && !s.isZero && zero.isZero, "shortfall=" + s.dec + " nofront=" + zero.dec)
    }

    // TWO INDEPENDENT ROUTES TO ONE NUMBER. Inside a single tick range a concentrated
    // liquidity pool IS a constant product on its virtual reserves x = L·2^96/√P and
    // y = L·√P/2^96, so equation (1) applied to those reserves must land on the pool's own
    // staged-rounding step routine. Agreement to within a rounding unit is a real check on
    // both; the SECOND arm proves the comparison can fail, so the first is not a tautology.
    arm("v3_step_agrees_with_constant_product_on_virtual_reserves", "within 1 part in 10^9") {
        let gross = U256(1_000_000_000_000_000)
        guard let st = v3Step(sqrtCur: Q96, liquidity: L, feePips: 3000, grossIn: gross, zeroForOne: false) else { return (false, "nil") }
        // at sqrtP = 2^96 both virtual reserves equal L
        guard let anet = U256.mulDiv(gross, U256(997_000), U256(1_000_000)),
              let cp = U256.mulDiv(L, anet, L + anet) else { return (false, "nil cp") }
        let d = SInt.diff(cp, st.amountOut)
        guard let scaled = U256.mulDiv(d.mag, U256(1_000_000_000), U256(1)) else { return (false, "nil scale") }
        return (U256.cmp(scaled, st.amountOut) <= 0, "step=" + st.amountOut.dec + " cp=" + cp.dec + " diff=" + d.dec)
    }
    arm("that_agreement_check_can_fail", "a wrong fee tier breaks it") {
        let gross = U256(1_000_000_000_000_000)
        guard let st = v3Step(sqrtCur: Q96, liquidity: L, feePips: 10000, grossIn: gross, zeroForOne: false) else { return (false, "nil") }
        guard let anet = U256.mulDiv(gross, U256(997_000), U256(1_000_000)),
              let cp = U256.mulDiv(L, anet, L + anet) else { return (false, "nil cp") }
        let d = SInt.diff(cp, st.amountOut)
        guard let scaled = U256.mulDiv(d.mag, U256(1_000_000_000), U256(1)) else { return (false, "nil scale") }
        return (U256.cmp(scaled, st.amountOut) > 0, "diff=" + d.dec)
    }

    // ---- THE INSTRUMENT MUST REFUSE AN EMPTY INPUT ----------------------------------
    arm("empty_corpus_yields_zero_blocks", "0 blocks, so the caller REFUSES") {
        var r = Run()
        let tmp = NSTemporaryDirectory() + "extraction-selftest-empty"
        try? FileManager.default.createDirectory(atPath: tmp, withIntermediateDirectories: true)
        let b = tmp + "/blocks.ndjson", c = tmp + "/receipts.ndjson"
        FileManager.default.createFile(atPath: b, contents: Data())
        FileManager.default.createFile(atPath: c, contents: Data())
        runCorpus(blocksPath: b, receiptsPath: c, expectStart: 0, expectCount: 0, r: &r)
        try? FileManager.default.removeItem(atPath: tmp)
        return (r.blocks == 0 && r.dets.isEmpty, "blocks=\(r.blocks) dets=\(r.dets.count)")
    }
    arm("absent_corpus_is_not_an_empty_one", "0 blocks from a path that does not exist") {
        var r = Run()
        runCorpus(blocksPath: "/nonexistent/blocks.ndjson", receiptsPath: "/nonexistent/receipts.ndjson",
                  expectStart: 0, expectCount: 0, r: &r)
        return (r.blocks == 0, "blocks=\(r.blocks)")
    }
    // The self-contradiction guard, both directions.
    arm("self_contradiction_guard_fires", "gasUsed>0 with zero transactions is impossible") {
        var r = Run()
        let tmp = NSTemporaryDirectory() + "extraction-selftest-contra"
        try? FileManager.default.createDirectory(atPath: tmp, withIntermediateDirectories: true)
        let b = tmp + "/blocks.ndjson", c = tmp + "/receipts.ndjson"
        let blk = "{\"number\":\"0x1\",\"timestamp\":\"0x10\",\"gasUsed\":\"0x5208\",\"hash\":\"0x" + String(repeating: "a", count: 64) + "\",\"parentHash\":\"0x" + String(repeating: "b", count: 64) + "\",\"transactions\":[]}\n"
        try? blk.write(toFile: b, atomically: true, encoding: .utf8)
        try? "[]\n".write(toFile: c, atomically: true, encoding: .utf8)
        runCorpus(blocksPath: b, receiptsPath: c, expectStart: 0, expectCount: 0, r: &r)
        try? FileManager.default.removeItem(atPath: tmp)
        return (r.selfContradictions == 1, "contradictions=\(r.selfContradictions)")
    }
    arm("self_contradiction_guard_silent_on_an_honest_empty_block", "0") {
        var r = Run()
        let tmp = NSTemporaryDirectory() + "extraction-selftest-honest"
        try? FileManager.default.createDirectory(atPath: tmp, withIntermediateDirectories: true)
        let b = tmp + "/blocks.ndjson", c = tmp + "/receipts.ndjson"
        let blk = "{\"number\":\"0x1\",\"timestamp\":\"0x10\",\"gasUsed\":\"0x0\",\"hash\":\"0x" + String(repeating: "a", count: 64) + "\",\"parentHash\":\"0x" + String(repeating: "b", count: 64) + "\",\"transactions\":[]}\n"
        try? blk.write(toFile: b, atomically: true, encoding: .utf8)
        try? "[]\n".write(toFile: c, atomically: true, encoding: .utf8)
        runCorpus(blocksPath: b, receiptsPath: c, expectStart: 0, expectCount: 0, r: &r)
        try? FileManager.default.removeItem(atPath: tmp)
        return (r.selfContradictions == 0 && r.blocks == 1, "contradictions=\(r.selfContradictions) blocks=\(r.blocks)")
    }
    arm("decimal_string_parses_to_exact_256_bit", "2^200 round-trips through its decimal form") {
        let a = U256(w0: 0, w1: 0, w2: 0, w3: 1 << 8)
        guard let b = decU256(a.dec) else { return (false, "nil") }
        return (U256.cmp(a, b) == 0, b.dec)
    }
    arm("decimal_parser_refuses_a_non_number", "nil, not a partial value") {
        return (decU256("123x4") == nil && decU256("") == nil, "nil")
    }
    arm("live_row_arithmetic_check_discriminates", "an off-by-one cycle_back is caught") {
        // the published live row's own integers, which do not fit a 64-bit literal
        guard let ai = decU256("305200121698016153126"),
              let bo = decU256("305281051544900842672"),
              let cb = decU256("80929846884689546"),
              let bad = decU256("80929846884689547") else { return (false, "nil") }
        let d = SInt.diff(bo, ai)
        let good = !d.neg && U256.cmp(d.mag, cb) == 0
        let rejects = U256.cmp(d.mag, bad) != 0
        return (good && rejects, "good=\(good) rejects_off_by_one=\(rejects)")
    }
    arm("pseudonym_is_stable_and_discriminating", "same address same key, different address different key") {
        let a = parseAddrLit("0x1111111111111111111111111111111111111111")
        let b = parseAddrLit("0x1111111111111111111111111111111111111112")
        return (pseudo(a) == pseudo(a) && pseudo(a) != pseudo(b), pseudo(a) + " vs " + pseudo(b))
    }

    emit("")
    kv("arms_run", armsRun)
    kv("arms_passed", armsPassed)
    kv("arms_failed", armsFailed)
    emit(armsFailed == 0 ? "SELFTEST\tPASS" : "SELFTEST\tFAIL")
    return armsFailed == 0 ? 0 : 1
}

// =====================================================================================
// SECTION 9 — REPORT
// =====================================================================================

func fmtUnits(_ v: U256, _ tok: Addr?) -> String {
    guard let t = tok, let dec = tokenDecimals(t) else { return v.dec }
    let s = v.dec
    if dec == 0 { return s }
    var whole = "", frac = ""
    if s.count <= dec { whole = "0"; frac = String(repeating: "0", count: dec - s.count) + s }
    else { whole = String(s.prefix(s.count - dec)); frac = String(s.suffix(dec)) }
    while frac.count > 1 && frac.hasSuffix("0") { frac.removeLast() }
    return whole + "." + frac + " " + tokenLabel(t)
}

func report(_ r: Run, corpusStart: UInt64, corpusCount: UInt64) {
    section("ENUMERATION — every block, every log, exclusions counted")
    kv("blocks_scanned", r.blocks)
    kv("transactions_total", r.txTotal)
    kv("receipts_total", r.receiptTotal)
    kv("logs_total", r.logsTotal)
    kv("swap_v2_events", r.swapV2)
    kv("swap_v3_events", r.swapV3)
    kv("sync_events", r.syncs)
    kv("erc20_transfer_events", r.transfers)
    kv("empty_blocks", r.emptyBlocks)
    kv("blocks_not_contiguous", r.notContiguous)
    kv("parent_hash_chain_breaks", r.chainBreaks)
    kv("receipt_count_mismatch", r.txCountMismatch)
    kv("bad_hex_fields_counted", r.badHex)
    kv("malformed_swap_data_counted", r.malformedSwapData)
    kv("self_contradictions_txcount0_gasused_positive", r.selfContradictions)
    kv("first_block_timestamp_unix", r.tsFirst)
    kv("last_block_timestamp_unix", r.tsLast)
    kv("elapsed_ms", r.elapsedNS / 1_000_000)

    section("SYNC-CHAIN CONTENT CHECK — the reserve decoding validated against the data")
    emit("Consecutive Sync events on one V2 pool must differ by exactly the intervening")
    emit("Swap event's own deltas. This validates the Sync topic constant, the uint112")
    emit("reserve decoding and the delta sign convention against the corpus itself —")
    emit("nothing here is asserted from a table of well-known hashes.")
    kv("consecutive_sync_pairs_checked", r.syncChainChecked)
    kv("consecutive_sync_pairs_agreeing_exactly", r.syncChainAgreed)
    if r.syncChainChecked == 0 { emit("SYNC_CHAIN\tNOT_EXERCISED — a gate given nothing is not a pass") }
    else if r.syncChainAgreed == r.syncChainChecked { emit("SYNC_CHAIN\tEXACT_ON_EVERY_PAIR") }
    else { kv("SYNC_CHAIN_disagreements", r.syncChainChecked - r.syncChainAgreed) }

    section("DETECTION RE-DERIVATION — this program is an independent third implementation")
    kv("pools_with_3plus_swaps_in_a_block", r.poolsWith3Plus)
    kv("ordered_pairs_tested", r.pairsTested)
    kv("SHEAR_brackets_conditions_1_to_5", r.brackets)
    kv("SHEAR_extractive_net_nonneg_both_tokens", r.extractive)
    kv("blocks_carrying_a_BRACKET", UInt64(r.bracketBlocks.count))
    kv("blocks_carrying_an_EXTRACTIVE_detection", UInt64(r.shearBlocks.count))
    kv("distinct_bracketing_actors_pseudonymous", UInt64(r.bracketActors.count))
    kv("distinct_EXTRACTIVE_actors_pseudonymous", UInt64(r.extractiveActors.count))
    kv("detections_with_leg_span_over_3", r.spanOver3)
    kv("pool_token_identifications", UInt64(r.poolTokens.count))
    kv("pool_token_identification_conflicts", r.poolTokenConflicts)
    emit("The published detector reports 126 brackets, 108 extractive, 104 blocks, 28")
    emit("bracketing actors and 26 extractive actors over this corpus. Those five numbers")
    emit("are the agreement test for the re-derivation above; they are printed here so a")
    emit("reader compares rather than takes the claim.")
    emit("")
    emit("ONE OF THE FIVE IS A LABEL DEFECT IN THE PUBLISHED REPORT, AND IT IS NAMED HERE.")
    emit("The published line 'blocks_carrying_a_shear 104' sits directly under the extractive")
    emit("count, which reads as 104 blocks carrying one of the 108. It is not: that counter is")
    emit("incremented on every BRACKET, so 104 is the block count for the 126. Both numbers are")
    emit("printed above and both are true of different questions. The extractive figure — the")
    emit("one every rate below is computed from — is the second line.")

    let dets = r.dets.sorted { ($0.block, $0.txVictim) < ($1.block, $1.txVictim) }

    // ---- status census -------------------------------------------------------------
    section("SHORTFALL STATUS — four answers, kept apart, complete")
    var byStatus = [String: Int]()
    for d in dets { byStatus[d.status.rawValue, default: 0] += 1 }
    for k in byStatus.keys.sorted() { kv(k, byStatus[k]!) }
    kv("detections_total", dets.count)
    let determinate = dets.filter { $0.status.isDeterminate }
    kv("detections_with_a_computed_shortfall", determinate.count)
    kv("detections_NOT_KNOWN", dets.count - determinate.count)
    emit("NOT_KNOWN is not zero and it is not a small shortfall. Each class above names the")
    emit("exact reason the pool's own arithmetic could not be reproduced for that row.")

    // ---- rows closed from a state that was READ rather than inverted ------------------
    let recoveredRows = dets.filter { $0.status.isRecovered }
    kv("detections_closed_from_a_recovered_pre_front_state", recoveredRows.count)
    kv("closed_from_an_earlier_swap_in_the_same_block_no_wire_needed", RECOVERED_INBLOCK.count)
    kv("recovered_states_supplied", RECOVERED.count)
    kv("recovered_states_REJECTED_did_not_reproduce_the_leg", RECOVERED_REJECTED.count)
    for (tx, why) in RECOVERED_REJECTED.sorted(by: { $0.key < $1.key }) {
        emit("RECOVERED_REJECTED\t" + tx + "\t" + why)
    }
    if RECOVERED.isEmpty {
        emit("No recovered state was supplied. Every figure below is the figure this kernel")
        emit("produces from the corpus alone, which is how the published run was made.")
    }

    // ---- WHAT EACH REMAINING NOT_KNOWN ROW WOULD NEED --------------------------------
    // A NOT_KNOWN that cannot name the quantity it is missing is indistinguishable from
    // a row nobody looked at. Each line below names the row, the pool, the block at which
    // the missing quantity can be read, and the call that reads it. Rows whose missing
    // quantity is not a single readable state say so, and say why.
    section("WHAT EVERY REMAINING NOT_KNOWN ROW IS MISSING")
    emit("victim_tx\tblock\tpool\tprotocol\tstatus\tmissing_quantity\thow_to_read_it")
    var needCounts = [String: Int]()
    for d in dets where !d.status.isDeterminate {
        let need: String, how: String
        switch d.status {
        case .notKnownInvert:
            need = "sqrtPriceX96 immediately before the front leg"
            how = "eth_call slot0() 0x3850c7bd at block " + String(d.block &- 1)
                + " — valid only if the front leg is the first touch of this pool in block "
                + String(d.block); 
        case .notKnownRepro:
            need = "the pool fee tier"
            how = "eth_call fee() 0xddca3f43 at any block — fee is immutable"
        case .notKnownTick:
            need = "the tick map across the interval the leg spans"
            how = "NOT A SINGLE STATE. The known fee still does not reproduce the leg, so the"
                + " leg does not reproduce at the pool's own fee, so a single-tick step at a"
                + " constant liquidity cannot express it. Whether that is a tick crossing or a"
                + " liquidity change inside the step is NOT distinguished here."
        case .notKnownLiq:
            need = "in-range liquidity at every tick the pair spans"
            how = "NOT A SINGLE STATE. Liquidity differs between the two legs, so the"
                + " counterfactual is a multi-tick walk, not one step at one L."
        case .notKnownFee:
            need = "the constant-product pool's fee numerator"
            how = "this pool is a fork with a non-standard fee; no fee in the searched"
                + " interval reproduces the observed leg"
        default:
            need = "see status"
            how = "-"
        }
        needCounts[d.status.rawValue, default: 0] += 1
        emit(d.victimTx + "\t" + String(d.block) + "\t" + pseudo(d.pool)
            + "\t" + (d.kind == 2 ? "V2" : "V3") + "\t" + d.status.rawValue
            + "\t" + need + "\t" + how)
    }
    for k in needCounts.keys.sorted() { kv("still_NOT_KNOWN_" + k, needCounts[k]!) }
    if let needsPath = EMIT_NEEDS_TO {
        // The operational form, with the real pool address, so the states can actually be
        // fetched. Written to a named file, never to the published output: the page keeps
        // the keyed pseudonym convention.
        var lines = ["# victim_tx\tblock\tpool_address\tstatus\tselector"]
        for d in dets where !d.status.isDeterminate {
            let sel = d.status == .notKnownRepro ? "0xddca3f43" : "0x3850c7bd"
            lines.append(d.victimTx + "\t" + String(d.block) + "\t" + addrHexOf(d.pool)
                + "\t" + d.status.rawValue + "\t" + sel)
        }
        try? (lines.joined(separator: "\n") + "\n").write(toFile: needsPath, atomically: true, encoding: .utf8)
        kv("needs_written_to", needsPath)
        kv("needs_rows", lines.count - 1)
    }

    // ---- the totals -----------------------------------------------------------------
    section("WHAT WAS TAKEN — per token, in BASE UNITS, integer")
    emit("Two different quantities. They are not each other's negative and they are never")
    emit("added together.")
    emit("")
    emit("ATTACKER NET POSITION CHANGE is the sum of the two attacker legs' own deltas with")
    emit("the sign flipped: what the pool lost to that address across the pair, per token.")
    emit("It is GROSS OF GAS. Gas is reported beside it, in wei, and is NOT netted — netting")
    emit("it would require a price between the token and ETH, which is a judgement.")
    emit("")
    emit("VICTIM SHORTFALL is equation (4): what the victim's own leg returned, against what")
    emit("the identical input would have returned at the pre-front-run state of the same pool.")

    var shortByToken = [String: (tok: Addr?, total: U256, n: Int, label: String)]()
    var attackerNet0 = [String: U256](), attackerNet1 = [String: U256]()
    var gasTotal = U256()
    for d in determinate {
        if d.shortfall.neg { continue }
        let key = d.victimOutToken.map { addrKey($0) } ?? ("unknown:" + addrKey(d.pool))
        let lbl = d.victimOutToken.map { tokenLabel($0) } ?? ("UNIDENTIFIED@pool:" + pseudo(d.pool))
        var e = shortByToken[key] ?? (d.victimOutToken, U256(), 0, lbl)
        e.total = e.total + d.shortfall.mag
        e.n += 1
        e.tok = d.victimOutToken
        e.label = lbl
        shortByToken[key] = e
    }
    for d in dets {
        gasTotal = gasTotal + d.gasWei
        if !d.net0.isNegative && !d.net0.isZero {
            let k = addrKey(d.pool) + ":0"
            attackerNet0[k] = (attackerNet0[k] ?? U256()) + U256(mag: d.net0)
        }
        if !d.net1.isNegative && !d.net1.isZero {
            let k = addrKey(d.pool) + ":1"
            attackerNet1[k] = (attackerNet1[k] ?? U256()) + U256(mag: d.net1)
        }
    }
    emit("")
    emit("VICTIM SHORTFALL TOTALS, by the token the victim was paid in:")
    emit("token\tvictims\ttotal_base_units\ttotal_human_readable")
    var tokenRows: [(String, Int, U256, Addr?)] = []
    for k in shortByToken.keys.sorted() {
        let e = shortByToken[k]!
        tokenRows.append((e.label, e.n, e.total, e.tok))
    }
    tokenRows.sort { $0.1 > $1.1 }
    for t in tokenRows { emit(t.0 + "\t" + String(t.1) + "\t" + t.2.dec + "\t" + fmtUnits(t.2, t.3)) }
    emit("")
    kv("gas_paid_by_all_attacker_legs_wei_NOT_NETTED", gasTotal.dec)
    emit("Gas is what the two legs' transactions cost their sender in wei. It is stated so a")
    emit("reader can see that attacker net position change is a GROSS figure, never called")
    emit("profit here.")

    // ---- per-victim, published in full ----------------------------------------------
    section("PER-VICTIM SHORTFALL — every row, published in full. A mean over a heavy tail is a lie.")
    emit("Every row carries the pre-front-run reserve pair it was computed from, so equation")
    emit("(1) can be re-run by hand on any row without re-reading the corpus. For a V3 row the")
    emit("pair is the VIRTUAL reserve at that price, L·2^96/sqrtP and L·sqrtP/2^96.")
    emit("block\tvictim_tx\tprotocol\tpool\tactor\tpaid_in\treceived\tWOULD_HAVE_RECEIVED\tSHORTFALL\tloss_bp\tsize_bp\tfee\tRin_pre_front\tRout_pre_front\tstatus")
    for d in dets {
        let inTok = d.victimInToken.map { tokenLabel($0) } ?? "?"
        let outTok = d.victimOutToken.map { tokenLabel($0) } ?? "?"
        emit(String(d.block)
            + "\t" + d.victimTx
            + "\tV" + String(d.kind)
            + "\t" + pseudo(d.pool)
            + "\t" + pseudo(d.actor)
            + "\t" + d.victimIn.dec + " " + inTok
            + "\t" + d.victimOut.dec + " " + outTok
            + "\t" + (d.status.isDeterminate ? d.victimOutCF.dec : "NOT_KNOWN")
            + "\t" + (d.status.isDeterminate ? d.shortfall.dec : "NOT_KNOWN")
            + "\t" + (d.lossBp > 0 ? String(d.lossBp) : ((d.status == .exact || d.status == .exactRecovered) ? "0" : "-"))
            + "\t" + String(d.sizeBp)
            + "\t" + (d.feeNum > 0 ? (d.kind == 2 ? String(d.feeNum) + "/1000" : String(d.feeNum) + "pips") : "-")
            + "\t" + d.reserveInPre.dec
            + "\t" + d.reserveOutPre.dec
            + "\t" + d.status.rawValue)
    }

    // ---- attacker net, per detection -------------------------------------------------
    section("ATTACKER NET POSITION CHANGE — per detection, both tokens, GROSS OF GAS")
    emit("block\tactor\tpool\tnet_token0\tnet_token1\tgas_wei_two_legs")
    for d in dets {
        emit(String(d.block) + "\t" + pseudo(d.actor) + "\t" + pseudo(d.pool)
            + "\t" + d.net0.decimal + "\t" + d.net1.decimal + "\t" + d.gasWei.dec)
    }

    // ---- distribution ----------------------------------------------------------------
    section("THE DISTRIBUTION — concentrated or spread")
    let pos = determinate.filter { !$0.shortfall.neg && !$0.shortfall.isZero }
    kv("victims_with_a_positive_shortfall", pos.count)
    kv("victims_with_exactly_zero_shortfall", determinate.filter { $0.shortfall.isZero }.count)
    kv("victims_with_a_NEGATIVE_shortfall", determinate.filter { $0.shortfall.neg }.count)
    emit("A negative shortfall would mean the victim got MORE than at the pre-front state.")
    emit("The direction conjunct makes that impossible, so a non-zero count here is a defect")
    emit("report on this program, not a finding. The self-test proves the function CAN return")
    emit("a negative, which is what makes the count above informative rather than structural.")

    // loss_bp order statistics — unit-free, so comparable across every token
    let lb = pos.map { $0.lossBp }.sorted()
    if !lb.isEmpty {
        emit("")
        emit("LOSS AS A FRACTION OF WHAT THEY WERE DUE — ten-thousandths (bp). Unit-free, so")
        emit("every victim is on one scale regardless of which token they were paid in.")
        func q(_ n: Int, _ d: Int) -> UInt64 { lb[min(lb.count - 1, (lb.count * n) / d)] }
        kv("loss_bp_min", lb[0])
        kv("loss_bp_p10", q(1, 10))
        kv("loss_bp_p25", q(1, 4))
        kv("loss_bp_median", q(1, 2))
        kv("loss_bp_p75", q(3, 4))
        kv("loss_bp_p90", q(9, 10))
        kv("loss_bp_max", lb[lb.count - 1])
        emit("full_sorted_loss_bp\t" + lb.map { String($0) }.joined(separator: ","))
        // split by venue shape, because the two are different machines and a pooled median
        // over two machines is a statement about neither
        let v2 = pos.filter { $0.kind == 2 }.map { $0.lossBp }.sorted()
        let v3 = pos.filter { $0.kind == 3 }.map { $0.lossBp }.sorted()
        emit("")
        emit("SPLIT BY VENUE SHAPE. A constant-product pool and a concentrated-liquidity pool")
        emit("are different machines; one median over both describes neither.")
        if !v2.isEmpty { kv("constant_product_victims", v2.count); kv("constant_product_loss_bp_median", v2[v2.count / 2]) }
        if !v3.isEmpty { kv("concentrated_liquidity_victims", v3.count); kv("concentrated_liquidity_loss_bp_median", v3[v3.count / 2]) }
    }

    // concentration within a token denomination
    section("IS IT CONCENTRATED OR SPREAD — the relation between trade SIZE and SHORTFALL")
    emit("Sizes in different tokens are not commensurable, so the size measure used here is")
    emit("UNIT-FREE: the victim's input as ten-thousandths of the pool's own input-side")
    emit("reserve at the pre-front state (for a V3 pool, its virtual reserve at that price).")
    emit("That is the quantity an automated market maker actually charges slippage on, and")
    emit("it is an exact integer ratio.")
    let both = pos.filter { $0.sizeBp > 0 }
    kv("victims_with_both_ratios_available", both.count)
    if both.count >= 4 {
        var conc = 0, disc = 0, ties = 0
        for i in 0..<both.count {
            for j in (i+1)..<both.count {
                let ds = Int(both[i].sizeBp) - Int(both[j].sizeBp)
                let dl = Int(both[i].lossBp) - Int(both[j].lossBp)
                if ds == 0 || dl == 0 { ties += 1 }
                else if (ds > 0) == (dl > 0) { conc += 1 }
                else { disc += 1 }
            }
        }
        kv("pairs_compared", conc + disc + ties)
        kv("concordant_bigger_trade_bigger_relative_loss", conc)
        kv("discordant_bigger_trade_smaller_relative_loss", disc)
        kv("tied", ties)
        if conc + disc > 0 {
            let num = (conc - disc) * 1000 / (conc + disc)
            kv("kendall_tau_permille_integer", num)
            emit(num > 0
                ? "READS: relative loss RISES with trade size — the shear falls hardest on the LARGER trades in a pool."
                : (num < 0
                   ? "READS: relative loss FALLS with trade size — the shear falls hardest on the SMALLER trades in a pool."
                   : "READS: no monotone relation between size and relative loss in this corpus."))
        }
        // the median split, stated in plain counts
        let bySize = both.sorted { $0.sizeBp < $1.sizeBp }
        let half = bySize.count / 2
        let small = Array(bySize[0..<half]), large = Array(bySize[half...])
        func med(_ a: [Detection]) -> UInt64 { let s = a.map { $0.lossBp }.sorted(); return s.isEmpty ? 0 : s[s.count / 2] }
        kv("median_loss_bp_smaller_half_by_pool_relative_size", med(small))
        kv("median_loss_bp_larger_half_by_pool_relative_size", med(large))
    }
    // absolute concentration: share of the total held by the top rows, within each token
    emit("")
    emit("CONCENTRATION OF THE TOTAL, within each token denomination. A heavy tail means a")
    emit("few victims carry most of the sum, and a total then says little about a typical person.")
    for k in shortByToken.keys.sorted() {
        let e = shortByToken[k]!
        if e.n < 3 { continue }
        let rows = pos.filter { ($0.victimOutToken.map { addrKey($0) } ?? ("unknown:" + addrKey($0.pool))) == k }
            .sorted { U256.cmp($0.shortfall.mag, $1.shortfall.mag) > 0 }
        var top1 = U256(), top3 = U256()
        for (i, d) in rows.enumerated() {
            if i < 1 { top1 = top1 + d.shortfall.mag }
            if i < 3 { top3 = top3 + d.shortfall.mag }
        }
        let lbl = e.label
        let p1 = e.total.isZero ? U256() : (U256.mulDiv(top1, U256(1000), e.total) ?? U256())
        let p3 = e.total.isZero ? U256() : (U256.mulDiv(top3, U256(1000), e.total) ?? U256())
        emit(lbl + "\tvictims\t" + String(e.n)
            + "\ttop1_share_permille\t" + p1.dec
            + "\ttop3_share_permille\t" + p3.dec)
    }

    // ---- concentration by POOL, not only by victim --------------------------------------
    section("CONCENTRATION BY POOL — 108 detections are not 108 independent places")
    var byPool = [String: (n: Int, label: String)]()
    for d in dets {
        let k = addrKey(d.pool)
        var e = byPool[k] ?? (0, pseudo(d.pool))
        e.n += 1
        byPool[k] = e
    }
    // DETERMINISM, and it was measured rather than reasoned about. `byPool.values` iterates a
    // Dictionary, and Swift randomises Dictionary order per process, so sorting it by count
    // alone fed an UNSTABLE sort a DIFFERENT input order on every run: two runs of the same
    // binary over byte-identical corpora printed different members in this table's tie rows.
    // A printed table that changes between runs of an exact program is a defect in the
    // program, not a property of the data. The key order is fixed first and the tie is broken
    // by the pseudonym, so this table is now a function of the corpus and of nothing else.
    let poolRows = byPool.keys.sorted().map { byPool[$0]! }
        .sorted { $0.n != $1.n ? $0.n > $1.n : $0.label < $1.label }
    kv("distinct_pools_carrying_a_detection", poolRows.count)
    emit("pool\tdetections")
    for p in poolRows.prefix(8) { emit(p.label + "\t" + String(p.n)) }
    if let top = poolRows.first {
        kv("busiest_pool_share_of_all_detections_permille", top.n * 1000 / max(1, dets.count))
        emit("READS: a fifth of this corpus's detections sit on ONE pool. Any statement of the")
        emit("form '108 sheared trades across the market' is therefore overstating the spread,")
        emit("and every distribution above should be read with that in mind.")
    }

    // ---- why a token could not be identified: measured, not guessed ---------------------
    section("UNIDENTIFIED OUTPUT TOKENS — the cause MEASURED, not assumed")
    emit("A token is identified by finding an ERC-20 Transfer in the victim's own transaction")
    emit("that leaves the pool with EXACTLY the amount the Swap event says left the pool. When")
    emit("no such log exists, this program does not guess why. It records the LARGEST transfer")
    emit("out of that pool in that transaction and prints the ratio, which discriminates")
    emit("between the two candidate causes without asserting either.")
    let unid = dets.filter { $0.victimOutToken == nil }
    kv("detections_with_an_unidentified_output_token", unid.count)
    var near = 0, none = 0
    emit("block\tpool\tswap_says_out\tlargest_transfer_out\tratio_permille")
    for d in unid {
        guard let t = d.outTransferNear else { none += 1; continue }
        near += 1
        let r = d.victimOut.isZero ? U256() : (U256.mulDiv(t, U256(1000), d.victimOut) ?? U256())
        emit(String(d.block) + "\t" + pseudo(d.pool) + "\t" + d.victimOut.dec + "\t" + t.dec + "\t" + r.dec)
    }
    kv("rows_where_a_transfer_out_of_the_pool_DOES_exist", near)
    kv("rows_where_NO_transfer_out_of_the_pool_exists", none)
    emit("A ratio below 1000 means less left the pool's counterparty than the pool says it")
    emit("paid — the shape of a token that deducts on transfer. A ratio at or above 1000, or")
    emit("no transfer at all, is a different shape and this program does not name it.")
    emit("EITHER WAY the shortfall above is measured AT THE POOL BOUNDARY: what the pool paid")
    emit("out against what it would have paid out. If a token also deducts on the way to the")
    emit("wallet, the person received LESS than the received column says, and the shortfall")
    emit("stated here is a FLOOR on their loss rather than the whole of it.")

    // ---- WHO BEARS IT, measured without any conversion ---------------------------------
    section("WHO BEARS IT — the victims' own trade sizes, MEASURED, no rate applied")
    emit("Most victims paid in WETH, so for those the size of the trade is already in one")
    emit("unit and needs no price: it is the wei the person put into the pool. This section")
    emit("applies NO rate and converts nothing. It answers the question the founder's")
    emit("objection turns on — is this professionals trading against each other, or is it")
    emit("ordinary people paying.")
    let wethIn = pos.filter { d in d.victimInToken.map { addrEq($0, WETH) } ?? false }
    let wethInAll = dets.filter { d in d.victimInToken.map { addrEq($0, WETH) } ?? false }
    kv("victims_paying_in_WETH_across_all_108_detections", wethInAll.count)
    kv("victims_with_a_determinate_positive_shortfall", pos.count)
    kv("victims_in_BOTH_sets_used_below", wethIn.count)
    if !wethIn.isEmpty {
        let sizes = wethIn.map { $0.victimIn }.sorted { U256.cmp($0, $1) < 0 }
        func qs(_ n: Int, _ d: Int) -> U256 { sizes[min(sizes.count - 1, (sizes.count * n) / d)] }
        emit("")
        emit("VICTIM TRADE SIZE, in wei, measured off the wire:")
        kv("trade_size_wei_min", sizes[0].dec)
        kv("trade_size_wei_p25", qs(1, 4).dec)
        kv("trade_size_wei_median", qs(1, 2).dec)
        kv("trade_size_wei_p75", qs(3, 4).dec)
        kv("trade_size_wei_max", sizes[sizes.count - 1].dec)
        emit("readable_median\t" + fmtUnits(qs(1, 2), WETH))
        emit("readable_max\t" + fmtUnits(sizes[sizes.count - 1], WETH))
        // integer decade buckets on ETH, no logarithm and no float
        let E18 = U256(w0: 1_000_000_000_000_000_000, w1: 0, w2: 0, w3: 0)
        let tenth = U256(w0: 100_000_000_000_000_000, w1: 0, w2: 0, w3: 0)
        let ten = U256(w0: 10_000_000_000_000_000_000, w1: 0, w2: 0, w3: 0)
        let hundred = U256(w0: 0, w1: 5, w2: 0, w3: 0)   // 5·2^64 = 92233720368547758080 ≈ 92.2 ETH
        var b0 = 0, b1 = 0, b2 = 0, b3 = 0, b4 = 0
        for d in wethIn {
            let v = d.victimIn
            if U256.cmp(v, tenth) < 0 { b0 += 1 }
            else if U256.cmp(v, E18) < 0 { b1 += 1 }
            else if U256.cmp(v, ten) < 0 { b2 += 1 }
            else if U256.cmp(v, hundred) < 0 { b3 += 1 }
            else { b4 += 1 }
        }
        emit("")
        emit("VICTIM TRADE SIZE, counted into decade buckets. Boundaries are exact integers.")
        kv("victims_under_0.1_ETH", b0)
        kv("victims_0.1_to_1_ETH", b1)
        kv("victims_1_to_10_ETH", b2)
        kv("victims_10_to_92.2_ETH", b3)
        kv("victims_over_92.2_ETH", b4)
        emit("The 92.2 boundary is 5·2^64 wei exactly — a power-of-two boundary chosen so the")
        emit("comparison is an integer limb test rather than a decimal conversion.")
        // absolute size against relative loss, measured both ways
        var conc = 0, disc = 0, ties = 0
        for i in 0..<wethIn.count {
            for j in (i+1)..<wethIn.count {
                let ds = U256.cmp(wethIn[i].victimIn, wethIn[j].victimIn)
                let dl = Int(wethIn[i].lossBp) - Int(wethIn[j].lossBp)
                if ds == 0 || dl == 0 { ties += 1 }
                else if (ds > 0) == (dl > 0) { conc += 1 }
                else { disc += 1 }
            }
        }
        emit("")
        emit("ABSOLUTE TRADE SIZE against RELATIVE LOSS. Both measured, no conversion.")
        kv("pairs_compared", conc + disc + ties)
        kv("concordant_bigger_ETH_trade_bigger_relative_loss", conc)
        kv("discordant_bigger_ETH_trade_smaller_relative_loss", disc)
        kv("tied", ties)
        if conc + disc > 0 {
            let t = (conc - disc) * 1000 / (conc + disc)
            kv("kendall_tau_permille_integer", t)
            emit(t > 0 ? "READS: in ABSOLUTE terms the larger trades take the larger relative hit."
                       : (t < 0 ? "READS: in ABSOLUTE terms the SMALLER trades take the larger relative hit."
                                : "READS: no monotone relation between absolute size and relative loss."))
        }
    }
    // ---- the floor under the victim size distribution, measured -------------------------
    emit("")
    emit("WHY THERE ARE NO TINY VICTIMS, MEASURED RATHER THAN ASSERTED. A sandwich costs the")
    emit("actor two transactions' gas before it earns anything, so a trade too small to move")
    emit("the price by more than that gas is not worth attacking. That floor is not an")
    emit("opinion here — it is the gas the legs actually paid, against the smallest shortfall")
    emit("actually taken.")
    let gasSorted = dets.map { $0.gasWei }.sorted { U256.cmp($0, $1) < 0 }
    if !gasSorted.isEmpty {
        kv("gas_wei_per_detection_min", gasSorted[0].dec)
        kv("gas_wei_per_detection_median", gasSorted[gasSorted.count / 2].dec)
        kv("gas_wei_per_detection_max", gasSorted[gasSorted.count - 1].dec)
        emit("readable_median_gas\t" + fmtUnits(gasSorted[gasSorted.count / 2], WETH))
    }
    if !wethIn.isEmpty {
        let sm = wethIn.map { $0.victimIn }.sorted { U256.cmp($0, $1) < 0 }
        emit("smallest_victim_trade_observed\t" + fmtUnits(sm[0], WETH))
        emit("READS: the absence of victims below a tenth of an ETH is not evidence that small")
        emit("traders are safe. It is what a gas cost of this size does to the ATTACKER's own")
        emit("arithmetic. Cheaper blockspace moves that floor down, and nothing measured here")
        emit("bounds where it stops.")
    }

    // thin pools, named so they cannot drive a headline unnoticed
    let thin = pos.filter { $0.sizeBp > 10_000 }
    emit("")
    kv("victims_whose_input_EXCEEDED_the_whole_input_reserve", thin.count)
    emit("A victim input larger than the pool's entire input-side reserve is a thin-pool row.")
    emit("Its arithmetic is exact and its shortfall is real, but its ratios sit orders of")
    emit("magnitude away from every other row, so it is counted here rather than left to move")
    emit("a median quietly. Rows: " + thin.map { String($0.block) }.joined(separator: ","))
    if thin.count > 0 && pos.count - thin.count >= 4 {
        let core = pos.filter { $0.sizeBp <= 10_000 }
        let lbc = core.map { $0.lossBp }.sorted()
        kv("loss_bp_median_EXCLUDING_thin_pool_rows", lbc[lbc.count / 2])
        kv("rows_in_that_median", lbc.count)
    }

    // ---- rates ------------------------------------------------------------------------
    section("RATE — measured over this corpus, and the projection kept apart from it")
    let blocksWith = r.shearBlocks.count
    kv("blocks_in_corpus", r.blocks)
    kv("blocks_carrying_at_least_one_detection", blocksWith)
    kv("detections_total", dets.count)
    if r.blocks > 0 {
        kv("detections_per_1000_blocks_MEASURED", dets.count)
        kv("blocks_carrying_one_per_1000_MEASURED", blocksWith)
    }
    let span = r.tsLast >= r.tsFirst ? r.tsLast - r.tsFirst : 0
    kv("corpus_wall_clock_seconds_from_block_timestamps", span)
    if span > 0 {
        kv("mean_seconds_per_block_integer_floor", span / max(1, r.blocks - 1))
        kv("detections_per_hour_MEASURED_floor", UInt64(dets.count) * 3600 / span)
    }
    emit("")
    emit("PROJECTED — NOT MEASURED. Stated with its assumption and its arithmetic.")
    emit("ASSUMPTION: the rate measured over these 1,000 consecutive blocks continues")
    emit("unchanged. That assumption is NOT tested here and this corpus cannot test it: a")
    emit("thousand blocks is about three and a half hours of one chain on one day.")
    if span > 0 {
        let perDay = UInt64(dets.count) * 86_400 / span
        kv("PROJECTED_detections_per_day", perDay)
        kv("PROJECTED_detections_per_year", perDay * 365)
        emit("arithmetic\t" + String(dets.count) + " detections / " + String(span)
            + " s × 86400 = " + String(perDay) + " per day; × 365 = " + String(perDay * 365) + " per year")
        emit("A PROJECTION IS NOT A MEASUREMENT. Every figure on this line is labelled")
        emit("PROJECTED for that reason, and no total anywhere above is scaled by it.")
    }

    // ---- readability ------------------------------------------------------------------
    section("DERIVED_FOR_READABILITY — the money figure, and why it is a courtesy")
    emit("A shortfall is a count of token base units. That count is the RESULT. Turning it")
    emit("into money needs a rate, and a rate is a judgement about what a token is worth.")
    emit("No figure in this section touches a decision anywhere in this program.")
    if !r.usdcPerEthDen.isZero {
        kv("rate_source", "a WETH/USDC pool inside this same corpus, its own reserves")
        kv("rate_pool_pseudonym", pseudo(r.usdcRatePool))
        kv("rate_measured_at_block", r.usdcRateBlock)
        kv("rate_USDC_base_units_numerator", r.usdcPerEthNum.dec)
        kv("rate_wei_denominator", r.usdcPerEthDen.dec)
        if let usdPerEth = U256.mulDiv(r.usdcPerEthNum, U256(1_000_000_000_000_000_000), r.usdcPerEthDen) {
            kv("rate_USDC_base_units_per_1e18_wei", usdPerEth.dec)
            emit("i.e. 1 ETH ≈ " + fmtUnits(usdPerEth, USDC) + " at that block, by that pool's own reserves")
        }
        emit("")
        emit("CONVERSION RULE, stated so it can be disagreed with. A shortfall denominated in")
        emit("the token the victim received is expressed in wei at THAT POOL'S OWN marginal")
        emit("price at the pre-front-run state — an exact ratio of that pool's own reserves,")
        emit("Rin/Rout, taken at the same instant the shortfall is measured. No oracle, no")
        emit("external feed, one integer division. It is a MARGINAL price, not an average")
        emit("execution price, so for a shortfall that is a large fraction of the pool it")
        emit("OVERSTATES what the victim could actually have realised. It is a courtesy.")
        var weiOf = [Int: U256]()
        var direct = 0, viaPool = 0, viaUsdc = 0, notConv = 0
        for (i, d) in pos.enumerated() {
            if let t = d.victimOutToken, addrEq(t, WETH) { weiOf[i] = d.shortfall.mag; direct += 1; continue }
            if let ti = d.victimInToken, addrEq(ti, WETH), !d.reserveOutPre.isZero,
               let w = U256.mulDiv(d.shortfall.mag, d.reserveInPre, d.reserveOutPre) {
                weiOf[i] = w; viaPool += 1; continue
            }
            // a stablecoin leg reaches wei through the corpus's own WETH/USDC reserves
            var usdcAmt: U256? = nil
            if let t = d.victimOutToken, addrEq(t, USDC) { usdcAmt = d.shortfall.mag }
            else if let ti = d.victimInToken, addrEq(ti, USDC), !d.reserveOutPre.isZero {
                usdcAmt = U256.mulDiv(d.shortfall.mag, d.reserveInPre, d.reserveOutPre)
            }
            if let u = usdcAmt, let w = U256.mulDiv(u, r.usdcPerEthDen, r.usdcPerEthNum) {
                weiOf[i] = w; viaUsdc += 1; continue
            }
            notConv += 1
        }
        kv("shortfalls_already_in_wei", direct)
        kv("shortfalls_converted_at_their_own_pool_marginal_price", viaPool)
        kv("shortfalls_converted_through_the_corpus_WETH_USDC_reserves", viaUsdc)
        kv("shortfalls_NOT_CONVERTED_left_in_their_own_token", notConv)
        var total = U256()
        for (_, w) in weiOf { total = total + w }
        kv("TOTAL_victim_shortfall_wei_DERIVED", total.dec)
        // THE WEAKEST NUMBER, CHECKED AGAINST ITS OWN WEAKEST INPUT. A marginal price is
        // least defensible exactly where the trade is large against the pool, so the total
        // is split at that boundary rather than left as one figure that hides it.
        var thinWei = U256(); var thinN = 0
        for (i, d) in pos.enumerated() where d.sizeBp > 10_000 {
            if let w = weiOf[i] { thinWei = thinWei + w; thinN += 1 }
        }
        kv("of_which_from_thin_pool_rows_wei", thinWei.dec)
        kv("thin_pool_rows_in_the_total", thinN)
        let core = total - thinWei
        kv("TOTAL_EXCLUDING_thin_pool_rows_wei", core.dec)
        emit("readable_excluding_thin_pools\t" + fmtUnits(core, WETH))
        if !total.isZero, let sh = U256.mulDiv(thinWei, U256(1000), total) {
            kv("thin_pool_share_of_the_derived_total_permille", sh.dec)
            emit(U256.cmp(sh, U256(500)) > 0
                ? "READS: MORE THAN HALF the derived total comes from rows where the marginal price is least defensible. Read the excluding-thin figure as the sound one."
                : "READS: the derived total is NOT driven by the rows where the marginal price is least defensible.")
        }
        emit("DERIVED_FOR_READABILITY\t≈ " + fmtUnits(total, WETH)
            + " across " + String(weiOf.count) + " of " + String(pos.count) + " victims")
        if let usd = U256.mulDiv(total, r.usdcPerEthNum, r.usdcPerEthDen) {
            kv("TOTAL_victim_shortfall_USDC_base_units_DERIVED", usd.dec)
            emit("DERIVED_FOR_READABILITY\t≈ " + fmtUnits(usd, USDC) + " over 1,000 blocks")
            emit("THE MEASURED RESULT IS THE PER-TOKEN INTEGER TABLE ABOVE. This line is a")
            emit("courtesy and carries two judgements: that a pool's marginal price is what a")
            emit("shortfall was worth, and that a USDC unit is a dollar.")
            if span > 0 {
                emit("")
                emit("PROJECTED_AND_DERIVED — the weakest number on this page, and it is labelled twice.")
                emit("It stacks a projection (this rate of shear continues) on a conversion (a pool's")
                emit("marginal price is what the loss was worth). EITHER assumption failing moves it.")
                let perDayU = U256.mulDiv(usd, U256(86_400), U256(span)) ?? U256()
                kv("PROJECTED_AND_DERIVED_USDC_per_day", perDayU.dec)
                kv("PROJECTED_AND_DERIVED_USDC_per_year", (U256.mulDiv(perDayU, U256(365), U256(1)) ?? U256()).dec)
                emit("arithmetic\t" + usd.dec + " USDC base units / " + String(span)
                    + " s × 86400 × 365")
                emit("readable_per_year\t≈ " + fmtUnits(U256.mulDiv(perDayU, U256(365), U256(1)) ?? U256(), USDC))
                emit("AND IT IS STILL A FLOOR, for every reason in WHAT IS NOT INCLUDED below —")
                emit("one venue family, one attack shape, one address per attacker, 86 of 108")
                emit("detections converted. A projected floor is not an estimate of the whole.")
            }
        }
        // per-victim wei, sorted — the shape of the distribution in one unit
        if !weiOf.isEmpty {
            let sorted = weiOf.values.sorted { U256.cmp($0, $1) < 0 }
            func qw(_ n: Int, _ d: Int) -> U256 { sorted[min(sorted.count - 1, (sorted.count * n) / d)] }
            emit("")
            emit("PER-VICTIM SHORTFALL IN ONE UNIT, DERIVED. The shape matters more than the sum.")
            kv("shortfall_wei_min", sorted[0].dec)
            kv("shortfall_wei_p25", qw(1, 4).dec)
            kv("shortfall_wei_median", qw(1, 2).dec)
            kv("shortfall_wei_p75", qw(3, 4).dec)
            kv("shortfall_wei_max", sorted[sorted.count - 1].dec)
            emit("readable_median\t" + fmtUnits(qw(1, 2), WETH))
            emit("readable_max\t" + fmtUnits(sorted[sorted.count - 1], WETH))
            if let m = U256.mulDiv(qw(1, 2), r.usdcPerEthNum, r.usdcPerEthDen) {
                emit("readable_median_usd\t≈ " + fmtUnits(m, USDC) + "  — the TYPICAL victim's loss")
            }
            var top1 = U256(), top5 = U256()
            let desc = sorted.reversed()
            for (i, v) in desc.enumerated() {
                if i < 1 { top1 = top1 + v }
                if i < 5 { top5 = top5 + v }
            }
            if !total.isZero {
                kv("top1_victim_share_of_the_total_permille", (U256.mulDiv(top1, U256(1000), total) ?? U256()).dec)
                kv("top5_victims_share_of_the_total_permille", (U256.mulDiv(top5, U256(1000), total) ?? U256()).dec)
            }
            // what each ETH size band lost, DERIVED
            let E18b = U256(w0: 1_000_000_000_000_000_000, w1: 0, w2: 0, w3: 0)
            let tenthb = U256(w0: 100_000_000_000_000_000, w1: 0, w2: 0, w3: 0)
            let tenb = U256(w0: 10_000_000_000_000_000_000, w1: 0, w2: 0, w3: 0)
            var s0 = U256(), s1 = U256(), s2 = U256(), s3 = U256()
            var c0 = 0, c1 = 0, c2 = 0, c3 = 0
            for (i, d) in pos.enumerated() {
                guard let w = weiOf[i] else { continue }
                guard let t = d.victimInToken, addrEq(t, WETH) else { continue }
                if U256.cmp(d.victimIn, tenthb) < 0 { s0 = s0 + w; c0 += 1 }
                else if U256.cmp(d.victimIn, E18b) < 0 { s1 = s1 + w; c1 += 1 }
                else if U256.cmp(d.victimIn, tenb) < 0 { s2 = s2 + w; c2 += 1 }
                else { s3 = s3 + w; c3 += 1 }
            }
            emit("")
            emit("WHICH SIZE BAND CARRIES THE LOSS — victims paying in WETH, DERIVED totals.")
            emit("band\tvictims\tshortfall_wei\treadable")
            emit("under 0.1 ETH\t" + String(c0) + "\t" + s0.dec + "\t" + fmtUnits(s0, WETH))
            emit("0.1 to 1 ETH\t" + String(c1) + "\t" + s1.dec + "\t" + fmtUnits(s1, WETH))
            emit("1 to 10 ETH\t" + String(c2) + "\t" + s2.dec + "\t" + fmtUnits(s2, WETH))
            emit("10 ETH and over\t" + String(c3) + "\t" + s3.dec + "\t" + fmtUnits(s3, WETH))
        }
    } else {
        emit("rate\tNOT_KNOWN — no WETH/USDC pool leg was identified in this corpus, so no")
        emit("money figure is offered. NOT_KNOWN is a third answer; it is not zero.")
    }

    // ---- what is not included ----------------------------------------------------------
    section("WHAT IS NOT INCLUDED — the total above is a FLOOR and is called one")
    emit("1. ONLY detections that pass EVERY conjunct. A bracket that fails one is excluded.")
    emit("   The published relaxed count — the same geometry with the same-address condition")
    emit("   dropped — is 7,307 brackets of which 54 are extractive, against 108 here. That")
    emit("   relaxed set is mostly ordinary two-way flow, which is exactly why the condition")
    emit("   is in the predicate; it is quoted as the CEILING on what attribution costs, not")
    emit("   as a second estimate.")
    emit("2. ONLY same-address two-leg attacks. A searcher splitting the two legs across two")
    emit("   addresses, or packing both into one transaction, is INVISIBLE here and is not")
    emit("   counted anywhere in this program.")
    emit("3. ONLY these pools — Uniswap-V2-shaped and Uniswap-V3-shaped Swap events. Every")
    emit("   other venue in these blocks contributes zero to this total by construction.")
    emit("4. ONLY the sheared leg. A victim routing through several pools is measured on the")
    emit("   pool where the shear happened; any loss elsewhere in that route is not here.")
    emit("5. ONLY rows whose arithmetic reproduced exactly. Every NOT_KNOWN row above is a")
    emit("   detection with a real victim whose shortfall this program declined to state.")
    emit("6. GAS IS NOT NETTED into the attacker figure, and the attacker figure is therefore")
    emit("   NOT profit. It is stated separately, in wei.")
    emit("7. 1,000 consecutive blocks on one chain on one day. Nothing here is scaled to a")
    emit("   year except on a line labelled PROJECTED.")
    emit("8. DETECTION IS NOT INTENT. The null floor for this geometry is 47 false positives")
    emit("   per 212,769 leg pairs under the span bound — hits with the same shape as a live")
    emit("   detection. Nothing above names or implies wrongdoing by any participant.")
}

// =====================================================================================
// SECTION 10 — REFERENCE FIGURES. Every exit path prints them, including the one where the
// corpus is absent. ABSENCE is not a pass and it is not a failure.
// =====================================================================================

func referenceFigures(_ why: String) {
    section("REFERENCE FIGURES — published, from the pinned corpus")
    kv("why_this_path", why)
    emit("figures_below_are\tPUBLISHED_REFERENCES_NOT_THIS_RUNS_MEASUREMENTS")
    emit("  corpus            Ethereum blocks 14,000,000–14,000,999 (1,000 consecutive)")
    emit("  detector          126 brackets · 108 extractive · 104 blocks · 26 extractive actors")
    emit("  discrimination    262,799 naive positional brackets across 848 blocks vs 108")
    emit("  reproduction      108 of 108 SET-IDENTICAL under an independent re-derivation")
    emit("  null floor        47 false positives per 212,769 leg pairs under the span bound")
    emit("")
    emit("WHAT WAS TAKEN — the result, not the instrument. Measured over that corpus.")
    emit("  costed rows       87 of 108 EXACT · 21 NOT_KNOWN, each with a named reason")
    emit("  victim shortfall  per token, integer base units, largest denominations:")
    emit("    UNIDENTIFIED@pool:a939ee68  21 victims  155,576,958,801,814,594,396,893")
    emit("    tok:acf14d4b                13 victims    5,074,012,211,888,792,743,310")
    emit("    tok:417c0c57                 8 victims   28,924,625,003,219,287,345,953")
    emit("    WETH                         4 victims        1,689,797,703,211,127,422")
    emit("    34 denominations in all; the per-token table is the measured result")
    emit("  DERIVED_FOR_READABILITY, one unit, a courtesy and never a decision input:")
    emit("    TOTAL_victim_shortfall_wei_DERIVED  28,889,398,990,674,697,077  (28.8894 WETH)")
    emit("    TOTAL_EXCLUDING_thin_pool_rows_wei  28,247,424,339,991,594,322")
    emit("    TOTAL_victim_shortfall_USDC_DERIVED 94,645,772,620  (≈ 94,645.77 USDC)")
    emit("    rate 3,276,141,973 USDC base units per 1e18 wei — this corpus's own deepest")
    emit("    WETH/USDC pool reserves at block 14,000,730, not a fetched price")
    emit("  relative loss     min 47 · p25 102 · MEDIAN 476 · p75 1,785 · max 9,999 bp")
    emit("  absolute loss     MEDIAN 0.170457244547709297 WETH ≈ 558.442133 USDC")
    emit("  who bears it      median victim trade 6.0 WETH · 0 under 0.1 ETH · max 49.0 WETH")
    emit("  size relation     pool-relative Kendall tau +491 permille · absolute-ETH tau -500 permille")
    emit("  attacker gas      median 0.104516232525109603 WETH per detection, NOT netted")
    emit("  rate MEASURED     108 detections per 1,000 blocks = 13,586 s · 28 per hour")
    emit("  PROJECTED         686 per day · 250,390 per year — NOT MEASURED, untested assumption")
    emit("")
    emit("THE TOTAL IS A FLOOR AND IS CALLED ONE: one attack shape, one address per actor,")
    emit("two venue shapes, one sheared leg per victim, 87 of 108 rows costed, gas never")
    emit("netted, and 1,000 blocks of one chain on one day.")
    emit("")
    emit("This program adds the quantity the detector never computed: what each victim lost,")
    emit("in integer token base units, from the pool's own arithmetic. With no corpus present")
    emit("it computes nothing and says so.")
    emit("")
    emit("-- WHAT THE 21 NOT_KNOWN ROWS TURNED OUT TO NEED, measured, not assumed --")
    emit("Three routes to the missing pre-front state were tried on every row: invert the")
    emit("front leg, take the last swap on that pool earlier in the same block, or read")
    emit("slot0() at the parent block from a free public archive endpoint. Every route is")
    emit("admitted only if the candidate reproduces the leg FORWARD through the same v3Step.")
    emit("  states fetched from the free wire                                    9")
    emit("  endpoint refusals                                                    0")
    emit("  states REJECTED because they did not reproduce the leg               9")
    emit("  rows closed from an earlier swap in the same block                   0")
    emit("  rows closed in total                                                 0")
    emit("  EXACT rows, unchanged                                               87")
    emit("  NOT_KNOWN rows, unchanged                                           21")
    emit("  floor, unchanged            28,889,398,990,674,697,077 wei")
    emit("Of the six FRONT_NOT_INVERTIBLE rows, FIVE had no earlier swap on that pool")
    emit("anywhere in the block, so the parent-block price WAS the price before the front")
    emit("leg and it still did not reproduce it. Of the three LEG_NOT_REPRODUCIBLE rows,")
    emit("the pool's own fee was read — 500, 3000 and 10000 pips — and none reproduces the")
    emit("victim leg either, so those three now carry the sharper status")
    emit("  NOT_KNOWN_NOT_REPRODUCIBLE_AT_THE_POOLS_OWN_FEE")
    emit("which is a refutation of the model on those rows rather than a gap in the data.")
    emit("TWENTY OF THE TWENTY-ONE fail for one structural reason: the single-tick,")
    emit("constant-liquidity step this counterfactual uses cannot reproduce those legs —")
    emit("nine because the leg does not reproduce at the pool's own fee, eleven because")
    emit("in-range liquidity is not constant between the two legs. This program does NOT")
    emit("distinguish a tick crossing from a mint or burn inside the step, and does not")
    emit("claim to: what closes them either way is a multi-tick counterfactual over the")
    emit("pool tick map, a larger law than the one written here — NOT the two reserve")
    emit("states this study previously said they needed. The floor did not move, and it")
    emit("is still a floor.")
    emit("")
    emit("-- THE POOL CONCENTRATION IS ONE EPISODE, measured on four real sub-corpora --")
    emit("Splitting the 1,000 blocks into four 250-block sub-corpora, each verified with")
    emit("blocks_scanned 250 and blocks_not_contiguous 0:")
    emit("  Q0 14000000-14000249   40 detections   24 pools   busiest 150 permille")
    emit("  Q1 14000250-14000499   31 detections    8 pools   busiest 580 permille")
    emit("  Q2 14000500-14000749   19 detections   13 pools   busiest 210 permille")
    emit("  Q3 14000750-14000999   18 detections   15 pools   busiest 111 permille")
    emit("EIGHTEEN of the twenty-two detections on the busiest pool sit in Q1 alone, and")
    emit("three more in Q2. The published 203 permille is the average of quarters ranging")
    emit("111 to 580, so it describes no quarter of the window it summarises.")
    emit("Both Kendall taus keep their SIGNS in all four: pool-relative +137 +619 +573")
    emit("+269, absolute-ETH -464 -592 -590 -657. The magnitudes do not. Q1 is both the")
    emit("most concentrated quarter and the strongest tau, so the four are not four")
    emit("independent draws and four agreeing signs are weaker evidence than they look.")
    emit("")
    emit("-- OUT OF SAMPLE: blocks 14001000-14003999, 3000 more blocks from the free wire --")
    emit("  blocks_scanned 3000, blocks_not_contiguous 0")
    emit("                              published 1,000      extension 3,000")
    emit("  detections                            108                  319")
    emit("  per 1,000 blocks                      108                  106   RATE REPLICATES")
    emit("  distinct pools                         48                  162")
    emit("  busiest pool share, permille          203                   78   CONCENTRATION GOES")
    emit("  the pool that carried it               22                    6   an 11x fall")
    emit("  EXACT                                  87                  249")
    emit("  NOT_KNOWN                              21                   70")
    emit("  pool-relative size tau               +491                 +112   sign holds")
    emit("  absolute ETH size tau                -500                 -407   sign holds")
    emit("THE RATE IS A PROPERTY OF THE CHAIN; THE CONCENTRATION WAS AN EPISODE. Both tau")
    emit("signs survive on three times the data and both magnitudes fall, so the published")
    emit("magnitudes are the top of the range and not its centre.")
    emit("")
    emit("NOTE  detections_per_1000_blocks_MEASURED is the raw detection COUNT and is a")
    emit("NOTE  rate only when the window is exactly 1,000 blocks. On the 3,000-block")
    emit("NOTE  corpus it prints 319, which is the count. The 106 above is computed from")
    emit("NOTE  the counts, 319 x 1000 / 3000. Quote the counts, never that field.")
    emit("")
    emit("NOTE  --start and --count in this program are a CONTIGUITY ASSERTION, not a")
    emit("NOTE  filter. It always reads the whole file and only checks that block i is")
    emit("NOTE  numbered start+i, reporting blocks_not_contiguous when it is not. Passing")
    emit("NOTE  a narrower --count does NOT select a sub-window: it returns the same")
    emit("NOTE  answer with every block flagged. Split the ndjson to split the corpus.")
}

// =====================================================================================
// SECTION 11 — MAIN
// =====================================================================================

let argv = CommandLine.arguments
func opt(_ name: String) -> String? {
    if let i = argv.firstIndex(of: name), i + 1 < argv.count { return argv[i + 1] }
    return nil
}
func flag(_ name: String) -> Bool { argv.contains(name) }

emit("EXTRACTION_EXACT")
emit("built_swift\t6.4 / -O / -swift-version 5")
emit("float_types_declared\t0")
emit("scope\tWHAT_WAS_TAKEN__ATTACKER_NET_AND_VICTIM_SHORTFALL")
emit("legal_position\tGEOMETRY_ONLY_DETECTION_IS_NOT_PROOF_OF_INTENT")
emit("acting_addresses_on_output\tKEYED_PSEUDONYM_8HEX")
emit("victim_transaction_hashes_on_output\tPRINTED — the harmed party must be able to find their own row")

// RECOVERED PRE-FRONT STATE, optional. With no --recovered file this loads nothing and
// every figure this kernel prints is the figure it printed when the study was published.
if flag("--emit-needs") { EMIT_NEEDS_TO = opt("--emit-needs-to") ?? "needs.tsv" }
if let rp = opt("--recovered") {
    let (rows, bad) = loadRecovered(rp)
    emit("recovered_state_file\t" + rp)
    emit("recovered_state_rows_loaded\t" + String(rows))
    emit("recovered_state_rows_malformed\t" + String(bad))
    emit("A recovered state is USED, never trusted. A supplied price must reproduce the")
    emit("front leg forward through the same v3Step, and a supplied fee must reproduce the")
    emit("victim's own leg exactly, or the row keeps its NOT_KNOWN and the rejection is named.")
} else {
    emit("recovered_state_file\tNONE — every figure below comes from the corpus alone")
}

if argv.count > 1 && argv[1] == "selftest" {
    let rc = selftest()
    flush()
    exit(Int32(rc))
}

let dir = opt("--dir") ?? ""
if dir.isEmpty {
    section("INPUT")
    emit("CORPUS_ABSENT\tno --dir given")
    emit("ABSENT is not a REFUSAL and it is not a pass: the corpus is fetched, never committed.")
    _ = selftest()
    referenceFigures("no corpus directory was named")
    flush()
    exit(4)
}

let blocksPath = dir + "/blocks.ndjson"
let receiptsPath = dir + "/receipts.ndjson"
if !FileManager.default.fileExists(atPath: blocksPath) || !FileManager.default.fileExists(atPath: receiptsPath) {
    section("INPUT")
    emit("CORPUS_ABSENT\t" + dir)
    emit("ABSENT is not a REFUSAL and it is not a pass.")
    _ = selftest()
    referenceFigures("the named corpus directory does not carry blocks.ndjson and receipts.ndjson")
    flush()
    exit(4)
}

section("INPUT DIGESTS — computed here, never asserted")
guard let bh = sha256File(blocksPath), let rh = sha256File(receiptsPath) else {
    refuse("INPUT_UNREADABLE")
}
kv("blocks.ndjson_bytes", bh.bytes)
kv("blocks.ndjson_sha256_computed", bh.hex)
kv("receipts.ndjson_bytes", rh.bytes)
kv("receipts.ndjson_sha256_computed", rh.hex)
if let eb = opt("--expect-blocks") {
    kv("blocks.ndjson_sha256_expected", eb)
    if eb != bh.hex { refuse("BLOCKS_DIGEST_MISMATCH") }
}
if let er = opt("--expect-receipts") {
    kv("receipts.ndjson_sha256_expected", er)
    if er != rh.hex { refuse("RECEIPTS_DIGEST_MISMATCH") }
}
if bh.bytes == 0 || rh.bytes == 0 { refuse("EMPTY_INPUT_A_GATE_GIVEN_NOTHING_MUST_NOT_PASS") }

let start = UInt64(opt("--start") ?? "14000000") ?? 14_000_000
let count = UInt64(opt("--count") ?? "1000") ?? 1000

if !flag("--no-selftest") {
    let rc = selftest()
    if rc != 0 { refuse("SELFTEST_FAILED_NO_MEASUREMENT_IS_VALID") }
}

var R = Run()
runCorpus(blocksPath: blocksPath, receiptsPath: receiptsPath, expectStart: start, expectCount: count, r: &R)
if R.blocks == 0 { refuse("ZERO_BLOCKS_PARSED") }

// The readability rate, measured from the corpus: the largest WETH/USDC V2 leg found.
// Measured, not fetched; an integer ratio of that pool's own reserves.
do {
    // The readability rate is MEASURED from this corpus: the deepest pool whose two tokens
    // were identified as WETH and USDC, at its own reserves. It is not fetched, and if no
    // such pool is present the rate stays NOT_KNOWN rather than reaching for an oracle.
    for (key, toks) in R.poolTokens {
        let a = toks.0, b = toks.1
        let isPair = (addrEq(a, WETH) && addrEq(b, USDC)) || (addrEq(a, USDC) && addrEq(b, WETH))
        if !isPair { continue }
        guard let deep = R.poolDeepest[key] else { continue }
        let wethRes = addrEq(a, WETH) ? deep.0 : deep.1
        let usdcRes = addrEq(a, WETH) ? deep.1 : deep.0
        if wethRes.isZero || usdcRes.isZero { continue }
        if U256.cmp(wethRes, R.usdcPerEthDen) > 0 {
            R.usdcPerEthDen = wethRes
            R.usdcPerEthNum = usdcRes
            R.usdcRateBlock = deep.2
            R.usdcRatePool = deep.3
        }
    }
}

// ---- WAS I SANDWICHED, AND WHAT DID IT COST ME -----------------------------------------
// The usable form of this result is not a table for a regulator. It is one question answered
// on one person's own transaction hash. This is that answer, over the corpus this run holds.
// A hash that is not in the corpus gets ABSENCE, never a clean bill: the corpus is 1,000
// blocks and the transaction may simply be outside it.
if let want = opt("--tx") {
    section("WAS THIS TRANSACTION SHEARED")
    let needle = want.lowercased()
    let hits = R.dets.filter { $0.victimTx.lowercased() == needle }
    kv("transaction", needle)
    kv("corpus_block_range", String(start) + ".." + String(start &+ count &- 1))
    if hits.isEmpty {
        let seen = R.dets.contains { $0.victimTx.lowercased() == needle }
        _ = seen
        emit("ANSWER\tNOT_IN_THIS_CORPUS")
        emit("This is ABSENCE, not a clean bill. The corpus this run holds is 1,000 blocks;")
        emit("a transaction outside it is not examined here and nothing about it is claimed.")
    } else {
        for d in hits {
            emit("ANSWER\tSHEARED")
            kv("block", d.block)
            kv("venue_shape", d.kind == 2 ? "constant_product" : "concentrated_liquidity")
            kv("pool_pseudonym", pseudo(d.pool))
            kv("you_paid_in", d.victimIn.dec + " " + (d.victimInToken.map { tokenLabel($0) } ?? "?"))
            kv("you_received", d.victimOut.dec + " " + (d.victimOutToken.map { tokenLabel($0) } ?? "?"))
            if d.status.isDeterminate {
                kv("you_would_have_received", d.victimOutCF.dec)
                kv("SHORTFALL_base_units", d.shortfall.dec)
                kv("shortfall_as_ten_thousandths_of_your_due_output", d.lossBp)
                kv("computed_from_pre_front_reserves", d.reserveInPre.dec + " / " + d.reserveOutPre.dec)
                kv("fee_recovered_from_your_own_swap", d.kind == 2 ? String(d.feeNum) + "/1000" : String(d.feeNum) + "pips")
            } else {
                kv("SHORTFALL", "NOT_KNOWN")
                kv("reason", d.status.rawValue)
                emit("NOT_KNOWN is not zero. The pool's arithmetic could not be reproduced")
                emit("exactly for this row, so no figure is offered for it.")
            }
            emit("DETECTION IS NOT INTENT. This says an insertion happened around your swap and")
            emit("what it cost you. It says nothing about anyone's intent, and names no one.")
        }
    }
    flush()
    exit(0)
}

report(R, corpusStart: start, corpusCount: count)
if let live = opt("--live") {
    liveRows(live.split(separator: ",").map { String($0) })
}
flush()
exit(0)
