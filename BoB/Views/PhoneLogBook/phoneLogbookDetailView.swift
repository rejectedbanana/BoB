//
//  phoneLogbookDetail.swift
//  BoB
//
//  Created by Kim Martini on 1/4/24.
//

import SwiftUI

struct phoneLogbookDetailView: View {
    var body: some View {
        NavigationStack {
                List {
                    Section("Sample Details"){
                        phoneDetailRow(header: "Minimum Water Temperature", content: "7.0 °C")
                        phoneDetailRow(header: "Maximum Underwater Depth", content: "44.0 m")
                        phoneDetailRow(header: "Start Time", content: "Oct 17, 2023 at 12:10:39 PM PST")
                        phoneDetailRow(header: "End Time", content: "Oct 17, 2023 at 12:21:22 PM")
                        phoneDetailRow(header: "Samples", content: "1430")
                        phoneDetailRow(header: "Sampling Frequency", content: "10 Hz")
                        phoneDetailRow(header: "Source", content: "Kim's Apple Watch")
                    }
                    
                    Section("Device Details"){
                        phoneDetailRow(header: "Name", content: "Apple Watch")
                        phoneDetailRow(header: "Manufacturer", content: "Apple Inc.")
                        phoneDetailRow(header: "Model", content: "Ultra")
                        phoneDetailRow(header: "Hardware Version", content: "Watch6,18")
                        phoneDetailRow(header: "Software Version", content: "10.3")
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle("Details")
                .toolbar {
                    NavigationLink(destination: phoneLogbookExportDetailView()) {
                        Text("Export")
                    }
                }
        }
    }

}


struct phoneDetailRow: View {
    let header: String
    let content: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(header)
                .font(.callout)
                .foregroundColor(Color.gray)
            Text(content)
                .font(.body)
        }
    }
}

#Preview {
    phoneLogbookDetailView()
}
