import Foundation
import CoreData



public typealias PersistentStoreMetaData = [String: Any]


extension NSPersistentStoreCoordinator {
    
    public static func metadata(
        forStoreAt storeURL: URL,
        using storageStrategy: StorageStrategy = .persistent
    ) -> PersistentStoreMetaData?  {
        try? NSPersistentStoreCoordinator.metadataForPersistentStore(
            ofType: storageStrategy.storeKind.rawValue,
            at: storeURL,
            options: nil
        )
    }
    
    
    public static func replaceStore(
        at targetURL: URL,
        withStoreAt sourceURL: URL,
        using storageStrategy: StorageStrategy = .persistent
    ) throws {
        print("ReplaceStore::targetURL:\(targetURL)")
        print("ReplaceStore::sourceURL:\(sourceURL)")
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: NSManagedObjectModel())
        
        try persistentStoreCoordinator.replacePersistentStore(
            at: targetURL,
            destinationOptions: nil,
            withPersistentStoreFrom: sourceURL,
            sourceOptions: nil,
            ofType: storageStrategy.storeKind.rawValue
        )
    }
    
    
    public static func destroyStore(
        at targetURL: URL,
        using storageStrategy: StorageStrategy = .persistent
    ) throws {
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: NSManagedObjectModel())
        
        try persistentStoreCoordinator.destroyPersistentStore(
            at: targetURL,
            ofType: storageStrategy.storeKind.rawValue,
            options: nil
        )
    }
}
