// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "MultipleDelegate",
    platforms: [
        .iOS(.v10)
    ],
    products: [
        .library(name: "MultipleDelegate", targets: ["MultipleDelegate"])
    ],
    targets: [
        .target(name: "MultipleDelegate", path: "Sources")
    ]
)
