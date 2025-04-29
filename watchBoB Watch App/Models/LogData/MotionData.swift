//
//  MotionData.swift
//  watchBoB Watch App
//
//  Created by Kim Martini on 6/14/24.
//

import Foundation

// Motion structure to use inside swift
struct MotionData: Codable {
    var timestamp: String
    var accelerationX: Double?
    var accelerationY: Double?
    var accelerationZ: Double?
    var angularVelocityX: Double?
    var angularVelocityY: Double?
    var angularVelocityZ: Double?
    var magneticFieldX: Double?
    var magneticFieldY: Double?
    var magneticFieldZ: Double?
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        // encode the timestamp
        try container.encode(timestamp, forKey: .timestamp)
        
        // encode the motion
        try container.encode(accelerationX, forKey: .accelerationX)
        try container.encode(accelerationY, forKey: .accelerationY)
        try container.encode(accelerationZ, forKey: .accelerationZ)
        try container.encode(angularVelocityX, forKey: .angularVelocityX)
        try container.encode(angularVelocityY, forKey: .angularVelocityY)
        try container.encode(angularVelocityZ, forKey: .angularVelocityZ)
        try container.encode(magneticFieldX, forKey: .magneticFieldX)
        try container.encode(magneticFieldY, forKey: .magneticFieldY)
        try container.encode(magneticFieldZ, forKey: .magneticFieldZ)
    }
    
    enum CodingKeys: String, CodingKey {
        case timestamp
        case accelerationX
        case accelerationY
        case accelerationZ
        case angularVelocityX
        case angularVelocityY
        case angularVelocityZ
        case magneticFieldX
        case magneticFieldY
        case magneticFieldZ
    }
}

// Motion structure for use to export as JSON
struct MotionArrays: Codable {
    var timestamp: [String?]
    var accelerationX: [Double?]
    var accelerationY: [Double?]
    var accelerationZ: [Double?]
    var angularVelocityX: [Double?]
    var angularVelocityY: [Double?]
    var angularVelocityZ: [Double?]
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
        let formattedRotationX = angularVelocityX.map { $0.map { round( $0 * 1000000 ) / 1000000 } }
        let formattedRotationY = angularVelocityY.map { $0.map { round( $0 * 1000000 ) / 1000000 } }
        let formattedRotationZ = angularVelocityZ.map { $0.map { round( $0 * 1000000 ) / 1000000 } }
        let formattedMagneticFieldX = magneticFieldX.map { $0.map { round( $0 * 1000 ) / 1000 } }
        let formattedMagneticFieldY = magneticFieldY.map { $0.map { round( $0 * 1000 ) / 1000 } }
        let formattedMagneticFieldZ = magneticFieldZ.map { $0.map { round( $0 * 1000 ) / 1000 } }
        // encode the formatted values
        try container.encode(formattedAccelerationX, forKey: .accelerationX)
        try container.encode(formattedAccelerationY, forKey: .accelerationY)
        try container.encode(formattedAccelerationZ, forKey: .accelerationZ)
        try container.encode(formattedRotationX, forKey: .angularVelocityX)
        try container.encode(formattedRotationY, forKey: .angularVelocityY)
        try container.encode(formattedRotationZ, forKey: .angularVelocityZ)
        try container.encode(formattedMagneticFieldX, forKey: .magneticFieldX)
        try container.encode(formattedMagneticFieldY, forKey: .magneticFieldY)
        try container.encode(formattedMagneticFieldZ, forKey: .magneticFieldZ)
    }
    
    enum CodingKeys: String, CodingKey {
        case timestamp
        case accelerationX
        case accelerationY
        case accelerationZ
        case angularVelocityX
        case angularVelocityY
        case angularVelocityZ
        case magneticFieldX
        case magneticFieldY
        case magneticFieldZ
    }
}
