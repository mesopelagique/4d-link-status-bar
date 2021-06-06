// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "4d-link-status-bar",
    platforms: [.macOS(.v10_15)],
    products: [
        .executable(
            name: "4d-link-status-bar",
            targets: ["Executable"]
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/pointfreeco/swift-composable-architecture.git",
            from: "0.3.0"
        )
    ],
    targets: [
        .target(
            name: "Executable",
            dependencies: ["App", "QuatreD"]
        ),
        .target(
            name: "App",
            dependencies: [
                "StatusBar",
                "QuatreD",
                .product(
                    name: "ComposableArchitecture",
                    package: "swift-composable-architecture"
                )
            ]
        ),
        .target(
            name: "StatusBar",
            dependencies: [
                "QuatreD",
                .product(
                    name: "ComposableArchitecture",
                    package: "swift-composable-architecture"
                )
            ],
            resources: [
                .copy("Resources/")
            ]
        ),
        .target(
            name: "QuatreD",
            dependencies: [
                .product(
                    name: "ComposableArchitecture",
                    package: "swift-composable-architecture"
                )
            ]
        ),
    ]
)
