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

    func startSampling(sensorManager: SensorManager, locationDataManager: LocationDataManager, metadataLogger: MetadataLogger, waterSubmersionManager: WaterSubmersionManager) {
        metadataLogger.startLogging()
        sensorManager.startLogging(10)
        locationDataManager.startSamplingGPS()
        
        waterSubmersionManager.enableWaterLock()
        // Commented below since we're handling automatic
//        waterSubmersionManager.startDiveSession()
        
        let device = WKInterfaceDevice.current()
        metadataLogger.deviceName = device.name
        metadataLogger.deviceModel = device.model
        metadataLogger.deviceLocalizedModel = device.localizedModel
        metadataLogger.deviceSystemVersion = device.systemVersion
        metadataLogger.deviceManufacturer = "Apple Inc."
    }

    func stopSampling(sensorManager: SensorManager, locationDataManager: LocationDataManager, metadataLogger: MetadataLogger, waterSubmersionManager: WaterSubmersionManager, context: NSManagedObjectContext, dismiss: (() -> Void)?) {
        sensorManager.stopLogging()
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
        
        newEntry.sampleCSV = sensorManager.data.convertToJSONString()
        newEntry.gpsJSON = locationDataManager.sampledLocationsToJSON()
        if let submersionJSON = waterSubmersionManager.serializeSubmersionData() {
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
