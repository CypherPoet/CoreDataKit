import Foundation
import CoreData
import Combine


public final class CoreDataManager {
    public typealias LoadCompletionHandler = (() -> Void)

    private var managedObjectModelName: String
    private var storageType: StorageType


    // MARK: - PersistentContainer
    public lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: managedObjectModelName)

        if storageType == .inMemory {
            container.persistentStoreDescriptions = [inMemoryStoreDescription]
        }

        container.persistentStoreDescriptions.first?.type = storeType

        return container
    }()


    // MARK: - Managed Object Contexts
    public lazy var backgroundContext: NSManagedObjectContext = {
        let context = self.persistentContainer.newBackgroundContext()
        
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy

        return context
    }()
    
    
    public lazy var mainContext: NSManagedObjectContext = {
        let context = self.persistentContainer.viewContext
        
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        context.automaticallyMergesChangesFromParent = true
        context.shouldDeleteInaccessibleFaults = true
        
        return context
    }()
    
    
    // MARK: - Init
    public init(
        managedObjectModelName: String,
        storageType: StorageType = .persistent
    ) {
        self.managedObjectModelName = managedObjectModelName
        self.storageType = storageType
    }
}


// MARK: - Computeds
extension CoreDataManager {

    var storeType: String {
        switch storageType {
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


// MARK: - Public Methods
extension CoreDataManager {
    
    public func setup(then completionHandler: LoadCompletionHandler? = nil) {
        loadPersistentStore() {
            completionHandler?()
        }
    }
    
    
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
