//
//  LocationData.swift
//  BoB
//
//  Created by Hasan Armoush on 08/08/2024.
//

import Foundation

struct LocationData: Codable {
    let timestamp: Date
    let latitude: Double?
    let longitude: Double?
}