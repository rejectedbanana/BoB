//
//  phoneLogbookDetailRow.swift
//  BoB
//
//  Created by Kim Martini on 2/29/24.
//

import SwiftUI

struct phoneLogbookDetailRow: View {
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
    phoneLogbookDetailRow(header: "Water Temperature", content: "8 °C")
}
