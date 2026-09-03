// The compositor: a plain Grid. Deliberately NOT the substrate's
// VignetteCompositor, which drags RealityKit + OpenUSD + WebKit and would alone
// blow the 250 ms cold-start budget.
import SwiftUI
import FusionLaw
import FusionAffine
import FusionClock
import FusionLattice

public struct FusionCourtView: View {
    @State private var snapshot: ControlSnapshot = .empty
    private let ring: SnapshotRing
    private let coldStart: UInt64
    private let periodNanos: UInt64

    public init(ring: SnapshotRing, coldStartNanos: UInt64, periodNanos: UInt64) {
        self.ring = ring; self.coldStart = coldStartNanos; self.periodNanos = periodNanos
    }

    public var body: some View {
        VStack(spacing: 10) {
            HStack(spacing: 10) {
                LawPanel()
                VerdictWall(snapshot: snapshot)
                CadencePanel(snapshot: snapshot, coldStartNanos: coldStart)
            }
            ChannelScope(window: snapshot.scope,
                         channel: snapshot.scopeChannel,
                         terminal: snapshot.hottest.first(where: { $0.channel == snapshot.scopeChannel })?.terminal ?? 0)
            statusStrip
        }
        .padding(12).background(Palette.bg)
        // 60 Hz READ of a published snapshot. The UI computes nothing it shows.
        .task {
            while !Task.isCancelled {
                snapshot = ring.read()
                try? await Task.sleep(nanoseconds: 16_666_666)
            }
        }
    }

    private var statusStrip: some View {
        HStack(spacing: 18) {
            strip("path", snapshot.path.rawValue)
            strip("agents", "\(snapshot.agentCount)")
            strip("period", "\(periodNanos / 1000) µs")
            strip("lanes", "\(Modalities.all.count)")
            strip("coldstart", "\(coldStart / 1_000_000) ms")
            Spacer()
            Text(snapshot.skippedTicks > 0 ? "DEADLINES MISSED" : "cadence held")
                .font(.system(size: 10, weight: .semibold, design: .monospaced))
                .foregroundStyle(snapshot.skippedTicks > 0 ? Palette.refused : Palette.nominal)
        }
        .padding(.horizontal, 4)
    }
    private func strip(_ k: String, _ v: String) -> some View {
        HStack(spacing: 5) {
            Text(k).font(.system(size: 9, design: .monospaced)).foregroundStyle(Palette.dim)
            Text(v).font(.system(size: 10, design: .monospaced)).foregroundStyle(Palette.ink)
        }
    }
}

// SwiftUI calls App.init() itself and App.main() is static, so the running
// state cannot be handed in through an initialiser. It is published here once,
// before main() is called, and read once when the scene is constructed.
public enum LiveContext {
    nonisolated(unsafe) public static var ring = SnapshotRing()
    nonisolated(unsafe) public static var coldStartNanos: UInt64 = 0
    nonisolated(unsafe) public static var periodNanos: UInt64 = 1_000_000
}

public struct FusionCourtSceneApp: App {
    public init() {}
    public var body: some Scene {
        Window("Affine.Earth — Fusion Control Verdict Court", id: "fusion-court") {
            FusionCourtView(ring: LiveContext.ring,
                            coldStartNanos: LiveContext.coldStartNanos,
                            periodNanos: LiveContext.periodNanos)
                .frame(minWidth: 1180, minHeight: 780)
        }
        .windowStyle(.hiddenTitleBar)
    }
}
