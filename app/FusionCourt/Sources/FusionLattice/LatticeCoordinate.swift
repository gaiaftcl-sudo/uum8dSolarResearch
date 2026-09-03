// THE LATTICE COORDINATE — Int128, the largest NATIVE Swift integer.
//
// Why Int128 and not BigInt: a coordinate on the control path must not allocate.
// BigInt allocates on every add, and an allocation inside a 1 kHz tick is an
// unbounded pause. Int128 is a stdlib fixed-width type: 16 bytes, no heap, and
// 1.8447e19x the headroom of Int64. Measured on Swift 6.4: Int128.max is
// 1.7014e38, so the products that overflow Int64 in this domain sit trivially
// inside it.
//
// Why not Int64: the Greenwald cross-multiply reaches 2.8e19 at a 20 m minor
// radius. That overflows Int64 and needs no escalation at all in Int128.
//
// BigInt still has a home — the ledger, where a coordinate accumulates for
// decades and reversibility must be exact. It is simply not on the tick.

#if compiler(>=6.0)

/// One axis of the T^8 lattice, in exact integer quanta.
@frozen public struct LatticeAxis: Sendable, Equatable, Hashable {
    public var q: Int128
    @inlinable public init(_ q: Int128) { self.q = q }
    @inlinable public init(_ q: Int64) { self.q = Int128(q) }

    /// Every operation reports overflow rather than wrapping. A wrapped
    /// coordinate is a silently wrong position, which is worse than a refusal.
    @inlinable
    public func adding(_ o: LatticeAxis) -> (LatticeAxis, overflow: Bool) {
        let (s, o1) = q.addingReportingOverflow(o.q)
        return (LatticeAxis(s), o1)
    }
    @inlinable
    public func scaled(by k: Int128) -> (LatticeAxis, overflow: Bool) {
        let (p, o1) = q.multipliedReportingOverflow(by: k)
        return (LatticeAxis(p), o1)
    }
}

/// A point on the orientable 8D flat torus, exact.
@frozen public struct LatticePoint8: Sendable, Equatable {
    public var x: (LatticeAxis, LatticeAxis, LatticeAxis, LatticeAxis,
                   LatticeAxis, LatticeAxis, LatticeAxis, LatticeAxis)

    public init(repeating v: Int128 = 0) {
        let a = LatticeAxis(v); x = (a,a,a,a,a,a,a,a)
    }

    // Swift synthesises tuple Equatable only up to 6 elements; an 8-tuple needs
    // this written out. Compared axis by axis in FIXED order — a coordinate
    // comparison that depended on iteration order would not be a comparison.
    @inlinable
    public static func == (a: LatticePoint8, b: LatticePoint8) -> Bool {
        for i in 0..<8 { if a[i] != b[i] { return false } }
        return true
    }

    @inlinable
    public subscript(i: Int) -> LatticeAxis {
        get { switch i { case 0: return x.0; case 1: return x.1; case 2: return x.2
                         case 3: return x.3; case 4: return x.4; case 5: return x.5
                         case 6: return x.6; default: return x.7 } }
        set { switch i { case 0: x.0 = newValue; case 1: x.1 = newValue; case 2: x.2 = newValue
                         case 3: x.3 = newValue; case 4: x.4 = newValue; case 5: x.5 = newValue
                         case 6: x.6 = newValue; default: x.7 = newValue } }
    }

    /// Torus wrap: floored modulo, so the representative is always in [0, span).
    /// Floored — NOT truncating — because Swift's % is truncating and would put
    /// a negative coordinate outside the fundamental domain.
    @inlinable
    public mutating func wrap(span: Int128) {
        for i in 0..<8 {
            var r = self[i].q % span
            if r < 0 { r += span }
            self[i] = LatticeAxis(r)
        }
    }

    /// Winding number per axis — the quotient half of the same division. Kept
    /// because the pair (representative, winding) is what makes the wrap
    /// REVERSIBLE; the representative alone is not.
    @inlinable
    public func winding(span: Int128) -> [Int128] {
        (0..<8).map { i in
            let v = self[i].q
            var w = v / span
            if v % span < 0 { w -= 1 }
            return w
        }
    }
}

public enum LatticeWidth {
    public static let axisBits = Int128.bitWidth
    public static let pointBytes = MemoryLayout<LatticePoint8>.size
    public static let int64HeadroomFactor: Int128 = Int128.max / Int128(Int64.max)
}

#endif
