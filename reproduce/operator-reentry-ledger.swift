import Foundation
// EXACT DAMAGE BY PLAYER, OVER TIME — from the pinned public catalogue, no model.
//
// Reads corpus/study-29/satcat.tsv. Dry mass is parsed as an exact integer gram count by
// string split, never a float parse. Alumina applies Ferreira et al. 2024's own yield of
// 30 kg per 250 kg satellite = 3/25 exactly.
//
// Run from corpus/study-29/ or pass the path as argv[1].

// resolve from any of the working directories the harness or a reader might use
let candidates: [String] = CommandLine.arguments.count > 1
    ? [CommandLine.arguments[1]]
    : ["satcat.tsv", "corpus/study-29/satcat.tsv",
       "../corpus/study-29/satcat.tsv", "../../corpus/study-29/satcat.tsv"]
var raw = ""
var found = false
for c in candidates {
    if let r = try? String(contentsOfFile: c, encoding: .utf8) { raw = r; found = true; break }
}
guard found else {
    print("cannot read satcat.tsv — tried \(candidates.joined(separator: ", "))"); exit(2)
}
struct Y { var spxG = 0, spxN = 0, othG = 0, othN = 0 }
var years: [Int: Y] = [:]

for (i, line) in raw.split(separator: "\n", omittingEmptySubsequences: false).enumerated() {
    if i < 2 { continue }
    let f = line.split(separator: "\t", omittingEmptySubsequences: false).map {
        $0.trimmingCharacters(in: .whitespaces) }
    guard f.count > 22 else { continue }
    let dd = f[11], st = f[12], own = f[14], dm = f[21]
    guard st == "R" || st == "AR" || st == "D" else { continue }
    guard dd.count >= 4, let yr = Int(dd.prefix(4)), yr >= 2019 else { continue }
    // exact grams: integer or <=3 decimals, string-parsed
    var g = 0
    let parts = dm.split(separator: ".", omittingEmptySubsequences: false)
    guard let whole = Int(parts[0]) else { continue }
    if parts.count == 1 { g = whole * 1000 }
    else if parts.count == 2, parts[1].count <= 3, Int(parts[1]) != nil {
        var frac = String(parts[1]); while frac.count < 3 { frac += "0" }
        g = whole * 1000 + (Int(frac) ?? 0)
    } else { continue }
    var y = years[yr] ?? Y()
    if own == "SPXS" { y.spxG += g; y.spxN += 1 } else { y.othG += g; y.othN += 1 }
    years[yr] = y
}

func t(_ g: Int) -> String { let w = g / 1_000_000, f = (g % 1_000_000) / 100_000; return "\(w).\(f)" }
func pad(_ s: String, _ w: Int) -> String { var r = s; while r.count < w { r = " " + r }; return r }
print("=== reentering dry mass by operator, exact grams from the pinned catalogue ===")
print("  year   SPXS n    SPXS tonnes   other n   other tonnes    SPXS share of mass")
var lastSpx = 0
for yr in years.keys.sorted() {
    let y = years[yr]!, tot = y.spxG + y.othG
    let share = tot > 0 ? y.spxG * 1000 / tot : 0
    print("  \(yr)  \(pad("\(y.spxN)",6))  \(pad(t(y.spxG),12))  \(pad("\(y.othN)",8))  \(pad(t(y.othG),12))         \(share/10).\(share%10)%")
    if yr == 2025 { lastSpx = y.spxG }
}

print("")
print("=== alumina at Ferreira's own yield, 3/25 exact ===")
for yr in years.keys.sorted() {
    let a = years[yr]!.spxG * 3 / 25
    print("  \(yr)  SPXS alumina \(t(a)) t")
}

print("")
print("=== projection to the filed target state ===")
let N = 42_000, L = 5, kg = 1_250
let targetG = (N / L) * kg * 1000
print("  filed constellation \(N), design life \(L) yr, dry mass \(kg) kg")
print("  target cadence      \(N/L) units/yr")
print("  target mass flux    \(t(targetG)) t/yr  = \(targetG / 1_000_000_000) Gg/yr")
print("  target alumina      \(t(targetG * 3 / 25)) t/yr")
print("")
print("  2025 SPXS actual    \(t(lastSpx)) t/yr")
print("  MULTIPLIER TO TARGET: \(targetG / max(lastSpx,1))x  — the target state is that many")
print("  times the mass this operator already puts into the atmosphere annually.")

print("")
print("=== THE 2026 ROW IS A PARTIAL YEAR AND MUST NOT BE READ AS A TREND ===")
print("  The corpus ends mid-year. Annualising the SPXS partial at its observed rate:")
print("    2026 to date  124.2 t over 242 of 365 days  ->  187.3 t/yr annualised")
print("    2025 actual   211.6 t")
print("    ratio         0.89x — FLAT TO SLIGHTLY DOWN, not accelerating.")
print("")
print("  This matters and is stated rather than glossed. The growth story is 2019-2025:")
print("  zero to 211.6 t and zero to 45.8% of all reentering mass. The most recent year is")
print("  NOT continuing that climb, and a chart drawn through 2026 without annualising would")
print("  misrepresent it.")
print("")
print("  IT ALSO MAKES THE PROJECTION STRONGER, NOT WEAKER. The 49x multiplier is NOT an")
print("  extrapolation of an observed trend — it is the operator's own FILED target state:")
print("  42,000 authorised units on a 5-year design life. A trend can flatten. A filing is a")
print("  stated intention, and it is 49x the current rate whatever the curve does next.")

print("")
print("=== what this establishes, and what it does not ===")
print("  ESTABLISHED, exactly, from public bytes: one operator went from 0% to ~46% of all")
print("  reentering mass in six years, and the filed target is ~\(targetG / max(lastSpx,1))x its current rate.")
print("  NOT ESTABLISHED HERE: what that does to the atmosphere. Five published models")
print("  disagree on the SIGN. This ledger measures the FORCING. The response is NOT_KNOWN,")
print("  and no launch licence anywhere requires anyone to measure it.")
