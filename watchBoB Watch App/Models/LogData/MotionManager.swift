//
//  MotionManager.swift
//  watchBoB Watch App
//
//  Created by Kim Martini on 10/25/23.
//

import Foundation
import CoreMotion

class MotionManager: NSObject, ObservableObject {
    // set up Motion Manager
    var motionManager: CMMotionManager? = CMMotionManager()
    // make empty structure to hold data
    var motionData: [MotionData] = []

    @Published var accX = 0.0
    @Published var accY = 0.0
    @Published var accZ = 0.0
    @Published var gyrX = 0.0
    @Published var gyrY = 0.0
    @Published var gyrZ = 0.0
    @Published var magX = 0.0
    @Published var magY = 0.0
    @Published var magZ = 0.0

    let timeStampFormatter = TimeStampManager()
    @Published var timeStamp = Date()
    @Published var elapsedTime = "00:00"
    var timer = Timer()
    var startTime = Date()
    
    // Units manager for coordinate system preferences
    private let unitsManager = UnitsManager()

    @objc private func sampleSensors() {
        var finalAccX = 0.0, finalAccY = 0.0, finalAccZ = 0.0
        var finalGyrX = 0.0, finalGyrY = 0.0, finalGyrZ = 0.0
        var finalMagX = 0.0, finalMagY = 0.0, finalMagZ = 0.0
        
        // grab the motion data
        if let deviceMotion = motionManager?.deviceMotion {
            let acceleration = deviceMotion.userAcceleration
            let rotationRate = deviceMotion.rotationRate
            let magneticField = deviceMotion.magneticField.field
            
            // Apply coordinate transformation based on setting
            if unitsManager.motionCoordinateSystem == .earth {
                // Transform to earth coordinates using device attitude
                let attitude = deviceMotion.attitude
                
                // Transform acceleration
                let earthAccel = transformToEarthCoordinates(
                    x: acceleration.x, y: acceleration.y, z: acceleration.z,
                    attitude: attitude
                )
                finalAccX = earthAccel.x
                finalAccY = earthAccel.y
                finalAccZ = earthAccel.z
                
                // Transform rotation rate
                let earthRotation = transformToEarthCoordinates(
                    x: rotationRate.x, y: rotationRate.y, z: rotationRate.z,
                    attitude: attitude
                )
                finalGyrX = earthRotation.x
                finalGyrY = earthRotation.y
                finalGyrZ = earthRotation.z
                
                // Transform magnetic field
                let earthMagnetic = transformToEarthCoordinates(
                    x: magneticField.x, y: magneticField.y, z: magneticField.z,
                    attitude: attitude
                )
                finalMagX = earthMagnetic.x
                finalMagY = earthMagnetic.y
                finalMagZ = earthMagnetic.z
            } else {
                // Use device coordinates (original behavior)
                finalAccX = acceleration.x
                finalAccY = acceleration.y
                finalAccZ = acceleration.z
                finalGyrX = rotationRate.x
                finalGyrY = rotationRate.y
                finalGyrZ = rotationRate.z
                finalMagX = magneticField.x
                finalMagY = magneticField.y
                finalMagZ = magneticField.z
            }
        }
        
        // Update published properties for UI display
        accX = finalAccX
        accY = finalAccY
        accZ = finalAccZ
        gyrX = finalGyrX
        gyrY = finalGyrY
        gyrZ = finalGyrZ
        magX = finalMagX
        magY = finalMagY
        magZ = finalMagZ
        
        // grab the timestamps
        timeStamp = Date()
        elapsedTime = String(format: "%.1f", Date().timeIntervalSince(startTime))
        
        // grab the data
        let sampledMotion = MotionData(
            timestamp: timeStampFormatter.ISO8601Format(timeStamp),
            accelerationX: finalAccX,
            accelerationY: finalAccY,
            accelerationZ: finalAccZ,
            angularVelocityX: finalGyrX,
            angularVelocityY: finalGyrY,
            angularVelocityZ: finalGyrZ,
            magneticFieldX: finalMagX,
            magneticFieldY: finalMagY,
            magneticFieldZ: finalMagZ
        )
        
        // append the array
        motionData.append(sampledMotion)
    }

    func startLogging(_ samplingInterval: Double) {
        if motionManager!.isAccelerometerAvailable {
            motionManager?.startAccelerometerUpdates()
        }
        if motionManager!.isDeviceMotionAvailable {
            motionManager?.startDeviceMotionUpdates(using: .xTrueNorthZVertical)
        }
        startTime = Date()
        timer = Timer.scheduledTimer(timeInterval: samplingInterval, target: self, selector: #selector(sampleSensors), userInfo: nil, repeats: true)
    }

    func stopLogging() {
        timer.invalidate()
        if motionManager!.isAccelerometerActive {
            motionManager?.stopAccelerometerUpdates()
        }
        if motionManager!.isDeviceMotionActive {
            motionManager?.stopDeviceMotionUpdates()
        }
    }
    
    // Transform device coordinates to earth coordinates using device attitude
    private func transformToEarthCoordinates(x: Double, y: Double, z: Double, attitude: CMAttitude) -> (x: Double, y: Double, z: Double) {
        // Get the rotation matrix from device to earth coordinates
        let rotationMatrix = attitude.rotationMatrix
        
        // Apply the rotation matrix transformation
        let earthX = rotationMatrix.m11 * x + rotationMatrix.m12 * y + rotationMatrix.m13 * z
        let earthY = rotationMatrix.m21 * x + rotationMatrix.m22 * y + rotationMatrix.m23 * z
        let earthZ = rotationMatrix.m31 * x + rotationMatrix.m32 * y + rotationMatrix.m33 * z
        
        return (x: earthX, y: earthY, z: earthZ)
    }

    func convertArrayToJSONString() -> String? {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        do {
            let jsonData = try encoder.encode(motionData)
            return String(data: jsonData, encoding: .utf8)
        } catch {
            print( "Error encoding motion sensor data to JSON: \(error)")
            return nil
        }
    }

    func clear() {
        accX = 0.0
        accY = 0.0
        accZ = 0.0
        gyrX = 0.0
        gyrY = 0.0
        gyrZ = 0.0
        magX = 0.0
        magY = 0.0
        magZ = 0.0
        elapsedTime = "00:00"
        motionData.removeAll()
    }
}
