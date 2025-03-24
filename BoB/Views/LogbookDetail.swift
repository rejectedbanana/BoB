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
    private var combinedData: StructuredData? {
        return combineJSONsIntoStructuredData()
    }
    
    // encoders and decosers for JSON output
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    
    // time stamp formatter
    let timeStampFormatter = TimeStampManager()
    
    var body: some View {
        List {
            Section("Deployment Map") {
                DataMap(combinedData: combinedData)
                    .frame(height: 250)
                    .listRowInsets(EdgeInsets())
            }
            
            Section("Deployment Details") {
                DetailRow(header: "Start Time", content: timeStampFormatter.viewFormat(entry.startDatetime ?? Date(timeIntervalSince1970: 0)))
                DetailRow(header: "End Time", content: timeStampFormatter.viewFormat(entry.stopDatetime ?? Date(timeIntervalSince1970: 0)))
                DetailRow(header: "Samples", content: "\(entry.getMotionDataCount())")
                DetailRow(header: "Sampling Frequency", content: "10 Hz")
                DetailRow(header: "Min Temp", content: entry.getMinimumTemperature().isNaN ? "no submersion data" : String(format: "%.1f °C", entry.getMinimumTemperature()) )
                DetailRow(header: "Max Depth", content: entry.getMaximumDepth().isNaN ? "no submersion data" : String(format: "%.1f m", entry.getMaximumDepth()))
                DetailRow(header: "Source", content: entry.deviceName ?? "Unknown")
            }
            
            Section("Data Viewer") {
                // Buttons for viewing JSON data
                Button("View Location Data") {
                    showLocationJSON.toggle()
                }
                .sheet(isPresented: $showLocationJSON) {
                    DataView(combinedData: combinedData, sensorType: "location")
                }
                
                Button("View Motion Data") {
                    showMotionJSON.toggle()
                }
                .sheet(isPresented: $showMotionJSON) {
                    DataView(combinedData: combinedData, sensorType: "motion")
                }
                
                Button("View Submersion Data") {
                    showSubmersionJSON.toggle()
                }
                .sheet(isPresented: $showSubmersionJSON) {
                    DataView(combinedData: combinedData, sensorType: "submersion")
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
            if let combinedJSONString = convertCombinedDataToJSONString() {
                ShareLink(item: exportCombinedJSON(fileName: JSONName, content: combinedJSONString))
            } else {
                Text("No data to share")
            }
        }
        .onAppear {
            self.JSONName = timeStampFormatter.exportNameFormat(entry.startDatetime ?? Date.now )+"_AWUData.json"
        }
    }

    // Combine the data from all the sensors into one encodable structure
    private func combineJSONsIntoStructuredData() -> StructuredData? {
        // Grab the JSON strings from CoreData
        guard let motionJSON = entry.motionJSON, let locationJSON = entry.locationJSON else {
            print("No motionJSON or locationJSON found")
            return nil
        }
        let submersionJSON = entry.waterSubmersionJSON ?? "[]"
        
        // Turn JSON strings into data
        let locationData = Data(locationJSON.utf8)
        let locationDecoded = try? decoder.decode( LocationData.self, from: locationData)
        
        
        let motionData = Data(motionJSON.utf8)
        let motionDecoded = try? decoder.decode( MotionData.self, from: motionData)
        
        let submersionData = Data(submersionJSON.utf8)
        let submersionDecoded = try? decoder.decode( WaterSubmersionData.self, from: submersionData)
        
        do {
            // extract location data
            let locationArrays = LocationData(timestamp: locationDecoded?.timestamp ?? [], latitude: locationDecoded?.latitude ?? [], longitude: locationDecoded?.longitude ?? [])
            let formattedLocationData = FormattedLocationData(values: locationArrays)
            
            // extract motion data
            let motionArrays = MotionData(timestamp: motionDecoded?.timestamp ?? [], accelerationX: motionDecoded?.accelerationX ?? [], accelerationY: motionDecoded?.accelerationY ?? [], accelerationZ: motionDecoded?.accelerationZ ?? [], angularVelocityX: motionDecoded?.angularVelocityX ?? [], angularVelocityY: motionDecoded?.angularVelocityY ?? [], angularVelocityZ: motionDecoded?.angularVelocityZ ?? [], magneticFieldX: motionDecoded?.magneticFieldX ?? [], magneticFieldY: motionDecoded?.magneticFieldY ?? [], magneticFieldZ: motionDecoded?.magneticFieldZ ?? [])
            let formattedMotionData = FormattedMotionData(values: motionArrays)
            
            // extract the submersion data
            let submersionArrays = WaterSubmersionData(timestamp: submersionDecoded?.timestamp ?? [], depth: submersionDecoded?.depth ?? [], temperature: submersionDecoded?.temperature ?? [])
            let formattedSubmersionData = FormattedSubmersionData(values: submersionArrays)
            
            // Combine the data
            let structuredData = StructuredData(location: formattedLocationData, motion: formattedMotionData, submersion: formattedSubmersionData )
            
            return structuredData
        } catch {
            print("Error parsing or combining JSON: \(error)")
            return nil
        }
    }

    // Convert combined data to a string
    private func convertCombinedDataToJSONString() -> String? {
        guard let combinedData = combinedData else { return nil }
        
        encoder.outputFormatting = [.sortedKeys, .withoutEscapingSlashes]
        do {
            let jsonData = try encoder.encode(combinedData)
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
