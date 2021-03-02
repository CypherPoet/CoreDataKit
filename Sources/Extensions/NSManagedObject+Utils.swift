import Foundation
import CoreData


extension NSManagedObject {
    
    /// Whether an object is written to a persistent store.
    ///
    /// This leverages the logic of `objectID.isTemporaryID`. As per Apple's documentation:
    ///
    ///     Temporary IDs are assigned to newly inserted objects and replaced with
    ///     permanent IDs when an object is written to a persistent store.
    public var hasBeenPersistedInStore: Bool {
        objectID.isTemporaryID == false
    }
}
