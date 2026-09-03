// Integer buckets. No mean, no float. A percentile reports its bucket's UPPER
// BOUND, because a histogram cannot resolve finer than its buckets and
// interpolating with a float to pretend otherwise is the same error class as an
// approximated sine.

public struct LatencyHistogram: Sendable, Equatable {
    public static let edgesNanos: [UInt64] =
        [250, 500, 1_000, 2_000, 4_000, 8_000, 16_000, 32_000,
         64_000, 128_000, 256_000, 512_000, 1_048_576, UInt64.max]

    public private(set) var counts: [UInt64]
    public private(set) var minNanos: UInt64
    public private(set) var maxNanos: UInt64
    public private(set) var total: UInt64

    public init() {
        counts = [UInt64](repeating: 0, count: LatencyHistogram.edgesNanos.count)
        minNanos = UInt64.max; maxNanos = 0; total = 0
    }

    public mutating func record(_ ns: UInt64) {
        var i = 0
        while i < LatencyHistogram.edgesNanos.count - 1 && ns > LatencyHistogram.edgesNanos[i] { i += 1 }
        counts[i] &+= 1
        if ns < minNanos { minNanos = ns }
        if ns > maxNanos { maxNanos = ns }
        total &+= 1
    }

    /// Integer percentile. Returns the containing bucket's upper bound.
    public func percentileNanos(_ p: Int) -> UInt64 {
        if total == 0 { return 0 }
        let want = (total &* UInt64(p) &+ 99) / 100      // ceil, integer
        var seen: UInt64 = 0
        for (i, c) in counts.enumerated() {
            seen &+= c
            if seen >= want { return LatencyHistogram.edgesNanos[i] }
        }
        return maxNanos
    }
}
