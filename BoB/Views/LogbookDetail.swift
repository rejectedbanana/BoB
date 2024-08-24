//
//  phoneLogbookDetail.swift
//  BoB
//
//  Created by Kim Martini on 1/4/24.
//

import SwiftUI

struct LogbookDetail: View {
    let entry: SampleSet
    
    @State private var csvName = ""
    @State private var csvContent = ""
    
    // time stamp formatter
    let timeStampFormatter = TimeStampManager()
    private var parsedData: [[String: Any]]? {
        return parseJSON()
    }
    private var combinedJSON: [String: Any]? {
        return combineJSON()
    }
    
    private func combineJSON() -> [String: Any]? {
        guard let sampleCSV = entry.sampleCSV, let sampleJSON = entry.gpsJSON else {
            print("No sampleCSV or sampleJSON found")
            return nil
        }
        
        let csvData = Data(sampleCSV.utf8)
        let jsonData = Data(sampleJSON.utf8)
        
        do {
            // Parse the motion data from CSV
            let motionDataArray = try JSONSerialization.jsonObject(with: csvData, options: []) as? [[String: Any]] ?? []
            let motionData = motionDataArray.map { $0.map { $1 } }
            
            // Parse the location data from JSON
            let locationDataArray = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [[String: Any]] ?? []
            let locationData = locationDataArray.map { [$0["timestamp"], $0["latitude"], $0["longitude"]] }
            
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
    
    private func parseJSON() -> [[String: Any]]? {
        guard let jsonString = entry.gpsJSON else {
            print("No JSON string found")
            return nil
        }
        print("JSON String: \(jsonString)") // Debugging line
        let data = Data(jsonString.utf8)
        do {
            if let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                return jsonArray
            } else {
                print("JSON is not an array of dictionaries")
                return nil
            }
        } catch {
            print("Error parsing JSON: \(error)")
            return nil
        }
    }
    
    var body: some View {
        List {
            Section("Sample Details"){
                DetailRow(header: "Minimum Water Temperature", content: "7.0 °C")
                DetailRow(header: "Maximum Underwater Depth", content: "44.0 m")
                DetailRow(header: "Start Time", content: timeStampFormatter.viewFormat( entry.startDatetime ?? Date(timeIntervalSince1970: 0) ))
                DetailRow(header: "End Time", content: timeStampFormatter.viewFormat( entry.stopDatetime ?? Date(timeIntervalSince1970: 0) ))
                DetailRow(header: "Samples", content: "1430")
                DetailRow(header: "Sampling Frequency", content: "10 Hz")
                DetailRow(header: "Source", content: "Kim's Apple Watch")
                DetailRow(header: "CSV Data", content: entry.sampleCSV ?? "No CSV data.")
                if let dataArray = parsedData {
                    ForEach(dataArray.indices, id: \.self) { index in
                        let item = dataArray[index]
                        if let timestamp = item["timestamp"] as? String,
                           let latitude = item["latitude"] as? Double,
                           let longitude = item["longitude"] as? Double {
                            DetailRow(header: "Location Sample \(index + 1)", content: "Time: \(timeStampFormatter.formattedTime(from: timestamp)), \nLat: \(latitude), \nLon: \(longitude)")
                        }
                    }
                } else {
                    DetailRow(header: "Sample Data", content: "No data available")
                }
            }
            
            Section("Device Details"){
                DetailRow(header: "Name", content: "Apple Watch")
                DetailRow(header: "Manufacturer", content: "Apple Inc.")
                DetailRow(header: "Model", content: "Ultra")
                DetailRow(header: "Hardware Version", content: "Watch6,18")
                DetailRow(header: "Software Version", content: "10.3")
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
