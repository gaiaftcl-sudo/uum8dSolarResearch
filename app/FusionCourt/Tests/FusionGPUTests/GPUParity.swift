import Testing
@testable import FusionGPU
@testable import FusionLaw

// The load-bearing claim of the crossover study: the GPU computes the SAME
// verdict as the CPU golden, BIT-FOR-BIT, so its slowness is a speed result and
// never a correctness compromise. No tolerance — integer verdicts are equal or
// they are not.
@Suite("GPU parity") struct GPUParity {

    static func corpus() -> ([Int16], Int, Int) {
        let W = 256, N = 4096
        var w = [Int16](repeating: 0, count: N * W)
        for a in 0..<N {
            let onset = 100 + (a % 200)          // spread onsets so all terminals appear
            for i in 0..<W {
                var v: Int
                if a % 37 == 0 && i == 3 { v = 30000 }        // malformed
                else if a % 53 == 0 && i > 8 { v = 6500 }     // out of envelope
                else { let e = i < onset ? 60 : 60 + (i - onset) * 120
                       v = i % 2 == 0 ? e : -e }
                w[a*W + i] = Int16(clamping: v)
            }
        }
        return (w, W, N)
    }

    @Test("GPU verdict == CPU golden, bit-for-bit, across a mixed corpus")
    func bitExact() {
        guard let gpu = VerdictScreenGPU() else {
            // No device (CI without a GPU): the CPU path is authoritative; skip
            // rather than fail, but say so.
            print("GPU unavailable — parity test skipped, CPU is authoritative"); return
        }
        let (w, W, N) = Self.corpus()
        guard let out = gpu.screen(windows: w, windowLen: W, agentCount: N) else {
            Issue.record("GPU screen returned nil"); return
        }
        var mism = 0, terminals = Set<UInt32>()
        for a in 0..<N {
            let want = CPUGolden.terminalOrdinal(w[(a*W)..<(a*W+W)])
            terminals.insert(want)
            if out[a] != want { mism += 1 }
        }
        #expect(mism == 0, "\(mism) of \(N) agents disagreed")
        // and the corpus must actually exercise more than one terminal, or the
        // parity check proves nothing (an all-NOMINAL corpus would trivially agree).
        #expect(terminals.count >= 3, "corpus only reached \(terminals.count) terminals")
    }
}
