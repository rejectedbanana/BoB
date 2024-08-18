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
    func manager(_ manager: CMWaterSubmersionManager, didUpdate event: CMWaterSubmersionEvent) {
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
    
    func manager(_ manager: CMWaterSubmersionManager, didUpdate measurement: CMWaterSubmersionMeasurement) {
        if diveSessionRunning {
            debugPrint("[Measurement] *** Received a depth measurement. ***")
            Task {
                await set(measurement: measurement)
                await addSubmersionSample(measurement: measurement, temperature: self.temperature)
            }
        }
    }
    
    func manager(_ manager: CMWaterSubmersionManager, didUpdate measurement: CMWaterTemperature) {
        if diveSessionRunning {
            debugPrint(("[Temperature] *** \(measurement.temperature.formatted()) ***"))
            Task {
                await set(temperature: measurement)
                await addSubmersionSample(measurement: self.measurement, temperature: temperature)
            }
        }
    }
    
    func manager(_ manager: CMWaterSubmersionManager, errorOccurred error: Error) {
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
