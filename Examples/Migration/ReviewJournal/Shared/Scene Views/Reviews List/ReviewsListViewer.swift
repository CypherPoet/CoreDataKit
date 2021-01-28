//
// ReviewsListViewer.swift
// ReviewBook
//
// Created by CypherPoet on 12/30/20.
// ✌️
//

import SwiftUI


struct ReviewsListViewer {
    @Environment(\.managedObjectContext) private var managedObjectContext

    @StateObject private var viewModel = ViewModel()
    @State private var isShowingNewReviewSheet = false
}


// MARK: - `View` Body
extension ReviewsListViewer: View {
    
    var body: some View {
        Group {
            if viewModel.displayedReviews.isEmpty {
                emptyStateView
            } else {
                ReviewsListView(
                    reviews: viewModel.displayedReviews,
                    buildDestination: buildDestination(for:)
                )
                .listStyle(PlainListStyle())
            }
        }
        .toolbar { toolbarContent }
        .navigationTitle("Reviews")
        .sheet(
            isPresented: $isShowingNewReviewSheet,
            onDismiss: {
                viewModel.newReviewForForm = nil
            },
            content: {
            NavigationView {
                NewReviewFormView(
                    newReview: viewModel.newReviewForForm!,
                    onSubmit: viewModel.createNewReview(_:)
                )
            }
            .environment(\.managedObjectContext, CoreDataManager.current.backgroundContext)
        })
        .onAppear(perform: viewModel.fetchReviews)
        .onReceive(viewModel.$newReviewForForm, perform: { newReview in
            isShowingNewReviewSheet = newReview != nil
        })
    }
}


// MARK: - Computeds
extension ReviewsListViewer {
}


// MARK: - View Content Builders
private extension ReviewsListViewer {
    
    var emptyStateView: some View {
        Text("No Reviews Yet")
            .font(.largeTitle)
    }
    
    var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .primaryAction) {
            Button(
                action: {
//                    isShowingNewReviewSheet = true
                    viewModel.setupNewReviewForForm()
                },
                label: {
                    Label("Create a new Review", systemImage: "plus")
                        .labelStyle(IconOnlyLabelStyle())
                }
            )
        }
    }
}


// MARK: - Private Helpers
private extension ReviewsListViewer {
    
    func buildDestination(for review: Review) -> some View {
        ReviewDetailsView(viewModel: .init(review: review))
    }
}



#if DEBUG
// MARK: - Preview
struct ReviewsListViewer_Previews: PreviewProvider {
    
    static var previews: some View {
        let _ = PreviewData.Reviews.all
        
        return NavigationView {
            ReviewsListViewer()
                .environment(\.managedObjectContext, PreviewData.managedObjectContext)
        }
    }
}
#endif
