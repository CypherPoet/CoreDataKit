//
//  ExampleApp.swift
//  Shared
//

import SwiftUI


@main
struct ExampleApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @Environment(\.scenePhase) private var scenePhase


    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(\.managedObjectContext, CoreDataManager.shared.mainContext)
        }
        .onChange(of: scenePhase) { newScenePhase in
            if newScenePhase == .background {
                CoreDataManager.shared.saveContexts()
            }
        }
    }
}
