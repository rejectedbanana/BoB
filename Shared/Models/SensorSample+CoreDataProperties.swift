//
//  SensorSample+CoreDataProperties.swift
//  watchBoB Watch App
//
//  Created by Kim Martini on 4/23/24.
//
//

import Foundation
import CoreData


extension SensorSample {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SensorSample> {
        return NSFetchRequest<SensorSample>(entityName: "SensorSample")
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
    @NSManaged public var sampleSet: SampleSet?

}

extension SensorSample : Identifiable {

}
