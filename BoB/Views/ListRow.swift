//
//  ListRow.swift
//  BoB
//
//  Created by Kim Martini on 5/10/24.
//

import SwiftUI

struct ListRow: View {
    let entry: SampleSet
    
    // time stamp formatter
    let timeStampFormatter = TimeStampManager()
    
    // get the size of the text to scale the icon
    @State var labelHeight = CGFloat.zero
    
    var body: some View {
        HStack {
            Image(systemName: "mappin.and.ellipse")
                .resizable()
                .foregroundColor(.fandango)
                .aspectRatio(contentMode: .fit)
                .frame(maxHeight: labelHeight*0.8)
                .padding([.trailing], 5)
            
            VStack(alignment: .leading) {
                Text(entry.fileName ?? "unknown")
                    .font(.headline)
                Text(timeStampFormatter.viewFormat( entry.startDatetime ?? Date(timeIntervalSince1970: 0) )) // change this unwrap to something else when I figure out how
                    .foregroundStyle(.silver)
                    .font(.footnote)
                Text(String(format: "%0.3f", entry.startLatitude)+" N, "+String(format: "%0.3f", entry.startLongitude)+" E")
                    .foregroundStyle(.silver)
                    .font(.footnote)
            }
        }
        .overlay(
            GeometryReader(content: { geometry in
                Color.clear
                    .onAppear(perform: {
                        self.labelHeight = geometry.frame(in: .local).size.height
                    })
            })
        )
    }
}

//#Preview {
//    ListRow()
//}
