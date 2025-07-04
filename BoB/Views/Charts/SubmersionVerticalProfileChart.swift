//
//  SubmersionVerticalProfileChart.swift
//  BoB
//
//  Created by Kim Martini on 6/13/25.
//

import SwiftUI
import Charts

struct SubmersionVerticalProfileChart: View {
    let submersionData: [WaterSubmersionData]
    
    // pull out the minimum and maximum temperatures
    private var minTemperature: Double {
        submersionData.map{ $0.temperature }.min() ?? -2.0
    }
    private var maxTemperature: Double {
        submersionData.map{ $0.temperature }.max() ?? 120.0
    }
    
    // pull out the minimum and maximum temperatures
    private var minDepth: Double {
        submersionData.map{ $0.depth }.min() ?? 0.0
    }
    private var maxDepth: Double {
        submersionData.map{ $0.depth }.max() ?? 44.0
    }
    
    var body: some View {
        Chart(submersionData) { item in
            LineMark(
                x: .value("Temperature", item.temperature),
                y: .value("Depth", -1*(item.depth))
            )
            .foregroundStyle(.blue)
            .interpolationMethod(.linear)

            PointMark(
                x: .value("Temperature", item.temperature),
                y: .value("Depth", -1*(item.depth))
            )
            .symbolSize(10)
            .accessibilityLabel("Temperature versus Depth")
            .accessibilityValue("Temperature: \(item.temperature) degrees Celsius")
        }
        .chartXScale(domain: minTemperature...maxTemperature)
        .chartYScale(domain: -1*maxDepth...minDepth)
        .chartXAxisLabel("Temperature [°C]")
        .chartYAxisLabel("Depth [m]")
        .frame(height: 300)
        .contentShape(Rectangle())
        .clipped()
    }
}

//#Preview {
//    VerticalProfileChart()
//}
