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
//        try super.createDestinationInstances(forSource: sourceEntity, in: mapping, manager: manager)
        
        guard let attributeMappings = mapping.attributeMappings else {
            throw Error.noAttributeMappingsFound
        }
        
        // Get the destination entity
        let destinationImageAttachment = try self.destinationImageAttachment(in: manager.destinationContext, using: mapping)
        
        
        // Traverse property mappings
        for propertyMapping in attributeMappings {
            try migrateValue(
                in: propertyMapping,
                from: sourceEntity,
                to: destinationImageAttachment
            )
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

        // Use the manager to connect the source and destination entities
        manager.associate(
            sourceInstance: sourceEntity,
            withDestinationInstance: destinationImageAttachment,
            for: mapping
        )
    }
    
    
    func migrateValue(
        in propertyMapping: NSPropertyMapping,
        from sourceEntity: NSManagedObject,
        to destinationEntity: NSManagedObject
    ) throws {
        guard let destinationAttributeName = propertyMapping.name else {
            throw Error.noDestinationAttributeNameFound(propertyMapping: propertyMapping)
        }
        
        // 🔑 Even though this is a custom migration, most of the attribute migrations
        // should be performed using the expressions we've defined in the mapping model.
        if let valueExpression = propertyMapping.valueExpression {
            let context: NSMutableDictionary = [
                "source": sourceEntity
            ]
            
            guard let destinationValue = valueExpression.expressionValue(
                with: sourceEntity,
                context: context
            ) else { return }
            
            destinationEntity.setValue(destinationValue, forKey: destinationAttributeName)
        }
    }
    
    
    func destinationImageAttachment(
        in destinationContext: NSManagedObjectContext,
        using mapping: NSEntityMapping
    )  throws -> ImageAttachment {
        guard let entityName = mapping.destinationEntityName else {
            throw Error.failedToFindEntityName
        }

        guard
            let entityDescription = NSEntityDescription.entity(forEntityName: entityName, in: destinationContext)
        else {
            throw Error.failedToMakeDestinationEntityDescription
        }
        
        return ImageAttachment(entity: entityDescription, insertInto: destinationContext)
    }
}



extension ImageAttachmentToImageAttachment_v3_to_v4 {
    
    enum Error: Swift.Error {
        case failedToFindEntityName
        case failedToMakeDestinationEntityDescription
        case noAttributeMappingsFound
        case noDestinationAttributeNameFound(propertyMapping: NSPropertyMapping)
    }
}
