// swift-tools-version:5.10
import PackageDescription

let package = Package(
    name: "OneInchKit",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        .library(
            name: "OneInchKit",
            targets: ["OneInchKit"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/attaswift/BigInt.git", .upToNextMajor(from: "5.0.0")),
        .package(url: "https://github.com/sunimp/EvmKit.Swift.git", .upToNextMajor(from: "2.1.1")),
        .package(url: "https://github.com/sunimp/Eip20Kit.Swift.git", .upToNextMajor(from: "2.0.5")),
        .package(url: "https://github.com/sunimp/WWCryptoKit.Swift.git", .upToNextMajor(from: "1.3.4")),
        .package(url: "https://github.com/sunimp/WWExtensions.Swift.git", .upToNextMajor(from: "1.0.8")),
        .package(url: "https://github.com/sunimp/WWToolKit.Swift.git", .upToNextMajor(from: "2.0.7")),
    ],
    targets: [
        .target(
            name: "OneInchKit",
            dependencies: [
                "BigInt",
                .product(name: "EvmKit", package: "EvmKit.Swift"),
                .product(name: "Eip20Kit", package: "Eip20Kit.Swift"),
                .product(name: "WWCryptoKit", package: "WWCryptoKit.Swift"),
                .product(name: "WWExtensions", package: "WWExtensions.Swift"),
                .product(name: "WWToolKit", package: "WWToolKit.Swift"),
            ]
        ),
    ]
)
