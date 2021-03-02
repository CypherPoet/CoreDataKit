//
// ProcessInfo+Utils.swift
// ReviewJournal
//
// Created by CypherPoet on 1/24/21.
// ✌️
//

import Foundation


extension ProcessInfo {

    static var isRunningForXcodePreviews: Bool {
        ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] != nil
    }
}
