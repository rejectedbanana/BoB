//
//  MotionManager.swift
//  watchBoB Watch App
//
//  Created by Kim Martini on 10/25/23.
//

import Foundation
import CoreMotion

class MotionManager: NSObject, ObservableObject {
    var motionManager: CMMotionManager? = CMMotionManager()
    var motionData: MotionData = MotionData(timestamp: [], accelerationX: [], accelerationY: [], accelerationZ: [], rotationRateX: [], rotationRateY: [], rotationRateZ: [], magneticFieldX: [], magneticFieldY: [], magneticFieldZ: [])

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

    @objc private func sampleSensors() {
        // grab the motion data
        if let data = motionManager?.accelerometerData {
            accX = data.acceleration.x
            accY = data.acceleration.y
            accZ = data.acceleration.z
        }
        if let data = motionManager?.deviceMotion {
            gyrX = data.rotationRate.x
            gyrY = data.rotationRate.y
            gyrZ = data.rotationRate.z
            magX = data.magneticField.field.x
            magY = data.magneticField.field.y
            magZ = data.magneticField.field.z
        }
        // grab the timestamps
        timeStamp = Date()
        elapsedTime = String(format: "%.1f", Date().timeIntervalSince(startTime))
        
        // append the arrays
        motionData.timestamp.append(timeStampFormatter.ISO8601Format(timeStamp))
        motionData.accelerationX.append(accX)
        motionData.accelerationY.append(accY)
        motionData.accelerationZ.append(accZ)
        motionData.rotationRateX.append(gyrX)
        motionData.rotationRateY.append(gyrY)
        motionData.rotationRateZ.append(gyrZ)
        motionData.magneticFieldX.append(magX)
        motionData.magneticFieldY.append(magY)
        motionData.magneticFieldZ.append(magZ)
        
        
    }

    func startLogging(_ freq: Double) {
        if motionManager!.isAccelerometerAvailable {
            motionManager?.startAccelerometerUpdates()
        }
        if motionManager!.isDeviceMotionAvailable {
            motionManager?.startDeviceMotionUpdates(using: .xTrueNorthZVertical)
        }
        startTime = Date()
        timer = Timer.scheduledTimer(timeInterval: 1.0 / freq, target: self, selector: #selector(sampleSensors), userInfo: nil, repeats: true)
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

    func convertArrayToJSONString() -> String? {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        do {
            let jsonData = try encoder.encode(motionData)
            return String(data: jsonData, encoding: .utf8)
        } catch {
            print("Error encoding sensor data to JSON: \(error)")
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
        motionData.timestamp.removeAll()
        motionData.accelerationX.removeAll()
        motionData.accelerationY.removeAll()
        motionData.accelerationZ.removeAll()
        motionData.rotationRateX.removeAll()
        motionData.rotationRateY.removeAll()
        motionData.rotationRateZ.removeAll()
        motionData.magneticFieldX.removeAll()
        motionData.magneticFieldY.removeAll()
        motionData.magneticFieldZ.removeAll()
    }
}
