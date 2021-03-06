// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "CSVParser",
    products: [
        .library(name: "CSVParser", targets: ["CSVParser"]),
    ],
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
