//
// PersistentStoreMigrationVersion.swift
// ReviewJournal
//
// Created by CypherPoet on 1/24/21.
// ✌️
//

import Foundation
import CoreDataKit


enum PersistentStoreMigrationVersion: String {
    case version1 = "ReviewJournal"
    case version2 = "ReviewJournal v2"
}


// MARK: - PersistentStoreVersionLogging
extension PersistentStoreMigrationVersion: PersistentStoreVersionLogging {
    
    static var persistentContainerName: String { "ReviewJournal" }
    
    var modelSchemaName: String { rawValue }
    

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
