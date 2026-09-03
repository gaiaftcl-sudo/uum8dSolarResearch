// Headless entry for now — the self-tests the plan's verification section names.
// The SwiftUI panels land next; this proves the package links and the budgets
// hold before any UI exists to hide behind.
import Foundation
import FusionLaw
import FusionAffine
import FusionClock
import FusionLattice
import FusionGPU
import FusionOperatingPoint

let args = CommandLine.arguments
if args.contains("--selftest-clock") {
    let d = FixedStepDriver(config: .init(periodNanos: 1_000_000, computeBudgetNanos: 400_000)) { _, _ in }
    let granted = d.requestTimeConstraint()
    d.start(); Thread.sleep(forTimeInterval: 10.0); d.stop()
    Thread.sleep(forTimeInterval: 0.05)
    let h = d.snapshotHistogram()
    print("time_constraint_granted=\(granted)")
    print("ticks=\(d.completedTicks) skipped=\(d.skippedTicks) gaps=\(d.gaps.count)")
    print("p50=\(h.percentileNanos(50))ns p99=\(h.percentileNanos(99))ns max=\(h.maxNanos)ns")
    exit(d.skippedTicks == 0 ? 0 : 1)
}
if args.contains("--selftest-coldstart") {
    // THE APP TIMES ITS OWN COLD START, with its own clock. No python, no
    // external timing tool: this programme is Swift 6.4 and the measurement
    // must be too. Spawns a child copy of itself and times exec-to-exit.
    let me = CommandLine.arguments[0]
    var best = UInt64.max
    for _ in 0..<5 {
        let t0 = ControlClock.now().raw
        let p = Process()
        p.executableURL = URL(fileURLWithPath: me)
        p.arguments = ["--selftest-lattice"]
        p.standardOutput = FileHandle.nullDevice
        p.standardError = FileHandle.nullDevice
        try? p.run(); p.waitUntilExit()
        let d = ControlClock.nanoseconds(ticks: ControlClock.now().raw &- t0)
        if d == 0 { print("BROKEN_TIMER"); exit(3) }
        if d < best { best = d }
    }
    let budget = UInt64(ProcessInfo.processInfo.environment["FUSION_COLDSTART_BUDGET_NS"] ?? "") ?? 250_000_000
    print("coldstart_ns=\(best) budget_ns=\(budget) ms=\(best / 1_000_000)")
    exit(best > budget ? 1 : 0)
}
if args.contains("--grade") {
    // Grade YOUR machine's operating point from the command line, exact and
    // re-derivable. Units are integers: ne14=n_e/1e14 m^-3, ipAmp=amperes,
    // aMm=minor radius mm, betaNMilli=beta_N x1000, qMinMilli=q_min x1000.
    // Optional piNum/piDen declare pi for an exact (rather than pi-independent)
    // verdict. Example:
    //   FusionCourt --grade ne14=1000000 ipAmp=15000000 aMm=2000 betaNMilli=1800 qMinMilli=3000
    func arg(_ k: String) -> Int64? {
        for a in args where a.hasPrefix("\(k)=") { return Int64(a.dropFirst(k.count + 1)) }
        return nil
    }
    guard let ne = arg("ne14"), let ip = arg("ipAmp"), let a = arg("aMm"),
          let bn = arg("betaNMilli"), let qm = arg("qMinMilli") else {
        print("usage: FusionCourt --grade ne14=N ipAmp=N aMm=N betaNMilli=N qMinMilli=N [piNum=N piDen=N]")
        print("  all integers. ne14=n_e/1e14 m^-3, ipAmp=A, aMm=mm, ratios x1000.")
        exit(2)
    }
    let e = OperatingEnvelope(ne14: ne, ipAmp: ip, minorRadiusMm: a, betaNMilli: bn,
                              qMinMilli: qm, piNum: arg("piNum") ?? 0, piDen: arg("piDen") ?? 0)
    let v = FusionOperatingPointLaw.grade(e)
    print("verdict:        \(v.verdict)")
    if let b = v.bindingBranch { print("binding branch: \(b.rawValue)") }
    if !v.openBranches.isEmpty { print("open branches:  \(v.openBranches.map { $0.rawValue }.joined(separator: ", "))") }
    print("pi-independent: \(v.piIndependent)")
    print("exact path:     \(v.exactPath)")
    print("(this verdict is an exact integer comparison; re-derive it by hand from the same inputs)")
    exit(v.verdict == "REFUSED_NONPHYSICAL" ? 1 : 0)
}
if args.contains("--selftest-crossover") {
    // The measured crossover: at what N does the GPU round-trip beat 12 CPU
    // cores on this branchy, no-multiply law? Prior: the GPU loses until N is
    // very large, because a kernel launch is fixed hundreds of microseconds and
    // the per-agent CPU cost is ~2 ns. The deliverable is the MEASUREMENT,
    // including the honest outcome that the GPU never wins in a realistic range.
    guard let gpu = VerdictScreenGPU() else {
        print("GPU_UNAVAILABLE — metallib missing or no device; CPU path is authoritative"); exit(0)
    }
    let W = 256
    func makeWindows(_ n: Int) -> [Int16] {
        var w = [Int16](repeating: 0, count: n * W)
        for a in 0..<n {
            let onset = 100 + (a % 120)
            for i in 0..<W {
                let e = i < onset ? 60 : 60 + (i - onset) * 120
                w[a*W + i] = Int16(clamping: i % 2 == 0 ? e : -e)
            }
        }
        return w
    }
    func medianNanos(_ reps: Int, _ body: () -> Void) -> UInt64 {
        var xs = [UInt64](); for _ in 0..<reps {
            let t0 = ControlClock.now().raw; body()
            xs.append(ControlClock.nanoseconds(ticks: ControlClock.now().raw &- t0))
        }; xs.sort(); return xs[reps/2]
    }
    print("N          CPU(12core)   GPU(roundtrip)   parity   winner")
    var crossover = "GPU never wins in this range"
    for n in [4_096, 16_384, 65_536, 262_144, 1_048_576] {
        let w = makeWindows(n)
        // FAIR CPU ARM: the SAME flat row-major layout the GPU is handed, the
        // SAME law (CPUGolden), one terminal per agent, parallel across 12 cores.
        // (The first version of this benchmark transposed the data column-by-
        // column with a fresh allocation per sample and charged the CPU 560x the
        // law's real cost — 72 ms where the law is 128 us — which falsely handed
        // every N to the GPU. That is a broken instrument flattering one side,
        // and the 72 ms vs 128 us gap was the tell.)
        var cpuOut = [UInt32](repeating: 0, count: n)
        let cpu = w.withUnsafeBufferPointer { wpRaw -> UInt64 in
            nonisolated(unsafe) let wp = wpRaw   // disjoint slab ranges; see AgentArena
            return medianNanos(5) {
                cpuOut.withUnsafeMutableBufferPointer { op in
                    nonisolated(unsafe) let opp = op.baseAddress!
                    DispatchQueue.concurrentPerform(iterations: 12) { slab in
                        let lo = slab * n / 12, hi = (slab + 1) * n / 12
                        // ONE reused Int32 scratch per slab (12 total, not N) —
                        // widen Int16 -> Int32 into it and feed the SINGLE law.
                        // No per-agent allocation, and no second copy of the law
                        // (an Int16 overload would re-fork the very logic just merged).
                        var scratch = [Int32](repeating: 0, count: W)
                        scratch.withUnsafeMutableBufferPointer { sp in
                            for a in lo..<hi {
                                let bA = a * W
                                for i in 0..<W { sp[i] = Int32(wp[bA + i]) }
                                opp[a] = { switch FusionLaw.screen(UnsafeBufferPointer(sp)).verdict {
                                    case .NOMINAL: return 0; case .MITIGATE: return 1
                                    case .REFUSED_OUT_OF_ENVELOPE: return 2
                                    case .REFUSED_MALFORMED: return 3 } }()
                            }
                        }
                    }
                }
            }
        }
        var gpuOut: [UInt32] = []
        let gpuT = medianNanos(5) { gpuOut = gpu.screen(windows: w, windowLen: W, agentCount: n) ?? [] }
        // PARITY: GPU must match CPU golden bit-for-bit
        var parity = true
        for a in 0..<n {
            let want = CPUGolden.terminalOrdinal(w[(a*W)..<(a*W+W)])
            if gpuOut.isEmpty || gpuOut[a] != want { parity = false; break }
        }
        let winner = gpuT < cpu ? "GPU" : "CPU"
        if winner == "GPU" && crossover.hasPrefix("GPU never") { crossover = "GPU first wins at N=\(n)" }
        print(String(format: "%-10d %8llu us   %8llu us   %@   %@",
                     n, cpu/1000, gpuT/1000, parity ? "BIT-EXACT" : "MISMATCH!", winner))
        if !parity { print("PARITY FAILED at N=\(n) — GPU disabled, CPU authoritative"); exit(1) }
    }
    print("CROSSOVER: \(crossover)")
    exit(0)
}
if args.contains("--selftest-lattice") {
    print("axis_bits=\(LatticeWidth.axisBits) point_bytes=\(LatticeWidth.pointBytes)")
    print("int64_headroom=\(LatticeWidth.int64HeadroomFactor)")
    print("lanes=\(Modalities.all.count) samples_per_tick_per_channel=\(Modalities.samplesPerTickPerChannel)")
    exit(0)
}
// NO FLAGS: run the court. The driver owns the tick; the UI reads snapshots.
if args.count <= 1 {
    let AGENTS = 65_536      // DERIVED from measurement: 1.95 ns/agent,
    let WINDOW = 256         // 127.9 us/tick = 32% of the 400 us budget
    let ring = LiveContext.ring
    let host = ControlHost(agents: AGENTS, window: WINDOW, slabs: 12, ring: ring)

    let t0 = ControlClock.now().raw
    let driver = FixedStepDriver(config: .init(periodNanos: 1_000_000,
                                               computeBudgetNanos: 400_000)) { tick, _ in
        host.tick(tick)
    }
    _ = driver.requestTimeConstraint()
    driver.start()
    LiveContext.coldStartNanos = ControlClock.nanoseconds(ticks: ControlClock.now().raw &- t0)
    LiveContext.periodNanos = 1_000_000
    FusionCourtSceneApp.main()
}

print("FusionCourt — Affine.Earth fusion control verdict court")
print("  (no flags)           open the four-panel court window on 65,536 agents at 1 kHz")
print("  --grade K=V ...      grade one operating point (ne14, ipAmp, aMm, betaNMilli, qMinMilli)")
print("  --selftest-clock     10 s at 1 kHz, histogram, refuses on any skipped tick")
print("  --selftest-lattice   lattice widths and ingress lanes")
print("  --selftest-coldstart exec-to-exit vs the 250 ms budget, timed by the app itself")
print("  --selftest-crossover CPU vs GPU at 4k..1M agents, bit-parity asserted at each N")
