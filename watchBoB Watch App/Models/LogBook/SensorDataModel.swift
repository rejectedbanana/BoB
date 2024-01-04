//
//  SensorDataModel.swift
//  watchBoB Watch App
//
//  Created by Kim Martini on 10/25/23.
//

import Foundation

struct SensorData {
    var accelerometerData: String
    
    private let column = "time,x\n"
    
    init() {
        self.accelerometerData = self.column
    }
    
    mutating func append(time: String, x: Double) {
        var line = time + ","
        line.append(String(x) + "\n")
        
        accelerometerData.append(line)
    }
    
    mutating func reset() {
        accelerometerData = column
    }
    
}
