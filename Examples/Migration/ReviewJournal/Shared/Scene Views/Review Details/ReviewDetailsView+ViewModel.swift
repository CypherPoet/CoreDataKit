//
// ReviewDetailsView+ViewModel.swift
// ReviewBook
//
// Created by CypherPoet on 12/31/20.
// ✌️
//

import SwiftUI
import Combine


fileprivate typealias ViewModel = ReviewDetailsView.ViewModel


extension ReviewDetailsView {

    final class ViewModel {
        private var subscriptions = Set<AnyCancellable>()
        
        @ObservedObject var review: Review

        // MARK: - Internal Publishers
//        private lazy var someValuePublisher = makeSomeValuePublisher()

        
        // MARK: - Init
        init(
            review: Review
        ) {
            self.review = review
            
            setupSubscribers()
        }

        // MARK: - Published Outputs
//        @Published var someValue: String = ""
    }
}

extension ViewModel: ObservableObject {}


// MARK: - Computeds
extension ViewModel {
    
    var titleText: String {
        review.title ?? ""
    }
    
    var bodyText: String {
        review.bodyText ?? ""
    }
    
    var images: [UIImage] { review.uiImages }
}


// MARK: - Public Methods
extension ViewModel {
}


// MARK: - Publisher Factories
private extension ViewModel {

//    func makeSomeValuePublisher() -> AnyPublisher<String, Never> {
//        Just("")
//            .eraseToAnyPublisher()
//    }
}


// MARK: - Private Helpers
private extension ViewModel {

    func setupSubscribers() {
//        someValuePublisher
//            .receive(on: DispatchQueue.main)
//            .assign(to: \.someValue, on: self)
//            .store(in: &subscriptions)
    }
}
