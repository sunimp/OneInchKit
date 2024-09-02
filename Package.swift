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
        .package(url: "https://github.com/sunimp/EVMKit.Swift.git", .upToNextMajor(from: "2.4.0")),
        .package(url: "https://github.com/sunimp/EIP20Kit.Swift.git", .upToNextMajor(from: "2.4.0")),
        .package(url: "https://github.com/sunimp/WWCryptoKit.Swift.git", .upToNextMajor(from: "1.4.0")),
        .package(url: "https://github.com/sunimp/WWExtensions.Swift.git", .upToNextMajor(from: "1.2.0")),
        .package(url: "https://github.com/sunimp/WWToolKit.Swift.git", .upToNextMajor(from: "2.2.0")),
        .package(url: "https://github.com/nicklockwood/SwiftFormat.git", from: "0.54.3"),
    ],
    targets: [
        .target(
            name: "OneInchKit",
            dependencies: [
                "BigInt",
                .product(name: "EVMKit", package: "EVMKit.Swift"),
                .product(name: "EIP20Kit", package: "EIP20Kit.Swift"),
                .product(name: "WWCryptoKit", package: "WWCryptoKit.Swift"),
                .product(name: "WWExtensions", package: "WWExtensions.Swift"),
                .product(name: "WWToolKit", package: "WWToolKit.Swift"),
            ]
        ),
    ]
)
