//
// Review+DisplayUtils.swift
// ReviewJournal
//
// Created by CypherPoet on 12/31/20.
// ✌️
//

import Foundation


extension Review {
    
    var displayedCreationDate: String {
        guard let date = creationDate else { preconditionFailure() }

        return Formatters.Dates.listItemRowView.string(from: date)
    }
    
    
    var latestImageAttachment: ImageAttachment? {
        guard let startingAttachment = imageAttachments?.first else {
            return nil
        }
        
        return imageAttachments?.reduce(startingAttachment) { (latest, current) in
            guard let currentCreationDate = current.creationDate else { return latest }
            
            return latest.creationDate?.compare(currentCreationDate) == .orderedAscending ? latest : current
        }
    }
}
