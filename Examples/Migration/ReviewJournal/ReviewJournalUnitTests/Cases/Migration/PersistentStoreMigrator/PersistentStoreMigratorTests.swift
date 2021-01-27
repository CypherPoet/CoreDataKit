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
    
    override class func setUp() {
        super.setUp()
        
        FileManager.clearDirectoryContents(at: FileManager.default.temporaryDirectory)
    }
    
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
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
    
}


// MARK: - "When" Helpers (Actions Are Performed)
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


// MARK: - Test Checking if Migration is Required
extension PersistentStoreMigratorTests {
    
    func test_RequiringMigration_WhenRequired_ReturnsTrue() throws {
        givenStartingStoreFileName("ReviewJournal_1")
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
        givenStartingStoreFileName("ReviewJournal_1")
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


// MARK: - Test Single Step Migrations
extension PersistentStoreMigratorTests {
    
    func test_MigratingFromV1ToV2_WhenEntitiesExist_MigratesEntitiesAndPreservesProperties() throws {
        let destinationVersion = PersistentStoreMigrationVersion.version2
        
        givenStartingStoreFileName("ReviewJournal_1")
        givenStoreIsReadyForMigration()
        
        try sut.migrateStore(
            at: newStoreURL,
            to: destinationVersion
        )
        
        XCTAssertTrue(fileManager.fileExists(atPath: newStoreURL.path))
        
        let newVersionDataModel = NSManagedObjectModel.model(for: destinationVersion)
        
        let newVersionManagedObjectContext = NSManagedObjectContext(
            for: newVersionDataModel,
            at: newStoreURL
        )
        
        let fetchRequest = Review.FetchRequests.default()
        let migratedReviews = try? newVersionManagedObjectContext.fetch(fetchRequest)
        
        XCTAssertEqual(migratedReviews?.count, 3)
        
        let firstMigratedReview = try XCTUnwrap(migratedReviews?.first)
        
        // 📝 There's a reason for using a plain `NSManagedObject`
        // instance and KVC to read properties.
        //
        // This is to handle the very likely scenario that the `Review` structure
        // defined in the destination model will not be the final `Review` structure.
        //
        // If we used `Review` instances, then as the `Review` entity changed in later
        // versions of the model, those changes would be mirrored in the `Review` `NSManagedObject`
        // subclass, which would result in this test potentially breaking.
        //
        // By using plain `NSManagedObject` instances and KVC, it is possible to
        // ensure that this test is 100% accurate to the structure of the `Review`
        // entity as defined in the destination model under test.
        let title = try XCTUnwrap(
            firstMigratedReview.value(forKeyPath: #keyPath(Review.title)) as? String
        )
        
        let creationDate = try XCTUnwrap(
            firstMigratedReview.value(forKeyPath: #keyPath(Review.creationDate)) as? Date
        )
        
        let lastModificationDate = try XCTUnwrap(
            firstMigratedReview.value(forKeyPath: #keyPath(Review.lastModificationDate)) as? Date
        )
        
        let bodyText = try XCTUnwrap(
            firstMigratedReview.value(forKeyPath: #keyPath(Review.bodyText)) as? String
        )
        
        let score = try XCTUnwrap(
            firstMigratedReview.value(forKeyPath: #keyPath(Review.score)) as? Double
        )
        
        let imageData = firstMigratedReview.value(forKeyPath: #keyPath(Review.imageData)) as? Data
        
        
        XCTAssertEqual(title, "Fire")
        XCTAssertEqual(creationDate.timeIntervalSinceReferenceDate, 633287866.120558)
        XCTAssertEqual(lastModificationDate.timeIntervalSinceReferenceDate, 633287866.120678)
        XCTAssertEqual(bodyText, "Hot")
        XCTAssertEqual(score, 4.3)
        XCTAssertEqual(imageData, nil)
        
        try newVersionManagedObjectContext.destroyStores()
    }
}
