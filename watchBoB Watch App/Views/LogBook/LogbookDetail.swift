//
//  LogbookDetail.swift
//  watchBoB Watch App
//
//  Created by Kim Martini on 10/23/23.
//

import SwiftUI

struct LogbookDetail: View {
    let record: SampleSet
    
//    @Environment(\.managedObjectContext) var moc

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    
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
