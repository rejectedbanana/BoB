//
//  phoneLogbookDetail.swift
//  BoB
//
//  Created by Kim Martini on 1/4/24.
//

import SwiftUI

struct LogbookDetail: View {
    let entry: SampleSet
    
    @State private var showMotionJSON = false
    @State private var showLocationJSON = false
    @State private var showSubmersionJSON = false
    @State private var csvName = ""
    @State private var csvContent = ""
    
    // time stamp formatter
    let timeStampFormatter = TimeStampManager()
    
    private var combinedJSON: [String: Any]? {
        return combineJSON()
    }
    
    private func combineJSON() -> [String: Any]? {
        guard let sampleCSV = entry.sampleCSV, let sampleJSON = entry.gpsJSON, let submersionJSON = entry.waterSubmersionJSON else {
            print("No sampleCSV, sampleJSON, or submersionJSON found")
            return nil
        }
        
        let csvData = Data(sampleCSV.utf8)
        let jsonData = Data(sampleJSON.utf8)
        let submersionData = Data(submersionJSON.utf8)
        
        do {
            // Parse the motion data from CSV
            let motionDataArray = try JSONSerialization.jsonObject(with: csvData, options: []) as? [[String: Any]] ?? []
            let motionData = motionDataArray.map { $0.map { $1 } }
            
            // Parse the location data from JSON
            let locationDataArray = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [[String: Any]] ?? []
            let locationData = locationDataArray.map { [$0["timestamp"], $0["latitude"], $0["longitude"]] }
            
            // Parse the submersion data from JSON
            let submersionDataArray = try JSONSerialization.jsonObject(with: submersionData, options: []) as? [[String: Any]] ?? []
            let submersionData = submersionDataArray.map { [$0["timestamp"], $0["depth"], $0["temperature"]] }
            
            // Create structured JSON with metadata
            let structuredJSON: [String: Any] = [
                "MOTION": [
                    "metadata": [
                        "variables": "time,accelerometerX,accelerometerY,accelerometerZ,gyroscopeX,gyroscopeY,gyroscopeZ,magnetometerX,magnetometerY,magnetometerZ",
                        "units": "yyyy-MM-dd'T'HH:mm:ss.SSSZ, m/s, m/s, m/s, radians/s, radians/s, radians/s, microTesla, microTesla, microTesla",
                        "sensor_id": "motion",
                        "description": "3-axis acceleration, rotation, and magnetic field from motion sensors"
                    ],
                    "data": motionData
                ],
                "LOCATION": [
                    "metadata": [
                        "variables": "time,latitude,longitude",
                        "units": "yyyy-MM-dd'T'HH:mm:ss.SSSZ, degrees North, degrees East",
                        "sensor_id": "location",
                        "description": "Location determined from either L1 and L5 GPS, GLONASS, Galileo, QZSS, and BeiDou"
                    ],
                    "data": locationData
                ],
                "SUBMERSION": [
                    "metadata": [
                        "variables": "time,depth,temperature",
                        "units": "yyyy-MM-dd'T'HH:mm:ss.SSSZ, meters, degrees Celsius",
                        "sensor_id": "submersion",
                        "description": "Depth and temperature data from dive sensors when submerged"
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
    
    var body: some View {
        List {
            Section("Sample Details") {
                DetailRow(header: "Minimum Water Temperature", content: String(format: "%.1f °C", getMinimumTemperature(from: entry.waterSubmersionJSON)))
                DetailRow(header: "Maximum Underwater Depth", content: String(format: "%.1f m", getMaximumDepth(from: entry.waterSubmersionJSON)))
                DetailRow(header: "Start Time", content: timeStampFormatter.viewFormat(entry.startDatetime ?? Date(timeIntervalSince1970: 0)))
                DetailRow(header: "End Time", content: timeStampFormatter.viewFormat(entry.stopDatetime ?? Date(timeIntervalSince1970: 0)))
                DetailRow(header: "Samples", content: "\(getSampleCount(from: entry.sampleCSV))")
                DetailRow(header: "Sampling Frequency", content: "10 Hz")
                DetailRow(header: "Source", content: "Kim's Apple Watch")
//                DetailRow(header: "CSV Data", content: entry.sampleCSV ?? "No CSV data.")
                
                // Buttons for viewing JSON data
                Button("View Motion Data") {
                    showMotionJSON.toggle()
                }
                .sheet(isPresented: $showMotionJSON) {
                    JSONView(jsonContent: entry.sampleCSV ?? "No CSV data", title: "Motion Data")
                }
                
                Button("View Location Data") {
                    showLocationJSON.toggle()
                }
                .sheet(isPresented: $showLocationJSON) {
                    JSONView(jsonContent: entry.gpsJSON ?? "No GPS data", title: "Location Data")
                }
                
                Button("View Submersion Data") {
                    showSubmersionJSON.toggle()
                }
                .sheet(isPresented: $showSubmersionJSON) {
                    JSONView(jsonContent: entry.waterSubmersionJSON ?? "No Submersion data", title: "Submersion Data")
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
                ShareLink(item: exportCombinedJSON(fileName: csvName, content: combinedJSONString))
            } else {
                Text("No data to share")
            }
        }
        .onAppear {
            self.csvName = timeStampFormatter.exportNameFormat(entry.startDatetime ?? Date.now )+"_AWUData.csv"
            self.csvContent = entry.sampleCSV ?? "No CSV data"
        }
    }
    
    func getMinimumTemperature(from json: String?) -> Double {
        guard let json = json, let data = json.data(using: .utf8) else { return 0.0 }
        do {
            let submersionDataArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] ?? []
            let temperatures = submersionDataArray.compactMap { $0["temperature"] as? Double }
            return temperatures.min() ?? 0.0
        } catch {
            print("Error parsing submersion JSON for temperature: \(error)")
            return 0.0
        }
    }
    
    func getMaximumDepth(from json: String?) -> Double {
        guard let json = json, let data = json.data(using: .utf8) else { return 0.0 }
        do {
            let submersionDataArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] ?? []
            let depths = submersionDataArray.compactMap { $0["depth"] as? Double }
            return depths.max() ?? 0.0
        } catch {
            print("Error parsing submersion JSON for depth: \(error)")
            return 0.0
        }
    }
    
    func getSampleCount(from csv: String?) -> Int {
        guard let csv = csv else { return 0 }
        return csv.split(separator: "\n").count - 1 // Minus 1 to exclude header row
    }
    
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
