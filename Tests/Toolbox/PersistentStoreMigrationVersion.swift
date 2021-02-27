import Foundation
import CypherPoetCoreDataKit


enum PersistentStoreMigrationVersion: String {
    case version1 = "Model"
    case version2 = "Model v2"
}


// MARK - PersistentStoreVersionLogging
extension PersistentStoreMigrationVersion: PersistentStoreVersionLogging {
    static var persistentContainerName: String { "Model" }

    var modelSchemaName: String { "Model" }
    var modelSchemaSubdirectoryName: String? { "Model" }
    

    // MARK: - Current
    static var currentVersion: Self {
        version1
    }
    

    // MARK: - Migration
    func nextVersion() -> PersistentStoreMigrationVersion? {
        switch self {
        case .version1:
            return .version2
        case .version2:
            return .none
        }
    }
}
