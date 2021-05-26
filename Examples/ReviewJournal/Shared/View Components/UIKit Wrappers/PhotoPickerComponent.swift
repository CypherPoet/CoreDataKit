//
// PhotoPickerComponent.swift
// ReviewJournal
//
// Created by CypherPoet on 1/1/21.
// ✌️
//


import SwiftUI
import PhotosUI
import Combine


struct PhotoPickerComponent {
    typealias UIViewControllerType = PHPickerViewController
    
    var selectionLimit: SelectionLimit = .any
    var filter: PHPickerFilter = .images

    var onPickingCompleted: Coordinator.CompletionHandler
}



// MARK: - UIViewControllerRepresentable
extension PhotoPickerComponent: UIViewControllerRepresentable {

    func makeCoordinator() -> Coordinator {
        Coordinator(onPickingCompleted: onPickingCompleted)
    }


    func makeUIViewController(context: Context) -> UIViewControllerType {
        let configuration = makePickerConfiguration()
        let viewController = UIViewControllerType(configuration: configuration)
        
        viewController.delegate = context.coordinator

        return viewController
    }


    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        update(uiViewController, applying: context)
    }
}


// MARK: - Private Helpers
private extension PhotoPickerComponent {

    /// Configure the view controller with the current state,
    /// using the current context.
    func update(_ uiViewController: UIViewControllerType, applying context: Context) {
    }
    
    
    func makePickerConfiguration() -> PHPickerConfiguration {
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        
        configuration.selectionLimit = selectionLimit.value
        configuration.filter = filter
        
        return configuration
    }
}


extension PhotoPickerComponent {
    enum SelectionLimit {
        case any
        case max(of: Int)
        
        static var unlimited: Self { .any }
        static var single: Self { .max(of: 1) }

        var value: Int {
            switch self {
            case .any:
                return 0
            case .max(let value):
                return value
            }
        }
    }
}


// MARK: - Static Methods
extension PhotoPickerComponent {
    
    public static func generateUIImages(
        from pickerResults: [PHPickerResult]
    ) -> Future<[UIImage], PhotoPickerComponent.Error> {
        Future { promise in
            var convertedImages = [UIImage]()
            let dispatchGroup = DispatchGroup()
            
            for result in pickerResults {
                dispatchGroup.enter()

                let itemProvider = result.itemProvider
                
                guard itemProvider.canLoadObject(ofClass: UIImage.self) else { return }

                
                itemProvider.loadObject(ofClass: UIImage.self) { (itemProviderReading, error) in
                
                    guard error == nil else {
                        promise(.failure(.imageLoadingFailed))
                        return
                    }

                    guard let uiImage = itemProviderReading as? UIImage else {
                        preconditionFailure()
                    }

                    convertedImages.append(uiImage)
                    dispatchGroup.leave()
                }
            }
            
            
            dispatchGroup.notify(queue: .main) {
                promise(.success(convertedImages))
            }
        }
    }
}


extension PhotoPickerComponent {
    
    enum Error: Swift.Error {
        case imageLoadingFailed
    }
}
