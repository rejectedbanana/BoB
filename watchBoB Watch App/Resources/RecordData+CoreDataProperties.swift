//
//  RecordData+CoreDataProperties.swift
//  BoB
//
//  Created by Kim Martini on 1/26/24.
//
//

import Foundation
import CoreData


extension RecordData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RecordData> {
        return NSFetchRequest<RecordData>(entityName: "RecordData")
    }

    @NSManaged public var accelerationX: Double
    @NSManaged public var accelerationY: Double
    @NSManaged public var accelerationZ: Double
    @NSManaged public var datetimeStamp: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var magneticFluxX: Double
    @NSManaged public var magneticFluxY: Double
    @NSManaged public var magneticFluxZ: Double
    @NSManaged public var rotationRateX: Double
    @NSManaged public var rotationRateY: Double
    @NSManaged public var rotationRateZ: Double
    @NSManaged public var waterDepth: Double
    @NSManaged public var waterTemperature: Double
    @NSManaged public var logbookRecord: NSSet?

}

// MARK: Generated accessors for logbookRecord
extension RecordData {

    @objc(addLogbookRecordObject:)
    @NSManaged public func addToLogbookRecord(_ value: LogBookRecord)

    @objc(removeLogbookRecordObject:)
    @NSManaged public func removeFromLogbookRecord(_ value: LogBookRecord)

    @objc(addLogbookRecord:)
    @NSManaged public func addToLogbookRecord(_ values: NSSet)

    @objc(removeLogbookRecord:)
    @NSManaged public func removeFromLogbookRecord(_ values: NSSet)

}

extension RecordData : Identifiable {

}
