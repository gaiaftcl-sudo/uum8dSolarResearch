// The stratosphere as a closed system: a steady-state mass balance.
//
// This is the simplest defensible instrument in the whole programme, and it needs
// no chemistry-transport model, no saturation threshold, and no assumption about
// what the material DOES once it is there.
//
//   burden B = injection rate I  x  residence time tau        (steady state)
//
// Compare human injection to the natural meteoric injection the stratosphere has
// always carried. Both populations are micrometre-scale metal-oxide particles at
// the same altitudes, so they share tau -- AND TAU CANCELS:
//
//   B_human / B_natural = (I_human x tau) / (I_natural x tau) = I_human / I_natural
//
// That is the whole model. Integer arithmetic in kilograms per year.
// It does not say what the ratio DOES. It says how far the sky has been moved
// from the composition it held before anyone launched anything.

func pad(_ s: String, _ w: Int) -> String { var r = s; while r.count < w { r += " " }; return r }
func rp(_ s: String, _ w: Int) -> String { var r = s; while r.count < w { r = " " + r }; return r }
// ratio as a percentage with one decimal, integer-only
func pct(_ n: Int, _ d: Int) -> String { let p = n * 1000 / d; return "\(p/10).\(p%10)%" }
// ratio as "x times", one decimal
func times(_ n: Int, _ d: Int) -> String { let p = n * 10 / d; return "\(p/10).\(p%10)x" }

print("=== THE CLOSED SYSTEM ===")
print("  The stratosphere exchanges slowly with the troposphere. Particles injected")
print("  into it settle out on a residence time of order a year to a few years.")
print("  At steady state the burden it carries is injection rate x residence time.")
print("")
print("  Comparing human injection to natural meteoric injection, the residence time")
print("  CANCELS. What is left is a ratio of two mass fluxes -- both measurable,")
print("  neither modelled. This is why the closed system is the honest instrument:")
print("  it asks how far the composition has moved, not what the consequence will be.")
print("")

// --- the natural term, kg/yr ---
// Cosmic dust entering Earth's atmosphere. The published spread is wide and the
// spread is part of the answer, so both ends are carried, never a midpoint.
// REPORTED: the ablated fraction reaching stratospheric aerosol is commonly placed
// near 20-40 t/day. Both bounds are carried; no midpoint is invented.
let natLo = 20 * 365 * 1000        // 20 t/day  ->  7,300,000 kg/yr
let natHi = 40 * 365 * 1000        // 40 t/day  -> 14,600,000 kg/yr
print("=== THE NATURAL TERM (REPORTED, wide spread carried as a band) ===")
print("  meteoric input to the stratosphere   20 t/day  = \(natLo) kg/yr")
print("                                       40 t/day  = \(natHi) kg/yr")
print("  The spread is a factor of two and it is the literature's, not ours.")
print("")

// --- the human term, kg/yr ---
let scen: [(String, Int, String)] = [
    ("2025, measured",            461_213,  "GCAT, exact row count and mass"),
    ("FCC-authorized 19,408",   1_909_400,  "authorized fleet at 5-yr replacement"),
    ("Gen3 filed 100,000",      9_840_000,  "filed, NOT authorized"),
    ("orbital data centres",   80_000_000,  "operator's own 40,000/yr disposal figure"),
]

print("=== HUMAN INJECTION AS A FRACTION OF THE NATURAL FLUX ===")
print("  \(pad("scenario",26))\(rp("kg/yr",12))   vs 40 t/day      vs 20 t/day")
for (n, kg, _) in scen {
    let hi = pct(kg, natHi)          // against the LARGER natural term = the kinder reading
    let lo = pct(kg, natLo)
    print("  \(pad(n,26))\(rp("\(kg)",12))   \(rp(hi,12))    \(rp(lo,12))")
}
print("")
print("  Read the KINDER column (vs 40 t/day) first. Even there:")
print("")

let odc = 80_000_000
print("=== THE RESULT ===")
print("  At the filed orbital-data-centre disposal rate, human metal injection into")
print("  the stratosphere is")
print("")
print("      \(times(odc, natHi)) the natural meteoric input   (kind reading, 40 t/day)")
print("      \(times(odc, natLo)) the natural meteoric input   (other end, 20 t/day)")
print("")
print("  The stratosphere has carried meteoric metal for the whole history of life.")
print("  This is not a new substance. It is the same kind of material arriving at")
print("  FIVE TO ELEVEN TIMES the rate the planet has ever supplied it.")
print("")
print("  Today, at the measured 2025 rate, the same ratio is \(pct(461_213, natHi)) to \(pct(461_213, natLo)).")
print("  The authorized fleet alone takes it to \(pct(1_909_400, natHi)) to \(pct(1_909_400, natLo)).")
print("")

print("  Stated as the pages state it:")
print("    human injection reaches 5.4 to 10.9 times the natural meteoric input")
print("    the already-authorized fleet alone reaches 13.0% \u{2013} 26.1% of it")
print("")
print("=== WHAT THIS MODEL DOES NOT SAY, and the assumptions that could break it ===")
print("  1. IT NAMES NO CONSEQUENCE. A composition ratio is not an ozone loss, a")
print("     temperature, or a harm. Five chemistry models disagree about the")
print("     consequence and this model settles none of that.")
print("  2. ABLATION FRACTIONS ARE ASSUMED COMPARABLE. Meteoroids arrive at 11-72")
print("     km/s and ablate almost entirely; satellites reenter near 7-8 km/s and a")
print("     fraction survives to the surface. If the ablated fractions differ, the")
print("     ratio moves by that difference. This is the assumption most likely to be")
print("     wrong and it is stated first for that reason.")
print("  3. COMPOSITION DIFFERS. Meteoric smoke is iron- and magnesium-rich silicate;")
print("     satellite ablation is aluminium-rich. Equal mass is not equal chemistry,")
print("     and alumina's surface chemistry is the whole point of the dispute.")
print("  4. THE NATURAL TERM CARRIES A FACTOR-OF-TWO SPREAD, carried here as a band")
print("     rather than collapsed to a midpoint.")
print("  5. STEADY STATE IS ASSUMED. A rising injection rate has not yet reached the")
print("     burden its rate implies, so the CURRENT burden is lower than these")
print("     ratios -- they describe where it settles, not where it is today.")
print("")
print("  Every one of those five is a reason the number could be wrong. None of them")
print("  is a reason not to measure it, and nobody is measuring it.")
