//
//  SampleSet+CoreDataClass.swift
//  watchBoB Watch App
//
//  Created by Kim Martini on 4/23/24.
//
//

import Foundation
import CoreData

@objc(SampleSet)
public class SampleSet: NSManagedObject {
    
    public required convenience init(from decoder: any Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext!] as? NSManagedObjectContext else {
                    throw DecoderConfigurationError.missingManagedObjectContext
                }

        self.init(context: context)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.startDatetime = try container.decode(Date.self, forKey: .startDatetime)
        self.startLatitude = try container.decode(Double.self, forKey: .startLatitude)
        self.startLongitude = try container.decode(Double.self, forKey: .startLongitude)
        self.stopDatetime = try container.decode(Date.self, forKey: .stopDatetime)
        self.stopLatitude = try container.decode(Double.self, forKey: .stopLatitude)
        self.startLongitude = try container.decode(Double.self, forKey: .stopLongitude)
        self.sampleCSV = try container.decode(String.self, forKey: .sampleCSV)
        self.gpsJSON = try container.decode(String.self, forKey: .gpsJSON)
        self.waterSubmersionJSON = try container.decode(String.self, forKey: .waterSubmersionJSON)
        
        // Device Info
        self.deviceName = try container.decode(String.self, forKey: .deviceName)
        self.deviceModel = try container.decode(String.self, forKey: .deviceModel)
        self.deviceManufacturer = try container.decode(String.self, forKey: .deviceManufacturer)
        self.deviceSystemVersion = try container.decode(String.self, forKey: .deviceSystemVersion)
        self.deviceLocalizedModel = try container.decode(String.self, forKey: .deviceLocalizedModel)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(startDatetime, forKey: .startDatetime)
        try container.encode(startLatitude, forKey: .startLatitude)
        try container.encode(startLongitude, forKey: .startLongitude)
        try container.encode(stopDatetime, forKey: .stopDatetime)
        try container.encode(stopLatitude, forKey: .stopLatitude)
        try container.encode(stopLongitude, forKey: .stopLongitude)
        try container.encode(sampleCSV, forKey: .sampleCSV)
        try container.encode(gpsJSON, forKey: .gpsJSON)
        try container.encode(waterSubmersionJSON, forKey: .waterSubmersionJSON)
        
        // Device Info
        try container.encode(deviceName, forKey: .deviceName)
        try container.encode(deviceModel, forKey: .deviceModel)
        try container.encode(deviceManufacturer, forKey: .deviceManufacturer)
        try container.encode(deviceSystemVersion, forKey: .deviceSystemVersion)
        try container.encode(deviceLocalizedModel, forKey: .deviceLocalizedModel)
    }
    
    // Functions to check the data ranges
    func getMinimumTemperature() -> Double {
        guard let json = waterSubmersionJSON, let data = json.data(using: .utf8) else { return Double.nan }
        do {
            let submersionDataArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] ?? []
            let temperatures = submersionDataArray.compactMap { $0["temperature"] as? Double }
            return temperatures.min() ?? Double.nan
        } catch {
            print("Error parsing submersion JSON for temperature: \(error)")
            return Double.nan
        }
    }
    
    func getMaximumDepth() -> Double {
        guard let json = waterSubmersionJSON, let data = json.data(using: .utf8) else { return Double.nan }
        do {
            let submersionDataArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] ?? []
            let depths = submersionDataArray.compactMap { $0["depth"] as? Double }
            return depths.max() ?? Double.nan
        } catch {
            print("Error parsing submersion JSON for depth: \(error)")
            return Double.nan
        }
    }
    
    func getMotionDataCount() -> Int {
        guard let json = sampleCSV, let data = json.data(using: .utf8) else { return 0 }
        do {
            let motionDataArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] ?? []
            let accelerationX = motionDataArray.compactMap { $0["accX"] as? Double }
            return accelerationX.count
        } catch {
            print("Error parsing motion JSON for data count: \(error)")
            return 0
        }
    }
    
    
}
