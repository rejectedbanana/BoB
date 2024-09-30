//
//  LocationManager.swift
//  watchBoB Watch App
//
//  Created by Kim Martini on 10/28/23.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    var locationManager = CLLocationManager()
    
    @Published var authorizationStatus: CLAuthorizationStatus?
    @Published var location: CLLocationCoordinate2D?
    
    @Published var sampledLocations: [LocationData] = []
    
    private var samplingTimer: Timer?
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func startSamplingGPS() {
        locationManager.requestWhenInUseAuthorization()
        samplingTimer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { _ in
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
            let locationData = LocationData(
                timestamp: Date(),
                latitude: round(location.latitude * 10000) / 10000, // 4 decimal places
                longitude: round(location.longitude * 10000) / 10000 // 4 decimal places
            )
            sampledLocations.append(locationData)
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
