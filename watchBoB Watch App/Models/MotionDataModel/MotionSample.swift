//
//  MotionSample.swift
//  watchBoB Watch App
//
//  Created by Ramar Parham on 2/12/24.
//

import Foundation
import CoreData

public class MotionSample: NSManagedObject {
    @NSManaged public var timestamp: Date
    @NSManaged public var accelerometerX: Double
    @NSManaged public var accelerometerY: Double
    @NSManaged public var accelerometerZ: Double
    @NSManaged public var gyroscopeX: Double
    @NSManaged public var gyroscopeY: Double
    @NSManaged public var gyroscopeZ: Double
    @NSManaged public var magnetometerX: Double
    @NSManaged public var magnetometerY: Double
    @NSManaged public var magnetometerZ: Double
}

public class SessionMetadata: NSManagedObject {
    @NSManaged public var sessionID: UUID
    @NSManaged public var startTime: Date
    @NSManaged public var endTime: Date?
}
