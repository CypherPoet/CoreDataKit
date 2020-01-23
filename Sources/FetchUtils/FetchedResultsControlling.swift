import Foundation
import CoreData


public protocol FetchedResultsControlling: NSObject {
    associatedtype FetchedResult: NSFetchRequestResult
    
    var fetchRequest: NSFetchRequest<FetchedResult> { get }
    var fetchedResultsController: NSFetchedResultsController<FetchedResult> { get }
    
    
    func makeFetchedResultsController(
        sectionNameKeyPath: String?,
        cacheName: String?
    ) -> FetchedResultsController
    
    func extractResults(from fetchedResultsController: FetchedResultsController) -> [FetchedResult]
}


extension FetchedResultsControlling {
    public typealias FetchedResultsController = NSFetchedResultsController<FetchedResult>
    public typealias FetchRequest = NSFetchRequest<FetchedResult>

    
    public func makeFetchedResultsController(
        managedObjectContext: NSManagedObjectContext,
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
