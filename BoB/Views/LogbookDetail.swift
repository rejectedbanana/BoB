//
//  phoneLogbookDetail.swift
//  BoB
//
//  Created by Kim Martini on 1/4/24.
//

import SwiftUI

struct LogbookDetail: View {
    let entry: SampleSet
    let jsonParserService: JSONParserService
    
    @State private var showMotionJSON = false
    @State private var showLocationJSON = false
    @State private var showSubmersionJSON = false
    
    private var parsedMotionJSON: String {
        guard let parsedJSON = jsonParserService.parse(entry.sampleJSON ?? "") else {
            return "No Motion Data"
        }
        
        if let dictionary = parsedJSON as? [String: Any] {
            return convertDictionaryToString(dictionary) ?? "No Motion Data"
        } else if let array = parsedJSON as? [[Any]] {
            return convertArrayToString(array) ?? "No Motion Data"
        } else {
            return "No Motion Data"
        }
    }

    private var parsedLocationJSON: String {
        guard let parsedJSON = jsonParserService.parse(entry.gpsJSON ?? "") else {
            return "No Location Data"
        }
        
        if let dictionary = parsedJSON as? [String: Any] {
            return convertDictionaryToString(dictionary) ?? "No Location Data"
        } else if let array = parsedJSON as? [[Any]] {
            return convertArrayToString(array) ?? "No Location Data"
        } else {
            return "No Location Data"
        }
    }

    private var parsedSubmersionJSON: String {
        guard let parsedJSON = jsonParserService.parse(entry.waterSubmersionJSON ?? "") else {
            return "No Submersion Data"
        }
        
        if let dictionary = parsedJSON as? [String: Any] {
            return convertDictionaryToString(dictionary) ?? "No Submersion Data"
        } else if let array = parsedJSON as? [[Any]] {
            return convertArrayToString(array) ?? "No Submersion Data"
        } else {
            return "No Submersion Data"
        }
    }

