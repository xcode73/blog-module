// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "blog-module",
    platforms: [
        .macOS(.v10_15)
    ],
    products: [
        .library(name: "BlogModule", targets: ["BlogModule"])
    ],
    dependencies: [
        .package(url: "https://github.com/xcode73/feather-core", branch: "test-dev"),
        .package(url: "https://github.com/xcode73/blog-objects", branch: "test-dev"),
        .package(url: "https://github.com/xcode73/web-module", branch: "test-dev")
    ],
    targets: [
        .target(name: "BlogModule", dependencies: [
            .product(name: "Feather", package: "feather-core"),
            .product(name: "BlogObjects", package: "blog-objects"),
            .product(name: "WebModule", package: "web-module")
        ],
        resources: [
            .copy("Bundle")
        ]),
    ],
    swiftLanguageVersions: [.v5]
)
