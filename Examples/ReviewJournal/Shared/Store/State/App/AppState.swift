//
// AppState.swift
// Shared
//
// Created by CypherPoet on 11/23/20.
// ✌️
//


import Foundation
import SwiftUI
import CypherPoetReduxUtils
import CypherPoetCoreDataKit


struct AppState {
    @AppStorage("isFirstRunOfApp") var isFirstRunOfApp: Bool = true
    
    var coreDataSetupState: CoreDataSetupState = .idle
}


// MARK: - Actions (Inspired by https://redux.js.org/basics/actions)
extension AppState {

    enum Action {
        // MARK: -  Actions For Nested States


        // MARK: -  Actions with Side Effects
        case setupCoreDataStack
        

        // MARK: -  Actions without Side Effects
        case firstRunCompleted
        case coreDataSetupCompleted
        case coreDataSetupFailed(CoreDataStackMiddleware.Error)
    }
}


// MARK: - Default Reducer
extension AppState {

    static let defaultReducer = Reducer<AppState, AppState.Action>(
        reduce: { (appState, appAction) -> Void in
            switch appAction {
            case .firstRunCompleted:
                appState.isFirstRunOfApp = false
            case .coreDataSetupCompleted:
                appState.coreDataSetupState = .completed
            case .coreDataSetupFailed(let error):
                appState.coreDataSetupState = .failed(error)
            case .setupCoreDataStack:
                appState.coreDataSetupState = .inProgress
            }
        }
    )
}


extension AppState {
    
    enum CoreDataSetupState {
        case idle
        case inProgress
        case failed(Error)
        case completed
    }
}
