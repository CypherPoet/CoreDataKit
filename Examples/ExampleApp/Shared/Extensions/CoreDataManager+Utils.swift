//
// CoreDataManager+Utils.swift
// ExampleApp
//
// Created by CypherPoet on 8/26/20.
// ✌️
//

import Foundation
import CypherPoetCoreDataKit


// Expose the `CoreDataManager` type to the rest of our app
typealias CoreDataManager = CypherPoetCoreDataKit.CoreDataManager


extension CoreDataManager {
    static let managedObjectModelName = "ExampleApp"

    static let shared = CoreDataManager(
        managedObjectModelName: CoreDataManager.managedObjectModelName
    )

    static let preview = CoreDataManager(
        managedObjectModelName: CoreDataManager.managedObjectModelName,
        storageType: .inMemory
    )
}
