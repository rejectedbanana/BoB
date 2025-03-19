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
    static let shared = WaterSubmersionManager()

    @Published var events: [CMWaterSubmersionEvent] = []
    @Published var isSubmerged: Bool = false
    @Published var measurement: CMWaterSubmersionMeasurement? = nil
    @Published var temperature: CMWaterTemperature? = nil
    @Published var diveSessionRunning: Bool = false
    @Published var waterSubmersionData: WaterSubmersionData = WaterSubmersionData(timestamp: [], depth: [], temperature: [])
    
    // load timestamp formatter
    let timeStampFormatter = TimeStampManager()
    
    // Instantiate the submersion manager
    private var submersionManager: CMWaterSubmersionManager?
    
    // Get the availability of water submersion data
    private var waterSubmersionAvailable: Bool {
        return CMWaterSubmersionManager.waterSubmersionAvailable
    }
    
    // explicitly create the extended runtime session
    private var extendedRuntimeSession: WKExtendedRuntimeSession?

    override private init() {
        super.init()
        
        self.submersionManager = CMWaterSubmersionManager()
        self.submersionManager?.delegate = self
        
        guard let submersionManager = self.submersionManager, CMWaterSubmersionManager.waterSubmersionAvailable else {
            debugPrint("Water submersion is not available on this device.")
            return
        }
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
    
    func clear() {
        events.removeAll()
        isSubmerged = false
        measurement = nil
        temperature = nil
        waterSubmersionData.timestamp.removeAll()
        waterSubmersionData.depth.removeAll()
        waterSubmersionData.temperature.removeAll()
    }
    
    @MainActor
    private func addSubmersionSample(measurement: CMWaterSubmersionMeasurement?, temperature: CMWaterTemperature?) {
        
        // grab the water depth
        guard let depth = measurement?.depth?.value else {
            debugPrint("No depth data available")
            return
        }
        
        // grab the temperature timestamp
        guard let ttimestamp = temperature?.date else {
            debugPrint("No temperature timestamp available")
            return
        }
        
        // grab the pressure timestamp
        guard let ptimestamp = measurement?.date else {
            debugPrint("No pressure timestamp available")
            return
        }
        
        // determine if the timestamp is unique, exit otherwise (takes into account temp and pressure are measured at the same time, but queried at different times)
        if ttimestamp == ptimestamp {
            debugPrint("Pressure and temperature timestamps are identical.")
            return
        }
                
        // grab the water temperature
        guard let temperature = temperature?.temperature.value else {
            debugPrint("No temperature data available")
            return
        }
        
        // append the data
        waterSubmersionData.timestamp.append(timeStampFormatter.ISO8601Format(ptimestamp))
        waterSubmersionData.depth.append(depth)
        waterSubmersionData.temperature.append(temperature)
        
    }
    
    // determine if water submersion is available
    func isWaterSubmersionAvailable() -> Bool {
        CMWaterSubmersionManager.waterSubmersionAvailable
    }
    
    // explicitly start a runtime session
    func startDiveSession() {
        debugPrint("[WKExtendedRuntimeSession] *** Starting a dive session. ***")
        
        // create the extended runtime session here because you can't pass it in from SamplingService
        let session = WKExtendedRuntimeSession()
        
        // Assign a delegate to the session
        session.delegate = self
        
        // Start the session
        session.start()
        
        // Pass the extended runtime session back to the manager class
        self.extendedRuntimeSession = session
        
        // Start the dive session
        diveSessionRunning = true
        debugPrint("[WKExtendedRuntimeSession] *** Dive session started. Waiting for submersion... ***")
        
        // runs until you
        // 1. explicitly cancel the session by calling invadidate()
        // 2. The wearer turns off Water Lock
        // 3. Your app remains in the CMWaterSubmersionEvent.State.notSubmerged for 10 minutes
    }
    
    // explicitly end the runtime session
    func stopDiveSession() {
        // Stop the dive session
        debugPrint("[WKExtendedRuntimeSession] *** Stopping dive session. ***")
        diveSessionRunning = false
        
        // Stop the extended runtime session
        extendedRuntimeSession?.invalidate()
        debugPrint("[WKExtendedRuntimeSession] *** Extended runtime session invalidated. ***")
        
        // Reset the extended runtime session
        extendedRuntimeSession = nil
    }

    // automatically start a runtime session when the watch descends below 1 meter
    func handleAutomaticSession(_ session: WKExtendedRuntimeSession) {
        debugPrint("[WKExtendedRuntimeSession] *** Handling automatic dive session. ***")
        
        // assign a delegate to the session
        session.delegate = self
        
        // Pass the extended runtime session back to the manager class
        self.extendedRuntimeSession = session
        
        // Start the dive session
        diveSessionRunning = true
        debugPrint("[WKExtendedRuntimeSession] *** Dive session started. Submerged to 1 meter. ***")
        
        // automatically enable waterlock
        enableWaterLock()
        debugPrint("[WKExtendedRuntimeSession] *** Water lock enabled. ***")
        
    }
    
    func enableWaterLock() {
        debugPrint("[Water Lock] *** Activating Water Lock. ***")
        WKInterfaceDevice.current().enableWaterLock()
    }
    
    func convertArrayToJSONString() -> String? {
        guard !waterSubmersionData.timestamp.isEmpty else {
            debugPrint("No submersion data to serialize.")
            return nil
        }
        
        let encoder = JSONEncoder()
        do {
            let jsonData = try encoder.encode(waterSubmersionData)
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        } catch {
            print("[Encoder] Failed to encode submersion data: \(error)")
            return nil
        }
    }
}

