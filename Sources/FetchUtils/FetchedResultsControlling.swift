import Foundation
import CoreData


@MainActor
public protocol FetchedResultsControlling: NSObject, NSFetchedResultsControllerDelegate {
    associatedtype FetchedResult: NSFetchRequestResult

    typealias FetchedResultsController = NSFetchedResultsController<FetchedResult>
    typealias FetchRequest = NSFetchRequest<FetchedResult>

    
    var managedObjectContext: NSManagedObjectContext { get }

    var fetchRequest: NSFetchRequest<FetchedResult> { get }
    var fetchedResultsController: NSFetchedResultsController<FetchedResult> { get }
    
    
    nonisolated func extractAllResults(
        from fetchedResultsController: FetchedResultsController
    ) -> [FetchedResult]
    

    nonisolated func extractFirstSectionResults(
        from fetchedResultsController: FetchedResultsController
    ) -> [FetchedResult]
    
    
    nonisolated func extractResults(
        from sectionInfo: NSFetchedResultsSectionInfo
    ) -> [FetchedResult]
}


extension FetchedResultsControlling {

    /// Helper function for initializing the `fetchedResultsController` used
    /// by the conforming type's instance.
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
    
    
    
    nonisolated public func extractAllResults(
        from fetchedResultsController: FetchedResultsController
    ) -> [FetchedResult] {
        guard let sections = fetchedResultsController.sections else { return [] }
        
        return sections.flatMap { sectionInfo in
            extractResults(from: sectionInfo)
        }
    }
    

    nonisolated public func extractFirstSectionResults(
        from fetchedResultsController: FetchedResultsController
    ) -> [FetchedResult] {
        guard let firstSection = fetchedResultsController.sections?.first else { return [] }
        
        return extractResults(from: firstSection)
    }
    
    
    nonisolated public func extractResults(
        from sectionInfo: NSFetchedResultsSectionInfo
    ) -> [FetchedResult] {
        sectionInfo.objects as? [FetchedResult] ?? []
    }
}
