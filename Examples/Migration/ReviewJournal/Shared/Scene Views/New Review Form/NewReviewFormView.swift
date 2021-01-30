//
// NewReviewFormView.swift
// ReviewBook
//
// Created by CypherPoet on 12/31/20.
// ✌️
//

import SwiftUI
import CypherPoetCoreDataKit
import Combine


struct NewReviewFormView {
    @Environment(\.presentationMode) private var presentationMode
    
    
    // 🔑 Two main concepts being expressed here:
    //
    //      - The `newReview` is a bound `ObservedObject` that's owned elsewhere
    //      and passed in, but ultimately, we can still write to it.
    //      - The `viewModel` is a `StateObject` that's concerned with the "internal
    //      data state" of the view, and thus owned exclusively by it.
    //
    // ... and I think this is fairly logical.
    @ObservedObject var newReview: Review
    @StateObject private var viewModel = ViewModel()
    

    var onSubmit: (Review) -> Void


    @State private var isShowingPhotoPicker = false
}


// MARK: - `View` Body
extension NewReviewFormView: View {
    
    var body: some View {
        Form {
            Section(
                header: Text("Title")
            ) {
                TextField(
                    "Enter A Title",
                    text: Binding($newReview.title, replacingNilWith: "")
                )
            }

            GroupBox {
                Button(
                    action: { isShowingPhotoPicker = true },
                    label: {
                        Label("Select a Photo", systemImage: "camera.circle")
                            .imageScale(.large)
                    }
                )
                .frame(maxWidth: .infinity)
                
                featuredImage.map {
                    Image(uiImage: $0)
                        .resizable()
                        .scaledToFit()
                        .padding(.top)
                }
            }
            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            
            Section(
                header: Text("Description")
            ) {
                TextEditor(
                    text: Binding($newReview.bodyText, replacingNilWith: "")
                )
                .frame(minHeight: 300, idealHeight: 500, maxHeight: .infinity)
            }
        }
        .fullScreenCover(isPresented: $isShowingPhotoPicker, content: {
            PhotoPickerComponent(
                selectionLimit: .max(of: 10),
                onPickingCompleted: viewModel.handlePhotoPickingCompletion(_:)
            )
        })
        .navigationTitle("New Review")
        .toolbar { toolbarContent }
    }
}


// MARK: - Computeds
extension NewReviewFormView {
    
    var canSubmit: Bool {
        newReview.title?.isEmpty == false
    }
    
    
    var featuredImage: UIImage? {
        viewModel.featuredImageData.flatMap { UIImage(data: $0) }
    }
}


// MARK: - View Content Builders
private extension NewReviewFormView {
    
    var toolbarContent: some ToolbarContent {
        Group {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel", action: {
                    presentationMode.wrappedValue.dismiss()
                })
            }
            
            ToolbarItem(placement: .primaryAction) {
                Button("Submit", action: {
                    viewModel.handleSubmit(for: newReview) {
                        presentationMode.wrappedValue.dismiss()
                        onSubmit(newReview)
                    }
                })
                .disabled(canSubmit == false)
            }
        }
    }
}


// MARK: - Private Helpers
private extension NewReviewFormView {
}


#if DEBUG
// MARK: - Preview
struct NewReviewFormView_Previews: PreviewProvider {
    
    static var previews: some View {
        NavigationView {
            NewReviewFormView(
                newReview: Review(context: PreviewData.managedObjectContext),
                onSubmit: { _ in }
            )
        }
        .preferredColorScheme(.dark)
    }
}
#endif
