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
    
    var sessionMetadata: SessionMetadata?

    func startLogging() {
        
        motionManager.startDeviceMotionUpdates(to: .main) { (motionData, error) in
            guard let motionData = motionData else { return }

            
            let motionSample = MotionSample(context: self.context)
            motionSample.accelerometerX = motionData.userAcceleration.x
            motionSample.accelerometerY = motionData.userAcceleration.y
            motionSample.accelerometerZ = motionData.userAcceleration.z
            

            motionSample.timestamp = Date()

            
            do {
                try self.context.save()
            } catch {
                print("Failed to save motion sample: \(error)")
            }
        }

        
        sessionMetadata = SessionMetadata(context: context)
        sessionMetadata?.sessionID = UUID()
        sessionMetadata?.startTime = Date()

        do {
            try context.save()
        } catch {
            print("Failed to save session metadata: \(error)")
        }
    }

    func stopLogging() {
        
        motionManager.stopDeviceMotionUpdates()

       
        sessionMetadata?.endTime = Date()

        do {
            try context.save()
        } catch {
            print("Failed to save session metadata: \(error)")
        }
    }
}

