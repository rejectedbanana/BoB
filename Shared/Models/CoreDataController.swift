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
    // Use NSPersistentCloudKitContainer for CloudKit support
    let container: NSPersistentCloudKitContainer
    
    init() {
        container = NSPersistentCloudKitContainer(name: "Bob")
        
        // Enable persistent history tracking
        let description = container.persistentStoreDescriptions.first
        description?.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
        description?.cloudKitContainerOptions = NSPersistentCloudKitContainerOptions(containerIdentifier: "iCloud.com.TiniScientific.BoB.SampleSet")
        
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
                return
            }
            self.container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
            self.container.viewContext.automaticallyMergesChangesFromParent = true
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
