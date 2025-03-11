// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "WellNest-iphone",
    platforms: [
        .macOS(.v10_15)
    ],
    products: [
        .executable(
            name: "WellNest-iphone",
            targets: ["WellNest-iphone"]),
    ],
    dependencies: [
        // Add your dependencies here, for example:
        // .package(url: "https://github.com/apple/swift-argument-parser", from: "0.4.0"),
    ],
    targets: [
        .target(
            name: "WellNest-iphone",
            dependencies: [
                // Add your target dependencies here
            ]),
        .testTarget(
            name: "WellNest-iphoneTests",
            dependencies: ["WellNest-iphone"]),
    ]
)