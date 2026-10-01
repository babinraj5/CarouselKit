// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "CarouselKit",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(name: "CarouselKit", targets: ["CarouselKit"])
    ],
    targets: [
        .target(name: "CarouselKit"),
        .testTarget(name: "CarouselKitTests", dependencies: ["CarouselKit"])
    ]
)
