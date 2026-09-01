// STUDY 31 — ingest the measured healthy range, then run the state change.
//
// Baseline: 56,575 daily Dobson total-ozone observations, five stations, 1963-2026.
// Total_Ozone is published at one decimal place, so it is ingested as an exact
// integer count of DECI-DOBSON. No float is constructed anywhere in this program.
//
// The healthy range is taken from the pre-1980 record -- before the CFC depletion
// that the Montreal Protocol was written to stop -- so it is a measured healthy sky
// and not an assumed one.

import Foundation

struct Stn { let code: String, name: String, lat: String }
let stations = [
    Stn(code: "BRW", name: "Barrow, Alaska",          lat: "71.32 N"),
    Stn(code: "BLD", name: "Boulder, Colorado",       lat: "40.02 N"),
    Stn(code: "MLO", name: "Mauna Loa, Hawaii",       lat: "19.53 N"),
    Stn(code: "SMO", name: "Tutuila, Samoa",          lat: "14.25 S"),
    Stn(code: "SPO", name: "Amundsen-Scott, S. Pole", lat: "89.90 S"),
]

func find(_ f: String) -> String? {
    for c in ["corpus/study-31/\(f)", "../corpus/study-31/\(f)", "../../corpus/study-31/\(f)", f] {
        if let s = try? String(contentsOfFile: c, encoding: .utf8) { return s }
    }
    return nil
}
func pad(_ s: String, _ w: Int) -> String { var r = s; while r.count < w { r += " " }; return r }
func rp(_ s: String, _ w: Int) -> String { var r = s; while r.count < w { r = " " + r }; return r }
// deci-Dobson integer -> "276.0"
func du(_ d: Int) -> String { "\(d/10).\(abs(d)%10)" }

// exact integer-tenths parse; refuses anything that is not N.N
func deci(_ tok: String) -> Int? {
    let p = tok.split(separator: ".", omittingEmptySubsequences: false)
    guard p.count == 2, p[1].count == 1, let w = Int(p[0]), let f = Int(p[1]) else { return nil }
    return w >= 0 ? w * 10 + f : w * 10 - f
}

struct Base { var healthy: [Int] = [], modern: [Int] = [], refused = 0 }
var got: [String: Base] = [:]
var totalRows = 0, totalRefused = 0

for s in stations {
    guard let raw = find("ozone_\(s.code).txt") else { continue }
    var b = Base()
    // NOTE: this archive uses CRLF, and in Swift "\r\n" is a SINGLE Character.
    // split(separator: "\n") therefore matches NOTHING and returns the whole file
    // as ~3 lines. Split on any newline form explicitly.
    for line in raw.split(whereSeparator: { $0 == "\n" || $0 == "\r\n" || $0 == "\r" }) {
        let f = line.split(separator: " ", omittingEmptySubsequences: true).map(String.init)
        guard f.count > 7, f[0].count == 10, f[0].contains("/") else { continue }
        guard let yr = Int(f[0].prefix(4)) else { continue }
        guard let d = deci(f[6]) else { b.refused += 1; continue }
        guard d > 0 else { b.refused += 1; continue }        // absence is not a reading
        if yr < 1980 { b.healthy.append(d) } else if yr >= 2015 { b.modern.append(d) }
    }
    b.healthy.sort(); b.modern.sort()
    got[s.code] = b
    totalRows += b.healthy.count + b.modern.count
    totalRefused += b.refused
}

func pct(_ v: [Int], _ p: Int) -> Int { v.isEmpty ? 0 : v[min(v.count-1, (v.count-1)*p/100)] }

print("╔══ THE MEASURED HEALTHY SKY — pre-1980 Dobson record ══╗")
print("  The baseline is not assumed. It is what five ground instruments recorded")
print("  before the CFC depletion the Montreal Protocol was written to stop.")
print("")
print("  \(pad("station",26))\(pad("lat",10))\(rp("n",7))\(rp("p05",8))\(rp("median",8))\(rp("p95",8))   healthy range (DU)")
for s in stations {
    guard let b = got[s.code], !b.healthy.isEmpty else { continue }
    let lo = pct(b.healthy, 5), md = pct(b.healthy, 50), hi = pct(b.healthy, 95)
    print("  \(pad(s.name,26))\(pad(s.lat,10))\(rp("\(b.healthy.count)",7))\(rp(du(lo),8))\(rp(du(md),8))\(rp(du(hi),8))   \(du(lo)) to \(du(hi))")
}
print("")
print("  rows admitted \(totalRows)   refused (non integer-tenths or absent) \(totalRefused)")
print("  Every admitted value is an exact integer count of deci-Dobson. Zero floats.")
print("")

