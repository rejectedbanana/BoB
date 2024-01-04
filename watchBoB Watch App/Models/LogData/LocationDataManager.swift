//
//  LocationDataManager.swift
//  watchBoB Watch App
//
//  Created by Kim Martini on 10/28/23.
//

import Foundation
import CoreLocation

class LocationDataManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    var locationManager = CLLocationManager()
    
    @Published var authorizationStatus: CLAuthorizationStatus?
    
    @Published var location: CLLocationCoordinate2D?
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse:
            authorizationStatus = .authorizedWhenInUse
            locationManager.requestLocation()
            break
            
        case .restricted, .denied:
            break
            
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
            break
        
        default:
            break
        }
    }
    
    func requestLocation() {
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.first?.coordinate
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error: \(error.localizedDescription)")
    }
}
