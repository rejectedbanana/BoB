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

class AppDelegate: NSObject, WKApplicationDelegate {
    func handle(_ extendedRuntimeSession: WKExtendedRuntimeSession) {
        debugPrint("[AppDelegate] *** Received an automatic session start. ***")
        
        let submersionManager = WaterSubmersionManager.shared
        submersionManager.handleAutomaticSession(extendedRuntimeSession)
    }
}

@main
struct watchBobApp: App {
    // Create an observable instance of the Core Data stack.
    @StateObject private var coreDataController = CoreDataController()
    @WKApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            ContentView()
            // Inject the persistent container's managed object context into the environment
                .environment(\.managedObjectContext, coreDataController.container.viewContext)
        }
    }
}

