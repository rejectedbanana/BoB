//
//  MotionDataLogging.swift
//  watchBoB Watch App
//
//  Created by Ramar Parham on 2/13/24.
//

import Foundation
import CoreMotion


class MotionLogger: ObservableObject {
    let motionManager = CMMotionManager()
    let context = PersistenceController.shared.container.viewContext

    func startLogging() {
        
        motionManager.startDeviceMotionUpdates(to: .main) { (motionData, error) in
            guard let motionData = motionData else { return }

            
            let motionSample = MotionSample(context: self.context)
            motionSample.accelerometerX = motionData.userAcceleration.x
            motionSample.accelerometerY = motionData.userAcceleration.y
            motionSample.accelerometerZ = motionData.userAcceleration.z
            
            motionSample.gyroscopeX = motionData.rotationRate.x
            motionSample.gyroscopeY = motionData.rotationRate.y
            motionSample.gyroscopeZ = motionData.rotationRate.z
            
            motionSample.magnetometerX = motionData.magneticField.field.x
            motionSample.magnetometerY = motionData.magneticField.field.y
            motionSample.magnetometerZ = motionData.magneticField.field.z

            motionSample.timestamp = Date()

            
            do {
                try self.context.save()
            } catch {
                print("Failed to save motion sample: \(error)")
            }
        }
    }

    func stopLogging() {
        
        motionManager.stopDeviceMotionUpdates()
    }
}

