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
    @Published var sampledLocations: [LocationData] = []
    
    // set up the timer
    private var samplingTimer: Timer?
    
    // load timestamp formatter
    let timeStampFormatter = TimeStampManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func startSamplingGPS(_ sampleInterval: Double) {
        locationManager.requestWhenInUseAuthorization()
        locationManager.allowsBackgroundLocationUpdates = true
        samplingTimer = Timer.scheduledTimer(withTimeInterval: sampleInterval, repeats: true) { _ in
            self.locationManager.requestLocation()
        }
    }
    
    func stopSamplingGPS() {
        samplingTimer?.invalidate()
        samplingTimer = nil
        locationManager.allowsBackgroundLocationUpdates = false
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
            let sampledLocation = LocationData(
                timestamp: timeStampFormatter.ISO8601Format(Date()),
                latitude: location.latitude,
                longitude: location.longitude
            )
            // append the array
            sampledLocations.append(sampledLocation)
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
        sampledLocations.removeAll()
    }
}
