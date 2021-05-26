//
//  Review+CoreDataProperties.swift
//  ReviewJournal
//
//  Created by Brian Sipple on 1/24/21.
//
//

import Foundation
import CoreData


extension Review {
    @NSManaged public var uuid: String?
    @NSManaged public var bodyText: String?
    @NSManaged public var creationDate: Date?
    @NSManaged public var lastModificationDate: Date?
    @NSManaged public var score: Double
    @NSManaged public var title: String?
    @NSManaged public var imageAttachments: Set<ImageAttachment>?
}


// MARK: Generated accessors for imageAttachments
extension Review {

    @objc(addImageAttachmentsObject:)
    @NSManaged public func addToImageAttachments(_ value: ImageAttachment)

    @objc(removeImageAttachmentsObject:)
    @NSManaged public func removeFromImageAttachments(_ value: ImageAttachment)

    @objc(addImageAttachments:)
    @NSManaged public func addToImageAttachments(_ values: Set<ImageAttachment>)

    @objc(removeImageAttachments:)
    @NSManaged public func removeFromImageAttachments(_ values: Set<ImageAttachment>)
}


extension Review: Identifiable {
    public var id: String { uuid! }
}


// MARK: - Lifecycle Events
extension Review {
    
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        
        setPrimitiveValue(UUID().uuidString, forKey: #keyPath(Review.uuid))
        setPrimitiveValue(Date(), forKey: #keyPath(Review.creationDate))
        stampDate()
    }
    
    
    public override func willSave() {
        super.willSave()
        stampDate()
    }
    
    
    func stampDate() {
        setPrimitiveValue(Date(), forKey: #keyPath(Review.lastModificationDate))
    }
}

