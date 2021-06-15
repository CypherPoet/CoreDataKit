import CoreData


extension NSPersistentStoreDescription {
    
    internal static let inMemoryStore = NSPersistentStoreDescription(
        url: URL(fileURLWithPath: "/dev/null")
    )
    
}
