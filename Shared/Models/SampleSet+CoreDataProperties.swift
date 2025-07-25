//
//  SampleSet+CoreDataProperties.swift
//  watchBoB Watch App
//
//  Created by Kim Martini on 4/23/24.
//
//

import Foundation
import CoreData


extension SampleSet {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SampleSet> {
        return NSFetchRequest<SampleSet>(entityName: "SampleSet")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var fileID: String?
    @NSManaged public var fileName: String?
    @NSManaged public var startDatetime: Date?
    @NSManaged public var startLatitude: Double
    @NSManaged public var startLongitude: Double
    @NSManaged public var stopDatetime: Date?
    @NSManaged public var stopLatitude: Double
    @NSManaged public var stopLongitude: Double
    @NSManaged public var sample: NSSet?
    @NSManaged public var motionJSON: String?
    @NSManaged public var locationJSON: String?
    @NSManaged public var waterSubmersionJSON: String?
    
    // Device Info
    @NSManaged public var deviceName: String?
    @NSManaged public var deviceModel: String?
    @NSManaged public var deviceLocalizedModel: String?
    @NSManaged public var deviceSystemVersion: String?
    @NSManaged public var deviceManufacturer: String?

}

// MARK: Generated accessors for sample
extension SampleSet {

    @objc(addSample:)
    @NSManaged public func addToSample(_ values: NSSet)

    @objc(removeSample:)
    @NSManaged public func removeFromSample(_ values: NSSet)

}

extension SampleSet : Identifiable {

}

extension SampleSet: Codable {
    enum CodingKeys: CodingKey {
        case id
        case fileID
        case fileName
        case startDatetime
        case startLatitude
        case startLongitude
        case stopDatetime
        case stopLatitude
        case stopLongitude
        case sample
        case motionJSON
        case locationJSON
        case waterSubmersionJSON
        case deviceName
        case deviceModel
        case deviceLocalizedModel
        case deviceSystemVersion
        case deviceManufacturer
    }
    
}

extension CodingUserInfoKey {
    static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")
}

enum DecoderConfigurationError: Error {
    case missingManagedObjectContext
}

extension SampleSet {
    // Functions to check the data ranges
    func getMinimumTemperature() -> Double {
        guard let json = waterSubmersionJSON, let data = json.data(using: .utf8) else { return Double.nan }
        do {
            let temperatureData = try JSONDecoder().decode([WaterSubmersionData].self, from: data)
            let minTemp = temperatureData.map({ $0.temperature }).min()
            return minTemp ?? Double.nan
        } catch {
            print("Error parsing submersion JSON for temperature: \(error)")
            return Double.nan
        }
    }
    
    func getMaximumDepth() -> Double {
        guard let json = waterSubmersionJSON, let data = json.data(using: .utf8) else { return Double.nan }
        do {
            let depthData = try JSONDecoder().decode([WaterSubmersionData].self, from: data)
            let maxDepth = depthData.map( { $0.depth } ).max()
            return maxDepth ?? Double.nan
        } catch {
            print("Error parsing submersion JSON for depth: \(error)")
            return Double.nan
        }
    }
    
    func getMotionDataCount() -> Int {
        guard let json = motionJSON, let data = json.data(using: .utf8) else { return 0 }
        do {
            let motionData = try JSONDecoder().decode([MotionData].self, from: data)
            return motionData.count
        } catch {
            print("Error parsing motion JSON for data count: \(error)")
            return 0
        }
    }
}
