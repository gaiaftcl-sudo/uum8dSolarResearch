// THE SYNTHETIC PLANT — the app's sample generator, and the only one. Lifted
// verbatim from ControlHost.swift on 2026-10-03 so that the census the court
// shows (54,272 NOMINAL / 8,192 MITIGATE / 2,048 REFUSED env / 1,024 REFUSED mal
// at 65,536 agents) has exactly one generator, which the app, the tests and the
// Affine IDE all call.
//
// IT IS NOT PLASMA DATA. Each agent's channel class is fixed by its index:
// class = agent & 63, so the verdict pattern is the generator's, by construction:
//   class 0       1 in 64   30000, outside the 14-bit ADC domain     -> REFUSED_MALFORMED
//   class 1-2     2 in 64   +-7000 + noise, past the 6000 envelope   -> REFUSED_OUT_OF_ENVELOPE
//   class 3-10    8 in 64   a sawtooth growing > 900 per 8 samples   -> MITIGATE
//   class 11-63  53 in 64   noise only                               -> NOMINAL
// A real deployment substitutes the digitiser's own integer stream for `fill`
// and nothing else changes.
//
// The multiplier 2246822519 exceeds Int32.max, so this is 64-bit-Int code: Darwin
// arm64, the only platform the app and the IDE build for.

public enum SyntheticPlant {

    /// One integer sample for one agent at one tick. Constant work, no allocation.
    @inlinable
    public static func sample(agent i: Int, tick t: UInt64) -> Int16 {
        let ti = Int(truncatingIfNeeded: t)
        let noise = Int(((i &+ ti) &* 2246822519) >> 22) % 100 - 50
        let cls = i & 63                     // 64-way channel class
        var v: Int
        if cls == 0 {
            // ~1.5%: a sensor returning garbage outside the ADC domain
            v = 30000
        } else if cls == 1 || cls == 2 {
            // ~3%: a stuck-high channel PERSISTENTLY past the envelope
            v = (ti % 2 == 0 ? 7000 : -7000) + noise      // |v| > 6000
        } else if cls < 11 {
            // ~14%: a growing mode. Each control window sees a step > the 900
            // trigger for >= 3 windows, so it MITIGATEs and LATCHES — bounded
            // ~5000, inside the ADC domain, so it never runs away into malformed.
            let step = 1000 + (Int((i &* 2654435761) >> 20) % 400)   // > 900
            let k = Int(ti % 16)
            let amp = min(60 + k * step, 5000)
            v = (ti % 2 == 0 ? amp : -amp) + noise
        } else {
            // the rest: quiescent
            v = noise
        }
        return Int16(clamping: v)
    }

    /// One sample per agent for tick t, written into a caller-owned buffer whose
    /// count is the agent count. Allocates nothing; agent i is buffer index i.
    @inlinable
    public static func fill(_ out: UnsafeMutableBufferPointer<Int16>, tick t: UInt64) {
        var i = 0
        let n = out.count
        while i < n { out[i] = sample(agent: i, tick: t); i += 1 }
    }
}
