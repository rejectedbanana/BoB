//
//  CoreDataController.swift
//  watchBoB Watch App
//
//  Created by Kim Martini on 10/26/23.
//

import CoreData
import Foundation

// Define an observable class to encapsulate all Core Data-related functionality.
class CoreDataController: ObservableObject {
    // Pass the data model filename to the container’s initializer.
    let container = NSPersistentContainer(name: "Bob")
    
    init() {
        
        let description = container.persistentStoreDescriptions.first
                description?.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
        
        // Load any persistent stores, which creates a store if none exists.
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
            
            self.container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        }
    }
    
    // Enable persistent history tracking
    func enableHistoryTracking() {
        let context = container.viewContext
        context.performAndWait {
            try? context.setQueryGenerationFrom(NSQueryGenerationToken.current)
        }
    }
}
