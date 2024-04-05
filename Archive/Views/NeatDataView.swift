//
//  NeatDataView.swift
//  watchBoB Watch App
//
//  Created by Kim Martini on 10/31/23.
//
// UNUSED VIEW
// The idea was to have two differnet views depending on the user, one for raw data and the other for useful data. This is the "Neat" view that is designed for the outdoor enthusiast that wants practical information such as water temperature, water depth, wave height and wave period. 

import SwiftUI

struct NeatDataView: View {
//    var sensorLogger: SensorManager
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "timer")
                Image(systemName: "thermometer.and.liquid.waves")
                Image(systemName: "water.waves.and.arrow.down")
                Spacer()
                Text("Water Weather")
                    .foregroundColor(.silver)
            }
            .foregroundColor(.blue)
            .frame(width: .infinity, alignment: .leading)
            .padding(.leading, 5)
            .padding(.bottom, 5)
            
//                        LogDataRow(name1: "Time", name2: "Time", value: "00:00")
                        LogDataRow(name1: "Water", name2: "Temp", value: "17.1 \(degree())C")
                        LogDataRow(name1: "Water", name2: "Depth", value: "10.1 m")
                        LogDataRow(name1: "Wave", name2: "Height", value: "1 m")
                        LogDataRow(name1: "Wave", name2: "Period", value: "1 s")
        }
    }
}

#Preview {
    NeatDataView()
}
