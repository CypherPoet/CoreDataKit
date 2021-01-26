//
// PhotoPickerComponent+Coordinator.swift
// ReviewJournal
//
// Created by CypherPoet on 1/1/21.
// ✌️
//

import Foundation
import SwiftUI
import PhotosUI


extension PhotoPickerComponent {
    
    final class Coordinator: NSObject {
        @Binding var pickerResults: [UIImage]

        init(pickerResults: Binding<[UIImage]>) {
            self._pickerResults = pickerResults
        }
    }
}


// MARK: - PHPickerViewControllerDelegate
extension PhotoPickerComponent.Coordinator: PHPickerViewControllerDelegate {
    
    func picker(
        _ picker: PHPickerViewController,
        didFinishPicking results: [PHPickerResult]
    ) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            for result in results
                where result.itemProvider.canLoadObject(ofClass: UIImage.self)
            {
                result.itemProvider.loadObject(ofClass: UIImage.self) { (itemProviderReading, error) in
                    guard error == nil else {
                        print("Error while loading image from picker itemProvider: \(error!.localizedDescription)")
                        return
                    }
                    
                    guard let uiImage = itemProviderReading as? UIImage else {
                        preconditionFailure()
                    }
                    
                    self.pickerResults.append(uiImage)
                }
            }
            
        }

        picker.dismiss(animated: true)
    }
}
