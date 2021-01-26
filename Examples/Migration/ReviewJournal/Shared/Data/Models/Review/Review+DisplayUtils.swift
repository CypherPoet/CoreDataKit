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
}
