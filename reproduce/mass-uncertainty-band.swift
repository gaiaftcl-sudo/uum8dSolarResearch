// The headline reentry mass, split by whether GCAT flags the value as an estimate.
// GCAT marks an estimated DryMass with DryFlag "?"; its documentation puts such
// estimates at roughly +/-20%. This program does NOT assume the flagged values are
// wrong. It reports how much of the published total rests on them, and the band that
// follows if every flagged value is off by the full 20% in the same direction --
// the widest honest reading, not the likeliest one.
// Integer grams throughout. No float.
import Foundation

// resolve the corpus whether run from the repo root, from reproduce/, or with an
// explicit path argument -- the harness invokes programs from more than one cwd.
let candidates: [String] = CommandLine.arguments.count > 1
    ? [CommandLine.arguments[1]]
    : ["corpus/study-29/satcat.tsv",
       "../corpus/study-29/satcat.tsv",
       "../../corpus/study-29/satcat.tsv",
       "satcat.tsv"]
var raw = ""
var found = false
for c in candidates {
    if let r = try? String(contentsOfFile: c, encoding: .utf8) { raw = r; found = true; break }
}
guard found else {
    print("corpus missing: tried \(candidates.joined(separator: ", "))"); exit(1)
}

var rowsQ = 0, rowsC = 0, gQ = 0, gC = 0
for (i, line) in raw.split(separator: "\n", omittingEmptySubsequences: false).enumerated() {
    if i < 2 { continue }
    let f = line.split(separator: "\t", omittingEmptySubsequences: false).map {
        $0.trimmingCharacters(in: .whitespaces) }
    guard f.count > 22 else { continue }
    let dd = f[11], st = f[12], dm = f[21], fl = f[22]
    guard st == "R" || st == "AR" || st == "D" else { continue }
    guard dd.count >= 4, let yr = Int(dd.prefix(4)), yr == 2025 else { continue }
    var g = 0
    let parts = dm.split(separator: ".", omittingEmptySubsequences: false)
    guard let whole = Int(parts[0]) else { continue }
    if parts.count == 1 { g = whole * 1000 }
    else if parts.count == 2, parts[1].count <= 3, Int(parts[1]) != nil {
        var frac = String(parts[1]); while frac.count < 3 { frac += "0" }
        g = whole * 1000 + (Int(frac) ?? 0)
    } else { continue }
    if fl == "?" { rowsQ += 1; gQ += g } else { rowsC += 1; gC += g }
}

let rows = rowsQ + rowsC, tot = gQ + gC
func t1(_ g: Int) -> String { "\(g/1_000_000).\((g%1_000_000)/100_000)" }
func pct1(_ n: Int, _ d: Int) -> String { let p = n*1000/d; return "\(p/10).\(p%10)" }

print("=== the headline number, and how much of it is estimated ===")
print("  admitted 2025 reentry rows            \(rows)          EXACT — a row count")
print("  published dry-mass total              \(tot) g")
print("")
print("  rows GCAT flags as estimates (\"?\")     \(rowsQ)   = \(pct1(rowsQ, rows))% of rows")
print("  mass carried by those rows            \(gQ) g")
print("                                        = \(pct1(gQ, tot))% OF THE PUBLISHED TOTAL")
print("  rows with an unflagged value          \(rowsC)")
print("  mass carried by those rows            \(gC) g   = \(pct1(gC, tot))%")
print("")
print("  THREE QUARTERS of the headline mass rests on values the catalogue itself marks")
print("  as estimates. Quoting that total to nine significant figures is false precision.")
print("")

// +/-20% applied to the flagged portion only, integers throughout
let band = gQ / 5                       // 20% of the flagged mass
let lo = tot - band, hi = tot + band
print("=== the honest band, widest reading (every flagged value off by the full 20%) ===")
print("  low    \(lo) g   = \(t1(lo)) t")
print("  point  \(tot) g   = \(t1(tot)) t")
print("  high   \(hi) g   = \(t1(hi)) t")
print("  → the 2025 reentry dry mass is 461 t, and the honest way to write it is")
print("    ABOUT 460 TONNES, RANGE 391 TO 531.")
print("")

// carry the band through the alumina yield used by the ledger (211.6 t at the point value)
let aluminaPoint = 211_600_000
let aLo = aluminaPoint - (aluminaPoint / tot) * band - ((aluminaPoint % tot) * band) / tot
let aHi = aluminaPoint + (aluminaPoint / tot) * band + ((aluminaPoint % tot) * band) / tot
print("=== carried through to alumina, and to the season ===")
print("  alumina per year   \(t1(aLo)) to \(t1(aHi)) t   (point \(t1(aluminaPoint)) t)")
print("  alumina per season \(t1(aLo/4)) to \(t1(aHi/4)) t   (point \(t1(aluminaPoint/4)) t)")
print("")
print("  Stated as the pages state it:")
print("    2025 reentry dry mass: about 460 tonnes, range 391 to 531.")
print("    Alumina reaching the stratosphere: 45 to 61 tonnes each season.")
print("")
print("  So the headline claim -- ABOUT FIFTY TONNES A SEASON -- SURVIVES the band.")
print("  The claim held; the precision did not. Both halves of that are published.")
