// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LibrusKit",
    products: [
        .library(
            name: "LibrusKit",
            targets: ["LibrusKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/scinfu/SwiftSoup.git", from: "1.7.4"),
    ],
    targets: [
        .target(
            name: "LibrusKit",
            dependencies: ["SwiftSoup"]),
        .testTarget(
            name: "LibrusKitTests",
            dependencies: ["LibrusKit"]),
    ]
)
