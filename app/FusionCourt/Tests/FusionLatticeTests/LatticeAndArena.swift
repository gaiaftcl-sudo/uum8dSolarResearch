import Testing
@testable import FusionLattice
@testable import FusionAffine
@testable import FusionLaw

@Suite("lattice + arena") struct LatticeAndArena {

    @Test("the torus wrap is reversible")
    func wrapReversible() {
        var p = LatticePoint8()
        p[0] = LatticeAxis(Int128(-7)); p[1] = LatticeAxis(Int128(13)); p[2] = LatticeAxis(Int128(-1))
        let span: Int128 = 5
        let w = p.winding(span: span)
        var q = p; q.wrap(span: span)
        for i in 0..<3 { #expect(q[i].q >= 0 && q[i].q < span) }
        #expect(q[0].q + w[0]*span == -7)
        #expect(q[1].q + w[1]*span == 13)
        #expect(q[2].q + w[2]*span == -1)
    }

    @Test("overflow is reported, never wrapped")
    func overflowReported() {
        let (_, of) = LatticeAxis(Int128.max).adding(LatticeAxis(Int128(1)))
        #expect(of)
    }

    @Test("the Greenwald product that overflows Int64 fits Int128")
    func greenwaldFits() {
        let ne14: Int128 = 1_000_000, piNum: Int128 = 355, aMm: Int128 = 20_000
        let lhs = 100 * ne14 * piNum * aMm * aMm
        #expect(lhs > Int128(Int64.max))
        #expect(lhs < Int128.max)
    }

    @Test("lanes do not share an envelope")
    func lanesDiffer() {
        let probe = Modalities.magneticProbe, cam = Modalities.neutronCamera
        // 3000 counts: inside the probe's envelope, outside the camera's DOMAIN.
        #expect(3000 < probe.envelopeAbs)
        #expect(3000 > cam.adcMax)
    }

    @Test("AgentState is exactly 32 bytes so a GPU port can assert it")
    func agentLayout() {
        #expect(MemoryLayout<AgentState>.size == 32)
        #expect(MemoryLayout<AgentState>.stride == 32)
    }

    @Test("incremental evaluation matches the batch law")
    func incrementalMatchesBatch() {
        let W = 256, N = 32
        let arena = AgentArena(agentCount: N, window: W, slabs: 4)
        let traces: [[Int16]] = (0..<N).map { j in
            (0..<W).map { i in
                let onset = 120 + j
                let e = i < onset ? 60 : 60 + (i - onset) * 120
                return Int16(clamping: i % 2 == 0 ? e : -e)
            }
        }
        for i in 0..<W {
            var col = [Int16](repeating: 0, count: N)
            for j in 0..<N { col[j] = traces[j][i] }
            col.withUnsafeBufferPointer { arena.advance(samples: $0, tick: UInt32(i)) }
        }
        for j in 0..<N {
            let batch = FusionLaw.screen(traces[j].map { Int32($0) })
            let ord: UInt32 = { switch batch.verdict {
                case .NOMINAL: return 0; case .MITIGATE: return 1
                case .REFUSED_OUT_OF_ENVELOPE: return 2; case .REFUSED_MALFORMED: return 3 } }()
            #expect(arena.states[j].terminal == ord, "agent \(j)")
        }
    }

    // ---- added 2026-10-03: the slice, the plant and the window, each from one home ----

    @Test("the D-slice is one integer: 22,132,500 mm^2, the cell 49,920 mm^2, no pi")
    func densitySlice() {
        #expect(DensitySlice.vertices.count == 16)
        #expect(DensitySlice.twiceArea == 44_265_000)
        #expect(DensitySlice.areaMm2 == 22_132_500)
        #expect(DensitySlice.cellDeterminant == 49_920)
        var s: Int64 = 0
        for i in 0..<16 { s += DensitySlice.edgeDeterminant(i) }
        #expect(s == DensitySlice.twiceArea)              // counter-clockwise: the sum is positive
        // the circle it replaces moves 334 mm^2 across the pi bracket
        let lo = DensitySlice.circleAreaFloorMm2(radiusMm: 2000, piNum: 333, piDen: 106)
        let hi = DensitySlice.circleAreaFloorMm2(radiusMm: 2000, piNum: 355, piDen: 113)
        #expect(lo == 12_566_037)
        #expect(hi == 12_566_371)
        #expect(hi! - lo! == 334)
        // CONTROL: no radius, no area
        #expect(DensitySlice.circleAreaFloorMm2(radiusMm: 0, piNum: 355, piDen: 113) == nil)
    }

    @Test("the synthetic plant has one census: 54,272 / 8,192 / 2,048 / 1,024 at 65,536 agents")
    func plantCensus() {
        func census(_ n: Int, ticks: UInt64) -> (Int, Int, Int, Int) {
            let arena = AgentArena(agentCount: n, window: 256, slabs: 12)
            var buf = [Int16](repeating: 0, count: n)
            var t: UInt64 = 0
            while t < ticks {
                buf.withUnsafeMutableBufferPointer { SyntheticPlant.fill($0, tick: t) }
                buf.withUnsafeBufferPointer { arena.advance(samples: $0, tick: UInt32(t)) }
                t += 1
            }
            let c = arena.census()
            return (c.nominal, c.mitigate, c.refusedEnv, c.refusedMal)
        }
        let big = census(65_536, ticks: 64)
        #expect(big == (54_272, 8_192, 2_048, 1_024))
        // CONTROL: a different size gives a different, predicted census
        let small = census(4_096, ticks: 64)
        #expect(small == (3_392, 512, 128, 64))
        // the bulk face and the per-agent face are one generator
        var one = [Int16](repeating: 0, count: 64)
        one.withUnsafeMutableBufferPointer { SyntheticPlant.fill($0, tick: 9) }
        for i in 0..<64 { #expect(one[i] == SyntheticPlant.sample(agent: i, tick: 9)) }
    }

    @Test("the window copy into a caller's buffer equals the allocating copy, and refuses a wrong size")
    func windowInto() {
        let arena = AgentArena(agentCount: 16, window: 256, slabs: 4)
        var buf = [Int16](repeating: 0, count: 16)
        for t in 0..<300 {
            buf.withUnsafeMutableBufferPointer { SyntheticPlant.fill($0, tick: UInt64(t)) }
            buf.withUnsafeBufferPointer { arena.advance(samples: $0, tick: UInt32(t)) }
        }
        let a = arena.windowSnapshot(agent: 5)
        var b = [Int16](repeating: 0, count: 256)
        let wrote = b.withUnsafeMutableBufferPointer { arena.windowSnapshot(agent: 5, into: $0) }
        #expect(wrote)
        #expect(a == b)
        #expect(a.last == SyntheticPlant.sample(agent: 5, tick: 299))   // newest last
        // CONTROL: a buffer of another size, or an agent outside the arena, is refused
        var short = [Int16](repeating: 0, count: 255)
        let wroteShort = short.withUnsafeMutableBufferPointer { arena.windowSnapshot(agent: 5, into: $0) }
        let wroteOutside = b.withUnsafeMutableBufferPointer { arena.windowSnapshot(agent: 16, into: $0) }
        #expect(!wroteShort)
        #expect(!wroteOutside)
    }
}
