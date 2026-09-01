print("=== GATE 1 note: cold-day overshoot on a 500 mW nominal panel ===")
// Monocrystalline power temp coefficient ~ -0.30 to -0.45 %/degC, referenced to STC 25 degC.
// Cold + bright is the worst case for OVERSHOOT.
let nominalMw = 500, ceilingMw = 510
for coeffMilliPctPerC in [300, 380, 450] {          // 0.300, 0.380, 0.450 %/degC, integer milli-percent
    for tC in [0, -10, -20] {
        let dT = 25 - tC                             // degrees BELOW STC
        // gain = 1 + coeff*dT  ; work in parts-per-million to stay integral
        let gainPpm = 1_000_000 + (coeffMilliPctPerC * dT * 10)   // milli-% -> ppm is *10
        let outMw = nominalMw * gainPpm / 1_000_000
        let over = outMw > ceilingMw
        print("  coeff \(coeffMilliPctPerC)m%/C at \(tC) C: \(outMw) mW  \(over ? "OVER the 510 mW ceiling" : "within ceiling")")
    }
}
print("")
print("  A 450 mW nominal panel at the same worst case:")
for coeffMilliPctPerC in [450] { for tC in [-20] {
    let gainPpm = 1_000_000 + (coeffMilliPctPerC * (25 - tC) * 10)
    print("    \(450 * gainPpm / 1_000_000) mW  (ceiling 510) — and still 48x the daily duty ceiling")
} }

print("")
print("=== GATE 2 note: x7 flux across the wrap boundary ===")
let N = 65536
func naive(_ a: Int, _ b: Int) -> Int { abs(a - b) }
func ringDelta(_ a: Int, _ b: Int) -> Int {          // signed shortest path on Z/N
    var d = (a - b) % N
    if d < 0 { d += N }
    if d > N/2 { d -= N }
    return d
}
for (a, b, truth) in [(5, 65530, 11), (65530, 5, -11), (100, 90, 10), (32768, 0, 32768)] {
    print("  x(tk)=\(a) x(tk-1)=\(b): naive |a-b| = \(naive(a,b))   ringDelta = \(ringDelta(a,b))   true change = \(truth)")
}
print("")
print("  The naive absolute difference reports 65,525 for a real change of 11 —")
print("  a benign step across the wrap reads as a near-maximal flux excursion.")
print("  ringDelta is exact, integer-only, and agrees with the true change whenever |change| < N/2.")
