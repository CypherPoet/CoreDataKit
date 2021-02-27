import Foundation
import CoreData



extension NSManagedObjectModel {
    
    public static func model(
        forSchemaNamed modelSchemaName: String,
        inSubdirectoryNamed subdirectoryName: String? = nil,
        in bundle: Bundle = .main
    ) -> NSManagedObjectModel {
        guard let url =
            bundle.url(forResource: modelSchemaName, withExtension: "omo", subdirectory: subdirectoryName)
            ?? bundle.url(forResource: modelSchemaName, withExtension: "mom", subdirectory: subdirectoryName)
            ?? bundle.url(forResource: modelSchemaName, withExtension: "momd")
        else {
            preconditionFailure("Unable to find managed object model named \"\(modelSchemaName)\" in bundle.")
        }
        
        guard let model = NSManagedObjectModel(contentsOf: url) else {
            preconditionFailure("Unable to load managed object model file at url: \(url.absoluteURL)")
        }
        
        return model
    }
    
    
    public static func model<Version: PersistentStoreVersionLogging>(
        for version: Version,
        in bundle: Bundle = .main
    ) -> NSManagedObjectModel {
        model(
            forSchemaNamed: version.modelSchemaName,
            inSubdirectoryNamed: version.modelSchemaSubdirectoryName,
            in: bundle
        )
    }


    public static func makeModel(
        with storeMetaData: PersistentStoreMetaData,
        mergingFrom bundles: [Bundle] = [.main]
    ) -> NSManagedObjectModel? {
        NSManagedObjectModel.mergedModel(from: bundles, forStoreMetadata: storeMetaData)
    }
}
