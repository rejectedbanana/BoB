//
//  WatchSettingsView.swift
//  watchBoB Watch App
//
//  Created by Kim Martini on 8/8/25.
//

import SwiftUI

struct WatchSettingsView: View {
    @StateObject private var unitsManager = UnitsManager()
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker("", selection: $unitsManager.submersionUnits) {
                        ForEach(SubmersionUnits.allCases, id: \.self) { unit in
                            Text(unit.displayName)
                                .tag(unit)
                        }
                    }
                    .pickerStyle(.inline)
                    .labelsHidden()
                } header: {
                    Text("Submersion Display")
                }
            }
            .formStyle(.grouped)
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            
        }
    }
}

#Preview {
    WatchSettingsView()
}
