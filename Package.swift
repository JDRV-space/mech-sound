// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "MechSound",
    platforms: [.macOS(.v13)],
    targets: [
        .executableTarget(
            name: "MechSound",
            path: "Sources/MechSound",
            linkerSettings: [
                .linkedFramework("Cocoa"),
                .linkedFramework("AVFoundation"),
            ]
        ),
        .testTarget(
            name: "MechSoundTests",
            dependencies: ["MechSound"],
            path: "Tests/MechSoundTests"
        ),
    ]
)