// notifies when something interesting happens with CMWaterSubmersionDelegate
extension WaterSubmersionManager: CMWaterSubmersionManagerDelegate {
    // respond to events
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
            }
//            } else {
//                debugPrint("Watch is not submerged. Pausing data collection.")
//                diveSessionRunning = true
//                isSubmerged = false
//            }
        }
    }
    
    // receive submersion measurement update (surface pressure, water pressure, depth, submersion state)
    nonisolated func manager(_ manager: CMWaterSubmersionManager, didUpdate measurement: CMWaterSubmersionMeasurement) {
        if diveSessionRunning {
            
            let submerged: Bool?
            switch measurement.submersionState {
            case .unknown:
                debugPrint("[Dive Session] *** Unknown Depth ***")
                submerged = nil
            case .notSubmerged:
                debugPrint("[Dive Session] *** Not Submerged ***")
                submerged = false
            case .submergedShallow, .submergedDeep, .approachingMaxDepth, .pastMaxDepth:
                debugPrint("[Dive Session] *** Submerged State: \(measurement.submersionState) ***")
                submerged = true
            case .sensorDepthError:
                debugPrint("[Dive Session] *** A depth error has occurred. ***")
                submerged = nil
            @unknown default:
                fatalError("[Dive Session] *** An unknown measurement depth state: \(measurement.submersionState)")
            }
            
            if submerged == true {
                // Output depth and pressure  values for debugging
                let mdate = measurement.date
                let depth = measurement.depth
                let currentDepth = "\(mdate): \(depth?.value ?? Double.nan) \(depth?.unit ?? .meters)"
                debugPrint("[Submerged] *** Depth: \(currentDepth) ***")
                let pressure = measurement.pressure
                let currentPressure = "\(mdate): \(pressure?.value ?? Double.nan) \(pressure?.unit ?? .hectopascals)"
                debugPrint("[Submerged] *** Pressure: \(currentPressure) ***")
//                let surfacePressure = measurement.surfacePressure
//                let currentSurfacePressure = "\(mdate): \(surfacePressure.value) \(surfacePressure.unit)"
//                debugPrint("*** [Submerged] Surface Pressure: \(currentSurfacePressure) ***")
//                let calculatedPressure = (surfacePressure.value - (pressure?.value ?? 0.0))/100 // 1 hPa = 0.01 dbar
//                debugPrint("*** [Submerged] Calculated Pressure: \(calculatedPressure) dbar ***")
            }
            
            Task {
                await set(measurement: measurement)
                if let submerged = submerged {
                    await set(submerged: submerged)
                }
                // add the pressure measurement and the pressure timestamp
                await addSubmersionSample(measurement: measurement, temperature: self.temperature)
            }
        }
    }
    
    // receive temperature measurement update (temperature, temperature uncertainty)
    nonisolated func manager(_ manager: CMWaterSubmersionManager, didUpdate measurement: CMWaterTemperature) {
        if diveSessionRunning {
            let mdate = measurement.date
            let temp = measurement.temperature
            let uncertainty = measurement.temperatureUncertainty
            let currentTemperature = "\(mdate): \(temp.value) +/- \(uncertainty.value) \(temp.unit)"
            
            debugPrint("[Submerged] *** Temperature: \(currentTemperature) ***")
            
            Task {
                await set(temperature: measurement)
                // add the temperature measurement and the temperature timestamp
                await addSubmersionSample(measurement: self.measurement, temperature: measurement)
            }
        }
    }
    
    nonisolated func manager(_ manager: CMWaterSubmersionManager, errorOccurred error: Error) {
        debugPrint("[Submersion Manager] *** An error occurred: \(error.localizedDescription) ***")
    }
}

// notifies when something interesting happns with WKExtendedRuntimeSession
// MARK:- Extended Runtime Session Delegate Methods
extension WaterSubmersionManager: WKExtendedRuntimeSessionDelegate {
    func extendedRuntimeSession(_ extendedRuntimeSession: WKExtendedRuntimeSession, didInvalidateWith reason: WKExtendedRuntimeSessionInvalidationReason, error: Error?) {
        // Track when your session ends.
        // Also handle errors here.
        debugPrint("[WKExtendedRuntimeSession] *** Submersion Session invalidated with reason: \(reason.rawValue) and error: \(error?.localizedDescription ?? "nil") ***")
//        stopDiveSession()
    }
    
    func extendedRuntimeSessionDidStart(_ extendedRuntimeSession: WKExtendedRuntimeSession) {
        // Track when your session starts.
        debugPrint("[WKExtendedRuntimeSession] *** Submersion Session started. ***")
    }
    
    func extendedRuntimeSessionWillExpire(_ extendedRuntimeSession: WKExtendedRuntimeSession) {
        // Finish and clean up any tasks before the session ends.
        debugPrint("[WKExtendedRuntimeSession] *** Submersion Session will expire. ***")
//        stopDiveSession()
    }
}
