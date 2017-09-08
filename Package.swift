// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Shuttle",
    products: [
        .library(name: "Shuttle", targets: ["Shuttle"]),
    ],
    dependencies: [
        .package(url: "https://github.com/devxoul/MoyaSugar.git", .upToNextMajor(from: "0.4.1")),
        .package(url: "https://github.com/Moya/Moya.git", .upToNextMajor(from: "8.0.5")),
//        .package(url: "https://github.com/Quick/Quick.git", .branch("support-swift-4")),
//        .package(url: "https://github.com/Quick/Nimble.git", .branch("support-swift-4")),
    ],
    targets: [
        .target(name: "Shuttle", dependencies: ["TestFlight", "Tunes", "Portal"]),
        .target(name: "TestFlight", dependencies: ["Core"]),
        .target(name: "Tunes", dependencies: ["Core"]),
        .target(name: "Portal", dependencies: ["Core"]),
        .target(name: "Core", dependencies: ["MoyaSugar", "Moya"]),
        .target(name: "TestSupport", dependencies: []),

        .testTarget(name: "ShuttleTests", dependencies: ["Shuttle", "TestSupport"]), // Quick", "Nimble"]),
        .testTarget(name: "TestFlightTests", dependencies: ["TestFlight", "TestSupport"]), // Quick", "Nimble"]),
        .testTarget(name: "TunesTests", dependencies: ["Tunes", "TestSupport"]), // "Quick", "Nimble"]),
        .testTarget(name: "PortalTests", dependencies: ["Portal", "TestSupport"]), // "Quick", "Nimble"]),
        .testTarget(name: "CoreTests", dependencies: ["Core", "TestSupport"]), // "Quick", "Nimble"]),
    ],
    swiftLanguageVersions: [3, 4]
)
