//
//  CombinedData.swift
//  BoB
//
//  Created by Kim Martini on 10/1/24.
//

import Foundation

struct CombinedData: Codable {
    let LOCATION: LocationDataForJSON
    let MOTION: MotionDataForJSON
    let SUBMERSION: SubmersionDataForJSON
}

struct LocationDataForJSON: Codable {
    let sensor_id: String
    let description: String
    let labels: [String]
    let units: [String]
    let values: LocationData
    
    init( values: LocationData ) {
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
    let values: MotionData
    
    init( values: MotionData ) {
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
    let values: WaterSubmersionData
    
    init( values: WaterSubmersionData ) {
        self.description = "Submersion data from water depth and water temperature sensors"
        self.sensor_id = "submersion"
        self.labels = ["timestamp,waterDepth,waterTemperature"]
        self.units = ["ISO8601,meters,°C"]
        self.values = values
    }
}
