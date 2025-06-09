//
//  JSONExportManager.swift
//  watchBoB Watch App
//
//  Created by Kim Martini on 4/30/25.
//

import Foundation

class JSONExportManager: ObservableObject {
    
    // define structures to hold data
    var entry: SampleSet

    init(_ entry: SampleSet) {
        self.entry = entry
    }
    
    // define encoders and decoders
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    
    // load in a timestamp manager
    let timeStampFormatter = TimeStampManager()
    
    // compute the other properties
    var metaData: watchMetadata {
        return entryToMetaData(entry)
    }
    var locationData: [LocationData] {
        return entryToLocationData(entry)
    }
    var motionData: [MotionData] {
        return entryToMotionData(entry)
    }
    var submersionData: [WaterSubmersionData] {
        return entryToSubmersionData(entry)
    }
    var exportableData: StructuredData? {
        return combineDataIntoStructuredData(metadata: metaData, locationDecoded: locationData, motionDecoded: motionData, submersionDecoded: submersionData) ?? nil
    }
    
    // class methods
    func entryToMetaData(_ entry: SampleSet) -> watchMetadata {
        let samplingStart = SamplingInfo(
            description: "Metadata taken immediately before sampling is started and the watch starts continuously taking data. (Default = Jan 1, 1970 at 12:00 AM)",
            datetime: timeStampFormatter.ISO8601Format(entry.startDatetime ?? Date(timeIntervalSince1970: 0)),
            latitude: entry.startLatitude,
            longitude: entry.startLatitude
            )
        
        let samplingStop = SamplingInfo(
            description: "Metadata taken immediately after sampling is canceled and the watch stops continuously taking data. (Default = Jan 1, 1970 at 12:00 AM)",
            datetime: timeStampFormatter.ISO8601Format(entry.startDatetime ?? Date(timeIntervalSince1970: 0)),
            latitude: entry.startLatitude,
            longitude: entry.startLatitude
            )
        
       return watchMetadata(
            fileID: entry.fileID ?? "unknown",
            fileName: entry.fileName ?? "unknown",
            deviceName: entry.deviceName ?? "unknown",
            deviceManufacturer: entry.deviceManufacturer ?? "unknown",
            deviceModel: entry.deviceModel ?? "unknown",
            deviceHardwareVersion: entry.deviceLocalizedModel ?? "unknown",
            deviceOperatingSystemVersion: entry.deviceSystemVersion ?? "unknown",
            samplingStart: samplingStart,
            samplingStop: samplingStop
        )
    }
    
    func entryToLocationData(_ entry: SampleSet) -> [LocationData] {
        guard let locationJSON = entry.locationJSON else {
            print("No location JSON found in Core Data entry")
            return [LocationData(timestamp: "", latitude: nil, longitude: nil)]
        }
        
        let locationData = locationJSON.data(using: .utf8) ?? Data()
        
        do {
            let locationDecoded = try decoder.decode([LocationData].self, from: locationData)
            return locationDecoded
        } catch {
            return []
        }
    }
    
    func entryToMotionData(_ entry: SampleSet) -> [MotionData] {
        guard let motionJSON = entry.motionJSON else {
            print("No motion JSON found in Core Data entry.")
            return []
        }
        
        let motionData = motionJSON.data(using: .utf8) ?? Data()
        
        do {
            let motionDecoded = try decoder.decode([MotionData].self, from: motionData)
            return motionDecoded
        } catch {
            return []
        }
    }
    
    func entryToSubmersionData(_ entry: SampleSet) -> [WaterSubmersionData] {
        guard let submersionJSON = entry.waterSubmersionJSON else {
            print( "No submersion JSON found in Core Data entry.")
            return []
        }
        
        let submersionData = submersionJSON.data(using: .utf8) ?? Data()
        
        do {
            let submersionDecoded = try decoder.decode([WaterSubmersionData].self, from: submersionData)
            return submersionDecoded
        } catch {
            return []
        }
    }
    
    func combineDataIntoStructuredData(metadata: watchMetadata, locationDecoded: [LocationData], motionDecoded: [MotionData], submersionDecoded: [WaterSubmersionData]) -> StructuredData? {
        
        // Make the structures to fill
        var structuredData: StructuredData?
        var locationArray: LocationArrays = LocationArrays(timestamp: [], latitude: [], longitude: [])
        var motionArray: MotionArrays = MotionArrays(timestamp: [], accelerationX: [], accelerationY: [], accelerationZ: [], angularVelocityX: [], angularVelocityY: [], angularVelocityZ: [], magneticFieldX: [], magneticFieldY: [], magneticFieldZ: [])
        var submersionArray: WaterSubmersionArrays = WaterSubmersionArrays(timestamp: [], depth: [], temperature: [])
        
        // transform the decoded into the structures of arrays
        for location in locationDecoded {
            locationArray.timestamp.append(location.timestamp)
            locationArray.latitude.append(location.latitude)
            locationArray.longitude.append(location.longitude)
        }
        
        for motion in motionDecoded {
            motionArray.timestamp.append(motion.timestamp)
            motionArray.accelerationX.append(motion.accelerationX)
            motionArray.accelerationY.append(motion.accelerationY)
            motionArray.accelerationZ.append(motion.accelerationZ)
            motionArray.angularVelocityX.append(motion.angularVelocityX)
            motionArray.angularVelocityY.append(motion.angularVelocityY)
            motionArray.angularVelocityZ.append(motion.angularVelocityZ)
            motionArray.magneticFieldX.append(motion.magneticFieldX)
            motionArray.magneticFieldY.append(motion.magneticFieldY)
            motionArray.magneticFieldZ.append(motion.magneticFieldZ)
        }
        
        for submersion in submersionDecoded {
            submersionArray.timestamp.append(submersion.timestamp)
            submersionArray.depth.append(submersion.depth)
            submersionArray.temperature.append(submersion.temperature ?? Double.nan)
        }
        
        // Reformat for saving as a compact JSON
        let formattedLocationData = FormattedLocationData(values: locationArray)
        let formattedMotionData = FormattedMotionData(values: motionArray)
        let formattedSubmersionData = FormattedSubmersionData(values: submersionArray)
        
        structuredData = StructuredData(metadata: metadata,location: formattedLocationData, motion: formattedMotionData, submersion: formattedSubmersionData )
        
        // Combine the data
        if let outputData = structuredData {
            return outputData
        } else {
            return nil
        }

    }
    
    func convertStructuredDataToJSONString(_ structuredData: StructuredData?) -> String? {
        encoder.outputFormatting = [.sortedKeys, .withoutEscapingSlashes]
        
        do {
            let jsonData = try encoder.encode(structuredData)
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        } catch {
            print("Error converting combined JSON to string: \(error.localizedDescription)")
            return nil
        }
    }
    
    func exportJSON(fileName: String, content: String) -> URL {
        let documentsDirectory = URL.documentsDirectory
        let fileURL = documentsDirectory.appending(path: fileName)
        
        do {
            try content.write(to: fileURL, atomically: true, encoding: .utf8)
        } catch {
            print("Failed to write combined JSON: \(error.localizedDescription)")
        }
        
        return fileURL
    }
    
}
