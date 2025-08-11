//
//  UnitsManager.swift
//  BoB
//
//  Created by Kim Martini on 8/8/25.
//

import Foundation

enum SubmersionUnits: String, CaseIterable {
    case metric = "metric"
    case imperial = "imperial"
    
    var displayName: String {
        switch self {
        case .metric: return "Metric [m,°C]"
        case .imperial: return "Imperial [ft,°F]"
        }
    }
    
    var depthUnit: UnitLength {
        switch self {
        case .metric: return .meters
        case .imperial: return .feet
        }
    }
    
    var temperatureUnit: UnitTemperature {
        switch self {
        case .metric: return .celsius
        case .imperial: return .fahrenheit
        }
    }
}

class UnitsManager: ObservableObject {
    @Published var submersionUnits: SubmersionUnits {
        didSet {
            UserDefaults.standard.set(submersionUnits.rawValue, forKey: "submersionUnits")
        }
    }
    
    init() {
        let savedUnits = UserDefaults.standard.string(forKey: "submersionUnits") ?? SubmersionUnits.metric.rawValue
        self.submersionUnits = SubmersionUnits(rawValue: savedUnits) ?? .metric
    }
    
    func convertDepth(_ metersValue: Double) -> Measurement<UnitLength> {
        let depthInMeters = Measurement(value: metersValue, unit: UnitLength.meters)
        let convertedDepth = depthInMeters.converted(to: submersionUnits.depthUnit)
        return convertedDepth
    }
    
    func convertTemperature(_ celsiusValue: Double) -> Measurement<UnitTemperature> {
        let tempInCelsius = Measurement(value: celsiusValue, unit: UnitTemperature.celsius)
        let convertedTemp = tempInCelsius.converted(to: submersionUnits.temperatureUnit)
        return convertedTemp
    }
    
    var depthUnitSymbol: String {
        switch submersionUnits.depthUnit {
        case .meters: return "m"
        case .feet: return "ft"
        default: return submersionUnits.depthUnit.symbol
        }
    }
    
    var temperatureUnitSymbol: String {
        switch submersionUnits.temperatureUnit {
        case .celsius: return "°C"
        case .fahrenheit: return "°F"
        default: return submersionUnits.temperatureUnit.symbol
        }
    }
}
