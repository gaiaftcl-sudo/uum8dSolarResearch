// swift-tools-version: 6.4
// Affine.Earth Math Court — public Glama example.
// HTTPS JSON-RPC only. Decimal strings. No floats. No miner verbs.
import PackageDescription

let package = Package(
    name: "AffineMathCourtMCP",
    platforms: [.macOS(.v27)],
    products: [
        .executable(name: "affine-math-court", targets: ["AffineMathCourtMCP"]),
    ],
    targets: [
        .executableTarget(
            name: "AffineMathCourtMCP",
            path: "Sources",
            swiftSettings: [.swiftLanguageMode(.v6)]),
    ]
)
