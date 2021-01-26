//
//  ReviewJournalApp.swift
//  Shared
//
//  Created by CypherPoet on 1/24/21.
//

import SwiftUI

@main
struct ReviewJournalApp: App {
    
    #if os(macOS)
    
    @NSApplicationDelegateAdaptor(AppDelegate.self)
    var appDelegate
    
    #else
    
    @UIApplicationDelegateAdaptor(AppDelegate.self)
    var appDelegate
    
    #endif
    
    
    @StateObject private var appStore: AppStore
    @Environment(\.scenePhase) private var scenePhase

    
    init() {
        let appStore = AppStore.default
        
        _appDelegate = .init(AppDelegate.self)
        _appDelegate.wrappedValue.appStore = appStore
        _appStore = .init(wrappedValue: appStore)
    }
    
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(appStore)
        }
        .onChange(of: scenePhase) { newScenePhase in
            switch newScenePhase {
            case .background:
                CoreDataManager.current.saveContexts()
            case .inactive:
                break
            case .active:
                if appStore.state.isFirstRunOfApp {
                    appStore.send(.firstRunCompleted)
                }
            @unknown default:
                break
            }
        }
    }
}
