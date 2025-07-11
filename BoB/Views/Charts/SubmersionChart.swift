//
//  SubmersionChart.swift
//  BoB
//
//  Created by Kim Martini on 3/25/25.
//

import SwiftUI
import Charts

struct SubmersionChart: View {
    let submersionData: [WaterSubmersionData]
    
    @State private var isTimeSeries: Bool = true

    var body: some View {
        // If there is no data, don't plot anything
        if submersionData.isEmpty {
                Text("No submersion data to plot.")
        } else {
            VStack {
                Picker("View your preferred plot", selection: $isTimeSeries) {
                    Text("Time Series").tag(true)
                    Text("Vertical Profile").tag(false)
                }
                .pickerStyle(.segmented)
                
                if isTimeSeries {
                    SubmersionTimeSeriesChart(submersionData: submersionData)
                } else {
                    SubmersionVerticalProfileChart(submersionData: submersionData)
                }
            }
        }
    }
}

#Preview {
    let sampleSubmersionData = [
        WaterSubmersionData(timestamp: "2025-05-05T23:25:47.008Z", depth: 0.0, temperature: 14.7),
        WaterSubmersionData(timestamp: "2025-05-05T23:25:50.020Z", depth: 1.1, temperature: 14.6),
        WaterSubmersionData(timestamp: "2025-05-05T23:25:53.872Z", depth: 2.1, temperature: 14.2),
        WaterSubmersionData(timestamp: "2025-05-05T23:25:56.877Z", depth: 3.2, temperature: 10.4),
        WaterSubmersionData(timestamp: "2025-05-05T23:25:59.882Z", depth: 3.5, temperature: 6.4),
        WaterSubmersionData(timestamp: "2025-05-05T23:26:03.887Z", depth: 4.3, temperature: 3.0),
        WaterSubmersionData(timestamp: "2025-05-05T23:26:06.872Z", depth: 5.3, temperature: 2.1),
        WaterSubmersionData(timestamp: "2025-05-05T23:26:09.872Z", depth: 7.2, temperature: 2.0),
        WaterSubmersionData(timestamp: "2025-05-05T23:26:13.827Z", depth: 9.0, temperature: 1.9)
    ]
    
    SubmersionChart(submersionData: sampleSubmersionData)
}
