//
//  WaterSubmersionData.swift
//  BoB
//
//  Created by Hasan Armoush on 14/08/2024.
//

import Foundation

struct WaterSubmersionData: Codable {
    var timestamp: [String]
    var depth: [Double]
    var temperature: [Double]
//    let surfacePressure: Double?
}
