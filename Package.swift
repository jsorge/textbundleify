// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "textbundleify",
    products: [
        .executable(name: "textbundleify", targets: ["textbundleify-main"]),
        .library(name: "TextBundleify", targets: ["TextBundleify"]),
    ],
    dependencies: [
        .package(url: "https://github.com/kylef/PathKit.git", from: "0.9.1"),
    ],
    targets: [
        .target(name: "textbundleify-main", dependencies: ["TextBundleify"]),
        .target(name: "TextBundleify", dependencies: ["PathKit"])
    ]
)
