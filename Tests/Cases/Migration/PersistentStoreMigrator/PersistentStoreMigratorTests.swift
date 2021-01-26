import Foundation
import XCTest
import CypherPoetCoreDataKit


final class PersistentStoreMigratorTests: XCTestCase {
    private var sut: PersistentStoreMigrator!
    private var storageStrategy: StorageStrategy!

    private var fileManager = FileManager.default
}


// MARK: - Lifecycle
extension PersistentStoreMigratorTests {
    
    override class func setUp() {
        super.setUp()
        
        FileManager.clearDirectoryContents(at: FileManager.default.temporaryDirectory)
    }
    
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        storageStrategy = .persistent
        sut = makeSUT()
    }
    
    
    override func tearDownWithError() throws {
        storageStrategy = nil
        sut = nil
        
        try super.tearDownWithError()
    }
}


// MARK: - Factories
extension PersistentStoreMigratorTests {
    
    func makeSUT() -> PersistentStoreMigrator {
        .init(
            storageStrategy: storageStrategy
        )
    }
    
    
    func makeSUTFromDefaults() -> PersistentStoreMigrator {
        .init()
    }
}


// MARK: - "Given" Helpers (Conditions Exist)
private extension PersistentStoreMigratorTests {
    
}


// MARK: - "When" Helpers (Actions Are Performed)
private extension PersistentStoreMigratorTests {
    
    func whenSomethingHappens() {
        // perform some action
    }
}


// MARK: - Test Single Step Migrations
extension PersistentStoreMigratorTests {
    
    func test_PopulatingAnSQLiteDB_UsingValidModel() throws {
        let sourceVersion = PersistentStoreMigrationVersion.version1
        let destinationVersion = PersistentStoreMigrationVersion.version2
        
        let storeFileName = sourceVersion.modelSchemaName
        let storeSubDirectoryName = "SQLiteExamples"
        let storeSourceURL = fileManager.temporaryDirectory
            .appendingPathComponent(storeFileName)
            .appendingPathExtension("sqlite")
        
        
        FileManager.copyFile(
            named: storeFileName,
            withExtension: "sqlite",
            inSubdirectory: storeSubDirectoryName,
            to: storeSourceURL,
            using: fileManager
        )

        
        try sut.migrateStore(
            at: storeSourceURL,
            to: destinationVersion
        )
        
        XCTAssertTrue(fileManager.fileExists(atPath: storeSourceURL.path))
    }
}
