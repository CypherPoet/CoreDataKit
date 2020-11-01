import Foundation
import CoreData
import Combine


public final class CoreDataManager {
    public typealias LoadCompletionHandler = (() -> Void)

    private var managedObjectModelName: String
    private var storageStrategy: StorageStrategy


    // MARK: - PersistentContainer
    public lazy var persistentContainer: NSPersistentContainer = makePersistentContainer()


    // MARK: - Managed Object Contexts
    public lazy var backgroundContext: NSManagedObjectContext = makeBackgroundContext()
    public lazy var mainContext: NSManagedObjectContext = makeMainContext()

    
    // MARK: - Init
    public init(
        managedObjectModelName: String,
        storageStrategy: StorageStrategy = .persistent
    ) {
        self.managedObjectModelName = managedObjectModelName
        self.storageStrategy = storageStrategy
    }
}


// MARK: - Computeds
extension CoreDataManager {

    public var storeKind: String {
        switch storageStrategy {
        case .persistent:
            return NSSQLiteStoreType
        case .inMemory:
            return NSInMemoryStoreType
        }
    }


    private var inMemoryStoreDescription: NSPersistentStoreDescription {
        .init(url: URL(fileURLWithPath: "/dev/null"))
    }
}


// MARK: - Public Methods
extension CoreDataManager {
    
    public func setup(then completionHandler: LoadCompletionHandler? = nil) {
        loadPersistentStore() {
            completionHandler?()
        }
    }
    

    @discardableResult
    public func save(_ context: NSManagedObjectContext) -> Future<Void, CoreDataManagerError> {
        Future { resolve in
            context.performAndWait {
                if context.hasChanges {
                    do {
                        try context.save()
                        resolve(.success(()))
                    } catch let error as NSError {
                        resolve(.failure(.saveFailed(error)))
                    }
                }
            }
        }
    }


    @discardableResult
    public func saveContexts() -> Future<Void, CoreDataManagerError> {
        Future { [weak self] resolve in
            guard let self = self else { return }
            
            [self.backgroundContext, self.mainContext].forEach { context in
                context.performAndWait {
                    if context.hasChanges {
                        do {
                            try context.save()
                        } catch let error as NSError {
                            resolve(.failure(.saveFailed(error)))
                        }
                    }
                }
            }
            
            resolve(.success(()))
        }
    }
}


// MARK: - Private Methods
extension CoreDataManager {

    private func loadPersistentStore(then completionHandler: @escaping LoadCompletionHandler) {
        persistentContainer.loadPersistentStores { description, error in
            guard error == nil else {
                fatalError("Error while loading persistent stores: \(error!)")
            }

            completionHandler()
        }
    }
}

// MARK: - Private Factories
extension CoreDataManager {

    private func makePersistentContainer() -> NSPersistentContainer {
        let container = NSPersistentContainer(name: managedObjectModelName)

        if storageStrategy == .inMemory {
            container.persistentStoreDescriptions = [inMemoryStoreDescription]
        }

        container.persistentStoreDescriptions.first?.type = storeKind

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


// MARK: - Static Properties
extension CoreDataManager {

    // 📝 Set this in your own app.
    public static var managedObjectModelName = ""

    public static let shared = CoreDataManager(
        managedObjectModelName: managedObjectModelName
    )

    public static let preview = CoreDataManager(
        managedObjectModelName: managedObjectModelName,
        storageStrategy: .inMemory
    )
}
