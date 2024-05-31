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
public class SampleSet: NSManagedObject, Codable {
    
//    // Define the JSON keys that we want to use when decoding data
//    enum CodingKeys: CodingKey {
//        case name
//    }
    
    // Intializer
    public required convenience init(from decoder: Decoder) throws {
        // Make the managed object context available within init
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
            throw DecoderError.missingManagedObjectContext
        }
        
        self.init(context: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
    }
    

}

enum DecoderError: Error {
    case missingManagedObjectContext
}

// extend CodingUserInfoKey to create a managed object context key
extension CodingUserInfoKey {
  static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")!
}
