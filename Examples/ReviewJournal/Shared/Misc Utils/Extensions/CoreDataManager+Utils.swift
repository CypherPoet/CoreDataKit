//
// CoreDataManager+Utils.swift
// ReviewJournal
//
// Created by CypherPoet on 1/24/21.
// ✌️
//


import Foundation
import CoreDataKit


// Syntactic sugar for our specialized `CoreDataManager` type that
// can then be used throughout the app.
typealias CoreDataManager = CoreDataKit.CoreDataManager<PersistentStoreMigrationVersion>


extension CoreDataManager {
    private static let `default` = CoreDataManager()

    private static let preview = CoreDataManager(
        storageStrategy: .inMemory
    )
    
    static var current: CoreDataManager {
        ProcessInfo.isRunningForXcodePreviews ? .preview : .default
    }
}
