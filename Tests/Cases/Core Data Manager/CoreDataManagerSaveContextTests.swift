//
// CoreDataManagerSaveContextTests.swift
//
// Created by CypherPoet on 2/24/21.
// ✌️
//


import XCTest
import CoreData
import CoreDataKit


class CoreDataManagerSaveContextTests: XCTestCase {
    typealias SystemUnderTest = CoreDataKit.CoreDataManager<PersistentStoreMigrationVersion>
    
    private var sut: SystemUnderTest!
    private var managedObjectContext: NSManagedObjectContext!
    private var storageStrategy: StorageStrategy!
    private var bundle: Bundle!
    private var fileManager: FileManager!
    private var managedObjectContextSavedExpectation: XCTestExpectation!
}


// MARK: - Lifecycle
extension CoreDataManagerSaveContextTests {

    override func setUp() async throws {
        try await super.setUp()
        
        storageStrategy = .inMemory
        bundle = .module
        fileManager = .default
        
        sut = makeSUT()
        managedObjectContext = sut.mainContext
        
        try await sut.setup()
    }


    override func tearDown() async throws {
        try await super.tearDown()

        sut = nil
        managedObjectContext = nil
        storageStrategy = nil
        bundle = nil
        fileManager = nil
        managedObjectContextSavedExpectation = nil
    }
}


// MARK: - Factories
extension CoreDataManagerSaveContextTests {

    private func makeSUT() -> SystemUnderTest {
        .init(
            storageStrategy: storageStrategy,
            bundle: bundle
        )
    }

    /// Helper to make the system under test from any default initializer
    /// and then test its initial conditions
    private func makeSUTFromDefaults() -> SystemUnderTest {
        .init()
    }
}


// MARK: - "Given" Helpers (Conditions Exist)
extension CoreDataManagerSaveContextTests {

    private func givenContextSaveIsExpected() {
        managedObjectContextSavedExpectation = expectation(
            forNotification: .NSManagedObjectContextDidSave,
            object: managedObjectContext
        )
    }
    
    
    private func givenContextSaveIsNotExpected() {
        givenContextSaveIsExpected()
        managedObjectContextSavedExpectation.isInverted = true
    }
}


// MARK: - "When" Helpers (Actions Are Performed)
extension CoreDataManagerSaveContextTests {
    
    private func whenSaveErrorOccurs() async throws -> SystemUnderTest.Error {
        do {
            try await sut.save(managedObjectContext)
        } catch {
            return try! XCTUnwrap(error as? CoreDataManager.Error)
        }
        
        preconditionFailure("Expected `CoreDataManager.Error` after save")
    }
}


// MARK: - Save Context Tests
extension CoreDataManagerSaveContextTests {
    
    func test_SaveContext_WhenContextHasNoChanges_DoesntPerformSave() async throws {
        givenContextSaveIsNotExpected()
        
        try await sut.save(managedObjectContext)
        
        wait(for: [managedObjectContextSavedExpectation], timeout: 0.5)
    }
    
    
    func test_SaveContext_WhenContextHasChanges_PerformsSave() async throws {
        givenContextSaveIsExpected()
        
        await managedObjectContext.perform {
            let player = Player(context: self.managedObjectContext)
            
            player.name = "CypherPoet"
        }

        try await sut.save(managedObjectContext)
        
        wait(for: [managedObjectContextSavedExpectation], timeout: 0.5)
    }
}


// MARK: - Context Saving Error Handling Tests


extension CoreDataManagerSaveContextTests {
    
    func test_SaveContext_WhenNSManagedObjectValidationError_ThrowsErrorForSaveFailingDueToValidationError()
    async throws {
        await managedObjectContext.perform {
            let player = Player(context: self.managedObjectContext)
            
            player.name = ""
        }
        
        let saveError = try await whenSaveErrorOccurs()
        
        switch (saveError) {
        case .saveFailureFromValidationError:
            break
        default:
            XCTFail("Expected Validation Error. Received error: \(saveError)")
        }
    }
}
