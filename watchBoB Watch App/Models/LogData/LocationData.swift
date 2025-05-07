//
//  LocationData.swift
//  BoB
//
//  Created by Hasan Armoush on 08/08/2024.
//

import Foundation

// Location structure for use inside swift
struct LocationData: Codable, Identifiable {
    let id = UUID()
    var timestamp: String
    var latitude: Double?
    var longitude: Double?
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        // encode the timestamp
        try container.encode(id, forKey: .id)
        try container.encode(timestamp, forKey: .timestamp)
        try container.encode(latitude, forKey: .latitude)
        try container.encode(longitude, forKey: .longitude)
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case timestamp
        case latitude
        case longitude
    }
}


// Location structure for export to a compact JSON
struct LocationArrays: Codable {
    var timestamp: [String?]
    var latitude: [Double?]
    var longitude: [Double?]
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        // encode the timestamp
        try container.encode(timestamp, forKey: .timestamp)
        
        // format latitude and longitude to 8 decimal places
        // This give accuracy to 1 m, with a location noise level of 1e-6 degrees latitude or longitude
        // location is GPS plus help from local mobile networks
        let decimalPlaces: Double = 8
        let multiplier: Double = pow(10, decimalPlaces+1)
        let formattedLatitude = latitude.map { $0.map { round( $0 * multiplier ) / multiplier } }
        let formattedLongitude = longitude.map { $0.map { round( $0 * multiplier ) / multiplier } }
        
        // encode the formatted values
        try container.encode(formattedLatitude, forKey: .latitude)
        try container.encode(formattedLongitude, forKey: .longitude)
    }
    
    enum CodingKeys: String, CodingKey {
        case timestamp
        case latitude
        case longitude
    }
}
