// swift-tools-version:5.10

import PackageDescription

let package = Package(
    name: "OneInchKit",
    platforms: [
        .iOS(.v14),
        .macOS(.v12)
    ],
    products: [
        .library(
            name: "OneInchKit",
            targets: ["OneInchKit"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/attaswift/BigInt.git", from: "5.4.1"),
        .package(url: "https://github.com/sunimp/EVMKit.git", .upToNextMajor(from: "1.0.0")),
        .package(url: "https://github.com/sunimp/EIP20Kit.git", .upToNextMajor(from: "1.0.0")),
        .package(url: "https://github.com/sunimp/SWCryptoKit.git", .upToNextMajor(from: "1.0.0")),
        .package(url: "https://github.com/sunimp/SWExtensions.git", .upToNextMajor(from: "1.0.0")),
        .package(url: "https://github.com/sunimp/SWToolKit.git", .upToNextMajor(from: "1.0.0")),
        .package(url: "https://github.com/nicklockwood/SwiftFormat.git", from: "0.54.6"),
    ],
    targets: [
        .target(
            name: "OneInchKit",
            dependencies: [
                "BigInt",
                "EVMKit",
                "EIP20Kit",
                "SWCryptoKit",
                "SWExtensions",
                "SWToolKit",
            ]
        ),
    ]
)
