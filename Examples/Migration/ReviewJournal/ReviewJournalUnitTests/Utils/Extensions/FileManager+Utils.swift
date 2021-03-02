//
// FileManager+Utils.swift
// ReviewJournal
//
// Created by CypherPoet on 1/24/21.
// ✌️
//

import Foundation


extension FileManager {
    
    static func clearDirectoryContents(
        at directory: URL,
        using fileManager: FileManager = .default
    ) {
        for fileName in try! fileManager.contentsOfDirectory(atPath: directory.path) {
            let fileURL = directory.appendingPathComponent(fileName)
            
            try? fileManager.removeItem(atPath: fileURL.path)
        }
    }
    
    
    static func copyFile(
        in bundle: Bundle,
        named fileName: String,
        withExtension extensionName: String,
        atSubdirectory subdirectoryName: String? = nil,
        to destination: URL,
        using fileManager: FileManager = .default
    ) {
        try? fileManager.removeItem(at: destination)
        
//        guard let sourceURL = bundle.url(
//            forResource: fileName,
//            withExtension: extensionName,
//            subdirectory: subdirectoryName
//        ) else {
//            fatalError("Unable to find URL in Bundle")
//        }
        guard
            let sourceURL = bundle
                .resourceURL?
                .appendingPathComponent(fileName)
                .appendingPathExtension(extensionName)
        else {
            fatalError("Unable to find URL in Bundle")
        }
        
        print("Copying from \(sourceURL) to \(destination)")
        
        try? fileManager.copyItem(at: sourceURL, to: destination)
    }
    
    

//    static func moveFileFromBundleToTempDirectory(
//        filename: String
//    ) -> URL {
//        let destinationURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true).appendingPathComponent(filename)
//        try? FileManager.default.removeItem(at: destinationURL)
//        let bundleURL = Bundle(for: CoreDataMigratorTests.self).resourceURL!.appendingPathComponent(filename)
//        try? FileManager.default.copyItem(at: bundleURL, to: destinationURL)
//
//        return destinationURL
//    }
}
