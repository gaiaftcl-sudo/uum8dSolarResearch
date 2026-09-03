// CADENCE — the panel where the app tells on itself. Red whenever a deadline
// was missed. A control loop that hides its own gaps is the always-green defect
// wearing a clock.
import SwiftUI
import FusionClock

struct CadencePanel: View {
    let snapshot: ControlSnapshot
    let coldStartNanos: UInt64

    var body: some View {
        let missed = snapshot.skippedTicks > 0
        VStack(alignment: .leading, spacing: 6) {
            Text("CADENCE").font(.system(size: 10, weight: .semibold, design: .monospaced))
                .foregroundStyle(missed ? Palette.refused : Palette.dim).tracking(1.2)
            let h = snapshot.histogram
            Canvas { ctx, size in
                let maxC = max(h.counts.max() ?? 1, 1)
                let bw = size.width / CGFloat(h.counts.count)
                var p = Path()
                for (i, c) in h.counts.enumerated() {
                    let frac = CGFloat(c) / CGFloat(maxC)
                    let bh = size.height * frac
                    p.addRect(CGRect(x: CGFloat(i) * bw, y: size.height - bh,
                                     width: max(bw - 1, 1), height: bh))
                }
                ctx.fill(p, with: .color(missed ? Palette.refused : Palette.accent))
            }
            .frame(height: 70).background(Palette.bg)
            row("tick", "\(snapshot.tick)")
            row("skippedTicks", "\(snapshot.skippedTicks)", alert: missed)
            row("p50 / p99", "\(h.percentileNanos(50)) / \(h.percentileNanos(99)) ns")
            row("max", "\(h.maxNanos) ns")
            row("cold start", "\(coldStartNanos / 1_000_000) ms")
            row("path", snapshot.path.rawValue)
        }
        .padding(12).frame(minWidth: 260, alignment: .leading)
        .background(Palette.panel)
        .overlay(RoundedRectangle(cornerRadius: 4).stroke(missed ? Palette.refused : Palette.line))
    }
    private func row(_ k: String, _ v: String, alert: Bool = false) -> some View {
        HStack {
            Text(k).font(.system(size: 11, design: .monospaced)).foregroundStyle(Palette.ink)
            Spacer(minLength: 10)
            Text(v).font(.system(size: 11, design: .monospaced))
                .foregroundStyle(alert ? Palette.refused : Palette.accent)
        }
    }
}
