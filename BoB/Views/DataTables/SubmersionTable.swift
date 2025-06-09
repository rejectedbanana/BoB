//
//  SubmersionTable.swift
//  BoB
//
//  Created by Kim Martini on 5/6/25.
//

import SwiftUI

struct SubmersionTable: View {
    let submersionData: [WaterSubmersionData]
    
    var body: some View {
        NavigationStack {
            if submersionData.isEmpty {
                VStack(alignment: .leading) {
                    HStack {
                        Text("No submersion data.")
                            .navigationTitle("Submersion Data ")
                        Spacer()
                    }
                    Spacer()
                }
                .padding(.leading, 20)
            } else {
                Table(submersionData) {
                    TableColumn("timestamp [ISO8601], depth [m], temperature [°C]") { data in
                        VStack(alignment: .leading) {
                            Text(data.timestamp)
                                .font(.subheadline)
                            HStack {
                                Text( String(format: "%0.2f", data.depth )+" m, " )
                                Text( String(format: "%0.1f", data.temperature ?? Double.nan)+" °C")
                            }
                            .font(.body)
                            .foregroundColor(.gray)
                        }
                    }
                }
                .navigationTitle("Submersion Data ")
            }
        }
        .padding(.leading, 10)
    }
}

#Preview {
    let sampleSubmersionData = [
        WaterSubmersionData(timestamp: "2025-05-05T23:25:47.008Z", depth: 0.0, temperature: 14.7),
        WaterSubmersionData(timestamp: "2025-05-05T23:25:50.020Z", depth: 1.1, temperature: 13.3),
        WaterSubmersionData(timestamp: "2025-05-05T23:25:53.872Z", depth: 1.9, temperature: 11.8),
        WaterSubmersionData(timestamp: "2025-05-05T23:25:56.877Z", depth: 3.2, temperature: 10.4),
    ]
    
    SubmersionTable(submersionData: sampleSubmersionData)
}
