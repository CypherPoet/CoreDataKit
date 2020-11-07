//
//  ExampleApp.swift
//  Shared
//

import SwiftUI


@main
struct ExampleApp: App {
    #if os(macOS)
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    #else
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    #endif
    
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
