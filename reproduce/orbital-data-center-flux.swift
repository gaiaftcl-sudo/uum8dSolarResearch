// The Orbital Data Center constellation, using SpaceX's OWN disposal split from the
// 29 May 2026 FCC filing rather than an assumed all-reentry model.
func t(_ g: Int) -> String { "\(g/1_000_000).\((g%1_000_000)/100_000)" }
func pad(_ s: String, _ w: Int) -> String { var r = s; while r.count < w { r = " " + r }; return r }

let N = 1_000_000, LIFE = 5
let decommissioned = N / LIFE            // 200,000/yr
let deorbitBurn = 40_000                 // FCC filing 2026-05-29, via Ars Technica 2026-08-20
let toDisposalOrbit = decommissioned - deorbitBurn

print("=== the disposal split is THEIRS, not an assumption ===")
print("  proposed constellation            \(N)")
print("  useful life (GPU-driven)          \(LIFE) yr")
print("  decommissioned per year           \(decommissioned)")
print("  of which DEORBIT AND BURN UP      \(deorbitBurn)   <- FCC filing 2026-05-29")
print("  of which pushed to disposal orbit \(toDisposalOrbit)")
print("")
print("  MY EARLIER PROJECTION ASSUMED ALL 200,000 REENTER. Their filing says 40,000.")
print("  That is 5x FEWER than I projected. Correcting downward.")

print("")
print("=== atmospheric mass flux, at the deorbiting fraction only ===")
for (label, kg) in [("Starlink fleet mean", 492), ("Gen3 filing figure", 2_000), ("NVL72-class, unstated", 4_000)] {
    let g = deorbitBurn * kg * 1000
    print("  \(pad(label,24)) \(pad("\(kg)",5)) kg  ->  \(pad(t(g),10)) t/yr = \(g/1_000_000_000) Gg/yr")
}
print("")
print("  vs 2025 measured SPXS reentry     211.6 t/yr")
let atGen3 = deorbitBurn * 2_000 * 1000
print("  at the Gen3 filing mass, that is \(atGen3 / 211_600_000)x the 2025 measured rate")

print("")
print("=== the founder's 250 Gg/yr, checked ===")
let claimed = 250_000_000_000
let impliedKg = claimed / deorbitBurn / 1000
print("  250 Gg/yr across \(deorbitBurn) deorbiting units implies \(impliedKg) kg each")
let impliedAll = claimed / decommissioned / 1000
print("  250 Gg/yr across all \(decommissioned) decommissioned implies \(impliedAll) kg each")
print("  Both are stateable, but the mass is UNSOURCED — no SpaceX filing gives an AI1 or")
print("  NVL72-satellite mass, and the Ars piece says so explicitly: 'Without full, detailed")
print("  specifications for these satellites, there is no way to properly tally the amount")
print("  of material'. The flux therefore cannot be pinned above a per-unit mass nobody has")
print("  published. State the RANGE and name the missing input.")

print("")
print("=== AND THE BLOCK HEIGHT, RE-PUT TO THE COURT ===")
print("  Scaling the numerator does not repair the denominator. The saturation chain was")
print("  refused on two grounds and neither is a function of constellation size:")
print("   1. T_sat = 1 particle/cm3 sits AT the measured Junge-layer background of 1-10.")
print("      A threshold the unperturbed sky already meets returns SATURATED for the")
print("      pre-industrial atmosphere. At 250 Gg/yr it still returns SATURATED for 1850.")
print("      The answer would not be '1 year'. It would be 'before Sputnik', which is the")
print("      signature of a broken threshold, not a fast catastrophe.")
print("   2. Aerosol residence is 1-4 years. A flux against a sink converges to flux x tau.")
print("      At 250 Gg/yr and tau=2 the standing burden is 500 Gg — LARGE and worth stating")
print("      plainly — but it is a CONSTANT, not a fill toward 100%.")
print("")
print("  What IS publishable at that flux, and it is strong: the steady-state burden.")
for tau in [1, 2, 4] {
    let burdenGg = 250 * tau
    // background stratospheric aerosol burden: 109-156 Gg SULFUR = 445-637 Gg aerosol
    print("    tau=\(tau) yr -> \(burdenGg) Gg standing vs a 445-637 Gg background aerosol burden")
}
print("  THAT is a comparison with a sourced denominator, and it does not need a fake limit.")
