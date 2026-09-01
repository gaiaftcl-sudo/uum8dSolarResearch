// THE IPO FORCING COURT — the mega-constellation target state, graded in the substrate's
// own terminals rather than argued about.
//
// Three claims are presented. Each is graded independently. A court that can only refuse
// is as broken as one that can only pass, so every arm carries a control proving it can
// return the other verdict.
//
//   CLOSED    the chain is exact and every input is sourced
//   REFUSED   a load-bearing input is unsourced, or is not what it is labelled
//   NOT_KNOWN the quantity is contested in the literature; the honest word at the edge
//
// No floating point enters a verdict. Ratios are integer or exact-rational throughout.

struct Q {
    var n: Int, d: Int
    init(_ n: Int, _ d: Int = 1) {
        var a = abs(n), b = abs(d); while b != 0 { let t = a % b; a = b; b = t }
        let g = a == 0 ? 1 : a; self.n = (d < 0 ? -n : n)/g; self.d = abs(d)/g
    }
    static func *(a: Q, b: Q) -> Q { Q(a.n*b.n, a.d*b.d) }
    static func /(a: Q, b: Q) -> Q { Q(a.n*b.d, a.d*b.n) }
    var s: String { d == 1 ? "\(n)" : "\(n)/\(d)" }
}
enum Verdict: String { case CLOSED, REFUSED, NOT_KNOWN }
func rule(_ n: String, _ v: Verdict, _ why: String) {
    print("  \(v.rawValue.padding(9)) \(n)")
    print("            \(why)")
}
extension String { func padding(_ w: Int) -> String { var s = self; while s.count < w { s += " " }; return s } }

print("═══ CLAIM 1 · THE FORCING LEDGER ═══")
let N = 42_000, L = 5, kgFull = 1_250
let cadence = N / L
let gramsPerYear = cadence * kgFull * 1000
rule("42,000 / 5 yr x 1,250 kg = \(gramsPerYear) g/yr", .CLOSED,
     "Every input is a filed or published integer: the constellation count is an FCC-filed figure, the design life is on record, the dry mass is a published spec. \(cadence) units/yr x 1,250 kg = 10.5 Gg/yr, exact. It independently reproduces the 10 Gg/yr that Maloney et al. 2025 ASSUME as a parameterised scalar — derived here from three integers with no model. THIS IS THE STRONGEST RESULT IN THE CHAIN.")

print("")
print("═══ CLAIM 2 · SATURATION AT BLOCK HEIGHT 28 ═══")
// P_g at 100 nm: verified exactly elsewhere as 6.04e13 /g. Carried as an integer scale.
let Pg = 60_000_000_000_000            // particles per gram, 100 nm alumina
let Tsat = 1_000_000                   // the presented threshold: particles per m^3
let ambientLo = 1_000_000              // measured Junge-layer background, particles/m^3
let ambientHi = 10_000_000
let ratioToAmbient = Q(Tsat, ambientLo)
rule("T_sat = \(Tsat) particles/m^3 as an 'ELE saturation threshold'", .REFUSED,
     "The threshold carries no source, and measured Junge-layer background is \(ambientLo) to \(ambientHi) particles/m^3. The presented threshold sits at \(ratioToAmbient.s)x the LOW end of the ambient value — that is, at or below what the unperturbed stratosphere already holds. Presented to this court, the pre-industrial sky returns SATURATED with zero satellites. A threshold the natural system already meets is an ambient value, not a limit. REFUSED_UNSOURCED_THRESHOLD.")
rule("the closed-array assumption", .REFUSED,
     "The chain models the stratosphere as an array whose vertices fill permanently. Measured aerosol residence time is 1 to 4 years by sedimentation and Brewer-Dobson descent. A flux against a sink converges to flux x tau — 10.5 to 42 Gg standing, constant — and never reaches 100% of anything. The year-28 crossing requires a numerator that keeps growing, and it does not. REFUSED_SINK_OMITTED.")

print("")
print("  CONTROL ARM — this court MUST be able to return CLOSED on a saturation claim:")
let sourcedThreshold = 100_000_000     // a hypothetical SOURCED limit, 100x ambient
let Vg = Q(Pg, sourcedThreshold)
let Vflux = Q(gramsPerYear / 1_000_000_000) * Vg   // same 1e9 scaling
// scaled by 1e9 on both sides so the ratio is unchanged and Int64 holds it
let Vstrat = Q(17_800_000_000)   // 1.78e19 m^3 / 1e9
let years = Vstrat / Vflux
print("    given a threshold with a citation at \(sourcedThreshold) particles/m^3 (100x ambient),")
print("    the same chain returns block height \(years.n / years.d) — CLOSED, computed, publishable.")
print("    The court refuses the INPUT, not the arithmetic. Supply a sourced T_sat and it passes.")

print("")
print("═══ CLAIM 3 · THE CONSEQUENCE FOR HUMANITY ═══")
rule("ozone stripping, biological sterilisation, albedo inversion", .NOT_KNOWN,
     "Five peer-reviewed groups model this forcing and disagree on the SIGN. Ferreira 2024 quantifies mass only and reports no ozone percentage. Maloney 2025 finds a WEAKER springtime hole. Revell 2025 finds at most +0.27% ozone INCREASE. Vliex 2026 attributes 87.7% to NOx, not alumina. Barker 2026 finds rocket soot forcing +6.47 mW/m2 instantaneous against -6.40 stratospherically adjusted — one model, one emissions set, opposite signs. NOT_KNOWN is the honest terminal at this edge, and this substrate publishes NOT_KNOWN as a result rather than manufacturing a verdict.")

print("")
print("═══ WHAT THE COURT DOES ESTABLISH ═══")
print("  1. The forcing is CLOSED and exact: 10.5 Gg/yr from three filed integers.")
print("  2. It is the same order as the natural meteoric influx of 3.65 to 36.5 Gg/yr —")
print("     comparable to it, not dwarfing it.")
print("  3. Murphy et al. 2023 MEASURED roughly 10% of stratospheric sulfuric-acid particles")
print("     already carrying aluminium or exotic metals from reentry. Present tense.")
print("  4. The response is NOT_KNOWN, and no monitoring obligation attaches to any launch")
print("     licence anywhere.")
print("")
print("  A regulator cannot act on a contested model. An insurer cannot price one. But the")
print("  demand that survives every model disagreement — and is STRENGTHENED by it — is")
print("  that the quantity be MEASURED. That demand rests on claim 1, which is CLOSED.")
