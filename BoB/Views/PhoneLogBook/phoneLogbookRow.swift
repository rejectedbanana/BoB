//
//  phoneLogbookRow.swift
//  BoB
//
//  Created by Kim Martini on 1/4/24.
//

import SwiftUI

struct phoneLogbookRow: View {
    let entry: Entry
    
    var body: some View {
        HStack {
            Image(systemName: "mappin.and.ellipse")
                .resizable()
                .foregroundColor(.fandango)
                .frame(width: 15, height: 15)
            
            VStack(alignment: .leading ) {
                Text(entry.id)
                Text("\(String(format: "%0.2f", entry.locationCoordinates.latitude)) N, \(String(format: "%0.2f", entry.locationCoordinates.longitude)) W")
            }
        }
    }
}

#Preview {
    phoneLogbookRow(entry: entries[0])
}
