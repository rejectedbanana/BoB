//
//  SubmersionDataSample.swift
//  BoB
//
//  Created by Hasan Armoush on 06/09/2024.
//

import Foundation

struct SubmersionDataSample: Codable {
    let timestamp: Date
    let depth: Double?
    let temperature: Double?
    let surfacePressure: Double?
}
