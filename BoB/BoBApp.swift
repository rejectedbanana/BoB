//
//  BoBApp.swift
//  BoB
//
//  Created by Kim Martini on 10/19/23.
//

import SwiftUI

func dateFormatterForView(_ date: Date) -> String {
    let format = DateFormatter()
    format.dateFormat = "MMM d y, HH:mm:ss"
    return format.string(from: date)
}

func dateFormatterForExport(_ date: Date) -> String {
    let format = DateFormatter()
    format.dateFormat = "yyyyMMdd_HHmmss"
    return format.string(from: date)
}

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
