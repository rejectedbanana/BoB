//
//  phoneLogbookDetail.swift
//  BoB
//
//  Created by Kim Martini on 1/4/24.
//

import SwiftUI

struct LogbookDetail: View {
    let entry: SampleSet
    
    private var jsonExportManager: JSONExportManager {
        return JSONExportManager(entry)
    }
    
    // Toggles to preview data
    @State private var showMotionJSON = false
    @State private var showLocationJSON = false
    @State private var showSubmersionJSON = false
    @State private var showSubmersionPlot = false
    
    // Strings to store exported name and data
    private var locationData: [LocationData] {
        return jsonExportManager.locationData
    }
    private var motionData: [MotionData] {
        return jsonExportManager.motionData
    }
    private var submersionData: [WaterSubmersionData] {
        return jsonExportManager.submersionData
    }
    private var combinedData: StructuredData? {
        return jsonExportManager.exportableData
    }
    @State private var JSONName = ""
    
    // time stamp formatter
    let timeStampFormatter = TimeStampManager()
    
    var body: some View {
        List {
            Section("Deployment Map") {
                DataMap(locationData: locationData)
                    .frame(height: 250)
                    .listRowInsets(EdgeInsets())
            }
            
            Section("Deployment Summary") {
                DetailRow(header: "Start Time", content: timeStampFormatter.viewFormat(entry.startDatetime ?? Date(timeIntervalSince1970: 0)))
                DetailRow(header: "End Time", content: timeStampFormatter.viewFormat(entry.stopDatetime ?? Date(timeIntervalSince1970: 0)))
                DetailRow(header: "Samples", content: "\(entry.getMotionDataCount())")
                DetailRow(header: "Sampling Frequency", content: "4 Hz")
                DetailRow(header: "Min Temp", content: entry.getMinimumTemperature().isNaN ? "no submersion data" : String(format: "%.1f °C", entry.getMinimumTemperature()) )
                DetailRow(header: "Max Depth", content: entry.getMaximumDepth().isNaN ? "no submersion data" : String(format: "%.1f m", entry.getMaximumDepth()))
                DetailRow(header: "Source", content: entry.deviceName ?? "Unknown")
            }
            
            Section("Data Charts") {
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
            
            Section("Data Tables") {
                // Buttons for viewing JSON data
                Button("View Location Data") {
                    showLocationJSON.toggle()
                }
                .sheet(isPresented: $showLocationJSON) {
//                    DataView(combinedData: combinedData, sensorType: "location")
                    LocationTable(locationData: locationData)
                }
                
                Button("View Motion Data") {
                    showMotionJSON.toggle()
                }
                .sheet(isPresented: $showMotionJSON) {
//                    DataView(combinedData: combinedData, sensorType: "motion")
                    MotionTable(motionData: motionData)
                }
                
                Button("View Submersion Data") {
                    showSubmersionJSON.toggle()
                }
                .sheet(isPresented: $showSubmersionJSON) {
//                    DataView(combinedData: combinedData, sensorType: "submersion")
                    SubmersionTable(submersionData: submersionData)
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
            if let combinedJSONString = jsonExportManager.convertStructuredDataToJSONString(combinedData) {
                ShareLink(item: jsonExportManager.exportJSON(fileName: JSONName, content: combinedJSONString))
            } else {
                Text("No data to share")
            }
        }
        .onAppear {
            self.JSONName = timeStampFormatter.exportNameFormat(entry.startDatetime ?? Date.now )+"_AWUData.json"
        }
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
