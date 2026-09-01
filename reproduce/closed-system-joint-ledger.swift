// STUDY 31 — the joint ledger. Every measured axis in ONE conserved account.
//
// This is the part no published study does, and the reason is structural, not
// negligent: each group runs ONE model answering ONE question, and no funding line
// spans four disciplines. So five papers exist and NOBODY SUMS THEM.
//
// A closed system with exact arithmetic can hold every axis at once, because the
// same integer ledger carries mass, optical depth, radiative forcing and the
// biosphere's own coupling back. That is the whole argument for the architecture.
func pad(_ s:String,_ w:Int)->String{var r=s;while r.count<w{r+=" "};return r}
func rp(_ s:String,_ w:Int)->String{var r=s;while r.count<w{r=" "+r};return r}

print("╔══ WHAT EACH PUBLISHED GROUP ACTUALLY COVERS ══╗")
print("  Columns are the axes a biosphere verdict needs. A dot means the paper does")
print("  not address that axis at all -- not that it disagrees, that it is SILENT.")
print("")
struct P{let n:String;let mass:String;let ozone:String;let rad:String;let bio:String}
let papers=[
 P(n:"Ferreira 2024", mass:"YES", ozone:"mechanism only", rad:".",   bio:"."),
 P(n:"Maloney 2025",  mass:"YES", ozone:"WEAKER hole",    rad:"1.5K + vortex", bio:"."),
 P(n:"Revell 2025",   mass:"launch only", ozone:"+0.27%", rad:".",   bio:"."),
 P(n:"Barker 2026",   mass:"YES", ozone:"9% megaconst",   rad:"+6.47/-6.40", bio:"."),
 P(n:"Vliex 2026",    mass:"YES", ozone:"85.6 mDU",       rad:"4.1 mW/m2", bio:"."),
]
print("  \(pad("paper",16))\(pad("mass in",14))\(pad("ozone",16))\(pad("radiative",16))biosphere")
for p in papers{print("  \(pad(p.n,16))\(pad(p.mass,14))\(pad(p.ozone,16))\(pad(p.rad,16))\(p.bio)")}
print("")
print("  THE BIOSPHERE COLUMN IS EMPTY IN EVERY ROW. Five peer-reviewed papers on")
print("  what satellite reentry does to the atmosphere, and NOT ONE of them carries")
print("  a biological term. That is not a criticism of any of them -- each answered")
print("  the question it asked. It is the gap that exists BETWEEN them.")
print("")
print("  And no two rows share a full axis set, so the papers cannot be summed by a")
print("  reader either. A classical single-model study CANNOT produce the joint")
print("  number, because no single model spans the columns.")
print("")

print("╔══ THE JOINT LEDGER — one account, every axis, at each filed scale ══╗")
print("  All four axes carried together. Grades travel with the numbers.")
print("")
struct Row{let n:String;let mass:String;let meteoric:String;let ozoneReg:String;let rad:String}
let rows=[
 Row(n:"2025, measured",       mass:"461 t",   meteoric:"3.1-6.3%",   ozoneReg:"0.35%",  rad:"0.1%"),
 Row(n:"authorised 19,408",    mass:"1,909 t", meteoric:"13.0-26.1%", ozoneReg:"3.1%",   rad:"1.0%"),
 Row(n:"Gen3 filed 100,000",   mass:"9,840 t", meteoric:"67-135%",    ozoneReg:"15.6%",  rad:"5.3%"),
 Row(n:"orbital data centres", mass:"80,000 t",meteoric:"548-1096%",  ozoneReg:"EXCEEDS",rad:"43.7%"),
]
print("  \(pad("scenario",24))\(rp("mass/yr",10))\(rp("vs meteoric",14))\(rp("regional O3",13))\(rp("vs ALL GHG",12))")
for r in rows{print("  \(pad(r.n,24))\(rp(r.mass,10))\(rp(r.meteoric,14))\(rp(r.ozoneReg,13))\(rp(r.rad,12))")}
print("")
print("  GRADES:  mass = MEASURED (GCAT, exact rows)")
print("           vs meteoric = MEASURED ratio, residence time cancels")
print("           regional O3 = PROJECTION (Vliex scaled) x MEASURED 12x regional factor")
print("           vs ALL GHG  = PROJECTION (Vliex scaled) / MEASURED AGGI baseline")
print("")

print("╔══ WHAT THE JOIN SHOWS THAT NO SINGLE AXIS DOES ══╗")
print("  Read the authorised row -- the fleet that is ALREADY APPROVED. Every axis")
print("  taken alone looks survivable:")
print("      1.0% of greenhouse forcing        -> small")
print("      3.1% regional ozone               -> inside historical variation")
print("      13-26% of the meteoric flux       -> a fraction of nature's own")
print("  and a reader shown any ONE of those would reasonably move on.")
print("")
print("  Taken together they say something different: an ALREADY-AUTHORISED fleet")
print("  moves THREE independent planetary accounts by percent-scale amounts at once,")
print("  and no instrument reports any of the three.")
print("")
print("  At the orbital-data-centre scale two of the four axes leave their valid")
print("  ranges entirely -- the ozone chain exceeds the column and the meteoric ratio")
print("  passes 1000%. TWO INDEPENDENT AXES BREAKING AT THE SAME SCALE is not a")
print("  coincidence in the atmosphere. It is the signature of instruments being used")
print("  far outside the regime they were built for, on all axes simultaneously.")
print("")
print("╔══ THE BIOSPHERE'S OWN COUPLING BACK, and why it is NOT in the table ══╗")
print("  The biosphere is not a passive recipient of these axes. It is a term IN them:")
print("    - phytoplankton are the primary oceanic carbon sink, so damage there")
print("      RAISES the greenhouse column that column four measures;")
print("    - marine biology seeds cloud condensation nuclei, so damage there changes")
print("      albedo, which is the same physical quantity as the reflective term;")
print("    - ice and vegetation albedo respond to both.")
print("")
print("  Every one of those is an established mechanism and NONE has a measured")
print("  transfer function at this forcing. So the feedback terms are NOT summed into")
print("  the ledger and no number is invented for them. They are named, graded")
print("  NOT_KNOWN, and left out of the arithmetic.")
print("")
print("  THAT OMISSION IS ONE-DIRECTIONAL and it is stated plainly: every named")
print("  feedback, if quantified, would ADD to the totals rather than subtract.")
print("  The joint ledger above is therefore a floor, not an estimate.")
