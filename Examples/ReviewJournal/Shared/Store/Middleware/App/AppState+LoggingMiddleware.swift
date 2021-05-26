//
// AppState+LoggingMiddleware.swift
// Shared
//
// Created by CypherPoet on 12/1/20.
// ✌️
//

import Foundation
import Combine
import CypherPoetReduxUtils


extension AppState {
    
    struct LoggingMiddleware {
        var runner: Middleware<AppState, AppState.Action>
        

        static func make() -> Self {
            Self { state, action -> AnyPublisher<AppState.Action, Never>? in
                print("Triggered action: \(action)")

                return Empty().eraseToAnyPublisher()
            }
        }
    }
}
