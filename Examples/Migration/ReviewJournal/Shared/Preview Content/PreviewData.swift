//
// PreviewData.swift
// ReviewJournal
//
// Created by CypherPoet on 12/16/20.
// ✌️
//

import Foundation

enum PreviewData {
    static let managedObjectContext = CoreDataManager.current.mainContext
    
    /// Initializes static PreviewData entities
    static func setup() {
        let _: [Any] = [
            PreviewData.Reviews.all,
        ]
    }
    
}
