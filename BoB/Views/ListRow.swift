//
//  ListRow.swift
//  BoB
//
//  Created by Kim Martini on 5/10/24.
//

import SwiftUI

struct ListRow: View {
    let record: SampleSet
    
    var body: some View {
        HStack {
            Image(systemName: "mappin.and.ellipse")
                .resizable()
                .foregroundColor(.fandango)
                .frame(width: 30, height: 30)
            VStack(alignment: .leading) {
                Text(dateFormatter( record.startDatetime ?? Date(timeIntervalSince1970: 0) )) // change this unwrap to something else when I figure out how
                Text(String(format: "%0.3f", record.startLatitude)+" N, "+String(format: "%0.3f", record.startLongitude)+" E")
                    .foregroundStyle(.silver)
            }
        }
    }
}

//#Preview {
//    ListRow()
//}
