import FusionLaw
// The fixed-timestep control driver.
//
// PRIMITIVE CHOICE, and why the alternatives were rejected:
//   CADisplayLink / CVDisplayLink — caps at the display refresh rate and stalls
//     when the window is occluded or the display sleeps. Control cadence is not
//     display cadence.
//   DispatchSourceTimer — leeway-based and deliberately coalesced by the kernel
//     for power. Jitter in the hundreds of microseconds under load.
//   A dedicated Thread at THREAD_TIME_CONSTRAINT_POLICY, waiting on an absolute
//     deadline with mach_wait_until — chosen.
import Darwin
import Foundation

public final class FixedStepDriver: @unchecked Sendable {

    public struct Config: Sendable {
        public var periodNanos: UInt64
        public var computeBudgetNanos: UInt64
        public var maxCatchUpSteps: Int
        public init(periodNanos: UInt64 = 1_000_000,
                    computeBudgetNanos: UInt64 = 400_000,
                    maxCatchUpSteps: Int = 8) {
            self.periodNanos = periodNanos
            self.computeBudgetNanos = computeBudgetNanos
            self.maxCatchUpSteps = maxCatchUpSteps
        }
    }

    /// A missed deadline, recorded rather than hidden.
    public struct Gap: Sendable, Equatable {
        public let tick: UInt64
        public let behindNanos: UInt64
        public let stepsSkipped: UInt64
    }

    private let config: Config
    private let step: @Sendable (UInt64, MachTicks) -> Void
    private var thread: Thread?
    private let lock = NSLock()
    private var _hist = LatencyHistogram()
    private var _skipped: UInt64 = 0
    private var _gaps: [Gap] = []
    private var _ticks: UInt64 = 0
    private var running = false

    public init(config: Config = Config(),
                step: @escaping @Sendable (UInt64, MachTicks) -> Void) {
        self.config = config
        self.step = step
    }

    public func start() {
        lock.lock(); running = true; lock.unlock()
        let t = Thread { [weak self] in self?.loop() }
        t.name = "affine.fusion.control"
        t.qualityOfService = .userInteractive
        t.stackSize = 512 * 1024
        thread = t
        t.start()
    }

    public func stop() { lock.lock(); running = false; lock.unlock() }

    public func snapshotHistogram() -> LatencyHistogram { lock.lock(); defer { lock.unlock() }; return _hist }
    public var skippedTicks: UInt64 { lock.lock(); defer { lock.unlock() }; return _skipped }
    public var gaps: [Gap] { lock.lock(); defer { lock.unlock() }; return _gaps }
    public var completedTicks: UInt64 { lock.lock(); defer { lock.unlock() }; return _ticks }

    /// Ask the kernel for a real-time band. Reported honestly: if this is refused
    /// or later demoted, the achieved cadence is what the histogram says, not
    /// what the config asked for.
    @discardableResult
    public func requestTimeConstraint() -> Bool {
        let periodTicks = UInt32(truncatingIfNeeded: ControlClock.ticks(nanoseconds: config.periodNanos))
        let computeTicks = UInt32(truncatingIfNeeded: ControlClock.ticks(nanoseconds: config.computeBudgetNanos))
        var policy = thread_time_constraint_policy_data_t(
            period: periodTicks, computation: computeTicks,
            constraint: periodTicks, preemptible: 0)
        let count = mach_msg_type_number_t(MemoryLayout<thread_time_constraint_policy_data_t>.size / MemoryLayout<integer_t>.size)
        let kr = withUnsafeMutablePointer(to: &policy) { p -> kern_return_t in
            p.withMemoryRebound(to: integer_t.self, capacity: Int(count)) { ip in
                thread_policy_set(pthread_mach_thread_np(pthread_self()),
                                  UInt32(THREAD_TIME_CONSTRAINT_POLICY), ip, count)
            }
        }
        return kr == KERN_SUCCESS
    }

    private func loop() {
        _ = requestTimeConstraint()
        let periodTicks = ControlClock.ticks(nanoseconds: config.periodNanos)
        // ABSOLUTE deadline, accumulated with &+=. Never `now() + period` —
        // that form folds each tick's execution time into the schedule and
        // drifts monotonically.
        var deadline = ControlClock.now().raw &+ periodTicks
        var tick: UInt64 = 0

        while true {
            lock.lock(); let go = running; lock.unlock()
            if !go { return }

            let t0 = ControlClock.now().raw
            step(tick, MachTicks(deadline))
            let t1 = ControlClock.now().raw
            let elapsed = ControlClock.nanoseconds(ticks: t1 &- t0)

            tick &+= 1
            deadline &+= periodTicks

            let after = ControlClock.now().raw
            if after > deadline {
                // MISSED. Execute at most maxCatchUpSteps, then record a GAP and
                // resynchronise. A control loop that silently replays N steps or
                // stretches dt is the always-green defect wearing a clock.
                var caught = 0
                while deadline < after && caught < config.maxCatchUpSteps {
                    deadline &+= periodTicks; caught &+= 1
                }
                if deadline < after {
                    let behind = ControlClock.nanoseconds(ticks: after &- deadline)
                    var skipped: UInt64 = 0
                    while deadline < after { deadline &+= periodTicks; skipped &+= 1 }
                    lock.lock()
                    _skipped &+= skipped
                    if _gaps.count < 256 {
                        _gaps.append(Gap(tick: tick, behindNanos: behind, stepsSkipped: skipped))
                    }
                    lock.unlock()
                }
            } else {
                mach_wait_until(deadline)
            }

            lock.lock(); _hist.record(elapsed); _ticks = tick; lock.unlock()
        }
    }
}
