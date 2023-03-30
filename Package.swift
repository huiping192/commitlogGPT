// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "commitlogGPT",
    platforms: [
        .macOS(.v10_15)
    ],
    products: [
        .executable(name: "clg", targets: ["commitlogGPT"])
    ],
    dependencies: [
        .package(url: "https://github.com/adamrushy/OpenAISwift.git", from: "1.0.0")
    ],
    targets: [
        .executableTarget(
            name: "commitlogGPT",
            dependencies: [
                .product(name: "OpenAISwift", package: "OpenAISwift")
            ]
        ),
        .testTarget(
            name: "commitlogGPTTests",
            dependencies: ["commitlogGPT"]),
    ]
)
