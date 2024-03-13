//
//  watchBobApp.swift
//  watchBoB Watch App
//
//  Created by Ramar Parham on 3/7/24.
//

import Foundation
import SwiftUI

let settingsManager = SettingsManager()

@main
struct watchBobApp: App {
    
    let persistenceController = PersistenceController.shared
    @StateObject var metadataLogger = MetadataLogger(settingsManager: settingsManager)
    
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                                    .environmentObject(metadataLogger)
                                    .environmentObject(settingsManager)
            }
        }
    }
}
