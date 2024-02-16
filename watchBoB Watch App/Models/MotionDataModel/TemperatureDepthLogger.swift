//
//  TemperatureDepthLogger.swift
//  watchBoB Watch App
//
//  Created by Ramar Parham on 2/16/24.
//

import Foundation
import CoreData

public class WaterTemperature: NSManagedObject {
    @NSManaged public var timestamp: Date
    @NSManaged public var temperature: Double
}

public class WaterDepth: NSManagedObject {
    @NSManaged public var timestamp: Date
    @NSManaged public var depth: Double
}

class TemperatureDepthLogger: ObservableObject {
    let context = PersistenceController.shared.container.viewContext
    var sessionMetadata: SessionMetadata?

    func startLogging() {
        let timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            let temperature = Double.random(in: 0..<100)
            let depth = Double.random(in: 0..<10)

            let temperatureSample = WaterTemperature(context: self.context)
            temperatureSample.timestamp = Date()
            temperatureSample.temperature = temperature

            let depthSample = WaterDepth(context: self.context)
            depthSample.timestamp = Date()
            depthSample.depth = depth

            do {
                try self.context.save()
            } catch {
                print("Failed to save temperature or depth sample: \(error)")
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
        sessionMetadata?.endTime = Date()

        do {
            try context.save()
        } catch {
            print("Failed to save session metadata: \(error)")
        }
    }
}
