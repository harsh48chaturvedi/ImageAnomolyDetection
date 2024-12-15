//
//  ImageAnomolyModel.swift
//  ImageAnomolyDetection
//
//  Created by Harsh Chaturvedi on 15/12/24.
//

enum ImageStatus: String {
	case processed = "Processed"
	case inProgress = "InProgress"
	case inValid = "InValid"
}

enum ImageSourceType {
	case camera, photoLibrary
}
