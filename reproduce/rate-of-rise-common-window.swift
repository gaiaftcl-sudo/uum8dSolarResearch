import Foundation
struct P { let m: Int; let v: Int }
func load(_ p: String) -> [P] {
    guard let s = try? String(contentsOfFile: p, encoding: .utf8) else { return [] }
    var o: [P] = []
    for l in s.split(separator: "\n") {
        let f = l.split(separator: "\t", omittingEmptySubsequences: false)
        guard f.count >= 2, f[1] != "-999999", let t = String(f[0]).firstIndex(of: "T") else { continue }
        let d = String(f[0]); let day = String(d[d.startIndex..<t])
        let hm = d[d.index(after: t)...].prefix(5).split(separator: ":")
        guard hm.count == 2, let h = Int(hm[0]), let mi = Int(hm[1]) else { continue }
        let off = day.hasSuffix("-07-03") ? 0 : (day.hasSuffix("-07-04") ? 1440 : 2880)
        let vv = String(f[1]).split(separator: ".")
        var fr = vv.count > 1 ? String(vv[1]) : "0"; while fr.count < 3 { fr += "0" }
        o.append(P(m: off + h*60 + mi, v: (Int(vv[0]) ?? 0)*1000 + (Int(fr.prefix(3)) ?? 0)))
    }
    return o.sorted { $0.m < $1.m }
}
// max rise over the SMALLEST window each gauge can support, and over a COMMON 15 min
func maxRate(_ s: [P], window: Int) -> (Int, Int, Int) {
    var best = (0, 0, 0)
    for i in 0..<s.count {
        for j in (i+1)..<s.count {
            let dt = s[j].m - s[i].m
            if dt < window { continue }
            if dt > window { break }
            let r = (s[j].v - s[i].v) / dt
            if r > best.0 { best = (r, s[i].m, s[j].m) }
        }
    }
    return best
}
func hhmm(_ t: Int) -> String { let r = t % 1440; return String(format: "07-%02d %02d:%02d", 3 + t/1440, r/60, r%60) }

let hunt = load("s_08165500.tsv"), kerr = load("s_08166200.tsv")
print("sampling: Hunt every 5 min (343 of 344 gaps), Kerrville every 15 min (235 of 236)")
print("")
print("=== native window (what the earlier figure used) ===")
let h5 = maxRate(hunt, window: 5), k15 = maxRate(kerr, window: 15)
print("  Hunt      over  5 min: \(h5.0) milli-ft/min  (\(hhmm(h5.1)) -> \(hhmm(h5.2)))")
print("  Kerrville over 15 min: \(k15.0) milli-ft/min  (\(hhmm(k15.1)) -> \(hhmm(k15.2)))")
print("  NOT COMPARABLE: a shorter window can only raise a maximum.")
print("")
print("=== COMMON 15-minute window, both gauges ===")
let h15 = maxRate(hunt, window: 15)
print("  Hunt      over 15 min: \(h15.0) milli-ft/min  (\(hhmm(h15.1)) -> \(hhmm(h15.2)))")
print("  Kerrville over 15 min: \(k15.0) milli-ft/min  (\(hhmm(k15.1)) -> \(hhmm(k15.2)))")
print("  ratio Kerrville:Hunt = \(k15.0 * 100 / max(h15.0,1))/100")
print("")
print("=== COMMON 30-minute window ===")
let h30 = maxRate(hunt, window: 30), k30 = maxRate(kerr, window: 30)
print("  Hunt      over 30 min: \(h30.0) milli-ft/min")
print("  Kerrville over 30 min: \(k30.0) milli-ft/min")
print("  ratio = \(k30.0 * 100 / max(h30.0,1))/100")