    private func convertDictionaryToString(_ dictionary: [String: Any]) -> String? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
            return String(data: jsonData, encoding: .utf8)
        } catch {
            debugPrint("Error converting dictionary to string: \(error)")
            return nil
        }
    }
    
    private func convertArrayToString(_ array: [[Any]]) -> String? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: array, options: .prettyPrinted)
            return String(data: jsonData, encoding: .utf8)
        } catch {
            debugPrint("Error converting array to string: \(error)")
            return nil
        }
    }
    
    let timeStampFormatter = TimeStampManager()
    
    private func combineJSON() -> [String: Any]? {
        guard let sampleJSON = entry.sampleJSON,
              let locationJSON = entry.gpsJSON,
              let submersionJSON = entry.waterSubmersionJSON else {
            debugPrint("No sampleJSON, gpsJSON, or waterSubmersionJSON found")
            return nil
        }

        // Parse motion data (expected to be a dictionary with a "data" key holding an array of arrays)
        guard let motionJSONObject = try? JSONSerialization.jsonObject(with: Data(sampleJSON.utf8), options: []) as? [String: Any],
              let motionDataArray = motionJSONObject["data"] as? [[Any]] else {
            debugPrint("Failed to parse motion data")
            return nil
        }

        // Parse location data (expected to be an array of dictionaries)
        guard let locationDataArray = try? JSONSerialization.jsonObject(with: Data(locationJSON.utf8), options: []) as? [[String: Any]] else {
            debugPrint("Failed to parse location data")
            return nil
        }

        // Parse submersion data (expected to be an array of dictionaries)
        guard let submersionDataArray = try? JSONSerialization.jsonObject(with: Data(submersionJSON.utf8), options: []) as? [[String: Any]] else {
            debugPrint("Failed to parse submersion data")
            return nil
        }

        var structuredJSON: [String: Any] = [
            "MOTION": [
                "metadata": [
                    "variables": "time,accelerometerX,accelerometerY,accelerometerZ,gyroscopeX,gyroscopeY,gyroscopeZ,magnetometerX,magnetometerY,magnetometerZ",
                    "units": "yyyy-MM-dd'T'HH:mm:ss.SSSZ, m/s, m/s, m/s, radians/s, radians/s, radians/s, microTesla, microTesla, microTesla",
                    "sensor_id": "motion",
                    "description": "3-axis acceleration, rotation, and magnetic field from motion sensors"
                ],
                "data": motionDataArray
            ]
        ]

        structuredJSON["LOCATION"] = [
            "metadata": [
                "variables": "time,latitude,longitude",
                "units": "yyyy-MM-dd'T'HH:mm:ss.SSSZ, degrees North, degrees East",
                "sensor_id": "location",
                "description": "Location determined from either L1 and L5 GPS, GLONASS, Galileo, QZSS, and BeiDou"
            ],
            "data": locationDataArray.map { [$0["timestamp"], $0["latitude"], $0["longitude"]] }
        ]

        structuredJSON["SUBMERSION"] = [
            "metadata": [
                "variables": "time,depth,temperature",
                "units": "yyyy-MM-dd'T'HH:mm:ss.SSSZ, meters, degrees Celsius",
                "sensor_id": "submersion",
                "description": "Depth and temperature data from dive sensors when submerged"
            ],
            "data": submersionDataArray.map { [$0["timestamp"], $0["depth"], $0["temperature"]] }
        ]

        return structuredJSON
    }


    
    var body: some View {
        List {
            Section("Sample Details") {
                DetailRow(header: "Minimum Water Temperature", content: String(format: "%.1f °C", getMinimumTemperature(from: entry.waterSubmersionJSON)))
                DetailRow(header: "Maximum Underwater Depth", content: String(format: "%.1f m", getMaximumDepth(from: entry.waterSubmersionJSON)))
                DetailRow(header: "Start Time", content: timeStampFormatter.viewFormat(entry.startDatetime ?? Date()))
                DetailRow(header: "End Time", content: timeStampFormatter.viewFormat(entry.stopDatetime ?? Date()))
                
                Button("View Motion Data") {
                    showMotionJSON.toggle()
                }.sheet(isPresented: $showMotionJSON) {
                    JSONView(jsonContent: parsedMotionJSON, title: "Motion Data")
                }
                
                Button("View Location Data") {
                    showLocationJSON.toggle()
                }.sheet(isPresented: $showLocationJSON) {
                    JSONView(jsonContent: parsedLocationJSON, title: "Location Data")
                }
                
                Button("View Submersion Data") {
                    showSubmersionJSON.toggle()
                }.sheet(isPresented: $showSubmersionJSON) {
                    JSONView(jsonContent: parsedSubmersionJSON, title: "Submersion Data")
                }
            }
            Section("Device Details") {
                DetailRow(header: "Name", content: entry.deviceName ?? "Unknown")
                DetailRow(header: "Manufacturer", content: entry.deviceManufacturer ?? "Unknown")
                DetailRow(header: "Model", content: entry.deviceModel ?? "Unknown")
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Details")
        .toolbar {
            if let combinedJSONString = jsonParserService.convertToString(combineJSON() ?? [:]) {
                ShareLink(item: combinedJSONString) {
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
            let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]
            let temperatures = jsonArray?.compactMap { $0["temperature"] as? Double }
            return temperatures?.min() ?? 0.0
        } catch {
            return 0.0
        }
    }
    
    func getMaximumDepth(from json: String?) -> Double {
        guard let json = json, let data = json.data(using: .utf8) else { return 0.0 }
        do {
            let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]
            let depths = jsonArray?.compactMap { $0["depth"] as? Double }
            return depths?.max() ?? 0.0
        } catch {
            return 0.0
        }
    }
}

struct LogbookDetail_Preview: PreviewProvider {
    static var previews: some View {
        LogbookDetail(entry: SampleSet(), jsonParserService: DefaultJSONParserService())
    }
}

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
