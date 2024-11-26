//
//  SamplingService.swift
//  BoB
//
//  Created by Hasan Armoush on 19/08/2024.
//

import CoreData
import WatchKit


class SamplingService {
    static let shared = SamplingService()

    private init() {}

    func startSampling(motionManager: MotionManager, locationManager: LocationManager, metadataManager: MetadataManager, waterSubmersionManager: WaterSubmersionManager) {
        metadataManager.startLogging()
        motionManager.startLogging(0.1)
        locationManager.startSamplingGPS(1.0)
        // Commented below since we're handling automatic
        waterSubmersionManager.startDiveSession()
        
        let device = WKInterfaceDevice.current()
        metadataManager.deviceName = device.name
        metadataManager.deviceModel = device.model
        metadataManager.deviceLocalizedModel = device.localizedModel
        metadataManager.deviceSystemVersion = device.systemVersion
        metadataManager.deviceManufacturer = "Apple Inc."
    }

    func stopSampling(motionManager: MotionManager, locationManager: LocationManager, metadataManager: MetadataManager, waterSubmersionManager: WaterSubmersionManager, context: NSManagedObjectContext, dismiss: (() -> Void)?) {
        motionManager.stopLogging()
        metadataManager.stopLogging()
        locationManager.stopSamplingGPS()
        waterSubmersionManager.stopDiveSession()
        
        let newEntry = SampleSet(context: context)
        newEntry.id = metadataManager.sessionID
        newEntry.startDatetime = metadataManager.startDatetime
        newEntry.stopDatetime = metadataManager.stopDatetime
        newEntry.name = metadataManager.name
        newEntry.startLatitude = metadataManager.startLatitude
        newEntry.startLongitude = metadataManager.startLongitude
        newEntry.stopLatitude = metadataManager.stopLatitude
        newEntry.stopLongitude = metadataManager.stopLongitude
        
        newEntry.deviceName = metadataManager.deviceName
        newEntry.deviceModel = metadataManager.deviceModel
        newEntry.deviceLocalizedModel = metadataManager.deviceLocalizedModel
        newEntry.deviceSystemVersion = metadataManager.deviceSystemVersion
        newEntry.deviceManufacturer = metadataManager.deviceManufacturer
        
        newEntry.motionJSON = motionManager.convertArrayToJSONString()
        newEntry.locationJSON = locationManager.convertArrayToJSONString()
        if let submersionJSON = waterSubmersionManager.convertArrayToJSONString() {
            newEntry.waterSubmersionJSON = submersionJSON
        }

        do {
            try context.save()
        } catch {
            print("Failed to save log entry: \(error)")
        }
        
        dismiss?()
    }
}
