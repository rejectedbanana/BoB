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
    private var combinedJSON: [String: Any]? {
        return combineJSON()
    }
    
    // time stamp formatter
    let timeStampFormatter = TimeStampManager()
    
    var body: some View {
        List {
            Section("Sample Details") {
                DetailRow(header: "Min Temp", content: entry.getMinimumTemperature().isNaN ? "no submersion data" : String(format: "%.1f °C", entry.getMinimumTemperature()) )
                DetailRow(header: "Max Depth", content: entry.getMaximumDepth().isNaN ? "no submersion data" : String(format: "%.1f m", entry.getMaximumDepth()))
                DetailRow(header: "Start Time", content: timeStampFormatter.viewFormat(entry.startDatetime ?? Date(timeIntervalSince1970: 0)))
                DetailRow(header: "End Time", content: timeStampFormatter.viewFormat(entry.stopDatetime ?? Date(timeIntervalSince1970: 0)))
                DetailRow(header: "Samples", content: "\(entry.getMotionDataCount())")
                DetailRow(header: "Sampling Frequency", content: "10 Hz")
                DetailRow(header: "Source", content: "Kim's Apple Watch")
                
                // Buttons for viewing JSON data
                Button("View Motion Data") {
                    showMotionJSON.toggle()
                }
                .sheet(isPresented: $showMotionJSON) {
                    JSONView(jsonContent: jsonString(for: "MOTION") ?? "No Motion Data", title: "Motion Data")
                }
                
                Button("View Location Data") {
                    showLocationJSON.toggle()
                }
                .sheet(isPresented: $showLocationJSON) {
                    JSONView(jsonContent: jsonString(for: "LOCATION") ?? "No Location Data", title: "Location Data")
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
    

    
    private func combineJSON() -> [String: Any]? {
        guard let motionJSON = entry.motionJSON, let locationJSON = entry.locationJSON else {
            print("No motionJSON or locationJSON found")
            return nil
        }
        let jsonData = Data(locationJSON.utf8)
        let submersionJSON = entry.waterSubmersionJSON ?? "[]"
        let submersionData = Data(submersionJSON.utf8)
        
        do {
            let motionDataArray = try JSONSerialization.jsonObject(with: Data(motionJSON.utf8), options: []) as? [[String: Any]] ?? []
            let motionData = motionDataArray.map { [$0["timestamp"], $0["accX"], $0["accY"], $0["accZ"], $0["gyrX"], $0["gyrY"], $0["gyrZ"], $0["magX"], $0["magY"], $0["magZ"]] }
            
            let locationDataArray = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [[String: Any]] ?? []
            let locationData = locationDataArray.map { [$0["timestamp"], $0["latitude"], $0["longitude"]] }
            
            let submersionDataArray = try JSONSerialization.jsonObject(with: submersionData, options: []) as? [[String: Any]] ?? []
            let submersionData = submersionDataArray.map { [$0["timestamp"], $0["depth"], $0["temperature"]] }
            
            let structuredJSON: [String: Any] = [
                "MOTION": [
                    "metadata": [
                        "variables": ["timestamp", "accX", "accY", "accZ", "gyrX", "gyrY", "gyrZ", "magX", "magY", "magZ"].joined(separator: ","),
                        "units": "ISO8601, m/s², m/s², m/s², rad/s, rad/s, rad/s, µT, µT, µT",
                        "sensor_id": "motion",
                        "description": "3-axis acceleration, rotation, and magnetic field from motion sensors"
                    ],
                    "data": motionData
                ],
                "LOCATION": [
                    "metadata": [
                        "variables": "timestamp,latitude,longitude",
                        "units": "ISO8601, degrees, degrees",
                        "sensor_id": "location",
                        "description": "Geographical location data"
                    ],
                    "data": locationData
                ],
                "SUBMERSION": [
                    "metadata": [
                        "variables": "timestamp,depth,temperature",
                        "units": "ISO8601, meters, °C",
                        "sensor_id": "submersion",
                        "description": "Depth and temperature data from submersion sensors"
                    ],
                    "data": submersionData
                ]
            ]
            
            return structuredJSON
        } catch {
            print("Error parsing or combining JSON: \(error)")
            return nil
        }
    }

    // Convert combined JSON to a string
    private func convertCombinedJSONToString() -> String? {
        guard let combinedJSON = combinedJSON else { return nil }
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: combinedJSON, options: .prettyPrinted)
            return String(data: jsonData, encoding: .utf8)
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
        
        if let sensorData = combinedJSON[sensorType] as? [String: Any],
           let jsonData = try? JSONSerialization.data(withJSONObject: sensorData, options: .prettyPrinted),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            return jsonString
        } else {
            return nil
        }
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
