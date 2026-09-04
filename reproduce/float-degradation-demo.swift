// LOCAL — the DEGRADATION NUMBER: float error cascades in a running loop over time.
//
// A controller maintains a running state (an integrator, an accumulated estimate, a filter's
// memory). Each tick updates it. In floating point, once the state passes the mantissa, the
// update rounds away — the accumulator STOPS tracking, and from that tick on the error grows
// every tick, without bound: a small off that cascades. Exact integers never lose a tick.
// This is run, not asserted; one unit per tick is the cleanest case, the mechanism is general.
import Foundation

let LIMIT = 20_000_000
var exact = 0, f32: Float = 0, freeze = 0
for n in 1...LIMIT {
  exact += 1
  f32 += 1
  if freeze == 0 && Int(f32) != exact { freeze = n }
}
print("=== float error cascade in a running integrator (one unit per tick) ===\n")
print("  float32 stops tracking at tick \(freeze)  (2^24 = \(1 << 24))")
print("  after \(LIMIT) ticks: truth = \(exact), float32 reads \(Int(f32)), LOST = \(exact - Int(f32)) ticks — and the gap grows every tick after freeze\n")

// The freeze is a THEOREM of IEEE-754, not an artifact of this loop. The successor of 2^p is
// unrepresentable once the mantissa fills, so adding 1 is a no-op there. This proves the float64
// onset (2^53) directly, WITHOUT looping to 9e15:
let t32: Float  = 16_777_216                 // 2^24
let t64: Double = 9_007_199_254_740_992      // 2^53
print("PROOF (IEEE-754, not a measurement):")
print("  float32: (2^24) + 1 == 2^24 ?  \(t32 + 1 == t32)   and (2^24) + 2 == 2^24 ?  \(t32 + 2 == t32)   -> ULP is 2 at 2^24, so +1 is lost")
print("  float64: (2^53) + 1 == 2^53 ?  \(t64 + 1 == t64)   and (2^53) + 2 == 2^53 ?  \(t64 + 2 == t64)   -> same freeze at 2^53, proven without looping there\n")

func human(_ ticks: Double, _ hz: Double) -> String {
  let s = ticks / hz
  if s < 90 { return String(format:"%.1f s", s) }
  if s < 5400 { return String(format:"%.0f min", s/60) }
  if s < 172800 { return String(format:"%.1f hours", s/3600) }
  if s < 3.156e7 { return String(format:"%.0f days", s/86400) }
  return String(format:"%.0f years", s/3.156e7)
}
let f32f = 16_777_216.0, f64f = 9_007_199_254_740_992.0  // 2^24, 2^53
print("DEGRADATION ONSET — when the running state stops updating:")
print(String(format:"  float32 at 2^24 = %.0f ticks   ->  %@ at 2 MHz  ·  %@ at 1 kHz", f32f, human(f32f,2e6) as NSString, human(f32f,1000) as NSString))
print(String(format:"  float64 at 2^53 = %.3e ticks   ->  %@ at 2 MHz  ·  %@ at 1 kHz", f64f, human(f64f,2e6) as NSString, human(f64f,1000) as NSString))
print("  exact Int128 at 2^126 ~ 1e38 ticks    ->  longer than the universe at any control rate")
print("\nWHERE float32 already stands, by the time the plasma matters:")
for (label, ticks) in [("one 6 ms shot @ 2 MHz", 12_000.0), ("one hour @ 2 MHz", 7.2e9), ("one day @ 1 kHz", 8.64e7)] {
  let lost = max(0, ticks - f32f)
  print(String(format:"  %@: truth %.3e, float32 frozen at %.0f, ERROR %.1f%% of the count", label as NSString, ticks, min(ticks,f32f), 100*lost/ticks))
}
print("""

  READING (run, integer-vs-float; the mechanism is general, one-unit-per-tick is the clean case)
   - A float32 running state stops integrating after ~16.8 million ticks — 8 seconds at a 2 MHz
     diagnostic, under 5 hours at a 1 kHz control loop — and every tick after that is lost, so
     the error cascades upward without bound. float64 lasts far longer for a bare sum, but a real
     controller does millions of float ops per tick over a high-dynamic-range state, so its
     effective horizon is a fraction of the bare-sum bound (ARGUMENT).
   - The lost count has NO relation to the plasma's real safety margin — it is a numerical
     artifact with no bound tied to the physics. The exact integer state carries error ZERO for
     any horizon: it is bounded to the meaning because it IS the meaning.
  FLOAT_STATE_DEGRADES_OVER_TIME_INVARIANT_DOES_NOT
""")
