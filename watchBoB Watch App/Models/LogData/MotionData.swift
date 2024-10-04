//
//  MotionData.swift
//  watchBoB Watch App
//
//  Created by Kim Martini on 6/14/24.
//

import Foundation

struct MotionData: Codable {
    var timestamp: [String?]
    var accelerationX: [Double?]
    var accelerationY: [Double?]
    var accelerationZ: [Double?]
    var rotationRateX: [Double?]
    var rotationRateY: [Double?]
    var rotationRateZ: [Double?]
    var magneticFieldX: [Double?]
    var magneticFieldY: [Double?]
    var magneticFieldZ: [Double?]
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        // encode the timestamp
        try container.encode(timestamp, forKey: .timestamp)
        
        // Format data to 6 decimal places
        let formattedAccelerationX = accelerationX.map { $0.map { round( $0 * 1000000 ) / 1000000 } }
        let formattedAccelerationY = accelerationY.map { $0.map { round( $0 * 1000000 ) / 1000000 } }
        let formattedAccelerationZ = accelerationZ.map { $0.map { round( $0 * 1000000 ) / 1000000 } }
        let formattedRotationX = rotationRateX.map { $0.map { round( $0 * 1000000 ) / 1000000 } }
        let formattedRotationY = rotationRateY.map { $0.map { round( $0 * 1000000 ) / 1000000 } }
        let formattedRotationZ = rotationRateZ.map { $0.map { round( $0 * 1000000 ) / 1000000 } }
        let formattedMagneticFieldX = magneticFieldY.map { $0.map { round( $0 * 1000 ) / 1000 } }
        let formattedMagneticFieldY = magneticFieldY.map { $0.map { round( $0 * 1000 ) / 10000 } }
        let formattedMagneticFieldZ = magneticFieldZ.map { $0.map { round( $0 * 1000 ) / 1000 } }
        // encode the formatted values
        try container.encode(formattedAccelerationX, forKey: .accelerationX)
        try container.encode(formattedAccelerationY, forKey: .accelerationY)
        try container.encode(formattedAccelerationZ, forKey: .accelerationZ)
        try container.encode(formattedRotationX, forKey: .rotationRateX)
        try container.encode(formattedRotationY, forKey: .rotationRateY)
        try container.encode(formattedRotationZ, forKey: .rotationRateZ)
        try container.encode(formattedMagneticFieldX, forKey: .magneticFieldX)
        try container.encode(formattedMagneticFieldY, forKey: .magneticFieldY)
        try container.encode(formattedMagneticFieldZ, forKey: .magneticFieldZ)
    }
    
    enum CodingKeys: String, CodingKey {
        case timestamp
        case accelerationX
        case accelerationY
        case accelerationZ
        case rotationRateX
        case rotationRateY
        case rotationRateZ
        case magneticFieldX
        case magneticFieldY
        case magneticFieldZ
    }
}
