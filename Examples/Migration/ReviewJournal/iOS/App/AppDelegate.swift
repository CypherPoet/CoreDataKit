//
// AppDelegate.swift
// ReviewJournal
//
// Created by CypherPoet on 12/16/20.
// ✌️
//

import UIKit


final class AppDelegate: UIResponder {
    var appStore: AppStore?
}


extension AppDelegate: UIApplicationDelegate {
    
    /// Override point for customization after application launch.
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        appStore?.send(.setupCoreDataStack)
        
        return true
    }
    
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        CoreDataManager.current.saveContexts()
    }
}
