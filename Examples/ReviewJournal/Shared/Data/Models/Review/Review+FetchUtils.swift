//
// Review+FetchUtils.swift
// ReviewJournal
//
// Created by CypherPoet on 12/31/20.
// ✌️
//



import Foundation
import CoreData
import CoreDataKit


// MARK: - Predicates
extension Review {

    public enum Predicates {

//        public static let favorites: NSPredicate = {
//            let keyword = NSComparisonPredicate.keyword(for: .equalTo)
//            let formatSpecifier = NSPredicate.FormatSpecifiers.object
//
//            return NSPredicate(
//                format: "%K \(keyword) \(formatSpecifier)",
//                #keyPath(Review.isFavorite),
//                NSNumber(booleanLiteral: true)
//            )
//        }()
    }
}


// MARK: - SortDescriptors
extension Review {

    // 💡 An instance of `NSFetchedResultsController`, or an `NSFetchRequestResult` created by
    // SwiftUI's `@FetchRequest` property wrapper, requires a fetch request with sort descriptors.

    public enum SortDescriptors {

        public static let titleAscending: NSSortDescriptor = NSSortDescriptor(
            key: #keyPath(Review.title),
            ascending: true,

            // 🔑 Any time you’re sorting user-facing strings,
            // Apple recommends that you pass in `NSString.localizedStandardCompare(_:)`
            // to sort according to the language rules of the current locale.
            // This means sort will “just work” and do the right thing for
            // languages with special character.
            selector: #selector(NSString.localizedStandardCompare(_:))
        )


        public static let nameDescending: NSSortDescriptor = {
            guard let descriptor = titleAscending.reversedSortDescriptor as? NSSortDescriptor else {
                preconditionFailure("Unable to make reversed sort descriptor")
            }

            return descriptor
        }()
    }
}


// MARK: - FetchRequests
extension Review {

    public enum FetchRequests {

        public static func baseFetchRequest<Review>() -> NSFetchRequest<Review> {
            NSFetchRequest<Review>(entityName: "Review")
        }


        public static func `default`() -> NSFetchRequest<Review> {
            let request: NSFetchRequest<Review> = baseFetchRequest()

            request.sortDescriptors = [Review.SortDescriptors.titleAscending]
            request.predicate = nil

            return request
        }
    }
}
