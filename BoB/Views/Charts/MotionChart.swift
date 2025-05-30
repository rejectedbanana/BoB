//
//  MotionChart.swift
//  BoB
//
//  Created by Kim Martini on 5/8/25.
//

import SwiftUI
import Charts

// Define structures so you can put three different lines on one chart
struct XYZData: Identifiable {
    let id = UUID()
    let date: Date
    let value: Double
    let axis: AxisType
}

// Define colors for X, Y and Z
enum AxisType: String, CaseIterable, Identifiable {
    case x = "X"
    case y = "Y"
    case z = "Z"

    var id: String { self.rawValue }

    var color: Color {
        switch self {
        case .x: return .blue
        case .y: return .fandango
        case .z: return .federalBlue
        }
    }
}

struct MotionChart: View {
    let motionData: [MotionData]
    let timeStampManager = TimeStampManager()
    
    // Transform the Accelerometer data for plotting
    var accData: [XYZData] {
            return motionData.flatMap { data -> [XYZData] in
                guard let date = timeStampManager.ISO8601StringtoDate(data.timestamp) else { return [] }
                var entries: [XYZData] = []

                if let x = data.accelerationX {
                    entries.append(XYZData(date: date, value: x, axis: .x))
                }
                if let y = data.accelerationY {
                    entries.append(XYZData(date: date, value: y, axis: .y))
                }
                if let z = data.accelerationZ {
                    entries.append(XYZData(date: date, value: z, axis: .z))
                }

                return entries
            }
        }
    var maxAbsAcceleration: Double {
        accData.map { abs($0.value) }.max() ?? 1.0
    }
    
    // Transform the Gyroscope data for plotting
    var gyrData: [XYZData] {
            return motionData.flatMap { data -> [XYZData] in
                guard let date = timeStampManager.ISO8601StringtoDate(data.timestamp) else { return [] }
                var entries: [XYZData] = []

                if let x = data.angularVelocityX {
                    entries.append(XYZData(date: date, value: x, axis: .x))
                }
                if let y = data.angularVelocityY {
                    entries.append(XYZData(date: date, value: y, axis: .y))
                }
                if let z = data.angularVelocityZ {
                    entries.append(XYZData(date: date, value: z, axis: .z))
                }

                return entries
            }
        }
    var maxAbsAngularVelocity: Double {
        gyrData.map { abs($0.value) }.max() ?? 1.0
    }

    // Transform the Magnetic Field Data for plotting
    var magData: [XYZData] {
            return motionData.flatMap { data -> [XYZData] in
                guard let date = timeStampManager.ISO8601StringtoDate(data.timestamp) else { return [] }
                var entries: [XYZData] = []

                if let x = data.magneticFieldX {
                    entries.append(XYZData(date: date, value: x, axis: .x))
                }
                if let y = data.magneticFieldY {
                    entries.append(XYZData(date: date, value: y, axis: .y))
                }
                if let z = data.magneticFieldZ {
                    entries.append(XYZData(date: date, value: z, axis: .z))
                }

                return entries
            }
        }
    var maxAbsMagneticField: Double {
        magData.map { abs($0.value) }.max() ?? 1.0
    }

