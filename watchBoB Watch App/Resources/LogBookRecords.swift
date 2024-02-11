//
// 
//  watchBoB Watch App
//
//  Created by Ramar Parham on 2/11/24.
//

import Foundation
import CoreData

//Needed to subclass NSManagedObject
final class LogBookRecords: NSManagedObject {
    
    @NSManaged var id: UUID
    @NSManaged var name: String
    @NSManaged var startDatetime: Date
    @NSManaged var startLatitude: Double
    @NSManaged var startLongitude: Double
    @NSManaged var stopDatetime: Date
    @NSManaged var stopLatitude: Double
    @NSManaged var stopLongitude: Double
    
    override func awakeFromInsert() {
        super.awakeFromInsert()
        setPrimitiveValue(UUID.self, forKey: "id")
        setPrimitiveValue(false, forKey: "stopLongitude")
    }
}
