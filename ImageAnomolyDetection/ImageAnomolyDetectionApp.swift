//
//  ImageAnomolyDetectionApp.swift
//  ImageAnomolyDetection
//
//  Created by Harsh Chaturvedi on 13/12/24.
//

import SwiftUI

@main
struct ImageAnomolyDetectionApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
