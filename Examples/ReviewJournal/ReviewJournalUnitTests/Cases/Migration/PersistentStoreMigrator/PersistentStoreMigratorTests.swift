//
//  PersistentStoreMigratorTests.swift
//  Tests iOS
//

import Foundation
import XCTest
import CypherPoetCoreDataKit
import CoreData


@testable import ReviewJournal


final class PersistentStoreMigratorTests: XCTestCase {
    private var sut: PersistentStoreMigrator!
    private var storageStrategy: StorageStrategy!
    private var fileManager = FileManager.default
    private var startingStoreFileName: String!
    private var newStoreURL: URL!
}


// MARK: - Lifecycle
extension PersistentStoreMigratorTests {
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        FileManager.clearDirectoryContents(at: FileManager.default.temporaryDirectory)

        storageStrategy = .persistent
        sut = makeSUT()
    }
    
    
    override func tearDownWithError() throws {
        storageStrategy = nil
        sut = nil
        startingStoreFileName = nil
        newStoreURL = nil
        
        try super.tearDownWithError()
    }
}


// MARK: - Factories
extension PersistentStoreMigratorTests {
    
    func makeSUT() -> PersistentStoreMigrator {
        .init(
            storageStrategy: storageStrategy
        )
    }
    
    
    func makeSUTFromDefaults() -> PersistentStoreMigrator {
        .init()
    }
}


// MARK: - "Given" Helpers (Conditions Exist)
private extension PersistentStoreMigratorTests {
    
    func givenStartingStoreFileName(_ fileName: String) {
        startingStoreFileName = fileName
    }
    
    
    func givenStoreIsReadyForMigration() {
        newStoreURL = fileManager.temporaryDirectory
            .appendingPathComponent(startingStoreFileName)
            .appendingPathExtension("sqlite")
        
        FileManager.copyFile(
            in: Bundle(for: Self.self),
            named: startingStoreFileName,
            withExtension: "sqlite",
            to: newStoreURL,
            using: fileManager
        )
    }
}


// MARK: - "When" Helpers (Actions Are Performed)
private extension PersistentStoreMigratorTests {
}


// MARK: - Test Checking if Migration is Required
extension PersistentStoreMigratorTests {
    
    func test_RequiringMigration_WhenRequired_ReturnsTrue() throws {
        givenStartingStoreFileName(TestConstants.PersistentStoreFileNames.v1)
        givenStoreIsReadyForMigration()
        
        XCTAssertEqual(
            sut.requiresMigration(
                at: newStoreURL,
                to: PersistentStoreMigrationVersion.version2
            ),
            true
        )
    }
    

    func test_RequiringMigration_WhenVersionsAreEqual_ReturnsFalse() throws {
        givenStartingStoreFileName(TestConstants.PersistentStoreFileNames.v1)
        givenStoreIsReadyForMigration()
        
        XCTAssertEqual(
            sut.requiresMigration(
                at: newStoreURL,
                to: PersistentStoreMigrationVersion.version1
            ),
            false
        )
    }
}

