// 10,000 sensing sites, 10 years. Integer cents throughout.
let sites = 10_000, months = 120
func usd(_ c: Int) -> String {
    let d = c / 100
    var s = "\(d)", out = "", n = 0
    for ch in s.reversed() { if n > 0 && n % 3 == 0 { out = "," + out }; out = String(ch) + out; n += 1 }
    s = out
    return "$" + s
}
print("=== ORBITAL, one terminal PER SITE (the draft's assumption) ===")
for (mkt, kitC, moC) in [("US, Mini + Residential 100", 19_900, 5_500),
                         ("US, Standard + MAX",        34_900, 13_000),
                         ("Kenya, Mini + 50 GB",        5_280, 1_000),
                         ("Nigeria, residential",      19_900, 3_900)] {
    let cap = sites * kitC, op = sites * moC * months
    print("  \(mkt): CapEx \(usd(cap)) + OpEx \(usd(op)) = \(usd(cap + op))")
}
print()
print("=== ORBITAL, AGGREGATED — 1 terminal backhauls N sites (what a reviewer builds) ===")
for n in [10, 50, 100] {
    let terms = sites / n
    for (mkt, kitC, moC) in [("US Standard+MAX", 34_900, 13_000), ("Kenya Mini+50GB", 5_280, 1_000)] {
        let cap = terms * kitC, op = terms * moC * months
        print("  1:\(n) (\(terms) terminals) \(mkt): \(usd(cap + op))")
    }
}
print()
print("=== A.E.P-1, 10,000 pods ===")
for (label, pod) in [("BOM-realistic $25", 2_500), ("BOM-realistic $30", 3_000)] {
    // gateways: 100 LoRa gateways, one per 100 pods, each needing backhaul
    let gwHw = 100 * 15_000                       // $150 gateway
    let gwOp = 100 * 13_000 * months              // each gateway still buys a US MAX uplink
    let pods = sites * pod
    print("  \(label): pods \(usd(pods)) + gw hw \(usd(gwHw)) + gw uplink \(usd(gwOp)) = \(usd(pods + gwHw + gwOp))")
}
