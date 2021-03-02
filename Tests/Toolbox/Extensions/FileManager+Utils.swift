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
        named fileName: String,
        withExtension extensionName: String,
        inSubdirectory subdirectoryName: String? = nil,
        to destination: URL,
        using fileManager: FileManager = .default
    ) {
        try? fileManager.removeItem(at: destination)
        
        guard let sourceURL = Bundle.module.url(
            forResource: fileName,
            withExtension: extensionName,
            subdirectory: subdirectoryName
        ) else {
            fatalError("Unable to find URL in Bundle")
        }
        
        print("Copying from \(sourceURL) to \(destination)")
        
        try? fileManager.copyItem(at: sourceURL, to: destination)
    }
    
}
