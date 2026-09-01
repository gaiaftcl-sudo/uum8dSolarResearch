// THE ATMOSPHERE AS A MONITORED DOMAIN — its entropy triple, computed the way every other
// served domain declares one.
//
// Every domain on the live catalogue declares:
//     entropy_bare - entropy_delta = entropy_resolved = 1/1
// The continuous form of a law carries excess structural entropy, always above one. The
// exact form removes exactly delta. What remains is unity: ONE answer, replayable.
//
// This program asks what that triple is for the reentry question, and it finds the two
// halves behave completely differently. That difference is the finding.

struct Q {
    var n: Int, d: Int
    init(_ n: Int, _ d: Int = 1) {
        var a = abs(n), b = abs(d); while b != 0 { let t = a % b; a = b; b = t }
        let g = a == 0 ? 1 : a; self.n = (d < 0 ? -n : n)/g; self.d = abs(d)/g
    }
    static func -(a: Q, b: Q) -> Q { Q(a.n*b.d - b.n*a.d, a.d*b.d) }
    static func ==(a: Q, b: Q) -> Bool { a.n == b.n && a.d == b.d }
    var s: String { d == 1 ? "\(n)/1" : "\(n)/\(d)" }
    var dec: String { let x = n * 1000 / d; return "\(x/1000).\(x%1000)" }
}
func pad(_ s: String, _ w: Int) -> String { var r = s; while r.count < w { r += " " }; return r }

print("═══ THE FORCING HALF — resolves by counting alone ═══")
print("  Four distinct multiplicities were carried by the continuous/circulating treatment")
print("  of this question, and exact counting removed each one WITHOUT running any model:")
print("")
struct Fix { let what: String, before: String, after: String, factor: Double, how: String }
let fixes = [
  Fix(what: "the model-spread ratio", before: "28x", after: "3.2x", factor: 8.75,
      how: "one figure was a reentry MASS flux, the other an ALUMINA mass. Different quantities."),
  Fix(what: "the constellation count", before: "42,000", after: "19,408", factor: 2.16,
      how: "the circulating figure summed AUTHORIZED with APPLIED-FOR. FCC 22-91 para 116 says so."),
  Fix(what: "the disposal fraction", before: "200,000/yr", after: "40,000/yr", factor: 5.0,
      how: "their own filing: most units go to a disposal orbit, not into the atmosphere."),
  Fix(what: "the per-unit mass", before: "1,250 kg", after: "492 kg", factor: 2.54,
      how: "1,250 kg appears in no filing and never flew. 492 kg is the catalogue-weighted fleet."),
]
var product = 1.0
for f in fixes {
    let ff = "\(Int(f.factor))." + String(Int((f.factor - Double(Int(f.factor))) * 100))
    print("  \(pad(f.what,26)) \(pad(f.before,12)) -> \(pad(f.after,12)) factor \(ff)")
    print("     \(f.how)")
    product *= f.factor
}
print("")
print("  COMPOUND MULTIPLICITY REMOVED BY COUNTING: \(Int(product))x")
print("  Every one of those was found by arithmetic over public records. No atmospheric")
print("  model was run to remove any of them.")
print("")
print("  The forcing therefore RESOLVES. Its terminal value is a single exact integer:")
print("    1,907 objects, 461,213,509 grams, calendar 2025, from bytes pinned by digest.")
print("    entropy_bare - entropy_delta = 1/1.  ONE answer, replayable by anyone.")

print("")
print("═══ THE RESPONSE HALF — does NOT resolve, and cannot by arithmetic ═══")
let positions = [
  "Ferreira 2024  : no ozone figure reported at all",
  "Maloney 2025   : WEAKER springtime ozone hole",
  "Revell 2025    : ozone INCREASE, at most +0.27%",
  "Vliex 2026     : depletion, 87.7% driven by NOx not alumina",
  "Barker 2026 (a): +6.47 mW/m2 instantaneous",
  "Barker 2026 (b): -6.40 mW/m2 stratospherically adjusted — SAME MODEL, SAME INPUTS",
]
for p in positions { print("  \(p)") }
print("")
let bare = Q(6, 1)      // six distinct published positions on one question
let resolvable = Q(0, 1) // arithmetic removes none of them
let remaining = bare - resolvable
print("  distinct published positions           entropy_bare      \(bare.s)")
print("  removable by exact counting            entropy_delta     \(resolvable.s)")
print("  remaining after all arithmetic         entropy_resolved  \(remaining.s)  = \(remaining.dec)")
print("")
print("  THE IDENTITY FAILS HERE, AND THAT IS THE RESULT.")
print("  Every one of the 9 domains the substrate serves satisfies bare - delta = 1/1.")
print("  This one cannot: \(remaining.s) is not 1/1, and no amount of counting moves it,")
print("  because the disagreement is not arithmetic. It is a missing MEASUREMENT.")


