//
// CoreDataManagerTests.swift
// ReviewJournal
//
// Created by CypherPoet on 2/24/21.
// ✌️
//


import XCTest
import Combine
import CypherPoetCoreDataKit
import XCTestStarterKit


class CoreDataManagerTests: XCTestCase {
    typealias CoreDataManager = CypherPoetCoreDataKit.CoreDataManager<PersistentStoreMigrationVersion>
    
    private var sut: CoreDataManager!
    private var storageStrategy: StorageStrategy!
    private var migrator: MockPersistentStoreMigrator!
    
    private var subscriptions = Set<AnyCancellable>()
}


// MARK: - Lifecycle
extension CoreDataManagerTests {

    override func setUpWithError() throws {
        // Put setup code here.
        // This method is called before the invocation of each
        // test method in the class.
        super.setUp()
        
        migrator = MockPersistentStoreMigrator()
        storageStrategy = .inMemory
        
        sut = makeSUT(
            storageStrategy: storageStrategy,
            migrator: migrator,
            bundle: Bundle(for: Self.self)
        )
    }


    override func tearDownWithError() throws {
        // Put teardown code here.
        // This method is called after the invocation of each
        // test method in the class.
        sut = nil
        storageStrategy = nil
        migrator = nil

        super.tearDown()
    }
}


// MARK: - Factories
private extension CoreDataManagerTests {

    func makeSUT(
        storageStrategy: StorageStrategy = .inMemory,
        migrator: PersistentStoreMigrating? = nil,
        bundle: Bundle = .module
    ) -> CoreDataManager {
        .init(
            storageStrategy: storageStrategy,
            migrator: migrator,
            bundle: bundle
        )
    }

    /// Helper to make the system under test from any default initializer
    /// and then test its initial conditions
    func makeSUTFromDefaults() -> CoreDataManager {
        .init()
    }
}


// MARK: - "Given" Helpers (Conditions Exist)
private extension CoreDataManagerTests {

    func givenDefaultSUTIsCreated() {
        sut = makeSUTFromDefaults()
    }
}


// MARK: - "When" Helpers (Actions Are Performed)
private extension CoreDataManagerTests {

    func whenSetupHasCompleted() throws {
        let publisher = sut.setup()
        
        let _ = try awaitCompletion(of: publisher)
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

    func test_CoreDataManager_WhenCreatedWithCustomStorageStrategy_CreatesDefaultMigratorWithCustomStorageStrategy() throws {
        sut = makeSUT(storageStrategy: .inMemory)
        XCTAssertEqual(sut.migrator.storageStrategy, .inMemory)
        
        sut = makeSUT(storageStrategy: .persistent)
        XCTAssertEqual(sut.migrator.storageStrategy, .persistent)
    }
}


// MARK: - `setup` Tests
extension CoreDataManagerTests {

    func test_CoreDataManagerSetup_LoadsPersistentStore() throws {
        try whenSetupHasCompleted()
        
        XCTAssertGreaterThan(
            sut.persistentContainer.persistentStoreCoordinator.persistentStores.count,
            0
        )
    }
    
    
    func test_CoreDataManagerSetup_MakesMainContextFromPersistentContainerViewContext() throws {
        try whenSetupHasCompleted()
        
        XCTAssertEqual(
            sut.mainContext,
            sut.persistentContainer.viewContext
        )
    }
    
    
    func test_CoreDataManagerSetup_MakesMainContextFromThePersistentStoreCoordinatorsFirstStore() throws {
        try whenSetupHasCompleted()
        
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


// MARK: - Migration Handing Tests
extension CoreDataManagerTests {
    
    func test_CoreDataManagerSetup_ChecksIfMigrationIsNeeded() throws {
        XCTAssertFalse(migrator.requiresMigrationWasCalled)
        
        try whenSetupHasCompleted()
        
        XCTAssertTrue(migrator.requiresMigrationWasCalled)
    }
    
    
    func test_CoreDataManagerSetup_WhenMigrationIsNeeded_PerformsMigration() throws {
        migrator.isMigrationExpectedToBeRequired = true
        XCTAssertFalse(migrator.migrateStoreWasCalled)
        
        try whenSetupHasCompleted()
        
        XCTAssertTrue(migrator.migrateStoreWasCalled)
    }
    
    
    func test_CoreDataManagerSetup_WhenMigrationIsNotNeeded_DoesNotPerformMigration() throws {
        migrator.isMigrationExpectedToBeRequired = false
        XCTAssertFalse(migrator.migrateStoreWasCalled)
        
        try whenSetupHasCompleted()
        
        XCTAssertFalse(migrator.migrateStoreWasCalled)
    }
}
