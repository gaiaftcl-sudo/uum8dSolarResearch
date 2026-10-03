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
//
// ONE LOOP OR NONE (2026-10-03). `step` has one owner: whatever it touches (an
// arena, a scratch buffer) is written by the control thread alone. Until this
// date stop() only cleared a flag, so a stop() followed within a period by
// start() left the old loop alive — it woke from mach_wait_until, read
// running == true, and kept calling `step` beside the new one: two writers on
// state with one owner. Now stop() RETURNS ONLY AFTER the loop has returned, and
// start() REFUSES while a loop is alive. A caller may rebuild what `step` touches
// the moment stop() comes back.
//
// THE COUNTERS ARE LIFETIME COUNTERS. The tick number carries across a restart
// (a restarted loop continues from completedTicks), so completedTicks,
// skippedTicks, gaps and the histogram all describe the same lifetime.
import Darwin
import Foundation

public final class FixedStepDriver: @unchecked Sendable {

    public struct Config: Sendable {
        public var periodNanos: UInt64
        public var computeBudgetNanos: UInt64
        public init(periodNanos: UInt64 = 1_000_000,
                    computeBudgetNanos: UInt64 = 400_000) {
            self.periodNanos = periodNanos
            self.computeBudgetNanos = computeBudgetNanos
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
    private let lock = NSLock()
    // ---- everything below is read and written under `lock` ----
    private var thread: Thread?
    private var loopExit: DispatchSemaphore?   // non-nil exactly while a loop is alive
    private var running = false
    private var _hist = LatencyHistogram()
    private var _skipped: UInt64 = 0
    private var _gaps: [Gap] = []
    private var _ticks: UInt64 = 0
    private var _granted = false

    public init(config: Config = Config(),
                step: @escaping @Sendable (UInt64, MachTicks) -> Void) {
        self.config = config
        self.step = step
    }

    /// Starts the control thread. Returns false, and starts nothing, while a loop
    /// is alive — including one that stop() has been asked to end on another
    /// thread and that has not yet returned.
    @discardableResult
    public func start() -> Bool {
        lock.lock()
        if loopExit != nil { lock.unlock(); return false }
        let done = DispatchSemaphore(value: 0)
        loopExit = done
        running = true
        let firstTick = _ticks
        let t = Thread { [weak self] in
            if let self {
                self.loop(from: firstTick)
                self.lock.lock(); self.loopExit = nil; self.thread = nil; self.lock.unlock()
            }
            done.signal()                       // the loop has RETURNED
        }
        t.name = "affine.fusion.control"
        t.qualityOfService = .userInteractive
        t.stackSize = 512 * 1024
        thread = t
        lock.unlock()
        t.start()
        return true
    }

    /// Ends the loop and returns only after loop() has returned, so nothing calls
    /// `step` once this comes back. Called from inside `step` — on the control
    /// thread itself — it only clears the flag: a thread cannot wait for its own
    /// exit, and the loop ends when that step returns.
    public func stop() {
        lock.lock()
        running = false
        let done = loopExit
        let onControlThread = thread.map { Thread.current === $0 } ?? false
        lock.unlock()
        guard let done, !onControlThread else { return }
        done.wait()
        done.signal()      // hand the wake on to any other caller waiting on this loop
    }

    /// True while a control loop is alive (between a successful start() and the
    /// moment its loop returns).
    public var loopAlive: Bool { lock.lock(); defer { lock.unlock() }; return loopExit != nil }

    public func snapshotHistogram() -> LatencyHistogram { lock.lock(); defer { lock.unlock() }; return _hist }
    /// Every period whose step never ran, over the driver's lifetime.
    public var skippedTicks: UInt64 { lock.lock(); defer { lock.unlock() }; return _skipped }
    /// The first 256 missed deadlines, over the driver's lifetime.
    public var gaps: [Gap] { lock.lock(); defer { lock.unlock() }; return _gaps }
    /// Steps completed over the driver's lifetime; also the next tick number.
    public var completedTicks: UInt64 { lock.lock(); defer { lock.unlock() }; return _ticks }
    /// Whether the kernel granted THREAD_TIME_CONSTRAINT_POLICY to the CONTROL
    /// thread, as the control thread itself was told. False until a loop has asked.
    public var timeConstraintGranted: Bool { lock.lock(); defer { lock.unlock() }; return _granted }

    /// Ask the kernel for a real-time band FOR THE CALLING THREAD. Private since
    /// 2026-10-03: only the control loop calls it, on itself. The app used to call
    /// it from the main thread as well, which placed the UI thread under a 1 ms /
    /// 400 us policy. Reported honestly: if this is refused or later demoted, the
    /// achieved cadence is what the histogram says, not what the config asked for.
    private func requestTimeConstraint() -> Bool {
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

    private func loop(from firstTick: UInt64) {
        let granted = requestTimeConstraint()
        lock.lock(); _granted = granted; lock.unlock()
        let periodTicks = ControlClock.ticks(nanoseconds: config.periodNanos)
        // ABSOLUTE deadline, accumulated with &+=. Never `now() + period` —
        // that form folds each tick's execution time into the schedule and
        // drifts monotonically.
        var deadline = ControlClock.now().raw &+ periodTicks
        var tick: UInt64 = firstTick

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
                // MISSED. No step is replayed and dt is never stretched — a control
                // loop that silently replays N steps or stretches dt is the
                // always-green defect wearing a clock. The deadline moves past `now`
                // one whole period at a time, and EVERY period it passes is a step
                // that never ran: each is counted in skippedTicks and the miss is
                // recorded as a gap. (Until 2026-10-03 the first 8 such periods were
                // advanced uncounted, under a comment that said "execute at most 8";
                // the code executed none and counted none.)
                let behind = ControlClock.nanoseconds(ticks: after &- deadline)
                var skipped: UInt64 = 0
                while deadline < after { deadline &+= periodTicks; skipped &+= 1 }
                lock.lock()
                _skipped &+= skipped
                if _gaps.count < 256 {
                    _gaps.append(Gap(tick: tick, behindNanos: behind, stepsSkipped: skipped))
                }
                lock.unlock()
            } else {
                mach_wait_until(deadline)
            }

            lock.lock(); _hist.record(elapsed); _ticks = tick; lock.unlock()
        }
    }
}
