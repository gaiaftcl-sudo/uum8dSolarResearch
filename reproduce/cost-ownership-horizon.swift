// The cost row, completed over time. The validated matrix priced ONE moment:
// t=0 capex at like-for-like aggregation, orbital $1,594,900 vs mesh $1,825,000
// -- orbital wins, and that row STAYS. But a t=0 comparison structurally favours
// a subscription architecture, because the subscription's cost lives in years
// 1..N and its hardware retires on the operator's own SEC-filed five-year life.
// This program extends the SAME workload over a 15-year horizon, integers only.
func pad(_ s:String,_ w:Int)->String{var r=s;while r.count<w{r+=" "};return r}
func rp(_ s:String,_ w:Int)->String{var r=s;while r.count<w{r=" "+r};return r}
func usd(_ c:Int)->String{var s="\(c)";var o="";while s.count>3{o=","+s.suffix(3)+o;s=String(s.dropLast(3))};return "$"+s+o}

let orbCapex  = 1_594_900          // MEASURED — cost-matrix.swift, like-for-like aggregation
let meshCapex = 1_825_000          // MEASURED — same program
let satLife   = 5                  // the operator's own SEC-filed replacement life, in years

print("=== T=0, RESTATED WITHOUT FLINCHING ===")
print("  orbital \(usd(orbCapex))  vs  mesh \(usd(meshCapex))  ->  ORBITAL WINS AT T=0.")
print("  That row is measured and it stays. What follows completes it, not replaces it.")
print("")
print("=== THE HORIZON — the same workload, 15 years, both cost structures ===")
print("  orbital: re-buys itself every \(satLife) years (the operator's own filed life).")
print("  mesh: bought once, ground-repairable; maintenance carried as a band of")
print("  2% to 5% of capex per year (ILLUSTRATION band, labelled as such -- a real")
print("  deployment prices maintenance from its own spares ledger).")
print("")
print("  \(pad("year",6))\(rp("orbital cumulative",20))\(rp("mesh low (2%)",16))\(rp("mesh high (5%)",16))")
var cross = 0
for y in [0,4,5,9,10,14] {   // a buy at exactly y=15 opens the NEXT period; 3 buys cover this horizon
    let orb = orbCapex * (1 + y/satLife)
    let mLo = meshCapex + meshCapex*2*y/100
    let mHi = meshCapex + meshCapex*5*y/100
    if cross==0 && orb > mHi { cross = y }
    print("  \(pad("\(y)",6))\(rp(usd(orb),20))\(rp(usd(mLo),16))\(rp(usd(mHi),16))")
}
print("")
print("=== THE CROSSOVER ===")
print("  The mesh overtakes the orbital path at year \(cross) -- THE FIRST REPLACEMENT")
print("  CYCLE -- and the gap widens every cycle after, on the operator's own filed")
print("  hardware life. Over 15 years: orbital \(usd(orbCapex*3)) against mesh")
print("  \(usd(meshCapex + meshCapex*5*15/100)) at the WORST maintenance band. Both readings are true:")
print("  THEY WIN THE MOMENT OF PURCHASE. OWNERSHIP WINS EVERY YEAR AFTER YEAR \(cross).")
print("")
print("=== THE RENT STRUCTURE — the axis the price column cannot see ===")
print("  A subscription architecture is a one-way flow: the user pays every month,")
print("  forever, for hardware that retires on the operator's schedule, at a price")
print("  the operator sets, into an asset the community never owns. At the widely")
print("  published REPORTED residential rate of ~$120/month, one hundred households")
print("  send \(usd(120*100*12)) OUT of their local economy every year --")
print("  \(usd(120*100*12*15)) over the fifteen-year horizon -- and own nothing at the end.")
print("  A mesh the community buys is the same money kept: paid once, repaired")
print("  locally, priced by no one, and still standing.")
print("")
print("=== SCOPE, REFUSED IN CAPITALS SO NOBODY QUOTES PAST IT ===")
print("  THE POD MESH IS NOT BROADBAND. LoRa moves telemetry -- 35 exact messages an")
print("  hour under a 1% duty regime -- verdicts, gauges, warnings, court calls. It")
print("  does not stream video and this page never claims it does. The rent figures")
print("  above are the STRUCTURE of subscription versus ownership, shown on the one")
print("  product where a like-for-like number exists (the verification workload the")
print("  matrix priced). Different products; same ownership arithmetic.")
print("")
print("=== THE ETHICS, STATED AS ARITHMETIC ===")
print("  Rent extraction is not a moral flourish; it is a direction of flow. Every")
print("  architecture above delivers connectivity. Exactly one of them leaves the")
print("  capital, the repair skills, the pricing power and the hardware IN the")
print("  community it serves -- and sends nothing to the stratosphere when it dies.")
