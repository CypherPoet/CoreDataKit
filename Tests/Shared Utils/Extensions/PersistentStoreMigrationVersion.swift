import Foundation
import CypherPoetCoreDataKit


enum PersistentStoreMigrationVersion: String {
    case version1 = "ReviewJournalTests_v1"
    case version2 = "ReviewJournalTests_v2"
}


// MARK - PersistentStoreVersionLogging
extension PersistentStoreMigrationVersion: PersistentStoreVersionLogging {
    
    var modelSchemaName: String { rawValue }
//    var modelSchemaSubdirectoryName: String { "\(rawValue).momd" }
    var modelSchemaSubdirectoryName: String? { nil }
    

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
