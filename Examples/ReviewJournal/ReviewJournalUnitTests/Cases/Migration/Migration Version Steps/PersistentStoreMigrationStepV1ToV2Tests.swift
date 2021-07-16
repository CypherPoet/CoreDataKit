//
//  PersistentStoreMigrationStepV1ToV2Tests.swift
//  ReviewJournalUnitTests
//
//

import Foundation
import XCTest
import CoreDataKit
import CoreData

@testable import ReviewJournal


class PersistentStoreMigrationStepV1ToV2Tests: XCTestCase {
    private var sut: PersistentStoreMigrator!
    private var storageStrategy: StorageStrategy!
    private var fileManager = FileManager.default
    private var startingStoreFileName: String!
    private var destinationVersion: PersistentStoreMigrationVersion!
    private var newStoreURL: URL!
    private var newVersionDataModel: NSManagedObjectModel!
    private var newVersionManagedObjectContext: NSManagedObjectContext!
    private var migratedReviews: [NSManagedObject]!
}


// MARK: - Lifecycle
extension PersistentStoreMigrationStepV1ToV2Tests {
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        FileManager.clearDirectoryContents(at: FileManager.default.temporaryDirectory)
        
        destinationVersion = .version2
        storageStrategy = .persistent
        sut = makeSUT()
    }
    
    
    override func tearDownWithError() throws {
        try newVersionManagedObjectContext?.destroyStores()
        
        sut = nil
        startingStoreFileName = nil
        destinationVersion = nil
        storageStrategy = nil
        newStoreURL = nil
        newVersionDataModel = nil
        newVersionManagedObjectContext = nil
        migratedReviews = nil
        
        try super.tearDownWithError()
    }
}


// MARK: - Factories
extension PersistentStoreMigrationStepV1ToV2Tests {
    
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
private extension PersistentStoreMigrationStepV1ToV2Tests {
    
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
private extension PersistentStoreMigrationStepV1ToV2Tests {
    
    func whenStoreIsMigrated(to destinationVersion: PersistentStoreMigrationVersion) throws {
        try sut.migrateStore(
            at: newStoreURL,
            to: destinationVersion
        )
        
        
        XCTAssertTrue(fileManager.fileExists(atPath: newStoreURL.path))
    }
    
    
    func whenNewVersionDataModelIsCreated() {
        newVersionDataModel = NSManagedObjectModel.model(for: destinationVersion)
        
        newVersionManagedObjectContext = NSManagedObjectContext(
            for: newVersionDataModel,
            at: newStoreURL
        )
    }
    
    
    func whenMigratedReviewsAreFetched(
        using fetchRequest: NSFetchRequest<Review> = Review.FetchRequests.default()
    ) throws {
        migratedReviews = try newVersionManagedObjectContext.fetch(fetchRequest)
    }
}




// MARK: - Test Migration Step
extension PersistentStoreMigrationStepV1ToV2Tests {
    
    
    func test_MigratingFromV1ToV2_WhenEntitiesExist_PerformsMigration() throws {
        givenStartingStoreFileName(TestConstants.PersistentStoreFileNames.v1)
        givenStoreIsReadyForMigration()
        
        try whenStoreIsMigrated(to: destinationVersion)
        whenNewVersionDataModelIsCreated()
        try whenMigratedReviewsAreFetched()
        
        XCTAssertEqual(migratedReviews.count, 3)
        
        let firstMigratedReview = try XCTUnwrap(migratedReviews.first)
        
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
            firstMigratedReview.value(forKey: "title") as? String
        )
        
        let creationDate = try XCTUnwrap(
            firstMigratedReview.value(forKey: "creationDate") as? Date
        )
        
        let lastModificationDate = try XCTUnwrap(
            firstMigratedReview.value(forKey: "lastModificationDate") as? Date
        )
        
        let bodyText = try XCTUnwrap(
            firstMigratedReview.value(forKey: "bodyText") as? String
        )
        
        let score = try XCTUnwrap(
            firstMigratedReview.value(forKey: "score") as? Double
        )
        
        let imageData = firstMigratedReview.value(forKey: "imageData") as? Data
        
        
        XCTAssertEqual(title, "Fire")
        XCTAssertEqual(creationDate.timeIntervalSinceReferenceDate, 633287866.120558)
        XCTAssertEqual(lastModificationDate.timeIntervalSinceReferenceDate, 633287866.120678)
        XCTAssertEqual(bodyText, "Hot")
        XCTAssertEqual(score, 4.3)
        XCTAssertEqual(imageData, nil)
    }
}
