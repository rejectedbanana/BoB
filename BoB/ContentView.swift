//
//  ContentView.swift
//  BoB
//
//  Created by Kim Martini on 10/19/23.
//

import SwiftUI
import CoreData
import WatchConnectivity
struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [SortDescriptor(\.startDatetime, order: .reverse)]) var logBookRecords: FetchedResults<SampleSet>
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var phoneSessionManager = PhoneSessionManager()
    
    @State var messageString: String? = ""
    @State var messageDictionary: [String: Any] = [:]
    
    var body: some View {
        NavigationStack {
            ZStack {
                if logBookRecords.isEmpty {
                    VStack {
                        Image(systemName: "book.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 32, height: 32)
                            .foregroundColor(.gray)
                            .padding()
                        
                        Text("No Log Entries")
                            .font(.headline)
                            .foregroundColor(.gray)
                        
                        Text("Start a new logbook entry or sync data from your watch.")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        
                        Spacer()
                    }
                } else {
                    List {
                        ForEach(logBookRecords) { logBookRecord in
                            NavigationLink {
                                LogbookDetail(entry: logBookRecord, jsonParserService: DefaultJSONParserService())
                            } label: {
                                ListRow(entry: logBookRecord)
                            }
                        }
                        .onDelete(perform: delete)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
#if DEBUG
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Generate Mock Data") {
                        generateMockData()
                    }
                }
#endif
            }
        }
    }
    
    func delete(at offsets: IndexSet) {
        for offset in offsets {
            let entry = logBookRecords[offset]
            moc.delete(entry)
        }
        do {
            try moc.save()
        } catch {
            print("Failed to delete log entry: \(error)")
        }
    }
    
    func generateMockData() {
        let newEntry = SampleSet(context: moc)
        newEntry.id = UUID()
        newEntry.startDatetime = Date()
        newEntry.stopDatetime = Date().addingTimeInterval(3600)
        newEntry.name = "Mock Dive"
        newEntry.startLatitude = 47.6062
        newEntry.startLongitude = -122.3321
        newEntry.stopLatitude = 47.6097
        newEntry.stopLongitude = -122.3331
        newEntry.deviceName = "Apple Watch"
        newEntry.deviceModel = "Ultra"
        newEntry.deviceLocalizedModel = "Watch6,18"
        newEntry.deviceSystemVersion = "10.3"
        newEntry.deviceManufacturer = "Apple Inc."
        
        let mockMotionData: [[Any]] = [
            ["2024-06-19T16:27:20.892Z", 0.0169, -0.0843, -0.9829, -0.0322, 0.0037, 0.0037, 12.0515, -7.9176, -46.0155],
            ["2024-06-19T16:27:20.990Z", 0.0151, -0.0776, -0.9986, 0.0150, 0.0007, 0.0007, 12.3359, -7.6903, -45.9714]
        ]
        
        let mockLocationData: [[Any]] = [
            ["2024-06-19T16:27:20.892Z", 47.6062, -122.3321],
            ["2024-06-19T16:27:20.990Z", 47.6097, -122.3331]
        ]
        
        let mockSubmersionData: [[Any]] = [
            ["2024-06-19T16:27:20.892Z", 10.5, 22.3],
            ["2024-06-19T16:27:20.990Z", 15.0, 20.5],
            ["2024-06-19T16:27:21.090Z", 5.0, 24.0]
        ]
        
        if let motionData = try? JSONSerialization.data(withJSONObject: mockMotionData, options: .prettyPrinted),
           let locationData = try? JSONSerialization.data(withJSONObject: mockLocationData, options: .prettyPrinted),
           let submersionData = try? JSONSerialization.data(withJSONObject: mockSubmersionData, options: .prettyPrinted) {
            
            newEntry.sampleJSON = String(data: motionData, encoding: .utf8)
            newEntry.gpsJSON = String(data: locationData, encoding: .utf8)
            newEntry.waterSubmersionJSON = String(data: submersionData, encoding: .utf8)
        }
        
        do {
            try moc.save()
            print("Mock data saved successfully.")
        } catch {
            print("Failed to save mock data: \(error)")
        }
    }

}

#Preview {
    ContentView()
}
