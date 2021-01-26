//
// PersistentStoreMigrationVersion.swift
// ReviewJournal
//
// Created by CypherPoet on 1/24/21.
// ✌️
//

import Foundation
import CypherPoetCoreDataKit


enum PersistentStoreMigrationVersion: String {
    case version1 = "ReviewJournal"
    case version2 = "ReviewJournal v2"
}


// MARK - PersistentStoreVersionLogging
extension PersistentStoreMigrationVersion: PersistentStoreVersionLogging {
    
    var modelSchemaName: String { rawValue }
//    var modelSchemaSubdirectoryName: String { "\(rawValue).momd" }
//    var modelSchemaSubdirectoryName: String? { nil }
    var modelSchemaSubdirectoryName: String? { "ReviewJournal.momd" }
    

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
