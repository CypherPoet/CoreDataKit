//
// ProcessInfo+Utils.swift
// ExampleApp
//
// Created by CypherPoet on 8/26/20.
// ✌️
//

import Foundation


extension ProcessInfo {

    static var isRunningForXcodePreviews: Bool {
        ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] != nil
    }
}
