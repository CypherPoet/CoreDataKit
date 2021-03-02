import Foundation
import CoreData


extension PersistentStoreMigrationStep {
    enum Error: Swift.Error {
        case mappingModelCreationFailed
    }
}


/// Helper type for encapsulating the information needed to perform a migration.
///
/// A migration happens between two model versions by mapping
/// from the entities, attributes, and relationships of the source model
/// to their counterpoints in the destination model.
///
/// - Source version model.
/// - Destination version model.
/// - Mapping model
public struct PersistentStoreMigrationStep {
    public var sourceModel: NSManagedObjectModel
    public var destinationModel: NSManagedObjectModel

    internal var mappingModel: NSMappingModel
    

    // MARK: - Init
    public init<Version: PersistentStoreVersionLogging>(
        sourceVersion: Version,
        destinationVersion: Version,
        bundle: Bundle = .main
    ) throws {
        self.sourceModel = NSManagedObjectModel.model(for: sourceVersion, in: bundle)
        self.destinationModel = NSManagedObjectModel.model(for: destinationVersion, in: bundle)
        
        guard let mappingModel = Self.mappingModel(
            from: sourceModel,
            to: destinationModel,
            in: bundle
        ) else {
            throw Error.mappingModelCreationFailed
        }
        
        self.mappingModel = mappingModel
    }
}


// MARK: - Migration Manager
extension PersistentStoreMigrationStep {
    
    public var migrationManager: NSMigrationManager {
        .init(sourceModel: sourceModel, destinationModel: destinationModel)
    }
}


// MARK: - Mapping Model Utilities
extension PersistentStoreMigrationStep {
    
    private static func mappingModel(
        from source: NSManagedObjectModel,
        to destination: NSManagedObjectModel,
        in bundle: Bundle
    ) -> NSMappingModel? {
        if let customMappingModel = Self.customMappingModel(
            from: source,
            to: destination,
            in: bundle
        ) {
            return customMappingModel
        } else {
            return Self.inferredMappingModel(from: source, to: destination)
        }
    }
    
    
    private static func customMappingModel(
        from source: NSManagedObjectModel,
        to destination: NSManagedObjectModel,
        in bundle: Bundle
    ) -> NSMappingModel? {
        NSMappingModel(
            from: [bundle],
            forSourceModel: source,
            destinationModel: destination
        )
    }
    
    
    private static func inferredMappingModel(
        from source: NSManagedObjectModel,
        to destination: NSManagedObjectModel
    ) -> NSMappingModel? {
        try? NSMappingModel.inferredMappingModel(
            forSourceModel: source,
            destinationModel: destination
        )
    }
}

