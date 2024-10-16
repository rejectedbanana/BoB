//
//  DataView.swift
//  BoB
//
//  Created by Kim Martini on 10/11/24.
//

import SwiftUI

struct DataView: View {
    let combinedData: StructuredData?
    let sensorType: String
    
    private var locations: [Locations] {
        return convertToLocationArray()
    }
    private var motions: [Motions] {
        return convertToMotionArray()
    }
    private var submersions: [Submersion] {
        return convertToSubmersionArray()
    }
    
    private let dataTitle: String = ""
    private var dataLabels: String {
        switch sensorType {
        case "LOCATION":
            return "timestamp [ISO8601], latitude [°N], longitude [°E]"
            case "MOTION":
            return " timestamp [ISO8601]\n acceleration X, Y, Z [m/s²]\n angular velocity X, Y, Z [rad/s]\n magnetic field X, Y, Z [µT]"
        case "SUBMERSION":
            return "timestamp [ISO8601], depth [m], temperature [°C]"
        default:
            return ""
        }
    }
    
    var body: some View {
        // use lazy vstacks to view data
        VStack {
            // dynamic headers
            Text("\(sensorType) DATA")
                .frame(maxWidth: .infinity, alignment: .center)
                .padding()
                .font(.title)
            
            Text(dataLabels)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 20)
                .font(.system(size: 12, weight: .regular, design: .monospaced))
            
            // scrollable data view
            ScrollView {
                switch sensorType {
                case "LOCATION":
                    LazyVStack(alignment: .leading) {
                        ForEach(locations) { location in
                            Text("\( location.timestamp ), \( String(format: "%.4f", location.latitude) ), \( String( format: "%.2f", location.longitude) )")
                        }
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.all, 10)
                    
                case "MOTION":
                    LazyVStack() {
                        ForEach(motions) { motion in
                            VStack(alignment: .leading) {
                                Text("\(motion.timestamp)")
                                
                                Text("Acc: \(String(format: "%.6f", motion.accX)), \(String(format: "%.6f", motion.accY)), \(String(format: "%.6f", motion.accZ))" )
                                
                                Text("Rot: \(String(format: "%.6f", motion.gyrX)), \(String(format: "%.6f", motion.gyrY)), \(String(format: "%.6f", motion.gyrZ))")
                                
                                Text("Mag: \(String(format: "%.4f", motion.gyrX)), \(String(format: "%.4f", motion.gyrY)), \(String(format: "%.4f", motion.gyrZ))")
                            }
                        }
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.all, 15)
                    
                case "SUBMERSION":
                    LazyVStack() {
                        ForEach(submersions) { submersion in
                            Text("\( submersion.timestamp ), \( String(format: "%.2f", submersion.depth) ), \( String( format: "%.2f", submersion.temperature) )")
                        }
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.all, 10)
                    
                default:
                    Text("No data")
                    
                }
            }
            .font(.system(size: 14, weight: .regular, design: .monospaced))
            .background(.white)
            .cornerRadius(10)
            .padding(.all, 10)
        }
        .background(Color.gray.opacity(0.1))
    }
    
    
    // FUNCTIONS TO CONVERT ARRAYS TO STRUCTURES
    private func convertToLocationArray() -> [Locations] {
        let timestamp = combinedData?.LOCATION.values.timestamp.map(\.self) ?? []
        let latitude = combinedData?.LOCATION.values.latitude.map(\.self) ?? []
        let longitude = combinedData?.LOCATION.values.longitude.map(\.self) ?? []
        
        var locationArray: [Locations] = []
        
        for index in timestamp.indices {
            let newLocation = Locations(
                timestamp: timestamp[index] ?? "",
                latitude: latitude[index] ?? Double.nan,
                longitude: longitude[index] ?? Double.nan
            )
            
            locationArray.append(newLocation)
        }
        
        return locationArray
    }
    
    private func convertToMotionArray() -> [Motions] {
        let timestamp = combinedData?.MOTION.values.timestamp.map(\.self) ?? []
        let accX = combinedData?.MOTION.values.accelerationX.map(\.self) ?? []
        let accY = combinedData?.MOTION.values.accelerationY.map(\.self) ?? []
        let accZ = combinedData?.MOTION.values.accelerationZ.map(\.self) ?? []
        let gyrX = combinedData?.MOTION.values.rotationRateX.map(\.self) ?? []
        let gyrY = combinedData?.MOTION.values.rotationRateY.map(\.self) ?? []
        let gyrZ = combinedData?.MOTION.values.rotationRateZ.map(\.self) ?? []
        let magX = combinedData?.MOTION.values.magneticFieldX.map(\.self) ?? []
        let magY = combinedData?.MOTION.values.magneticFieldY.map(\.self) ?? []
        let magZ = combinedData?.MOTION.values.magneticFieldZ.map(\.self) ?? []
        
        var motionArray: [Motions] = []
        
        for index in timestamp.indices {
            let newMotion = Motions(
                timestamp: timestamp[index] ?? "",
                accX: accX[index] ?? Double.nan,
                accY: accY[index] ?? Double.nan,
                accZ: accZ[index] ?? Double.nan,
                gyrX: gyrX[index] ?? Double.nan,
                gyrY: gyrY[index] ?? Double.nan,
                gyrZ: gyrZ[index] ?? Double.nan,
                magX: magX[index] ?? Double.nan,
                magY: magY[index] ?? Double.nan,
                magZ: magZ[index] ?? Double.nan
                )
            motionArray.append(newMotion)
        }
        
        return motionArray
    }
    
    private func convertToSubmersionArray() -> [Submersion] {
        let timestamp = combinedData?.SUBMERSION.values.timestamp.map(\.self) ?? []
        let depth = combinedData?.SUBMERSION.values.depth.map(\.self) ?? []
        let temperature = combinedData?.SUBMERSION.values.temperature.map(\.self) ?? []
        
        var submersionArray: [Submersion] = []
        
        for index in timestamp.indices {
            let newSubmersion = Submersion(
                timestamp: timestamp[index],
                depth: depth[index],
                temperature: temperature[index]
            )
            submersionArray.append(newSubmersion)
        }
        
        return submersionArray
        
    }
}

