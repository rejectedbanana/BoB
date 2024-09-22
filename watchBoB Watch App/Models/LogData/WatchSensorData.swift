//
//  WatchSensorData.swift
//  watchBoB Watch App
//
//  Created by Kim Martini on 6/14/24.
//

import Foundation

struct SensorData: Codable {
    let timestamp: String
    let accX: Double
    let accY: Double
    let accZ: Double
    let gyrX: Double
    let gyrY: Double
    let gyrZ: Double
    let magX: Double
    let magY: Double
    let magZ: Double
}
