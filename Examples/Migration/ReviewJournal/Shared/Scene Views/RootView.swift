//
// RootView.swift
// ReviewJournal
//
// Created by CypherPoet on 12/29/20.
// ✌️
//

import SwiftUI


struct RootView {
    @EnvironmentObject private var appStore: AppStore
}


// MARK: - `View` Body
extension RootView: View {

    var body: some View {
        switch appStore.state.coreDataSetupState {
        case .idle:
            EmptyView()
        case .inProgress:
            Text("Setting up Core Data")
        case .failed(let error):
            Text("Error while setting up Core Data")
            Text(error.localizedDescription)
        case .completed:
            MainView()
                .environment(\.managedObjectContext, CoreDataManager.current.mainContext)
        }
    }
}


// MARK: - Computeds
extension RootView {
}


// MARK: - View Builders
private extension RootView {
}


// MARK: - Private Helpers
private extension RootView {
}


#if DEBUG
// MARK: - Preview
struct RootView_Previews: PreviewProvider {

    static var previews: some View {
        RootView()
    }
}
#endif
