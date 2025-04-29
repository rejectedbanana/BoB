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
    // make data to fill in
//    var motionData: MotionData = MotionDa/*ta(timestamp: [], accelerationX: [], accelerationY: [], accelerationZ: [], angularVelocityX: [], angularVelocityY: [], angularVel*/ocityZ: [], magneticFieldX: [], magneticFieldY: [], magneticFieldZ: [])
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
        
//        // append the arrays
//        motionData.timestamp.append(timeStampFormatter.ISO8601Format(timeStamp))
//        motionData.accelerationX.append(accX)
//        motionData.accelerationY.append(accY)
//        motionData.accelerationZ.append(accZ)
//        motionData.angularVelocityX.append(gyrX)
//        motionData.angularVelocityY.append(gyrY)
//        motionData.angularVelocityZ.append(gyrZ)
//        motionData.magneticFieldX.append(magX)
//        motionData.magneticFieldY.append(magY)
//        motionData.magneticFieldZ.append(magZ)
        
        // grab the data
        let sampledMotion = MotionData(
            timestamp: timeStampFormatter.ISO8601Format(timeStamp),
            accelerationX: accX,
            accelerationY: accY,
            accelerationZ: accZ,
            angularVelocityX: gyrX,
            angularVelocityY: gyrY,
            angularVelocityZ: gyrZ,
            magneticFieldX: magX,
            magneticFieldY: magY,
            magneticFieldZ: magZ
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

    func convertArrayToJSONString() -> String? {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        if let jsonData = try? encoder.encode(motionData) {
            return String(data: jsonData, encoding: .utf8)
        }
        debugPrint("motion data not encoded")
        return nil
//        do {
//            let jsonData = try encoder.encode(motionData)
//            return String(data: jsonData, encoding: .utf8)
//        } catch {
//            print("Error encoding sensor data to JSON: \(error)")
//            return nil
//        }
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
//        motionData.timestamp.removeAll()
//        motionData.accelerationX.removeAll()
//        motionData.accelerationY.removeAll()
//        motionData.accelerationZ.removeAll()
//        motionData.angularVelocityX.removeAll()
//        motionData.angularVelocityY.removeAll()
//        motionData.angularVelocityZ.removeAll()
//        motionData.magneticFieldX.removeAll()
//        motionData.magneticFieldY.removeAll()
//        motionData.magneticFieldZ.removeAll()
        motionData.removeAll()
    }
}
