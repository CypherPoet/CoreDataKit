//
//  ImageAttachment+CoreDataProperties.swift
//  ReviewJournal
//
//  Created by Brian Sipple on 1/27/21.
//
//

import Foundation
import CoreData


extension ImageAttachment {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ImageAttachment> {
        return NSFetchRequest<ImageAttachment>(entityName: "ImageAttachment")
    }

    @NSManaged public var creationDate: Date?
    @NSManaged public var imageData: Data?
    @NSManaged public var title: String?
    @NSManaged public var review: Review?

}

extension ImageAttachment: Identifiable {}


// MARK: - Lifecycle Events
extension ImageAttachment {
    
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        
        setPrimitiveValue(Date(), forKey: #keyPath(ImageAttachment.creationDate))
    }
}

