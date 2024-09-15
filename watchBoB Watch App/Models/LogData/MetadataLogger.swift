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
    // time stamp formatter
    let timeStampFormatter = TimeStampManager()
    
    // define an ID for the metadata
    @Published var sessionID: UUID?
    @Published var name: String = "TBD"
    @Published var startDatetime: Date?
    @Published var startLatitude: Double = 0.0
    @Published var startLongitude: Double = 0.0
    @Published var stopDatetime: Date?
    @Published var stopLatitude: Double = 0.0
    @Published var stopLongitude: Double = 0.0
    
    // Device Info
    var deviceName: String = "Unknown"
    var deviceModel: String = "Unknown"
    var deviceLocalizedModel: String = "Unknown"
    var deviceSystemVersion: String = "Unknown"
    var deviceManufacturer: String = "Unknown"
    
    var isLogging = false

    func getCurrentLocation() -> (latitude: Double, longitude: Double) {
        let locationDataManager = LocationDataManager()
        
        guard let location = locationDataManager.locationManager.location else {
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
    
    func clear() {
        sessionID = nil
        name = "TBD"
        startDatetime = nil
        startLatitude = 0.0
        startLongitude = 0.0
        stopDatetime = nil
        stopLatitude = 0.0
        stopLongitude = 0.0
    }
 }
extension Double {
    /// Rounds the double to 'places' decimal places.
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
