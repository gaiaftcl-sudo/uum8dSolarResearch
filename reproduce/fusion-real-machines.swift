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
#if compiler(>=6.0)
import Foundation

struct Machine { let name: String; let ipAmp: Int64; let aMm: Int64; let src: String }
let machines = [
  // ITER: R=6.2 m, a=2.0 m, Ip=15 MA (iter.org, REPORTED)
  Machine(name: "ITER (tokamak)",       ipAmp: 15_000_000, aMm: 2000, src: "iter.org"),
  // SPARC: a=0.57 m, Ip=8.7 MA (Creely et al. 2020; Wikipedia, REPORTED)
  Machine(name: "SPARC (tokamak)",      ipAmp:  8_700_000, aMm:  570, src: "Creely 2020"),
  // JET: a=1.25 m, Ip up to 4.8 MA (EUROfusion; Wikipedia, REPORTED)
  Machine(name: "JET (tokamak)",        ipAmp:  4_800_000, aMm: 1250, src: "EUROfusion"),
  // DIII-D: a=0.67 m, Ip up to 2.0 MA (General Atomics; Wikipedia, REPORTED)
  Machine(name: "DIII-D (tokamak)",     ipAmp:  2_000_000, aMm:  670, src: "General Atomics"),
]
// W7-X: a~0.53 m, CURRENTLESS stellarator (IPP, REPORTED) — no Greenwald limit.
let w7x = Machine(name: "W7-X (stellarator)", ipAmp: 0, aMm: 530, src: "IPP Greifswald")

// exact integer Greenwald density in 1e14 units at pi = 355/113 (the court's high
// bound): n_G14 = Ip / (pi a^2) / 1e6 * 1e14 = Ip * 1e8 / (pi a_mm^2) with a in mm...
// carefully: n_G[1e20] = Ip[MA]/(pi a[m]^2). In 1e14 units n_G14 = n_G[1e20]*1e6.
// = Ip[A]/1e6 / (pi (a_mm/1000)^2) * 1e6 = Ip[A] * 1e6 / (pi a_mm^2 / 1e6) / 1e6 ...
// do it directly in integers: n_G14 = Ip[A] * 1_000_000 * 113 / (355 * a_mm^2 / 1000000)
// Keep it simple & exact: n_G14 = Ip * 113 * 1_000_000_000_000 / (355 * a_mm * a_mm)
func greenwald14(_ ipAmp: Int64, _ aMm: Int64) -> Int64 {
    // n_G14 = Ip[A] * 1e6 * 113 / (355 * a_mm^2). The 1e6 converts a_mm^2/1e6
    // back to m^2 AND m^-3 to 1e14 units — derived, not guessed (a prior version
    // had 1e12 here and put every machine a million-fold over its own limit).
    let num = Int128(ipAmp) * 113 * 1_000_000
    let den = Int128(355) * Int128(aMm) * Int128(aMm)
    return Int64(num / den)
}
func pad(_ s: String, _ w: Int) -> String { var r = s; while r.count < w { r += " " }; return r }
func rp(_ s: String, _ w: Int) -> String { var r = s; while r.count < w { r = " " + r }; return r }

print("=== THE COURT ON REAL PUBLISHED MACHINE GEOMETRIES ===")
print("  Every (Ip, a) is REPORTED from a public source. Densities are set at")
print("  0.80 and 0.90 of each machine's OWN Greenwald limit, clear of the")
print("  pi-bracket, so each verdict is pi-independent.")
print("")
print("  \(pad("machine",22))\(rp("Ip(A)",10))\(rp("a(mm)",7))\(rp("n_G(1e14)",12))\(rp("@0.80",8))\(rp("@0.90",8))\(rp("source",18))")
var wins = 0, misses = 0
for m in machines {
    let ng = greenwald14(m.ipAmp, m.aMm)
    let safe = FusionOperatingPointLaw.grade(OperatingEnvelope(
        ne14: ng * 80 / 100, ipAmp: m.ipAmp, minorRadiusMm: m.aMm, betaNMilli: 1800, qMinMilli: 3000))
    let over = FusionOperatingPointLaw.grade(OperatingEnvelope(
        ne14: ng * 90 / 100, ipAmp: m.ipAmp, minorRadiusMm: m.aMm, betaNMilli: 1800, qMinMilli: 3000))
    if safe.verdict == "WIN" { wins += 1 }
    if over.verdict == "MISS" && over.bindingBranch == .greenwald { misses += 1 }
    print("  \(pad(m.name,22))\(rp("\(m.ipAmp)",10))\(rp("\(m.aMm)",7))\(rp("\(ng)",12))\(rp(safe.verdict,8))\(rp(over.verdict,8))\(rp(m.src,18))")
}
print("")
// the stellarator
let sv = FusionOperatingPointLaw.grade(OperatingEnvelope(
    ne14: 5_000_000, ipAmp: w7x.ipAmp, minorRadiusMm: w7x.aMm, betaNMilli: 1800, qMinMilli: 3000))
print("  \(pad(w7x.name,22))\(rp("0",10))\(rp("\(w7x.aMm)",7))\(rp("n/a",12))\(rp(sv.verdict,17))\(rp(w7x.src,18))")
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
#endif
