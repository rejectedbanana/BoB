//
//  ControlButtonView.swift
//  BoB
//
//  Created by Hasan Armoush on 15/09/2024.
//


import SwiftUI

struct ControlButtonView: View {
    @Binding var isLogging: Bool
    let startAction: () -> Void
    let stopAction: () -> Void
    
    var body: some View {
        Button(action: {
            isLogging.toggle()
            if isLogging {
                startAction()
            } else {
                stopAction()
            }
        }) {
            Text(isLogging ? "Stop" : "Start")
                .frame(maxWidth: .infinity)
        }
        .tint(isLogging ? .red : .blue)
        .frame(height: 35)
        .buttonStyle(.borderedProminent)
        .padding(.top, 10)
    }
}
