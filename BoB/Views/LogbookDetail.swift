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

    var body: some View {
        List {
            Section("Sample Details"){
                DetailRow(header: "Minimum Water Temperature", content: "7.0 °C")
                DetailRow(header: "Maximum Underwater Depth", content: "44.0 m")
                DetailRow(header: "Start Time", content: dateFormatterForView( entry.startDatetime ?? Date(timeIntervalSince1970: 0) ))
                DetailRow(header: "End Time", content: dateFormatterForView( entry.stopDatetime ?? Date(timeIntervalSince1970: 0) ))
                DetailRow(header: "Samples", content: "1430")
                DetailRow(header: "Sampling Frequency", content: "10 Hz")
                DetailRow(header: "Source", content: "Kim's Apple Watch")
                DetailRow(header: "CSV Data", content: entry.sampleCSV ?? "No CSV data.")
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
            ShareLink(item: exportCSV(fileName: csvName) )
        }
        .onAppear {
            self.csvName = dateFormatterForExport(entry.startDatetime ?? Date.now )+"_AWUData.csv"
            self.csvContent = entry.sampleCSV ?? "No CSV data"
        }
    }
    
    func exportCSV(fileName: String) -> URL {
        // Get the path to the documents directory
        let documentsDirectory = URL.documentsDirectory
        let fileURL = documentsDirectory.appending(path: fileName)
        
        do {
            // Append CSV content to file
            try csvContent.write(to: fileURL, atomically: true, encoding: .utf8)
            
        } catch {
            print("Failed to write CSV: \(error.localizedDescription)")
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
