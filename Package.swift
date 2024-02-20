// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "blog-module",
    platforms: [
       .macOS(.v12)
    ],
    products: [
        .library(name: "BlogModule", targets: ["BlogModule"]),
    ],
    dependencies: [
        .package(url: "https://github.com/xcode73/feather-core", .branch("test-dev")),
        .package(url: "https://github.com/xcode73/blog-objects", .branch("test-dev")),
        .package(url: "https://github.com/xcode73/web-module", .branch("test-dev")),
    ],
    targets: [
        .target(name: "BlogModule", dependencies: [
            .product(name: "Feather", package: "feather-core"),
            .product(name: "BlogObjects", package: "blog-objects"),
            .product(name: "WebModule", package: "web-module"),
        ],
        resources: [
            .copy("Bundle"),
        ]),
    ]
)
