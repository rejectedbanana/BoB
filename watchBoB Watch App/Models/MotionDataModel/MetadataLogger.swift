//
//  MetadataLogger.swift
//  watchBoB Watch App
//
//  Created by Ramar Parham on 2/19/24.
//

import Foundation
import CoreData
import WatchKit

class MetadataLogger: NSObject, ObservableObject, CLLocationManagerDelegate {
    
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
<<<<<<< Updated upstream
    let locationManager = CLLocationManager()
    var currentLocation: CLLocationCoordinate2D?
=======
    
    func getCurrentLocation() -> (latitude: Double, longitude: Double){
        var locationDataManager = LocationDataManager()
        
        let latitude = locationDataManager.locationManager.location?.coordinate.latitude ?? Double.nan
        let longitude = locationDataManager.locationManager.location?.coordinate.longitude ?? Double.nan
        
        return( latitude, longitude)
    }
>>>>>>> Stashed changes

    func startLogging() {
        // replace with just updating the local variables
        sessionID = UUID()
        startDatetime = Date()
        startLatitude = 99.0
        startLongitude = 99.0
        
        locationManager.startUpdatingLocation()

        WKInterfaceDevice.current().enableWaterLock()
        
        isLogging = true
        
    }

    func stopLogging() {
        // replace with just updating the local variables
        sessionID = UUID()
        stopDatetime = Date()
        stopLatitude = -99.0
        stopLongitude = -99.0
        
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
