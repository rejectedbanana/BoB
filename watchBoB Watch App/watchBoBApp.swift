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
    
    @StateObject private var coreDataController = CoreDataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, coreDataController.container.viewContext)
        }
    }
}

