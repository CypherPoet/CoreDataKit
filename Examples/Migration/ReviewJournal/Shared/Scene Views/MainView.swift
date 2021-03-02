//
// MainView.swift
// ReviewJournal
//
// Created by CypherPoet on 12/30/20.
// ✌️
//

import SwiftUI


struct MainView {
    @Environment(\.managedObjectContext) private var managedObjectContext
}


// MARK: - `View` Body
extension MainView: View {

    var body: some View {
        NavigationView {
            ReviewsListViewer()
        }
    }
}


// MARK: - Computeds
extension MainView {
}


// MARK: - View Builders
private extension MainView {
}


// MARK: - Private Helpers
private extension MainView {
}


#if DEBUG
// MARK: - Preview
struct MainView_Previews: PreviewProvider {

    static var previews: some View {
        MainView()
            .environment(\.managedObjectContext, PreviewData.managedObjectContext)
    }
}
#endif
