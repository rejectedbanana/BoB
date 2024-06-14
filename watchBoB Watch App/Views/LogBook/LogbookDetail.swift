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
    var watchSession = WatchSessionManager()
    
    // make a dynamic message
    @State private var watchMessage: String = ""
    // make a dynamic dictionary
    @State private var watchDictionary: [String: Any] = [:]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                
                Button {
                    // Send a text message
                    // define the text to send
//                    watchMessage = dateFormatter(Date.now)
//                    watchMessage = record.name ?? "Name not added to string."
                    // check if phone is activated
//                    watchSession.activatePhone()
                    // send the textmessage
//                    watchSession.sendMessageToPhone(watchMessage)
                    
                    // Send a dictionary
                    // check if the phone is activated
                    watchSession.activatePhone()
                    // build the dictionary from the Core Data Record
                    watchDictionary["id"] = [""]
                    watchDictionary["name"] = String(record.name ?? "Name not added to dictionary.")
                    watchDictionary["startDatetime"] = record.startDatetime
                    watchDictionary["stopDatetime"] = record.stopDatetime
                    watchDictionary["startLatitude"] = record.startLatitude
                    watchDictionary["startLongitude"] = record.startLongitude
                    watchDictionary["stopLatitude"] = record.stopLatitude
                    watchDictionary["stopLongitude"] = record.startLongitude
                    // send the dictionary
                    watchSession.sendDictionaryToPhone(watchDictionary)
                    
                } label: {
                    Text("Send to phone")
                }
                
                DetailRow(header: "Min Temp", content: "7.0 °C")
                DetailRow(header: "Max Depth", content: "44.0 m")
                DetailRow(header: "Start Time", content: dateFormatter( record.startDatetime ?? Date(timeIntervalSince1970: 0) ))
                DetailRow(header: "End Time", content: dateFormatter( record.stopDatetime ?? Date(timeIntervalSince1970: 0) ))
                DetailRow(header: "Start Coordinates", content: String(format: "%0.3f", record.startLatitude)+" N,"+String(format: "%0.3f", record.startLongitude)+" E")
                DetailRow(header: "End Coordinates", content: String(format: "%0.3f", record.stopLatitude)+" N,"+String(format: "%0.3f", record.stopLongitude)+" E")
                DetailRow(header: "Samples", content: "1430")
                DetailRow(header: "Sampling Frequency", content: "10 Hz")
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
