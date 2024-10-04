//
//  phoneLogbookDetail.swift
//  BoB
//
//  Created by Kim Martini on 1/4/24.
//

import SwiftUI

struct LogbookDetail: View {
    let entry: SampleSet
    
    // Toggles to preview data
    @State private var showMotionJSON = false
    @State private var showLocationJSON = false
    @State private var showSubmersionJSON = false
    
    // Strings to store exported name and data
    @State private var JSONName = ""
    @State private var JSONContent = ""
    private var combinedJSON: CombinedData? {
        return combineJSON().structuredJSON
    }
    
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    
    // time stamp formatter
    let timeStampFormatter = TimeStampManager()
    
    var body: some View {
        List {
            Section("Deployment Details") {
                DetailRow(header: "Start Time", content: timeStampFormatter.viewFormat(entry.startDatetime ?? Date(timeIntervalSince1970: 0)))
                DetailRow(header: "End Time", content: timeStampFormatter.viewFormat(entry.stopDatetime ?? Date(timeIntervalSince1970: 0)))
                DetailRow(header: "Samples", content: "\(entry.getMotionDataCount())")
                DetailRow(header: "Sampling Frequency", content: "10 Hz")
                DetailRow(header: "Min Temp", content: entry.getMinimumTemperature().isNaN ? "no submersion data" : String(format: "%.1f °C", entry.getMinimumTemperature()) )
                DetailRow(header: "Max Depth", content: entry.getMaximumDepth().isNaN ? "no submersion data" : String(format: "%.1f m", entry.getMaximumDepth()))
                DetailRow(header: "Source", content: "Kim's Apple Watch")
            }
            
            Section("Data Viewer") {
                // Buttons for viewing JSON data
                Button("View Location Data") {
                    showLocationJSON.toggle()
                }
                .sheet(isPresented: $showLocationJSON) {
                    JSONView(jsonContent: entry.locationJSON ?? "No Location Data", title: "Location Data")
                }
                
                Button("View Motion Data") {
                    showMotionJSON.toggle()
                }
                .sheet(isPresented: $showMotionJSON) {
                    JSONView(jsonContent: jsonString(for: "MOTION") ?? "No Motion Data", title: "Motion Data")
                }
                
                Button("View Submersion Data") {
                    showSubmersionJSON.toggle()
                }
                .sheet(isPresented: $showSubmersionJSON) {
                    JSONView(jsonContent: jsonString(for: "SUBMERSION") ?? "No Submersion Data", title: "Submersion Data")
                }
            }
            
            Section("Device Details") {
                DetailRow(header: "Name", content: entry.deviceName ?? "Unknown")
                DetailRow(header: "Manufacturer", content: entry.deviceManufacturer ?? "Unknown")
                DetailRow(header: "Model", content: entry.deviceModel ?? "Unknown")
                DetailRow(header: "Hardware Version", content: entry.deviceLocalizedModel ?? "Unknown")
                DetailRow(header: "Software Version", content: entry.deviceSystemVersion ?? "Unknown")
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Details")
        .toolbar {
            if let combinedJSONString = convertCombinedJSONToString() {
                ShareLink(item: exportCombinedJSON(fileName: JSONName, content: combinedJSONString))
            } else {
                Text("No data to share")
            }
        }
        .onAppear {
            self.JSONName = timeStampFormatter.exportNameFormat(entry.startDatetime ?? Date.now )+"_AWUData.json"
            self.JSONContent = entry.motionJSON ?? "No JSON data"
        }
    }

    // Combine the data from all the sensors
    private func combineJSON() -> (structuredJSON: CombinedData?, locationJSON: LocationDataForJSON?, motionJSON: MotionDataForJSON?, submersionJSON: SubmersionDataForJSON?) {
        // Grab the JSON strings from CoreData
        guard let motionJSON = entry.motionJSON, let locationJSON = entry.locationJSON else {
            print("No motionJSON or locationJSON found")
            return (structuredJSON: nil, locationJSON: nil, motionJSON: nil, submersionJSON: nil)
        }
        let submersionJSON = entry.waterSubmersionJSON ?? "[]"
        
        // Turn JSON strings into data
        let location = Data(locationJSON.utf8)
        let locationData = try? decoder.decode( LocationData.self, from: location)
        
        let motion = Data(motionJSON.utf8)
        let motionData = try? decoder.decode( MotionData.self, from: motion)
        
        let submersionData = Data(submersionJSON.utf8)
        
        do {
            // extract location data
            let locationArrays = LocationData(timestamp: locationData?.timestamp ?? [], latitude: locationData?.latitude ?? [], longitude: locationData?.longitude ?? [])
            let locationDataForJSON = LocationDataForJSON(values: locationArrays)
            
            // extract motion data
//            let motionJsonObject = try JSONSerialization.jsonObject(with: motionData, options: []) as? [[String: Any]] ?? []
//            let motionTimeStamp = motionJsonObject.map { $0["timestamp"] as? String }
//            let accX = motionJsonObject.map { $0["accX"] as? Double }
//            let accY = motionJsonObject.map { $0["accY"] as? Double }
//            let accZ = motionJsonObject.map { $0["accZ"] as? Double }
//            let gyrX = motionJsonObject.map { $0["gyrX"] as? Double }
//            let gyrY = motionJsonObject.map { $0["gyrY"] as? Double }
//            let gyrZ = motionJsonObject.map { $0["gyrZ"] as? Double }
//            let magX = motionJsonObject.map { $0["magX"] as? Double }
//            let magY = motionJsonObject.map { $0["magY"] as? Double }
//            let magZ = motionJsonObject.map { $0["magZ"] as? Double }
            let motionArrays = MotionData(timestamp: motionData?.timestamp ?? [], accelerationX: motionData?.accelerationX ?? [], accelerationY: motionData?.accelerationY ?? [], accelerationZ: motionData?.accelerationZ ?? [], rotationRateX: motionData?.rotationRateX ?? [], rotationRateY: motionData?.rotationRateY ?? [], rotationRateZ: motionData?.rotationRateZ ?? [], magneticFieldX: motionData?.magneticFieldX ?? [], magneticFieldY: motionData?.magneticFieldY ?? [], magneticFieldZ: motionData?.magneticFieldZ ?? [])
            let motionDataforJSON = MotionDataForJSON(values: motionArrays)
            
            // extract the submersion data
            let submersionJsonObject = try JSONSerialization.jsonObject(with: submersionData, options: []) as? [[String: Any]] ?? []
            let submersionTimeStamp = submersionJsonObject.map { $0["timestamp"] as? String }
            let waterDepth = submersionJsonObject.map { $0["depth"] as? Double }
            let waterTemperature = submersionJsonObject.map { $0["temperature"] as? Double }
            let submersionArrays = SubmersionArrays(timestamp: submersionTimeStamp, waterDepth: waterDepth, waterTemperature: waterTemperature)
            let submersionDataforJSON = SubmersionDataForJSON(values: submersionArrays)
            
            // Combine the data
            let structuredJSON = CombinedData(LOCATION: locationDataForJSON, MOTION: motionDataforJSON, SUBMERSION: submersionDataforJSON )
            
            return (structuredJSON: structuredJSON, locationJSON: locationDataForJSON, motionJSON: motionDataforJSON, submersionJSON: submersionDataforJSON)
        } catch {
            print("Error parsing or combining JSON: \(error)")
            return (structuredJSON: nil, locationJSON: nil, motionJSON: nil, submersionJSON: nil)
        }
    }

    // Convert combined JSON to a string
    private func convertCombinedJSONToString() -> String? {
        guard let combinedJSON = combinedJSON else { return nil }
        
        encoder.outputFormatting = [.sortedKeys, .prettyPrinted, .withoutEscapingSlashes]
        do {
            let jsonData = try encoder.encode(combinedJSON)
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        } catch {
            print("Error converting combined JSON to string: \(error)")
            return nil
        }
    }
    
    // Temporarily save the CombinedJSON to document storage for export
    func exportCombinedJSON(fileName: String, content: String) -> URL {
        let documentsDirectory = URL.documentsDirectory
        let fileURL = documentsDirectory.appending(path: fileName)
        
        do {
            try content.write(to: fileURL, atomically: true, encoding: .utf8)
        } catch {
            print("Failed to write combined JSON: \(error.localizedDescription)")
        }
        
        return fileURL
    }
    
    // View the piece of the JSON that was prepared for export
    private func jsonString(for sensorType: String) -> String? {
        guard let combinedJSON = combinedJSON else { return nil }
        
        return "Some data string"
        
//        if let sensorData = combinedJSON[sensorType] as? [String: Any],
//           let jsonData = try? JSONSerialization.data(withJSONObject: sensorData, options: [.sortedKeys, .prettyPrinted]),
//           let jsonString = String(data: jsonData, encoding: .utf8) {
//            return jsonString
//        } else {
//            return nil
//        }
    }
}

//#Preview {
//    LogbookDetail()
//}

struct DetailRow: View {
    let header: String
    let content: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(header)
                .font(.callout)
                .foregroundColor(Color.gray)
            Text(content)
                .font(.body)
        }
    }
}
