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
}
