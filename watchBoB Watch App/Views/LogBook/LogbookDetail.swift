//
//  LogbookDetail.swift
//  watchBoB Watch App
//
//  Created by Kim Martini on 10/23/23.
//

import SwiftUI

struct LogbookDetail: View {
    let record: SampleSet

    // time stamp formatter
    let timeStampFormatter = TimeStampManager()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                DetailRow(header: "Min Temp", content: record.getMinimumTemperature().isNaN ? "no submersion data" : String(format: "%.1f °C", record.getMinimumTemperature()) )
                DetailRow(header: "Max Depth", content: record.getMaximumDepth().isNaN ? "no submersion data" : String(format: "%.1f m", record.getMaximumDepth()))
                DetailRow(header: "Start Time", content: timeStampFormatter.viewFormat( record.startDatetime ?? Date(timeIntervalSince1970: 0) ))
                DetailRow(header: "End Time", content: timeStampFormatter.viewFormat( record.stopDatetime ?? Date(timeIntervalSince1970: 0) ))
                DetailRow(header: "Start Coordinates", content: String(format: "%0.3f", record.startLatitude)+" N,"+String(format: "%0.3f", record.startLongitude)+" E")
                DetailRow(header: "End Coordinates", content: String(format: "%0.3f", record.stopLatitude)+" N,"+String(format: "%0.3f", record.stopLongitude)+" E")
                DetailRow(header: "Samples", content: "\(record.getMotionDataCount())")
                DetailRow(header: "Sampling Frequency", content: "10 Hz")
                DetailRow(header: "Submersion Data", content: record.waterSubmersionJSON ?? "no submersion data")
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
