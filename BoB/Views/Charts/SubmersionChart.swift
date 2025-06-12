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
    
    // pull out the minimum and maximum temperatures
    private var minTemperature: Double {
        submersionData.map{ $0.temperature }.min() ?? -2.0
    }
    private var maxTemperature: Double {
        submersionData.map{ $0.temperature }.max() ?? 150.0
    }

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
                    timeSeries(submersionData: submersionData, minTemperature: minTemperature, maxTemperature: maxTemperature)
                } else {
                    verticalProfile(submersionData: submersionData, minTemperature: minTemperature, maxTemperature: maxTemperature)
                }
            }
        }
    }
}

// make individual views for each type of submersion plot
// Time Series of Temperature and Pressure
struct timeSeries: View {
    let submersionData: [WaterSubmersionData]
    let minTemperature: Double
    let maxTemperature: Double
    let timeStampManager = TimeStampManager()
    
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
// Vertical profile of temperature agaist depth
struct verticalProfile: View {
    let submersionData: [WaterSubmersionData]
    let minTemperature: Double
    let maxTemperature: Double
    
    // Zoom state for X and Y axes
    @State private var xScale: CGFloat = 1.0
    @State private var yScale: CGFloat = 1.0
    
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
//        .chartXScale(domain: minTemperature...maxTemperature)
        .chartXScale(domain: xDomain())
        .chartYScale(domain: yDomain())
        .chartXAxisLabel("Temperature [°C]")
        .chartYAxisLabel("Depth [m]")
        .frame(height: 300)
        .gesture(
            MagnificationGesture()
                .onChanged { value in
                    let clamped = max(1.0, min(value, 10.0))
                    xScale = clamped
                    yScale = clamped
                }
        )
    }
    
    func xDomain() -> ClosedRange<Double> {
        let temps = submersionData.map { $0.temperature }
        guard let minT = temps.min(), let maxT = temps.max() else {
            return 0...1
        }
        let center = (minT + maxT) / 2
        let range = (maxT - minT) / xScale
        return (center-range / 2)...(center+range / 2)
        
    }
    
    func yDomain() -> ClosedRange<Double> {
        let depths = submersionData.map { $0.depth * -1 }
        guard let minD = depths.min(), let maxD = depths.max() else {
            return 0...1
        }
        let center = (minD + maxD) / 2
        let range = (maxD - minD) / yScale
        return (center-range / 2)...(center+range / 2)
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
