// THE AUTHORIZATION TIER LEDGER — every projection carries its regulatory tier.
//
// Built because this program published 10.5 Gg/yr from "42,000 satellites x 1,250 kg",
// and BOTH inputs were wrong:
//   42,000 is TIER-MIXED. FCC 22-91 paragraph 116 decomposes it in the Commission's own
//   words: 29,988 Gen2 SpaceX "has applied for", 4,408 Gen1 authorized, and 7,518 V-band.
//   Two of those three are now stale — the V-band constellation was merged into Gen2 on
//   2023-10-13 and no longer exists separately, and the 29,988 is 15,000 granted with
//   14,988 explicitly DEFERRED.
//   1,250 kg is a proposed bus that never flew. The catalogue's measured fleet is 275-910 kg.
//
// Summing an authorized count with a requested one is the same defect Study 29 convicts
// the reentry literature of. It was committed here and this file is the correction.
//
// Every count below traces to a primary FCC document. Masses are catalogue-measured.

struct Tier { let name: String, count: Int, status: String, src: String }
let tiers = [
  Tier(name: "Gen1 Ku/Ka",        count:   4_408, status: "AUTHORIZED", src: "FCC 21-48, rel. 2021-04-27"),
  Tier(name: "Gen2 tranche 1",    count:   7_500, status: "AUTHORIZED", src: "FCC 22-91, rel. 2022-12-01"),
  Tier(name: "Gen2 tranche 2",    count:   7_500, status: "AUTHORIZED", src: "DA 26-36 para 5, 2026-01-09"),
  Tier(name: "Gen2 remainder",    count:  14_988, status: "DEFERRED",   src: "DA 26-36 para 5 — explicitly not granted"),
  Tier(name: "Direct-to-cell",    count:  15_000, status: "PENDING",    src: "SAT-LOA-20250916-00282; DA 26-471 para 18"),
  Tier(name: "Gen3",              count: 100_000, status: "PENDING",    src: "SAT-LOA-20260630-00264 — SECONDARY sourcing only"),
  Tier(name: "Orbital Data Ctr",  count:1_000_000, status: "PENDING",   src: "SAT-LOA-20260108-00016; accepted DA 26-113, 2026-02-04"),
]

// Catalogue-measured dry mass by bus, with fleet counts
let buses: [(String, Int, Int)] = [
  ("v1.0 / v1.5", 275, 4_680), ("V2 mini", 700, 2_760),
  ("V2 mini optimized", 530, 4_341), ("V2 direct-to-cell", 910, 663),
]
var wsum = 0, wn = 0
for (_, kg, n) in buses { wsum += kg * n; wn += n }
let meanKg = wsum / wn
let LIFE = 5    // SEC-filed useful life, broadband satellites (424B4, 2026-06-12)

func pad(_ s: String, _ w: Int) -> String { var r = s; while r.count < w { r = " " + r }; return r }
func lpad(_ s: String, _ w: Int) -> String { var r = s; while r.count < w { r += " " }; return r }
func t(_ g: Int) -> String { "\(g/1_000_000).\((g%1_000_000)/100_000)" }

print("=== catalogue-measured dry mass, by bus ===")
for (nm, kg, n) in buses { print("  \(lpad(nm,20)) \(pad("\(kg)",4)) kg   n = \(n)") }
print("  fleet-weighted mean \(meanKg) kg")
print("  (the 1,250 kg used earlier is a PROPOSED bus that never flew)")

print("")
print("=== AUTHORIZED TOTAL, the only figure with operating authority ===")
let authorized = tiers.filter { $0.status == "AUTHORIZED" }.reduce(0) { $0 + $1.count }
print("  4,408 Gen1 + 15,000 Gen2 = \(authorized)")
print("  V-band standalone: 0 — merged into Gen2 on 2023-10-13, do NOT add 7,518")

