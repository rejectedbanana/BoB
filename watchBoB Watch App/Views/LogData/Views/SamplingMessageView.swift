//
//  SamplingMessageView.swift
//  BoB
//
//  Created by Hasan Armoush on 15/09/2024.
//


import SwiftUI

struct SamplingMessageView: View {
    let message: String
    let color: Color
    
    var body: some View {
        Text(message)
            .font(.headline)
            .foregroundColor(color)
            .transition(.opacity)
            .padding(.vertical, 16)
    }
}
