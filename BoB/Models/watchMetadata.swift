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
    var filename: String
    
    // device details
    var deviceName: String
    var deviceManufacturer: String
    var deviceModel: String
    var deviceHardwareVersion: String
    var deviceOperatingSystemVersion: String
//    
//    // start date and location
//    let samplingStart: SamplingStart
//    
//    // end date and location
//    let samplingStop: SamplingStop
    
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


struct SamplingStart: Codable {
    let description: String
    let units: [String]
    let labels: [String]
    var datetime: String
    var latitude: String
    var longitude: String
    
    init(datetime: String, latitude: String, longitude: String) {
        self.description = "Metadata taken immediately before sampling is started and the watch starts continuously taking data."
        self.labels = ["timestamp","latitude","longitude"]
        self.units = ["ISO8601","degreesNorth","degreesEast"]
        self.datetime = datetime
        self.latitude = latitude
        self.longitude = longitude
    }
}

struct SamplingStop: Codable {
    let description: String
    let units: [String]
    let labels: [String]
    var datetime: String
    var latitude: String
    var longitude: String
    
    init(datetime: String, latitude: String, longitude: String) {
        self.description = "Metadata taken immediately after sampling is canceled and the watch stops continuously taking data."
        self.labels = ["timestamp","latitude","longitude"]
        self.units = ["ISO8601","degreesNorth","degreesEast"]
        self.datetime = datetime
        self.latitude = latitude
        self.longitude = longitude
    }
}
