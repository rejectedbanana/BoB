//
//  LogbookDetail.swift
//  watchBoB Watch App
//
//  Created by Kim Martini on 10/23/23.
//

import SwiftUI

struct LogbookDetail: View {
    let entry: LogBookEntry
    
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
                
                Text(entry.name ?? "Unknown name")
                RectangleDivider()
                Text(String(format: "%0.3f", entry.startLatitude))
                Text(String(format: "%0.3f", entry.startLongitude))
  

            }
        }
    }
}

//#Preview {
//    LogbookDetail()
//}
