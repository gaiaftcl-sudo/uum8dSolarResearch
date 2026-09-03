// The driver thread is the SOLE owner of the arena and the per-tick scratch
// buffer. Swift 6 strict concurrency will not let a @Sendable closure capture
// them mutably, and it is right to refuse — so ownership is made explicit here
// instead of being asserted in a comment.
//
// @unchecked Sendable is the honest annotation: the invariant is enforced by
// construction (only the control thread ever calls tick()), not by the compiler.
// No per-tick allocation happens inside tick(); the scratch buffer is allocated
// once at init, which is what keeps the loop real-time.
import Foundation
import FusionLaw
import FusionAffine
import FusionClock

final class ControlHost: @unchecked Sendable {
    let agents: Int
    let window: Int
    private let arena: AgentArena
    private var scratch: [Int16]
    private let ring: SnapshotRing
    private var hottest: [AgentDigest]

    init(agents: Int, window: Int, slabs: Int, ring: SnapshotRing) {
        self.agents = agents; self.window = window; self.ring = ring
        self.arena = AgentArena(agentCount: agents, window: window, slabs: slabs)
        self.scratch = [Int16](repeating: 0, count: agents)
        self.hottest = []
        self.hottest.reserveCapacity(agents)     // once, never per tick
    }

    var arenaBytes: Int { arena.arenaBytes }

    func tick(_ t: UInt64) {
        // One integer sample per agent. A real deployment substitutes the
        // digitiser's own integer stream here and nothing else changes.
        let ti = Int(truncatingIfNeeded: t)
        scratch.withUnsafeMutableBufferPointer { buf in
            for i in 0..<agents {
                let noise = (((i &+ ti) &* 2246822519) >> 22) % 120 - 60
                let onset = 3000 &+ (i & 1023)
                let env = ti < onset ? 0 : (ti - onset) * 120
                buf[i] = Int16(clamping: noise &+ (ti % 2 == 0 ? env : -env))
            }
        }
        let s0 = ControlClock.now().raw
        scratch.withUnsafeBufferPointer { arena.advance(samples: $0, tick: UInt32(truncatingIfNeeded: t)) }
        let cost = ControlClock.nanoseconds(ticks: ControlClock.now().raw &- s0)

        if t % 16 == 0 {                          // publish at ~60 Hz, not per tick
            let c = arena.census()
            hottest.removeAll(keepingCapacity: true)
            for st in arena.states {
                hottest.append(AgentDigest(channel: st.channel, terminal: st.terminal,
                                           peakGrowth: st.peakGrowth))
            }
            ring.publish(ControlSnapshot(
                tick: t,
                terminals: SIMD4(UInt32(c.nominal), UInt32(c.mitigate),
                                 UInt32(c.refusedEnv), UInt32(c.refusedMal)),
                histogram: LatencyHistogram(), skippedTicks: 0, tickCostNanos: cost,
                path: .cpuGolden, agentCount: agents, hottest: hottest))
        }
    }
}
