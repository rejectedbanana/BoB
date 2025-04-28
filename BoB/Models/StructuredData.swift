//
//  StructuredData.swift
//  BoB
//
//  Created by Kim Martini on 10/1/24.
//

import Foundation

struct StructuredData: Codable {
    let location: FormattedLocationData
    let motion: FormattedMotionData
    let submersion: FormattedSubmersionData
}

struct FormattedLocationData: Codable {
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

struct FormattedMotionData: Codable {
    let sensor_id: String
    let description: String
    let labels: [String]
    let units: [String]
    let values: MotionData
    
    init( values: MotionData ) {
        self.sensor_id = "motion"
        self.description = "3-axis acceleration, angular velocity, and magnetic field from motion sensors"
        self.labels = ["timestamp,accelerationX,accelerationY,accelerationZ,angularVelocityX,angularVelocityY,angularVelocityZ,magneticFieldX,magneticFieldY,magneticFieldZ"]
        self.units = ["ISO8601,m/s²,m/s²,m/s²,rad/s,rad/s,rad/s,µT,µT,µT"]
        self.values = values
    }
}

struct FormattedSubmersionData: Codable {
    let sensor_id: String
    let description: String
    let labels: [String]
    let units: [String]
    let values: WaterSubmersionData
    
    init( values: WaterSubmersionData ) {
        self.description = "Submersion data from water depth and water temperature sensors"
        self.sensor_id = "submersion"
        self.labels = ["timestamp,depth,temperature"]
        self.units = ["ISO8601,meters,°C"]
        self.values = values
    }
}
