//
//  phoneLogbookDetail.swift
//  BoB
//
//  Created by Kim Martini on 1/4/24.
//

import SwiftUI

struct LogbookDetail: View {
    @Environment(\.managedObjectContext) private var moc
    @ObservedObject var entry: SampleSet
    
    // Cache the JSONExportManager to avoid recreating it
    @State private var jsonExportManager: JSONExportManager?
    
    // Toggles to preview data
    @State private var showSummary = false
    @State private var showDeviceDetails = false
    @State private var showDataTables = false
    @State private var showMotionTable = false
    @State private var showLocationTable = false
    @State private var showSubmersionTable = false
    
    // Toggles to edit filename
    @State private var showFileNameEditor: Bool = false
    @State private var updatedFileName: String = ""
    @State private var localFileName: String = ""
    @FocusState var showKeyboard: Bool
    
    // Add state for export data - computed only when needed
    @State private var exportData: (url: URL, fileName: String)?
    
    // time stamp formatter
    let timeStampFormatter = TimeStampManager()
    
    var body: some View {
        NavigationStack{
            List {
                Section {
                    if showFileNameEditor {
                        FilenameEditor(
                            isEditing: $showFileNameEditor,
                            filename: .constant(entry.fileName ?? ""),
                            onSave: { newName in
                                entry.fileName = newName
                                do {
                                    try moc.save()
                                    // Regenerate export data after successful save
                                    generateExportData()
                                } catch {
                                    print("File name change failed: \(error.localizedDescription)")
                                }
                            }
                        )
                    } else {
                        Button {
                            showFileNameEditor.toggle()
                        } label: {
                            HStack {
                                Text(entry.fileName ?? "unknown")
                                Spacer()
                                Image(systemName: "pencil")
                                    .foregroundStyle(.blue)
                                    .scaledToFit()
                                    .frame(width: 30, height: 30)
                            }
                        }
                    }
                } header: {
                    Text("Filename")
                }
                
                Section {
                    if let manager = jsonExportManager {
                        DataMap(locationData: manager.entryToLocationData(entry))
                            .frame(height: 180)
                            .listRowInsets(EdgeInsets())
                            .id("datamap")
                    }
                } header: {
                    Text("Deployment Map")
                }
                
                Section {
                    if let manager = jsonExportManager {
                        SubmersionChart(submersionData: manager.entryToSubmersionData(entry))
                    }
                    
                } header: {
                    Text( "Submersion Data")
                }
                
                Section {
                    if let manager = jsonExportManager{
                        MotionChart(motionData: manager.entryToMotionData(entry), coordinateSystem: entry.motionCoordinateSystem ?? "device")
                    }
                } header: {
                    Text( "Motion Data")
                }
                
                Section(isExpanded: $showDataTables) {
                    if let manager = jsonExportManager {
                        // Buttons for viewing JSON data
                        Button("View Location Data") {
                            showLocationTable.toggle()
                        }
                        .sheet(isPresented: $showLocationTable) {
                            LocationTable(locationData: manager.entryToLocationData(entry))
                        }
                        
                        Button("View Submersion Data") {
                            showSubmersionTable.toggle()
                        }
                        .sheet(isPresented: $showSubmersionTable) {
                            SubmersionTable(submersionData: manager.entryToSubmersionData(entry))
                        }
                        
                        Button("View Motion Data") {
                            showMotionTable.toggle()
                        }
                        .sheet(isPresented: $showMotionTable) {
                            MotionTable(motionData: manager.entryToMotionData(entry))
                        }
                    }
                } header: {
                    Text("Data Tables")
                }
                
                Section(isExpanded: $showSummary) {
                    DetailRow(header: "Start Time", content: timeStampFormatter.viewFormat(entry.startDatetime ?? Date(timeIntervalSince1970: 0)))
                    DetailRow(header: "End Time", content: timeStampFormatter.viewFormat(entry.stopDatetime ?? Date(timeIntervalSince1970: 0)))
                    DetailRow(header: "Samples", content: "\(entry.getMotionDataCount())")
                    DetailRow(header: "Sampling Frequency", content: "4 Hz")
                    DetailRow(header: "Min Temp", content: entry.getMinimumTemperature().isNaN ? "no submersion data" : String(format: "%.1f °C", entry.getMinimumTemperature()) )
                    DetailRow(header: "Max Depth", content: entry.getMaximumDepth().isNaN ? "no submersion data" : String(format: "%.1f m", entry.getMaximumDepth()))
                    DetailRow(header: "File Name", content: entry.fileName ?? "Unknown")
                    DetailRow(header: "File ID", content: entry.fileID ?? "Unknown")
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
            }
            .listStyle(.sidebar)
            .listSectionSpacing(.compact)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    // Only show ShareLink if export daa is available
                    if let exportData = exportData {
                        ShareLink(item: exportData.url) {
                            Label("Share JSON", systemImage: "square.and.arrow.up" )
                        }
                    } else {
                        Text("Preparing...")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .onAppear {
                updatedFileName = entry.fileName ?? ""
                // Initialize the JSON export manager once
                jsonExportManager = JSONExportManager(entry)
                // Generate export data once on appear
                generateExportData()
                
            }
        }
    }
    
    // Function to generate export data only when needed
    private func generateExportData() {
        guard let manager = jsonExportManager else { return }
        
        // Use a background queue for expensive operations
        DispatchQueue.global(qos: .userInitiated).async {
            let fileName = (entry.fileName ?? "unknown") + "_AWUData.json"
            debugPrint(fileName)
            
            let exportableData = manager.combineDataIntoStructuredData(entry)
            
            if let combinedJSONString = manager.convertStructuredDataToJSONString(exportableData) {
                if let fileURL = manager.exportJSON(fileName: fileName, content: combinedJSONString) {
                    DispatchQueue.main.async {
                        self.exportData = (url: fileURL, fileName: fileName)
                    }
                }
            }
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
