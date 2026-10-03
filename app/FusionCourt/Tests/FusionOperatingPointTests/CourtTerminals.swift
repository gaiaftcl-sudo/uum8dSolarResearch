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

    // ---- the faces added 2026-10-03: one home for n_G, the sides, the margin ----

    @Test("n_G floors exactly: four machines at pi = 355/113, and no limit without current")
    func greenwaldDensityFloors() {
        let hi = FusionOperatingPointLaw.piHi
        func ng(_ ip: Int64, _ a: Int64) -> Int64? {
            FusionOperatingPointLaw.greenwaldDensityFloor(ipAmp: ip, minorRadiusMm: a,
                                                          piNum: hi.num, piDen: hi.den)
        }
        #expect(ng(15_000_000, 2000) == 1_193_661)     // ITER — also pinned by validate.sh
        #expect(ng(8_700_000, 570) == 8_523_532)       // SPARC
        #expect(ng(4_800_000, 1250) == 977_847)        // JET
        #expect(ng(2_000_000, 670) == 1_418_177)       // DIII-D
        // CONTROL: no current, no limit — nil, never 0
        #expect(ng(0, 530) == nil)
        #expect(ng(15_000_000, 0) == nil)
        #expect(FusionOperatingPointLaw.greenwaldDensityFloor(ipAmp: 15_000_000, minorRadiusMm: 2000,
                                                              piNum: 0, piDen: 113) == nil)
        // the bracket moves the floor: the low pi gives a LARGER n_G
        let lo = FusionOperatingPointLaw.piLo
        #expect(FusionOperatingPointLaw.greenwaldDensityFloor(ipAmp: 15_000_000, minorRadiusMm: 2000,
                                                              piNum: lo.num, piDen: lo.den)! > 1_193_661)
    }

    @Test("the sides shown are the sides compared: ITER at its test point, above 2^53")
    func greenwaldSidesAtIter() {
        let s = FusionOperatingPointLaw.greenwaldSides(Self.iter, piNum: 355, piDen: 113)
        #expect(s?.lhs == 142_000_000_000_000_000)
        #expect(s?.rhs == 144_075_000_000_000_000)
        #expect(s!.lhs > (Int128(1) << 53))            // past where float64 is exact
        #expect(s!.lhs < s!.rhs)                        // and the court says WIN
        #expect(FusionOperatingPointLaw.grade(Self.iter).verdict == "WIN")
        // CONTROL: a product past Int128 has no sides, and the court refuses it
        let huge = OperatingEnvelope(ne14: Int64.max, ipAmp: 1, minorRadiusMm: Int64.max,
                                     betaNMilli: 1800, qMinMilli: 3000)
        #expect(FusionOperatingPointLaw.greenwaldSides(huge, piNum: 355, piDen: 113) == nil)
        #expect(FusionOperatingPointLaw.grade(huge).verdict == "REFUSED_NONPHYSICAL")
    }

    @Test("the margin inside the inequality is the published constant: 85 % WIN, 86 % MISS")
    func marginBoundary() {
        // ITER at 85 % and 86 % of its own n_G (pi = 355/113, floored): the court's
        // boundary sits between them, which is exactly greenwaldMarginPercent.
        #expect(FusionOperatingPointLaw.greenwaldMarginPercent == 85)
        let ng: Int64 = 1_193_661
        let at85 = OperatingEnvelope(ne14: ng * 85 / 100, ipAmp: 15_000_000, minorRadiusMm: 2000,
                                     betaNMilli: 1800, qMinMilli: 3000)
        let at86 = OperatingEnvelope(ne14: ng * 86 / 100, ipAmp: 15_000_000, minorRadiusMm: 2000,
                                     betaNMilli: 1800, qMinMilli: 3000)
        #expect(FusionOperatingPointLaw.grade(at85).verdict == "WIN")
        #expect(FusionOperatingPointLaw.grade(at86).verdict == "MISS")
        #expect(FusionOperatingPointLaw.grade(at86).bindingBranch == .greenwald)
    }

    @Test("half a declared pi is not a declaration: the court grades at the bracket")
    func halfDeclaredPi() {
        let half = OperatingEnvelope(ne14: 27057, ipAmp: 400_000, minorRadiusMm: 2000,
                                     betaNMilli: 1800, qMinMilli: 3000, piNum: 355, piDen: 0)
        #expect(!half.declaresPi)
        #expect(FusionOperatingPointLaw.grade(half).verdict == "NOT_MEASURED_PI_BRACKET")
        let whole = OperatingEnvelope(ne14: 27057, ipAmp: 400_000, minorRadiusMm: 2000,
                                      betaNMilli: 1800, qMinMilli: 3000, piNum: 355, piDen: 113)
        #expect(whole.declaresPi)
        #expect(FusionOperatingPointLaw.grade(whole).verdict != "NOT_MEASURED_PI_BRACKET")
    }

    @Test("one input grammar: -?[0-9]+ that fits Int64, everything else refused")
    func integerTokens() {
        #expect(IntegerToken.parse("1000000") == 1_000_000)
        #expect(IntegerToken.parse("-5") == -5)
        #expect(IntegerToken.parse("0") == 0)
        #expect(IntegerToken.parse("9223372036854775807") == Int64.max)
        #expect(IntegerToken.parse("-9223372036854775808") == Int64.min)
        // CONTROL: the measured truncation 6.2 -> 6 must be a refusal here
        #expect(IntegerToken.parse("6.2") == nil)
        for bad in ["", "-", "+5", " 7", "7 ", "1e6", "0x10", "9223372036854775808",
                    "-9223372036854775809", "12a", "--1"] {
            #expect(IntegerToken.parse(bad) == nil, "\(bad)")
        }
        // a -5 radius PARSES; the court, not the parser, refuses it
        let e = OperatingEnvelope(ne14: 1_000_000, ipAmp: 15_000_000,
                                  minorRadiusMm: IntegerToken.parse("-5")!,
                                  betaNMilli: 1800, qMinMilli: 3000)
        #expect(FusionOperatingPointLaw.grade(e).verdict == "REFUSED_NONPHYSICAL")
    }

    // ---- the machine table and the synthetic sweep ----

    @Test("the machine table: five rows, ITER's R sourced, every unsourced figure nil")
    func machineTable() {
        let all = FusionMachines.all
        #expect(all.map(\.name) == ["ITER", "SPARC", "JET", "DIII-D", "W7-X"])
        #expect(FusionMachines.iter.majorRadiusMm == 6200)
        for m in all where m.name != "ITER" { #expect(m.majorRadiusMm == nil, "\(m.name) R") }
        for m in all {
            #expect(m.kappaMilli == nil, "\(m.name) kappa")
            #expect(m.fieldPeriods == nil, "\(m.name) field periods")
            #expect(m.grade == "REPORTED")
        }
        #expect(FusionMachines.w7x.ipAmp == 0)
        #expect(FusionMachines.jet.qualifier.contains("up to"))
        #expect(FusionMachines.diiiD.qualifier.contains("up to"))
    }

    @Test("the drift: -2 at tick 4,320, a 20,160-tick triangle in [-14, +14]")
    func driftTriangle() {
        #expect(FusionMachines.drift(tick: 4320) == -2)
        #expect(FusionMachines.drift(tick: 0) == -14)
        #expect(FusionMachines.drift(tick: 28 * 360) == 14)
        var lo: Int64 = 0, hi: Int64 = 0
        var t: UInt64 = 0
        while t < 20_160 {
            let d = FusionMachines.drift(tick: t)
            lo = min(lo, d); hi = max(hi, d)
            #expect(d == FusionMachines.drift(tick: t + 20_160))
            t += 360
        }
        #expect(lo == -14 && hi == 14)
    }

    @Test("the published frame re-derives at tick 4,320: 72 WIN, 80 WIN, 86 MISS, 94 MISS, N/A")
    func referenceFrame() {
        func frame(_ tick: UInt64) -> [(Int64, String)] {
            FusionMachines.all.map { m in
                let p = FusionMachines.operatingPoint(m, tick: tick)!
                return (p.percent, FusionOperatingPointLaw.grade(p.envelope).verdict)
            }
        }
        let f = frame(4320)
        #expect(f.map { $0.0 } == [72, 80, 86, 94, 0])
        #expect(f.map { $0.1 } == ["WIN", "WIN", "MISS", "MISS", "NOT_APPLICABLE_NO_PLASMA_CURRENT"])
        let w = FusionOperatingPointLaw.grade(FusionMachines.operatingPoint(FusionMachines.w7x, tick: 4320)!.envelope)
        #expect(w.openBranches == [.greenwald])
        // CONTROL: drift +12 (tick 26 x 360) puts ITER at 86 %, and the court calls MISS
        let g = frame(26 * 360)
        #expect(g[0].0 == 86)
        #expect(g[0].1 == "MISS")
        // the table's n_G is the law's n_G
        #expect(FusionMachines.operatingPoint(FusionMachines.iter, tick: 4320)!.greenwaldFloor14 == 1_193_661)
    }
}
