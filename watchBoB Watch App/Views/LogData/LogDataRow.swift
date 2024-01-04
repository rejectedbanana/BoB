//
//  LogDataRow.swift
//  watchBoB Watch App
//
//  Created by Kim Martini on 10/19/23.
//

import SwiftUI

struct LogDataRow: View {
    var name1: String
    var name2: String
    var value: String
    
    var body: some View {
        HStack(alignment: .lastTextBaseline){
            Text(value)
                .font(.title2)
                .frame(maxWidth: .infinity, alignment: .bottomTrailing)

            Text(name1+name2)
                .frame(maxWidth: .infinity, alignment: .bottomLeading)
                .font(/*@START_MENU_TOKEN@*/.footnote/*@END_MENU_TOKEN@*/)
                .foregroundColor(.lightRed)
        }
    }
}

#Preview {
    LogDataRow(name1: "Water", name2: "Temp", value: "17.0 \(degree())C")
}
