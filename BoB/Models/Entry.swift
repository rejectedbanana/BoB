//
//  Entry.swift
//  BoB
//
//  Created by Kim Martini on 10/23/23.
//

import Foundation
import CoreLocation

struct Entry: Hashable, Codable, Identifiable {
    
    // MARK: - Properties
    
    var id: String
    var date: String
    var coordinates: Coordinates
    var waterDepth: WaterDepth
    var waterTemperature: WaterTemperature

    // Make a location property
    var locationCoordinates: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: coordinates.latitude, longitude: coordinates.longitude)
    }
   
    struct Coordinates: Hashable, Codable {
        var longitude: Double
        var latitude: Double
        var altitude: Double
    }
    
    struct WaterDepth: Hashable, Codable {
        var maximum: Double
    }
    
    struct WaterTemperature: Hashable, Codable {
        var minimum: Double
        var maximum: Double
    }
}
