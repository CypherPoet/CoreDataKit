//
// CoreDataManager+Utils.swift
// ExampleApp
//
// Created by CypherPoet on 8/26/20.
// ✌️
//

import Foundation
import CypherPoetCoreDataKit


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
