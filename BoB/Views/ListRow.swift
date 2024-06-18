//
//  ListRow.swift
//  BoB
//
//  Created by Kim Martini on 5/10/24.
//

import SwiftUI

struct ListRow: View {
    let entry: SampleSet
    
    // time stamp formatter
    let timeStampFormatter = TimeStampManager()
    
    var body: some View {
        HStack {
            Image(systemName: "mappin.and.ellipse")
                .resizable()
                .foregroundColor(.fandango)
                .frame(width: 30, height: 30)
            VStack(alignment: .leading) {
                Text(timeStampFormatter.viewFormat( entry.startDatetime ?? Date(timeIntervalSince1970: 0) )) // change this unwrap to something else when I figure out how
                Text(String(format: "%0.3f", entry.startLatitude)+" N, "+String(format: "%0.3f", entry.startLongitude)+" E")
                    .foregroundStyle(.silver)
            }
        }
    }
}

//#Preview {
//    ListRow()
//}
