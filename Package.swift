// swift-tools-version:5.9
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
        .package(path: "../feather-core"),
//        .package(url: "git@github.com:xcode73/feather-core.git", branch: "main")
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
