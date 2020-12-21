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

    
    func extractAllResults(
        from fetchedResultsController: FetchedResultsController
    ) -> [FetchedResult]
    

    func extractFirstSectionResults(
        from fetchedResultsController: FetchedResultsController
    ) -> [FetchedResult]
    
    
    func extractResults(
        from sectionInfo: NSFetchedResultsSectionInfo
    ) -> [FetchedResult]
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
    

    public func extractAllResults(
        from fetchedResultsController: FetchedResultsController
    ) -> [FetchedResult] {
        guard let sections = fetchedResultsController.sections else { return [] }
        
        return sections.flatMap(extractResults(from:))
    }
    

    public func extractFirstSectionResults(
        from fetchedResultsController: FetchedResultsController
    ) -> [FetchedResult] {
        guard let firstSection = fetchedResultsController.sections?.first else { return [] }
        
        return extractResults(from: firstSection)
    }
    
    
    public func extractResults(
        from sectionInfo: NSFetchedResultsSectionInfo
    ) -> [FetchedResult] {
        sectionInfo.objects as? [FetchedResult] ?? []
    }
}


// 🔑 Example of adopting `NSFetchedResultsControllerDelegate` and sending
// `sections` to a `sectionsPublisher` owned by the `FetchedResultsControlling` type.
//
//// MARK: - NSFetchedResultsControllerDelegate
//extension ViewModel: NSFetchedResultsControllerDelegate {
//
//func controllerDidChangeContent(
//    _ controller: NSFetchedResultsController<NSFetchRequestResult>
//) {
//    guard
//        let fetchedResultsController = controller as? FetchedResultsController
//    else { return }
//        
//    sectionsPublisher.send(fetchedResultsController.sections ?? [])
//}
//}
