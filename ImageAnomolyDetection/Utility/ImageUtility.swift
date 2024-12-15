//
//  ImagePickerUtility.swift
//  ImageAnomolyDetection
//
//  Created by Harsh Chaturvedi on 15/12/24.
//

import SwiftUI
import PhotosUI
import Vision
import UIKit

class ImageUtility {

	/// Processes an array of PHPickerResult objects to extract UIImage objects.
	///
	/// - Parameter images: An array of PHPickerResult to process.
	/// - Returns: An array of UIImage objects extracted from the PHPickerResult.
	///
	/// This method uses a DispatchGroup to handle asynchronous loading of images from the item providers
	/// contained within the PHPickerResult objects. It waits for all loading tasks to complete before returning
	/// the array of UIImage objects.
	static func processPHPickerImages(_ images: [PHPickerResult]) -> [UIImage] {
		let group = DispatchGroup()
		var imageArray: [UIImage] = []

		for image in images {
			group.enter()
			image.itemProvider.loadObject(ofClass: UIImage.self) { (reading, error) in
				if let uiImage = reading as? UIImage {
					imageArray.append(uiImage)
				}
				group.leave()
			}
		}
		group.wait()
		return imageArray
	}

	/// Detects if there is a face in the given UIImage.
	///
	/// - Parameter image: The UIImage in which to detect a face.
	/// - Returns: A Boolean value indicating whether a face was detected.
	///
	/// This method uses Vision framework's VNDetectFaceRectanglesRequest to detect
	static func detectFace(in image: UIImage) -> Bool {
		guard let ciImage = CIImage(image: image) else {
			return false
		}
		let request = VNDetectFaceRectanglesRequest()
		#if targetEnvironment(simulator)
		request.usesCPUOnly = true
		#endif
		let handler = VNImageRequestHandler(ciImage: ciImage, options: [:])
		do {
			try handler.perform([request])
			return !(request.results?.isEmpty ?? true)
		} catch {
			return false
		}
	}
}
