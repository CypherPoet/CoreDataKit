import Foundation


public extension CodingUserInfoKey {
    
    /// Use for retrieving a Core Data managed object context from the `userInfo` dictionary
    /// of a decoder instance.
    static let managedObjectContext = CodingUserInfoKey(rawValue: "Managed Object Context")!
}
