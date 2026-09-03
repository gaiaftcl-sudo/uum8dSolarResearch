// An agent is a STRUCT IN A BUFFER, not an actor. 240 actors exist in the
// substrate and they are the wrong primitive for a 1 ms tick: child-task
// overhead is hundreds of nanoseconds and the scheduler is not deadline-aware.
//
// @frozen is load-bearing: it makes the layout assertable, so a future GPU
// port can static_assert the same 32 bytes on both sides and REFUSE rather
// than compute wrong numbers.

@frozen public struct AgentState: Sendable, Equatable {
    public var head: UInt32          // ring index into the window arena
    public var run: Int32            // consecutive tripping windows
    public var firstTrip: Int32       // -1 when none
    public var peakGrowth: Int32
    public var terminal: UInt32       // Verdict ordinal
    public var trippedAtTick: UInt32
    public var channel: UInt32
    public var flags: UInt32          // bit0 latched, bit1 gap-seen

    public init(channel: UInt32) {
        head = 0; run = 0; firstTrip = -1; peakGrowth = 0
        terminal = 0; trippedAtTick = 0; self.channel = channel; flags = 0
    }
}
