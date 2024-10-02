//
//  OutputDataForJSON.swift
//  BoB
//
//  Created by Kim Martini on 10/1/24.
//

import Foundation

struct OutputDataForJSON: Codable {
    let LOCATION: LocationDataForJSON
    let MOTION: MotionDataForJSON
    let SUBMERSION: SubmersionDataForJSON
}

struct LocationDataForJSON: Codable {
    let sensor_id: String
    let description: String
    let labels: [String]
    let units: [String]
    let values: LocationArrays
    
    init( values: LocationArrays ) {
        self.sensor_id = "location"
        self.description = "Geographical location from L1 and L5 GPS, GLONASS, Galileo, QZSS, or BeiDou"
        self.labels = ["timestamp,latitude,longitude"]
        self.units = ["ISO8601,degreesNorth,degreesEast"]
        self.values = values
    }
}

struct MotionDataForJSON: Codable {
    let sensor_id: String
    let description: String
    let labels: [String]
    let units: [String]
    let values: MotionArrays
    
    init( values: MotionArrays ) {
        self.sensor_id = "motion"
        self.description = "3-axis acceleration, rotation, and magnetic field from motion sensors"
        self.labels = ["timestamp,accelerationX,accelerationY,accelerationZ,rotationRateX,rotationRateY,rotationRateZ,magneticFieldX,magneticFieldY, magneticFieldZ"]
        self.units = ["ISO8601,m/s²,m/s²,m/s²,rad/s,rad/s,rad/s,µT,µT,µT"]
        self.values = values
    }
}

struct SubmersionDataForJSON: Codable {
    let sensor_id: String
    let description: String
    let labels: [String]
    let units: [String]
    let values: SubmersionArrays
    
    init( values: SubmersionArrays ) {
        self.description = "Submersion data from water depth and water temperature sensors"
        self.sensor_id = "submersion"
        self.labels = ["timestamp,waterDepth,waterTemperature"]
        self.units = ["ISO8601,meters,°C"]
        self.values = values
    }
}

struct LocationArrays: Codable {
    let timestamp: [String?]
    let latitude: [Double?]
    let longitude: [Double?]
    
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

struct MotionArrays: Codable {
    let timestamp: [String?]
    let accelerationX: [Double?]
    let accelerationY: [Double?]
    let accelerationZ: [Double?]
    let rotationRateX: [Double?]
    let rotationRateY: [Double?]
    let rotationRateZ: [Double?]
    let magneticFieldX: [Double?]
    let magneticFieldY: [Double?]
    let magneticFieldZ: [Double?]
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        // encode the timestamp
        try container.encode(timestamp, forKey: .timestamp)
        
        // Format data to 6 decimal places
        let formattedAccelerationX = accelerationX.map { $0.map { round( $0 * 1000000 ) / 1000000 } }
        let formattedAccelerationY = accelerationY.map { $0.map { round( $0 * 1000000 ) / 1000000 } }
        let formattedAccelerationZ = accelerationZ.map { $0.map { round( $0 * 1000000 ) / 1000000 } }
        let formattedRotationX = rotationRateX.map { $0.map { round( $0 * 1000000 ) / 1000000 } }
        let formattedRotationY = rotationRateY.map { $0.map { round( $0 * 1000000 ) / 1000000 } }
        let formattedRotationZ = rotationRateZ.map { $0.map { round( $0 * 1000000 ) / 1000000 } }
        let formattedMagneticFieldX = magneticFieldY.map { $0.map { round( $0 * 1000 ) / 1000 } }
        let formattedMagneticFieldY = magneticFieldY.map { $0.map { round( $0 * 1000 ) / 10000 } }
        let formattedMagneticFieldZ = magneticFieldZ.map { $0.map { round( $0 * 1000 ) / 1000 } }
        // encode the formatted values
        try container.encode(formattedAccelerationX, forKey: .accelerationX)
        try container.encode(formattedAccelerationY, forKey: .accelerationY)
        try container.encode(formattedAccelerationZ, forKey: .accelerationZ)
        try container.encode(formattedRotationX, forKey: .rotationRateX)
        try container.encode(formattedRotationY, forKey: .rotationRateY)
        try container.encode(formattedRotationZ, forKey: .rotationRateZ)
        try container.encode(formattedMagneticFieldX, forKey: .magneticFieldX)
        try container.encode(formattedMagneticFieldY, forKey: .magneticFieldY)
        try container.encode(formattedMagneticFieldZ, forKey: .magneticFieldZ)
    }
    
    enum CodingKeys: String, CodingKey {
        case timestamp
        case accelerationX
        case accelerationY
        case accelerationZ
        case rotationRateX
        case rotationRateY
        case rotationRateZ
        case magneticFieldX
        case magneticFieldY
        case magneticFieldZ
    }
}

struct SubmersionArrays: Codable {
    let timestamp: [String?]
    let waterDepth: [Double?]
    let waterTemperature: [Double?]
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        // encode the timestamp
        try container.encode(timestamp, forKey: .timestamp)
        
        // format the data to 4 decimal places
        let formattedWaterDepth: [Double?] = waterDepth.map { $0.map { round( $0 * 10000 ) / 10000 } }
        let formattedWaterTemperature: [Double?] = waterTemperature.map { $0.map { round( $0 * 1000 ) / 1000 } }
        // encode the data
        try container.encode(formattedWaterDepth, forKey: .waterDepth)
        try container.encode(formattedWaterTemperature, forKey: .waterTemperature)
    }
    
    enum CodingKeys: String, CodingKey {
        case timestamp
        case waterDepth
        case waterTemperature
    }
}
