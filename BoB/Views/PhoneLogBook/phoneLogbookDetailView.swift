//
//  phoneLogbookDetail.swift
//  BoB
//
//  Created by Kim Martini on 1/4/24.
//

import SwiftUI

struct phoneLogbookDetailView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Lake Washington")
                    .font(.system(size: 36))
                Text("1430 Samples at 10 Hz")
                
                List {
                    Section{
                        Text("Item 1")
                        Text("Item 2")
                    }
                    
                    Section{
                        Text("Item 1")
                        Text("Item 2")
                        Text("Item 3")
                        Text("Item 4")
                        Text("Item 5")
                    }
                }
                
                Spacer()
                
                NavigationLink(destination: phoneLogbookExportDetailView()) {
                    Button("Export") {
                    
                    }
                    .padding()
                    .frame(maxWidth: .infinity, minHeight: 40)
                    .background(.gray)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                .padding()
                }
            }
        }
    }
}

#Preview {
    phoneLogbookDetailView()
}
