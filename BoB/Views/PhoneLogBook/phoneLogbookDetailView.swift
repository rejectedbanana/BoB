//
//  phoneLogbookDetail.swift
//  BoB
//
//  Created by Kim Martini on 1/4/24.
//

import SwiftUI

struct phoneLogbookDetailView: View {
    var body: some View {
        NavigationView {
            VStack {
                List {
                    Section("Sample Details"){
                        phoneLogbookDetailRow(header: "Minimum Water Temperature", content: "7.0 °C")
                        phoneLogbookDetailRow(header: "Maximum Underwater Depth", content: "44.0 m")
                        phoneLogbookDetailRow(header: "Start Time", content: "Oct 17, 2023 at 12:10:39 PM PST")
                        phoneLogbookDetailRow(header: "End Time", content: "Oct 17, 2023 at 12:21:22 PM")
                        phoneLogbookDetailRow(header: "Samples", content: "1430")
                        phoneLogbookDetailRow(header: "Sampling Frequency", content: "10 Hz")
                        phoneLogbookDetailRow(header: "Source", content: "Kim's Apple Watch")
                    }
                    
                    Section("Device Details"){
                        phoneLogbookDetailRow(header: "Name", content: "Apple Watch")
                        phoneLogbookDetailRow(header: "Manufacturer", content: "Apple Inc.")
                        phoneLogbookDetailRow(header: "Model", content: "Ultra")
                        phoneLogbookDetailRow(header: "Hardware Version", content: "Watch6,18")
                        phoneLogbookDetailRow(header: "Software Version", content: "10.3")
                    }
                }
                
                Spacer()
                
                NavigationLink(destination: phoneLogbookExportDetailView()) {
                    Button("Export") {
                    
                    }
                    .padding()
                    .frame(maxWidth: .infinity, minHeight: 40)
                    .background(.gray)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                .padding()
                }
            }
        }
    }

}

#Preview {
    phoneLogbookDetailView()
}
