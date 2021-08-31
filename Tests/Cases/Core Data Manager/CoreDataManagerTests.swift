//
// CoreDataManagerTests.swift
//
// Created by CypherPoet on 2/24/21.
// ✌️
//


import XCTest
import CoreData
import CoreDataKit


class CoreDataManagerTests: XCTestCase {
    typealias SystemUnderTest = CoreDataKit.CoreDataManager<PersistentStoreMigrationVersion>
    
    private var sut: SystemUnderTest!
    private var storageStrategy: StorageStrategy!
    private var migrator: MockPersistentStoreMigrator!
    private var bundle: Bundle!
}


// MARK: - Lifecycle
extension CoreDataManagerTests {

    override func setUpWithError() throws {
        // Put setup code here.
        // This method is called before the invocation of each
        // test method in the class.
        try super.setUpWithError()
        
        migrator = MockPersistentStoreMigrator()
        storageStrategy = .inMemory
        bundle = .module
        
        sut = makeSUT(
            storageStrategy: storageStrategy,
            migrator: migrator,
            bundle: bundle
        )
    }


    override func tearDownWithError() throws {
        // Put teardown code here.
        // This method is called after the invocation of each
        // test method in the class.
        sut = nil
        storageStrategy = nil
        migrator = nil
        bundle = nil
        
        try super.tearDownWithError()
    }
}


// MARK: - Factories
extension CoreDataManagerTests {

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
extension CoreDataManagerTests {

    private func givenDefaultSUTIsCreated() {
        sut = makeSUTFromDefaults()
    }
}


// MARK: - "When" Helpers (Actions Are Performed)
extension CoreDataManagerTests {

    private func whenSetupHasCompleted() async throws {
        try await sut.setup()
    }
}


// MARK: - Test Initial Conditions From Default Initialization
extension CoreDataManagerTests {

    func test_DefaultCoreDataManager_SetsStorageStrategy() throws {
        givenDefaultSUTIsCreated()
        
        XCTAssertEqual(sut.storageStrategy, .persistent)
    }
    
    
    func test_DefaultCoreDataManager_SetsMigratorUsingDefaultStorageStrategy() throws {
        givenDefaultSUTIsCreated()
        
        XCTAssertEqual(sut.migrator.storageStrategy, .persistent)
    }
}


// MARK: - Test Initializing with Custom Arguments
extension CoreDataManagerTests {

    func test_WhenCreatedWithCustomStorageStrategy_CreatesDefaultMigratorWithCustomStorageStrategy() throws {
        sut = makeSUT(storageStrategy: .inMemory)
        XCTAssertEqual(sut.migrator.storageStrategy, .inMemory)
        
        sut = makeSUT(storageStrategy: .persistent)
        XCTAssertEqual(sut.migrator.storageStrategy, .persistent)
    }
}


// MARK: - Persistent Store Description Configuration
extension CoreDataManagerTests {

    
    func test_GivenPersistentStorageType_ConfiguresStoresToBeAddedAsynchronously() throws {
        sut = makeSUT(storageStrategy: .persistent)
        
        let persistentStoreDescription = try XCTUnwrap(sut.persistentContainer.persistentStoreDescriptions.first)
        
        XCTAssertTrue(persistentStoreDescription.shouldAddStoreAsynchronously)
    }
    
    
    func test_GivenInMemoryStorageType_ConfiguresStoresToBeAddedSynchronously() throws {
        sut = makeSUT(storageStrategy: .inMemory)
        
        let persistentStoreDescription = try XCTUnwrap(sut.persistentContainer.persistentStoreDescriptions.first)
        
        XCTAssertFalse(persistentStoreDescription.shouldAddStoreAsynchronously)
    }
}


// MARK: - `setup` Tests
extension CoreDataManagerTests {

    func test_Setup_LoadsPersistentStore() async throws {
        try await whenSetupHasCompleted()
        
        XCTAssertGreaterThan(
            sut.persistentContainer.persistentStoreCoordinator.persistentStores.count,
            0
        )
    }
    
    
    func test_Setup_MakesMainContextFromPersistentContainerViewContext() async throws {
        try await whenSetupHasCompleted()
        
        XCTAssertEqual(
            sut.mainContext,
            sut.persistentContainer.viewContext
        )
    }
    
    
    func test_Setup_MakesMainContextFromThePersistentStoreCoordinatorsFirstStore() async throws {
        try await whenSetupHasCompleted()
        
        let sutPersistentStore = try XCTUnwrap(
            sut.persistentContainer.persistentStoreCoordinator.persistentStores.first
        )
        let mainContextPersistentStore = try XCTUnwrap( sut.mainContext.persistentStoreCoordinator?.persistentStores.first
        )

        XCTAssertEqual(
            sutPersistentStore.identifier,
            mainContextPersistentStore.identifier
        )
    }
}


// MARK: - Migration During Setup Tests
extension CoreDataManagerTests {
    
    func test_PerformingMigration_ChecksIfMigrationIsNeeded() async throws {
        XCTAssertFalse(migrator.requiresMigrationWasCalled)
        
        try await whenSetupHasCompleted()
        
        XCTAssertTrue(migrator.requiresMigrationWasCalled)
    }
    
    
    func test_PerformingMigration_WhenMigrationIsNeeded_PerformsMigration() async throws {
        migrator.isMigrationExpectedToBeRequired = true
        XCTAssertFalse(migrator.migrateStoreWasCalled)
        
        try await whenSetupHasCompleted()
        
        XCTAssertTrue(migrator.migrateStoreWasCalled)
    }
    
    
    func test_PerformingMigration_WhenMigrationIsNotNeeded_DoesNotPerformMigration() async throws {
        migrator.isMigrationExpectedToBeRequired = false
        XCTAssertFalse(migrator.migrateStoreWasCalled)
        
        try await whenSetupHasCompleted()
        
        XCTAssertFalse(migrator.migrateStoreWasCalled)
    }
    
    
    func test_PerformingMigration_whenStoreURLIsNil_ThrowsError() async throws {
        sut.persistentContainer.persistentStoreDescriptions = []
        
        do {
            try await whenSetupHasCompleted()
        } catch {
            guard case SystemUnderTest.Error.persistentStoreURLNotFound = error else {
                XCTFail()
                return
            }
        }
    }
}
