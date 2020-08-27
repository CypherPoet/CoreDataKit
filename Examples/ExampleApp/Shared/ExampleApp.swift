//
//  ExampleApp.swift
//  Shared
//
//  Created by Brian Sipple on 8/26/20.
//

import SwiftUI
import CypherPoetCoreDataKit


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
