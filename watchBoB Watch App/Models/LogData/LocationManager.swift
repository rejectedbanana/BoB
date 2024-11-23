//
//  LocationManager.swift
//  watchBoB Watch App
//
//  Created by Kim Martini on 10/28/23.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    // set up location
    var locationManager = CLLocationManager()
    @Published var authorizationStatus: CLAuthorizationStatus?
    @Published var location: CLLocationCoordinate2D?
    
    // make data to fill in
    @Published var sampledLocations: LocationData = LocationData(timestamp: [], latitude: [], longitude: [])
    
    // set up the timer
    private var samplingTimer: Timer?
    private var samplingInterval: TimeInterval = 1.0
    
    // format time
    // let timeStampFormatter = TimeStampManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func startSamplingGPS() {
        locationManager.requestWhenInUseAuthorization()
        samplingTimer = Timer.scheduledTimer(withTimeInterval: samplingInterval, repeats: true) { _ in
            self.locationManager.requestLocation()
        }
    }
    
    func stopSamplingGPS() {
        samplingTimer?.invalidate()
        samplingTimer = nil
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse:
            authorizationStatus = .authorizedWhenInUse
            locationManager.requestLocation()
        case .restricted, .denied:
            break
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first?.coordinate {

            // grab the data
            let timestamp: String = ISO8601DateFormatter().string(from: Date())
            let latitude: Double = location.latitude
            let longitude: Double = location.longitude
            
            // append the data arrays
            sampledLocations.timestamp.append(timestamp)
            sampledLocations.latitude.append(latitude)
            sampledLocations.longitude.append(longitude)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get location: \(error.localizedDescription)")
    }
    
    func convertArrayToJSONString() -> String? {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        if let jsonData = try? encoder.encode(sampledLocations) {
            return String(data: jsonData, encoding: .utf8)
        }
        return nil
    }
    
    func clear() {
//        sampledLocations.removeAll()
        sampledLocations.timestamp.removeAll()
        sampledLocations.latitude.removeAll()
        sampledLocations.longitude.removeAll()
    }
}
