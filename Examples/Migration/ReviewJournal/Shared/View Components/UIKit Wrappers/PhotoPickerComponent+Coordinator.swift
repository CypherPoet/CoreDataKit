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
        typealias CompletionHandler = (([PHPickerResult]) -> Void)?

        var onPickingCompleted: CompletionHandler

        init(
            onPickingCompleted: CompletionHandler = nil
        ) {
            self.onPickingCompleted = onPickingCompleted
        }
    }
}


// MARK: - PHPickerViewControllerDelegate
extension PhotoPickerComponent.Coordinator: PHPickerViewControllerDelegate {
    
    func picker(
        _ picker: PHPickerViewController,
        didFinishPicking results: [PHPickerResult]
    ) {
        onPickingCompleted?(results)
        picker.dismiss(animated: true)
    }
}
