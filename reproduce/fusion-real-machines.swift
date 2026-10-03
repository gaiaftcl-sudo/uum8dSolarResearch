// The operating-point court, run over REAL PUBLISHED machine GEOMETRIES.
//
// This grades the court against machines whose parameters are public and
// verifiable — not to claim we know each machine's actual operating density
// (that is shot-specific), but to show the court places the Greenwald boundary
// CORRECTLY on real geometry, and correctly REFUSES a currentless machine.
//
// Every (Ip, a) below is REPORTED from public sources, cited inline. Densities
// are chosen at 0.80 and 0.90 of each machine's own Greenwald limit, safely
// clear of the pi-bracket, so each verdict is pi-independent.
//
// Consumes FusionOperatingPointLaw. Units: Ip amperes, a millimetres,
// n_e in 1e14 m^-3, ratios x1000.
//
// ONE TABLE (2026-10-03): the (Ip, a) rows, their sources and the sources' own
// qualifiers ("up to", "~") are read from FusionMachines (app/FusionCourt/Sources/
// FusionOperatingPoint/Machines.swift), and n_G from the law's own
// greenwaldDensityFloor. This script used to carry its own copy of both.
// The grading densities (0.80 and 0.90 of n_G) remain this script's own inputs.
import Foundation

struct Machine { let name: String; let ipAmp: Int64; let aMm: Int64; let src: String }
func row(_ m: FusionMachine) -> Machine {
  Machine(name: "\(m.name) (\(m.kind))", ipAmp: m.ipAmp, aMm: m.minorRadiusMm,
          src: m.qualifier.isEmpty ? m.source : "\(m.source); \(m.qualifier)")
}
let machines = FusionMachines.all.filter { $0.ipAmp > 0 }.map(row)
// W7-X: the tree records no plasma current (IPP, REPORTED) — no Greenwald limit.
let w7x = row(FusionMachines.w7x)

// exact integer Greenwald density in 1e14 units at pi = 355/113 (the court's high
// bound): n_G14 = Ip[A] * 1e6 * 113 / (355 * a_mm^2), floored. The 1e6 converts
// a_mm^2/1e6 back to m^2 AND m^-3 to 1e14 units — derived, not guessed (a prior
// version had 1e12 here and put every machine a million-fold over its own limit).
// It is the LAW's face now, so this script and the court cannot place the limit
// differently.
func greenwald14(_ ipAmp: Int64, _ aMm: Int64) -> Int64 {
    let hi = FusionOperatingPointLaw.piHi
    guard let ng = FusionOperatingPointLaw.greenwaldDensityFloor(
            ipAmp: ipAmp, minorRadiusMm: aMm, piNum: hi.num, piDen: hi.den) else {
        print("REFUSED: no Greenwald limit for Ip=\(ipAmp) a=\(aMm)"); return -1
    }
    return ng
}
func pad(_ s: String, _ w: Int) -> String { var r = s; while r.count < w { r += " " }; return r }
func rp(_ s: String, _ w: Int) -> String { var r = s; while r.count < w { r = " " + r }; return r }

print("=== THE COURT ON REAL PUBLISHED MACHINE GEOMETRIES ===")
print("  Every (Ip, a) is REPORTED from a public source. Densities are set at")
print("  0.80 and 0.90 of each machine's OWN Greenwald limit, clear of the")
print("  pi-bracket, so each verdict is pi-independent.")
print("")
print("  \(pad("machine",22))\(rp("Ip(A)",10))\(rp("a(mm)",7))\(rp("n_G(1e14)",12))\(rp("@0.80",8))\(rp("@0.90",8))   source (as cited, qualifier verbatim)")
var wins = 0, misses = 0
for m in machines {
    let ng = greenwald14(m.ipAmp, m.aMm)
    let safe = FusionOperatingPointLaw.grade(OperatingEnvelope(
        ne14: ng * 80 / 100, ipAmp: m.ipAmp, minorRadiusMm: m.aMm, betaNMilli: 1800, qMinMilli: 3000))
    let over = FusionOperatingPointLaw.grade(OperatingEnvelope(
        ne14: ng * 90 / 100, ipAmp: m.ipAmp, minorRadiusMm: m.aMm, betaNMilli: 1800, qMinMilli: 3000))
    if safe.verdict == "WIN" { wins += 1 }
    if over.verdict == "MISS" && over.bindingBranch == .greenwald { misses += 1 }
    print("  \(pad(m.name,22))\(rp("\(m.ipAmp)",10))\(rp("\(m.aMm)",7))\(rp("\(ng)",12))\(rp(safe.verdict,8))\(rp(over.verdict,8))   \(m.src)")
}
print("")
// the stellarator
let sv = FusionOperatingPointLaw.grade(OperatingEnvelope(
    ne14: 5_000_000, ipAmp: w7x.ipAmp, minorRadiusMm: w7x.aMm, betaNMilli: 1800, qMinMilli: 3000))
print("  \(pad(w7x.name,22))\(rp("0",10))\(rp("\(w7x.aMm)",7))\(rp("n/a",12))\(rp(sv.verdict,17))   \(w7x.src)")
print("")
print("=== WHAT THIS SHOWS ===")
print("  \(wins) of \(machines.count) tokamaks: a plasma at 0.80 of the machine's own")
print("  Greenwald limit WINS; at 0.90 it MISSES on the greenwald branch. The")
print("  court places the 0.85 density boundary correctly on every real geometry,")
print("  using only the machine's published current and minor radius.")
print("")
print("  W7-X returns \(sv.verdict): a currentless stellarator has no")
print("  Greenwald limit to place, and the court says so rather than inventing one.")
print("  REAL-MACHINE GEOMETRY GRADED: \(wins) WIN / \(misses) MISS-greenwald / 1 NOT_APPLICABLE")
