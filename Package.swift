// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CypherPoetCoreDataKit",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
    ],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(name: "CypherPoetCoreDataKit", targets: ["CypherPoetCoreDataKit"]),

        .library(name: "CypherPoetCoreDataKit.CoreDataManager", targets: ["CypherPoetCoreDataKit.CoreDataManager"]),
        .library(name: "CypherPoetCoreDataKit.Extensions", targets: ["CypherPoetCoreDataKit.Extensions"]),
        .library(name: "CypherPoetCoreDataKit.PredicateUtils", targets: ["CypherPoetCoreDataKit.PredicateUtils"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "CypherPoetCoreDataKit",
            dependencies: [
                "CypherPoetCoreDataKit.CoreDataManager",
                "CypherPoetCoreDataKit.Extensions",
                "CypherPoetCoreDataKit.PredicateUtils",
            ]
        ),
        
        
        .target(
            name: "CypherPoetCoreDataKit.CoreDataManager",
            path: "Sources/CoreDataManager"
        ),
        
        
        .target(
            name: "CypherPoetCoreDataKit.Extensions",
            path: "Sources/Extensions"
        ),
        
        
        .target(
            name: "CypherPoetCoreDataKit.PredicateUtils",
            path: "Sources/PredicateUtils"
        ),
        .testTarget(
            name: "CypherPoetCoreDataKit.PredicateUtilsTests",
            dependencies: ["CypherPoetCoreDataKit.PredicateUtils"],
            path: "Tests/PredicateUtils"
        ),
    ]
)
