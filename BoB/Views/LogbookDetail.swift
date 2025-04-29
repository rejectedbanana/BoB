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
    @State private var showSubmersionPlot = false
    
    // Strings to store exported name and data
    private var locationData: [LocationData] {
        return entryToLocationData()
    }
    
    
    private var combinedData: StructuredData? {
        return combineJSONsIntoStructuredData()
    }
    @State private var JSONName = ""
    
    // encoders and decosers for JSON output
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    
    // time stamp formatter
    let timeStampFormatter = TimeStampManager()
    
    var body: some View {
        List {
            Section("Deployment Map") {
                DataMap(locationData: locationData)
                    .frame(height: 250)
                    .listRowInsets(EdgeInsets())
            }
            
            Section("Deployment Details") {
                DetailRow(header: "Start Time", content: timeStampFormatter.viewFormat(entry.startDatetime ?? Date(timeIntervalSince1970: 0)))
                DetailRow(header: "End Time", content: timeStampFormatter.viewFormat(entry.stopDatetime ?? Date(timeIntervalSince1970: 0)))
                DetailRow(header: "Samples", content: "\(entry.getMotionDataCount())")
                DetailRow(header: "Sampling Frequency", content: "4 Hz")
                DetailRow(header: "Min Temp", content: entry.getMinimumTemperature().isNaN ? "no submersion data" : String(format: "%.1f °C", entry.getMinimumTemperature()) )
                DetailRow(header: "Max Depth", content: entry.getMaximumDepth().isNaN ? "no submersion data" : String(format: "%.1f m", entry.getMaximumDepth()))
                DetailRow(header: "Source", content: entry.deviceName ?? "Unknown")
            }
            
            Section("Data Plots") {
//                TimeSeriesView(
//                    x: convertISO8601DatesToDateArray(dateStrings: combinedData?.submersion.values.timestamp ?? [timeStampFormatter.ISO8601Format(Date.now)]),
//                    y: combinedData?.submersion.values.temperature ?? [0.1],
//                    yVariable: "Temperature",
//                    yUnit: "° C"
//                )
//                    
//                TimeSeriesView(
//                    x: convertISO8601DatesToDateArray(dateStrings: combinedData?.submersion.values.timestamp ?? []),
//                    y: combinedData?.submersion.values.depth ?? [],
//                    yVariable: "Depth",
//                    yUnit: "meters"
//                )
            }
            
            Section("Raw Data Viewer") {
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
        .listStyle(.sidebar)
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
    
    // Convert the logged data in SampleSet back into [LocationData] array
    private func entryToLocationData() -> [LocationData] {
        guard let locationJSONString = entry.locationJSON else {
            print("No locationJSON found")
            return [LocationData(timestamp: "", latitude: Double.nan, longitude: Double.nan)]
        }
        
        let locationData = locationJSONString.data(using: .utf8) ?? Data()
        
        do {
            let locationDecoded = try decoder.decode([LocationData].self, from: locationData)
            
            return locationDecoded
        } catch {
            print( "Location JSON not decoded.")
            return [LocationData(timestamp: "", latitude: Double.nan, longitude: Double.nan)]
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
        let locationData = locationJSON.data(using: .utf8) ?? Data()
        
//        let motionData = Data(motionJSON.utf8)
//        let motionDecoded = try? decoder.decode( MotionData.self, from: motionData)
        let motionData = motionJSON.data(using: .utf8) ?? Data()
        
//        let submersionData = Data(submersionJSON.utf8)
//        let submersionDecoded = try? decoder.decode( WaterSubmersionData.self, from: submersionData)
        let submersionData = submersionJSON.data(using: .utf8) ?? Data()
        
        do {
            // extract location data
            // decode the location data and transform it
            let locationDecoded = try decoder.decode([LocationData].self, from: locationData)
            // turn values into arrays so the saved JSON is smaller
            var locationArray: LocationArrays = LocationArrays(timestamp: [], latitude: [], longitude: [])
            for location in locationDecoded {
                locationArray.timestamp.append(location.timestamp)
                locationArray.latitude.append(location.latitude)
                locationArray.longitude.append(location.longitude)
            }
            // Reformat for saving as a compact JSON
            let formattedLocationData = FormattedLocationData(values: locationArray)
            
            // extract motion data
//            let motionArrays = MotionData(timestamp: motionDecoded?.timestamp ?? [], accelerationX: motionDecoded?.accelerationX ?? [], accelerationY: motionDecoded?.accelerationY ?? [], accelerationZ: motionDecoded?.accelerationZ ?? [], angularVelocityX: motionDecoded?.angularVelocityX ?? [], angularVelocityY: motionDecoded?.angularVelocityY ?? [], angularVelocityZ: motionDecoded?.angularVelocityZ ?? [], magneticFieldX: motionDecoded?.magneticFieldX ?? [], magneticFieldY: motionDecoded?.magneticFieldY ?? [], magneticFieldZ: motionDecoded?.magneticFieldZ ?? [])
//            let formattedMotionData = FormattedMotionData(values: motionArrays)
            // decode the motion data and transform it
            let motionDecoded = try decoder.decode([MotionData].self, from: motionData)
            var motionArray: MotionArrays = MotionArrays(timestamp: [], accelerationX: [], accelerationY: [], accelerationZ: [], angularVelocityX: [], angularVelocityY: [], angularVelocityZ: [], magneticFieldX: [], magneticFieldY: [], magneticFieldZ: [])
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
            // Reformat for saving as a compact JSON
            let formattedMotionData = FormattedMotionData(values: motionArray)
            
            // extract the submersion data
//            let submersionArrays = WaterSubmersionData(timestamp: submersionDecoded?.timestamp ?? [], depth: submersionDecoded?.depth ?? [], temperature: submersionDecoded?.temperature ?? [])
//            let formattedSubmersionData = FormattedSubmersionData(values: submersionArrays)
            // decode the submersion data and transform it
            let submersionDecoded = try decoder.decode([WaterSubmersionData].self, from: submersionData)
            var submersionArray: WaterSubmersionArrays = WaterSubmersionArrays(timestamp: [], depth: [], temperature: [])
            for submersion in submersionDecoded {
                submersionArray.timestamp.append(submersion.timestamp)
                submersionArray.depth.append(submersion.depth ?? Double.nan)
                submersionArray.temperature.append(submersion.temperature ?? Double.nan)
            }
            let formattedSubmersionData = FormattedSubmersionData(values: submersionArray)
            
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
    
    // change array of string dates to a date array
    private func convertISO8601DatesToDateArray(dateStrings: [String]) -> [Date] {
        var dateArray: [Date] = []
        
        for dateString in dateStrings {
            if let date = timeStampFormatter.ISO8601StringtoDate(dateString) {
                dateArray.append(date)
            }
        }
        return dateArray
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
