//
//  WaterDataView.swift
//  BoB
//
//  Created by Hasan Armoush on 15/09/2024.
//


import SwiftUI

struct WaterDataView: View {
    let depth: Double?
    let temperature: Double?
    
    var body: some View {
        HStack {
            if let depth = depth, let temperature = temperature {
                Text(String(format: "%.2f m", depth))
                Spacer()
                Text(String(format: "%.2f°C", temperature))
            } else {
                Text("No data yet")
                    .foregroundColor(.gray)
                Spacer()
            }
        }
        .padding(.horizontal, 50)
    }
}
