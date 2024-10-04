//
//  LocationData.swift
//  BoB
//
//  Created by Hasan Armoush on 08/08/2024.
//

import Foundation

struct LocationData: Codable {
    var timestamp: [String?]
    var latitude: [Double?]
    var longitude: [Double?]
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        // encode the timestamp
        try container.encode(timestamp, forKey: .timestamp)
        
        // format latitude and longitude to 4 decimal places
        let formattedLatitude = latitude.map { $0.map { round( $0 * 10000 ) / 10000 } }
        let formattedLongitude = longitude.map { $0.map { round( $0 * 10000 ) / 10000 } }
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
