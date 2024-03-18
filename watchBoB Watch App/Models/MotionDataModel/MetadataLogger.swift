//
//  MetadataLogger.swift
//  watchBoB Watch App
//
//  Created by Ramar Parham on 2/19/24.
//

import Foundation
import CoreData
import WatchKit

//public class SessionMetadata: NSManagedObject {
//    @NSManaged public var sessionID: UUID
//    @NSManaged public var startTime: Date
//    @NSManaged public var endTime: Date
//    @NSManaged public var stopTime: Date?
//    @NSManaged public var startCoordinates: Double
//    @NSManaged public var stopCoordinates: Double
//    @NSManaged public var startLatitude: Double
//    @NSManaged public var startLongitude: Double
//    @NSManaged public var stopLatitude: Double
//    @NSManaged public var stopLongitude: Double
//    @NSManaged public var samplingFrequency: Int16
//    @NSManaged public var stopCoordinatesLatitude: Double
//    @NSManaged public var stopCoordinatesLongitude: Double
//    
//    var isStopped = false
//    
//    func stop() {
//        guard !isStopped else { return } 
//           isStopped = true
//           endTime = Date()
//      }
//}

class MetadataLogger: NSObject, ObservableObject, CLLocationManagerDelegate {
    // Temporarily remove logging directly to CoreData
//    let context = PersistenceController.shared.container.viewContext
//    var sessionMetadata: SessionMetadata?
    
    // define an ID for the metadata
    var sessionID: UUID?
    // define the start data
    var startDatetime: Date?
    var startLatitude: Double = 0.0
    var startLongitude: Double = 0.0
    // define the stop data
    var stopDatetime: Date?
    var stopLatitude: Double = 0.0
    var stopLongitude: Double = 0.0
    
    var isLogging = false
    let locationManager = CLLocationManager()
    var currentLocation: CLLocationCoordinate2D?

    func startLogging() {
        // Temporarily remove logging directly to CoreData
//        sessionMetadata = SessionMetadata(context: context)
//        sessionMetadata?.sessionID = UUID()
//        sessionMetadata?.startTime = Date()
//
//        sessionMetadata?.samplingFrequency = 10
//
//        do {
//            try context.save()
//        } catch {
//            print("Failed to save session metadata: \(error)")
//        }
        
        // replace with just updating the local variables
        sessionID = UUID()
        startDatetime = Date()
        startLatitude = 99.0
        startLongitude = 99.0
        
        locationManager.startUpdatingLocation()

        WKInterfaceDevice.current().enableWaterLock()
        
        isLogging = true
        
//        self.sessionMetadata = nil
    }

    func stopLogging(stopCoordinates: CLLocationCoordinate2D) {
        // Temporarily remove logging directly to CoreData
//        guard let sessionMetadata = sessionMetadata else {
//                print("Session metadata not found")
//                return
//            }
//        sessionMetadata.stopTime = Date()
//        sessionMetadata.stopCoordinatesLatitude = stopCoordinates.latitude
//        sessionMetadata.stopCoordinatesLongitude = stopCoordinates.longitude
//
//        do {
//            try context.save()
//            print("Session metadata saved")
//        } catch {
//            print("Failed to save session metadata: \(error.localizedDescription)")
//        }
        
        // replace with just updating the local variables
        sessionID = UUID()
        stopDatetime = Date()
        stopLatitude = -99.0
        stopLongitude = -99.0
        
        locationManager.stopUpdatingLocation()

        isLogging = false
        
//        self.sessionMetadata = nil
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
