//
//  ImageUploadViewModel.swift
//  ImageAnomolyDetection
//
//  Created by Harsh Chaturvedi on 14/12/24.
//

import SwiftUI
import PhotosUI
import Vision
import UIKit

class ImageUploadViewModel: ObservableObject {
	@Published private(set) var processedImage: [String:UIImage] = [:]
	@Published private(set) var images: [String: UIImage] = [:]
	@Published private(set) var imagesStatus: [String : ImageStatus] = [:]
	@Published var sourceType: ImageSourceType = .photoLibrary
	@Published var shouldShowIncorrectImageAlert = false

	private func postImage(image: UIImage, uuid: String, retries: Int = 3) {
		DispatchQueue.global().async {[weak self] in
			// Asynchronously post the image to a server.
			// In case of an error, retry the request up to `retries` times.
			
//			guard let url = URL(string: "https://urlString"), let imageData = image.jpegData(compressionQuality: 1.0) else {
//				return
//			}
//			var request = URLRequest(url: url)
//			request.httpMethod = "POST"
//			request.setValue("application/octet-stream", forHTTPHeaderField: "Content-Type")
//
//			let task = URLSession.shared.uploadTask(with: request, from: imageData) { [weak self] data, response, error in
//				if let error = error {
//					if retries > 0 {
//						// Retry the request
//						print("Retrying... \(retries) attempts left")
//						self?.processImage(image: image, uuid: uuid, retries: retries - 1)
//					}
//				} else if let data = data, let responseImage = UIImage(data: data) {
//					DispatchQueue.main.async {
//						self?.processedImage[uuid] = image
//						self?.imagesStatus[uuid] = .processed
//					}
//				}
//				
//			}
//			
//			task.resume()

			// Simulate network delay
			sleep(20)
			// Update the processedImage dictionary and imagesStatus dictionary on the main thread
			DispatchQueue.main.async {
				self?.processedImage[uuid] = image
				self?.imagesStatus[uuid] = .processed
			}
		}
	}
	
	private func insertImage(allImageWithStatus: [(UIImage, ImageStatus)]) {
		for (image, status) in allImageWithStatus {
			let uuid = UUID().uuidString
			images[uuid] = image
			imagesStatus[uuid] = status
			if status == .inProgress {
				postImage(image: image, uuid: uuid)
			}
		}
	}

	// Determine whether the result option should be shown.
	// Returns true if there are 10 or more images.
	func shouldShowResultOption() -> Bool {
		images.count >= 10
	}

	// Process the picked images based on the source type.
	// For camera images, process only the first image.
	// For non-camera images, process all images concurrently.
	func processImagePicked(images:[UIImage]){
		if sourceType == .camera {
			guard let first = images.first else {
				return
			}
			DispatchQueue.global().async {[weak self] in
				let status: ImageStatus = ImageUtility.detectFace(in: first) ? .inProgress : .inValid
				if status == .inProgress {
					self?.insertImage(allImageWithStatus: [(first, status)])
				}
				else {
					DispatchQueue.main.async {
						self?.shouldShowIncorrectImageAlert = true
					}
				}
			}
		}
		else {
			let group = DispatchGroup()
			var imagesWithStatus: [(UIImage, ImageStatus)] = []
			let queue = DispatchQueue(label: "imagesWithStatusSyncQueue")

			for image in images {
				group.enter()
				DispatchQueue.global().async {
					if ImageUtility.detectFace(in: image) {
						queue.async {
							imagesWithStatus.append((image, .inProgress))
							group.leave()
						}
					}
					else {
						queue.async {
							imagesWithStatus.append((image, .inValid))
							group.leave()
						}
					}
				}
			}

			group.notify(queue: .main) {[weak self] in
				if !imagesWithStatus.isEmpty {
					self?.insertImage(allImageWithStatus:imagesWithStatus)
				}
			}
		}
	}
	
}
