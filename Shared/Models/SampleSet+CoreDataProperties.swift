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
    @NSManaged public var name: String?
    @NSManaged public var startDatetime: Date?
    @NSManaged public var startLatitude: Double
    @NSManaged public var startLongitude: Double
    @NSManaged public var stopDatetime: Date?
    @NSManaged public var stopLatitude: Double
    @NSManaged public var stopLongitude: Double
    @NSManaged public var sample: NSSet?

}

// MARK: Generated accessors for sample
extension SampleSet {

    @objc(addSampleObject:)
    @NSManaged public func addToSample(_ value: SensorSample)

    @objc(removeSampleObject:)
    @NSManaged public func removeFromSample(_ value: SensorSample)

    @objc(addSample:)
    @NSManaged public func addToSample(_ values: NSSet)

    @objc(removeSample:)
    @NSManaged public func removeFromSample(_ values: NSSet)

}

extension SampleSet : Identifiable {

}

extension SampleSet {
    
    // 
    enum CodingKeys: String, CodingKey {
        case name
    }

//    public required convenience init(from decoder: Decoder) throws {
//        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
//            throw DecoderError.missingManagedObjectContext
//        }
//
//        self.init(context: context)
//
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.name = try container.decode(String.self, forKey: .name)
//    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
    }
    
    // Convert from Core Data Object to Codable Object
    func toCodable() -> SampleSetCodable {
        return SampleSetCodable(name: self.name ?? "Name Unknown")
    }
    
    // Initialize a Core Data object from a Codable object
    static func from(codable: SampleSetCodable, context: NSManagedObjectContext) -> SampleSet {
        let sampleSet = SampleSet(context: context)
        sampleSet.name = codable.name
        return sampleSet
    }
    
    
}

//enum DecoderError: Error {
//    case missingManagedObjectContext
//}