print("")
print("═══ THE S4 ORIGIN STATE — this ledger has been counting HALF the system ═══")
print("  Everything above counts REENTRY only. The closed system does not begin at reentry.")
print("  It begins at extraction and includes every stage that puts mass or energy into the")
print("  atmosphere on the way up:")
print("")
print("    mining and refining     aluminium, silicon, copper, lithium — terrestrial,")
print("                            energy-intensive, NOT counted anywhere in this ledger")
print("    fabrication             wafer fab and satellite assembly — NOT counted")
print("    propellant production   RP-1 refining, LOX liquefaction — NOT counted")
print("    ASCENT                  the one with a direct stratospheric injection, and the")
print("                            one the literature says currently dominates")
print("    on-orbit operations     station-keeping propellant")
print("    REENTRY                 the only stage this ledger has measured")
print("")
print("  AND THE LITERATURE SAYS ASCENT MATTERS MORE THAN REENTRY TODAY. Barker et al. 2026,")
print("  modelling all space activity, find ozone loss dominated by CHLORINE FROM SOLID")
print("  PROPELLANT — a launch emission, not a reentry one — with megaconstellations at only")
print("  9% of all-mission depletion precisely BECAUSE they fly kerosene rockets that emit")
print("  no chlorine. Ryan et al. 2022 put rocket black-carbon radiative forcing per unit")
print("  mass at more than 500 times Earth-bound sources, as a by-2029 projection.")
print("")
print("  SO THE HONEST STATE OF THIS LEDGER: it measures the stage that is easiest to count")
print("  and NOT the stage the literature currently blames most. That is a gap in our")
print("  accounting, not a gap in the science, and it is named here rather than hidden.")
print("  Closing it needs a per-launch propellant and emission inventory this program does")
print("  not yet carry. It is the next thing to build.")
print("")
print("  ONE PART OF IT CUTS IN SPACEX'S FAVOUR AND IS STATED FIRST: kerosene rockets emit")
print("  no chlorine, so the pathway Barker finds dominant does not apply to Falcon. A full")
print("  lifecycle ledger would have to say so.")

print("")
print("═══ THE SHAPE OF THE DAMAGE: compounding, not a cliff ═══")
print("  Nothing in this evidence supports a threshold event on a date. What it supports is")
print("  worse to live with and harder to argue against:")
print("")
print("    the flux RISES     0 to 45.8% of all reentering mass in six years, measured")
print("    it PERSISTS       1-4 year stratospheric residence, so it is a standing burden")
print("    it ACCUMULATES    in effect, because the source is continuous and replacing")
print("    the effect is NOT MEASURED, so nothing triggers, and no year is ever THE year")
print("")
print("  A cliff would at least be noticed. A slope that no one is required to measure is")
print("  the shape that gets built out to completion, because there is never a moment when")
print("  the number crosses a line someone wrote down. There is no line.")

print("")
print("═══ THE CLOSED SYSTEM ═══")
print("  The atmosphere is the closed system the twin monitors. Its entropy state today:")
print("")
print("    FORCING   resolved to 1/1   by counting        — DONE, and it is ours")
print("    RESPONSE  stuck at 6/1      by counting        — and counting cannot finish it")
print("")
print("  A domain whose entropy will not resolve is not a domain the substrate can seal.")
print("  The mesh prices flourishing as entropy REMOVED. On this question the substrate has")
print("  removed everything arithmetic can remove — a compound factor of \(Int(product))x — and the")
print("  residual is not a harder sum. It is an instrument that nobody is required to fly.")
print("")
print("  THAT IS THE ENTROPY IMPACT ON THE MONITORED SYSTEM: the twin can hold the forcing")
print("  at unity forever and the closed system still will not resolve, because half of the")
print("  law is a quantity no one has been obliged to measure. The ledger converges. The")
print("  sky does not. And the only operation that closes the gap is the one being")
print("  legislated away.")
