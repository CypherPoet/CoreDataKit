import Foundation
import CoreData
import Combine


public final class CoreDataManager {
    public typealias LoadCompletionHandler = (() -> Void)

    private var managedObjectModelName: String
    private var storeType: String = NSSQLiteStoreType
    
    
    // MARK: - PersistentContainer
    public lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: managedObjectModelName)
        let description = container.persistentStoreDescriptions.first
        
        description?.type = storeType
        
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
        storeType: String = NSSQLiteStoreType
    ) {
        self.managedObjectModelName = managedObjectModelName
        self.storeType = storeType
    }
}


// MARK: - Private Methods
extension CoreDataManager {
    
    private func loadPersistentStore(then completionHandler: @escaping LoadCompletionHandler) {
        persistentContainer.loadPersistentStores { description, error in
            guard error == nil else {
                fatalError("Error while loading store: \(error!)")
            }
            
            completionHandler()
        }
    }
}

// MARK: - Error
extension CoreDataManager {
    public enum Error: Swift.Error {
        case saveFailed(NSError)
    }
}



// MARK: - Public Methods
extension CoreDataManager {
    
    public func setup(then completionHandler: LoadCompletionHandler? = nil) {
        loadPersistentStore() {
            completionHandler?()
        }
    }
    
    
    public func save(_ context: NSManagedObjectContext) -> Future<Void, Error> {
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

    
    public func saveContexts() -> Future<Void, Error> {
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
