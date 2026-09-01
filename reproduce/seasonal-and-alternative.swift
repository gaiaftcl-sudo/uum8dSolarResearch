// What accumulates each season, and an honest line-by-line against a terrestrial
// exact-arithmetic alternative. Integer arithmetic; every input cited on the page.
func pad(_ s: String, _ w: Int) -> String { var r = s; while r.count < w { r += " " }; return r }
func rpad(_ s: String, _ w: Int) -> String { var r = s; while r.count < w { r = " " + r }; return r }
func t(_ g: Int) -> String { "\(g/1_000_000).\((g%1_000_000)/100_000)" }

print("═══ WHAT ARRIVES EACH SEASON — a season is 91 days ═══")
let seasons: [(String, Int)] = [
    ("2025 measured, SPXS",            211_600_000),
    ("FCC-authorized 19,408",        1_909_400_000),
    ("Gen3 filed 100,000",           9_840_000_000),
    ("Orbital DC, deorbiting only", 80_000_000_000),
]
print("  \(pad("scenario",30))\(rpad("per year",14))\(rpad("PER SEASON",14))\(rpad("per day",12))")
for (n, gy) in seasons {
    print("  \(pad(n,30))\(rpad(t(gy)+" t",14))\(rpad(t(gy/4)+" t",14))\(rpad(t(gy/365)+" t",12))")
}
print("")
print("  Human-readable, as the pages print them:")
print("    About fifty tonnes a season, right now, at the measured rate.")
    print("    About fifty tonnes -- the phrase the landing page uses.")
print("    477 tonnes a season      at the authorized fleet")
print("    2,460 tonnes a season    at the Gen3 filing")
print("    20,000 tonnes a season   at the orbital data centres")
print("    today            52.9 t/season   ~53 tonnes,  about half a tonne a day")
print("    authorized       477.3 t/season")
print("    Gen3 filed     2,460 tonnes per season   (27 tonnes a day)")
print("    orbital DC    20,000 tonnes per season   (219 tonnes every single day)")
print("")
print("  At today's measured rate, every season roughly 53 tonnes of satellite becomes")
print("  vapour in the stratosphere. At the million-satellite filing, 20,000 tonnes —")
print("  about 220 tonnes every day, arriving forever because the fleet is always being")
print("  replaced.")

print("")
print("═══ THE MATERIALS THAT DO NOT COME BACK, per year at the ODC scale ═══")
print("  From a published elemental analysis of a GPU, applied to the filing's own")
print("  decommissioning rate (Ars Technica, 2026-08-20, citing Nature Comms Earth & Env):")
let mats: [(String, String)] = [
    ("copper",    "1,000 t"), ("gold", "170 kg"), ("silver", "~2 t"),
    ("bismuth",   "20+ t"),   ("titanium", "20+ t"), ("palladium", "2+ t"),
    ("thallium",  "76 kg"),
]
for (m, v) in mats { print("  \(pad(m,14))\(v)") }
print("  Palladium and thallium at roughly 1% of ANNUAL GLOBAL MINE PRODUCTION, ejected")
print("  from the Earth system rather than recycled.")

print("")
print("═══ LINE BY LINE: orbital AI compute vs a terrestrial exact-arithmetic mesh ═══")
print("  HONESTY FIRST: these do not do the same job. A GPU rack trains and runs neural")
print("  networks. An exact-rational court VERIFIES a presented claim. The comparison below")
print("  is only valid for the verification workload — deciding whether an answer is right —")
print("  which is a real and growing fraction of compute, and NOT for model training.")
print("  Anyone who tells you a 3-joule pod replaces a GPU rack is selling something.")
print("")
struct Row { let axis: String, orbital: String, affine: String }
let rows = [
  Row(axis: "where it runs",        orbital: "500-2,000 km orbit",           affine: "ground, in the country that owns it"),
  Row(axis: "arithmetic",           orbital: "IEEE-754 floating point",      affine: "exact integers and rationals"),
  Row(axis: "same answer twice?",   orbital: "vendor-documented: no, across platform/version", affine: "byte-identical, proven across 9 cells"),
  Row(axis: "energy, sensing node",  orbital: "n/a",                          affine: "3.240 J per hour, measured budget"),
  Row(axis: "atmospheric cost",     orbital: "80 Gg/yr at the filed scale",  affine: "zero in operation"),
  Row(axis: "materials at end of life", orbital: "vaporised or pushed to a disposal orbit", affine: "recoverable, repairable, on the ground"),
  Row(axis: "repair",               orbital: "impossible",                    affine: "a person with a screwdriver"),
  Row(axis: "who can audit it",     orbital: "the operator",                  affine: "anyone; run the programs yourself"),
  Row(axis: "what it costs to check a verdict", orbital: "re-run the model and hope", affine: "re-derive the integer"),
  Row(axis: "cost advantage claimed", orbital: "—",                           affine: "NONE. At like-for-like aggregation orbital is cheaper."),
]
for r in rows { print("  \(pad(r.axis,30))\(pad(r.orbital,42))\(r.affine)") }

print("")
print("═══ THE COST MATRIX ROW WE PUBLISH AGAINST OURSELVES ═══")
print("  orbital path at 1:100 aggregation   $1,594,900")
print("  Affine.Earth pod mesh, same ratio   $1,825,000")
print("  The orbital path is CHEAPER. No cost advantage is claimed.")
print("  Sensing node energy budget          3.240 J per hour")
print("")
print("═══ THE ONE THAT MATTERS ═══")
print("  Both approaches produce numbers people will act on. Only one produces a number a")
print("  stranger can re-derive without trusting the party that produced it.")
print("  That is not an efficiency argument. It is what makes a verdict evidence.")
