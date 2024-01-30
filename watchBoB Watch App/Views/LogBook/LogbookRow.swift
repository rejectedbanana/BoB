//
//  LogbookRow.swift
//  BoB
//
//  Created by Kim Martini on 10/23/23.
//

import SwiftUI

func dateFormatter(_ date: Date) -> String {
    let format = DateFormatter()
    format.dateFormat = "MMM d y, HH:MM:SS"
    return format.string(from: date)
}

struct LogbookRow: View {
    let record: LogBookRecord
    
    @Environment(\.managedObjectContext) var moc
    
    var body: some View {
        HStack {
            Image(systemName: "mappin.and.ellipse")
                .resizable()
                .foregroundColor(.fandango)
                .frame(width: 15, height: 15)
            VStack(alignment: .leading) {
                Text(dateFormatter( record.startDatetime ?? Date(timeIntervalSince1970: 0) )) // change this unwrap to something else when I figure out how
//                Text(record.name ?? "Name Unknown")
                Text("\(String(format: "%0.2f", record.startLatitude)), \(String(format: "%0.2f", record.startLongitude))")
            }
            .font(.footnote)
        }
    }
}

//#Preview {
//    LogbookRow()
//}
