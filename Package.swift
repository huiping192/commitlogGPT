// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "commmitlogGPT",
    platforms: [
        .macOS(.v10_15)
    ],
    products: [
        .executable(name: "clg",
                    targets: ["commmitlogGPT"])
    ],
    dependencies: [
      .package(url: "https://github.com/adamrushy/OpenAISwift.git", from: "1.0.0")
    ],
    targets: [
      .target(name: "commmitlogGPT", dependencies: [
        .product(name: "OpenAISwift", package: "OpenAISwift")
      ]),
      .testTarget(
        name: "commmitlogGPTTests",
        dependencies: ["commmitlogGPT"]),
    ]
)
