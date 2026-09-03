// The four terminals. ABSENT, REFUSED and MISS are different answers and are
// never collapsed into each other.

public enum Verdict: String, Sendable, Equatable {
    case NOMINAL
    case MITIGATE
    case REFUSED_OUT_OF_ENVELOPE
    case REFUSED_MALFORMED
}

/// What one evaluation returns. Both auxiliaries are carried — the three forked
/// copies this replaces each dropped a different one.
public struct ScreenResult: Sendable, Equatable {
    public let verdict: Verdict
    public let firstTrip: Int      // index of the first tripping window, -1 if none
    public let peakGrowth: Int     // largest growth seen across the scan
    public let atIndex: Int        // where a refusal occurred, -1 if none

    public init(verdict: Verdict, firstTrip: Int, peakGrowth: Int, atIndex: Int) {
        self.verdict = verdict
        self.firstTrip = firstTrip
        self.peakGrowth = peakGrowth
        self.atIndex = atIndex
    }
}
