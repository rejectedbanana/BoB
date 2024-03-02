//
//  LogbookView.swift
//  watchBoB Watch App
//
//  Created by Kim Martini on 10/20/23.
//

import SwiftUI

struct LogbookView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [SortDescriptor(\.startDatetime, order: .reverse)]) var logBookRecords: FetchedResults<LogBookRecord>
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(logBookRecords) {logBookRecord in
                    NavigationLink {
                        LogbookDetail(record: logBookRecord)
                    } label: {
//                        Text(logBookRecord.name ?? "Unknown Name")
                        LogbookRow(record: logBookRecord)
                    }
                }
                .onDelete(perform: deleteBooks)
            }
        }
        .navigationTitle("Logbook")
    }
    
    // make a function to delete log entries
    func deleteBooks(at offsets: IndexSet) {
        for offset in offsets {
            let entry = logBookRecords[offset]
            moc.delete(entry)
        }
    }
}

#Preview {
    LogbookView()
}
