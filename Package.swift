// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "4d-link-status-bar",
    platforms: [.macOS(.v11)],
    products: [
        .executable(
            name: "4d-link-status-bar",
            targets: ["Executable"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", from: "0.3.0"),
        .package(url: "https://github.com/phimage/Appify.git", from: "0.0.1")
    ],
    targets: [
        .target(
            name: "Executable",
            dependencies: ["App", "QuatreD", "Appify", "Bash"],
            resources: [
                .process("4D-structure.png")
            ]
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
                "Bash",
                .product(
                    name: "ComposableArchitecture",
                    package: "swift-composable-architecture"
                )
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
        .target(
            name: "Bash"
        )
    ]
)
