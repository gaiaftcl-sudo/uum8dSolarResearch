// The reactor operating point, on the wire, in EXACT INTEGER units only.
// The court's ingest refuses any float-shaped token, so there is no "6.2" and
// no "1e20" anywhere near this type — lengths in mm, currents in A, densities
// in 1e14 m^-3, ratios x1000. `IntegerToken.parse` below IS that ingest.
//
// MAC-ONLY app (founder, 2026-09-03: "this is a mac only fusion app, not the
// build for the affine.earth cells"). Kept Foundation-free anyway — a verdict
// law that needs a runtime is not a law — but this does NOT ship to the cells
// and carries no Linux-portability burden.
//
// Nothing in this file touches Int128, so it carries no availability mark and
// compiles on every macOS the consumers support.

public struct OperatingEnvelope: Sendable, Equatable {
    public let ne14: Int64          // electron density / 1e14 m^-3
    public let ipAmp: Int64         // plasma current, amperes  (0 = a currentless machine)
    public let minorRadiusMm: Int64 // a, millimetres
    public let betaNMilli: Int64    // beta_N x 1000
    public let qMinMilli: Int64     // q_min x 1000
    public let piNum: Int64         // caller-declared pi, or 0 to use the bracket
    public let piDen: Int64

    public init(ne14: Int64, ipAmp: Int64, minorRadiusMm: Int64,
                betaNMilli: Int64, qMinMilli: Int64,
                piNum: Int64 = 0, piDen: Int64 = 0) {
        self.ne14 = ne14; self.ipAmp = ipAmp; self.minorRadiusMm = minorRadiusMm
        self.betaNMilli = betaNMilli; self.qMinMilli = qMinMilli
        self.piNum = piNum; self.piDen = piDen
    }

    /// True only when BOTH halves of the declared pi are positive. Anything else —
    /// including HALF a declaration, one of the pair zero or negative — is not a
    /// declaration: the court grades at the bracket. A caller that shows the verdict
    /// of a half-declared pi must say "pi not declared: bracket used", because the
    /// court did not grade at the pi the visitor typed.
    public var declaresPi: Bool { piNum > 0 && piDen > 0 }
}

public enum Branch: String, Sendable { case greenwald, troyon, qMin }

public struct CourtVerdict: Sendable, Equatable {
    public let verdict: String            // WIN | MISS | NOT_MEASURED_PI_BRACKET
                                          // | NOT_APPLICABLE_NO_PLASMA_CURRENT | REFUSED_NONPHYSICAL
    public let bindingBranch: Branch?     // the FIRST branch that failed, in declared order
    public let openBranches: [Branch]     // branches that could not be graded (e.g. no current)
    public let piIndependent: Bool        // true when the verdict holds at both pi bounds
    public let exactPath: String          // "int128"
    public init(verdict: String, bindingBranch: Branch?, openBranches: [Branch],
                piIndependent: Bool, exactPath: String) {
        self.verdict = verdict; self.bindingBranch = bindingBranch
        self.openBranches = openBranches; self.piIndependent = piIndependent
        self.exactPath = exactPath
    }
}

/// The court's input grammar for ONE integer, the only one there is: an optional
/// leading '-' and then one or more ASCII digits, whose value fits Int64.
/// Anything else is not an integer and is REFUSED (nil) — "6.2", "1e20", "+5",
/// " 7", "0x10", "-", "" — never truncated, rounded or coerced. That is the control
/// arm against the measured truncation of 6.2 to 6 in an earlier wire face.
/// Every face that takes a typed number (the app's --grade, the IDE's grade form)
/// parses through here, so the court has one input grammar.
public enum IntegerToken {
    public static func parse(_ s: Substring) -> Int64? {
        let u = s.utf8
        var i = u.startIndex
        guard i != u.endIndex else { return nil }
        let negative = u[i] == UInt8(ascii: "-")
        if negative {
            i = u.index(after: i)
            guard i != u.endIndex else { return nil }
        }
        var v: Int64 = 0
        while i != u.endIndex {
            let c = u[i]
            guard c >= UInt8(ascii: "0"), c <= UInt8(ascii: "9") else { return nil }
            let d = Int64(c &- UInt8(ascii: "0"))
            let (m, o1) = v.multipliedReportingOverflow(by: 10)
            // accumulate a negative value DOWNWARD so Int64.min is reachable exactly
            let (n, o2) = negative ? m.subtractingReportingOverflow(d) : m.addingReportingOverflow(d)
            if o1 || o2 { return nil }
            v = n
            i = u.index(after: i)
        }
        return v
    }

    public static func parse(_ s: String) -> Int64? { parse(s[...]) }
}
