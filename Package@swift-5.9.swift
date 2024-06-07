// swift-tools-version:5.9
import PackageDescription
import Foundation

let package = Package(
    name: "blog-module",
    platforms: [
        .macOS(.v10_15)
    ],
    products: [
        .library(name: "BlogModule", targets: ["BlogModule"]),
        .library(name: "BlogApi", targets: ["BlogApi"]),
    ],
    dependencies: [
        .package(url: "https://github.com/xcode73/feather-core.git", branch: "main"),
    ],
    targets: [
        .target(
            name: "BlogApi",
            dependencies: [
                .product(name: "FeatherCoreApi", package: "feather-core"),
            ],
            swiftSettings: [.enableExperimentalFeature("StrictConcurrency=complete")]
        ),
        .target(
            name: "BlogModule",
            dependencies: [
                .target(name: "BlogApi"),
                .product(name: "FeatherCore", package: "feather-core"),
            ],
            resources: [
                .copy("Bundle"),
            ],
            swiftSettings: [.enableExperimentalFeature("StrictConcurrency=complete")]
        ),
    ]
)
