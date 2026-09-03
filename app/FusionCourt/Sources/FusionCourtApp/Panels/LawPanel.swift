// THE LAW, FROZEN. Every constant is rendered FROM LawConstants — never typed
// into the view. This panel is the app's claim to being a court rather than a
// dashboard, and it would be worthless if the numbers were transcribed.
import SwiftUI
import FusionLaw

struct LawPanel: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("THE LAW, FROZEN").font(.system(size: 10, weight: .semibold, design: .monospaced))
                .foregroundStyle(Palette.dim).tracking(1.2)
            row("ADC domain", "\(LawConstants.adcMin) … \(LawConstants.adcMax)")
            row("declared envelope", "|count| ≤ \(LawConstants.envelopeAbs)")
            row("growth window", "\(LawConstants.growthWindow) samples")
            row("growth trigger", "\(LawConstants.growthTrigger) counts")
            row("persistence", "\(LawConstants.persist) consecutive windows")
            row("arithmetic", "integer add · subtract · compare")
            Spacer(minLength: 0)
            Text("rendered from LawConstants, not transcribed")
                .font(.system(size: 9, design: .monospaced)).foregroundStyle(Palette.dim)
        }
        .padding(12).frame(minWidth: 260, alignment: .leading)
        .background(Palette.panel).overlay(RoundedRectangle(cornerRadius: 4).stroke(Palette.line))
    }
    private func row(_ k: String, _ v: String) -> some View {
        HStack(alignment: .firstTextBaseline) {
            Text(k).font(.system(size: 11, design: .monospaced)).foregroundStyle(Palette.ink)
            Spacer(minLength: 12)
            Text(v).font(.system(size: 11, design: .monospaced)).foregroundStyle(Palette.accent)
        }
    }
}
