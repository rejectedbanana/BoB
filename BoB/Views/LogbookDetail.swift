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
    
    // Toggles to edit filename
    @State private var showFileNameEditor: Bool = false
    @State private var updatedFileName: String = ""
    @FocusState var showKeyboard: Bool
    
    // time stamp formatter
    let timeStampFormatter = TimeStampManager()
    
    var body: some View {
        NavigationStack{
            List {
                Section {
                    if showFileNameEditor == true {
                        HStack {
                            TextField("Tap done to save new filename", text: $updatedFileName)
                                .focused($showKeyboard)
                                .onSubmit {
                                    entry.fileName = updatedFileName
                                    do {
                                        try moc.save()
                                    } catch {
                                        print("File name change failed: \(error.localizedDescription)")
                                    }
                                    
                                    showFileNameEditor.toggle()
                                }
                                .submitLabel(.done)
                            
                            Spacer()
                            
                            Button {
                                showFileNameEditor.toggle()
                            } label: {
                                Text("Cancel")
                                    .foregroundStyle(.blue)
                            }
                        }
                        .onAppear{
                            showKeyboard = true
                        }
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
                        .onAppear{
                            showKeyboard = false
                        }
                    }
                } header: {
                    Text("Filename")
                }
                
                Section {
                    DataMap(locationData: jsonExportManager.entryToLocationData(entry))
                        .frame(height: 180)
                        .listRowInsets(EdgeInsets())
                } header: {
                    Text("Deployment Map")
                }
                
                Section {
                    SubmersionChart(submersionData: jsonExportManager.entryToSubmersionData(entry))
                } header: {
                    Text( "Submersion Data")
                }
                
                Section {
                    MotionChart(motionData: jsonExportManager.entryToMotionData(entry))
                } header: {
                    Text( "Motion Data")
                }
                
                Section(isExpanded: $showDataTables) {
                    // Buttons for viewing JSON data
                    Button("View Location Data") {
                        showLocationTable.toggle()
                    }
                    .sheet(isPresented: $showLocationTable) {
                        LocationTable(locationData: jsonExportManager.entryToLocationData(entry))
                    }
                    
                    Button("View Submersion Data") {
                        showSubmersionTable.toggle()
                    }
                    .sheet(isPresented: $showSubmersionTable) {
                        SubmersionTable(submersionData: jsonExportManager.entryToSubmersionData(entry))
                    }
                    
                    Button("View Motion Data") {
                        showMotionTable.toggle()
                    }
                    .sheet(isPresented: $showMotionTable) {
                        MotionTable(motionData: jsonExportManager.entryToMotionData(entry))
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
                    let fileName = updatedFileName+"_AWUData.json"
                    
                    let exportableData = jsonExportManager.combineDataIntoStructuredData(entry)
                    
                    if let combinedJSONString = jsonExportManager.convertStructuredDataToJSONString(exportableData) {
                        let fileURL = jsonExportManager.exportJSON(fileName: fileName, content: combinedJSONString)
                        
                        if let url = fileURL {
                            ShareLink(item: url) {
                                Label("Share JSON", systemImage: "square.and.arrow.up" )
                            }
                        }
                    } else {
                        Text("No data to share.")
                    }
                }
            }
            .onAppear {
                updatedFileName = entry.fileName ?? ""
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
