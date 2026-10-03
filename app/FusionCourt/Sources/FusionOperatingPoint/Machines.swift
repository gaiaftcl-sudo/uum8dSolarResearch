// THE FIVE MACHINES — one table. The app, the reproduce scripts and the Affine IDE
// read their machine numbers from here and nowhere else. Until 2026-10-03 the same
// rows were typed three times (ControlHost.swift, fusion-real-machines.swift,
// fusion-exact-vs-float.swift) and the W7-X rows already disagreed.
//
// WHAT IS SOURCED. Every (I_p, a) is REPORTED from the public source named in its
// row, and the source's own qualifier travels with it verbatim: "up to" for the JET
// and DIII-D currents, "~" for the W7-X radius, "Wikipedia" where the tree cites it.
// A figure that is in no tree is nil, and a face that shows it must say "not in
// tree" in its place — never a guess:
//   majorRadiusMm  ITER only, 6,200 mm (iter.org). Every other machine: not in tree.
//   kappaMilli     not in tree for any machine.
//   fieldPeriods   not in tree for any machine (the tree has no W7-X citation for it).
// Each enters only from a read source, with the surface the source states.
//
// WHAT IS SYNTHETIC. basePercent, fixedNe14, liveBetaNMilli, liveQMinMilli and the
// drift are NOT machine data. They are the inputs of the app's synthetic sweep: each
// machine is placed at its own fraction of its own Greenwald limit and moved by a
// triangle drift, so the court grades COMMANDED points. Nothing here is a measured
// plasma density.

public struct FusionMachine: Sendable, Equatable {
    public let name: String
    public let kind: String            // "tokamak" | "stellarator", as the tree names it
    public let ipAmp: Int64            // plasma current, A (0: the tree records no current)
    public let minorRadiusMm: Int64    // a, mm
    public let majorRadiusMm: Int64?   // R, mm — nil = not in tree
    public let kappaMilli: Int64?      // elongation x1000 — nil = not in tree
    public let fieldPeriods: Int64?    // nil = not in tree
    public let basePercent: Int64      // SYNTHETIC sweep base, % of this machine's own n_G
    public let fixedNe14: Int64?       // SYNTHETIC fixed density where there is no n_G to scale
    public let source: String          // the citation, as the tree gives it
    public let qualifier: String       // the source's own qualifier, verbatim ("" if none)
    public let grade: String           // evidence grade of (I_p, a): "REPORTED"

    public init(name: String, kind: String, ipAmp: Int64, minorRadiusMm: Int64,
                majorRadiusMm: Int64?, kappaMilli: Int64?, fieldPeriods: Int64?,
                basePercent: Int64, fixedNe14: Int64?, source: String,
                qualifier: String, grade: String) {
        self.name = name; self.kind = kind; self.ipAmp = ipAmp
        self.minorRadiusMm = minorRadiusMm; self.majorRadiusMm = majorRadiusMm
        self.kappaMilli = kappaMilli; self.fieldPeriods = fieldPeriods
        self.basePercent = basePercent; self.fixedNe14 = fixedNe14
        self.source = source; self.qualifier = qualifier; self.grade = grade
    }
}

/// One commanded point of the synthetic sweep, ready for the court.
public struct FusionMachinePoint: Sendable, Equatable {
    public let percent: Int64             // commanded % of own n_G; 0 where there is no n_G
    public let greenwaldFloor14: Int64?   // n_G at pi = 355/113, floored; nil with no current
    public let envelope: OperatingEnvelope
    public init(percent: Int64, greenwaldFloor14: Int64?, envelope: OperatingEnvelope) {
        self.percent = percent; self.greenwaldFloor14 = greenwaldFloor14; self.envelope = envelope
    }
}

