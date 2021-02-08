//
//  ImageAttachment+CoreDataProperties.swift
//  ReviewJournal
//
//  Created by Brian Sipple on 1/27/21.
//
//

import Foundation
import CoreData
import UIKit


extension ImageAttachment {
    @NSManaged public var imageData: Data?
    @NSManaged public var width: Float
    @NSManaged public var height: Float
    @NSManaged public var review: Review?
}


extension ImageAttachment: ReviewAttachable {
    @NSManaged public var creationDate: Date
    @NSManaged public var title: String
}


extension ImageAttachment: Identifiable {}


// MARK: - Lifecycle Events
extension ImageAttachment {
    
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        
        setPrimitiveValue(Date(), forKey: #keyPath(ImageAttachment.creationDate))
    }
}

