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
    @State private var showSummary = false
    @State private var showDeviceDetails = false

    @State private var showDataTables = false
    @State private var showMotionTable = false
    @State private var showLocationTable = false
    @State private var showSubmersionTable = false

    
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
                    .frame(height: 180)
                    .listRowInsets(EdgeInsets())
            }
            
            Section {
                SubmersionChart(submersionData: submersionData)
            } header: {
                Text( "Submersion Data")
            }
            
            Section {
                MotionChart(motionData: motionData)
            } header: {
                Text( "Motion Data")
            }
            
            Section(isExpanded: $showSummary) {
                DetailRow(header: "Start Time", content: timeStampFormatter.viewFormat(entry.startDatetime ?? Date(timeIntervalSince1970: 0)))
                DetailRow(header: "End Time", content: timeStampFormatter.viewFormat(entry.stopDatetime ?? Date(timeIntervalSince1970: 0)))
                DetailRow(header: "Samples", content: "\(entry.getMotionDataCount())")
                DetailRow(header: "Sampling Frequency", content: "4 Hz")
                DetailRow(header: "Min Temp", content: entry.getMinimumTemperature().isNaN ? "no submersion data" : String(format: "%.1f °C", entry.getMinimumTemperature()) )
                DetailRow(header: "Max Depth", content: entry.getMaximumDepth().isNaN ? "no submersion data" : String(format: "%.1f m", entry.getMaximumDepth()))
                DetailRow(header: "Source", content: entry.deviceName ?? "Unknown")
            } header: {
                Text("Deployment Summary")
            }
            
            Section(isExpanded: $showDeviceDetails) {
                DetailRow(header: "Name", content: entry.deviceName ?? "Unknown")
                DetailRow(header: "Manufacturer", content: entry.deviceManufacturer ?? "Unknown")
                DetailRow(header: "Model", content: entry.deviceModel ?? "Unknown")
                DetailRow(header: "Hardware Version", content: entry.deviceLocalizedModel ?? "Unknown")
                DetailRow(header: "Software Version", content: entry.deviceSystemVersion ?? "Unknown")
            } header: {
                Text("Device Details")
            }
            
            Section(isExpanded: $showDataTables) {
                // Buttons for viewing JSON data
                Button("View Location Data") {
                    showLocationTable.toggle()
                }
                .sheet(isPresented: $showLocationTable) {
                    LocationTable(locationData: locationData)
                }
                
                Button("View Motion Data") {
                    showMotionTable.toggle()
                }
                .sheet(isPresented: $showMotionTable) {
                    MotionTable(motionData: motionData)
                }
                
                Button("View Submersion Data") {
                    showSubmersionTable.toggle()
                }
                .sheet(isPresented: $showSubmersionTable) {
                    SubmersionTable(submersionData: submersionData)
                }
            } header: {
                Text("Data Tables")
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
}

//#Preview {
//    LogbookDetail()
//}

// Make a unified view for the rows in the sections
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
