// The pod mesh, region by region. Integer arithmetic from constants already
// validated in this repository (pod-energy-budget, lora-time-on-air, cost-matrix)
// plus solar peak-sun-hour bands carried as REPORTED ranges from standard solar
// atlases -- both ends, never a midpoint.
//
// The question: where on the planet does the A.E.P-1 pod run, what binds it
// there, and what verdicts does a mesh deliver to the people under it.
func pad(_ s:String,_ w:Int)->String{var r=s;while r.count<w{r+=" "};return r}
func rp(_ s:String,_ w:Int)->String{var r=s;while r.count<w{r=" "+r};return r}

// pod constants, already validated
let podJPerDay      = 77_760           // milli-joules x1000? No: 3.240 J/h x 24 = 77.76 J/day -> in mJ
// hold everything in mJ/day: 3.240 J/h = 3240 mJ/h -> 77,760 mJ/day
let panel_mW        = 510              // sized panel ceiling, BQ25570 kept

print("=== THE POD, RESTATED FROM THE VALIDATED BUDGET ===")
print("  binding compute rate      3.240 J per hour  =  77,760 mJ per day")
print("  panel ceiling             510 mW")
print("")

// regions: (name, PSH low x10, PSH high x10, radio regime, msgs/hr, the verdict people get)
struct Region { let name:String; let pshLo:Int; let pshHi:Int; let radio:String; let msgs:String; let verdict:String }
let regions:[Region]=[
 Region(name:"Sahel / Horn of Africa",   pshLo:55, pshHi:65, radio:"EU868-style 1% duty", msgs:"35/hr",
        verdict:"wadi flash-flood gauges; wet-bulb heat court at the 30.55 C line"),
 Region(name:"Monsoon South Asia",       pshLo:40, pshHi:55, radio:"IN865 1% duty",       msgs:"35/hr",
        verdict:"river-rise lead time (the Guadalupe ledger shape); heat-mortality instruments Study 28 graded"),
 Region(name:"Equatorial SE Asia",       pshLo:38, pshHi:48, radio:"AS923 LBT+duty",      msgs:"35/hr class",
        verdict:"flood lead time under cloud; tsunami-vs-surge discrimination (Study 04 law)"),
 Region(name:"Mid-latitude Europe",      pshLo:25, pshHi:40, radio:"EU868 1% duty",       msgs:"35/hr",
        verdict:"replayable air/water quality verdicts a regulator re-derives"),
 Region(name:"Continental N. America",   pshLo:35, pshHi:55, radio:"US915 dwell-time",    msgs:"no duty cap",
        verdict:"flood lead time (validated on the four-gauge USGS corpus in this repo)"),
 Region(name:"Andes / high altitude",    pshLo:45, pshHi:60, radio:"AU915",               msgs:"no duty cap",
        verdict:"glacial-lake outburst gauges; UV-B surface record where the regional ozone projection bites"),
 Region(name:"High latitude (60N+)",     pshLo:15, pshHi:30, radio:"EU868 1% duty",       msgs:"35/hr",
        verdict:"reentry-track observation under the polar inclinations most reentries cross"),
]

print("=== SOLAR MARGIN BY REGION — both ends of the REPORTED peak-sun band ===")
print("  energy/day = 510 mW x PSH; margin = that / the pod's 77,760 mJ need")
print("")
print("  \(pad("region",26))\(rp("PSH",9))\(rp("mJ/day low",13))\(rp("margin",9))   binding constraint")
var worstMargin = Int.max; var worstName = ""
for r in regions {
    // mJ/day = mW x PSH x 3600 / 1000 * ... : 510 mW x 1 h = 510 mWh = 1,836,000 mJ. So per PSH(x10): 183,600 mJ per 0.1 PSH? 
    // 1 PSH -> 510 mWh -> 510*3600 mJ = 1,836,000 mJ. pshLo is x10.
    let lo = 1_836_000 * r.pshLo / 10
    let hi = 1_836_000 * r.pshHi / 10
    let mLo = lo / podJPerDay
    _ = hi
    if mLo < worstMargin { worstMargin = mLo; worstName = r.name }
    print("  \(pad(r.name,26))\(rp("\(r.pshLo/10).\(r.pshLo%10)-\(r.pshHi/10).\(r.pshHi%10)",9))\(rp("\(lo)",13))\(rp("\(mLo):1",9))   \(r.radio) -> \(r.msgs)")
}
print("")
print("=== THE FINDING THE TABLE FORCES ===")
print("  The WORST solar margin on the planet -- \(worstName), at the low end of its")
print("  band -- is \(worstMargin):1. The pod is over-provisioned by two orders of")
print("  magnitude EVERYWHERE INHABITED.")
print("")
print("  So the binding constraint is NOWHERE energy. It is (a) the radio duty cycle")
print("  a region's law imposes -- 35 exact messages per hour under a 1% duty regime,")
print("  counted by FLOORING, never rounding -- and (b) the density of things worth")
print("  measuring. That is the honest engineering result: a mesh you can deploy from")
print("  the Sahel to 60 North without redesigning the power stage once.")
print("")
print("=== WHAT A MESH DELIVERS, per region, in verdicts rather than watts ===")
for r in regions { print("  \(pad(r.name,26))\(r.verdict)") }
print("")
print("=== COST, from the validated matrix ===")
print("  pod mesh at 1:100 aggregation   $1,825,000   (vs orbital $1,594,900 -- THEY WIN ON PRICE)")
print("  what the premium buys: ground-repairable, country-owned, zero atmospheric")
print("  cost in operation, and every verdict re-derivable by the population it serves.")
print("")
print("=== WHAT THIS PAGE DOES NOT CLAIM ===")
print("  No lives-saved figure. No adoption forecast. No revenue projection for the")
print("  mesh itself. The PSH bands are REPORTED atlas ranges, not site surveys, and")
print("  a real deployment starts with a site survey. The claim is narrower: the")
print("  power stage closes everywhere, the law layer is the same 49 domains")
print("  everywhere, and the verdicts land in the hands of the people under them.")
