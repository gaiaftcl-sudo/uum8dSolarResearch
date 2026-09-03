// THE SWARM — two tiers, because TENDING and COMPUTING have incompatible
// constraints and merging them breaks whichever one you cared about.
//
//   TIER 1  THE LATTICE ITSELF — hot, 1 kHz, struct-in-buffer, ZERO allocation,
//           fixed slabs, order-fixed reductions. No actors: a Swift actor hop
//           costs hundreds of nanoseconds and the scheduler is not deadline
//           aware, so an actor per agent would blow a 400 us budget on
//           scheduling alone. Measured: 65,536 agents at 1.95 ns each.
//
//   TIER 2  THE TENDERS — warm, ~10 Hz, real Swift actors. They may allocate,
//           await, log, seal and talk to the outside. They NEVER sit on the
//           tick. A tender reads a published snapshot and acts between ticks.
//
// The rule that keeps it honest: TIER 2 MAY NEVER BE CALLED FROM TIER 1.
// Enforced structurally — the hot path holds no reference to any actor.

import Foundation

/// What a tender is allowed to see. A snapshot, never live buffers.
public struct LaneDigest: Sendable {
    public let modalityID: UInt8
    public let admitted: Int
    public let refusedDomain: Int      // outside this lane's own ADC domain
    public let refusedEnvelope: Int    // inside domain, outside declared envelope
    public let mitigating: Int
    public let peakGrowth: Int32
    public let staleTicks: UInt32      // ticks since this lane last delivered
}

public struct SwarmSnapshot: Sendable {
    public let tick: UInt64
    public let lanes: [LaneDigest]
    public let skippedTicks: UInt64
    public let tickCostNanos: UInt64
}

/// What a tender decides. Applied BETWEEN ticks, never during one.
public enum TendingAction: Sendable, Equatable {
    case rebalanceSlabs(to: Int)          // agent distribution across P-cores
    case quarantineLane(UInt8, reason: StaticString)
    case escalateSeal(reason: StaticString)
    case none

    public static func == (a: TendingAction, b: TendingAction) -> Bool {
        switch (a, b) {
        case (.none, .none): return true
        case (.rebalanceSlabs(let x), .rebalanceSlabs(let y)): return x == y
        case (.quarantineLane(let x, _), .quarantineLane(let y, _)): return x == y
        case (.escalateSeal, .escalateSeal): return true
        default: return false
        }
    }
}

/// One tender. An actor — it may allocate and await, because it is off the tick.
public actor Tender {
    public let name: StaticString
    private let decide: @Sendable (SwarmSnapshot) -> TendingAction
    private var lastAction: TendingAction = .none

    public init(name: StaticString, decide: @escaping @Sendable (SwarmSnapshot) -> TendingAction) {
        self.name = name; self.decide = decide
    }
    public func tend(_ s: SwarmSnapshot) -> TendingAction {
        let a = decide(s); lastAction = a; return a
    }
    public func last() -> TendingAction { lastAction }
}

/// The tending tier. Runs at its own slow cadence and produces actions.
public actor TendingSwarm {
    private var tenders: [Tender] = []
    private var applied: [TendingAction] = []

    public init() {}
    public func add(_ t: Tender) { tenders.append(t) }
    public var count: Int { tenders.count }

    /// Fan out to every tender. Actions are collected in FIXED tender order so
    /// two runs over the same snapshot produce the same action list.
    public func tend(_ s: SwarmSnapshot) async -> [TendingAction] {
        var out: [TendingAction] = []
        for t in tenders {                      // fixed order, deliberately serial
            let a = await t.tend(s)
            if a != .none { out.append(a) }
        }
        applied.append(contentsOf: out)
        return out
    }
    public func history() -> [TendingAction] { applied }
}

public enum StandardTenders {
    /// A lane that stops delivering is a DIFFERENT failure from a lane that
    /// delivers bad data. Absence is not a verdict — quarantine and say so.
    public static func staleLaneWatch(afterTicks: UInt32) -> Tender {
        Tender(name: "stale_lane_watch") { s in
            for l in s.lanes where l.staleTicks > afterTicks {
                return .quarantineLane(l.modalityID, reason: "lane went silent; absence is not NOMINAL")
            }
            return .none
        }
    }
    /// The budget tender: if the tick is eating the period, shed agents rather
    /// than miss deadlines silently.
    public static func budgetWatch(budgetNanos: UInt64, slabsWhenTight: Int) -> Tender {
        Tender(name: "budget_watch") { s in
            s.tickCostNanos > budgetNanos ? .rebalanceSlabs(to: slabsWhenTight) : .none
        }
    }
    /// Any refusal anywhere is worth a seal — a refusal is the product.
    public static func refusalSealer() -> Tender {
        Tender(name: "refusal_sealer") { s in
            let refused = s.lanes.reduce(0) { $0 + $1.refusedDomain + $1.refusedEnvelope }
            return refused > 0 ? .escalateSeal(reason: "lane refusals present this tick") : .none
        }
    }
}
