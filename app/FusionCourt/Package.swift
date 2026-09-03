// swift-tools-version: 6.4
import PackageDescription

// MAC-ONLY BY DECISION (founder, 2026-09-02): no Linux burden, no MCP, no
// network on the control path. FusionLaw stays import-free anyway so the
// substrate court can share it.
//
// NO unsafeFlags anywhere: a package using them cannot be consumed as a
// dependency, which would destroy the one-law-one-home mechanism.
// NO -Ounchecked: it removes the overflow traps that ARE the safety property.
let package = Package(
    name: "FusionCourt",
    platforms: [.macOS(.v26)],
    products: [
        .executable(name: "FusionCourt", targets: ["FusionCourtApp"]),
        .library(name: "FusionLaw", targets: ["FusionLaw"]),
        .library(name: "FusionAffine", targets: ["FusionAffine"]),
        .library(name: "FusionLattice", targets: ["FusionLattice"]),
        .library(name: "FusionOperatingPoint", targets: ["FusionOperatingPoint"]),
        .library(name: "FusionGPU", targets: ["FusionGPU"]),
    ],
    targets: [
        .target(name: "FusionLaw", swiftSettings: [.swiftLanguageMode(.v6)]),
        .target(name: "FusionLattice", swiftSettings: [.swiftLanguageMode(.v6)]),
        .target(name: "FusionOperatingPoint", swiftSettings: [.swiftLanguageMode(.v6)]),
        .target(name: "FusionGPU", dependencies: ["FusionLaw", "FusionAffine"],
                exclude: ["Shaders"],
                resources: [.copy("Resources/verdict_screen.metallib")],
                swiftSettings: [.swiftLanguageMode(.v6)],
                linkerSettings: [.linkedFramework("Metal")]),
        .target(name: "FusionAffine", dependencies: ["FusionLaw"],
                swiftSettings: [.swiftLanguageMode(.v6)]),
        .target(name: "FusionClock", dependencies: ["FusionLaw"],
                swiftSettings: [.swiftLanguageMode(.v6)]),
        .executableTarget(name: "FusionCourtApp",
                dependencies: ["FusionLaw", "FusionAffine", "FusionClock", "FusionLattice", "FusionOperatingPoint", "FusionGPU"],
                swiftSettings: [.swiftLanguageMode(.v6)]),
        .testTarget(name: "FusionLawTests", dependencies: ["FusionLaw"],
                swiftSettings: [.swiftLanguageMode(.v6)]),
        .testTarget(name: "FusionLatticeTests", dependencies: ["FusionLattice", "FusionAffine", "FusionClock"],
                swiftSettings: [.swiftLanguageMode(.v6)]),
        .testTarget(name: "FusionOperatingPointTests", dependencies: ["FusionOperatingPoint"],
                swiftSettings: [.swiftLanguageMode(.v6)]),
        .testTarget(name: "FusionGPUTests", dependencies: ["FusionGPU", "FusionLaw"],
                swiftSettings: [.swiftLanguageMode(.v6)]),
    ]
)
