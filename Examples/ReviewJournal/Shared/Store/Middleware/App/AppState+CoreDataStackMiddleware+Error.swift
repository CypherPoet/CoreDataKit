//
// AppState+CoreDataStackMiddleware.swift
// Shared
//
// Created by CypherPoet on 11/23/20.
// ✌️
//

// 📝 Adding this layer is a good way to expose an error interface to the `State`
// types using our middleware -- while also adopting `LocalizedError` to
// define more descriptive, potentially-user-facing descriptions.


import Foundation
import CoreDataKit


extension AppState.CoreDataStackMiddleware {

    enum Error: Swift.Error {
        case coreDataManagerError(CoreDataManager.Error)
    }
}


extension AppState.CoreDataStackMiddleware.Error: Identifiable {
    var id: UUID { .init() }
}


extension AppState.CoreDataStackMiddleware.Error: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .coreDataManagerError(let error):
            switch error {
            case .migrationFailed(let persistentStoreMigratorError):
                return NSLocalizedString(
                    "Failed to migrate persistent stores. Error: \(persistentStoreMigratorError.localizedDescription)",
                    comment: ""
                )
            case .persistentStoreURLNotFound:
                return NSLocalizedString(
                    "(persistentStoreURLNotFound) Failed to find persistent store",
                    comment: ""
                )
            case .saveFailed(let error):
                return NSLocalizedString(
                    "(saveFailed) An error occurred while setting up the app's data store: \(error.localizedDescription)",
                    comment: ""
                )
            case .persistentStoreLoadingFailed(let error):
                return NSLocalizedString(
                    "(persistentStoreLoadingFailed) An error occurred while setting up the app's data store: \(error.localizedDescription)",
                    comment: ""
                )
            case .unknownError(let error):
                return NSLocalizedString(
                    "(unknownError) An error occurred while setting up the app's data store: \(error.localizedDescription)",
                    comment: ""
                )
            }
        }
    }
}
