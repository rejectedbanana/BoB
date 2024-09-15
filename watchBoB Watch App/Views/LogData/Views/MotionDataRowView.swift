//
//  MotionDataRowView.swift
//  BoB
//
//  Created by Hasan Armoush on 15/09/2024.
//


import SwiftUI

struct MotionDataRowView: View {
    let title: String
    let xValue: Double
    let yValue: Double
    let zValue: Double
    let stringFormat: String
    
    var body: some View {
        HStack {
            Text("\(title):")
                .frame(width: 50, alignment: .leading)
            Spacer()
            Text(String(format: stringFormat, xValue))
            Text(String(format: stringFormat, yValue))
            Text(String(format: stringFormat, zValue))
        }
        .padding(.horizontal, 5)
    }
}