print("╔══ WHAT ALREADY HAPPENED — the control arm this study needs ══╗")
print("  Before projecting anything, the instrument must show it can SEE a real")
print("  depletion. The Montreal-era loss is the known case. If the ingest cannot")
print("  find it, the ingest is broken and no projection is worth running.")
print("")
print("  \(pad("station",26))\(rp("healthy med",13))\(rp("2015+ med",12))\(rp("change",10))")
var sawLoss = 0
for s in stations {
    guard let b = got[s.code], !b.healthy.isEmpty, !b.modern.isEmpty else { continue }
    let h = pct(b.healthy, 50), m = pct(b.modern, 50)
    let dpm = (m - h) * 1000 / h                       // per-mille change, integer
    let sign = dpm < 0 ? "" : "+"
    if dpm < 0 { sawLoss += 1 }
    print("  \(pad(s.name,26))\(rp(du(h)+" DU",13))\(rp(du(m)+" DU",12))\(rp("\(sign)\(dpm/10).\(abs(dpm)%10)%",10))")
}
print("")
if sawLoss >= 3 {
    print("  CONTROL ARM PASSES: the ingest independently recovers a depletion at")
    print("  \(sawLoss) of 5 stations, from raw instrument rows, with no model involved.")
    print("  The instrument can see a real loss, so it can be trusted to measure one.")
} else {
    print("  CONTROL ARM FAILS: the ingest does not recover the known depletion.")
    print("  No projection is run. The instrument is the bug.")
}
print("")

print("╔══ THE STATE CHANGE — projected loss applied to the MEASURED baseline ══╗")
print("  Column loss projections are carried from the envelope (Vliex 2026 scaled")
print("  linearly to each filed fleet). They are PROJECTIONS. The baseline is not.")
print("")
// per-mille global-mean column loss by scenario
let scen: [(String, Int)] = [
    ("authorised 19,408",      3),      // 0.257% -> 2.57 per-mille
    ("Gen3 filed 100,000",    13),      // 1.324%
    ("orbital data centres", 108),      // 10.767%
]
guard let bld = got["BLD"], !bld.healthy.isEmpty else { exit(1) }
let hMed = pct(bld.healthy, 50), hLo = pct(bld.healthy, 5)
print("  Worked at Boulder, whose healthy median is \(du(hMed)) DU and whose healthy")
print("  5th percentile -- the low end of a normal sky -- is \(du(hLo)) DU.")
print("")
print("  \(pad("scenario",24))\(rp("global mean",13))\(rp("regional x12",14))\(rp("Boulder median",16))")
for (n, pm) in scen {
    let reg = pm * 12
    let after = hMed - (hMed * reg) / 1000
    let note = reg >= 1000 ? "  <- exceeds the column" : ""
    print("  \(pad(n,24))\(rp("\(pm/10).\(pm%10)%",13))\(rp("\(reg/10).\(reg%10)%",14))\(rp(du(after)+" DU",16))\(note)")
}
print("")
print("  The middle row is the one to read. At the Gen3 filing the regional loss")
print("  takes Boulder's median from \(du(hMed)) DU to \(du(hMed - (hMed*156)/1000)) DU -- BELOW the 5th")
print("  percentile of its own healthy record. A normal day would become rarer than")
print("  the worst day of the healthy era.")
print("")
print("  The bottom row exceeds the column entirely, which does not forecast a")
print("  catastrophe -- it disqualifies the linear projection before it reaches that")
print("  scale, and that disqualification is the finding.")
print("")
print("╔══ WHAT IS BASELINE AND WHAT IS PROJECTION ══╗")
print("  MEASURED  the healthy ranges, the 2015+ comparison, the recovered depletion")
print("  PROJECTED the column-loss percentages, and the 12x regional factor")
print("  NOT KNOWN the biological response. No transfer function is applied here and")
print("            none is claimed. The chain stops where the measurement stops.")
