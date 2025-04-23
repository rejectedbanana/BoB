//
//  TimeSeriesView.swift
//  BoB
//
//  Created by Kim Martini on 4/1/25.
//

import SwiftUI
import Charts

struct Point: Identifiable {
    let id = UUID()
    let x: Date
    let y: Double
}

struct TimeSeriesView: View {
    
    let x: [Date]
    let y: [Double]
    let yVariable: String
    let yUnit: String
    
    private var points: [Point] {
        return mapTimeSeriesToPoint(x, y)
    }
    
    var body: some View {
        Chart(points) { point in
            LineMark(
                x: .value("Date", point.x),
                y: .value("Y", point.y)
            )
            .foregroundStyle(.blue)
            .interpolationMethod(.linear)
            .symbol(Circle())
            .accessibilityLabel("\(yVariable) versus Date")
            .accessibilityValue("\(yVariable) is \(point.y) \(yUnit)")
        }
        .chartYScale(domain: tightRange(for: points.map { $0.y }))
        .chartYAxisLabel("\(yVariable) [\(yUnit)]")
        .chartYAxis {
            AxisMarks(position: .leading)
        }
        .frame(height: 150)
        .padding()
    }
    
    // Make a function to convert the array into plotable points
    private func mapTimeSeriesToPoint(_ x: [Date], _ y: [Double]) -> [Point] {
        let dataPoints: [Point] = zip(x, y).map { Point(x: $0, y: $1) }
        return dataPoints
    }
    
    // Make a function for smaller plotting range
    func tightRange(for values: [Double]) -> ClosedRange<Double> {
        guard let min = values.min(), let max = values.max() else {
            return 0...1
        }
        return min...max
    }
}

#Preview {
    let xArray = [Date.now, Date.now.addingTimeInterval(60*1), Date.now.addingTimeInterval(60*2), Date.now.addingTimeInterval(60*3), Date.now.addingTimeInterval(60*4), Date.now.addingTimeInterval(60*5), Date.now.addingTimeInterval(60*6), Date.now.addingTimeInterval(60*7), Date.now.addingTimeInterval(60*8), Date.now.addingTimeInterval(60*9)]
    let yArray = [21.3,21.3,19.07,19.07,19.07,17.97,17.97,17.97,17.28,17.28]

    TimeSeriesView(x: xArray, y: yArray, yVariable: "Temperature", yUnit: "° C")
}
