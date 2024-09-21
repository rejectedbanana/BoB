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
                List {
                    ForEach(logBookRecords) { logBookRecord in
                        NavigationLink {
                            LogbookDetail(entry: logBookRecord)
                        } label: {
                            ListRow(entry: logBookRecord)
                        }
                    }
                    .onDelete(perform: delete)
                }
                .toolbar {
                    //                    ToolbarItem(placement: .navigationBarTrailing) {
                    //                        EditButton()
                    //                    }
                    Button(action: {
                        generateMockData()
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.blue)
                    }
                    .accessibilityLabel("Generate Mock Data")
                }
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
        newEntry.name = "Mock Session"
        
        // Set Start and Stop Dates
        newEntry.startDatetime = Date()
        newEntry.stopDatetime = Date()
        
        // Set GPS Coordinates (e.g., somewhere in San Francisco)
        newEntry.startLatitude = 37.7749
        newEntry.startLongitude = -122.4194
        newEntry.stopLatitude = 37.7749
        newEntry.stopLongitude = -122.4194
        
        // Set Device Info
        newEntry.deviceName = "Mock Device"
        newEntry.deviceModel = "Mock Model"
        newEntry.deviceLocalizedModel = "Mock Localized Model"
        newEntry.deviceSystemVersion = "Mock OS Version"
        newEntry.deviceManufacturer = "Apple Inc."
        
        // Generate Mock Sensor JSON Data
        newEntry.sampleCSV = generateMockSensorDataJSON()
        
        // Generate Mock GPS JSON Data
        newEntry.gpsJSON = generateMockGPSDataJSON()
        
        // Generate Mock Water Submersion JSON Data
        newEntry.waterSubmersionJSON = generateMockWaterSubmersionDataJSON()
        
        // Save the context
        do {
            try moc.save()
            print("Mock data generated successfully.")
        } catch {
            print("Failed to save mock data: \(error)")
        }
    }
    
    /// Generates a JSON string representing mock sensor data.
    func generateMockSensorDataJSON() -> String? {
        // Define the number of mock sensor samples
        let numberOfSamples = 50
        
        // Create an array to hold SensorData dictionaries
        var sensorDataArray: [[String: Any]] = []
        
        for i in 0..<numberOfSamples {
            let sensorData: [String: Any] = [
                "timestamp": ISO8601DateFormatter().string(from: Date().addingTimeInterval(Double(i) * 0.1)),
                "accX": Double.random(in: -2.0...2.0),
                "accY": Double.random(in: -2.0...2.0),
                "accZ": Double.random(in: -2.0...2.0),
                "gyrX": Double.random(in: -5.0...5.0),
                "gyrY": Double.random(in: -5.0...5.0),
                "gyrZ": Double.random(in: -5.0...5.0),
                "magX": Double.random(in: -50.0...50.0),
                "magY": Double.random(in: -50.0...50.0),
                "magZ": Double.random(in: -50.0...50.0)
            ]
            sensorDataArray.append(sensorData)
        }
        
        // Convert the array to JSON string
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: sensorDataArray, options: [])
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        } catch {
            print("Failed to generate mock sensor JSON: \(error)")
            return nil
        }
    }
    
    /// Generates a JSON string representing mock GPS data.
    func generateMockGPSDataJSON() -> String? {
        // Define the number of mock GPS samples
        let numberOfSamples = 10
        
        // Starting point (e.g., San Francisco)
        var latitude = 37.7749
        var longitude = -122.4194
        
        // Create an array to hold GPSData dictionaries
        var gpsDataArray: [[String: Any]] = []
        
        for i in 0..<numberOfSamples {
            // Slightly vary the coordinates
            latitude += Double.random(in: -0.001...0.001)
            longitude += Double.random(in: -0.001...0.001)
            
            let gpsData: [String: Any] = [
                "timestamp": ISO8601DateFormatter().string(from: Date().addingTimeInterval(Double(i) * 10)),
                "latitude": latitude,
                "longitude": longitude
            ]
            gpsDataArray.append(gpsData)
        }
        
        // Convert the array to JSON string
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: gpsDataArray, options: [])
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        } catch {
            print("Failed to generate mock GPS JSON: \(error)")
            return nil
        }
    }
    
    /// Generates a JSON string representing mock water submersion data.
    func generateMockWaterSubmersionDataJSON() -> String? {
        // Define the number of mock submersion samples
        let numberOfSamples = 20
        
        // Create an array to hold SubmersionDataSample dictionaries
        var submersionDataArray: [[String: Any]] = []
        
        for i in 0..<numberOfSamples {
            let submersionData: [String: Any] = [
                "timestamp": ISO8601DateFormatter().string(from: Date().addingTimeInterval(Double(i) * 5)),
                "depth": Double.random(in: 1.0...10.0), // meters
                "temperature": Double.random(in: 15.0...25.0) // °C
            ]
            submersionDataArray.append(submersionData)
        }
        
        // Convert the array to JSON string
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: submersionDataArray, options: [])
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        } catch {
            print("Failed to generate mock water submersion JSON: \(error)")
            return nil
        }
    }
}

#Preview {
    ContentView()
}
