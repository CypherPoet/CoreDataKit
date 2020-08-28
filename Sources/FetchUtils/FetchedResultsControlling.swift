import Foundation
import CoreData


public protocol FetchedResultsControlling: NSObject, NSFetchedResultsControllerDelegate {
    associatedtype FetchedResult: NSFetchRequestResult

    typealias FetchedResultsController = NSFetchedResultsController<FetchedResult>
    typealias FetchRequest = NSFetchRequest<FetchedResult>


    var fetchRequest: NSFetchRequest<FetchedResult> { get }
    var managedObjectContext: NSManagedObjectContext { get }
    var fetchedResultsController: NSFetchedResultsController<FetchedResult> { get }
    
    
    /// Helper function for initializing the `fetchedResultsController` used by the conforming type's instance.
    func makeFetchedResultsController(
        sectionNameKeyPath: String?,
        cacheName: String?
    ) -> FetchedResultsController


    func extractResults(from fetchedResultsController: FetchedResultsController) -> [FetchedResult]
}


extension FetchedResultsControlling {

    public func makeFetchedResultsController(
        sectionNameKeyPath: String? = nil,
        cacheName: String? = nil
    ) -> FetchedResultsController {
        .init(
            fetchRequest: fetchRequest,
            managedObjectContext: managedObjectContext,
            sectionNameKeyPath: sectionNameKeyPath,
            cacheName: cacheName
        )
    }
    
    
    public func extractResults(from fetchedResultsController: FetchedResultsController) -> [FetchedResult] {
        guard
            let section = fetchedResultsController.sections?.first,
            let fetchedResults = section.objects as? [FetchedResult]
        else { return [] }
        
        return fetchedResults
    }
}


// 🔑 Example of adopting `NSFetchedResultsControllerDelegate` and updating
// a "results" property on the `FetchedResultsControlling` type.
//
//// MARK: - NSFetchedResultsControllerDelegate
//extension ViewModel: NSFetchedResultsControllerDelegate {
//
//    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        guard let controller = controller as? FetchedResultsController else { return }
//
//        print("controllerDidChangeContent")
//        results = extractResults(from: controller)
//    }
//}
