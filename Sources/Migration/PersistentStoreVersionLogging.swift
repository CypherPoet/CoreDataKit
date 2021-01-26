import Foundation
import CoreData


public protocol PersistentStoreVersionLogging: CaseIterable, Equatable {
    static var currentVersion: Self { get }
    
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

