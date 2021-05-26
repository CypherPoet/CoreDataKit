//
// AppStore.swift
// Shared
//
// Created by CypherPoet on 11/23/20.
// ✌️
//

import Foundation
import CypherPoetReduxUtils


typealias AppStore = Store<AppState, AppState.Action>


extension AppStore {
    
    static let `default` = AppStore(
        initialState: .init(),
        reducer: AppState.defaultReducer,
        middlewareRunners: [
            AppState.LoggingMiddleware.make().runner,
            AppState.CoreDataStackMiddleware.make().runner,
        ]
    )
}
