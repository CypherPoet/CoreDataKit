import Foundation


extension CoreDataManager {

    public enum Error: Swift.Error {
        case saveFailed(NSError)
        case persistentStoreLoadingFailed(NSError)
        case persistentStoreURLNotFound
        case migrationFailed(PersistentStoreMigrator.Error)
        case unknownError(Swift.Error)
    }
    
}
