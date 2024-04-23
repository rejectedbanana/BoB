//
//  DetailRow.swift
//  BoB
//
//  Created by Kim Martini on 4/4/24.
//

import SwiftUI

struct DetailRow: View {
    let header: String
    let content: String
    
    var body: some View {
            VStack(alignment: .leading) {
                Text(header)
                    .font(.callout)
                    .foregroundColor(Color.gray)
                Text(content)
                    .font(.body)
            }
    }
}

#Preview {
    DetailRow(header: "Header here", content: "information here")
}
