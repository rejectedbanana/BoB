//
//  watchBoBApp.swift
//  watchBoB Watch App
//
//  Created by Kim Martini on 10/19/23.
//

import SwiftUI

func degree() -> String {
    return "\u{00B0}"
}

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

