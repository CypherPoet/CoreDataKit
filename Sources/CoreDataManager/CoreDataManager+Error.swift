import Foundation


extension CoreDataManager {

    public enum Error: Swift.Error {
        case genericSaveFailure(NSError)
        case saveFailureFromMultipleValidationErrors(Array<NSError>)
        case saveFailureFromValidationError(NSError)
        case persistentStoreLoadingFailed(NSError)
        case persistentStoreURLNotFound
        case migrationFailed(PersistentStoreMigrator.Error)
        case unknownError(Swift.Error)
    }
}
