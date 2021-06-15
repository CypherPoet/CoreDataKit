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
            
            // 📝 While undocumented, using `NSInMemoryStoreType` now appears to
            // be deprecated in favor of using an SQLite store that writes to /dev/null.
            //
            // See:
            //  - https://twitter.com/sowenjub/status/1376653234140512259
            //  - https://www.donnywals.com/setting-up-a-core-data-store-for-unit-tests/
            //  - https://useyourloaf.com/blog/core-data-in-memory-store/
            //  - https://twitter.com/DonnyWals/status/1290591660578156544
            
//            return NSInMemoryStoreType
            return NSSQLiteStoreType
        }
    }
}
