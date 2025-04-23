//
//  SubmersionChart.swift
//  BoB
//
//  Created by Kim Martini on 3/25/25.
//

import SwiftUI
import Charts

//struct Point: Identifiable {
//    let id = UUID()
//    let x: Date
//    let y: Double
//}

struct SubmersionChart: View {
    let data: WaterSubmersionData
    let timeStampManager = TimeStampManager()
    
    private var tempPoints: [Point] {
        return mapTimeSeriesToPoint(data.timestamp, data.temperature)
    }
    private var depthPoints: [Point] {
        return mapTimeSeriesToPoint(data.timestamp, data.depth)
    }
    
    var body: some View {
        Chart(tempPoints) { item in
            LineMark(
                x: .value("Date", item.x),
                y: .value("Temperature in Celsius", item.y)
            )
            .foregroundStyle(.blue)
            .interpolationMethod(.linear)
            .symbol(Circle())
            .accessibilityLabel("Temperature versus Date")
            .accessibilityValue("Temperature: \(item.x) degrees Celsius")
        }
        .chartYAxisLabel("Temperature [°C]")
        .chartYAxis {
            AxisMarks(position: .leading)
        }
        .frame(height: 200)
        .padding()
        
        
        Chart(depthPoints) {item in
            LineMark(
                x: .value("Date", item.x),
                y: .value("Depth in meters", -1*item.y)
            )
            .foregroundStyle(.blue)
            .interpolationMethod(.linear)
            .symbol(Circle())
            .accessibilityLabel("Depth versus Date")
            .accessibilityValue("Depth: \(item.x) meters")
        }
        .chartYAxisLabel("Depth [m]")
        .chartYAxis {
            AxisMarks(position: .leading)
        }
        .frame(height: 200)
        .padding()
    }
    
    // Convert the arrays into something that can be use by the chart
    private func mapTimeSeriesToPoint(_ x: [String], _ y: [Double]) -> [Point] {
        var xArray: [Date] = []
        for xx in x  {
            xArray.append(timeStampManager.ISO8601StringtoDate(xx) ?? Date())
        }
        let yArray = y
        let dataPoints: [Point] = zip(xArray, yArray).map {Point(x: $0, y: $1) }
        
        return dataPoints
    }
}

#Preview {
    let submersionData = WaterSubmersionData(
        timestamp:  ["2024-10-08T20:12:00Z","2024-10-08T20:13:00Z","2024-10-08T20:14:00Z","2024-10-08T20:15:00Z"],
        depth: [0.124,0.124,0.131,0.131],
        temperature: [18,19,20,19.5]
    )
    
    SubmersionChart(data: submersionData)
}
