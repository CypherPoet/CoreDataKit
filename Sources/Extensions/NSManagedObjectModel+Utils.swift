import Foundation
import CoreData


extension NSManagedObjectModel {
    
    /// Finds all potential managed object model URLs for a bundle
    ///
    /// When Xcode compiles your app into its app bundle,
    /// it will also compile your data models.
    ///
    /// The app bundle will have at its root a `.momd` folder that contains `.mom` and `.omo` files.
    ///
    /// MOM, or Managed Object Model, files are the compiled versions
    /// of `.xcdatamodel` files. You’ll have a .mom for each data model version.
    public static func modelURLs(
        inSubdirectoryNamed subdirectoryName: String? = nil,
        in bundle: Bundle = .main
    ) -> [URL] {
        ["omo", "mom"].flatMap { extensionName in
            bundle.urls(
                forResourcesWithExtension: extensionName,
                subdirectory: subdirectoryName
            )
            ?? []
        }
    }
    
    public static func model(
        forSchemaNamed modelSchemaName: String,
        inSubdirectoryNamed subdirectoryName: String? = nil,
        in bundle: Bundle = .main
    ) -> NSManagedObjectModel {
        guard
            let url = modelURLs(inSubdirectoryNamed: subdirectoryName, in: bundle)
                .first(where: {
                    [
                        "\(modelSchemaName).omo",
                        "\(modelSchemaName).mom",
                    ]
                    .contains($0.lastPathComponent)
                })
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
