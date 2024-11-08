//
//  WaterlockInstructionsView.swift
//  watchBoB Watch App
//
//  Created by Kim Martini on 11/8/24.
//

import SwiftUI

struct WaterlockInstructionsView: View {
    var body: some View {
        VStack(alignment: .center) {
            Text("Turn on waterlock to lock screen.")
                .font(.footnote)
                .foregroundColor(.white)
                .fixedSize(horizontal: false, vertical: true)
                .multilineTextAlignment(.center)
                .padding(.bottom, 20)
            
            HStack(alignment: .center) {
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
                .padding(.trailing, 20 )
                    
                Image(systemName: "arrow.right.square.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30)
                    .foregroundColor(.lightRed)
                
            }

        }
        .transition(.opacity)
        .padding(.all, 10)
    }
}

#Preview {
    WaterlockInstructionsView()
}
