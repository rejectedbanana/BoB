//
//  JSONView.swift
//  BoB
//
//  Created by Hasan Armoush on 07/09/2024.
//

import SwiftUI

struct JSONView: View {
    let jsonContent: String
    let title: String
    
    @StateObject private var viewModel = JSONViewModel()
    
    var body: some View {
        VStack {
            ScrollView {
//                Text(viewModel.truncatedJSONContent)
                Text(jsonContent)
                    .padding()
                    .background(Color.black.opacity(0.05))
                    .cornerRadius(8)
                    .font(.system(size: 14, weight: .regular, design: .monospaced))
                    .multilineTextAlignment(.leading)
                    .padding()
            }
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            .padding()
            
            Spacer()
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    UIPasteboard.general.string = viewModel.truncatedJSONContent
                }) {
                    Image(systemName: "doc.on.doc")
                }
                .help("Copy JSON to clipboard")
            }
        }
        .onAppear {
            viewModel.processJSON(jsonContent)
        }
    }
}

