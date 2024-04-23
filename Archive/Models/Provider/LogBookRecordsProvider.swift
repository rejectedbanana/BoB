//
//  LogBookRecordsProvider.swift
//  watchBoB Watch App
//
//  Created by Ramar Parham on 2/12/24.
//

import Foundation
import CoreData

//File is used to persisit data and assit in helping load data
final class LogBookRecordsProvider {
    
    static let shared = LogBookRecordsProvider()
    
    private let persistenceContainer: NSPersistentContainer
    
    var viewContext: NSManagedObjectContext {
        persistenceContainer.viewContext
    }
    
    private init() {
        
        persistenceContainer = NSPersistentContainer(name: "Bob")
        //when a change happens it will automatically get saved within out models file
        persistenceContainer.viewContext.automaticallyMergesChangesFromParent = true
        persistenceContainer.loadPersistentStores { _, error in
            if let error {
                fatalError("Unable to load store with error: \(error)")
            }
        }
    }
}
