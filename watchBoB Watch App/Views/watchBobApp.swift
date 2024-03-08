//
//  watchBobApp.swift
//  watchBoB Watch App
//
//  Created by Ramar Parham on 3/7/24.
//

import Foundation
import SwiftUI

@main
struct watchBobApp: App {
    
    let persistenceController = PersistenceController.shared
    let metadataLogger = MetadataLogger() // Create an instance of MetadataLogger
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                    .environmentObject(MetadataLogger())
            }
        }
    }
}
