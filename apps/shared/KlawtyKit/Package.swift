// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "KlawtyKit",
    platforms: [
        .iOS(.v18),
        .macOS(.v15),
    ],
    products: [
        .library(name: "KlawtyProtocol", targets: ["KlawtyProtocol"]),
        .library(name: "KlawtyKit", targets: ["KlawtyKit"]),
        .library(name: "KlawtyChatUI", targets: ["KlawtyChatUI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/steipete/ElevenLabsKit", exact: "0.1.0"),
        .package(url: "https://github.com/gonzalezreal/textual", exact: "0.3.1"),
    ],
    targets: [
        .target(
            name: "KlawtyProtocol",
            path: "Sources/KlawtyProtocol",
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
            ]),
        .target(
            name: "KlawtyKit",
            dependencies: [
                "KlawtyProtocol",
                .product(name: "ElevenLabsKit", package: "ElevenLabsKit"),
            ],
            path: "Sources/KlawtyKit",
            resources: [
                .process("Resources"),
            ],
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
            ]),
        .target(
            name: "KlawtyChatUI",
            dependencies: [
                "KlawtyKit",
                .product(
                    name: "Textual",
                    package: "textual",
                    condition: .when(platforms: [.macOS, .iOS])),
            ],
            path: "Sources/KlawtyChatUI",
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
            ]),
        .testTarget(
            name: "KlawtyKitTests",
            dependencies: ["KlawtyKit", "KlawtyChatUI"],
            path: "Tests/KlawtyKitTests",
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
                .enableExperimentalFeature("SwiftTesting"),
            ]),
    ])
