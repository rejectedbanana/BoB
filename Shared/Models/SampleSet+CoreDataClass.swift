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
        self.motionJSON = try container.decode(String.self, forKey: .motionJSON)
        self.locationJSON = try container.decode(String.self, forKey: .locationJSON)
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
        try container.encode(motionJSON, forKey: .motionJSON)
        try container.encode(locationJSON, forKey: .locationJSON)
        try container.encode(waterSubmersionJSON, forKey: .waterSubmersionJSON)
        
        // Device Info
        try container.encode(deviceName, forKey: .deviceName)
        try container.encode(deviceModel, forKey: .deviceModel)
        try container.encode(deviceManufacturer, forKey: .deviceManufacturer)
        try container.encode(deviceSystemVersion, forKey: .deviceSystemVersion)
        try container.encode(deviceLocalizedModel, forKey: .deviceLocalizedModel)
    }
}