print("")
print("=== projected reentry flux by tier, at the SEC-filed 5-year life ===")
print("  \(lpad("tier",20)) \(pad("count",9))  \(lpad("status",11)) \(pad("units/yr",9)) \(pad("mass t/yr",11)) \(pad("alumina",9))")
for x in tiers {
  let perYr = x.count / LIFE, g = perYr * meanKg * 1000
  print("  \(lpad(x.name,20)) \(pad("\(x.count)",9))  \(lpad(x.status,11)) \(pad("\(perYr)",9)) \(pad(t(g),11)) \(pad(t(g*3/25),9))")
}
let authG = (authorized / LIFE) * meanKg * 1000
print("  \(lpad("AUTHORIZED TOTAL",20)) \(pad("\(authorized)",9))  \(lpad("AUTHORIZED",11)) \(pad("\(authorized/LIFE)",9)) \(pad(t(authG),11)) \(pad(t(authG*3/25),9))")

print("")
print("=== against measurement, and one figure cuts against the alarm ===")
let m2025 = 211_600_000, trailing = 178_000_000, esa = 450_000_000
print("  2025 measured (catalogue)      \(t(m2025)) t/yr")
print("  trailing 365-day rate          \(t(trailing)) t/yr")
print("  ESA studies ASSUMED average    \(t(esa)) t/yr   — cited by SpaceX in FCC 22-91")
print("  THE MEASURED FLUX IS BELOW WHAT THE REGULATOR WAS GIVEN. Stated because omitting")
print("  a figure that cuts against your own case is the defect this program is named for.")
print("")
print("  AUTHORIZED TOTAL is \(authG / m2025)x the 2025 measured rate")
let odc = (1_000_000 / LIFE) * meanKg * 1000
print("  the PENDING Orbital Data Center application is \(odc / m2025)x it")


print("")
print("=== WHAT ACTUALLY ENTERS THE ATMOSPHERE — SpaceX's own demisability figure ===")
print("  Michael Nicolls, SpaceX, 2025-02-26, on the V2 mini:")
print("    \"approximately 5% of the mass of the entire satellite could survive reentry.")
print("     The biggest contributor (~90% of the surviving mass) is silicon from the solar cells.\"")
print("")
print("  So ~95% ABLATES. Applied to the measured flux, and this is SpaceX's own number")
print("  used against its own mass ledger:")
let measuredDry = 178_000_000        // trailing-365-day dry mass, grams
let ablated = measuredDry * 95 / 100
let survives = measuredDry * 5 / 100
print("    trailing measured dry mass   \(t(measuredDry)) t/yr")
print("    ablates into the atmosphere  \(t(ablated)) t/yr   (95%)")
print("    survives to the surface      \(t(survives)) t/yr   (5%, ~90% of it silicon)")
print("")
print("  NOTE WHAT THIS DOES AND DOES NOT SUPPORT. It confirms that nearly all the mass")
print("  enters the atmosphere as vapour rather than reaching the ground — which is the")
print("  premise of every alumina argument. It ALSO says the surviving fraction is mostly")
print("  SILICON, not aluminium, and the document states no aluminium fraction at all.")
print("  The 3/25 alumina yield comes from Ferreira, not from SpaceX.")

print("")
print("=== PRECISION OF THE MASS FIELD, stated because it bounds every figure above ===")
print("  GCAT column semantics: Mass = launch mass, UNFLAGGED for Starlink (reliable).")
print("  DryMass carries flag '?' = ESTIMATE, plus or minus about 20%.")
print("  Every dry-mass figure in this ledger therefore carries +/-20%, and the projections")
print("  inherit it. The launch-mass figures do not.")
print("  Only TWO Starlink masses are SpaceX-stated: v0.9 at 227 kg (2019 press kit) and")
print("  V2 mini Optimized at 575 kg at launch (2024 Progress Report p.25). Every other")
print("  figure is third-party or an unlabelled 'DAS Mass' from an FCC filing.")
print("  The 1,250 kg this program used earlier appears in NO filing — it traces to a public")
print("  remark. The FCC's Starship-launched figure is 2,000 kg.")
print("  V3 has never reached orbit: 20 deployed suborbital on 2026-07-24, all demised.")

print("")
print("=== on-orbit headroom, single-tracker basis ===")
print("  in orbit 11,093 against 19,408 authorized -> headroom 8,315")
print("  ITU Resolution 35 DEPLOYED, as actually reported: 735")
print("  Gen2 milestone: 50% = 7,500 satellites due 2028-12-01 (DA 26-36 retains it)")
print("  Basis is one tracker; no independent orbital-determination cross-check was available.")
