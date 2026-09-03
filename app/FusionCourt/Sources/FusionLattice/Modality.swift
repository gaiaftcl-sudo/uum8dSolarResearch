// MULTIMODAL INGRESS — one lane per diagnostic kind.
//
// Real tokamak diagnostics do not share a rate or a width. DIII-D magnetic
// probes sample at 2 MHz in 14 bits; ITER's radial neutron camera digitises
// 12-bit; ADITYA-U runs 16-bit at 200 kHz per channel. A single-width, single-
// rate ingress is a fiction, and a lane that silently rescales another lane's
// counts is the units error this programme grades everywhere else.
//
// So each lane declares its OWN width, rate and envelope, and the law is
// evaluated in that lane's native counts. Nothing is converted on the hot path.

@frozen public struct Modality: Sendable, Equatable {
    // StaticString is not Equatable; a lane's identity IS its id, so compare on that.
    public static func == (a: Modality, b: Modality) -> Bool { a.id == b.id }

    public let id: UInt8
    public let name: StaticString
    public let adcBits: Int32        // native digitiser width
    public let rateHz: Int64         // native sample rate
    public let envelopeAbs: Int32    // declared envelope IN THIS LANE'S COUNTS
    public let growthTrigger: Int32  // trip threshold in this lane's counts
    public let decimation: Int32     // samples per control tick at 1 kHz

    @inlinable public var adcMin: Int32 { -(1 << (adcBits - 1)) }
    @inlinable public var adcMax: Int32 {  (1 << (adcBits - 1)) - 1 }

    public init(id: UInt8, name: StaticString, adcBits: Int32, rateHz: Int64,
                envelopeAbs: Int32, growthTrigger: Int32) {
        self.id = id; self.name = name; self.adcBits = adcBits; self.rateHz = rateHz
        self.envelopeAbs = envelopeAbs; self.growthTrigger = growthTrigger
        self.decimation = Int32(rateHz / 1000)   // per 1 kHz control tick
    }
}

public enum Modalities {
    /// REPORTED widths and rates from published diagnostic-system literature.
    /// Envelope and trigger are DECLARED per lane, not derived — a real
    /// deployment re-freezes them against its own device.
    public static let magneticProbe = Modality(
        id: 0, name: "magnetic_probe", adcBits: 14, rateHz: 2_000_000,
        envelopeAbs: 6000, growthTrigger: 900)
    public static let ece = Modality(
        id: 1, name: "ece", adcBits: 14, rateHz: 2_000_000,
        envelopeAbs: 6000, growthTrigger: 1200)
    public static let neutronCamera = Modality(
        id: 2, name: "neutron_camera", adcBits: 12, rateHz: 2_000_000,
        envelopeAbs: 1500, growthTrigger: 300)
    public static let interferometer = Modality(
        id: 3, name: "interferometer", adcBits: 16, rateHz: 200_000,
        envelopeAbs: 24000, growthTrigger: 3000)
    public static let thomson = Modality(
        id: 4, name: "thomson_scattering", adcBits: 16, rateHz: 200_000,
        envelopeAbs: 24000, growthTrigger: 4000)
    public static let bolometer = Modality(
        id: 5, name: "bolometer", adcBits: 16, rateHz: 200_000,
        envelopeAbs: 20000, growthTrigger: 2500)

    public static let all: [Modality] =
        [magneticProbe, ece, neutronCamera, interferometer, thomson, bolometer]

    /// Samples that arrive per 1 kHz control tick, all lanes summed per channel.
    public static var samplesPerTickPerChannel: Int64 {
        all.reduce(0) { $0 + Int64($1.decimation) }
    }
}
