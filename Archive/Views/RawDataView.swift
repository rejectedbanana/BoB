//
//  RawDataView.swift
//  watchBoB Watch App
//
//  Created by Kim Martini on 10/31/23.
//
// UNUSED VIEW
// The idea was to have two differnet views depending on the user, one for raw data and the other for useful data. This is the "Raw" view that is designed for scientists that want raw sensor data validation and/or troubleshooting.

import SwiftUI

struct RawDataView: View {
    var sensorLogger: SensorManager
    
    var body: some View {
        VStack {
            
            Text(sensorLogger.elapsedTime)
            
            RawMotionRow(title: "Acceleration", xValue: sensorLogger.accX, yValue: sensorLogger.accY, zValue: sensorLogger.accZ, stringFormat: "%.2f")
            
            RawMotionRow(title: "Rotation", xValue: sensorLogger.gyrX, yValue: sensorLogger.gyrY, zValue: sensorLogger.gyrZ, stringFormat: "%.2f")
            
            RawMotionRow(title: "Magnetic Field", xValue: sensorLogger.magX, yValue: sensorLogger.magY, zValue: sensorLogger.magZ, stringFormat: "%.1f")
            
            VStack {
                Text("Water")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.silver)
                    .padding(.leading, 5)
                HStack{
                    Text("pres")
                        .foregroundColor(.lightRed)
                    Text(String(format: "%2.1f", 10.1)+"m")
                        .padding(.trailing, 5)
                    
                    Text("temp")
                        .foregroundColor(.lightRed)
                    Text(String(format: "%2.1f", 17.1)+"C")
                        .padding(.trailing, 5)
                    
                    Text("Light")
                        .foregroundColor(.lightRed)
                    Text(String(format: "%2.0f", 54)+"%")
                        .padding(.trailing, 5)
                    
                }
            }
//            .frame(maxWidth: .infinity, alignment: .leading)
//            .padding(.bottom, 10)
        }
    }
}

//#Preview {
//    RawDataView(sensorLogger: [])
//}
