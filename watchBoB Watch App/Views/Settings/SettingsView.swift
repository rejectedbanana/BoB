//
//  SettingsView.swift
//  watchBoB Watch App
//
//  Created by Kim Martini on 10/20/23.
//

import SwiftUI

struct SettingsView: View {
    var samplingFrequencies = [1, 10, 20, 50, 100]
    
    // Make this an object that can be passed to LogDataView
    @State private var samplingFrequency = 1
    
    // Pull in the settings to change them. Not sure how to change them so the app doesn't crash.
    @EnvironmentObject var settings: SettingsManager

    var body: some View {
        VStack {
            Text("Settings")
                .frame(maxWidth: .infinity, alignment: .leading)
            RectangleDivider()
            
            
                Picker("Sampling Frequency", selection: $samplingFrequency) {
                    ForEach(samplingFrequencies, id: \.self) {
                        Text(String($0)+" Hz")
                    }
                }
                .pickerStyle(.navigationLink)

        }
    }
}

#Preview {
    SettingsView()
}
