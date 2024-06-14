//
//  WatchSensorData.swift
//  watchBoB Watch App
//
//  Created by Kim Martini on 6/14/24.
//

import Foundation

enum SensorType {
    case Accelerometer
    case Gyroscope
    case Magnetometer
}

struct WatchSensorData {
    var accelerometerData: String
    
    private var header = "time,x,y,z\n"
    
    init() {
        self.accelerometerData = self.header
    }
    
    // append the data with a new line of string
    mutating func append(time: String, x: Double, y: Double, z: Double, sensorType: SensorType) {
        var line = time + ","
        line.append(String(x) + ",")
        line.append(String(y) + ",")
        line.append(String(z) + "\n")
        
        switch sensorType {
        case .Accelerometer:
            self.accelerometerData.append(line)
        default:
            print("Data from \(sensorType) is not available")
        }
    }
    
    mutating func reset() {
        self.accelerometerData = self.header
    }
    
}
