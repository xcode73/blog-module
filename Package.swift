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
        .package(url: "https://github.com/feathercms/feather-core", .branch("dev")),
        .package(url: "https://github.com/feathercms/blog-api", .branch("main")),
        .package(url: "https://github.com/feathercms/web-module", .branch("main")),
    ],
    targets: [
        .target(name: "BlogModule", dependencies: [
            .product(name: "Feather", package: "feather-core"),
            .product(name: "BlogApi", package: "blog-api"),
            .product(name: "WebModule", package: "web-module"),
        ],
        resources: [
            .copy("Bundle"),
        ]),
    ]
)
