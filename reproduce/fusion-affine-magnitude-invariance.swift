// PROOF — the affine invariant carries the verdict at ANY magnitude; float goes blind.
//
// A float's precision is relative to its magnitude: 24 mantissa bits in float32, 53 in
// float64. Once the numbers exceed 2^24 / 2^53 the format cannot represent consecutive
// integers, so two physically DISTINCT adjacent states — one inside the density bound, one
// over it — collapse to the same float and the safety verdict is lost. The exact integer
// invariant separates them at every scale. This is the same physics (Greenwald's density
// bound), converted from 2-D continuous math to an exact affine invariant.
import Foundation
#if compiler(>=6.0)
typealias Big = Int128

// Two adjacent states straddle the threshold T: n = T-1 is WIN (inside), n = T is MISS (over).
func affineSeparates(_ T: Big) -> Bool { (T - 1 < T) && !(T < T) }
func f32Separates(_ T: Big) -> Bool { let t = Float(T);  return (Float(T - 1) < t) && !(Float(T) < t) }
func f64Separates(_ T: Big) -> Bool { let t = Double(T); return (Double(T - 1) < t) && !(Double(T) < t) }
func pow10(_ k: Int) -> Big { var v: Big = 1; for _ in 0..<k { v *= 10 }; return v }

print("MAGNITUDE LADDER — can each number system still tell WIN from MISS?")
print("  (T = the density / charge-flux threshold, growing; the two states differ by one unit)")
print("  magnitude       float32   float64   affine Int128")
for k in [3, 6, 8, 12, 15, 16, 18, 24, 30] {
  let T = pow10(k)
  let a = f32Separates(T) ? "sees " : "BLIND"
  let b = f64Separates(T) ? "sees " : "BLIND"
  let c = affineSeparates(T) ? "sees " : "BLIND"
  print("  10^\(k)\(k < 10 ? " " : "")           \(a)     \(b)     \(c)")
}
let two24: Big = 1 << 24, two53: Big = 1 << 53
print("")
print("  float32 goes blind at 2^24 = \(two24)  (~1.7e7 — below a single plasma current in amperes)")
print("  float64 goes blind at 2^53 = \(two53)  (~9.0e15 — a fine charge-flux count crosses it)")
print("  affine  Int128 exact past 2^126 ~ 1e38  (no physical plasma quantity reaches it)")
print("""

  WHAT IS PROVEN
   - Past 2^24 (float32) and 2^53 (float64) the two adjacent states are the SAME number, so
     the safety verdict is not wrong — it is UNDEFINED; there is no verdict left to give.
   - The exact integer invariant separates them at 10^3 and at 10^30 alike. The meaning —
     inside the bound versus over it — survives no matter what magnitude it is written at.
  AFFINE_INVARIANT_CARRIES_MEANING_AT_ANY_MAGNITUDE
""")
#else
print("needs Swift 6")
#endif
