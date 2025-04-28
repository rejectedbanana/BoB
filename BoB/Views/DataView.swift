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
        case "location":
            return "timestamp [ISO8601], latitude [°N], longitude [°E]"
            case "motion":
            return " timestamp [ISO8601]\n acceleration X, Y, Z [m/s²]\n angular velocity X, Y, Z [rad/s]\n magnetic field X, Y, Z [µT]"
        case "submersion":
            return "timestamp [ISO8601], depth [m], temperature [°C]"
        default:
            return ""
        }
    }
    
    var body: some View {
        // use lazy vstacks to view data
        VStack {
            // dynamic headers
            Text("\(sensorType.capitalized) Data")
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
                case "location":
                    LazyVStack(alignment: .leading) {
                        ForEach(locations) { location in
                            Text("\( location.timestamp ), \( String(format: "%.4f", location.latitude) ), \( String( format: "%.2f", location.longitude) )")
                        }
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.all, 10)
                    
                case "motion":
                    LazyVStack() {
                        ForEach(motions) { motion in
                            VStack(alignment: .leading) {
                                Text("\(motion.timestamp)")
                                
                                Text("Acc: \(String(format: "%.6f", motion.accX)), \(String(format: "%.6f", motion.accY)), \(String(format: "%.6f", motion.accZ))" )
                                
                                Text("Rot: \(String(format: "%.6f", motion.gyrX)), \(String(format: "%.6f", motion.gyrY)), \(String(format: "%.6f", motion.gyrZ))")
                                
                                Text("Mag: \(String(format: "%.4f", motion.magX)), \(String(format: "%.4f", motion.magY)), \(String(format: "%.4f", motion.magZ))")
                            }
                        }
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.all, 15)
                    
                case "submersion":
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
        let timestamp = combinedData?.location.values.timestamp.map(\.self) ?? []
        let latitude = combinedData?.location.values.latitude.map(\.self) ?? []
        let longitude = combinedData?.location.values.longitude.map(\.self) ?? []
//        let locationData = combinedData?.location.values ?? []
        
        var locationArray: [Locations] = []
        
        for index in timestamp.indices {
            let newLocation = Locations(
                timestamp: timestamp[index] ?? "",
                latitude: latitude[index] ?? Double.nan,
                longitude: longitude[index] ?? Double.nan
            )
            
            locationArray.append(newLocation)
        }
//        for location in locationData {
//            let newLocation = Locations(timestamp: location.timestamp, latitude: location.latitude ?? Double.nan, longitude: location.longitude ?? Double.nan)
//            locationArray.append(newLocation)
//        }
        
        return locationArray
    }
    
    private func convertToMotionArray() -> [Motions] {
        let timestamp = combinedData?.motion.values.timestamp.map(\.self) ?? []
        let accX = combinedData?.motion.values.accelerationX.map(\.self) ?? []
        let accY = combinedData?.motion.values.accelerationY.map(\.self) ?? []
        let accZ = combinedData?.motion.values.accelerationZ.map(\.self) ?? []
        let gyrX = combinedData?.motion.values.angularVelocityX.map(\.self) ?? []
        let gyrY = combinedData?.motion.values.angularVelocityY.map(\.self) ?? []
        let gyrZ = combinedData?.motion.values.angularVelocityZ.map(\.self) ?? []
        let magX = combinedData?.motion.values.magneticFieldX.map(\.self) ?? []
        let magY = combinedData?.motion.values.magneticFieldY.map(\.self) ?? []
        let magZ = combinedData?.motion.values.magneticFieldZ.map(\.self) ?? []
        
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
        let timestamp = combinedData?.submersion.values.timestamp.map(\.self) ?? []
        let depth = combinedData?.submersion.values.depth.map(\.self) ?? []
        let temperature = combinedData?.submersion.values.temperature.map(\.self) ?? []
        
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

//#Preview {
//    let locationData = LocationData(
//        timestamp:  [
//            "2024-10-08T20:12:25Z",
//            "2024-10-08T20:12:25Z",
//            "2024-10-08T20:12:36Z",
//            "2024-10-08T20:12:36Z"
//          ],
//        latitude: [
//            47.6815,
//            47.6815,
//            47.6815,
//            47.6815
//          ],
//        longitude: [
//            -122.2835,
//            -122.2835,
//            -122.2835,
//            -122.2835
//          ])
//    let formattedLocationData = FormattedLocationData(values: locationData)
//    
//    let motionData = MotionData(
//        timestamp: [
//        "2024-10-08T20:12:27.058Z",
//        "2024-10-08T20:12:27.159Z",
//        "2024-10-08T20:12:27.258Z",
//        "2024-10-08T20:12:27.358Z"
//        ],
//        accelerationX: [
//        0,
//        0.18251,
//        0.18306,
//        0.183197],
//        accelerationY: [
//            0,
//            0.068802,
//            0.0681,
//            0.067474
//        ],
//        accelerationZ: [
//            0,
//            -0.981995,
//            -0.983765,
//            -0.983887
//            ],
//        angularVelocityX: [
//            0,
//            -0.003927,
//            -0.004953,
//            -0.005319
//            ],
//        angularVelocityY: [
//            0,
//            0.002478,
//            0.00736,
//            0.004074
//        ],
//        angularVelocityZ: [
//            0,
//            -0.002045,
//            3.1e-05,
//            0.001287
//            ],
//        magneticFieldX: [
//            0,
//            0.248,
//            0.246,
//            0.243
//            ],
//        magneticFieldY: [
//            0,
//            0.0248,
//            0.0246,
//            0.0243
//            ],
//        magneticFieldZ: [
//            0,
//            2.477,
//            2.464,
//            2.429
//            ]
//    )
//    let formattedMotionData = FormattedMotionData(values: motionData)
//    
//    let submersionData = WaterSubmersionData(
//        timestamp:  [
//        "2024-10-08T20:12:29Z",
//        "2024-10-08T20:12:30Z",
//        "2024-10-08T20:12:30Z",
//        "2024-10-08T20:12:30Z"
//        ],
//        depth: [
//        0.124,
//        0.124,
//        0.131,
//        0.131
//        ],
//        temperature: [
//            20.41,
//            20.41,
//            20.41,
//            20.41]
//    )
//    let formattedSubmersionData = FormattedSubmersionData(values: submersionData)
//    
//    
//    let combinedData = StructuredData(location: formattedLocationData, motion: formattedMotionData, submersion: formattedSubmersionData)
//    
//    DataView(combinedData: combinedData, sensorType: "submersion")
//}


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
