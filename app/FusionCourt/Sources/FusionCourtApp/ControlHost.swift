// The driver thread is the SOLE owner of the arena and the per-tick scratch
// buffer. Swift 6 strict concurrency will not let a @Sendable closure capture
// them mutably, and it is right to refuse — so ownership is made explicit here
// instead of being asserted in a comment.
//
// @unchecked Sendable is the honest annotation: the invariant is enforced by
// construction (only the control thread ever calls tick()), not by the compiler.
// No per-tick allocation happens inside the sample-and-advance path; the scratch
// buffer is allocated once at init, which is what keeps the loop real-time.
//
// ONE HOME FOR EVERY NUMBER (2026-10-03): the samples come from SyntheticPlant,
// the five machines and the drift from FusionMachines, n_G from
// FusionOperatingPointLaw.greenwaldDensityFloor, and the skipped-tick count from
// the driver itself. Until then this file carried its own copy of each, including
// an inline n_G with pi hard-coded and a skipped count that was the literal 0.
import Foundation
import FusionLaw
import FusionAffine
import FusionClock
import FusionOperatingPoint

final class ControlHost: @unchecked Sendable {
    let agents: Int
    let window: Int
    private let arena: AgentArena
    private var scratch: [Int16]
    private let ring: SnapshotRing
    private var hottest: [AgentDigest]
    private var latency = LatencyHistogram()

    /// The driver whose cadence this host publishes. Set once, before start().
    /// Weak: the driver's step closure already holds this host.
    weak var driver: FixedStepDriver?

    init(agents: Int, window: Int, slabs: Int, ring: SnapshotRing) {
        self.agents = agents; self.window = window; self.ring = ring
        self.arena = AgentArena(agentCount: agents, window: window, slabs: slabs)
        self.scratch = [Int16](repeating: 0, count: agents)
        self.hottest = []
        self.hottest.reserveCapacity(agents)     // once, never per tick
    }

    var arenaBytes: Int { arena.arenaBytes }

    func tick(_ t: UInt64) {
        // One integer sample per agent from the synthetic plant. A real deployment
        // substitutes the digitiser's own integer stream here and nothing else changes.
        scratch.withUnsafeMutableBufferPointer { SyntheticPlant.fill($0, tick: t) }
        let s0 = ControlClock.now().raw
        scratch.withUnsafeBufferPointer { arena.advance(samples: $0, tick: UInt32(truncatingIfNeeded: t)) }
        let cost = ControlClock.nanoseconds(ticks: ControlClock.now().raw &- s0)
        latency.record(cost)

        if t % 16 == 0 {                          // publish at ~60 Hz, not per tick
            let c = arena.census()
            hottest.removeAll(keepingCapacity: true)
            for st in arena.states {
                hottest.append(AgentDigest(channel: st.channel, terminal: st.terminal,
                                           peakGrowth: st.peakGrowth))
            }
            // the operating-point court, live on real published machine geometries.
            // Each machine sits at its OWN operating fraction of its OWN Greenwald
            // limit; a shared integer triangle drift moves them together across the
            // 0.85 line. Because their bases differ they cross at DIFFERENT phases —
            // so a single frame shows some WIN and some MISS, real discrimination,
            // never a synchronized all-green / all-red. W7-X carries no current and
            // never enters the density court at all: NOT_APPLICABLE, permanently.
            // The bases and the drift are SYNTHETIC inputs (see Machines.swift).
            var mverdicts: [MachineVerdict] = []
            for m in FusionMachines.all {
                if let p = FusionMachines.operatingPoint(m, tick: t) {
                    let v = FusionOperatingPointLaw.grade(p.envelope)
                    mverdicts.append(MachineVerdict(name: m.name, verdict: v.verdict,
                                                    fGwPct: Int(p.percent)))
                } else {
                    // a point that cannot be formed exactly is refused, never guessed
                    mverdicts.append(MachineVerdict(name: m.name, verdict: "REFUSED_NONPHYSICAL",
                                                    fGwPct: 0))
                }
            }
            // one representative channel for the scope panel: a growing-mode
            // channel (cls in 3..10) so the viewer sees a real precursor, read
            // from the arena's own ring in chronological order.
            let scopeCh = 5
            let scopeWin = arena.windowSnapshot(agent: scopeCh)
            // The driver's own count of periods whose step never ran. With no
            // driver attached the cadence is unknown, and unknown is published as
            // MISSED (UInt64.max), never as held.
            let skipped = driver?.skippedTicks ?? UInt64.max
            ring.publish(ControlSnapshot(
                tick: t,
                terminals: SIMD4(UInt32(c.nominal), UInt32(c.mitigate),
                                 UInt32(c.refusedEnv), UInt32(c.refusedMal)),
                histogram: latency, skippedTicks: skipped, tickCostNanos: cost,
                path: .cpuGolden, agentCount: agents, hottest: hottest,
                scope: scopeWin, scopeChannel: UInt32(scopeCh), machines: mverdicts))
        }
    }
}
