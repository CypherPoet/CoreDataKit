import Foundation


public protocol PersistentStoreMigrating {
    
    var storageStrategy: StorageStrategy { get }
    
    
    func requiresMigration<Version: PersistentStoreVersionLogging>(
        at storeURL: URL,
        to version: Version
    ) -> Bool
    

    /// Perform the migration of a persistent store to a specific version.
    ///
    /// throws: `PersistentStoreMigrator.Error`
    func migrateStore<Version: PersistentStoreVersionLogging>(
        at storeURL: URL,
        to version: Version
    ) throws
}
