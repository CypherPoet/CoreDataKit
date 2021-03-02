//
// AppDelegate.swift
// ReviewJournal
//
// Created by CypherPoet on 12/16/20.
// ✌️
//

import Cocoa


final class AppDelegate: NSObject {
    var appStore: AppStore?
}


extension AppDelegate: NSApplicationDelegate {

    func applicationDidFinishLaunching(_ notification: Notification) {
        appStore?.send(.setupCoreDataStack)
        
        if ProcessInfo.isRunningForXcodePreviews {
            PreviewData.setup()
        }
    }
    
    
    func applicationDidResignActive(_ notification: Notification) {
        CoreDataManager.current.saveContexts()
    }
}