public enum FusionMachines {
    public static let iter = FusionMachine(
        name: "ITER", kind: "tokamak", ipAmp: 15_000_000, minorRadiusMm: 2000,
        majorRadiusMm: 6200, kappaMilli: nil, fieldPeriods: nil,
        basePercent: 74, fixedNe14: nil,
        source: "iter.org", qualifier: "", grade: "REPORTED")
    public static let sparc = FusionMachine(
        name: "SPARC", kind: "tokamak", ipAmp: 8_700_000, minorRadiusMm: 570,
        majorRadiusMm: nil, kappaMilli: nil, fieldPeriods: nil,
        basePercent: 82, fixedNe14: nil,
        source: "Creely et al. 2020; Wikipedia", qualifier: "", grade: "REPORTED")
    public static let jet = FusionMachine(
        name: "JET", kind: "tokamak", ipAmp: 4_800_000, minorRadiusMm: 1250,
        majorRadiusMm: nil, kappaMilli: nil, fieldPeriods: nil,
        basePercent: 88, fixedNe14: nil,
        source: "EUROfusion; Wikipedia", qualifier: "I_p up to 4.8 MA", grade: "REPORTED")
    public static let diiiD = FusionMachine(
        name: "DIII-D", kind: "tokamak", ipAmp: 2_000_000, minorRadiusMm: 670,
        majorRadiusMm: nil, kappaMilli: nil, fieldPeriods: nil,
        basePercent: 96, fixedNe14: nil,
        source: "General Atomics; Wikipedia", qualifier: "I_p up to 2.0 MA", grade: "REPORTED")
    public static let w7x = FusionMachine(
        name: "W7-X", kind: "stellarator", ipAmp: 0, minorRadiusMm: 530,
        majorRadiusMm: nil, kappaMilli: nil, fieldPeriods: nil,
        basePercent: 0, fixedNe14: 5_000_000,
        source: "IPP Greifswald", qualifier: "a ~0.53 m; currentless", grade: "REPORTED")

    /// In display order. The four with a plasma current first, the currentless one last.
    public static let all: [FusionMachine] = [iter, sparc, jet, diiiD, w7x]

    /// The sweep's fixed beta_N and q_min — SYNTHETIC inputs, inside both bounds, so
    /// in the live sweep only the Greenwald branch can bind.
    public static let liveBetaNMilli: Int64 = 1800
    public static let liveQMinMilli: Int64 = 3000

    /// Ticks per drift step, and steps per triangle: one cycle is 56 x 360 = 20,160
    /// ticks, 20.16 s at 1 kHz.
    public static let driftStepTicks: UInt64 = 360
    public static let driftCycleSteps: UInt64 = 56

    /// The SYNTHETIC integer triangle drift in [-14, +14] percent, as the app has run
    /// it since 2026-09-02 (lifted verbatim from ControlHost.swift). A generator, not
    /// a plasma measurement.
    public static func drift(tick: UInt64) -> Int64 {
        let phase = Int64((tick / driftStepTicks) % driftCycleSteps)
        return (phase <= 28 ? phase : 56 - phase) - 14
    }

    /// The commanded point for machine m at tick. With a plasma current the density
    /// is (basePercent + drift) % of the machine's own n_G at pi = 355/113, floored;
    /// without one there is no n_G to scale, so the fixed synthetic density is used
    /// and the percent is 0. nil when the point cannot be formed exactly (no current
    /// and no fixed density, or a limit that overflows) — refused, never guessed.
    @available(macOS 15, *)
    public static func operatingPoint(_ m: FusionMachine, tick: UInt64) -> FusionMachinePoint? {
        if m.ipAmp == 0 {
            guard let ne = m.fixedNe14 else { return nil }
            return FusionMachinePoint(percent: 0, greenwaldFloor14: nil, envelope: OperatingEnvelope(
                ne14: ne, ipAmp: 0, minorRadiusMm: m.minorRadiusMm,
                betaNMilli: liveBetaNMilli, qMinMilli: liveQMinMilli))
        }
        let pct = m.basePercent + drift(tick: tick)
        let hi = FusionOperatingPointLaw.piHi
        guard let ng = FusionOperatingPointLaw.greenwaldDensityFloor(
                ipAmp: m.ipAmp, minorRadiusMm: m.minorRadiusMm, piNum: hi.num, piDen: hi.den)
        else { return nil }
        let (scaled, overflow) = ng.multipliedReportingOverflow(by: pct)
        if overflow { return nil }
        return FusionMachinePoint(percent: pct, greenwaldFloor14: ng, envelope: OperatingEnvelope(
            ne14: scaled / 100, ipAmp: m.ipAmp, minorRadiusMm: m.minorRadiusMm,
            betaNMilli: liveBetaNMilli, qMinMilli: liveQMinMilli))
    }
}
