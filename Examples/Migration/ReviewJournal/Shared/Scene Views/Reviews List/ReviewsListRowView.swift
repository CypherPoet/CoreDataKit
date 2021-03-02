//
// ReviewsListRowView.swift
// ReviewBook
//
// Created by CypherPoet on 12/31/20.
// ✌️
//

import SwiftUI


struct ReviewsListRowView {
    @ObservedObject var review: Review
}


// MARK: - `View` Body
extension ReviewsListRowView: View {

    var body: some View {
        VStack(alignment: .leading) {
            Text(review.title!)
                .font(.headline)
            
            Spacer()
            
            Text(
                """
                Last Modified: \
                \(review.lastModificationDate!, formatter: Formatters.Dates.listItemRowView)
                """
            )
            .font(.caption)
        }
    }
}


// MARK: - Computeds
extension ReviewsListRowView {
}


// MARK: - View Builders
private extension ReviewsListRowView {
}


// MARK: - Private Helpers
private extension ReviewsListRowView {
}


#if DEBUG
// MARK: - Preview
struct ReviewsListRowView_Previews: PreviewProvider {

    static var previews: some View {
        
        List(0 ..< 5) { _ in
            ReviewsListRowView(
                review: PreviewData.Reviews.sample1
            )
            .previewLayout(.sizeThatFits)
        }
    }
}
#endif
