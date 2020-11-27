// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "blog-module",
    platforms: [
       .macOS(.v10_15)
    ],
    products: [
        .library(name: "BlogModule", targets: ["BlogModule"]),
    ],
    dependencies: [
        .package(url: "https://github.com/binarybirds/feather-core", from: "1.0.0-beta"),
    ],
    targets: [
        .target(name: "BlogModule", dependencies: [
            .product(name: "FeatherCore", package: "feather-core"),
        ],
        resources: [
            .copy("Bundle"),
        ]),
        .testTarget(name: "BlogModuleTests", dependencies: [
                .target(name: "BlogModule"),
            ])
    ]
)
