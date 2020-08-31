import CoreData


public enum DecoderConfigurationError: Error {
    case missingManagedObjectContext
    case noEntityInManagedObjectContext
}


public enum DecoderConfiguration {

    public static func getEntityDescriptionAndContext(
        forEntityName entityName: String,
        using decoder: Decoder,
        keyedOn userInfoKey: CodingUserInfoKey = .managedObjectContext
    ) -> Result<(NSEntityDescription, NSManagedObjectContext), DecoderConfigurationError> {
        guard
            let managedObjectContext = decoder.userInfo[userInfoKey] as? NSManagedObjectContext
        else {
            return .failure(.missingManagedObjectContext)
        }

        guard
            let entityDescription = NSEntityDescription.entity(forEntityName: entityName, in: managedObjectContext)
        else {
            return .failure(.noEntityInManagedObjectContext)
        }

        return .success((entityDescription, managedObjectContext))
    }
}
