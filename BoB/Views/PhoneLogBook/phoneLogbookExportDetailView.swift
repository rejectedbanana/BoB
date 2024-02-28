//
//  phoneLogbookExportDetailView.swift
//  BoB
//
//  Created by Ramar Parham on 1/30/24.
//

import SwiftUI

struct phoneLogbookExportDetailView: View {
    
    @State var textFieldText: String = ""
    @State var selection: String = ""
    var body: some View {
        
        Text("Export")
            .font(.system(size: 40, weight: .bold))
        
        Spacer()
        
        TextField("Enter the filename", text: $textFieldText)
            .multilineTextAlignment(.center)
        
        Spacer()
        
        HStack {
            Text("Data Format")
            Text(selection)
        }
        Picker(
            selection: $selection,
            label: Text("Picker"),
            content: {
                Text(".CSV").tag(1)
            })
        .pickerStyle(.segmented)
        
        Spacer()
        
        Text("Output Summary")
        
        Spacer()
        
        ShareLink(Text("Export Records"), item: "String Item")
    }
}

#Preview {
    phoneLogbookExportDetailView()
}
