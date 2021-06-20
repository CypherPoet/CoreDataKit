import Foundation
import CypherPoetCoreDataKit


final class MockPersistentStoreMigrator {
    var requiresMigrationWasCalled: Bool
    var migrateStoreWasCalled: Bool


    var isMigrationExpectedToBeRequired: Bool = false
    
    
    init(
        requiresMigrationWasCalled: Bool = false,
        migrateStoreWasCalled: Bool = false
    ) {
        self.requiresMigrationWasCalled = requiresMigrationWasCalled
        self.migrateStoreWasCalled = migrateStoreWasCalled
    }
}


// MARK: - PersistentStoreMigrating
extension MockPersistentStoreMigrator: PersistentStoreMigrating {
    
    var storageStrategy: StorageStrategy {
        .inMemory
    }
    
    
    func requiresMigration<Version>(
        at storeURL: URL,
        to version: Version,
        in bundle: Bundle = .module
    ) -> Bool where Version : PersistentStoreVersionLogging {
        requiresMigrationWasCalled = true
        
        return isMigrationExpectedToBeRequired
    }
    
    
    func migrateStore<Version>(
        at storeURL: URL,
        to version: Version
    ) throws where Version: PersistentStoreVersionLogging {
        migrateStoreWasCalled = true
    }
    
    
}
