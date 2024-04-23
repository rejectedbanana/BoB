//
//  CoreDataController.swift
//  watchBoB Watch App
//
//  Created by Kim Martini on 10/26/23.
//

import CoreData
import Foundation

class CoreDataController: ObservableObject {
    let container = NSPersistentContainer(name: "Bob")
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
            
            self.container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        }
    }
}
