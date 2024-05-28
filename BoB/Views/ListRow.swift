//
//  ListRow.swift
//  BoB
//
//  Created by Kim Martini on 5/10/24.
//

import SwiftUI

struct ListRow: View {
    let record: SampleSet
    
    var body: some View {
        VStack{
            Text(record.name ?? "Unknown Record")
//            Text(dateFormatter( record.startDatetime ?? Date(timeIntervalSince1970: 0) )) 
        }
    }
}

//#Preview {
//    ListRow()
//}