    var body: some View {
        VStack {
            // Acceleration Plot
            Chart {
                ForEach(accData) { entry in
                    LineMark(
                        x: .value("Time", entry.date),
                        y: .value("Acceleration", entry.value),
                        series: .value("Direction", entry.axis.rawValue)
                    )
                    .foregroundStyle(by: .value("Axis", entry.axis.rawValue))
                    
                    PointMark(
                        x: .value("Time", entry.date),
                        y: .value("Acceleration", entry.value)
                    )
                    .foregroundStyle(by: .value("Axis", entry.axis.rawValue))
                    .symbolSize(10)
                    .accessibilityLabel("\(entry.axis) axis at \(timeStampManager.viewFormat(entry.date))")
                    .accessibilityValue("\(String(format: "%.3f", entry.value))")
                }
            }
            .chartForegroundStyleScale([
                "X": AxisType.x.color,
                "Y": AxisType.y.color,
                "Z": AxisType.z.color
            ])
            .chartYScale(domain: -maxAbsAcceleration ... maxAbsAcceleration)
            .chartYAxisLabel("Acceleration [m/s^2]")
            .chartLegend(position: .top, alignment: .leading)
            .frame(height: 220)
            
            // Anuglar Velocity Plot
            Chart {
                ForEach(gyrData) { entry in
                    LineMark(
                        x: .value("Time", entry.date),
                        y: .value("Angular Velocity", entry.value),
                        series: .value("Direction", entry.axis.rawValue)
                    )
                    .foregroundStyle(by: .value("Axis", entry.axis.rawValue))
                    
                    PointMark(
                        x: .value("Time", entry.date),
                        y: .value("Angular Velocity", entry.value)
                    )
                    .foregroundStyle(by: .value("Axis", entry.axis.rawValue))
                    .symbolSize(10)
                    .accessibilityLabel("\(entry.axis) axis at \(timeStampManager.viewFormat(entry.date))")
                    .accessibilityValue("\(String(format: "%.3f", entry.value))")
                }
            }
            .chartForegroundStyleScale([
                "X": AxisType.x.color,
                "Y": AxisType.y.color,
                "Z": AxisType.z.color
            ])
            .chartYScale(domain: -maxAbsAngularVelocity ... maxAbsAngularVelocity)
            .chartYAxisLabel("Angular Velocity [m/s]")
            .chartLegend(.hidden)
            .frame(height: 200)
            
            //  Magnetic Field Plot
            Chart {
                ForEach(magData) { entry in
                    LineMark(
                        x: .value("Time", entry.date),
                        y: .value("Magnetic Field", entry.value),
                        series: .value("Direction", entry.axis.rawValue)
                    )
                    .foregroundStyle(by: .value("Axis", entry.axis.rawValue))
                    
                    PointMark(
                        x: .value("Time", entry.date),
                        y: .value("Magmetic Field", entry.value)
                    )
                    .foregroundStyle(by: .value("Axis", entry.axis.rawValue))
                    .symbolSize(10)
                    .accessibilityLabel("\(entry.axis) axis at \(timeStampManager.viewFormat(entry.date))")
                    .accessibilityValue("\(String(format: "%.3f", entry.value))")
                }
            }
            .chartForegroundStyleScale([
                "X": AxisType.x.color,
                "Y": AxisType.y.color,
                "Z": AxisType.z.color
            ])
            .chartYScale(domain: -maxAbsMagneticField ... maxAbsMagneticField)
            .chartYAxisLabel("Magnetic Field [uT]")
            .chartLegend(.hidden)
            .frame(height: 200)
            
        }
    }
}

#Preview {
    let sampleMotionData = [
        MotionData(timestamp: "2025-05-05T23:25:51.015Z", accelerationX:  -0.042781, accelerationY: -0.1 , accelerationZ: -0.824951 , angularVelocityX: 0 , angularVelocityY: 0 , angularVelocityZ: 0, magneticFieldX: 0, magneticFieldY: 0, magneticFieldZ: 0 ),
        MotionData(timestamp: "2025-05-05T23:26:51.209Z", accelerationX:  0.004532, accelerationY: -0.299999 , accelerationZ: -0.850937 , angularVelocityX: 0.007171 , angularVelocityY: -0.003339 , angularVelocityZ: 0.000917, magneticFieldX: -10.309, magneticFieldY: -24.996, magneticFieldZ: -17.08 ),
        MotionData(timestamp: "2025-05-05T23:27:51.410Z", accelerationX:  -0.027241, accelerationY: -0.2, accelerationZ: -0.832413 , angularVelocityX: -0.018896 , angularVelocityY: 0.016209 , angularVelocityZ: -0.003137, magneticFieldX: -10.579, magneticFieldY: -25.273, magneticFieldZ: -16.473 ),
        MotionData(timestamp: "2025-05-05T23:28:51.610Z", accelerationX:  -0.004601, accelerationY: -0.537521 , accelerationZ: -0.843903 , angularVelocityX: 0 , angularVelocityY: 0.003899 , angularVelocityZ: 0.002769, magneticFieldX: -10.656, magneticFieldY: -25.29, magneticFieldZ: -16.579 )
    ]
    MotionChart(motionData: sampleMotionData)
}
