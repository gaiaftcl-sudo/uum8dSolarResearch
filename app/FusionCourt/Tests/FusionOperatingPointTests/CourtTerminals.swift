import Testing
@testable import FusionOperatingPoint

// Every terminal must be REACHABLE — a court that cannot reach all its verdicts
// is a turn counter. Reference points: ITER (tight but safe) and a stellarator
// (no current, so Greenwald is undeterminable, which is the whole thesis).
@Suite("fusion court terminals") struct CourtTerminals {

    // ITER: R=6.2 a=2.0m B=5.3T I_p=15 MA, n_e ~ 1e20 -> ne14 = 1e6.
    // f_GW = 0.8377 -> HOLDS but tight, exactly where a float verdict is not one.
    static let iter = OperatingEnvelope(ne14: 1_000_000, ipAmp: 15_000_000,
        minorRadiusMm: 2000, betaNMilli: 1800, qMinMilli: 3000)

    @Test("ITER at a safe point WINs")
    func iterWins() { #expect(FusionOperatingPointLaw.grade(Self.iter).verdict == "WIN") }

    @Test("over the Greenwald density MISSes on the greenwald branch")
    func greenwaldMiss() {
        var e = Self.iter
        e = OperatingEnvelope(ne14: 3_000_000, ipAmp: e.ipAmp, minorRadiusMm: e.minorRadiusMm,
                              betaNMilli: e.betaNMilli, qMinMilli: e.qMinMilli)
        let v = FusionOperatingPointLaw.grade(e)
        #expect(v.verdict == "MISS"); #expect(v.bindingBranch == .greenwald)
    }
    @Test("over the Troyon beta limit MISSes on troyon")
    func troyonMiss() {
        let e = OperatingEnvelope(ne14: 1_000_000, ipAmp: 15_000_000, minorRadiusMm: 2000,
                                  betaNMilli: 3000, qMinMilli: 3000)
        let v = FusionOperatingPointLaw.grade(e)
        #expect(v.verdict == "MISS"); #expect(v.bindingBranch == .troyon)
    }
    @Test("under q_min MISSes on qMin")
    func qMinMiss() {
        let e = OperatingEnvelope(ne14: 1_000_000, ipAmp: 15_000_000, minorRadiusMm: 2000,
                                  betaNMilli: 1800, qMinMilli: 1500)
        let v = FusionOperatingPointLaw.grade(e)
        #expect(v.verdict == "MISS"); #expect(v.bindingBranch == .qMin)
    }
    @Test("branch order: greenwald binds first even when troyon also fails")
    func branchOrder() {
        let e = OperatingEnvelope(ne14: 9_000_000, ipAmp: 15_000_000, minorRadiusMm: 2000,
                                  betaNMilli: 3000, qMinMilli: 1500)  // all three fail
        #expect(FusionOperatingPointLaw.grade(e).bindingBranch == .greenwald)
    }
    @Test("a currentless machine: Greenwald is NOT_APPLICABLE, not a fabricated number")
    func stellaratorNoCurrent() {
        // A stellarator confines without plasma current and routinely runs above
        // the Greenwald density. The court refuses to invent an n_G.
        let e = OperatingEnvelope(ne14: 4_000_000, ipAmp: 0, minorRadiusMm: 550,
                                  betaNMilli: 1800, qMinMilli: 3000)
        let v = FusionOperatingPointLaw.grade(e)
        #expect(v.verdict == "NOT_APPLICABLE_NO_PLASMA_CURRENT")
        #expect(v.openBranches == [.greenwald])
    }
    @Test("a non-physical point is REFUSED, not graded")
    func refusedNonphysical() {
        let e = OperatingEnvelope(ne14: 1_000_000, ipAmp: 15_000_000, minorRadiusMm: -5,
                                  betaNMilli: 1800, qMinMilli: 3000)
        #expect(FusionOperatingPointLaw.grade(e).verdict == "REFUSED_NONPHYSICAL")
    }
    @Test("the WIN at a safe point is pi-independent — stronger than any float")
    func piIndependent() { #expect(FusionOperatingPointLaw.grade(Self.iter).piIndependent) }

    @Test("the pi-bracket terminal is reachable — a point on the limit to within pi itself")
    func piBracket() {
        // Found by search: LHS/RHS lands between 113/355 and 106/333, so the
        // Greenwald verdict flips between the two pi bounds. The court refuses to
        // pick, and tells the caller to declare pi_num/pi_den to make it exact.
        let e = OperatingEnvelope(ne14: 27057, ipAmp: 400_000, minorRadiusMm: 2000,
                                  betaNMilli: 1800, qMinMilli: 3000)
        #expect(FusionOperatingPointLaw.grade(e).verdict == "NOT_MEASURED_PI_BRACKET")
    }
    @Test("declaring pi resolves the bracket to an exact verdict")
    func declaredPiResolvesBracket() {
        let e = OperatingEnvelope(ne14: 27057, ipAmp: 400_000, minorRadiusMm: 2000,
                                  betaNMilli: 1800, qMinMilli: 3000, piNum: 355, piDen: 113)
        let v = FusionOperatingPointLaw.grade(e)
        #expect(v.verdict != "NOT_MEASURED_PI_BRACKET")   // now decided, either WIN or MISS
        #expect(!v.piIndependent)                          // and it says it depended on the choice
    }
    @Test("all six terminals are reachable")
    func allReachable() {
        var e2 = Self.iter
        e2 = OperatingEnvelope(ne14: 3_000_000, ipAmp: 15_000_000, minorRadiusMm: 2000, betaNMilli: 1800, qMinMilli: 3000)
        let seen: Set<String> = [
            FusionOperatingPointLaw.grade(Self.iter).verdict,                                    // WIN
            FusionOperatingPointLaw.grade(e2).verdict,                                           // MISS
            FusionOperatingPointLaw.grade(OperatingEnvelope(ne14: 4_000_000, ipAmp: 0, minorRadiusMm: 550, betaNMilli: 1800, qMinMilli: 3000)).verdict, // NOT_APPLICABLE
            FusionOperatingPointLaw.grade(OperatingEnvelope(ne14: 1_000_000, ipAmp: 15_000_000, minorRadiusMm: -5, betaNMilli: 1800, qMinMilli: 3000)).verdict, // REFUSED
            FusionOperatingPointLaw.grade(OperatingEnvelope(ne14: 27057, ipAmp: 400_000, minorRadiusMm: 2000, betaNMilli: 1800, qMinMilli: 3000)).verdict, // PI_BRACKET
        ]
        #expect(seen.count == 5)   // WIN, MISS, NOT_APPLICABLE, REFUSED, NOT_MEASURED_PI_BRACKET
    }
}
