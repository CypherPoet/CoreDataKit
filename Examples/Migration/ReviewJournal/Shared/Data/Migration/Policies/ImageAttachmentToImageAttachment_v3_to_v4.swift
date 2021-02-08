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
///     - Move the `imageData` from the v3 entity to `image`, `width`, `height`,
///       and `title` properties on the v4 entity.
class ImageAttachmentToImageAttachment_v3_to_v4: NSEntityMigrationPolicy {
    
    static let className = "ImageAttachment"
    
    static func entityDescription(forAttachmentIn context: NSManagedObjectContext) -> NSEntityDescription? {
        NSEntityDescription.entity(forEntityName: className, in: context)
    }
    
    
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
        let destinationImageAttachment = try self.destinationImageAttachment(in: manager)
        
        
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
        in migrationManager: NSMigrationManager
    )  throws -> ImageAttachment {
//        guard let entityName = Self.entityName else {
//            throw Error.failedToMakeEntityName
//        }
//
//        guard let entityDescription = NSEntityDescription.entity(
//            forEntityName: entityName,
//            in: migrationManager.destinationContext
//        ) else {
//            throw Error.failedToMakeDestinationEntityDescription
//        }
        guard
            let entityDescription = Self.entityDescription(forAttachmentIn: migrationManager.destinationContext)
        else {
            throw Error.failedToMakeDestinationEntityDescription
        }
        
        
        return ImageAttachment(entity: entityDescription, insertInto: migrationManager.destinationContext)
    }
}



extension ImageAttachmentToImageAttachment_v3_to_v4 {
    
    enum Error: Swift.Error {
        case failedToMakeEntityName
        case failedToMakeDestinationEntityDescription
        case noAttributeMappingsFound
        case noDestinationAttributeNameFound(propertyMapping: NSPropertyMapping)
    }
}
