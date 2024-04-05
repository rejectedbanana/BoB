//
//  SettingManager.swift
//  watchBoB Watch App
//
//  Created by Kim Martini on 1/3/24.
//

import Foundation
import Combine

class SettingsManager: ObservableObject {
    
    // Sampling frequency in Hertz (1/sampling period)
    @Published var samplingFrequency: Double = 10 
    
}
