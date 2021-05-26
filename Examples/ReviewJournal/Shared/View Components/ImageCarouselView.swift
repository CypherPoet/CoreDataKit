//
// ImageCarouselView.swift
// ReviewJournal
//
// Created by CypherPoet on 2/3/21.
// ✌️
//

import SwiftUI


struct ImageCarouselView {
    var images: [UIImage]

}


// MARK: - `View` Body
extension ImageCarouselView: View {

    var body: some View {
        TabView {
            ForEach(0..<images.count, id: \.self) { index in
                Image(uiImage: images[index])
                    .resizable()
                    .scaledToFit()
            }
            .padding(.vertical)
        }
        .tabViewStyle(PageTabViewStyle())
    }
}


// MARK: - Computeds
extension ImageCarouselView {
}


// MARK: - View Content Builders
private extension ImageCarouselView {
}


// MARK: - Private Helpers
private extension ImageCarouselView {
}


#if DEBUG
// MARK: - Preview
struct ImageCarouselView_Previews: PreviewProvider {

    static var previews: some View {
        ImageCarouselView(
            images: [
                UIImage(named: "swift-logo")!,
                UIImage(named: "swift-logo")!,
            ]
        )
        .frame(minHeight: 200, idealHeight: 280, maxHeight: 360)
    }
}
#endif
