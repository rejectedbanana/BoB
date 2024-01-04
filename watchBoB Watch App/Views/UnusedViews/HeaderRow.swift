//
//  HeaderRow.swift
//  watchBoB Watch App
//
//  Created by Kim Martini on 10/20/23.
//
// Some UI ideas for the header row

import SwiftUI

struct HeaderRow: View {
    var latitude: String
    var longitude: String
    
    var body: some View {
        VStack {
            // Header Option #1
            VStack {
                HStack(alignment: .lastTextBaseline) {
                    Spacer()
                    Text("Start")
                        .font(.title3)
                        .foregroundColor(.fandango)
                    //                    .frame(maxWidth: .infinity, alignment: .leading)
                    VStack(alignment: .leading) {
                        Text("12:01 PM PST")
                            .font(.footnote)
                        Text("47.6N,-122.2W")
                            .font(.footnote)
                    }
                    
                }
                .padding(.leading)
                .padding(.trailing, 10)
                
                RectangleDivider()
                    .opacity(0.5)
            }
            .padding(.bottom, 20)
            
            // Header Option #2
            VStack {
                Text("Starting Location")
                    .font(.footnote)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                Text("\(latitude), \(longitude)")
                    .font(.subheadline)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .foregroundColor(.lightRed)
            }
        }
    }
}

#Preview {
    HeaderRow(latitude: "47.68 \(degree())N", longitude: "-122.28 \(degree())W")
}
