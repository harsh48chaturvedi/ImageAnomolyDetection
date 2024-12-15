//
//  ResultsView.swift
//  ImageAnomolyDetection
//
//  Created by Harsh Chaturvedi on 13/12/24.
//

import SwiftUI

struct ResultsView: View {
	@ObservedObject var vm: ImageUploadViewModel

	var body: some View {
		ScrollView {
			VStack {
				ForEach(Array(vm.images.keys).sorted(), id: \.self) { key in
					if let status  = vm.imagesStatus[key] {
						if status == .processed {
							if let processedImage = vm.processedImage[key] {
								ImageView(image: processedImage, status: status)
							}
						}
						else {
							if let image = vm.images[key] {
								ImageView(image: image, status: status)
							}
						}
					}
				}
			}
		}
		.navigationTitle("Results")
	}
}
