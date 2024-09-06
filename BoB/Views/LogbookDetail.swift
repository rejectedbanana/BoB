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
    
    private var parsedMotionJSON: String {
        return entry.sampleJSON ?? "No Motion Data"
    }
    
    private var parsedLocationJSON: String {
        return entry.gpsJSON ?? "No Location Data"
    }
    
    private var parsedSubmersionJSON: String {
        return entry.waterSubmersionJSON ?? "No Submersion Data"
    }
    
    let timeStampFormatter = TimeStampManager()
    private var parsedData: [[String: Any]]? {
        return parseJSON()
    }
    private var combinedJSON: [String: Any]? {
        return combineJSON()
    }
    
    private func combineJSON() -> [String: Any]? {
        guard let sampleJSON = entry.sampleJSON,
              let locationJSON = entry.gpsJSON,
              let submersionJSON = entry.waterSubmersionJSON else {
            print("No sampleJSON, gpsJSON, or waterSubmersionJSON found")
            return nil
        }
        
        let motionData = Data(sampleJSON.utf8)
        let locationData = Data(locationJSON.utf8)
        let submersionData = Data(submersionJSON.utf8)
        
        do {
            let motionJSONObject = try JSONSerialization.jsonObject(with: motionData, options: []) as? [String: Any] ?? [:]
            
            let locationDataArray = try JSONSerialization.jsonObject(with: locationData, options: []) as? [[String: Any]] ?? []
            let locationValues = locationDataArray.map { [$0["timestamp"], $0["latitude"], $0["longitude"]] }
            let submersionDataArray = try JSONSerialization.jsonObject(with: submersionData, options: []) as? [[String: Any]] ?? []
            
            let submersionValues = submersionDataArray.map { [$0["timestamp"], $0["depth"], $0["temperature"]] }
            var structuredJSON = motionJSONObject
            
            structuredJSON["LOCATION"] = [
                "metadata": [
                    "variables": "time,latitude,longitude",
                    "units": "yyyy-MM-dd'T'HH:mm:ss.SSSZ, degrees North, degrees East",
                    "sensor_id": "location",
                    "description": "Location determined from either L1 and L5 GPS, GLONASS, Galileo, QZSS, and BeiDou"
                ],
                "data": locationValues
            ]
            structuredJSON["SUBMERSION"] = [
                "metadata": [
                    "variables": "time,depth,temperature",
                    "units": "yyyy-MM-dd'T'HH:mm:ss.SSSZ, meters, degrees Celsius",
                    "sensor_id": "submersion",
                    "description": "Depth and temperature data from dive sensors when submerged"
                ],
                "data": submersionValues
            ]
            
            return structuredJSON
        } catch {
            debugPrint("Error parsing or combining JSON: \(error)")
            return nil
        }
    }
    
    private func convertCombinedJSONToString() -> String? {
        guard let combinedJSON = combinedJSON else { return nil }
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: combinedJSON, options: .prettyPrinted)
            return String(data: jsonData, encoding: .utf8)
        } catch {
            debugPrint("Error converting combined JSON to string: \(error)")
            return nil
        }
    }
    
    private func parseJSON() -> [[String: Any]]? {
        guard let jsonString = entry.gpsJSON else {
            debugPrint("No JSON string found")
            return nil
        }
        debugPrint("JSON String: \(jsonString)")
        let data = Data(jsonString.utf8)
        do {
            if let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                return jsonArray
            } else {
                debugPrint("JSON is not an array of dictionaries")
                return nil
            }
        } catch {
            debugPrint("Error parsing JSON: \(error)")
            return nil
        }
    }
    
    var body: some View {
        List {
            Section("Sample Details"){
                DetailRow(header: "Minimum Water Temperature", content: String(format: "%.1f °C", getMinimumTemperature(from: entry.waterSubmersionJSON)))
                DetailRow(header: "Maximum Underwater Depth", content: String(format: "%.1f m", getMaximumDepth(from: entry.waterSubmersionJSON)))
                DetailRow(header: "Start Time", content: timeStampFormatter.viewFormat(entry.startDatetime ?? Date(timeIntervalSince1970: 0)))
                DetailRow(header: "End Time", content: timeStampFormatter.viewFormat(entry.stopDatetime ?? Date(timeIntervalSince1970: 0)))
                DetailRow(header: "Samples", content: "\(getSampleCount(from: entry.sampleJSON))")
                DetailRow(header: "Sampling Frequency", content: "10 Hz")
                DetailRow(header: "Source", content: "Kim's Apple Watch")
                Button("View Motion Data") {
                    showMotionJSON.toggle()
                }
                .sheet(isPresented: $showMotionJSON) {
                    JSONView(jsonContent: parsedMotionJSON, title: "Motion Data")
                }
                
                Button("View Location Data") {
                    showLocationJSON.toggle()
                }
                .sheet(isPresented: $showLocationJSON) {
                    JSONView(jsonContent: parsedLocationJSON, title: "Location Data")
                }
                
                Button("View Submersion Data") {
                    showSubmersionJSON.toggle()
                }
                .sheet(isPresented: $showSubmersionJSON) {
                    JSONView(jsonContent: parsedSubmersionJSON, title: "Submersion Data")
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
            if let combinedJSONString = convertCombinedJSONToString(),
               let fileURL = exportCombinedJSON(content: combinedJSONString) {
                ShareLink(item: fileURL) {
                    Text("Share JSON")
                }
            } else {
                Text("No data to share")
            }
        }
    }
    
    func getMinimumTemperature(from json: String?) -> Double {
        guard let json = json, let data = json.data(using: .utf8) else { return 0.0 }
        do {
            let submersionDataArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] ?? []
            let temperatures = submersionDataArray.compactMap { $0["temperature"] as? Double }
            return temperatures.min() ?? 0.0
        } catch {
            debugPrint("Error parsing submersion JSON for temperature: \(error)")
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
            debugPrint("Error parsing submersion JSON for depth: \(error)")
            return 0.0
        }
    }
    
    func getSampleCount(from csv: String?) -> Int {
        guard let csv = csv else { return 0 }
        return csv.split(separator: "\n").count - 1 // Minus 1 to exclude header row
    }
    
    func exportCombinedJSON(content: String) -> URL? {
        guard let startDatetime = entry.startDatetime else {
            debugPrint("Failed to get startDatetime for filename.")
            return nil
        }
        
        let formattedDate = timeStampFormatter.exportNameFormat(startDatetime)
        let fileName = "\(formattedDate)_AWUData.json"
        
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            debugPrint("Failed to access documents directory.")
            return nil
        }
        
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        
        do {
            try content.write(to: fileURL, atomically: true, encoding: .utf8)
            debugPrint("JSON written to: \(fileURL)")
        } catch {
            debugPrint("Failed to write JSON: \(error.localizedDescription)")
            return nil
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
