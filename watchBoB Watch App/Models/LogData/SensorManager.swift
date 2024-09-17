//
//  SensorManager.swift
//  watchBoB Watch App
//
//  Created by Kim Martini on 10/25/23.
//

import Foundation
import CoreMotion
import CoreData

class SensorManager: NSObject, ObservableObject {
    // Start reporting movement
    var motionManager: CMMotionManager? = CMMotionManager()
    // make the structure to save data to
    var data = WatchSensorData()
    
    // device motion variables
    @Published var accX = 0.0
    @Published var accY = 0.0
    @Published var accZ = 0.0
    @Published var gyrX = 0.0
    @Published var gyrY = 0.0
    @Published var gyrZ = 0.0
    @Published var magX = 0.0
    @Published var magY = 0.0
    @Published var magZ = 0.0
    
    // time stamps
    let timeStampFormatter = TimeStampManager()
    @Published var timeStamp = Date()
    @Published var elapsedTime = "00:00.00"
    
    // start the time
    var timer = Timer()
    
    // create a start time variable to calculate elapsed time from
    var startTime = Date()
    
    @objc private func sampleSensors() {
        // grab the accelerometer data [m/s]
        if let data = motionManager?.accelerometerData {
            accX = data.acceleration.x
            accY = data.acceleration.y
            accZ = data.acceleration.z
        } else {
            accX = Double.nan
            accY = Double.nan
            accZ = Double.nan
        }
        //grab the rotation rate [radians/sec]
        if let data = motionManager?.deviceMotion {
            gyrX = data.rotationRate.x
            gyrY = data.rotationRate.y
            gyrZ = data.rotationRate.z
        } else {
            gyrX = Double.nan
            gyrY = Double.nan
            gyrZ = Double.nan
        }
        //grab the magentic field data [microTesla]
        if let data = motionManager?.deviceMotion {
            magX = data.magneticField.field.x
            magY = data.magneticField.field.y
            magZ = data.magneticField.field.z
        } else {
            magX = Double.nan
            magY = Double.nan
            magZ = Double.nan
        }
        
        // Get the time stamps
        timeStamp = Date()
        // get elapsed time string (UPDATE THIS TO A BETTER FORMAT AT SOME POINT)
        elapsedTime = String(format: "%.2f", Date().timeIntervalSince(startTime))
        
        // append the data string
        self.data.append(time: timeStampFormatter.ISO8601Format(timeStamp), AccX: self.accX, AccY: self.accY, AccZ: self.accZ, GyrX: self.gyrX, GyrY: self.gyrZ, GyrZ: self.gyrZ, MagX: self.magX, MagY: self.magY, MagZ: self.magZ)

    }

    // start getting data from the Motion Sensors
    func startLogging(_ freq: Double) {
        // Check if the accelerometer is available. If yes, get updates.
        if motionManager!.isAccelerometerAvailable {
            motionManager?.startAccelerometerUpdates()
        } else {
            print("Accelerometer is not available")
        }
        // check if device motion is available. If yes, get updates.
        if motionManager!.isDeviceMotionAvailable {
            motionManager?.startDeviceMotionUpdates(using: CoreMotion.CMAttitudeReferenceFrame.xTrueNorthZVertical)
        } else {
            print("Device Motion is not available")
        }
        
        // define the start time
        startTime = Date()
        // start the timer to begin sampling on a regular interval
        timer = Timer.scheduledTimer(timeInterval: 1.0/freq, target: self, selector: #selector(sampleSensors), userInfo: nil, repeats: true)
    }
    
    // Stop getting data from the motion sensors
    func stopLogging() {
        // stop the timer
        timer.invalidate()
        
        // Stop getting accelerometer updates.
        if motionManager!.isAccelerometerActive {
            motionManager?.stopAccelerometerUpdates()
        }
        
        // stop getting device motion data
        if motionManager!.isDeviceMotionActive {
            motionManager?.stopDeviceMotionUpdates()
        }
        
        print(data)
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
        elapsedTime = "00:00.00"
        data.reset()
    }
    
    // Save the data to CoreData
    func saveData(timeStamp: Double, accX: Double ) {
        // figure out how to save data to Core Motion here
    }
}
