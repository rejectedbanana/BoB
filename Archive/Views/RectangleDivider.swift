//
//  RectangleDivider.swift
//  watchBoB Watch App
//
//  Created by Kim Martini on 10/20/23.
//

import SwiftUI

struct RectangleDivider: View {
    var body: some View {
        Rectangle()
            .frame(height: 2)
            .foregroundColor(.silver)
            .padding(.vertical, 1)
    }
}

#Preview {
    RectangleDivider()
}
