//
//  ContentView.swift
//  ImageAnomolyDetection
//
//  Created by Harsh Chaturvedi on 13/12/24.
//

import SwiftUI
import SwiftUI

struct ImageUploadView: View {
	@StateObject var vm = ImageUploadViewModel()
	@State private var showImagePicker = false


	var body: some View {
		NavigationView {
			VStack {
				if vm.shouldShowResultOption() {
					NavigationLink(destination: ResultsView(vm: vm)) {
						Text("View Results")
					}
				} else {
					Text("Select or capture at least 10 images")
				}
				HStack {
					Button("Select from Gallery") {
						vm.sourceType = .photoLibrary
						showImagePicker = true
					}
					Button("Capture New Image") {
						vm.sourceType = .camera
						showImagePicker = true
					}
				}
			}
			.sheet(isPresented: $showImagePicker, content: {
				ImagePickerView(sourceType: vm.sourceType){images in
					vm.processImagePicked(images: images)
				}
			})
			.alert("no face detected in captured image", isPresented: $vm.shouldShowIncorrectImageAlert){
				Button("Dismiss", role: .cancel) { vm.shouldShowIncorrectImageAlert = false }
			}
		}
	}
}


#Preview {
    ImageUploadView()
}
