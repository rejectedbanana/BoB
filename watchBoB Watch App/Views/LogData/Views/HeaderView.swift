//
//  HeaderView.swift
//  BoB
//
//  Created by Hasan Armoush on 15/09/2024.
//


import SwiftUI

struct HeaderView: View {
    let title: String
    
    var body: some View {
        Text(title)
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundColor(.gray)
            .padding(.horizontal, 5)
            .padding(.top, 10)
    }
}
