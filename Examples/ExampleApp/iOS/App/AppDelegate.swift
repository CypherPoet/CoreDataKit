//
// AppDelegate.swift
// ExampleApp
//
// Created by CypherPoet on 8/26/20.
// ✌️
//

import UIKit


final class AppDelegate: UIResponder {}


extension AppDelegate: UIApplicationDelegate {

    /// Override point for customization after application launch.
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        if ProcessInfo.isRunningForXcodePreviews {
            CoreDataManager.preview.setup()
        } else {
            CoreDataManager.shared.setup()
        }
        
        return true
    }


    func applicationDidEnterBackground(_ application: UIApplication) {
        CoreDataManager.shared.saveContexts()
    }
}
