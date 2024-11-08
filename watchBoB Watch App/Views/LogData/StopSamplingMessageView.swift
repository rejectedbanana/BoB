//
//  StopSamplingMessageView.swift
//  watchBoB Watch App
//
//  Created by Kim Martini on 10/16/24.
//

import SwiftUI

struct StopSamplingMessageView: View {
    var body: some View {
//        NavigationView {
            VStack(alignment: .center) {
                ZStack {
                    Circle()
                        .fill(.blue)
                        .opacity(0.4)
                        .frame(width: 80, height: 80)
                    Image(systemName: "water.waves.and.arrow.trianglehead.up")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.lightRed)
                        .padding(.top, 10)
                }.padding(.bottom, 10)
                
                Text("Water lock off.")
                    .font(.footnote)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundColor(.white)
                
                Text("Sampling stopped.")
                    .font(.footnote)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundColor(.white)
                
                Text("Data saved.")
                    .font(.footnote)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundColor(.white)
                
                Spacer()
            }
            .transition(.opacity)
//        }
//        .toolbar(.hidden, for: .navigationBar)
    }
}

#Preview {
    StopSamplingMessageView()
}
