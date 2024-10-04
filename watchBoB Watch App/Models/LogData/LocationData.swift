//
//  LocationData.swift
//  BoB
//
//  Created by Hasan Armoush on 08/08/2024.
//

import Foundation

struct LocationData: Codable {
    var timestamp: [String]
    var latitude: [Double?]
    var longitude: [Double?]
}
