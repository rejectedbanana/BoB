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
    @NSManaged public var sampleCSV: String?

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
