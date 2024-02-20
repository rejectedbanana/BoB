//
//  MetadataLogger.swift
//  watchBoB Watch App
//
//  Created by Ramar Parham on 2/19/24.
//

import Foundation
import CoreData
import WatchKit

public class SessionMetadata: NSManagedObject {
    @NSManaged public var sessionID: UUID
    @NSManaged public var startTime: Date
    @NSManaged public var endTime: Date
    @NSManaged public var stopTime: Date?
    @NSManaged public var startCoordinates: String?
    @NSManaged public var stopCoordinates: String?
    @NSManaged public var samplingFrequency: Int16
}

class MetadataLogger: ObservableObject {
    let context = PersistenceController.shared.container.viewContext
    var sessionMetadata: SessionMetadata?
    var isLogging = false

    func startLogging() {
        sessionMetadata = SessionMetadata(context: context)
        sessionMetadata?.sessionID = UUID()
        sessionMetadata?.startTime = Date()
        sessionMetadata?.startCoordinates = "Start Coordinates" // Replace with actual coordinates

        sessionMetadata?.samplingFrequency = 10

        do {
            try context.save()
        } catch {
            print("Failed to save session metadata: \(error)")
        }

        WKInterfaceDevice.current().enableWaterLock()
        
        isLogging = true
    }

    func stopLogging() {
        sessionMetadata?.stopTime = Date()
        sessionMetadata?.stopCoordinates = "Stop Coordinates" // Replace with actual coordinates

        do {
            try context.save()
        } catch {
            print("Failed to save session metadata: \(error)")
        }

        isLogging = false
    }
}
