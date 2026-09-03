// OPERATING-POINT COURT — the SECOND law, live, on real published machines.
// The streaming law (VERDICT WALL) grades a signal window; this grades a whole
// discharge against three exact inequalities (Greenwald density, Troyon beta,
// q_min). n_e is swept 0.70..1.09 of each machine's own Greenwald limit, so WIN
// flips to MISS on screen as the sweep crosses 1.00 — and W7-X, a currentless
// stellarator, stays NOT_APPLICABLE the whole way: Greenwald is a statement
// about a current-carrying plasma, and the court refuses to invent an n_G that
// does not exist. Every verdict here is read from the snapshot, computed by the
// control thread through FusionOperatingPointLaw — the panel decides nothing.
import SwiftUI

struct OperatingPointPanel: View {
    let machines: [MachineVerdict]

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 8) {
                Text("OPERATING-POINT COURT").font(.system(size: 10, weight: .semibold, design: .monospaced))
                    .foregroundStyle(Palette.dim).tracking(1.2)
                Text("three exact inequalities · real machines · WIN holds below the 0.85 n_GW operational margin")
                    .font(.system(size: 9, design: .monospaced)).foregroundStyle(Palette.dim)
                Spacer()
                Text("bar = n_e / n_GW · tick past the mark is MISS")
                    .font(.system(size: 9, design: .monospaced)).foregroundStyle(Palette.dim)
            }
            HStack(spacing: 8) {
                ForEach(machines, id: \.name) { m in tile(m) }
            }
        }
        .padding(12).frame(maxWidth: .infinity, alignment: .leading)
        .background(Palette.panel)
        .overlay(RoundedRectangle(cornerRadius: 4).stroke(Palette.line))
    }

    private func tile(_ m: MachineVerdict) -> some View {
        let c = color(m.verdict)
        return VStack(alignment: .leading, spacing: 5) {
            HStack(spacing: 6) {
                Text(m.name).font(.system(size: 13, weight: .bold, design: .monospaced)).foregroundStyle(Palette.ink)
                Spacer(minLength: 4)
                if m.fGwPct > 0 {
                    Text("\(m.fGwPct)% n_GW").font(.system(size: 9, design: .monospaced)).foregroundStyle(Palette.dim)
                }
            }
            Text(badge(m.verdict)).font(.system(size: 10, weight: .semibold, design: .monospaced))
                .foregroundStyle(c).lineLimit(1).minimumScaleFactor(0.7)
            // a fill bar: how close n_e sits to this machine's Greenwald limit
            Canvas { ctx, size in
                var track = Path(); track.addRect(CGRect(origin: .zero, size: size))
                ctx.fill(track, with: .color(Palette.bg))
                let frac = min(CGFloat(m.fGwPct) / 120.0, 1.0)
                var fill = Path()
                fill.addRect(CGRect(x: 0, y: 0, width: size.width * frac, height: size.height))
                ctx.fill(fill, with: .color(c.opacity(0.55)))
                // the 0.85 n_GW operational margin — the court's actual WIN/MISS boundary
                let x = size.width * (85.0 / 120.0)
                var mark = Path(); mark.move(to: CGPoint(x: x, y: 0)); mark.addLine(to: CGPoint(x: x, y: size.height))
                ctx.stroke(mark, with: .color(Palette.ink.opacity(0.6)), lineWidth: 1)
            }
            .frame(height: 8)
        }
        .padding(9).frame(maxWidth: .infinity, alignment: .leading)
        .background(Palette.bg)
        .overlay(RoundedRectangle(cornerRadius: 3).stroke(c.opacity(0.5)))
    }

    private func color(_ v: String) -> Color {
        switch v {
        case "WIN": return Palette.nominal
        case "MISS": return Palette.refused
        case "NOT_APPLICABLE_NO_PLASMA_CURRENT": return Palette.dim
        case "NOT_MEASURED_PI_BRACKET": return Palette.mitigate
        default: return Palette.mitigate
        }
    }
    private func badge(_ v: String) -> String {
        switch v {
        case "NOT_APPLICABLE_NO_PLASMA_CURRENT": return "N/A · no I_p"
        case "NOT_MEASURED_PI_BRACKET": return "π-bracket"
        case "REFUSED_NONPHYSICAL": return "REFUSED"
        default: return v
        }
    }
}
