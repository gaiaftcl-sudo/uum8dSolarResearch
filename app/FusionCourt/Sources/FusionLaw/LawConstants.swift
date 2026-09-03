// THE LAW'S CONSTANTS — the single home. Nothing else in this repository may
// define these. Enforced by Tools/one-law-one-home.sh.
//
// No imports. Not even Foundation. A law that needs a runtime is not a law.

public enum LawConstants {
    /// 14-bit signed ADC domain, as DIII-D magnetic probes acquire.
    public static let adcMin: Int = -8192
    public static let adcMax: Int =  8191
    /// Outside this, the law REFUSES rather than extrapolating.
    public static let envelopeAbs: Int = 6000
    /// Samples compared for mode growth.
    public static let growthWindow: Int = 8
    /// Integer growth in |amplitude| across the window that trips.
    public static let growthTrigger: Int = 900
    /// Consecutive tripping windows required. One spike is not a mode.
    public static let persist: Int = 3
}
