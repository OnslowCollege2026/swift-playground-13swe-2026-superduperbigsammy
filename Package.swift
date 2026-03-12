// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftPlayground",
    dependencies: [
        .package(url: "https://github.com/groue/GRDB.swift", exact: "7.10.0")
    ],
        targets: [
        .executableTarget(
            name: "SwiftPlayground",
            dependencies: [
                .product(name: "GRDB", package: "grdb.swift")
            ]
        ),
    ]
)