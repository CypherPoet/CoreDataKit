import Foundation


extension PersistentStoreMigrator {
    
    public enum Error: Swift.Error {
        case unknownStoreVersionAtURL(url: URL)
        case forcedWALCheckpointingFailed(error: Swift.Error)
        case migrationStepConstructionFailed(error: Swift.Error)
        case persistentStoreReplacementFailed(error: Swift.Error)
        case persistentStoreDestructionFailed(error: Swift.Error)
        case migrationFailedAtStep(PersistentStoreMigrationStep)
    }
}
