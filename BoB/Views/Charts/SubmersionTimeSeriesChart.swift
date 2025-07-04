//
//  SubmersionTimeSeriesChart.swift
//  BoB
//
//  Created by Kim Martini on 6/13/25.
//

import SwiftUI
import Charts

struct SubmersionTimeSeriesChart: View {
    let submersionData: [WaterSubmersionData]
    let timeStampManager = TimeStampManager()
    
    // pull out the minimum and maximum temperatures
    private var minTemperature: Double {
        submersionData.map{ $0.temperature }.min() ?? -2.0
    }
    private var maxTemperature: Double {
        submersionData.map{ $0.temperature }.max() ?? 120.0
    }
    
    var body: some View {
        VStack {
            Chart(submersionData) { item in
                LineMark(
                    x: .value("Date", timeStampManager.ISO8601StringtoDate(item.timestamp) ?? Date()),
                    y: .value("Depth", -1*(item.depth))
                )
                .foregroundStyle(.blue)
                .interpolationMethod(.linear)
                
                PointMark(
                    x: .value("Date", timeStampManager.ISO8601StringtoDate(item.timestamp) ?? Date()),
                    y: .value("Depth", -1.0*(item.depth) )
                )
                .symbolSize(10)
                .accessibilityLabel("Depth versus Time")
                .accessibilityValue("Depth: \(item.depth) meters")
            }
            .chartYAxisLabel("Depth [m]")
            
            Chart(submersionData) { item in
                LineMark(
                    x: .value("Date", timeStampManager.ISO8601StringtoDate(item.timestamp) ?? Date()),
                    y: .value("Temperature", item.temperature)
                )
                .foregroundStyle(.blue)
                .interpolationMethod(.linear)
                
                PointMark(
                    x: .value("Date", timeStampManager.ISO8601StringtoDate(item.timestamp) ?? Date()),
                    y: .value("Acceleration", item.temperature)
                )
                .symbolSize(10)
                .accessibilityLabel("Temperature versus Time")
                .accessibilityValue("Temperature: \(item.temperature) degrees Celsius")
            }
            .chartYScale(domain: minTemperature...maxTemperature)
            .chartYAxisLabel("Temperature [°C]")
        }
        .frame(height: 300)
    }
}

//#Preview {
//    SubmersionTimeSeriesChart()
//}
