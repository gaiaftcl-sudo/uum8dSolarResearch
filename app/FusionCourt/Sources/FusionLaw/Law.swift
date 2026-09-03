// THE LAW. One home. Compiles clean under -swift-version 5 and language mode 6.
//
// CANONICAL SEMANTICS, frozen 2026-09-02 to resolve a three-way fork:
//   1. The malformed scan runs over the WHOLE window FIRST, before any growth
//      logic. The strictest of the three prior behaviours.
//   2. An input shorter than growthWindow is REFUSED_MALFORMED — never NOMINAL.
//      One prior copy returned NOMINAL here; a refusal had silently become a pass.
//   3. Both firstTrip AND peakGrowth are returned. Each prior copy dropped one.
//
// Arithmetic: integer abs, subtract, compare, and a run counter. No multiply,
// no division, no allocation, no floating point.

public enum FusionLaw {

    /// Evaluate one window. This is the ONLY verdict function in the programme.
    @inlinable
    public static func screen(_ counts: UnsafeBufferPointer<Int32>) -> ScreenResult {
        let n = counts.count
        let W = LawConstants.growthWindow

        // (1) Whole-window malformed pre-scan, before anything else.
        var i = 0
        while i < n {
            let v = Int(counts[i])
            if v < LawConstants.adcMin || v > LawConstants.adcMax {
                return ScreenResult(verdict: .REFUSED_MALFORMED,
                                    firstTrip: -1, peakGrowth: 0, atIndex: i)
            }
            i &+= 1
        }

        // (2) Too short to carry a growth window is malformed, not nominal.
        if n <= W {
            return ScreenResult(verdict: .REFUSED_MALFORMED,
                                firstTrip: -1, peakGrowth: 0, atIndex: n)
        }

        var run = 0
        var firstTrip = -1
        var peakGrowth = 0

        var k = W
        while k < n {
            let raw = Int(counts[k])
            let a = raw < 0 ? -raw : raw

            // Outside the declared envelope the law REFUSES. It does not rule on
            // data it was never frozen against — the terminal a statistical
            // interpolator cannot offer, because it always returns a number.
            if a > LawConstants.envelopeAbs {
                return ScreenResult(verdict: .REFUSED_OUT_OF_ENVELOPE,
                                    firstTrip: firstTrip, peakGrowth: peakGrowth, atIndex: k)
            }

            let pv = Int(counts[k &- W])
            let b = pv < 0 ? -pv : pv
            let g = a &- b
            if g > peakGrowth { peakGrowth = g }

            if g >= LawConstants.growthTrigger {
                run &+= 1
                if firstTrip < 0 { firstTrip = k }
                if run >= LawConstants.persist {
                    return ScreenResult(verdict: .MITIGATE,
                                        firstTrip: firstTrip, peakGrowth: peakGrowth, atIndex: k)
                }
            } else {
                run = 0
                firstTrip = -1
            }
            k &+= 1
        }

        return ScreenResult(verdict: .NOMINAL,
                            firstTrip: -1, peakGrowth: peakGrowth, atIndex: -1)
    }

    /// Array convenience. Same law, no copy of the logic.
    @inlinable
    public static func screen(_ counts: [Int32]) -> ScreenResult {
        return counts.withUnsafeBufferPointer { screen($0) }
    }
}