#Preview {
    let locationData = LocationData(
        timestamp:  [
            "2024-10-08T20:12:25Z",
            "2024-10-08T20:12:25Z",
            "2024-10-08T20:12:36Z",
            "2024-10-08T20:12:36Z"
          ],
        latitude: [
            47.6815,
            47.6815,
            47.6815,
            47.6815
          ],
        longitude: [
            -122.2835,
            -122.2835,
            -122.2835,
            -122.2835
          ])
    let formattedLocationData = FormattedLocationData(values: locationData)
    
    let motionData = MotionData(
        timestamp: [
        "2024-10-08T20:12:27.058Z",
        "2024-10-08T20:12:27.159Z",
        "2024-10-08T20:12:27.258Z",
        "2024-10-08T20:12:27.358Z"
        ],
        accelerationX: [
        0,
        0.18251,
        0.18306,
        0.183197],
        accelerationY: [
            0,
            0.068802,
            0.0681,
            0.067474
        ],
        accelerationZ: [
            0,
            -0.981995,
            -0.983765,
            -0.983887
            ],
        rotationRateX: [
            0,
            -0.003927,
            -0.004953,
            -0.005319
            ],
        rotationRateY: [
            0,
            0.002478,
            0.00736,
            0.004074
        ],
        rotationRateZ: [
            0,
            -0.002045,
            3.1e-05,
            0.001287
            ],
        magneticFieldX: [
            0,
            0.248,
            0.246,
            0.243
            ],
        magneticFieldY: [
            0,
            0.0248,
            0.0246,
            0.0243
            ],
        magneticFieldZ: [
            0,
            2.477,
            2.464,
            2.429
            ]
    )
    let formattedMotionData = FormattedMotionData(values: motionData)
    
    let submersionData = WaterSubmersionData(
        timestamp:  [
        "2024-10-08T20:12:29Z",
        "2024-10-08T20:12:30Z",
        "2024-10-08T20:12:30Z",
        "2024-10-08T20:12:30Z"
        ],
        depth: [
        0.124,
        0.124,
        0.131,
        0.131
        ],
        temperature: [
            20.41,
            20.41,
            20.41,
            20.41]
    )
    let formattedSubmersionData = FormattedSubmersionData(values: submersionData)
    
    
    let combinedData = StructuredData(LOCATION: formattedLocationData, MOTION: formattedMotionData, SUBMERSION: formattedSubmersionData)
    
    DataView(combinedData: combinedData, sensorType: "SUBMERSION")
}


private struct Locations: Identifiable {
    let id: UUID = UUID()
    let timestamp: String
    let latitude: Double
    let longitude: Double
}

private struct Motions: Identifiable {
    let id: UUID = UUID()
    let timestamp: String
    let accX: Double
    let accY: Double
    let accZ: Double
    let gyrX: Double
    let gyrY: Double
    let gyrZ: Double
    let magX: Double
    let magY: Double
    let magZ: Double
}

private struct Submersion: Identifiable {
    let id: UUID = UUID()
    let timestamp: String
    let depth: Double
    let temperature: Double
}
