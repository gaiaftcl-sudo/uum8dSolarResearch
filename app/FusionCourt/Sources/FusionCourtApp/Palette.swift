// ONE palette, matching clients/fusion-court/index.html exactly, so the app and
// the browser client agree by construction rather than by anyone remembering to
// keep them in step.
import SwiftUI

public enum Palette {
    public static let bg      = Color(red: 10/255,  green: 14/255,  blue: 20/255)
    public static let panel   = Color(red: 17/255,  green: 24/255,  blue: 35/255)
    public static let line    = Color(red: 30/255,  green: 41/255,  blue: 54/255)
    public static let ink     = Color(red: 201/255, green: 214/255, blue: 228/255)
    public static let dim     = Color(red: 95/255,  green: 114/255, blue: 133/255)
    public static let accent  = Color(red: 88/255,  green: 166/255, blue: 255/255)
    public static let nominal = Color(red: 63/255,  green: 185/255, blue: 80/255)   // #3fb950
    public static let mitigate = Color(red: 227/255, green: 179/255, blue: 65/255)  // #e3b341
    public static let refused = Color(red: 248/255, green: 81/255,  blue: 73/255)   // #f85149

    public static func forTerminal(_ t: UInt32) -> Color {
        switch t { case 1: return mitigate; case 2, 3: return refused; default: return nominal }
    }
}
