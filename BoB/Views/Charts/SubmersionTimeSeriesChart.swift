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
    
    @State private var showSelectionBar = false
    @State private var offsetX = 0.0
    @State private var offsetY = 0.0
    @State private var selectedTempString: String = ""
    @State private var selectedDepthString: String = ""
    
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
            .chartOverlay {proxy in
                GeometryReader { geometry in
                    Rectangle()
                        .foregroundStyle(.fandango)
                        .frame(width: 2, height: geometry.size.height * 0.95)
                        .opacity(showSelectionBar ? 1.0 : 0.0)
                        .offset(x: offsetX)
                    
                    Capsule()
                        .foregroundStyle(.fandango)
                        .frame(width: 60, height: 25)
                        .overlay {
                            VStack {
                                Text("\(selectedDepthString) m")
                                    .font(.caption)
                            }
                            .foregroundStyle(.white.gradient)
                        }
                        .opacity(showSelectionBar ? 1.0 : 0.0)
                        .offset(x: offsetX - 30, y: offsetY - 30)
                    
                    Rectangle()
                        .fill(.clear)
                        .contentShape(Rectangle())
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    if !showSelectionBar {
                                        showSelectionBar = true
                                    }
                                    
                                    if let plotFrame = proxy.plotFrame {
                                        let origin = geometry[plotFrame].origin
                                        let location = CGPoint(
                                            x: value.location.x - origin.x,
                                            y: value.location.y - origin.y
                                        )
                                        offsetX = location.x
                                        offsetY = location.y
                                        
                                        if let date: Date = proxy.value(atX: location.x) {
                                            if let selectedRecord: WaterSubmersionData = findNearestData(to: date) {
                                                selectedDepthString =  String(format: "%.1f", selectedRecord.depth)
                                                selectedTempString =  String(format: "%.1f", selectedRecord.temperature)
                                            }
                                            
                                        }
                                    }
                                }
                                .onEnded( {_ in
                                    showSelectionBar = false
                                })
                        )
                }
            }
            
            
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
            .chartOverlay {proxy in
                GeometryReader { geometry in
                    Rectangle()
                        .foregroundStyle(.fandango)
                        .frame(width: 2, height: geometry.size.height * 0.95)
                        .opacity(showSelectionBar ? 1.0 : 0.0)
                        .offset(x: offsetX)
                    
                    Capsule()
                        .foregroundStyle(.fandango)
                        .frame(width: 60, height: 25)
                        .overlay {
                            VStack {
                                Text("\(selectedTempString) °C")
                                    .font(.caption)
                            }
                            .foregroundStyle(.white.gradient)
                        }
                        .opacity(showSelectionBar ? 1.0 : 0.0)
                        .offset(x: offsetX - 30, y: offsetY - 30)
                    
                    Rectangle()
                        .fill(.clear)
                        .contentShape(Rectangle())
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    if !showSelectionBar {
                                        showSelectionBar = true
                                    }
                                    
                                    if let plotFrame = proxy.plotFrame {
                                        let origin = geometry[plotFrame].origin
                                        let location = CGPoint(
                                            x: value.location.x - origin.x,
                                            y: value.location.y - origin.y
                                        )
                                        offsetX = location.x
                                        offsetY = location.y
                                        
                                        if let date: Date = proxy.value(atX: location.x) {
                                            if let selectedRecord: WaterSubmersionData = findNearestData(to: date) {
                                                selectedDepthString =  String(format: "%.1f", selectedRecord.depth)
                                                selectedTempString =  String(format: "%.1f", selectedRecord.temperature)
                                            }
                                            
                                        }
                                    }
                                }
                                .onEnded( {_ in
                                    showSelectionBar = false
                                })
                        )
                }
            }
        }
        .frame(height: 300)
    }
    
    func findNearestData(to date: Date) -> WaterSubmersionData? {
        submersionData.min(by: { abs( timeStampManager.ISO8601StringtoDate($0.timestamp)!.timeIntervalSince(date)) < abs( timeStampManager.ISO8601StringtoDate($1.timestamp)!.timeIntervalSince(date)) })
    }
}

//#Preview {
//    SubmersionTimeSeriesChart()
//}
