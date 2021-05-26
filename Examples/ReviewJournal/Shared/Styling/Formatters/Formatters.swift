//
// Formatters.swift
// ReviewJournal
//
// Created by CypherPoet on 12/31/20.
// ✌️
//

import Foundation


enum Formatters {
    
    enum Dates {
        static let listItemRowView: DateFormatter = {
            let formatter = DateFormatter()
            
            formatter.setLocalizedDateFormatFromTemplate("dMMMy")
            
            return formatter
        }()
    }
}
