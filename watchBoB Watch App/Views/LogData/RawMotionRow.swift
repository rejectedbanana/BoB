//
//  RawMotionRow.swift
//  watchBoB Watch App
//
//  Created by Kim Martini on 10/31/23.
//

import SwiftUI

struct RawMotionRow: View {
    var title: String
    var xValue: Double
    var yValue: Double
    var zValue: Double
    var stringFormat: String
    
    var body: some View {

        HStack{
            Text(title)
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(.lightRed)
                .padding(.leading, 5)
                .padding(.trailing, 5)
            
            dataText(label: "x", value: xValue, stringFormat: stringFormat)
            
            dataText(label: "y", value: yValue, stringFormat: stringFormat)
            
            dataText(label: "z", value: zValue, stringFormat: stringFormat)
            

        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct dataText: View {
    var label: String
    var value: Double
    var stringFormat: String
    
    var body: some View {
        HStack {
            Text(String(format: self.stringFormat, value))
                .frame(width: 45)
                .padding(.trailing, 2)

        }
    }
}

#Preview {
    RawMotionRow(title: "Acc", xValue: 0.01, yValue: 2.20 , zValue: 30.03, stringFormat: "%.2f")
}
