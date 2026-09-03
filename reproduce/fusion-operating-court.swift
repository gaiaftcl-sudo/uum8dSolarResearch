// fusion-operating-court.swift — a REPRODUCE study.
//
// Runs the COMMITTED fusion operating-point court law (FusionOperatingPointLaw,
// two sources under app/FusionCourt/Sources/FusionOperatingPoint/) over a table
// of PUBLISHED reactor operating points and prints the verdict the law returns
// for each. Nothing here re-implements the physics: every verdict, every binding
// branch, every pi-independence flag is read straight off CourtVerdict. The only
// number this program prints is the count of distinct terminals reached, and it
// is computed by counting the verdict strings the law actually emitted.
//
// Reproduce recipe (stage as main.swift, compile with the two law sources):
//   d=$(mktemp -d); cp reproduce/fusion-operating-court.swift "$d/main.swift"
//   xcrun swiftc -O -swift-version 5 \
//     app/FusionCourt/Sources/FusionOperatingPoint/*.swift "$d/main.swift" -o /tmp/x && /tmp/x
//
// Units are EXACT INTEGERS, exactly as the wire type demands:
//   ne14         = electron density / 1e14 m^-3
//   ipAmp        = plasma current in amperes (0 = a currentless machine)
//   minorRadiusMm= minor radius a, in millimetres
//   betaNMilli   = normalized beta beta_N x 1000
//   qMinMilli    = minimum safety factor q_min x 1000
//   piNum/piDen  = a caller-declared pi as a ratio, or 0/0 to grade against the
//                  333/106 < pi < 355/113 bracket.

#if compiler(>=6.0)

// --- table plumbing (no physics lives here; the law is the only judge) ---------
func pad(_ s: String, _ n: Int) -> String {
    s.count >= n ? s : s + String(repeating: " ", count: n - s.count)
}

struct Point {
    let label: String
    let env: OperatingEnvelope
}

let points: [Point] = [

    // 1. ITER nominal, inductive baseline scenario. n_e ~ 1.0e20 m^-3, I_p = 15 MA,
    //    a = 2.0 m, beta_N ~ 1.8, q_95 ~ 3.  f_GW ~ 0.84, tight but under 0.85.
    //    Source: ITER Physics Basis, Nucl. Fusion 47 (2007) S1; ITER baseline 15 MA
    //    Q=10 H-mode scenario.  -> WIN, and the WIN is pi-INDEPENDENT: it holds at
    //    both ends of the pi bracket, a stronger claim than any single float pi.
    Point(label: "ITER 15MA baseline (nominal)",
          env: OperatingEnvelope(ne14: 1_000_000, ipAmp: 15_000_000,
                                 minorRadiusMm: 2000, betaNMilli: 1800, qMinMilli: 3000)),

    // 2. ITER driven ~40% above its Greenwald density (n/n_G ~ 1.17). This is the
    //    density-limit / MARFE-and-disruption regime.  Source: Greenwald et al.,
    //    Nucl. Fusion 28 (1988) 2199; Greenwald, PPCF 44 (2002) R27.
    //    -> MISS, binding branch greenwald.
    Point(label: "ITER pushed over Greenwald density",
          env: OperatingEnvelope(ne14: 1_400_000, ipAmp: 15_000_000,
                                 minorRadiusMm: 2000, betaNMilli: 1800, qMinMilli: 3000)),

    // 3. ITER density nominal but beta_N driven to 3.0, past the Troyon ceiling
    //    (beta_N <= 0.85 * 2.8 = 2.38 in this court). Ideal-MHD beta limit.
    //    Source: Troyon et al., Plasma Phys. Control. Fusion 26 (1984) 209.
    //    -> MISS, binding branch troyon.  (Greenwald passes first, so troyon binds.)
    Point(label: "ITER over Troyon beta limit",
          env: OperatingEnvelope(ne14: 1_000_000, ipAmp: 15_000_000,
                                 minorRadiusMm: 2000, betaNMilli: 3000, qMinMilli: 3000)),

    // 4. ITER with q_min driven to 1.5, below the q_min >= 2.0 floor: the kink /
    //    sawtooth / NTM-unstable regime.  Source: ITER Physics Basis ch.3 (MHD),
    //    Nucl. Fusion 39 (1999) 2251.  -> MISS, binding branch qMin.
    Point(label: "ITER under q_min floor",
          env: OperatingEnvelope(ne14: 1_000_000, ipAmp: 15_000_000,
                                 minorRadiusMm: 2000, betaNMilli: 1800, qMinMilli: 1500)),

    // 5. A stellarator-class point: Wendelstein 7-X, a currentless optimized
    //    stellarator (confinement from external coils, no net toroidal plasma
    //    current -> ipAmp = 0). a ~ 0.53 m; beta and q comfortably within the
    //    tokamak-style Troyon/q floors, so the ONLY branch the court cannot grade
    //    is Greenwald.  Source: Klinger et al., Nucl. Fusion 59 (2019) 112004.
    //    -> NOT_APPLICABLE_NO_PLASMA_CURRENT (Greenwald left open).
    Point(label: "W7-X stellarator (currentless, Ip=0)",
          env: OperatingEnvelope(ne14: 200_000, ipAmp: 0,
                                 minorRadiusMm: 530, betaNMilli: 2000, qMinMilli: 2500)),

    // 6. A point engineered to sit ON the 0.85*n_G line to within pi itself: n is
    //    below the limit at pi=333/106 and above it at pi=355/113. The court will
    //    NOT pick a side using a rounded pi.  (Values from the committed law's own
    //    pi-bracket fixture.)  -> NOT_MEASURED_PI_BRACKET.
    Point(label: "on the Greenwald line (pi-bracket)",
          env: OperatingEnvelope(ne14: 27057, ipAmp: 400_000,
                                 minorRadiusMm: 2000, betaNMilli: 1800, qMinMilli: 3000)),

    // 7. The SAME bracket point, but the caller now DECLARES its own pi as the exact
    //    ratio 355/113. One exact evaluation, no bracket: the point is above the
    //    limit at that pi.  -> MISS greenwald, and piIndependent is now FALSE — the
    //    verdict is true only for the pi the caller asserted, and the law says so.
    Point(label: "same point, caller declares its pi",
          env: OperatingEnvelope(ne14: 27057, ipAmp: 400_000,
                                 minorRadiusMm: 2000, betaNMilli: 1800, qMinMilli: 3000,
                                 piNum: 355, piDen: 113)),

    // 8. ITER's numbers with a reversed-sign current — a malformed submission, not a
    //    claim about physics. The court refuses it at the door rather than returning
    //    a confident number for a point that cannot exist. A trained surrogate has no
    //    such door: it extrapolates through nonsense inputs just as fluently.
    //    -> REFUSED_NONPHYSICAL.
    Point(label: "malformed submission (Ip < 0)",
          env: OperatingEnvelope(ne14: 1_000_000, ipAmp: -15_000_000,
                                 minorRadiusMm: 2000, betaNMilli: 1800, qMinMilli: 3000)),
]

