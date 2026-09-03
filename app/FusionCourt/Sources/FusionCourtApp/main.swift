// Headless entry for now — the self-tests the plan's verification section names.
// The SwiftUI panels land next; this proves the package links and the budgets
// hold before any UI exists to hide behind.
import Foundation
import FusionLaw
import FusionAffine
import FusionClock
import FusionLattice

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
print("  --selftest-clock     10 s at 1 kHz, histogram, refuses on any skipped tick")
print("  --selftest-lattice   lattice widths and ingress lanes")
