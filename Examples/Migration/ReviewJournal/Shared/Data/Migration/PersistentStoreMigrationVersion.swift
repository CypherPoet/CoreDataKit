//
// PersistentStoreMigrationVersion.swift
// ReviewJournal
//
// Created by CypherPoet on 1/20/21.
// ✌️
//

import Foundation
import CypherPoetCoreDataKit


enum PersistentStoreMigrationVersion: String {
    case version1 = "ReviewJournal_v1"
    case version2 = "ReviewJournal_v2"
}


// MARK - PersistentStoreVersionLogging
extension PersistentStoreMigrationVersion: PersistentStoreVersionLogging {
    
    var modelSchemaName: String { "ReviewJournal" }
    var modelSchemaSubdirectoryName: String? { "\(modelSchemaName).momd" }
    

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
            return nil
        }
    }
}