// --- run the court and print the table ----------------------------------------
let wL = 38, wV = 34, wB = 12
print("FUSION OPERATING-POINT COURT — reproduce over published reactor points")
print("law marker: \(FusionOperatingPointLaw.marker)")
print("")
print(pad("OPERATING POINT", wL) + pad("VERDICT", wV) + pad("BINDS", wB) + "PI-INDEP")
print(String(repeating: "-", count: wL + wV + wB + 8))

var seen = Set<String>()
for p in points {
    let v = FusionOperatingPointLaw.grade(p.env)
    seen.insert(v.verdict)
    let branch = v.bindingBranch?.rawValue ?? "-"
    let piInd = v.piIndependent ? "yes" : "no"
    print(pad(p.label, wL) + pad(v.verdict, wV) + pad(branch, wB) + piInd)
}

print("")
print("Why the stellarator returns NOT_APPLICABLE and not a number: the Greenwald")
print("limit is a statement about a current-carrying plasma (n_G = Ip / (pi a^2)).")
print("A currentless machine has Ip = 0, so n_G is undeterminable and the court")
print("leaves the Greenwald branch OPEN rather than inventing an n_G. That is the")
print("thesis: an invariant approach names what it cannot determine; a trained")
print("surrogate divides by ~0 and extrapolates a confident answer anyway.")
print("")
print("What the court does that a probabilistic surrogate cannot: it REFUSES rather")
print("than extrapolates. Every WIN and MISS is an exact integer inequality between")
print("Int128 products — the Greenwald product, the Troyon ceiling, the q_min floor —")
print("that a third party can re-derive by hand from the same integer inputs and reach")
print("the identical verdict on any machine. Where the answer turns on the value of pi")
print("below the resolution of a rational bracket, the court returns NOT_MEASURED and")
print("names the bracket instead of picking a side; where the input is nonphysical it")
print("returns REFUSED and names the branch. A surrogate returns a plausible float for")
print("every input, including the ones it has no basis to answer, and cannot tell you")
print("which of its answers it was entitled to give.")
print("")

let n = seen.count
if n == 5 {
    print("COURT TERMINALS REACHED: \(n) of 5")
} else {
    print("COURT TERMINALS REACHED: \(n) of 5  [BUG: expected all 5 distinct verdict")
    print("strings; the table above did not exercise every terminal. Seen: \(seen.sorted())]")
}

#else
print("compiler < 6.0: FusionOperatingPointLaw is guarded out; nothing to reproduce.")
#endif
