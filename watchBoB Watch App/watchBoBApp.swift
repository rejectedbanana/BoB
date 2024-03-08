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
struct watchBoB_Watch_AppApp: App {
    @StateObject private var dataController = DataController()
    @StateObject private var metadataLogger = MetadataLogger()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(metadataLogger)
        }
    }
}
