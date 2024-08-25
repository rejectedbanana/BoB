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

    func getCurrentLocation() -> (latitude: Double, longitude: Double){
        let locationDataManager = LocationDataManager()
        
        let latitude = locationDataManager.locationManager.location?.coordinate.latitude ?? Double.nan
        let longitude = locationDataManager.locationManager.location?.coordinate.longitude ?? Double.nan
        
        return( latitude, longitude)
    }

    func startLogging() {
        // replace with just updating the local variables
        sessionID = UUID()
        name = timeStampFormatter.exportNameFormat(Date.now)
        startDatetime = Date()
        ( startLatitude, startLongitude ) = getCurrentLocation()

//        WKInterfaceDevice.current().enableWaterLock()
        
        isLogging = true
        
    }

    func stopLogging() {
        // replace with just updating the local variables
        stopDatetime = Date()
        ( stopLatitude, stopLongitude ) = getCurrentLocation()

        isLogging = false
        
    }
    
 }
