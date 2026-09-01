// Gate 1 check: does a 500 mW nominal panel close the budget, and by how much?
// Integer microjoules / microwatt-hours throughout.
let podUjPerHour   = 6_660_453      // measured budget, 125 tx/hr ceiling (42 B frame)
let sleepUjPerHour =    81_828      // sleep-only floor, delta-driven quiet environment
let hoursPerDay    = 24

func wh(_ uj: Int) -> String {       // microjoules -> Wh, 4dp, integer-scaled
    // 1 Wh = 3600 J = 3_600_000_000 uJ
    let t = Int64(uj) * 10_000 / 3_600_000_000
    let i = t / 10_000, f = t % 10_000
    var s = "\(f)"; while s.count < 4 { s = "0" + s }
    return "\(i).\(s) Wh"
}

print("=== DEMAND, per day ===")
let ceilDay  = podUjPerHour * hoursPerDay
let floorDay = sleepUjPerHour * hoursPerDay
// founder's stated comparison case: hourly LoRa burst instead of the 125/hr ceiling
let perTxUj = 42_729 + 9_900                       // tx + wake
let hourlyBurstDay = sleepUjPerHour * hoursPerDay + perTxUj * hoursPerDay
print("  duty-cycle CEILING (125 tx/hr, every hour) : \(ceilDay) uJ = \(wh(ceilDay))")
print("  hourly burst (1 tx/hr, delta-driven)       : \(hourlyBurstDay) uJ = \(wh(hourlyBurstDay))")
print("  quiet floor (sleep only, no tx)            : \(floorDay) uJ = \(wh(floorDay))")

print("")
print("=== SUPPLY, 500 mW nominal panel ===")
for (cond, mw, hrs) in [("full sun, 5 h equivalent", 500, 5),
                        ("overcast, 100 mW, 24 h", 100, 24),
                        ("overcast, 100 mW, 8 h",  100, 8),
                        ("deep winter, 50 mW, 4 h", 50, 4)] {
    let uj = mw * 1000 * hrs * 3600          // mW -> uW -> uJ over hrs
    print("  \(cond): \(wh(uj))")
    for (dn, du) in [("ceiling", ceilDay), ("hourly burst", hourlyBurstDay), ("quiet floor", floorDay)] {
        let margin = uj / du
        print("      vs \(dn): \(margin)x")
    }
}
