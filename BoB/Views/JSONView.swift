//
//  JSONView.swift
//  BoB
//
//  Created by Hasan Armoush on 06/09/2024.
//

import SwiftUI

struct JSONView: View {
    let jsonContent: String
    let title: String

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                Text(formatJSON(jsonContent))
                    .font(.system(size: 14, weight: .regular, design: .monospaced))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)
                    .padding()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .background(Color(.systemGray6))
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .padding()
    }

    func formatJSON(_ json: String) -> String {
        do {
            let jsonData = json.data(using: .utf8)!
            let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: [])
            let formattedData = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
            if let formattedString = String(data: formattedData, encoding: .utf8) {
                return formattedString
            }
        } catch {
            print("Error formatting JSON: \(error)")
        }
        return json
    }
}
