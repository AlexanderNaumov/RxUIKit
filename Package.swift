// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "RxUIKit",
    platforms: [
        .iOS(.v10)
    ],
    products: [
        .library(name: "RxUIKit", targets: ["RxUIKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/ReactiveX/RxSwift.git", from: "6.1.0"),
        .package(url: "https://github.com/AlexanderNaumov/MultipleDelegate", from: "0.0.1")
    ],
    targets: [
        .target(name: "RxUIKit", dependencies: ["MultipleDelegate", .product(name: "RxCocoa", package: "RxSwift")], path: "Sources")
    ]
)
