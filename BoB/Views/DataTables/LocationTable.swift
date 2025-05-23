//
//  LocationTable.swift
//  BoB
//
//  Created by Kim Martini on 5/6/25.
//

import SwiftUI

struct LocationTable: View {
    let locationData: [LocationData]
    
    var body: some View {
        NavigationStack {
            Table(locationData) {
                TableColumn("timestamp [ISO8601], latitude [°N], longitude [°E]") { location in
                    VStack(alignment: .leading) {
                        Text(location.timestamp)
                            .font(.subheadline)
                        HStack {
                            Text( String(format: "%0.4f", location.latitude ?? Double.nan )+" °N" )
                            Text( String(format: "%0.4f", location.longitude ?? Double.nan )+" °E")
                        }
                        .font(.body)
                        .foregroundColor(.gray)
                    }
                }
            }
            .navigationTitle("Location Data")
        }
        .padding(.leading, 10)
    }
}

#Preview {
    let sampleLocationData = [
        LocationData(timestamp: "2025-05-05T23:25:47.008Z", latitude: 46.85273524379032, longitude: -121.76021503897891),
        LocationData(timestamp: "2025-05-05T23:25:47.020Z", latitude: 46.85273524379032-0.00001, longitude: -121.76021503897891+0.00003),
        LocationData(timestamp: "2025-05-05T23:25:51.872Z", latitude: 46.85273524379032+0.00001, longitude: -121.76021503897891+0.00001),
        LocationData(timestamp: "2025-05-05T23:25:51.877Z", latitude: 46.85273524379032+0.00001, longitude: -121.76021503897891-0.00003)
    ]
    LocationTable(locationData: sampleLocationData)
}
