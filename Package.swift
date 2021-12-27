// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "blog-module",
    platforms: [
       .macOS(.v12)
    ],
    products: [
        .library(name: "BlogModule", targets: ["BlogModule"]),
        .library(name: "BlogApi", targets: ["BlogApi"]),
    ],
    dependencies: [
        .package(url: "https://github.com/feathercms/feather-core", .branch("dev")),
    ],
    targets: [
        .target(name: "BlogApi", dependencies: [
            .product(name: "FeatherCoreApi", package: "feather-core"),
        ]),
        .target(name: "BlogModule", dependencies: [
            .target(name: "BlogApi"),
            .product(name: "FeatherCore", package: "feather-core"),
        ],
        resources: [
            .copy("Bundle"),
        ]),
    ]
)
