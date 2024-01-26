//
//  LogBookRecord+CoreDataProperties.swift
//  BoB
//
//  Created by Kim Martini on 1/26/24.
//
//

import Foundation
import CoreData


extension LogBookRecord {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LogBookRecord> {
        return NSFetchRequest<LogBookRecord>(entityName: "LogBookRecord")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var startDatetime: Date?
    @NSManaged public var startLatitude: Double
    @NSManaged public var startLongitude: Double
    @NSManaged public var stopDatetime: Date?
    @NSManaged public var stopLatitude: Double
    @NSManaged public var stopLongitude: Double
    @NSManaged public var origin: RecordData?

}

extension LogBookRecord : Identifiable {

}
