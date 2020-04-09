// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LibrusAPI",
    products: [
        .library(
            name: "LibrusAPI",
            targets: ["LibrusAPI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/scinfu/SwiftSoup.git", from: "1.7.4"),
    ],
    targets: [
        .target(
            name: "LibrusAPI",
            dependencies: ["SwiftSoup"]),
        .testTarget(
            name: "LibrusAPITests",
            dependencies: ["LibrusAPI"]),
    ]
)
