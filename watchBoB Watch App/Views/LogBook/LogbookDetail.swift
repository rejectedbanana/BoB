//
//  LogbookDetail.swift
//  watchBoB Watch App
//
//  Created by Kim Martini on 10/23/23.
//

import SwiftUI

struct LogbookDetail: View {
    let record: SampleSet
    
    // Create the watch session manager
    @StateObject private var watchSession = WatchSessionManager()
    
    // make a dynamic message
    @State private var watchMessage: String = ""
    // make a dynamic dictionary
    @State private var watchDictionary: [String: Any] = [:]
    
    // time stamp formatter
    let timeStampFormatter = TimeStampManager()
    
    private var parsedData: [[String: Any]]? {
        return parseJSON()
    }
    
    private func parseJSON() -> [[String: Any]]? {
        guard let jsonString = record.gpsJSON else {
            print("No JSON string found")
            return nil
        }
        print("JSON String: \(jsonString)") // Debugging line
        let data = Data(jsonString.utf8)
        do {
            if let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                return jsonArray
            } else {
                print("JSON is not an array of dictionaries")
                return nil
            }
        } catch {
            print("Error parsing JSON: \(error)")
            return nil
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                DetailRow(header: "Min Temp", content: "7.0 °C")
                DetailRow(header: "Max Depth", content: "44.0 m")
                DetailRow(header: "Start Time", content: timeStampFormatter.viewFormat( record.startDatetime ?? Date(timeIntervalSince1970: 0) ))
                DetailRow(header: "End Time", content: timeStampFormatter.viewFormat( record.stopDatetime ?? Date(timeIntervalSince1970: 0) ))
                DetailRow(header: "Start Coordinates", content: String(format: "%0.3f", record.startLatitude)+" N,"+String(format: "%0.3f", record.startLongitude)+" E")
                DetailRow(header: "End Coordinates", content: String(format: "%0.3f", record.stopLatitude)+" N,"+String(format: "%0.3f", record.stopLongitude)+" E")
                DetailRow(header: "Samples", content: "1430")
                DetailRow(header: "Sampling Frequency", content: "10 Hz")
                DetailRow(header: "Location JSON", content: record.gpsJSON ?? "No data available")
//                if let dataArray = parsedData {
//                    ForEach(dataArray.indices, id: \.self) { index in
//                        let item = dataArray[index]
//                        if let timestamp = item["timestamp"] as? String,
//                           let latitude = item["latitude"] as? Double,
//                           let longitude = item["longitude"] as? Double {
//                            DetailRow(header: "Location Sample \(index + 1)", content: "Time: \(timeStampFormatter.formattedTime(from: timestamp)), \nLat: \(latitude), \nLon: \(longitude)")
//                        }
//                    }
//                } else {
//                    DetailRow(header: "Location Data", content: "No data available")
//                }
            }
        }
    }
}

struct DetailRow: View {
    let header: String
    let content: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(header)
                .font(.subheadline)
                .foregroundColor(.silver)
                
            Text(content)
                .font(.headline)
        }
    }
}

//#Preview {
//    LogbookDetail()
//}
