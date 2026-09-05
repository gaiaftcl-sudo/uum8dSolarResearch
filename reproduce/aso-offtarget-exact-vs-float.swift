// An antisense off-target screen, both ways. The safety question for an ASO: besides its target,
// where ELSE in the transcriptome can its sequence bind well enough to be cut? Two instruments.
//
// EXACT  — Watson-Crick complementarity is a discrete rule. Bases A=0 C=1 G=2 U=3; a position pairs
//          when aso[i] + window[i] == 3 (A<->U, C<->G). A window is an off-target candidate when its
//          complementary-position count reaches a threshold. Pure integers: the same answer on every
//          machine, re-derivable byte-for-byte, no parameter to choose.
// FLOAT  — the conventional score is a binding free energy dG (Double): sum a per-pair energy over the
//          window, call it a candidate when dG <= a cutoff. dG needs a thermodynamic PARAMETER SET, and
//          published sets differ within their own uncertainty. That choice is unstandardized — exactly
//          like the rational value of pi on the fusion court (Study 34).
//
// This is a representative screen on synthetic sequences: it demonstrates the KIND of divergence, it did
// not screen zilganersen or any real GFAP sequence. Deterministic — no clock, no randomness.
import Foundation

let N = 20
// a representative 20-mer ASO (its bases pair with a window when aso[i] + window[i] == 3)
let aso: [Int] = [2,1,2,3,0,2,1,0,2,3,1,2,0,2,3,1,2,0,1,2]
func comp(_ b: Int) -> Int { 3 - b }                 // Watson-Crick complement
let perfect = aso.map(comp)                          // the perfect target: pairs 20/20

// build a synthetic transcriptome of windows from the perfect target, planting mismatches at chosen
// positions (a mismatch = flip that base to a NON-complementary one). GC-rich vs AU-rich mismatches
// move dG without moving the match count — which is exactly where exact and float part company.
func mutate(_ w: [Int], _ positions: [Int]) -> [Int] {
  var v = w
  for p in positions { v[p] = (v[p] + 1) % 4; if v[p] + aso[p] == 3 { v[p] = (v[p] + 1) % 4 } } // ensure non-pair
  return v
}
let windows: [(name: String, seq: [Int])] = [
  ("exact_target      ", perfect),
  ("offA_2mm_GCcore   ", mutate(perfect, [1, 18])),      // 18/20
  ("offB_2mm_edges    ", mutate(perfect, [0, 19])),      // 18/20
  ("offC_3mm          ", mutate(perfect, [3, 10, 16])),  // 17/20
  ("offD_2mm_AUrich   ", mutate(perfect, [4, 9])),       // 18/20, weaker pairs left
  ("decoy_6mm         ", mutate(perfect, [2,5,7,11,13,17])), // 14/20
]

// exact: count complementary positions
func matches(_ w: [Int]) -> Int { (0..<N).reduce(0) { $0 + (aso[$1] + w[$1] == 3 ? 1 : 0) } }
let EXACT_MIN = 18   // >= 18/20 complementary -> off-target candidate (<= 2 mismatches)

// float: nearest-neighbor-style dG under a chosen parameter set
struct Params { let gc: Double; let au: Double; let mm: Double; let name: String }
func dG(_ w: [Int], _ p: Params) -> Double {
  var e = 0.0
  for i in 0..<N {
    if aso[i] + w[i] == 3 {                            // a WC pair
      let gc = (w[i] == 1 || w[i] == 2)                // C or G in the window => G-C pair
      e += gc ? p.gc : p.au
    } else { e += p.mm }                               // mismatch penalty
  }
  return e
}
// two defensible parameter sets, differing within literature-scale uncertainty (~3%)
let A = Params(gc: -3.40, au: -2.40, mm: 1.50, name: "paramset-A")
let B = Params(gc: -3.28, au: -2.32, mm: 1.50, name: "paramset-B")
let CUTOFF = -46.0   // dG <= cutoff -> off-target candidate

print("=== an ASO off-target screen: exact complementarity vs float binding-energy ===\n")
print("  window                match/20   dG(A)     dG(B)    | exact    floatA   floatB")
var exactSet = Set<String>(), fA = Set<String>(), fB = Set<String>()
for (name, w) in windows {
  let m = matches(w), ga = dG(w, A), gb = dG(w, B)
  let ex = m >= EXACT_MIN, oa = ga <= CUTOFF, ob = gb <= CUTOFF
  if ex { exactSet.insert(name) }; if oa { fA.insert(name) }; if ob { fB.insert(name) }
  print(String(format: "  %@   %2d/20    %7.2f  %7.2f   | %@   %@   %@",
    name, m, ga, gb, ex ? "OFF ":"—   ", oa ? "OFF ":"—   ", ob ? "OFF ":"—   "))
}
print("")
print("  EXACT off-target set:            \(exactSet.sorted().map{$0.trimmingCharacters(in:.whitespaces)})")
print("  FLOAT off-target set, paramset-A: \(fA.sorted().map{$0.trimmingCharacters(in:.whitespaces)})")
print("  FLOAT off-target set, paramset-B: \(fB.sorted().map{$0.trimmingCharacters(in:.whitespaces)})")
let flipped = fA.symmetricDifference(fB)
print("")
print("  the exact set is one answer on every machine, with no parameter to choose.")
print("  the float set DISAGREES WITH ITSELF across two defensible parameter sets on: \(flipped.sorted().map{$0.trimmingCharacters(in:.whitespaces)})")
print("  windows exact flags that float (paramset-A) misses: \(exactSet.subtracting(fA).sorted().map{$0.trimmingCharacters(in:.whitespaces)})")
print("")
print("  READING — a synthetic, representative screen; it shows the KIND of divergence, not a result on any real drug.")
print("  Off-target candidate identification by exact complementarity is observer-invariant and re-derivable;")
print("  the same screen scored by a floating-point binding energy reorders and reclassifies with the parameter")
print("  set and the rounding — the sequence-safety analogue of the pi-bracket shear on the fusion court.")
print("  ASO_OFFTARGET_EXACT_IS_OBSERVER_INVARIANT")
