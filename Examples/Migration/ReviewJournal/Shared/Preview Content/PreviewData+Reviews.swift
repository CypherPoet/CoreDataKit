//
// PreviewData+Reviews.swift
// ReviewJournal
//
// Created by CypherPoet on 12/31/20.
// ✌️
//

import Foundation


extension PreviewData {
    
    enum Reviews {
        
        static let sample1: Review = {
            defer { try! managedObjectContext.save() }
            
            let review = Review(context: managedObjectContext)
            
            review.title = "Review 1"
            
            return review
        }()
        
        
        static let sample2: Review = {
            defer { try! managedObjectContext.save() }
            
            let review = Review(context: managedObjectContext)
            
            review.title = "Review 2"
            
            return review
        }()
        
        
        static let all: [Review] = {
            defer { try! managedObjectContext.save() }
            
            return [
                Reviews.sample1,
                Reviews.sample2,
            ]
        }()
    }
}
