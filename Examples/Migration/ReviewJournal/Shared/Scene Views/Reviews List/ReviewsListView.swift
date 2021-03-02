//
// ReviewsListView.swift
// ReviewBook
//
// Created by CypherPoet on 12/31/20.
// ✌️
//

import SwiftUI


struct ReviewsListView<Destination: View> {
    var reviews: [Review]
    var buildDestination: ((Review) -> Destination)
}


// MARK: - `View` Body
extension ReviewsListView: View {

    var body: some View {
        List(reviews) { review in
            NavigationLink(
                destination: buildDestination(review),
                label: {
                    ReviewsListRowView(review: review)
                        .foregroundColor(.primary)
                }
            )
            .foregroundColor(.primary)
        }
    }
}


// MARK: - Computeds
extension ReviewsListView {
}


// MARK: - View Builders
private extension ReviewsListView {
}


// MARK: - Private Helpers
private extension ReviewsListView {
}


#if DEBUG
// MARK: - Preview
struct ReviewsListView_Previews: PreviewProvider {

    static var previews: some View {
        ReviewsListView(
            reviews: PreviewData.Reviews.all,
            buildDestination: { _ in Text("Review Details") }
        )
    }
}
#endif
