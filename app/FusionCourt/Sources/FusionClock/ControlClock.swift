// The clock. Integer ticks, integer nanoseconds, no float anywhere.
import Darwin

public struct MachTicks: Sendable, Comparable, Hashable {
    public let raw: UInt64
    @inlinable public init(_ raw: UInt64) { self.raw = raw }
    @inlinable public static func < (a: MachTicks, b: MachTicks) -> Bool { a.raw < b.raw }
}

public enum ControlClock {
    // Read ONCE at process start. On Apple silicon this is 125/3.
    public static let numer: UInt64 = { var t = mach_timebase_info_data_t(); mach_timebase_info(&t); return UInt64(t.numer) }()
    public static let denom: UInt64 = { var t = mach_timebase_info_data_t(); mach_timebase_info(&t); return UInt64(t.denom) }()

    @inlinable public static func now() -> MachTicks { MachTicks(mach_absolute_time()) }

    /// ticks -> nanoseconds, via full-width multiply.
    ///
    /// CORRECTION, measured 2026-09-02: the plan justified this by claiming the
    /// naive `raw * numer / denom` overflows UInt64 "after a few hours of
    /// uptime". THAT WAS WRONG BY SIX ORDERS OF MAGNITUDE. Measured on this
    /// machine: timebase 125/3, so the tick rate is 24 MHz and the naive form
    /// overflows at UInt64.max/125 = 1.476e17 ticks -- about 195 YEARS of
    /// uptime. The naive form is safe for any real machine.
    ///
    /// The full-width form is kept anyway, because it is free, exact by
    /// construction, and independent of the timebase the OS happens to report
    /// -- a future platform with a larger numer would change the margin. But
    /// the stated reason is now the true one: correctness by construction, NOT
    /// a bug that would have bitten. An unmeasured hazard asserted as fact is
    /// the same defect this programme grades everywhere else.
    @inlinable
    public static func nanoseconds(ticks: UInt64) -> UInt64 {
        let (hi, lo) = ticks.multipliedFullWidth(by: numer)
        let (q, _) = denom.dividingFullWidth((high: hi, low: lo))
        return q
    }

    /// nanoseconds -> ticks, same discipline in the other direction.
    @inlinable
    public static func ticks(nanoseconds ns: UInt64) -> UInt64 {
        let (hi, lo) = ns.multipliedFullWidth(by: denom)
        let (q, _) = numer.dividingFullWidth((high: hi, low: lo))
        return q
    }
}
