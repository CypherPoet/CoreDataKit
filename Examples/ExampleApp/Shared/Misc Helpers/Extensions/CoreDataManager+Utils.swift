//
// CoreDataManager+Utils.swift
// ExampleApp
//
// Created by CypherPoet on 8/26/20.
// ✌️
//

import Foundation
import CoreDataKit


// Expose the `CoreDataManager` type to the rest of our app
typealias CoreDataManager = CoreDataKit.CoreDataManager


extension CoreDataManager {
    static let managedObjectModelName = "ExampleApp"
}
