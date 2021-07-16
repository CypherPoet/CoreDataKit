// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CypherPoetCoreDataKit",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
        .tvOS(.v15),
        .watchOS(.v8),
    ],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "CoreDataKit",
            targets: ["CoreDataKit"]
        ),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
//        .package(url: "https://github.com/CypherPoet/XCTestStarterKit", .exact("0.0.3")),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "CoreDataKit",
            dependencies: [],
            path: "Sources/"
        ),
        .testTarget(
            name: "CoreDataKitTests",
            dependencies: [
                "CoreDataKit",
//                "XCTestStarterKit",
            ],
            path: "Tests/",
            resources: [
                .copy("./Data/SQLiteExamples"),
            ]
        ),
    ]
)
