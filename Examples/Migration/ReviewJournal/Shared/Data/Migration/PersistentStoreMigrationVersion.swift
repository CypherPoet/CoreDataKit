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
    case version1 = "ReviewJournal"
    case version2 = "ReviewJournal v2"
    case version3 = "ReviewJournal v3"
    case version4 = "ReviewJournal v4"
}


// MARK - PersistentStoreVersionLogging
extension PersistentStoreMigrationVersion: PersistentStoreVersionLogging {

    static var persistentContainerName: String { "ReviewJournal" }

    var modelSchemaName: String { rawValue }
    

    // MARK: - Current
    static var currentVersion: Self {
        version4
    }
    

    // MARK: - Migration
    func nextVersion() -> PersistentStoreMigrationVersion? {
        switch self {
        case .version1:
            return .version2
        case .version2:
            return .version3
        case .version3:
            return .version4
        case .version4:
            return nil
        }
    }
}
