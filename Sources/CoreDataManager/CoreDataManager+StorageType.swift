import Foundation
import CoreData


/// The type of storage to be used by the Persistent Store
///
/// [📝 Apple Docs](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/CoreData/PersistentStoreFeatures.html)
public enum StorageStrategy {
    case persistent
    case inMemory
}


extension StorageStrategy {
    
    public var storeKind: String {
        switch self {
        case .persistent:
            return NSSQLiteStoreType
        case .inMemory:
            return NSInMemoryStoreType
        }
    }
}
