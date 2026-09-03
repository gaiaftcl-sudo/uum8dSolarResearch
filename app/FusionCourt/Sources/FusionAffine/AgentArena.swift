import FusionLaw
// The arena. One flat Int16 window buffer for every agent — a 14-bit sample
// fits in Int16, halving bandwidth against Int32.
//
// PARALLELISM: DispatchQueue.concurrentPerform over FIXED contiguous slabs.
// Slab boundaries never move and are never work-stolen, and cross-slab
// reductions run in fixed index order. Parallel but ORDER-FIXED is what makes
// a parallel result reproducible, and reproducibility is the product.
import Dispatch

public final class AgentArena: @unchecked Sendable {
    public let agentCount: Int
    public let window: Int
    public let slabs: Int

    public private(set) var states: [AgentState]
    private var ring: [Int16]

    public init(agentCount: Int, window: Int = 256, slabs: Int = 12) {
        precondition(window > 0 && (window & (window - 1)) == 0, "window must be a power of two so head & (window-1) replaces a modulo")
        self.agentCount = agentCount
        self.window = window
        self.slabs = slabs
        self.states = (0..<agentCount).map { AgentState(channel: UInt32($0)) }
        self.ring = [Int16](repeating: 0, count: agentCount * window)
    }

    public var arenaBytes: Int { ring.count * 2 + states.count * 32 }

    /// Push one sample per agent and advance the incremental law. O(1) per agent:
    /// the law's state (run, firstTrip, peakGrowth) CARRIES, so nothing rescans.
    public func advance(samples: UnsafeBufferPointer<Int16>, tick: UInt32) {
        precondition(samples.count == agentCount)
        let W = window
        let mask = UInt32(W - 1)
        let n = agentCount
        let per = (n + slabs - 1) / slabs

        states.withUnsafeMutableBufferPointer { st in
            ring.withUnsafeMutableBufferPointer { rg in
                let stBase = st.baseAddress!
                let rgBase = rg.baseAddress!
                DispatchQueue.concurrentPerform(iterations: slabs) { slab in
                    let lo = slab * per
                    let hi = min(lo + per, n)
                    var i = lo
                    while i < hi {
                        let base = i * W
                        var a = stBase[i]
                        let s = samples[i]
                        rgBase[base + Int(a.head & mask)] = s
                        let lagIdx = Int((a.head &+ UInt32(W) &- UInt32(LawConstants.growthWindow)) & mask)
                        let cur = Int(s)
                        let lag = Int(rgBase[base + lagIdx])
                        let ca = cur < 0 ? -cur : cur
                        let la = lag < 0 ? -lag : lag
                        // PRECEDENCE, and the incremental test caught this being
                        // wrong: the batch law scans the WHOLE window for
                        // malformed values BEFORE any growth or envelope logic.
                        // An incremental evaluator cannot pre-scan samples it has
                        // not seen — so instead MALFORMED takes priority and may
                        // OVERRIDE an already-latched envelope refusal. That is
                        // semantically right: "not admissible data" dominates
                        // "admissible data that left the envelope", and it is what
                        // makes incremental converge to batch once the window has
                        // streamed through. Checking envelope first made 64 of 64
                        // agents disagree with the batch law.
                        if cur < LawConstants.adcMin || cur > LawConstants.adcMax {
                            a.terminal = 3                              // REFUSED_MALFORMED — overrides
                            a.flags |= 1
                        } else if ca > LawConstants.envelopeAbs {
                            if a.terminal != 3 {                        // never downgrade from malformed
                                a.terminal = 2                          // REFUSED_OUT_OF_ENVELOPE
                                a.flags |= 1
                            }
                        } else {
                            let g = ca - la
                            if g > Int(a.peakGrowth) { a.peakGrowth = Int32(g) }
                            if g >= LawConstants.growthTrigger {
                                a.run &+= 1
                                if a.firstTrip < 0 { a.firstTrip = Int32(a.head) }
                                if Int(a.run) >= LawConstants.persist && a.terminal == 0 {
                                    a.terminal = 1                      // MITIGATE
                                    a.trippedAtTick = tick
                                    a.flags |= 1
                                }
                            } else {
                                a.run = 0; a.firstTrip = -1
                            }
                        }
                        a.head &+= 1
                        stBase[i] = a
                        i += 1
                    }
                }
            }
        }
    }

    /// Terminal census, in FIXED index order.
    public func census() -> (nominal: Int, mitigate: Int, refusedEnv: Int, refusedMal: Int) {
        var c = (0, 0, 0, 0)
        for s in states {
            switch s.terminal {
            case 1: c.1 += 1
            case 2: c.2 += 1
            case 3: c.3 += 1
            default: c.0 += 1
            }
        }
        return c
    }
}
