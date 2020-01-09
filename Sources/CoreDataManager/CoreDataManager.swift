import Foundation
import CoreData


public final class CoreDataManager {
    public typealias LoadCompletionHandler = (() -> Void)

    private var storeType: String = NSSQLiteStoreType
    
    
    // MARK: - PersistentContainer
    public lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: ManagedObjectModelName.application)
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


// MARK: - Public Methods
extension CoreDataManager {
    
    public func setup(storeType: String = NSSQLiteStoreType, then completionHandler: LoadCompletionHandler? = nil) {
        self.storeType = storeType
        
        loadPersistentStore() {
            completionHandler?()
        }
    }
    
    
    public func save(_ context: NSManagedObjectContext) {
        context.performAndWait {
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    // TODO: Better error handling would be needed here for a production app
                    let nsError = error as NSError
                    print("Error while attempting to save Core Data context named: \"\(context.name ?? "")\": \(nsError), \(nsError.userInfo)")
                }
            }
        }
    }
    
    
    public func saveContexts() {
        [mainContext, backgroundContext].forEach { save($0) }
    }
}
