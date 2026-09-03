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
import FusionOperatingPoint

final class ControlHost: @unchecked Sendable {
    let agents: Int
    let window: Int
    private let arena: AgentArena
    private var scratch: [Int16]
    private let ring: SnapshotRing
    private var hottest: [AgentDigest]
    private var latency = LatencyHistogram()

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
                let noise = Int(((i &+ ti) &* 2246822519) >> 22) % 100 - 50
                let cls = i & 63                     // 64-way channel class
                var v: Int
                if cls == 0 {
                    // ~1.5%: a sensor returning garbage outside the ADC domain
                    v = 30000
                } else if cls == 1 || cls == 2 {
                    // ~3%: a stuck-high channel PERSISTENTLY past the envelope
                    v = (ti % 2 == 0 ? 7000 : -7000) + noise      // |v| > 6000
                } else if cls < 11 {
                    // ~14%: a genuine growing mode. Each control window sees a
                    // step > the 900 trigger for >= 3 windows, so it MITIGATEs and
                    // LATCHES — bounded ~5000, well inside the ADC domain, so it is
                    // MITIGATE and never runs away into malformed.
                    let step = 1000 + (Int((i &* 2654435761) >> 20) % 400)   // > 900
                    let k = Int(ti % 16)
                    let amp = min(60 + k * step, 5000)
                    v = (ti % 2 == 0 ? amp : -amp) + noise
                } else {
                    // the rest: quiescent NOMINAL plasma
                    v = noise
                }
                buf[i] = Int16(clamping: v)
            }
        }
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
            // one representative channel for the scope panel: a growing-mode
            // channel (cls in 3..10) so the viewer sees a real precursor, read
            // from the arena's own ring in chronological order.
            // the operating-point court, live on real published machine geometries.
            // Each machine sits at its OWN operating fraction of its OWN Greenwald
            // limit; a shared integer triangle drift moves them together across the
            // 0.85 line. Because their bases differ they cross at DIFFERENT phases —
            // so a single frame shows some WIN and some MISS, real discrimination,
            // never a synchronized all-green / all-red. W7-X carries no current and
            // never enters the density court at all: NOT_APPLICABLE, permanently.
            //  (ip in A, minor radius a in mm, base = % of that machine's own n_GW)
            let machines: [(String, Int64, Int64, Int64)] = [
                ("ITER",   15_000_000, 2000, 74), ("SPARC", 8_700_000, 570, 82),
                ("JET",     4_800_000, 1250, 88), ("DIII-D", 2_000_000, 670, 96),
                ("W7-X",            0,  530,  0),
            ]
            // integer triangle drift in [-14, +14], period ~10 s at 1 kHz
            let phase = Int(t / 360) % 56
            let drift = (phase <= 28 ? phase : 56 - phase) - 14
            var mverdicts: [MachineVerdict] = []
            for (nm, ip, a, base) in machines {
                let frac = Int(base) + drift
                let ng: Int64 = ip == 0 ? 0 : Int64(Int128(ip) * 113 * 1_000_000 / (Int128(355) * Int128(a) * Int128(a)))
                let ne = ip == 0 ? 5_000_000 : ng * Int64(frac) / 100
                let v = FusionOperatingPointLaw.grade(OperatingEnvelope(
                    ne14: ne, ipAmp: ip, minorRadiusMm: a, betaNMilli: 1800, qMinMilli: 3000))
                mverdicts.append(MachineVerdict(name: nm, verdict: v.verdict,
                                                fGwPct: ip == 0 ? 0 : frac))
            }
            let scopeCh = 5
            let scopeWin = arena.windowSnapshot(agent: scopeCh)
            ring.publish(ControlSnapshot(
                tick: t,
                terminals: SIMD4(UInt32(c.nominal), UInt32(c.mitigate),
                                 UInt32(c.refusedEnv), UInt32(c.refusedMal)),
                histogram: latency, skippedTicks: 0, tickCostNanos: cost,
                path: .cpuGolden, agentCount: agents, hottest: hottest,
                scope: scopeWin, scopeChannel: UInt32(scopeCh), machines: mverdicts))
        }
    }
}
