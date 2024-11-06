//
//  RawMotionRow.swift
//  watchBoB Watch App
//
//  Created by Kim Martini on 10/31/23.
//

import SwiftUI

struct RawMotionRow: View {
    
    //MARK: - Properties
    
    var title: String
    var xValue: Double
    var yValue: Double
    var zValue: Double
    var stringFormat: String
    
    var body: some View {

        HStack{
            Text(title)
                .frame(width: 33, alignment: .leading)
                .foregroundColor(.lightRed)
                .padding(.trailing, 2)
//                .border(Color.red)
            
            dataText(value: xValue, stringFormat: stringFormat)
            dataText(value: yValue, stringFormat: stringFormat)
            dataText(value: zValue, stringFormat: stringFormat)

        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct dataText: View {
    var value: Double
    var stringFormat: String
    
    var body: some View {
            Text(String(format: self.stringFormat, value))
                .frame(maxWidth: .infinity, alignment: .trailing)
//                .border(Color.green)
    }
}

#Preview {
    VStack{
        RawMotionRow(title: "Acc", xValue: 10.01, yValue: 2.20 , zValue: 30.03, stringFormat: "%.2f")
        RawMotionRow(title: "Gyr", xValue: -3.28, yValue: 0.11 , zValue: 0.39, stringFormat: "%.2f")
        RawMotionRow(title: "Mag", xValue: -3.467, yValue: -19.917 , zValue: 10.34, stringFormat: "%.1f")
    }
}
