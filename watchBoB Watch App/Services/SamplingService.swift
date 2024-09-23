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

    func startSampling(motionManager: MotionManager, locationDataManager: LocationDataManager, metadataLogger: MetadataLogger, waterSubmersionManager: WaterSubmersionManager) {
        metadataLogger.startLogging()
        motionManager.startLogging(10)
        locationDataManager.startSamplingGPS()
        // Commented below since we're handling automatic
//        waterSubmersionManager.startDiveSession()
        
        let device = WKInterfaceDevice.current()
        metadataLogger.deviceName = device.name
        metadataLogger.deviceModel = device.model
        metadataLogger.deviceLocalizedModel = device.localizedModel
        metadataLogger.deviceSystemVersion = device.systemVersion
        metadataLogger.deviceManufacturer = "Apple Inc."
    }

    func stopSampling(motionManager: MotionManager, locationDataManager: LocationDataManager, metadataLogger: MetadataLogger, waterSubmersionManager: WaterSubmersionManager, context: NSManagedObjectContext, dismiss: (() -> Void)?) {
        motionManager.stopLogging()
        metadataLogger.stopLogging()
        locationDataManager.stopSamplingGPS()
        waterSubmersionManager.stopDiveSession()
        
        let newEntry = SampleSet(context: context)
        newEntry.id = metadataLogger.sessionID
        newEntry.startDatetime = metadataLogger.startDatetime
        newEntry.stopDatetime = metadataLogger.stopDatetime
        newEntry.name = metadataLogger.name
        newEntry.startLatitude = metadataLogger.startLatitude
        newEntry.startLongitude = metadataLogger.startLongitude
        newEntry.stopLatitude = metadataLogger.stopLatitude
        newEntry.stopLongitude = metadataLogger.stopLongitude
        
        newEntry.deviceName = metadataLogger.deviceName
        newEntry.deviceModel = metadataLogger.deviceModel
        newEntry.deviceLocalizedModel = metadataLogger.deviceLocalizedModel
        newEntry.deviceSystemVersion = metadataLogger.deviceSystemVersion
        newEntry.deviceManufacturer = metadataLogger.deviceManufacturer
        
        newEntry.sampleCSV = motionManager.convertToJSONString()
        newEntry.gpsJSON = locationDataManager.sampledLocationsToJSON()
        if let submersionJSON = waterSubmersionManager.serializeWaterSubmersionData() {
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
