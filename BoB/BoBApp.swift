//
//  BoBApp.swift
//  BoB
//
//  Created by Kim Martini on 10/19/23.
//

import SwiftUI

@main
struct BoBApp: App {
    // Create an observable instance of the Core Data stack.
    @StateObject private var coreDataController = CoreDataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
            // Inject the persistent container's managed object context into the environment
                .environment(\.managedObjectContext, coreDataController.container.viewContext)
        }
    }
}
