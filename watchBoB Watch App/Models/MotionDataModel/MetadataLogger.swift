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
    @NSManaged public var startCoordinates: Double
    @NSManaged public var stopCoordinates: Double
    @NSManaged public var samplingFrequency: Int16
}

class MetadataLogger: NSObject, ObservableObject, CLLocationManagerDelegate {
    let context = PersistenceController.shared.container.viewContext
    var sessionMetadata: SessionMetadata?
    var isLogging = false
    let locationDataManager = LocationDataManager()

    func startLogging() {
        sessionMetadata = SessionMetadata(context: context)
        sessionMetadata?.sessionID = UUID()
        sessionMetadata?.startTime = Date()

        sessionMetadata?.samplingFrequency = 10

        do {
            try context.save()
        } catch {
            print("Failed to save session metadata: \(error)")
        }
        
        locationDataManager.locationManager.startUpdatingLocation()

        WKInterfaceDevice.current().enableWaterLock()
        
        isLogging = true
    }

    func stopLogging() {
        sessionMetadata?.stopTime = Date()

        do {
            try context.save()
        } catch {
            print("Failed to save session metadata: \(error)")
        }
        
        locationDataManager.locationManager.stopUpdatingLocation()

        isLogging = false
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
         guard let location = locations.last else { return }
         // Handle location update
     }

     func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
         print("Location manager failed with error: \(error.localizedDescription)")
     }
 }
