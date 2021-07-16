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
        
        guard var baseURL = bundle.resourceURL else {
            preconditionFailure(("Unable to find resourceURL in Bundle"))
        }
        
        if let subdirectoryName = subdirectoryName {
            baseURL = baseURL.appendingPathComponent(subdirectoryName, isDirectory: true)
        }
        
        let sourceURL = baseURL
            .appendingPathComponent(fileName)
            .appendingPathExtension(extensionName)
        
        print("Copying from \(sourceURL) to \(destination)")
        
        try? fileManager.copyItem(at: sourceURL, to: destination)
    }
}
