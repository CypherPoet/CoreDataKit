//
// CoreDataManager+Utils.swift
// ReviewJournal
//
// Created by CypherPoet on 1/24/21.
// ✌️
//


import Foundation
import CypherPoetCoreDataKit


// Syntactic sugar for our app's specialized `CoreDataManager` type that
// can be used throughout.
typealias CoreDataManager = CypherPoetCoreDataKit.CoreDataManager<PersistentStoreMigrationVersion>


extension CoreDataManager {
    private static let `default` = CoreDataManager()

    private static let preview = CoreDataManager(
        storageStrategy: .inMemory
    )
    
    static var current: CoreDataManager {
        ProcessInfo.isRunningForXcodePreviews ? .preview : .default
    }
}
