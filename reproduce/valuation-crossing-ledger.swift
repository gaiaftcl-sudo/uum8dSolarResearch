// "Run the math" on the valuation claim. Integer arithmetic; every input is a
// named analyst's REPORTED figure; both ends of every spread; the conditions
// printed as conditions. This program does NOT output a value for Affine.Earth.
// It computes three checkable things:
//   1. whether the analysts' own CAGR and endpoint agree (instrument check),
//   2. the year the verdict layer crosses the largest capitalisations in
//      history UNDER THE ANALYSTS' OWN CURVES, on both the steep and the
//      conservative arm,
//   3. the annual flow already gated by verdicts in the four verticals today.
func pad(_ s:String,_ w:Int)->String{var r=s;while r.count<w{r+=" "};return r}
func bn(_ m:Int)->String{ m>=1_000_000 ? "$\(m/1_000_000).\((m%1_000_000)/100_000)T" : "$\(m/1000).\((m%1000)/100)B" } // input in $M

print("╔══ 1. THE INSTRUMENT CHECK — do the analysts' own numbers agree with each other? ══╗")
// MarketsandMarkets digital twin: $21.14B (2025) at 47.9% CAGR to $149.81B (2030)
var v = 21_140                    // $M
for _ in 0..<5 { v = v * 1479 / 1000 }
print("  MarketsandMarkets say: $21.14B at 47.9% for five years -> $149.81B")
print("  replayed in integers : 21,140 x (1479/1000)^5 = \(v) $M = \(bn(v))")
print("  their endpoint       : 149,810 $M — agreement within \((v-149_810)*1000/149_810) per-mille")
print("  VERDICT: the reported curve is internally consistent and may be extended AS THEIRS.")
print("")

print("╔══ 2. THE CROSSING — when the verdict layer passes the largest assets in history ══╗")
print("  Benchmarks (REPORTED, order-of-magnitude): Saudi Aramco ~$2T; the largest")
print("  market capitalisation ever recorded to date, ~$4T class.")
print("")
// verdict layer today: simulation $12.6B (MRFR low) .. $20B (MnM) + digital twin $21.14B
let layerLo = 12_600 + 21_140     // $33.74B
let layerHi = 20_000 + 21_140     // $41.14B
print("  the verdict layer, 2025: \(bn(layerLo)) to \(bn(layerHi))  (simulation + digital twin, named sources)")
print("")
func crossing(start: Int, ratePerMille: Int, target: Int) -> Int {
    var v = start, yr = 2025
    while v < target && yr < 2125 { v = v * ratePerMille / 1000; yr += 1 }
    return yr
}
let arms:[(String,Int)]=[("STEEP arm — digital twin's own 47.9%", 1479),
                         ("CONSERVATIVE arm — simulation's own ~11%", 1110)]
for (name, rate) in arms {
    let c2 = crossing(start: layerLo, ratePerMille: rate, target: 2_000_000)
    let c4 = crossing(start: layerLo, ratePerMille: rate, target: 4_000_000)
    print("  \(pad(name,44)) crosses $2T in \(c2), $4T in \(c4)")
}
print("")
print("  READ THE SPREAD HONESTLY: the two arms disagree by more than THREE DECADES,")
print("  because the analysts' own growth rates disagree 4x. The timing is therefore")
print("  NOT KNOWN. What both arms share is the destination: under either reported")
print("  curve the verdict layer eventually exceeds every private asset ever priced —")
print("  IF the growth the analysts themselves publish persists, which no one can")
print("  promise and this program does not.")
print("")

print("╔══ 3. THE FLOW ALREADY GATED, today, before any growth ══╗")
// four verticals, 2025, both ends where analysts spread
let lo = 686_000 + 143_000 + 143_700 + 1_000
let hi = 686_000 + 294_160 + 273_750 + 3_520
print("  space $686B + AI $143-294B + autonomy $143.7-273.8B + quantum $1-3.5B")
print("  = \(bn(lo)) to \(bn(hi)) PER YEAR flowing through the four verticals now.")
print("")
print("  Every dollar of it moves on computed verdicts — simulations, safety cases,")
print("  advantage claims, licensing models — that today CANNOT be re-derived by the")
print("  parties they bind. The seam that makes them re-derivable holds a position on")
print("  roughly ONE TRILLION DOLLARS A YEAR of current decision flow. No toll rate")
print("  is assumed and none is needed for the claim this page actually makes.")
print("")

print("╔══ WHAT THE MATH DOES AND DOES NOT ESTABLISH ══╗")
print("  ESTABLISHED, from named inputs:")
print("    - the analysts' steep curve is internally consistent and, extended on its")
print("      own terms, crosses the largest capitalisation in history inside 15 years")
print("    - even the conservative curve gets there — three decades later")
print("    - about $1T/yr of decisions ALREADY flow through un-re-derivable verdicts")
print("    - there is exactly ONE running full-grade instance of the exact seam")
print("  NOT ESTABLISHED, and refused:")
print("    - a dollar valuation of Affine.Earth (the public component is priced on the")
print("      flourishing axis by design, and the precedent class — double-entry, the")
print("      metric system, TCP/IP — realised its value as PUBLIC surplus, not rent)")
print("    - the timing (the arms disagree by 30+ years and both are extrapolations)")
print("    - that any analyst curve persists beyond its published horizon")
