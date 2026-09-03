import Testing
@testable import FusionLaw

// The frozen input -> terminal vectors, including the three cases where the
// law's three prior forks DISAGREED. These are the regression fence.
@Suite("law conformance") struct ConformanceVectors {

    static func quiescent(_ n: Int) -> [Int32] { (0..<n).map { Int32((($0 &* 2246822519) >> 22) % 140 - 70) } }
    static func growing(_ n: Int) -> [Int32] {
        (0..<n).map { i in let e = i < 200 ? 60 : 60 + (i-200)*120; return Int32(i % 2 == 0 ? e : -e) }
    }

    @Test("quiescent plasma is NOMINAL")
    func quiescentNominal() {
        #expect(FusionLaw.screen(Self.quiescent(400)).verdict == .NOMINAL)
    }
    @Test("a growing mode MITIGATEs and names where")
    func growingMitigates() {
        let r = FusionLaw.screen(Self.growing(260))
        #expect(r.verdict == .MITIGATE)
        #expect(r.firstTrip == 208)
        #expect(r.peakGrowth == 960)
    }
    @Test("one spike is not a mode")
    func spikeIsNotAMode() {
        var t = Self.quiescent(400); t[60] = 3400
        #expect(FusionLaw.screen(t).verdict == .NOMINAL)
    }
    @Test("past the declared envelope the law REFUSES rather than extrapolating")
    func envelopeRefuses() {
        let r = FusionLaw.screen([Int32](repeating: 6500, count: 120))
        #expect(r.verdict == .REFUSED_OUT_OF_ENVELOPE)
    }

    // ---- the three fork-divergence cases ----
    @Test("DIVERGENCE: a too-short input is REFUSED, never NOMINAL")
    func shortInputRefused() {
        // One prior copy returned NOMINAL here: a refusal had become a pass.
        #expect(FusionLaw.screen([1,2,3,4,5] as [Int32]).verdict == .REFUSED_MALFORMED)
    }
    @Test("DIVERGENCE: malformed anywhere beats out-of-envelope earlier")
    func malformedBeatsEnvelope() {
        // Prior copies disagreed on this exact trace: one said MALFORMED, two
        // said OUT_OF_ENVELOPE, purely from where the malformed scan sat.
        var t = Self.quiescent(400); t[10] = 6500; t[300] = 30000
        #expect(FusionLaw.screen(t).verdict == .REFUSED_MALFORMED)
    }
    @Test("DIVERGENCE: malformed inside the first window is still seen")
    func malformedInsideWindow() {
        var t = Self.quiescent(400); t[3] = 30000
        #expect(FusionLaw.screen(t).verdict == .REFUSED_MALFORMED)
    }

    @Test("the law is deterministic")
    func deterministic() {
        let ref = FusionLaw.screen(Self.growing(260))
        for _ in 0..<2000 { #expect(FusionLaw.screen(Self.growing(260)) == ref) }
    }
    @Test("four distinct terminals are reachable — the law discriminates")
    func discriminates() {
        var t = Self.quiescent(400); t[3] = 30000
        let seen: Set<Verdict> = [
            FusionLaw.screen(Self.quiescent(400)).verdict,
            FusionLaw.screen(Self.growing(260)).verdict,
            FusionLaw.screen([Int32](repeating: 6500, count: 120)).verdict,
            FusionLaw.screen(t).verdict,
        ]
        #expect(seen.count == 4)
    }
}
