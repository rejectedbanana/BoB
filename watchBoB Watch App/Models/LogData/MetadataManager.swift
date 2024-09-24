//
//  MetadataManager.swift
//  watchBoB Watch App
//
//  Created by Ramar Parham on 2/19/24.
//

import Foundation
import CoreData
import WatchKit

class MetadataManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    // time stamp formatter
    let timeStampFormatter = TimeStampManager()
    
    // define an ID for the metadata
    var sessionID: UUID?
    var name: String? = "TBD"
    // define the start data
    var startDatetime: Date?
    var startLatitude: Double = 0.0
    var startLongitude: Double = 0.0
    // define the stop data
    var stopDatetime: Date?
    var stopLatitude: Double = 0.0
    var stopLongitude: Double = 0.0
    
    // Device Info
    var deviceName: String = "Unknown"
    var deviceModel: String = "Unknown"
    var deviceLocalizedModel: String = "Unknown"
    var deviceSystemVersion: String = "Unknown"
    var deviceManufacturer: String = "Unknown"
    
    var isLogging = false

    func getCurrentLocation() -> (latitude: Double, longitude: Double) {
        let locationManager = LocationManager()
        
        guard let location = locationManager.locationManager.location else {
            debugPrint("Location data is unavailable.")
            return (Double.nan, Double.nan)
        }
        
        let latitude = location.coordinate.latitude.rounded(toPlaces: 6)
        let longitude = location.coordinate.longitude.rounded(toPlaces: 6)
        
        return (latitude, longitude)
    }

    func startLogging() {
        sessionID = UUID()
        name = timeStampFormatter.exportNameFormat(Date.now)
        startDatetime = Date()
        (startLatitude, startLongitude) = getCurrentLocation()
        isLogging = true
        
    }

    func stopLogging() {
        stopDatetime = Date()
        (stopLatitude, stopLongitude) = getCurrentLocation()

        isLogging = false
        
    }
    
 }
extension Double {
    /// Rounds the double to 'places' decimal places.
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
