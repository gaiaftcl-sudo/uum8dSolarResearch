// The reactor operating point, on the wire, in EXACT INTEGER units only.
// The court's ingest refuses any float-shaped token, so there is no "6.2" and
// no "1e20" anywhere near this type — lengths in mm, currents in A, densities
// in 1e14 m^-3, ratios x1000.
//
// MAC-ONLY app (founder, 2026-09-03: "this is a mac only fusion app, not the
// build for the affine.earth cells"). Kept Foundation-free anyway — a verdict
// law that needs a runtime is not a law — but this does NOT ship to the cells
// and carries no Linux-portability burden.
#if compiler(>=6.0)

public struct OperatingEnvelope: Sendable, Equatable {
    public let ne14: Int64          // electron density / 1e14 m^-3
    public let ipAmp: Int64         // plasma current, amperes  (0 = a currentless machine)
    public let minorRadiusMm: Int64 // a, millimetres
    public let betaNMilli: Int64    // beta_N x 1000
    public let qMinMilli: Int64     // q_min x 1000
    public let piNum: Int64         // caller-declared pi, or 0 to use the bracket
    public let piDen: Int64

    public init(ne14: Int64, ipAmp: Int64, minorRadiusMm: Int64,
                betaNMilli: Int64, qMinMilli: Int64,
                piNum: Int64 = 0, piDen: Int64 = 0) {
        self.ne14 = ne14; self.ipAmp = ipAmp; self.minorRadiusMm = minorRadiusMm
        self.betaNMilli = betaNMilli; self.qMinMilli = qMinMilli
        self.piNum = piNum; self.piDen = piDen
    }
}

public enum Branch: String, Sendable { case greenwald, troyon, qMin }

public struct CourtVerdict: Sendable, Equatable {
    public let verdict: String            // WIN | MISS | NOT_MEASURED_PI_BRACKET
                                          // | NOT_APPLICABLE_NO_PLASMA_CURRENT | REFUSED_NONPHYSICAL
    public let bindingBranch: Branch?     // the FIRST branch that failed, in declared order
    public let openBranches: [Branch]     // branches that could not be graded (e.g. no current)
    public let piIndependent: Bool        // true when the verdict holds at both pi bounds
    public let exactPath: String          // "int128"
    public init(verdict: String, bindingBranch: Branch?, openBranches: [Branch],
                piIndependent: Bool, exactPath: String) {
        self.verdict = verdict; self.bindingBranch = bindingBranch
        self.openBranches = openBranches; self.piIndependent = piIndependent
        self.exactPath = exactPath
    }
}
#endif
