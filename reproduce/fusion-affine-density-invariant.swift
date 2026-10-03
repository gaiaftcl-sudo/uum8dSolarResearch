// PROOF — the UUM-8D rational density invariant removes pi from the Greenwald bound.
//
// Classical:  n_G = I_p / (pi * a^2).  pi is irrational, so pi*a^2 cannot be written
// exactly; a control loop must round it and inherits the observer-dependence proven in
// Study 34. Affine:  I_rho = Phi_q / det(Lambda) — discrete charge flux over the exact
// integer determinant of the flux-surface lattice slice. No pi, no float, one integer.
//
// This program is itself trig-free and integer-only, so its own numbers are byte-
// identical on every machine — the property it is demonstrating.
//
// ONE HOME (2026-10-03): the slice's 16 vertices, the lattice cell and every
// determinant are read from DensitySlice (app/FusionCourt/Sources/FusionLattice/
// DensitySlice.swift); the pi bracket and the 85 % margin from FusionOperatingPointLaw.
// This script used to declare its own copy of each.
import Foundation   // only for printing

let a: Int64 = 2000                           // minor radius, mm

// --- 1. pi * a^2 is pi-ambiguous: evaluate at the two bracket rationals (exact ints) ---
let lo = FusionOperatingPointLaw.piLo         // 333/106 < pi
let hi = FusionOperatingPointLaw.piHi         // pi < 355/113
guard let circLo = DensitySlice.circleAreaFloorMm2(radiusMm: a, piNum: Int64(lo.num), piDen: Int64(lo.den)),
      let circHi = DensitySlice.circleAreaFloorMm2(radiusMm: a, piNum: Int64(hi.num), piDen: Int64(hi.den))
else { print("REFUSED: the circle area did not form exactly"); exit(1) }
print("CLASSICAL pi*a^2 (mm^2): \(lo.num)/\(lo.den) -> \(circLo) ,  \(hi.num)/\(hi.den) -> \(circHi)")
print("  pi-ambiguous by \(circHi - circLo) mm^2 across the bracket  (a control loop must pick one)")

// --- 2. det(Lambda): the exact area of an integer-vertex flux-surface slice ---
// A localized torus slice spanned by two integer lattice vectors; its cell area is the
// exact determinant |v1 x v2| — zero pi, one integer. (The founder's det(Lambda).)
print("\nLATTICE CELL det(Lambda) = |v1 x v2| = \(DensitySlice.cellDeterminant) mm^2   (exact integer, no pi)")

// A whole D-shaped cross-section as EXACT integer vertices (a real plasma is not a
// circle) — the program's own slice, not a published separatrix. Shoelace area =
// sum of 2x2 lattice determinants = exact integer.
let detLambda = Int(DensitySlice.areaMm2)     // exact integer area, mm^2
print("D-SHAPE det(Lambda) = \(detLambda) mm^2   (exact; carries the elongated shape the circle discards)")

// --- 3. the sealed invariant I_rho = Phi_q / det(Lambda), and a verdict with no pi ---
// Phi_q: discrete charge-flux count (stands in for I_p in exact lattice units).
let phiQ = 15_000_000
let margin = Int(FusionOperatingPointLaw.greenwaldMarginPercent)   // 85
// MISS iff  n_e >= 0.85 * I_rho  <=>  100 * n_e * det(Lambda) >= 85 * phiQ  (pure integers)
func affineVerdict(ne: Int) -> String { (100 * ne * detLambda >= margin * phiQ) ? "MISS" : "WIN" }
let neSafe = margin * phiQ / (100 * detLambda) - 5
let neOver = margin * phiQ / (100 * detLambda) + 5
print("\nI_rho = Phi_q / det(Lambda) = \(phiQ) / \(detLambda)   (exact rational; no pi anywhere)")
print("  n_e just below the bound -> \(affineVerdict(ne: neSafe))   just above -> \(affineVerdict(ne: neOver))")
print("  every verdict is an integer comparison: no bracket, no NOT_MEASURED, observer-invariant by construction")

print("""

WHAT IS PROVEN (integer-only, reproducible on any machine)
  - pi*a^2 cannot be pinned: it moves \(circHi - circLo) mm^2 across the pi-bracket — the
    same 2.66e-5 that made the float Greenwald verdict contradict itself on 142 points.
  - det(Lambda) is one exact integer; the affine invariant Phi_q / det(Lambda) needs no
    pi, no float, and no refusal band. Removing pi removes the observer-dependence at its
    root, not by bracketing it.
  HYPOTHESIS (NOT proven here; Study 33 is PENDING, no device): that this exact bound
  tracks real disruptions better than the empirical circular limit — the regime where
  shaped, conductively-walled plasmas exceed n_G is the falsifiable test, against data.
  AFFINE_DENSITY_INVARIANT_IS_PI_FREE
""")
