//
//  LogbookDetail.swift
//  watchBoB Watch App
//
//  Created by Kim Martini on 10/23/23.
//

import SwiftUI

struct LogbookDetail: View {
    let record: LogBookRecord
    
    @Environment(\.managedObjectContext) var moc

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                // Map showing where sampling started
                // Meta data list:
                // Sampling start
                // Total sampling time
                // Start Lat and Lon
                // Average water temperature
                // maximum depth
                
                Text(record.name ?? "Unknown name")
                RectangleDivider()
                Text(String(format: "%0.3f", record.startLatitude))
                Text(String(format: "%0.3f", record.startLongitude))
  

            }
        }
    }
}

//#Preview {
//    LogbookDetail()
//}
