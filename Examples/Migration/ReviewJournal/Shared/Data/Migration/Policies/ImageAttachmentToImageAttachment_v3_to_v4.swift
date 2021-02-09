//
// ImageAttachmentToImageAttachment_v3_to_v4.swift
// ReviewJournal
//
// Created by CypherPoet on 1/30/21.
// ✌️
//

import UIKit
import CoreData


/// Main focus:
///     - Create extra `width`, `height`, and `title` properties on the v4 entity.
class ImageAttachmentToImageAttachment_v3_to_v4: NSEntityMigrationPolicy {
    
    override func createDestinationInstances(
        forSource sourceEntity: NSManagedObject,
        in mapping: NSEntityMapping,
        manager: NSMigrationManager
    ) throws {
        try super.createDestinationInstances(forSource: sourceEntity, in: mapping, manager: manager)
        
        // Get the destination entity
        guard
            let destinationImageAttachment = manager
                .destinationInstances(
                    forEntityMappingName: mapping.name,
                    sourceInstances: [sourceEntity]
                )
                .first
        else {
            throw Error.destinationEntityNotFound
        }
        

        // Grab image-related properties
        if
            let sourceImageData = sourceEntity.value(forKey: "imageData") as? Data,
            let sourceImage = UIImage(data: sourceImageData)
        {
            destinationImageAttachment.setValue(Float(sourceImage.size.width), forKey: "width")
            destinationImageAttachment.setValue(Float(sourceImage.size.height), forKey: "height")
        }
        
        // Use review body text for the image title
        let reviewBodyText = sourceEntity.value(forKeyPath: "review.bodyText") as? String ?? ""
        
        destinationImageAttachment.setValue(
            reviewBodyText.prefix(80),
            forKey: "title"
        )
    }
}



extension ImageAttachmentToImageAttachment_v3_to_v4 {
    
    enum Error: Swift.Error {
        case destinationEntityNotFound
    }
}
