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
        .package(url: "https://github.com/ReactiveX/RxSwift.git", from: "5.0.0"),
        .package(path: "MultipleDelegate")
    ],
    targets: [
        .target(name: "RxUIKit", dependencies: ["MultipleDelegate", .product(name: "RxCocoa", package: "RxSwift")], path: "Sources")
    ]
)
