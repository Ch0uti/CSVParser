// swift-tools-version:4.2

import PackageDescription

let package = Package(
    name: "CSVParser",
    dependencies: [
        // development dependencies
        .package(url: "https://github.com/nicklockwood/SwiftFormat", from: "0.40.4"),
    ],
    targets: [
        .target(name: "CSVParser"),
        .testTarget(
            name: "CSVParserTests",
            dependencies: [
                "CSVParser",
            ]
        ),
    ]
)
