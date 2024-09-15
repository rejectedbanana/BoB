//
//  DataRowView.swift
//  BoB
//
//  Created by Hasan Armoush on 15/09/2024.
//


import SwiftUI

struct DataRowView: View {
    let label: String
    let value1: String
    let value2: String
    
    var body: some View {
        HStack {
            Text(label)
                .frame(width: 50, alignment: .leading)
            Spacer()
            Text("\(value1), \(value2)")
        }
        .padding(.horizontal, 5)
    }
}
