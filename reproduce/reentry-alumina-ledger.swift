// The reentry alumina ledger as EXACT RATIONAL arithmetic. No float anywhere.
// Every published scenario is checked against its own stated assumptions.
struct Q {                      // exact rational, Int64
    var n: Int64, d: Int64
    init(_ n: Int64, _ d: Int64 = 1) {
        precondition(d != 0)
        var a = n < 0 ? -n : n, b = d < 0 ? -d : d
        while b != 0 { let t = a % b; a = b; b = t }
        let g = a == 0 ? 1 : a
        let s: Int64 = d < 0 ? -1 : 1
        self.n = s * n / g; self.d = s * d / g
    }
    static func *(a: Q, b: Q) -> Q { Q(a.n &* b.n, a.d &* b.d) }
    static func /(a: Q, b: Q) -> Q { Q(a.n &* b.d, a.d &* b.n) }
    static func +(a: Q, b: Q) -> Q { Q(a.n &* b.d &+ b.n &* a.d, a.d &* b.d) }
    // exact decimal to k places, integer-only
    func dec(_ k: Int) -> String {
        var p: Int64 = 1; for _ in 0..<k { p &*= 10 }
        let scaled = (n &* p) / d
        let neg = scaled < 0, v = neg ? -scaled : scaled
        var frac = "\(v % p)"
        while frac.count < k { frac = "0" + frac }
        return (neg ? "-" : "") + "\(v / p)." + frac
    }
    var str: String { d == 1 ? "\(n)" : "\(n)/\(d)" }
}

// --- the one yield constant, exact ---
// Ferreira et al. 2024: a typical 250 kg satellite yields ~30 kg Al2O3.
let YIELD = Q(30, 250)                      // = 3/25 exactly
print("alumina yield fraction = \(YIELD.str) = \(YIELD.dec(4))   EXACT, no float")
print("")

// --- CHECK 1: does Ferreira's 2022 figure reconcile with its own yield? ---
let al2022 = Q(17)                          // ~17 t of Al2O3, 2022 population
let mass2022 = al2022 / YIELD               // implied reentered satellite mass, tonnes
print("CHECK 1 — Ferreira 2022")
print("  17 t alumina / (3/25) => implied reentered satellite mass = \(mass2022.str) t = \(mass2022.dec(2)) t")

// --- CHECK 2: the 360 t/yr scenario, and what satellite mass it requires ---
let al360 = Q(360)
let mass360 = al360 / YIELD
print("CHECK 2 — Ferreira mega-constellation scenario")
print("  360 t/yr alumina => \(mass360.str) t/yr = \(mass360.dec(1)) t/yr of reentering satellite mass")
// Boley & Byers: Starlink dry mass 260 kg = 13/50 t
let DRY = Q(260, 1000)
let nSats = mass360 / DRY
print("  at 260 kg dry mass => \(nSats.dec(0)) satellites/yr reentering")
print("  under a 5-year replacement cycle that implies a constellation of \(( nSats * Q(5)).dec(0)) on orbit")

// --- CHECK 3: the circulating ~2,400/yr projection, forward ---
let n2400 = Q(2400)
let mass2400 = n2400 * DRY
let al2400 = mass2400 * YIELD
print("CHECK 3 — the circulating 12,000 / 5-yr = 2,400/yr projection")
print("  2,400 sats/yr x 260 kg = \(mass2400.dec(0)) t/yr satellite mass")
print("  x (3/25) = \(al2400.dec(2)) t/yr alumina")
print("  Ferreira's own scenario figure is 360 t/yr — a factor of \((al360 / al2400).dec(2)) higher")

// --- CHECK 4: Maloney's 10 Gg/yr ---
let al10k = Q(10_000)
let mass10k = al10k / YIELD
let n10k = mass10k / DRY
print("CHECK 4 — Maloney et al. 2025, 10,000 t/yr")
print("  => \(mass10k.dec(0)) t/yr satellite mass => \(n10k.dec(0)) sats/yr at 260 kg")
print("  under a 5-year cycle => \((n10k * Q(5)).dec(0)) on orbit (their stated case is >60,000)")

// --- CHECK 5: measured 2025 against the ledger ---
// ESA ASER Issue 10.0: 486.7 t total re-entered mass, 442.8 t from LEO, 1,117 payloads.
let esaLEO = Q(4428, 10)
let alFromMeasured = esaLEO * YIELD
print("CHECK 5 — ESA measured calendar 2025")
print("  442.8 t re-entered from LEO x (3/25) = \(alFromMeasured.dec(2)) t alumina, IF all of it were satellite bus")
print("  (upper bound: the 442.8 t includes rocket bodies and fragments, not only payloads)")
print("")
print("EVERY LINE ABOVE IS EXACT RATIONAL ARITHMETIC. The ledger needs no float.")

print("")
print("=== CHECK 6 — is Maloney's 10 Gg/yr ALUMINA or MASS? Decide by arithmetic. ===")
// Maloney's stated case: >60,000 satellites in LEO, 5-year replacement -> 12,000/yr reentering.
let satsPerYr = Q(60_000) / Q(5)
print("  60,000 on orbit / 5 yr life = \(satsPerYr.dec(0)) reentering per year")
for (label, dryKg) in [("Starlink v1.5, 260 kg", Q(260,1000)),
                       ("Starlink v2 mini, 800 kg", Q(800,1000)),
                       ("Starlink v2 full, 1250 kg", Q(1250,1000))] {
    let massYr = satsPerYr * dryKg
    let alYr   = massYr * YIELD
    print("  \(label): mass \(massYr.dec(1)) t/yr  ->  alumina \(alYr.dec(1)) t/yr")
}
print("")
print("  READ IT: 10,000 t/yr is reached as MASS at ~800 kg/sat (9,600 t/yr), never as ALUMINA")
print("  (alumina at that mass is 1,152 t/yr). So 10 Gg/yr and 360 t/yr are DIFFERENT QUANTITIES.")
let al10kAsMass = (satsPerYr * Q(800,1000)) * YIELD
print("  Comparable alumina figures: Ferreira 360 t/yr vs Maloney-implied \(al10kAsMass.dec(0)) t/yr")
print("  ratio = \((al10kAsMass / Q(360)).dec(2)) x  — NOT the 28x that comes from comparing mass to alumina")
