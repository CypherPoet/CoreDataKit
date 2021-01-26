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
    @NSManaged public var bodyText: String?
    @NSManaged public var creationDate: Date?
    @NSManaged public var lastModificationDate: Date?
    @NSManaged public var score: Double
    @NSManaged public var title: String?
    @NSManaged public var imageData: Data?

}

extension Review: Identifiable {}


// MARK: - Lifecycle Events
extension Review {
    
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        
        setPrimitiveValue(Date(), forKey: #keyPath(Review.creationDate))
        setPrimitiveValue(Date(), forKey: #keyPath(Review.lastModificationDate))
    }
    
    
    public override func willSave() {
        super.willSave()
        
        setPrimitiveValue(Date(), forKey: #keyPath(Review.lastModificationDate))
    }
}

