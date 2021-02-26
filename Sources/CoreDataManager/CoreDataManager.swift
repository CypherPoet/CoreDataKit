import Foundation
import CoreData
import Combine


public final class CoreDataManager<VersionLog: PersistentStoreVersionLogging> {
    public var storageStrategy: StorageStrategy
    public var migrator: PersistentStoreMigrating
    
    
    // MARK: - PersistentContainer
    public private(set) lazy var persistentContainer: NSPersistentContainer = makePersistentContainer()
    
    
    // MARK: - Managed Object Contexts
    public lazy var backgroundContext: NSManagedObjectContext = makeBackgroundContext()
    public lazy var mainContext: NSManagedObjectContext = makeMainContext()
    
    
    // MARK: - Init
    public init(
        storageStrategy: StorageStrategy = .persistent,
        migrator: PersistentStoreMigrating? = nil
    ) {
        self.storageStrategy = storageStrategy
        self.migrator = migrator ?? PersistentStoreMigrator(storageStrategy: storageStrategy)
    }
}


// MARK: - Computeds
extension CoreDataManager {
    
    private var inMemoryStoreDescription: NSPersistentStoreDescription {
        .init(url: URL(fileURLWithPath: "/dev/null"))
    }
}


// MARK: - Public Methods
extension CoreDataManager {
    
    @discardableResult
    public func setup(
        runningOn schedulingQueue: DispatchQueue = .global(qos: .userInitiated),
        completingOn receptionQueue: DispatchQueue = .main
    ) -> AnyPublisher<Void, CoreDataManager.Error> {
        performMigrationIfNeeded()
            .subscribe(on: schedulingQueue)
            .receive(on: receptionQueue)
            .flatMap { _ in
                self.loadPersistentStores()
            }
            .eraseToAnyPublisher()
    }
  
    
    @discardableResult
    public func save(_ context: NSManagedObjectContext) -> Future<Void, CoreDataManager.Error> {
        Future { promise in
            context.performAndWait {
                if context.hasChanges {
                    do {
                        try context.save()
                        promise(.success(()))
                    } catch let error as NSError {
                        promise(.failure(.saveFailed(error)))
                    }
                }
            }
        }
    }

    @discardableResult
    public func saveContexts() -> Future<Void, CoreDataManager.Error> {
        Future { [weak self] promise in
            guard let self = self else { return }
            
            [self.backgroundContext, self.mainContext].forEach { context in
                context.performAndWait {
                    if context.hasChanges {
                        do {
                            try context.save()
                        } catch let error as NSError {
                            promise(.failure(.saveFailed(error)))
                        }
                    }
                }
            }
            
            promise(.success(()))
        }
    }
}


// MARK: - Private Methods
extension CoreDataManager {
    
    
    private func performMigrationIfNeeded() -> Future<Void, CoreDataManager.Error> {
        Future { [weak self] promise in
            guard let self = self else { return }

            guard let storeURL = self.persistentContainer.persistentStoreDescriptions.first?.url else {
                promise(.failure(.persistentStoreURLNotFound))
                return
            }

            let currentVersion = VersionLog.currentVersion

            guard self.migrator.requiresMigration(at: storeURL, to: currentVersion) else {
                promise(.success(()))
                return
            }

            do {
                try self.migrator.migrateStore(at: storeURL, to: currentVersion)
                promise(.success(()))
            } catch let error as PersistentStoreMigrator.Error {
                promise(.failure(.migrationFailed(error)))
            } catch {
                promise(.failure(.unknownError(error)))
            }
        }
    }
    
    
    private func loadPersistentStores() -> Future<Void, CoreDataManager.Error> {
        Future { [weak self] promise in
            self?.persistentContainer.loadPersistentStores { description, error in
                guard error == nil else {
                    promise(.failure(.persistentStoreLoadingFailed(error! as NSError)))
                    return
                }
                
                promise(.success(()))
            }
        }
    }
}


// MARK: - Private Factories
extension CoreDataManager {
    
    private func makePersistentContainer() -> NSPersistentContainer {
        let container = NSPersistentContainer(name: VersionLog.persistentContainerName)
        
        if storageStrategy == .inMemory {
            container.persistentStoreDescriptions = [inMemoryStoreDescription]
        }
        
        guard let description = container.persistentStoreDescriptions.first else {
            preconditionFailure("Unable to find a persistent store description")
        }
        
        description.type = storageStrategy.storeKind
        description.shouldMigrateStoreAutomatically = false
        description.shouldInferMappingModelAutomatically = false
        
        return container
    }
    
    
    private func makeBackgroundContext() -> NSManagedObjectContext {
        let context = self.persistentContainer.newBackgroundContext()
        
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        return context
    }
    
    
    private func makeMainContext() -> NSManagedObjectContext {
        let context = self.persistentContainer.viewContext
        
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        context.shouldDeleteInaccessibleFaults = true
        
        // 🔑 Ensures that the `mainContext` is aware of any changes that were made
        // to the persistent container.
        //
        // For example, when we save a background context,
        // the persistent container is automatically informed of the changes that
        // were made. And since the `mainContext` is considered to be a child of
        // the persistent container, it will receive those updates -- merging
        // any changes, as the name suggests, automatically.
        context.automaticallyMergesChangesFromParent = true
        
        return context
    }
}

