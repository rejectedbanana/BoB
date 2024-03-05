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
    @NSManaged public var startLatitude: Double
    @NSManaged public var startLongitude: Double
    @NSManaged public var stopLatitude: Double
    @NSManaged public var stopLongitude: Double
    @NSManaged public var samplingFrequency: Int16
}

class MetadataLogger: NSObject, ObservableObject, CLLocationManagerDelegate {
    let context = PersistenceController.shared.container.viewContext
    var sessionMetadata: SessionMetadata?
    var isLogging = false
    let locationManager = CLLocationManager()
    var currentLocation: CLLocationCoordinate2D?

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
        
        locationManager.startUpdatingLocation()

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
        
        locationManager.stopUpdatingLocation()

        isLogging = false
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
          guard let location = locations.last else { return }
          currentLocation = location.coordinate
      }

     func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
         print("Location manager failed with error: \(error.localizedDescription)")
     }
 }
