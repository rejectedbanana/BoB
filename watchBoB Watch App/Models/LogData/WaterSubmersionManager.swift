//
//  WaterSubmersionManager.swift
//  BoB
//
//  Created by Hasan Armoush on 13/08/2024.
//

import Foundation
import CoreMotion
import WatchKit

class WaterSubmersionManager: NSObject, ObservableObject {
    @Published var events: [CMWaterSubmersionEvent] = []
    @Published var isSubmerged: Bool = false
    @Published var measurement: CMWaterSubmersionMeasurement? = nil
    @Published var temperature: CMWaterTemperature? = nil
    @Published var diveSessionRunning: Bool = false
    @Published var submersionDataSamples: [SubmersionDataSample] = []
    
    private let submersionManager = CMWaterSubmersionManager()
    private var extendedRuntimeSession: WKExtendedRuntimeSession?
    
    private var waterSubmersionAvailable: Bool {
        return CMWaterSubmersionManager.waterSubmersionAvailable
    }
    
    override init() {
        super.init()
        submersionManager.delegate = self
    }
    
    @MainActor
    private func add(event: CMWaterSubmersionEvent) async {
        events.append(event)
    }
    
    @MainActor
    private func set(submerged: Bool) async {
        isSubmerged = submerged
    }
    
    @MainActor
    private func set(measurement: CMWaterSubmersionMeasurement?) {
        self.measurement = measurement
    }
    
    @MainActor
    private func set(temperature: CMWaterTemperature?) {
        self.temperature = temperature
    }
    
    @MainActor
    private func addSubmersionSample(measurement: CMWaterSubmersionMeasurement?, temperature: CMWaterTemperature?) {
        guard let depth = measurement?.depth?.value else {
            debugPrint("No depth data available")
            return
        }
        
        guard let tempValue = temperature?.temperature.value else {
            debugPrint("No temperature data available")
            return
        }
        
        let newSample = SubmersionDataSample(
            timestamp: Date(),
            depth: depth,
            temperature: tempValue,
            surfacePressure: measurement?.surfacePressure.value
        )
        submersionDataSamples.append(newSample)
    }
    
    func startDiveSession() {
        debugPrint("[WKExtendedRuntimeSession] *** Starting a dive session. ***")

        let session = WKExtendedRuntimeSession()
        session.delegate = self
        session.start()

        self.extendedRuntimeSession = session
        diveSessionRunning = true
        
        debugPrint("[WKExtendedRuntimeSession] *** Dive session started. Waiting for submersion... ***")
    }
    
    func stopDiveSession() {
        debugPrint("[WKExtendedRuntimeSession] *** Stopping dive session. ***")
        diveSessionRunning = false
        extendedRuntimeSession?.invalidate()
        extendedRuntimeSession = nil
    }
    
    func serializeSubmersionData() -> String? {
        guard !submersionDataSamples.isEmpty else {
            debugPrint("No submersion data to serialize.")
            return nil
        }
        
        let encoder = JSONEncoder()
        do {
            let jsonData = try encoder.encode(submersionDataSamples)
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        } catch {
            print("Failed to encode submersion data: \(error)")
            return nil
        }
    }
}

extension WaterSubmersionManager: CMWaterSubmersionManagerDelegate {
    nonisolated func manager(_ manager: CMWaterSubmersionManager, didUpdate event: CMWaterSubmersionEvent) {
        let submerged: Bool?
        switch event.state {
        case .unknown:
            debugPrint("[Event] *** Received an unknown event. ***")
            submerged = nil
        case .notSubmerged:
            debugPrint("[Event] *** Not Submerged Event ***")
            submerged = false
        case .submerged:
            debugPrint("[Event] *** Submerged Event ***")
            submerged = true
        @unknown default:
            fatalError("[Event] *** Unknown event received: \(event.state) ***")
        }
        Task {
            await add(event: event)
            if let submerged = submerged, submerged == true {
                await set(submerged: submerged)
                debugPrint("Watch is submerged. Starting data collection.")
                diveSessionRunning = true
            } else {
                debugPrint("Watch is not submerged. Pausing data collection.")
                diveSessionRunning = false
            }
        }
    }
    
    nonisolated func manager(_ manager: CMWaterSubmersionManager, didUpdate measurement: CMWaterSubmersionMeasurement) {
        if diveSessionRunning {
            debugPrint("[Measurement] *** Received a depth measurement. ***")
            let submerged: Bool?
            switch measurement.submersionState {
            case .unknown:
                debugPrint("*** Unknown Depth ***")
                submerged = nil
            case .notSubmerged:
                debugPrint("*** Not Submerged ***")
                submerged = false
            case .submergedShallow, .submergedDeep, .approachingMaxDepth, .pastMaxDepth:
                debugPrint("*** Submerged State: \(measurement.submersionState) ***")
                submerged = true
            case .sensorDepthError:
                debugPrint("*** A depth error has occurred. ***")
                submerged = nil
            @unknown default:
                fatalError("*** An unknown measurement depth state: \(measurement.submersionState)")
            }
            
            Task {
                await set(measurement: measurement)
                if let submerged = submerged {
                    await set(submerged: submerged)
                }
                await addSubmersionSample(measurement: measurement, temperature: self.temperature)
            }
        }
    }
    
    nonisolated func manager(_ manager: CMWaterSubmersionManager, didUpdate measurement: CMWaterTemperature) {
        if diveSessionRunning {
            let temp = measurement.temperature
            let uncertainty = measurement.temperatureUncertainty
            let currentTemperature = "\(temp.value) +/- \(uncertainty.value) \(temp.unit)"
            
            debugPrint("*** Temperature: \(currentTemperature) ***")
            
            Task {
                await set(temperature: measurement)
                await addSubmersionSample(measurement: self.measurement, temperature: measurement)
            }
        }
    }
    
    nonisolated func manager(_ manager: CMWaterSubmersionManager, errorOccurred error: Error) {
        debugPrint("*** An error occurred: \(error.localizedDescription) ***")
    }
}

extension WaterSubmersionManager: WKExtendedRuntimeSessionDelegate {
    func extendedRuntimeSession(_ extendedRuntimeSession: WKExtendedRuntimeSession, didInvalidateWith reason: WKExtendedRuntimeSessionInvalidationReason, error: Error?) {
        debugPrint("[WKExtendedRuntimeSession] *** Session invalidated with reason: \(reason.rawValue) and error: \(error?.localizedDescription ?? "nil") ***")
        stopDiveSession()
    }
    
    func extendedRuntimeSessionDidStart(_ extendedRuntimeSession: WKExtendedRuntimeSession) {
        debugPrint("[WKExtendedRuntimeSession] *** Session started. ***")
    }
    
    func extendedRuntimeSessionWillExpire(_ extendedRuntimeSession: WKExtendedRuntimeSession) {
        debugPrint("[WKExtendedRuntimeSession] *** Session will expire. ***")
        stopDiveSession()
    }
}
