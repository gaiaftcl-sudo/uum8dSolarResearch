import Testing
import Foundation
@testable import FusionClock

// ONE LOOP OR NONE. `step` has one owner; a second live loop calling it is two
// writers on state with one owner. Before 2026-10-03 stop() only cleared a flag,
// so stop() then start() inside one period left the old loop alive beside the new
// one. These tests hold the fix, and the control arm proves the probe CAN see two
// loops in `step` at once — an instrument that cannot fail proves nothing.

/// Counts how many loops are inside `step` at once, and whether tick numbers ever
/// repeat or run backwards across restarts.
final class StepProbe: @unchecked Sendable {
    private let lock = NSLock()
    private var inStep = 0
    private var maxInStep = 0
    private var steps = 0
    private var lastTick: UInt64? = nil
    private var nonIncreasing = 0

    func enter(_ tick: UInt64) {
        lock.lock()
        inStep += 1
        if inStep > maxInStep { maxInStep = inStep }
        steps += 1
        if let l = lastTick, tick <= l { nonIncreasing += 1 }
        lastTick = tick
        lock.unlock()
    }
    func leave() { lock.lock(); inStep -= 1; lock.unlock() }
    var snapshot: (maxIn: Int, steps: Int, nonIncreasing: Int) {
        lock.lock(); defer { lock.unlock() }
        return (maxInStep, steps, nonIncreasing)
    }
}

/// Busy for `ns` nanoseconds on the integer clock — widens the window in which two
/// loops would overlap, so an overlap that exists is one the probe sees.
func busy(_ ns: UInt64) {
    let t0 = ControlClock.now().raw
    while ControlClock.nanoseconds(ticks: ControlClock.now().raw &- t0) < ns {}
}

/// Waits (bounded) until `cond` holds. Returns whether it did.
func waitUntil(_ limitNanos: UInt64, _ cond: () -> Bool) -> Bool {
    let t0 = ControlClock.now().raw
    while !cond() {
        if ControlClock.nanoseconds(ticks: ControlClock.now().raw &- t0) > limitNanos { return false }
        usleep(20)
    }
    return true
}

@Suite("fixed-step driver: one loop or none", .serialized) struct DriverRestart {

    @Test("1,000 stop/start cycles: at most one loop is ever inside step")
    func thousandCycles() {
        let probe = StepProbe()
        let d = FixedStepDriver { tick, _ in probe.enter(tick); busy(100_000); probe.leave() }
        var started = 0, refusedWhileAlive = 0, reachedStep = 0, aliveAfterStop = 0
        for _ in 0..<1000 {
            let before = probe.snapshot.steps
            if d.start() { started += 1 }
            if !d.start() { refusedWhileAlive += 1 }          // a live loop refuses a second
            if waitUntil(500_000_000, { probe.snapshot.steps > before }) { reachedStep += 1 }
            d.stop()                                          // returns after the loop returned
            if d.loopAlive { aliveAfterStop += 1 }
        }
        let s = probe.snapshot
        #expect(started == 1000)
        #expect(refusedWhileAlive == 1000)
        #expect(reachedStep == 1000)
        #expect(aliveAfterStop == 0)
        #expect(s.maxIn == 1)                                 // THE PROPERTY
        #expect(s.nonIncreasing == 0)                         // ticks carry across restarts
        #expect(d.completedTicks >= 1000)
    }

    @Test("CONTROL: two live loops on one probe ARE seen inside step together")
    func twoLoopsOverlap() {
        let probe = StepProbe()
        // each loop is busy 600 us of every 1,000 us, so two live loops must overlap
        let a = FixedStepDriver { tick, _ in probe.enter(tick); busy(600_000); probe.leave() }
        let b = FixedStepDriver { tick, _ in probe.enter(tick); busy(600_000); probe.leave() }
        #expect(a.start())
        #expect(b.start())
        let saw = waitUntil(2_000_000_000, { probe.snapshot.maxIn >= 2 })
        a.stop(); b.stop()
        #expect(saw)
        #expect(probe.snapshot.maxIn == 2)
    }

    @Test("a step that overruns 3.5 periods is counted: skipped >= 3 and a gap recorded")
    func overrunIsCounted() {
        // Before 2026-10-03 up to 8 overrun periods were advanced uncounted, so this
        // case read skipped = 0 and no gap — the miss was invisible.
        let d = FixedStepDriver { tick, _ in if tick == 5 { busy(3_500_000) } }
        #expect(d.start())
        let ran = waitUntil(2_000_000_000, { d.completedTicks >= 20 })
        d.stop()
        #expect(ran)
        #expect(d.skippedTicks >= 3)
        #expect(d.gaps.count >= 1)
        #expect(d.gaps.contains { $0.stepsSkipped >= 3 })
    }

    @Test("stop() from inside step does not deadlock; the loop ends when that step returns")
    func stopFromInsideStep() {
        let box = DriverBox()
        let d = FixedStepDriver { tick, _ in if tick == 3 { box.driver?.stop() } }
        box.driver = d
        #expect(d.start())
        let ended = waitUntil(2_000_000_000, { !d.loopAlive })
        #expect(ended)
        #expect(d.completedTicks == 4)          // ticks 0...3 ran, nothing after
        #expect(d.start())                      // and it can start again
        d.stop()
    }
}

final class DriverBox: @unchecked Sendable { weak var driver: FixedStepDriver? }
