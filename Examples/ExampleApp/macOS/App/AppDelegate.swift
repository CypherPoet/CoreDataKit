//
// AppDelegate.swift
// ExampleApp
//
// Created by CypherPoet on 8/26/20.
// ✌️
//

import Cocoa


final class AppDelegate: NSObject {}


extension AppDelegate: NSApplicationDelegate {

    func applicationDidFinishLaunching(_ notification: Notification) {
        if ProcessInfo.isRunningForXcodePreviews {
            CoreDataManager.preview.setup()
        } else {
            CoreDataManager.shared.setup()
        }
    }
    
    func applicationDidResignActive(_ notification: Notification) {
        CoreDataManager.shared.saveContexts()
    }
}
