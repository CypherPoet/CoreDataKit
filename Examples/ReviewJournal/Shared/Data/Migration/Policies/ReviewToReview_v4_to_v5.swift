//
// ReviewToReview_v4_to_v5.swift
// ReviewJournal
//
// Created by CypherPoet on 2/11/21.
// ✌️
//

import UIKit
import CoreData


/// Main focus:
///     - Add a `uuid` to each `Review` entity.
class ReviewToReview_v4_to_v5: NSEntityMigrationPolicy {
    
    override func createDestinationInstances(
        forSource sourceEntity: NSManagedObject,
        in mapping: NSEntityMapping,
        manager: NSMigrationManager
    ) throws {
        try super.createDestinationInstances(forSource: sourceEntity, in: mapping, manager: manager)
        
        // Get the destination entity
        guard
            let destinationReview = manager
                .destinationInstances(
                    forEntityMappingName: mapping.name,
                    sourceInstances: [sourceEntity]
                )
                .first
        else {
            throw Error.destinationEntityNotFound
        }
        
        destinationReview.setValue(UUID().uuidString, forKey: "uuid")
    }
}


extension ReviewToReview_v4_to_v5 {
    
    enum Error: Swift.Error {
        case destinationEntityNotFound
    }
}
