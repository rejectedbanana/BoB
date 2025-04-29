//
//  WaterSubmersionData.swift
//  BoB
//
//  Created by Hasan Armoush on 14/08/2024.
//

import Foundation

// Submersion structure for use inside swift
struct WaterSubmersionData: Codable {
    var timestamp: String
    var depth: Double?
    var temperature: Double?
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(timestamp, forKey: .timestamp)
        try container.encode(depth, forKey: .depth)
        try container.encode(temperature, forKey: .temperature)
    }
    
    enum CodingKeys: String, CodingKey {
        case timestamp
        case depth
        case temperature
    }
}


// Submersion structure for use in a compact JSON
struct WaterSubmersionArrays: Codable {
    var timestamp: [String]
    var depth: [Double]
    var temperature: [Double]

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        // encode the timestamp
        try container.encode(timestamp, forKey: .timestamp)
        
        // format the data to 4 decimal places
        let formattedWaterDepth: [Double?] = depth.map { round( $0 * 1000 ) / 1000  }
        let formattedWaterTemperature: [Double?] = temperature.map { round( $0 * 100 ) / 100 } 
        // encode the data
        try container.encode(formattedWaterDepth, forKey: .depth)
        try container.encode(formattedWaterTemperature, forKey: .temperature)
    }
    
    enum CodingKeys: String, CodingKey {
        case timestamp
        case depth
        case temperature
    }
}
