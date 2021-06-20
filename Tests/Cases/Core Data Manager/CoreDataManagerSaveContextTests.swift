//
// CoreDataManagerSaveContextTests.swift
// ReviewJournal
//
// Created by CypherPoet on 2/24/21.
// ✌️
//


import XCTest
import CoreData
import CypherPoetCoreDataKit


class CoreDataManagerSaveContextTests: XCTestCase {
    typealias SystemUnderTest = CypherPoetCoreDataKit.CoreDataManager<PersistentStoreMigrationVersion>
    
    private var sut: SystemUnderTest!
    private var storageStrategy: StorageStrategy!
    private var bundle: Bundle!
    private var fileManager: FileManager!
    private var managedObjectContextSavedExpectation: XCTestExpectation!
    private var temporaryContext: NSManagedObjectContext!
}


// MARK: - Lifecycle
extension CoreDataManagerSaveContextTests {

    override func setUpWithError() throws {
        // Put setup code here.
        // This method is called before the invocation of each
        // test method in the class.
        super.setUp()
        
        storageStrategy = .inMemory
        bundle = .module
        fileManager = .default
        
        sut = makeSUT(
            storageStrategy: storageStrategy,
            bundle: bundle
        )
        
        
        managedObjectContextSavedExpectation = expectation(
            forNotification: .NSManagedObjectContextDidSave,
            object: temporaryContext
        )
    }


    override func tearDownWithError() throws {
        // Put teardown code here.
        // This method is called after the invocation of each
        // test method in the class.
        sut = nil
        storageStrategy = nil
        bundle = nil
        fileManager = nil
        managedObjectContextSavedExpectation = nil
        temporaryContext = nil
        
        super.tearDown()
    }
}


// MARK: - Factories
extension CoreDataManagerSaveContextTests {

    private func makeSUT(
        storageStrategy: StorageStrategy = .inMemory,
        migrator: PersistentStoreMigrating? = nil,
        bundle: Bundle = .module
    ) -> SystemUnderTest {
        .init(
            storageStrategy: storageStrategy,
            migrator: migrator,
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

    private func givenDefaultSUTIsCreated() {
        sut = makeSUTFromDefaults()
    }
}


// MARK: - "When" Helpers (Actions Are Performed)
extension CoreDataManagerSaveContextTests {

    private func whenSetupHasCompleted() async throws {
        try await sut.setup()
    }
    
    
    private func whenTemporaryContextIsCreated() {
        let sqliteFileName = PersistentStoreMigrationVersion.currentVersion.modelSchemaName
        let sqliteFileURL = fileManager.temporaryDirectory
            .appendingPathComponent(sqliteFileName)
            .appendingPathExtension("sqlite")

        FileManager.copyFile(
            in: Bundle.module,
            named: PersistentStoreMigrationVersion.currentVersion.modelSchemaName,
            withExtension: "sqlite",
            to: sqliteFileURL,
            using: fileManager
        )
        
        let dataModel = sut.managedObjectModel!
        
        temporaryContext = NSManagedObjectContext(
            model: dataModel,
            storeURL: sqliteFileURL
        )
    }
}


// MARK: - Save Context Tests
extension CoreDataManagerSaveContextTests {
    
    func test_saveContext_whenContextHasNoChanges_DoesntPerformSave() async throws {
        try await whenSetupHasCompleted()
        whenTemporaryContextIsCreated()
        
        managedObjectContextSavedExpectation.isInverted = true
        
        try await sut.save(temporaryContext)
        
        wait(for: [managedObjectContextSavedExpectation], timeout: 0.5)
    }
    
    
    func test_saveContext_whenContextHasChanges_PerformsSave() async throws {
        try await whenSetupHasCompleted()
        whenTemporaryContextIsCreated()
        
        await temporaryContext.perform {
            let player = Player(context: self.temporaryContext)
            
            player.name = "CypherPoet"
        }

        try await sut.save(temporaryContext)
        
        wait(for: [managedObjectContextSavedExpectation], timeout: 0.5)
    }
}
