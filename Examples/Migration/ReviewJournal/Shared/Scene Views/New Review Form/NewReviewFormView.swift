//
// NewReviewFormView.swift
// ReviewBook
//
// Created by CypherPoet on 12/31/20.
// ✌️
//

import SwiftUI
import CypherPoetCoreDataKit


struct NewReviewFormView {
    @Environment(\.managedObjectContext) private var managedObjectContext
    @Environment(\.presentationMode) private var presentationMode
    

    @ObservedObject var newReview: Review
    var onSubmit: (Review) -> Void
    

    @State private var selectedPhotos: [UIImage] = []
    @State private var isShowingPhotoPicker = false
    
}


// MARK: - `View` Body
extension NewReviewFormView: View {
    
    var body: some View {
        Form {
            Section(
                header: Text("Title")
            ) {
                TextField("Enter A Title", text: Binding($newReview.title, replacingNilWith: ""))
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
                
                if let featuredImage = selectedPhotos.first {
                    Image(uiImage: featuredImage)
                        .resizable()
                        .scaledToFit()
                        .padding(.top)
                }
            }
            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            
            Section(
                header: Text("Description")
            ) {
                TextEditor(text: Binding($newReview.bodyText, replacingNilWith: ""))
                    .frame(minHeight: 300, idealHeight: 500, maxHeight: .infinity)
            }
        }
        .sheet(isPresented: $isShowingPhotoPicker, content: {
            PhotoPickerComponent(
                results: $selectedPhotos,
                selectionLimit: .single
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
    
    var featuredImageData: Data? {
        selectedPhotos.first?.pngData()
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
                    if let imageData = featuredImageData {
                        guard let managedObjectContext = newReview.managedObjectContext else {
                            preconditionFailure()
                        }
                        
                        let attachment = ImageAttachment(context: managedObjectContext)
                        
                        attachment.imageData = imageData
                        attachment.review = newReview
                    }
                    
                    onSubmit(newReview)
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
        .environment(\.managedObjectContext, PreviewData.managedObjectContext)
    }
}
#endif
