//
//  LogbookView.swift
//  watchBoB Watch App
//
//  Created by Kim Martini on 10/20/23.
//

import SwiftUI

struct LogbookView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var logBookEntries: FetchedResults<LogBookRecord>
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(logBookEntries) {logBookEntry in
                    NavigationLink {
                        LogbookDetail(entry: logBookEntry)
                    } label: {
//                        Text(logBookEntry.name ?? "Unknown Name")
                        LogbookRow(entry: logBookEntry)
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
            let entry = logBookEntries[offset]
            moc.delete(entry)
        }
    }
}

#Preview {
    LogbookView()
}
