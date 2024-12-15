//
//  ImageView.swift
//  ImageAnomolyDetection
//
//  Created by Harsh Chaturvedi on 15/12/24.
//
import SwiftUI
import UIKit

struct ImageView: View {
	let image: UIImage
	let status: ImageStatus

	var body: some View {
		VStack {
			Image(uiImage: image)
				.resizable()
				.scaledToFit()
			Text(status.rawValue)
		}
	}
}
