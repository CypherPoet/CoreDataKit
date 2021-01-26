//
// ReviewsListViewer+ViewModel.swift
// ReviewBook
//
// Created by CypherPoet on 12/30/20.
// ✌️
//

import SwiftUI
import Combine
import CoreData
import CypherPoetCoreDataKit


fileprivate typealias ViewModel = ReviewsListViewer.ViewModel


extension ReviewsListViewer {

    final class ViewModel: NSObject, FetchedResultsControlling, ObservableObject {
        typealias FetchedResult = Review

        let managedObjectContext: NSManagedObjectContext
        var cacheName: String?
        private let coreDataManager: CoreDataManager


        lazy var fetchedResultsController: FetchedResultsController = makeFetchedResultsController(
            // sectionNameKeyPath: #keyPath(Review.categoryName),
            cacheName: cacheName
        )

        var fetchRequest: NSFetchRequest<FetchedResult> {
            didSet {
                NSFetchedResultsController<FetchedResult>.deleteCache(withName: cacheName)
                fetchedResultsController = makeFetchedResultsController()
                fetchedResultsController.delegate = self
                fetchReviews()
            }
        }

        // MARK: - Published Outputs
        @Published var reviews: [FetchedResult] = []


        // MARK: - Init
        init(
            coreDataManager: CoreDataManager = CoreDataManager.current,
            managedObjectContext: NSManagedObjectContext = CoreDataManager.current.mainContext,
            fetchRequest: NSFetchRequest<FetchedResult> = Review.FetchRequests.default(),
            cacheName: String? = nil
        ) {
            self.coreDataManager = coreDataManager
            self.managedObjectContext = managedObjectContext
            self.fetchRequest = fetchRequest
            self.cacheName = cacheName

            super.init()

            self.fetchedResultsController.delegate = self

            fetchReviews()
        }
    }
}


// MARK: - Computeds
extension ViewModel {
}


// MARK: - Public Methods
extension ViewModel {

    func fetchReviews() {
        do {
            try fetchedResultsController.performFetch()
            reviews = extractFirstSectionResults(from: fetchedResultsController)
        } catch {
            print("Fetch Error: \(error.localizedDescription)")
        }
    }
    
    
    func createNewReview(_ review: Review) {
        guard let managedObjectContext = review.managedObjectContext else {
            preconditionFailure()
        }
        
        coreDataManager.save(managedObjectContext)
    }
}


// MARK: - Private Helpers
private extension ViewModel {
}


// MARK: - NSFetchedResultsControllerDelegate
extension ViewModel: NSFetchedResultsControllerDelegate {

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        reviews = extractFirstSectionResults(from: fetchedResultsController)
    }
}
