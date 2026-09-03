// CHANNEL SCOPE — one agent's window, drawn to resemble
// images/study33-verdict-shot.svg so the app and the published figure are
// recognisably the same object.
import SwiftUI
import FusionLaw

struct ChannelScope: View {
    let window: [Int16]
    let channel: UInt32
    let terminal: UInt32

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text("CHANNEL SCOPE").font(.system(size: 10, weight: .semibold, design: .monospaced))
                    .foregroundStyle(Palette.dim).tracking(1.2)
                Spacer()
                Text("ch \(channel)").font(.system(size: 10, design: .monospaced))
                    .foregroundStyle(Palette.forTerminal(terminal))
            }
            Canvas { ctx, size in
                let mid = size.height / 2
                // Int32 domain -> CGFloat happens HERE and only here: the render
                // boundary, one-way. Same discipline as AffineBody.renderPosition.
                let scale = (size.height / 2 - 8) / CGFloat(LawConstants.adcMax)
                let env = CGFloat(LawConstants.envelopeAbs) * scale
                for y in [mid - env, mid + env] {
                    var l = Path(); l.move(to: CGPoint(x: 0, y: y)); l.addLine(to: CGPoint(x: size.width, y: y))
                    ctx.stroke(l, with: .color(Palette.refused),
                               style: StrokeStyle(lineWidth: 1, dash: [5, 5]))
                }
                guard window.count > 1 else { return }
                var p = Path()
                for (i, v) in window.enumerated() {
                    let x = size.width * CGFloat(i) / CGFloat(window.count - 1)
                    let y = mid - CGFloat(v) * scale
                    i == 0 ? p.move(to: CGPoint(x: x, y: y)) : p.addLine(to: CGPoint(x: x, y: y))
                }
                ctx.stroke(p, with: .color(Palette.accent), lineWidth: 1.1)
            }
            .frame(height: 130).background(Palette.bg)
            .overlay(RoundedRectangle(cornerRadius: 3).stroke(Palette.line))
            Text("envelope ±\(LawConstants.envelopeAbs) · trigger \(LawConstants.growthTrigger) over \(LawConstants.growthWindow) samples")
                .font(.system(size: 9, design: .monospaced)).foregroundStyle(Palette.dim)
        }
        .padding(12).background(Palette.panel)
        .overlay(RoundedRectangle(cornerRadius: 4).stroke(Palette.line))
    }
}
