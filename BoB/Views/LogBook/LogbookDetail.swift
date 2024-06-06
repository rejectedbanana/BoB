//
//  phoneLogbookDetail.swift
//  BoB
//
//  Created by Kim Martini on 1/4/24.
//

import SwiftUI

struct LogbookDetail: View {
    let record: SampleSet
    var body: some View {
                List {
                    Section("Sample Details"){
                        DetailRow(header: "Minimum Water Temperature", content: "7.0 °C")
                        DetailRow(header: "Maximum Underwater Depth", content: "44.0 m")
                        DetailRow(header: "Start Time", content: dateFormatter( record.startDatetime ?? Date(timeIntervalSince1970: 0) ))
                        DetailRow(header: "End Time", content: dateFormatter( record.stopDatetime ?? Date(timeIntervalSince1970: 0) ))
                        DetailRow(header: "Samples", content: "1430")
                        DetailRow(header: "Sampling Frequency", content: "10 Hz")
                        DetailRow(header: "Source", content: "Kim's Apple Watch")
                    }
                    
                    Section("Device Details"){
                        DetailRow(header: "Name", content: "Apple Watch")
                        DetailRow(header: "Manufacturer", content: "Apple Inc.")
                        DetailRow(header: "Model", content: "Ultra")
                        DetailRow(header: "Hardware Version", content: "Watch6,18")
                        DetailRow(header: "Software Version", content: "10.3")
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle("Details")
                .toolbar {
                    ShareLink(item: "Your sweet ocean data")
                }
    }

}

//#Preview {
//    LogbookDetail()
//}
