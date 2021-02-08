//
// Review+DisplayUtils.swift
// ReviewJournal
//
// Created by CypherPoet on 12/31/20.
// ✌️
//

import Foundation
import UIKit


extension Review {
    
    var displayedCreationDate: String {
        guard let date = creationDate else { preconditionFailure() }

        return Formatters.Dates.listItemRowView.string(from: date)
    }
    
    
    var uiImages: [UIImage] {
        guard let imageAttachments = imageAttachments else {
            return []
        }
        
        return imageAttachments.compactMap { UIImage(data: $0.imageData ?? Data()) }
    }
    
    
    var latestImageAttachment: ImageAttachment? {
        guard
            let imageAttachments = imageAttachments,
            let startingAttachment = imageAttachments.first
        else {
            return nil
        }
        
        return imageAttachments.reduce(startingAttachment) { (latest, current) in
            latest
                .creationDate
                .compare(current.creationDate) == .orderedAscending ?
                    latest
                    : current
        }
    }
}
