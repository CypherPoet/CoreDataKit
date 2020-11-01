# CypherPoetCoreDataKit

<p align="center">
   <img width="600px" src="./Resources/Images/Banner-1.png" alt="CypherPoetCoreDataKit Header Image">
</p>

<p>
    <img src="https://img.shields.io/badge/Swift-5.3-F06C33.svg" />
    <img src="https://img.shields.io/badge/iOS-13.0+-865EFC.svg" />
    <img src="https://img.shields.io/badge/iPadOS-13.0+-F65EFC.svg" />
    <img src="https://img.shields.io/badge/macOS-10.15+-179AC8.svg" />
    <img src="https://img.shields.io/badge/tvOS-13.0+-41465B.svg" />
    <img src="https://img.shields.io/badge/watchOS-6.0+-1FD67A.svg" />
    <img src="https://img.shields.io/badge/License-MIT-blue.svg" />
    <a href="https://github.com/apple/swift-package-manager">
      <img src="https://img.shields.io/badge/spm-compatible-brightgreen.svg?style=flat" />
    </a>
    <a href="https://twitter.com/cypher_poet">
        <img src="https://img.shields.io/badge/Contact-@cypher_poet-lightgrey.svg?style=flat" alt="Twitter: @cypher_poet" />
    </a>
</p>


<p align="center">

_A collection of utilities for building Core Data applications in SwiftUI._

<p />


## 🚧 Disclaimer

This library is still a WIP as I study some of the best practices and patterns enabled by SwiftUI 2.0 -- and refactor accordingly.


## Features

- ✅ A [`CoreDataManager`](./Sources/CoreDataManager/) that handles setting up your ["Core Data Stack"](https://developer.apple.com/documentation/coredata/core_data_stack).
- ✅ A [`FetchedResultsControlling` protocol](./Sources/FetchUtils/FetchedResultsControlling.swift) that helps architect `NSFetchedResultsController` instances and extract data from their `NSFetchRequest` results.
- ✅ Predicate Utilities
- ✅ Strongly-typed errors for save operations.
- ✅ `NSPersistentStore` helpers for using `NSSQLiteStoreType` in production apps and `NSInMemoryStoreType` in tests or previews:



## Installation

### Xcode Projects

Select `File` -> `Swift Packages` -> `Add Package Dependency` and enter `https://github.com/CypherPoet/CypherPoetCoreDataKit`.


### Swift Package Manager Projects

You can add `CypherPoetCoreDataKit` as a dependency in your `Package.swift` file:

```swift
let package = Package(
    //...
    dependencies: [
        .package(url: "https://github.com/CypherPoet/CypherPoetCoreDataKit", from: "0.0.13"),
    ],
    //...
)
```


Then simply `import CypherPoetCoreDataKit` wherever you’d like to use it.



## Usage

<!--

Usage of these utilities is best demonstrated by the [Example App](./Examples/ExampleApp/).

- [Using launch arguments]() to help with Core Data-related debugging.

 -->

## Contributing

Contributions to `CypherPoetCoreDataKit` are most welcome. Check out some of the [issue templates](./.github/ISSUE_TEMPLATE/) for more info.



## Developing

### Requirements

- Xcode 12.0+ (for developing)


### Generating Documentation

Documentation is generated by [Jazzy](https://github.com/realm/jazzy). Installation instructions can be found [here](https://github.com/realm/jazzy#installation), and as soon as you have it set up, docs can be generated simply by running `jazzy` from the command line.



## License

`CypherPoetCoreDataKit` is available under the MIT license. See the [LICENSE file](./LICENSE) for more info.
