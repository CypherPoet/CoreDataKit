//
// ReviewDetailsView.swift
// ReviewBook
//
// Created by CypherPoet on 12/31/20.
// ✌️
//

import SwiftUI


struct ReviewDetailsView {
    @ObservedObject var viewModel: ViewModel
}


// MARK: - `View` Body
extension ReviewDetailsView: View {
    
    var body: some View {
        ZStack(alignment: .bottom) {
            backgroundContent
                .edgesIgnoringSafeArea(.all)
            
            foregroundContent
                .padding(.vertical)
        }
        .navigationTitle(viewModel.titleText)
    }
}


// MARK: - Computeds
extension ReviewDetailsView {
    
}


// MARK: - View Builders
private extension ReviewDetailsView {
    
    var backgroundContent: some View {
        LinearGradient(
            gradient: Gradient(
                colors: [
                    Color(#colorLiteral(red: 0.9991074204, green: 0.3845782578, blue: 0.5377081633, alpha: 1)).opacity(0.3),
                    Color(#colorLiteral(red: 0.9991074204, green: 0.3845782578, blue: 0.5377081633, alpha: 1)),
                    Color(#colorLiteral(red: 0.6954901814, green: 0.6699760556, blue: 1, alpha: 1)),
                    Color(#colorLiteral(red: 0.6954901814, green: 0.6699760556, blue: 1, alpha: 1)).opacity(0.3),
                ]
            ),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    
    var foregroundContent: some View {
        ScrollView {
            VStack {
                Text(viewModel.bodyText)
                
                if viewModel.images.isEmpty == false {
                    ImageCarouselView(images: viewModel.images)
                        .frame(minHeight: 200, idealHeight: 280, maxHeight: 360)
                }
            }
        }
    }
}


// MARK: - Private Helpers
private extension ReviewDetailsView {
}


#if DEBUG
// MARK: - Preview
struct ReviewDetailsView_Previews: PreviewProvider {
    
    static var previews: some View {
        NavigationView {
            ReviewDetailsView(
                viewModel: .init(review: PreviewData.Reviews.sample1)
            )
        }
    }
}
#endif
