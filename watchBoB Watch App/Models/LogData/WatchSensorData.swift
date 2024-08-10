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
    
    func convertToJSONString() -> String? {
        let lines = dataCSV.split(separator: "\n").map { String($0) }
        guard let headerLine = lines.first else { return nil }
        
        let headers = headerLine.split(separator: ",").map { String($0) }
        var jsonArray: [[String: Any]] = []
        
        for line in lines.dropFirst() { // Skip the header line
            let values = line.split(separator: ",").map { String($0) }
            var jsonObject: [String: Any] = [:]
            
            for (index, header) in headers.enumerated() {
                if index < values.count {
                    let valueString = values[index]
                    if let value = Double(valueString), !value.isNaN, !value.isInfinite {
                        jsonObject[header] = value
                    } else {
                        jsonObject[header] = valueString // Keep the original string if it's not a valid number
                    }
                }
            }
            jsonArray.append(jsonObject)
        }
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: jsonArray, options: .prettyPrinted)
            return String(data: jsonData, encoding: .utf8)
        } catch {
            print("Failed to serialize JSON: \(error)")
            return nil
        }
    }
    
    mutating func reset() {
        self.dataCSV = self.header
    }
    
}
