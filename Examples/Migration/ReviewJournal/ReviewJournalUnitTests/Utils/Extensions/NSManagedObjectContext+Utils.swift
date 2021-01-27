//
// NSManagedObjectContext+Utils.swift
// ReviewJournal
//
// Created by CypherPoet on 1/25/21.
// ✌️
//

import Foundation
import CoreData

extension NSManagedObjectContext {
    
    convenience init(for model: NSManagedObjectModel, at storeURL: URL) {
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        try! persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
        
        self.init(concurrencyType: .mainQueueConcurrencyType)
        
        self.persistentStoreCoordinator = persistentStoreCoordinator
    }
    
    
    func destroyStores() throws {
        guard let persistentStoreCoordinator = persistentStoreCoordinator else { return }
        
        for store in persistentStoreCoordinator.persistentStores {
            try! persistentStoreCoordinator.remove(store)
            try! persistentStoreCoordinator.destroyPersistentStore(
                at: store.url!,
                ofType: store.type,
                options: nil
            )
        }
    }
}
