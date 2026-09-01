import Foundation
// THE RESPONSE ENVELOPE — every published result, projected to the filed constellation
// scales. This program invents no scenario. It takes each paper's OWN reported number at
// each paper's OWN stated flux, and scales it to the fluxes that are actually on file.
//
// THE ASSUMPTION, STATED ONCE AND LOUDLY: this is LINEAR scaling. Stratospheric chemistry
// is not linear — heterogeneous reaction rates saturate, dynamical feedbacks can reverse
// sign, and every author here would object to a straight multiplication. It is published
// as an ENVELOPE showing what each result implies if its own mechanism keeps working, not
// as a prediction. Where a paper reports no number, this program reports no number.

struct Model {
    let group: String, model: String, statedFluxGgYr: Double
    let quantity: String, value: Double?, units: String, sign: String
}

// Each row is the paper's own reported value at the paper's own stated flux.
let models = [
    Model(group: "Ferreira 2024", model: "mass only",  statedFluxGgYr: 0.36,
          quantity: "ozone loss", value: nil, units: "—", sign: "none reported"),
    Model(group: "Maloney 2025",  model: "WACCM6+CARMA", statedFluxGgYr: 10.0,
          quantity: "polar vortex wind speed", value: -10.0, units: "%", sign: "weaker ozone hole"),
    Model(group: "Maloney 2025",  model: "WACCM6+CARMA", statedFluxGgYr: 10.0,
          quantity: "temperature anomaly", value: 1.5, units: "K", sign: "warming"),
    Model(group: "Revell 2025",   model: "SOCOLv4",     statedFluxGgYr: 0.0,
          quantity: "ozone at 10 hPa NH", value: 0.27, units: "%", sign: "INCREASE (launch alumina, not reentry)"),
    Model(group: "Barker 2026",   model: "all-mission", statedFluxGgYr: 0.0,
          quantity: "soot forcing, instantaneous", value: 6.47, units: "mW/m2", sign: "warming"),
    Model(group: "Barker 2026",   model: "all-mission", statedFluxGgYr: 0.0,
          quantity: "soot forcing, strat-adjusted", value: -6.40, units: "mW/m2", sign: "COOLING — same model"),
    Model(group: "Vliex 2026",    model: "GEOS-Chem",   statedFluxGgYr: 0.0,
          quantity: "global column ozone loss", value: 85.6, units: "mDU", sign: "depletion, 87.7% from NOx"),
    Model(group: "Vliex 2026",    model: "GEOS-Chem",   statedFluxGgYr: 0.0,
          quantity: "net radiative forcing", value: 4.1, units: "mW/m2", sign: "warming"),
]

func pad(_ s: String, _ w: Int) -> String { var r = s; while r.count < w { r += " " }; return r }
func f(_ x: Double, _ p: Int = 2) -> String { String(format: "%.\(p)f", x) }

print("╔══ WHAT EACH PUBLISHED GROUP ACTUALLY REPORTS ══╗")
print("  \(pad("group",16))\(pad("quantity",34))\(pad("value",12))direction")
for m in models {
    let v = m.value.map { f($0) + " " + m.units } ?? "NOT REPORTED"
    print("  \(pad(m.group,16))\(pad(m.quantity,34))\(pad(v,12))\(m.sign)")
}
print("")
print("  Note the third and fourth Barker rows: ONE model, ONE emissions set, two standard")
print("  definitions of forcing, OPPOSITE SIGNS. That is not a disagreement between groups.")
print("  It is a single result that changes sign depending on which convention you apply.")

print("")
print("╔══ THE FILED SCALES, from primary regulatory documents ══╗")
let scales: [(String, Double, String)] = [
    ("measured today (SPXS 2025)", 0.212, "GCAT, exact"),
    ("FCC-authorized 19,408",       1.909, "FCC 21-48 + DA 26-36"),
    ("Gen3 filed 100,000",          9.840, "SAT-LOA-20260630-00264"),
    ("Orbital DC, deorbiting frac", 80.0,  "SAT-LOA-20260108-00016 + 2026-05-29 filing"),
]
for (n, gg, src) in scales { print("  \(pad(n,32))\(pad(f(gg,3) + " Gg/yr", 16))\(src)") }

print("")
print("╔══ THE ENVELOPE: each result scaled LINEARLY to each filed flux ══╗")
print("  Vliex is the only group reporting a global column-ozone number, so it is the only")
print("  row that can be projected as ozone. Its stated case is the 2024 reentry inventory.")
let vliexBaseFlux = 0.212      // Gg/yr — the 2024-2025 measured reentry scale it models
let vliexMDU = 85.6
let totalColumnMDU = 300_000.0 // ~300 DU global mean total column
print("  baseline: \(f(vliexMDU,1)) mDU global column loss at \(f(vliexBaseFlux,3)) Gg/yr")
print("  total column for reference: ~300 DU = \(Int(totalColumnMDU)) mDU")
print("")
print("  \(pad("flux scenario",32))\(pad("scale",8))\(pad("column loss",16))as % of total column")
for (n, gg, _) in scales {
    let k = gg / vliexBaseFlux
    let mdu = vliexMDU * k
    let pct = mdu / totalColumnMDU * 100
    print("  \(pad(n,32))\(pad(f(k,1)+"x",8))\(pad(f(mdu,1) + " mDU",16))\(f(pct,3))%")
}
print("")
print("  FOR SCALE, the comparisons a reader needs to judge those numbers:")
print("    Montreal-era global mean column loss, peak      ~5%      (~15,000 mDU)")
print("    Antarctic springtime hole, peak                 ~60%     (~180,000 mDU)")
print("    natural year-to-year variability, global mean   ~1-2%    (~3,000-6,000 mDU)")

print("")
print("╔══ WHAT THIS ENVELOPE DOES AND DOES NOT SAY ══╗")
print("  IT DOES SAY: at the largest FILED scale, the one group that publishes a global")
print("  ozone number implies a loss of the order of 32,000 mDU — around 10% of the column,")
print("  which is TWICE the peak Montreal-era global depletion — IF its mechanism scales")
print("  linearly and IF that constellation is built and disposed of as filed.")
print("")
print("  IT DOES NOT SAY that will happen. Three reasons, each of which could dominate:")
print("   1. LINEARITY IS AN ASSUMPTION AND PROBABLY WRONG. Heterogeneous chemistry")
print("      saturates as available surface fills. The real curve almost certainly bends,")
print("      and it could bend either way.")
print("   2. THE OTHER FOUR GROUPS DISAGREE, one of them in the opposite direction. Scale")
print("      Revell instead and you project an ozone INCREASE. Scale Maloney and you")
print("      project a WEAKER polar hole. Both are peer-reviewed.")
print("   3. THE FILED SCALES ARE APPLICATIONS, not authorizations. 19,408 is authorized;")
print("      100,000 and 1,000,000 are requested and may never be granted.")
print("")
print("  THE POINT OF AN ENVELOPE IS THAT YOU DO NOT HAVE TO PICK. The spread between the")
print("  most and least alarming published result, projected to the same filed scale, is")
print("  the size of the thing nobody is measuring. That spread is the argument.")
