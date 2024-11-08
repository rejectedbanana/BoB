//
//  StartSamplingMessageView.swift
//  watchBoB Watch App
//
//  Created by Kim Martini on 10/16/24.
//

import SwiftUI

struct StartSamplingMessageView: View {
    var body: some View {
//        NavigationView {
            VStack(alignment: .center) {
                ZStack {
                    Circle()
                        .fill(.blue)
                        .opacity(0.4)
                        .frame(width: 80, height: 80)
                    Image(systemName: "drop.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.blue)
                }
                .padding(.bottom, 10)
                Text("Water lock on.")
                    .font(.footnote)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundColor(.white)
                Text("Turn off to stop sampling.")
                    .font(.footnote)
                    .foregroundColor(.white)
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.center)
            }
            .transition(.opacity)
            .padding(.all, 10)
//        }
//        .toolbar(.hidden, for: .navigationBar )
    }
}

#Preview {
    StartSamplingMessageView()
}
