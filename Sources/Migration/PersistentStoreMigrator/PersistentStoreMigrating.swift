import Foundation
import CoreData


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


public struct PersistentStoreMigrator: PersistentStoreMigrating {
    public var storageStrategy: StorageStrategy
    private var fileManager: FileManager
    
    
    public init(
        storageStrategy: StorageStrategy = .persistent,
        fileManager: FileManager = .default
    ) {
        self.storageStrategy = storageStrategy
        self.fileManager = fileManager
    }
}


// MARK: - Public Methods
extension PersistentStoreMigrator {
    
    public func requiresMigration<Version>(
        at storeURL: URL,
        to version: Version
    ) -> Bool where Version: PersistentStoreVersionLogging {
        guard
            let metadata = NSPersistentStoreCoordinator.metadata(
                forStoreAt: storeURL,
                using: storageStrategy
            ),
            let compatibleVersion = Version.compatibleVersion(for: metadata)
        else {
            return false
        }
        
        return compatibleVersion != version
    }
    
    
    public func migrateStore<Version>(
        at urlForStoreToUpdate: URL,
        to destinationVersion: Version
    ) throws where Version: PersistentStoreVersionLogging {
        try forceWALCheckpointing(forStoreAt: urlForStoreToUpdate)
        
        var temporaryStoreURL = urlForStoreToUpdate
        
        /// Before a migration can be performed,
        /// Core Data must first construct the individual migration
        /// steps into a migration path.
        let migrationSteps = try self.migrationSteps(
            forStoreAt: urlForStoreToUpdate,
            targeting: destinationVersion
        )
        
        // 🔑 Save the result of each completed migration step to a
        // temporary persistent store.
        for migrationStep in migrationSteps {
            
            let destinationURL = fileManager
                .temporaryDirectory
                .appendingPathComponent(UUID().uuidString)

            
            let migrationManager = migrationStep.migrationManager
            let storeKind = storageStrategy.storeKind

            do {
                try migrationManager.migrateStore(
                    from: temporaryStoreURL,
                    sourceType: storeKind,
                    options: nil,
                    with: migrationStep.mappingModel,
                    toDestinationURL: destinationURL,
                    destinationType: storeKind,
                    destinationOptions: nil
                )
            } catch {
                throw Error.migrationFailedAtStep(migrationStep)
            }
            
            if temporaryStoreURL != urlForStoreToUpdate {
                // Destroy the intermediate step's store
                try cleanup(storeAtURL: temporaryStoreURL)
            }
            
            temporaryStoreURL = destinationURL
        }
        
        
        // 🔑 Once the migration is complete, overwrite the original persistent store.
        do {
            try NSPersistentStoreCoordinator.replaceStore(
                at: urlForStoreToUpdate,
                withStoreAt: temporaryStoreURL
            )
        } catch {
            throw Error.persistentStoreReplacementFailed(error: error)
        }

        if temporaryStoreURL != urlForStoreToUpdate {
            try cleanup(storeAtURL: temporaryStoreURL)
        }
    }
}



// MARK: - Private Helpers
extension PersistentStoreMigrator {
    
    private func cleanup(storeAtURL storeURL: URL) throws {
        do {
            try NSPersistentStoreCoordinator.destroyStore(at: storeURL)
        } catch {
            throw Error.persistentStoreDestructionFailed(error: error)
        }
    }
    
    /// Constructs a migration path that will take the user's data from the persistent
    /// store's model version to the bundle model version in a progressive migration.
    private func migrationSteps<Version: PersistentStoreVersionLogging>(
        forStoreAt storeURL: URL,
        targeting destinationVersion: Version
    ) throws -> [PersistentStoreMigrationStep] {
        guard
            let metadata = NSPersistentStoreCoordinator.metadata(
                forStoreAt: storeURL,
                using: storageStrategy
            ),
            let sourceVersion = Version.compatibleVersion(for: metadata)
        else {
            throw Error.unknownStoreVersionAtURL(url: storeURL)
        }

        do {
            return try migrationSteps(from: sourceVersion, to: destinationVersion)
        } catch {
            throw Error.migrationStepConstructionFailed(error: error)
        }
    }
    
    
    private func migrationSteps<Version: PersistentStoreVersionLogging>(
        from sourceVersion: Version,
        to destinationVersion: Version
    ) throws -> [PersistentStoreMigrationStep] {
        var sourceVersion = sourceVersion
        var migrationSteps = [PersistentStoreMigrationStep]()

        while
            sourceVersion != destinationVersion,
            let nextVersion = sourceVersion.nextVersion()
        {
            let migrationStep = try PersistentStoreMigrationStep(
                sourceVersion: sourceVersion,
                destinationVersion: destinationVersion
            )
            
            migrationSteps.append(migrationStep)

            sourceVersion = nextVersion
        }

        return migrationSteps
    }

    
    /// Performs [Write-Ahead Logging](https://www.sqlite.org/wal.html)
    ///
    /// The sqlite-wal and sqlite files store their data using the same structure to
    /// allow data to be transferred easily between them.
    ///
    /// However, this shared structure causes issues during migration, as Core Data
    /// only migrates the data stored in the sqlite file to the new structure,
    /// leaving the data in the sqlite-wal file in the old structure.
    ///
    /// The resulting mismatch in structure will lead to a crash when Core Data attempts to
    /// update/use data stored in the sqlite-wal file 😞 .
    ///
    /// To avoid this crash, we need to force any data in the sqlite-wal file into the
    /// sqlite file before we perform a migration -- a process known as "checkpointing"
    /// (AKA forcing a "commit").
    private func forceWALCheckpointing(forStoreAt storeURL: URL) throws {
        guard
            let metadata = NSPersistentStoreCoordinator.metadata(
                forStoreAt: storeURL,
                using: storageStrategy
            ),
            
            /// 🔑 An easy mistake to make when checkpointing is using the bundle's
            /// model rather than the store's model.
            ///
            /// Remember: we want to perform checkpointing on the live (store) model
            /// before attempting to migrate to the latest (bundle) model.
            let liveStoreModel = NSManagedObjectModel.makeModel(with: metadata)
        else {
            return
        }

        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: liveStoreModel)
        let options = [
            NSSQLitePragmasOption: ["journal_mode": "DELETE"]
        ]
        
        do {
            // Force the checkpointing operation.
            let store = try persistentStoreCoordinator.addPersistentStore(
                ofType: storageStrategy.storeKind,
                configurationName: nil,
                at: storeURL,
                options: options
            )

            /// A side effect of checkpointing is that the empty sqlite-wal file is deleted for us,
            /// so removing the store from the `persistentStoreCoordinator`
            /// is all the cleanup that we need to perform.
            try persistentStoreCoordinator.remove(store)
        } catch {
            throw Error.forcedWALCheckpointingFailed(error: error)
        }
    }
}


// MARK: - PersistentStoreMigrator.Error
extension PersistentStoreMigrator {
    
    public enum Error: Swift.Error {
        case unknownStoreVersionAtURL(url: URL)
        case forcedWALCheckpointingFailed(error: Swift.Error)
        case migrationStepConstructionFailed(error: Swift.Error)
        case persistentStoreReplacementFailed(error: Swift.Error)
        case persistentStoreDestructionFailed(error: Swift.Error)
        case migrationFailedAtStep(PersistentStoreMigrationStep)
    }
}
