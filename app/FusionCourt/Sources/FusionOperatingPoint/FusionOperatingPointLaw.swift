// THE FUSION COURT LAW — three exact integer inequalities on an operating point.
//
// It grades a PRESENTED point; it does not search, model, or extrapolate. That
// is the whole difference from a trained surrogate, which returns a number for
// any input including inputs outside anything it ever saw. Where this law has
// not been given a determinable answer it REFUSES and says which branch, rather
// than manufacturing one.
//
// Int128 (Swift 6.4 stdlib): the Greenwald product reaches 1.42e19 at a 20 m
// minor radius, past Int64, and fits Int128 with 1.2e19x to spare — so there is
// NO BigInt escalation path. Still, every product uses multipliedReportingOverflow
// and a genuine Int128 overflow REFUSES, because a wrapped verdict is worse than
// a refusal.
#if compiler(>=6.0)

public enum FusionOperatingPointLaw {

    public static let marker = "FUSION_OPERATING_POINT_IS_THREE_EXACT_INEQUALITIES"

    // pi brackets: 333/106 (low) < pi < 355/113 (high). Width 1/11978 ~ 8.35e-5.
    // (2.7e-7 is the error of 355/113 alone, NOT the width of the bracket — corrected 2026-09-03.)
    static let piLo = (num: Int128(333), den: Int128(106))
    static let piHi = (num: Int128(355), den: Int128(113))

    // Troyon: beta_N <= 0.85 * 2.8 = 2.38  -> betaNMilli <= 2380
    static let troyonCeilingMilli: Int64 = 2380
    // q_min floor: q_min >= 2.0 -> qMinMilli >= 2000
    static let qMinFloorMilli: Int64 = 2000

    /// The exact-typed face, for the strobe and for tests.
    public static func grade(_ e: OperatingEnvelope) -> CourtVerdict {
        // --- refusals first: a non-physical point is not a claim about physics ---
        if e.minorRadiusMm <= 0 || e.ipAmp < 0 || e.qMinMilli <= 0 || e.ne14 < 0 {
            return CourtVerdict(verdict: "REFUSED_NONPHYSICAL", bindingBranch: nil,
                                openBranches: [], piIndependent: false, exactPath: "int128")
        }

        // Branches graded in DECLARED order: greenwald, troyon, qMin. bindingBranch
        // is the first that fails, so the cause is deterministic — unlike a strobe's
        // last-writer record.
        var open: [Branch] = []

        // ---- Greenwald: 100 * ne14 * a_mm^2 * piNum  <  85 * ip * 1e6 * piDen ----
        // f_GW = n / n_G < 0.85, with n_G = ip/(pi a^2) in matching units.
        // A currentless machine (stellarator) has NO Greenwald limit — Greenwald is
        // a statement about a current-carrying plasma. The court refuses to invent an
        // n_G that does not exist. THIS ARM IS THE THESIS: an invariant approach names
        // what it cannot determine; a surrogate divides by ~0 and extrapolates.
        var greenwaldFails: Bool? = nil
        var piIndependent = true
        if e.ipAmp == 0 {
            open.append(.greenwald)
        } else {
            switch greenwaldViolated(e, piNum: piLo.num, piDen: piLo.den) {
            case .overflow:
                return CourtVerdict(verdict: "REFUSED_NONPHYSICAL", bindingBranch: .greenwald,
                                    openBranches: open, piIndependent: false, exactPath: "int128")
            case .value(let loViol):
                if e.piNum > 0 && e.piDen > 0 {
                    // caller declared its own pi — one exact evaluation, no bracket
                    switch greenwaldViolated(e, piNum: Int128(e.piNum), piDen: Int128(e.piDen)) {
                    case .overflow:
                        return CourtVerdict(verdict: "REFUSED_NONPHYSICAL", bindingBranch: .greenwald,
                                            openBranches: open, piIndependent: false, exactPath: "int128")
                    case .value(let v): greenwaldFails = v; piIndependent = false
                    }
                } else {
                    switch greenwaldViolated(e, piNum: piHi.num, piDen: piHi.den) {
                    case .overflow:
                        return CourtVerdict(verdict: "REFUSED_NONPHYSICAL", bindingBranch: .greenwald,
                                            openBranches: open, piIndependent: false, exactPath: "int128")
                    case .value(let hiViol):
                        if loViol == hiViol {
                            greenwaldFails = loViol       // pi-independent
                        } else {
                            // the point sits ON the Greenwald limit to within pi itself
                            return CourtVerdict(verdict: "NOT_MEASURED_PI_BRACKET",
                                                bindingBranch: nil, openBranches: open,
                                                piIndependent: false, exactPath: "int128")
                        }
                    }
                }
            }
        }
        if greenwaldFails == true {
            return CourtVerdict(verdict: "MISS", bindingBranch: .greenwald, openBranches: open,
                                piIndependent: piIndependent, exactPath: "int128")
        }

        // ---- Troyon ----
        if e.betaNMilli > troyonCeilingMilli {
            return CourtVerdict(verdict: "MISS", bindingBranch: .troyon, openBranches: open,
                                piIndependent: piIndependent, exactPath: "int128")
        }
        // ---- q_min ----
        if e.qMinMilli < qMinFloorMilli {
            return CourtVerdict(verdict: "MISS", bindingBranch: .qMin, openBranches: open,
                                piIndependent: piIndependent, exactPath: "int128")
        }

        if e.ipAmp == 0 {
            // troyon and qMin held, but greenwald was undeterminable
            return CourtVerdict(verdict: "NOT_APPLICABLE_NO_PLASMA_CURRENT",
                                bindingBranch: nil, openBranches: open,
                                piIndependent: piIndependent, exactPath: "int128")
        }
        return CourtVerdict(verdict: "WIN", bindingBranch: nil, openBranches: open,
                            piIndependent: piIndependent, exactPath: "int128")
    }

    private enum Guarded { case value(Bool); case overflow }

    /// Is n_e above 0.85 * n_Greenwald?  LHS < RHS means BELOW the limit (safe).
    ///   100 * ne14 * a_mm^2 * piNum   vs   85 * ip * 1_000_000 * piDen
    private static func greenwaldViolated(_ e: OperatingEnvelope,
                                          piNum: Int128, piDen: Int128) -> Guarded {
        let ne = Int128(e.ne14), a = Int128(e.minorRadiusMm), ip = Int128(e.ipAmp)
        func mul(_ x: Int128, _ y: Int128) -> Int128? {
            let (p, o) = x.multipliedReportingOverflow(by: y); return o ? nil : p
        }
        guard let a2 = mul(a, a),
              let l1 = mul(100, ne), let l2 = mul(l1, a2), let lhs = mul(l2, piNum),
              let r1 = mul(85, ip), let r2 = mul(r1, 1_000_000), let rhs = mul(r2, piDen)
        else { return .overflow }
        return .value(lhs >= rhs)     // >= limit means VIOLATED (n >= 0.85 n_G)
    }
}
#endif
