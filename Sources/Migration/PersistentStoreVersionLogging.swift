import Foundation
import CoreData


public protocol PersistentStoreVersionLogging: CaseIterable, Equatable {
    static var currentVersion: Self { get }
    
    /// A name with which to initialize this version's persistentContainer.
    static var persistentContainerName: String { get }
    
    /// The name corresponding to the current persistent store version's `.xcdatamodeld` file.
    var modelSchemaName: String { get }
    
    var modelSchemaSubdirectoryName: String? { get }
    
    
    func nextVersion() -> Self?
    
    
    static func compatibleVersion(
        for storeMetadata: PersistentStoreMetaData,
        in bundle: Bundle
    ) -> Self?
    
    
    static func compatibleModel(
        for storeMetaData: PersistentStoreMetaData,
        in bundle: Bundle
    ) -> NSManagedObjectModel?
}


// MARK: - Default Implementations
extension PersistentStoreVersionLogging {
    
    public var modelSchemaSubdirectoryName: String? { "\(Self.persistentContainerName).momd" }
    
    public static func compatibleVersion(
        for storeMetadata: PersistentStoreMetaData,
        in bundle: Bundle = .main
    ) -> Self? {
        allCases.first(where: { version in
            NSManagedObjectModel
                .model(for: version, in: bundle)
                .isConfiguration(
                    withName: nil,
                    compatibleWithStoreMetadata: storeMetadata
                )
        })
    }
    
    
    public static func compatibleModel(
        for storeMetaData: PersistentStoreMetaData,
        in bundle: Bundle = .main
    ) -> NSManagedObjectModel? {
        guard let version = compatibleVersion(for: storeMetaData) else { return nil }
        
        return NSManagedObjectModel.model(for: version, in: bundle)
    }
}

