//
//  metaData.swift
//  BoB
//
//  Created by Kim Martini on 5/31/25.
//

import Foundation

struct watchMetadata: Codable {
    // file details
    var fileID: String
    var fileName: String
    
    // device details
    var deviceName: String
    var deviceManufacturer: String
    var deviceModel: String
    var deviceHardwareVersion: String
    var deviceOperatingSystemVersion: String
    var motionCoordinateSystem: String
    
    // start and end sampling
    var samplingStart: SamplingInfo
    var samplingStop: SamplingInfo
    
}

struct SamplingInfo: Codable {
    let description: String
    let units: [String]
    let labels: [String]
    var datetime: String
    var latitude: Double
    var longitude: Double
    
    init(description: String, datetime: String, latitude: Double, longitude: Double) {
        self.description = description
        self.labels = ["timestamp","latitude","longitude"]
        self.units = ["ISO8601","degreesNorth","degreesEast"]
        self.datetime = datetime
        self.latitude = latitude
        self.longitude = longitude
    }
}


