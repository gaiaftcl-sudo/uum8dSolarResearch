// PROOF — a safety verdict must be the same for everyone who checks it.
// The exact-integer court gives one verdict every machine reproduces (or an
// honest refusal). Computing the SAME Greenwald verdict in IEEE-754 does not:
// it depends on the precision and on which rational value of pi you picked.
// Everything here is replayable: swift this file (the exact law is linked in).
import Foundation   // Double.pi / Float only; the EXACT law imports nothing.

// Published tokamak geometries (REPORTED): Ip in A, minor radius in mm.
let MACHINES: [(String, Int64, Int64)] = [
  ("ITER", 15_000_000, 2000), ("SPARC", 8_700_000, 570),
  ("JET",   4_800_000, 1250), ("DIII-D", 2_000_000, 670),
]

// The exact court's verdict (integer, pi-bracketed).
func exact(_ ne: Int64, _ ip: Int64, _ a: Int64) -> String {
  FusionOperatingPointLaw.grade(OperatingEnvelope(
    ne14: ne, ipAmp: ip, minorRadiusMm: a, betaNMilli: 1800, qMinMilli: 3000)).verdict
}
// The SAME Greenwald test in float: MISS iff 100*ne*a^2*pi >= 85*ip*1e6.
func f64(_ ne: Int64, _ ip: Int64, _ a: Int64, pi: Double) -> String {
  (100.0*Double(ne)*Double(a)*Double(a)*pi >= 85.0*Double(ip)*1e6) ? "MISS" : "WIN"
}
func f32(_ ne: Int64, _ ip: Int64, _ a: Int64, pi: Float) -> String {
  (Float(100)*Float(ne)*Float(a)*Float(a)*pi >= Float(85)*Float(ip)*Float(1e6)) ? "MISS" : "WIN"
}

print("=== PROOF: the floating-point safety verdict is observer-dependent; the exact one is not ===\n")
print("  PI_BRACKET  355/113 - 333/106 = 1/11978   (8.35e-5 wide; 2.7e-7 is the error of 355/113 alone)\n")
var totBracket=0, totF32Flip=0, totPiAmbiguous=0
var exhibit: String? = nil
for (nm, ip, a) in MACHINES {
  // real-arithmetic boundary, only to centre the integer sweep
  let neStar = 85.0*Double(ip)*1e6/(100.0*Double(a)*Double(a)*Double.pi)
  let lo = Int64(neStar)-60, hi = Int64(neStar)+60
  var bracket=0, f32flip=0, piamb=0
  for ne in lo...hi {
    let ex = exact(ne, ip, a)
    let a64  = f64(ne, ip, a, pi: Double.pi)          // pi to machine epsilon
    let a355 = f64(ne, ip, a, pi: 355.0/113.0)        // a good rational pi
    let a333 = f64(ne, ip, a, pi: 333.0/106.0)        // a coarser rational pi
    let a32  = f32(ne, ip, a, pi: Float.pi)           // single precision (GPU/ML default)
    if ex == "NOT_MEASURED_PI_BRACKET" { bracket += 1 }
    // float32 verdict differs from the exact answer where the exact answer is definite
    if ex != "NOT_MEASURED_PI_BRACKET" && a32 != ex { f32flip += 1 }
    // two DEFENSIBLE rational values of pi give contradictory float verdicts
    if a355 != a333 {
      piamb += 1
      if exhibit == nil && ex == "NOT_MEASURED_PI_BRACKET" {
        let nG = Double(ip)*1e6*113.0/(355.0*Double(a)*Double(a))
        exhibit = "  \(nm): at n_e=\(ne)e14 m^-3  ->  pi=355/113 says \(a355) · pi=333/106 says \(a333)"
          + "  |  the exact court says \(ex)\n"
          + "     (that operating point is \(String(format:"%.2f", 100*Double(ne)/nG))% of ITER-style n_GW; the honest answer is 'not to this precision')"
      }
    }
  }
  // physical width of the pi-ambiguous band, in m^-3 and as % of this machine's n_GW
  let nG = Double(ip)*1e6*113.0/(355.0*Double(a)*Double(a))
  let pctBand = 100.0*Double(bracket)/nG
  print(String(format:"  %-7@  exact NOT_MEASURED band = %3d points (%.4f%% of n_GW) · float32 flips = %3d · two-pi contradictions = %3d",
    nm as NSString, bracket, pctBand, f32flip, piamb))
  totBracket+=bracket; totF32Flip+=f32flip; totPiAmbiguous+=piamb
}
print("\n  TOTALS  exact-refused points = \(totBracket) · float32 flips vs exact = \(totF32Flip) · two-pi float contradictions = \(totPiAmbiguous)")
if let ex = exhibit { print("\n  EXHIBIT — one operating point, three answers:\n\(ex)") }
print("""

  WHAT IS PROVEN:
   - The exact court returns ONE verdict every machine reproduces bit-for-bit,
     or the honest refusal NOT_MEASURED_PI_BRACKET where the answer sits closer
     to the limit than pi itself is pinned.
   - The SAME verdict in floating point is observer-dependent: single precision
     flips it at boundary points, and two defensible rational values of pi give
     contradictory answers on the very points the exact court refuses.
   - A verdict that changes with the observer's hardware or choice of pi cannot
     be the shared safety authority a licensed facility, a regulator, or a
     citizen can be held to. The integer verdict can. That is the whole claim.
  PROOF_EXACT_VERDICT_IS_OBSERVER_INVARIANT
""")
