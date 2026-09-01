import Foundation
// Guadalupe River, 2025-07-04. USGS NWIS instantaneous values, parameter 00065 (gauge
// height, feet). Public, anonymous, no key. Stage carried as EXACT INTEGER MILLI-FEET:
// the served values have two decimals, so x1000 is exact and no float enters the ledger.
struct P { let minOfDay: Int; let milliFt: Int }

func load(_ path: String) -> [P] {
    guard let s = try? String(contentsOfFile: path, encoding: .utf8) else { return [] }
    var out: [P] = []
    for line in s.split(separator: "\n") {
        let f = line.split(separator: "\t", omittingEmptySubsequences: false)
        guard f.count >= 2, f[1] != "-999999" else { continue }
        let dt = String(f[0])                       // 2025-07-04T05:10:00.000-05:00
        guard let tI = dt.firstIndex(of: "T") else { continue }
        let day = String(dt[dt.startIndex..<tI])
        let hm = dt[dt.index(after: tI)...].prefix(5).split(separator: ":")
        guard hm.count == 2, let h = Int(hm[0]), let m = Int(hm[1]) else { continue }
        let dayOff = day.hasSuffix("-07-03") ? 0 : (day.hasSuffix("-07-04") ? 1440 : 2880)
        // exact: two decimals -> milli-feet, integer, via string split (never a float parse)
        let v = String(f[1]).split(separator: ".")
        let whole = Int(v[0]) ?? 0
        var frac = v.count > 1 ? String(v[1]) : "0"
        while frac.count < 3 { frac += "0" }
        let milli = whole * 1000 + (Int(frac.prefix(3)) ?? 0)
        out.append(P(minOfDay: dayOff + h * 60 + m, milliFt: milli))
    }
    return out.sorted { $0.minOfDay < $1.minOfDay }
}
func hhmm(_ t: Int) -> String {
    let d = t / 1440, r = t % 1440
    return String(format: "07-%02d %02d:%02d", 3 + d, r / 60, r % 60)
}
func ft(_ m: Int) -> String { "\(m / 1000).\(String(format: "%03d", m % 1000))" }

let gauges: [(String, String, Int)] = [
    ("Hunt",          "s_08165500.tsv", 0),
    ("Kerrville",     "s_08166200.tsv", 0),
    ("Comfort",       "s_08167000.tsv", 0),
    ("Spring Branch", "s_08167500.tsv", 0),
]

print("=== peak and record end, exact milli-feet ===")
var peaks: [String: (Int, Int)] = [:]
var series: [String: [P]] = [:]
for (name, path, _) in gauges {
    let s = load(path); series[name] = s
    guard let pk = s.max(by: { $0.milliFt < $1.milliFt }), let last = s.last else { continue }
    peaks[name] = (pk.minOfDay, pk.milliFt)
    print("  \(name.padding(toLength: 14, withPad: " ", startingAt: 0)) peak \(ft(pk.milliFt)) ft at \(hhmm(pk.minOfDay))   last reading \(hhmm(last.minOfDay))")
}

print("\n=== THE WAVE: peak-to-peak propagation lag ===")
if let h = peaks["Hunt"] {
    for n in ["Kerrville", "Comfort", "Spring Branch"] {
        if let p = peaks[n] { print("  Hunt -> \(n.padding(toLength: 14, withPad: " ", startingAt: 0)) \(p.0 - h.0) min") }
    }
}

print("\n=== THE LEAD TIME THAT EXISTED IN PUBLIC DATA ===")
// Frozen threshold, stated before the test: 10.000 ft = 10000 milli-feet.
let TH = 10_000
func firstCrossing(_ n: String) -> P? { series[n]?.first { $0.milliFt >= TH } }
if let hc = firstCrossing("Hunt"), let kc = firstCrossing("Kerrville") {
    print("  threshold frozen at \(ft(TH)) ft")
    print("  Hunt      crosses at \(hhmm(hc.minOfDay))")
    print("  Kerrville crosses at \(hhmm(kc.minOfDay))")
    print("  LEAD TIME AVAILABLE AT KERRVILLE: \(kc.minOfDay - hc.minOfDay) minutes")
    // what was Kerrville's own stage when Hunt crossed?
    if let at = series["Kerrville"]?.last(where: { $0.minOfDay <= hc.minOfDay }) {
        print("  Kerrville stage at that moment: \(ft(at.milliFt)) ft")
    }
}

print("\n=== rate of rise, exact milli-feet per minute ===")
for n in ["Hunt", "Kerrville"] {
    guard let s = series[n] else { continue }
    var best = (0, 0, 0)   // rate, from, to
    for i in 1..<s.count {
        let dt = s[i].minOfDay - s[i-1].minOfDay
        guard dt > 0, dt <= 30 else { continue }
        let r = (s[i].milliFt - s[i-1].milliFt) / dt
        if r > best.0 { best = (r, s[i-1].minOfDay, s[i].minOfDay) }
    }
    print("  \(n): max \(best.0) milli-ft/min = \(ft(best.0 * 60)) ft/hour, between \(hhmm(best.1)) and \(hhmm(best.2))")
    if let a = s.first(where: { $0.minOfDay >= 1440 + 3*60 }), let b = s.first(where: { $0.minOfDay >= 1440 + 4*60 + 35 }) {
        print("     \(hhmm(a.minOfDay)) \(ft(a.milliFt)) ft -> \(hhmm(b.minOfDay)) \(ft(b.milliFt)) ft = \(ft(b.milliFt - a.milliFt)) ft in \(b.minOfDay - a.minOfDay) min")
    }
}

print("\n=== the gap in the Hunt record ===")
if let s = series["Hunt"] {
    for i in 1..<s.count where s[i].minOfDay - s[i-1].minOfDay > 10 {
        print("  \(s[i].minOfDay - s[i-1].minOfDay)-minute gap: \(hhmm(s[i-1].minOfDay)) (\(ft(s[i-1].milliFt)) ft) -> \(hhmm(s[i].minOfDay)) (\(ft(s[i].milliFt)) ft)")
    }
    if let last = s.last { print("  record ENDS at \(hhmm(last.minOfDay)) with \(ft(last.milliFt)) ft — the gauge stops reporting at its own maximum") }
}
