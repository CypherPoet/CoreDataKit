import Foundation
import CoreData


public class CoreDataManager<VersionLog: PersistentStoreVersionLogging> {
    public var storageStrategy: StorageStrategy
    public var migrator: PersistentStoreMigrating
    public var bundle: Bundle
    
    
    // MARK: - PersistentContainer
    public private(set) lazy var persistentContainer: NSPersistentContainer = makePersistentContainer()
    
    
    // MARK: - Managed Object Contexts
    public lazy var backgroundContext: NSManagedObjectContext = makeBackgroundContext()
    public lazy var mainContext: NSManagedObjectContext = makeMainContext()
    
    
    // MARK: - Init
    public init(
        storageStrategy: StorageStrategy = .persistent,
        migrator: PersistentStoreMigrating? = nil,
        bundle: Bundle = .main
    ) {
        self.storageStrategy = storageStrategy
        self.migrator = migrator ?? PersistentStoreMigrator(storageStrategy: storageStrategy)
        self.bundle = bundle
    }
}


// MARK: - Computeds
extension CoreDataManager {
    
    public var managedObjectModel: NSManagedObjectModel? {
        .mergedModel(from: [bundle])
    }
    
    
    public var storeURL: URL? {
        persistentContainer.persistentStoreDescriptions.first?.url
    }
}


// MARK: - Public Methods
extension CoreDataManager {
    
    public func setup() async throws {
        try await performMigrationIfNeeded()
        try await loadPersistentStores()
    }

    
    ///
    /// - Parameters:
    ///   - taskSchedulingMode: Determines how the current context's thread will execute the task.
    public func save(
        _ context: NSManagedObjectContext,
        taskSchedulingMode: NSManagedObjectContext.ScheduledTaskType = .immediate
    ) async throws {
        try await context.perform(schedule: taskSchedulingMode) {
            if context.hasChanges {
                do {
                    try context.save()
                } catch let error as NSError {
                    throw Error.saveFailed(error)
                }
            }
        }
    }

    
    ///
    /// - Parameters:
    ///   - taskSchedulingMode: Determines how the current context's thread will execute the task.
    public func saveContexts(
        taskSchedulingMode: NSManagedObjectContext.ScheduledTaskType = .immediate
    ) async throws {
        try await save(backgroundContext, taskSchedulingMode: taskSchedulingMode)
        try await save(mainContext, taskSchedulingMode: taskSchedulingMode)
    }
}


// MARK: - Private Methods
extension CoreDataManager {
    
    internal func performMigrationIfNeeded() async throws {
        guard let storeURL = storeURL else {
            throw Error.persistentStoreURLNotFound
        }

        let currentVersion = VersionLog.currentVersion

        guard migrator.requiresMigration(
            at: storeURL,
            to: currentVersion,
            in: bundle
        ) else {
            return
        }

        do {
            try migrator.migrateStore(at: storeURL, to: currentVersion)
        } catch let error as PersistentStoreMigrator.Error {
            throw Error.migrationFailed(error)
        } catch {
            throw Error.unknownError(error)
        }
    }
    
  
    internal func loadPersistentStores() async throws {
        return try await withCheckedThrowingContinuation { continuation in
            persistentContainer.loadPersistentStores { description, error in
                switch error {
                case .some(let error):
                    continuation.resume(throwing: CoreDataManager.Error.persistentStoreLoadingFailed(error as NSError))
                case .none:
                    continuation.resume(returning: Void())
                }
            }
        }
    }
}


// MARK: - Private Factories
extension CoreDataManager {
    
    private func makePersistentContainer() -> NSPersistentContainer {
        guard let managedObjectModel = managedObjectModel else {
            preconditionFailure("Failed to create Managed Object Model")
        }
        
        let container = NSPersistentContainer(
            name: VersionLog.persistentContainerName,
            managedObjectModel: managedObjectModel
        )
        
        if storageStrategy == .inMemory {
            container.persistentStoreDescriptions = [.inMemoryStore]
        }
        
        guard let description = container.persistentStoreDescriptions.first else {
            preconditionFailure("Failed to find persistent store description")
        }
        
        configurePersistentStoreDescription(description)
        
        return container
    }
    
    
    private func configurePersistentStoreDescription(_ description: NSPersistentStoreDescription) {
        description.type = storageStrategy.storeKind.rawValue
        description.shouldMigrateStoreAutomatically = false
        description.shouldInferMappingModelAutomatically = false
        
        // Default to loading the store asynchronously to allow for (potentially)
        // slow store migrations.
        description.shouldAddStoreAsynchronously = true
        
        if storageStrategy == .inMemory {
            description.shouldAddStoreAsynchronously = false
        }
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

