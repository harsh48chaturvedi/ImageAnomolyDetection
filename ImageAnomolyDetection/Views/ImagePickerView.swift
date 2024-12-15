//
//  ImagePicker.swift
//  ImageAnomolyDetection
//
//  Created by Harsh Chaturvedi on 13/12/24.
//

import SwiftUI
import PhotosUI
import Vision
import UIKit

struct ImagePickerView: UIViewControllerRepresentable {
	var sourceType: ImageSourceType
	var callback: ([UIImage]) -> Void

	class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate, PHPickerViewControllerDelegate {
		var parent: ImagePickerView

		init(parent: ImagePickerView) {
			self.parent = parent
		}

		// UIImagePickerControllerDelegate method
		func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
			if let uiImage = info[.originalImage] as? UIImage {
				parent.callback([uiImage])
			}
			picker.dismiss(animated: true)
		}

		// PHPickerViewControllerDelegate method
		func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
			parent.callback(ImageUtility.processPHPickerImages(results))
			picker.dismiss(animated: true)
		}
	}

	func makeCoordinator() -> Coordinator {
		Coordinator(parent: self)
	}

	func makeUIViewController(context: Context) -> UIViewController {
		switch sourceType {
		case .camera:
			let picker = UIImagePickerController()
			picker.delegate = context.coordinator
			picker.sourceType = .camera
			return picker

		case .photoLibrary:
			var configuration = PHPickerConfiguration()
			configuration.filter = .images
			configuration.selectionLimit = 0
			let picker = PHPickerViewController(configuration: configuration)
			picker.delegate = context.coordinator
			return picker
		}
	}

	func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
