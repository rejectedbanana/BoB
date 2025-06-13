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
        .chartXScale(domain: xDomain())
        .chartYScale(domain: yDomain())
        .chartXAxisLabel("Temperature [°C]")
        .chartYAxisLabel("Depth [m]")
        .frame(height: 300)
        .contentShape(Rectangle())
        .clipped()
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
        let depths = submersionData.map { -1.0 * $0.depth }
        guard let minD = depths.min(), let maxD = depths.max() else {
            return 0...1
        }
        let center = (minD + maxD) / 2
        let range = (maxD - minD) / yScale
        return (center-range / 2)...(center+range / 2)
    }
}

//#Preview {
//    VerticalProfileChart()
//}
