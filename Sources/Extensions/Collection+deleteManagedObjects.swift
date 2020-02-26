import Foundation
import CoreData


extension Collection where
    Element: NSManagedObject,
    Index == Int
{
    /// Delete managed object entities at a set of indices in a list -- using the `managedObjectContext`
    /// that's associated with each entity.
    func delete(at indices: IndexSet) {
        indices.forEach { index in
            let element = self[index]
            
            guard let context = element.managedObjectContext else { preconditionFailure() }
            
            context.delete(element)
        }
    }
}
