// The control thread PUBLISHES; the UI READS. Triple-buffered so the control
// thread never blocks on the UI and never takes a lock the UI holds.
//
// THE RULE THIS ENFORCES: the UI never computes a number it displays. A panel
// that reimplements what it displays is measuring itself.
import Darwin
import FusionClock
import FusionLaw

public enum EvaluationPath: String, Sendable {
    case cpuGolden = "cpu_golden"
    case gpuScreenThenCPULaw = "gpu_screen+cpu_law"
}

public struct AgentDigest: Sendable {
    public let channel: UInt32
    public let terminal: UInt32
    public let peakGrowth: Int32
    public init(channel: UInt32, terminal: UInt32, peakGrowth: Int32) {
        self.channel = channel; self.terminal = terminal; self.peakGrowth = peakGrowth
    }
}

public struct MachineVerdict: Sendable {
    public let name: String
    public let verdict: String
    public let fGwPct: Int          // n_e as a percent of this machine's Greenwald limit
    public init(name: String, verdict: String, fGwPct: Int) {
        self.name = name; self.verdict = verdict; self.fGwPct = fGwPct
    }
}

public struct ControlSnapshot: Sendable {
    public let tick: UInt64
    public let terminals: SIMD4<UInt32>          // NOMINAL, MITIGATE, REFUSED_ENV, REFUSED_MAL
    public let histogram: LatencyHistogram
    public let skippedTicks: UInt64
    public let tickCostNanos: UInt64
    public let path: EvaluationPath
    public let agentCount: Int
    public let hottest: [AgentDigest]            // fixed capacity, no per-frame allocation
    public let scope: [Int16]                    // one selected channel's window
    public let scopeChannel: UInt32
    public let machines: [MachineVerdict]        // operating-point court on real machines

    public init(tick: UInt64, terminals: SIMD4<UInt32>, histogram: LatencyHistogram,
                skippedTicks: UInt64, tickCostNanos: UInt64, path: EvaluationPath,
                agentCount: Int, hottest: [AgentDigest],
                scope: [Int16] = [], scopeChannel: UInt32 = 0,
                machines: [MachineVerdict] = []) {
        self.tick = tick; self.terminals = terminals; self.histogram = histogram
        self.skippedTicks = skippedTicks; self.tickCostNanos = tickCostNanos
        self.path = path; self.agentCount = agentCount; self.hottest = hottest
        self.scope = scope; self.scopeChannel = scopeChannel
        self.machines = machines
    }
    public static let empty = ControlSnapshot(
        tick: 0, terminals: .zero, histogram: LatencyHistogram(), skippedTicks: 0,
        tickCostNanos: 0, path: .cpuGolden, agentCount: 0, hottest: [], scope: [], scopeChannel: 0, machines: [])
}

/// Three slots and a publish index. The writer fills the slot the reader is not
/// in; the reader takes whatever was most recently published.
public final class SnapshotRing: @unchecked Sendable {
    private var slots: [ControlSnapshot] = [.empty, .empty, .empty]
    private var published: Int32 = 0
    private var lock = os_unfair_lock_s()

    public init() {}

    public func publish(_ s: ControlSnapshot) {
        os_unfair_lock_lock(&lock)
        let next = (Int(published) + 1) % 3
        slots[next] = s
        published = Int32(next)
        os_unfair_lock_unlock(&lock)
    }
    public func read() -> ControlSnapshot {
        os_unfair_lock_lock(&lock)
        let s = slots[Int(published)]
        os_unfair_lock_unlock(&lock)
        return s
    }
}
