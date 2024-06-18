//
//  WatchSensorData.swift
//  watchBoB Watch App
//
//  Created by Kim Martini on 6/14/24.
//

import Foundation

struct WatchSensorData {
    var dataCSV: String
    
    // add units later
    private var header = "time,AccelerometerX,AccelerometerY,AccelerometerZ,GyroscopeX,GyroscopeY,GyroscopeZ,MagnetometerX,MagnetometerY,MagnetometerZ\n"
    
    init() {
        self.dataCSV = self.header
    }
    
    // append the data with a new line of string
    mutating func append(time: String, AccX: Double, AccY: Double, AccZ: Double, GyrX: Double, GyrY: Double, GyrZ: Double, MagX: Double, MagY: Double, MagZ: Double) {
        var line = time + ","
        
        line.append(String(AccX) + ",")
        line.append(String(AccY) + ",")
        line.append(String(AccZ) + ",")
        line.append(String(GyrX) + ",")
        line.append(String(GyrY) + ",")
        line.append(String(GyrZ) + ",")
        line.append(String(MagX) + ",")
        line.append(String(MagY) + ",")
        line.append(String(MagZ) + "\n")
        
        print(line)
        
        self.dataCSV.append(line)
        
    }
    
    mutating func reset() {
        self.dataCSV = self.header
    }
    
}
