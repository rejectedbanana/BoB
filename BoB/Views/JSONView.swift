//
//  JSONView.swift
//  BoB
//
//  Created by Hasan Armoush on 07/09/2024.
//

import SwiftUI

struct JSONView: View {
    let jsonContent: String
    let title: String
    
    var body: some View {
        VStack {
            ScrollView {
                Text(jsonContent)
                    .padding()
                    .background(Color.black.opacity(0.05))
                    .cornerRadius(8)
                    .font(.system(size: 14, weight: .regular, design: .monospaced))
                    .multilineTextAlignment(.leading)
                    .padding()
            }
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            .padding()
            
            Spacer()
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    UIPasteboard.general.string = jsonContent
                }) {
                    Image(systemName: "doc.on.doc")
                }
                .help("Copy JSON to clipboard")
            }
        }
    }
}

#Preview {
    JSONView(jsonContent: """
    {
        "MOTION": {
            "metadata": {
                "variables": "time,accelerometerX,accelerometerY,accelerometerZ,gyroscopeX,gyroscopeY,gyroscopeZ,magnetometerX,magnetometerY,magnetometerZ",
                "units": "yyyy-MM-dd'T'HH:mm:ss.SSSZ, m/s, m/s, m/s, radians/s, radians/s, radians/s, microTesla, microTesla, microTesla",
                "sensor_id": "motion",
                "description": "3-axis acceleration, rotation, and magnetic field from motion sensors"
            },
            "data": [
                ["2024-06-19T16:27:20.892Z", 0.0169, -0.0843, -0.9829, -0.0322, 0.0037, 0.0037, 12.0515, -7.9176, -46.0155]
            ]
        }
    }
    """, title: "Sample JSON")
}
