//
//  WaterSubmersionData.swift
//  BoB
//
//  Created by Hasan Armoush on 14/08/2024.
//

import Foundation

struct WaterSubmersionData: Codable {
    let timestamp: String
    let depth: Double?
    let temperature: Double?
    let surfacePressure: Double?
}
