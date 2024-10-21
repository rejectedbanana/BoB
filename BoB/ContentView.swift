//
//  ContentView.swift
//  BoB
//
//  Created by Kim Martini on 10/19/23.
//

import SwiftUI
import CoreData
import WatchConnectivity

struct ContentView: View {
    // Get a reference to the managed object context from the environment
    @Environment(\.managedObjectContext) var moc
    // Fetch data from Core Data
    @FetchRequest(sortDescriptors: [SortDescriptor(\.startDatetime, order: .reverse)]) var logBookRecords: FetchedResults<SampleSet>
    @Environment(\.dismiss) var dismiss
    
    // Cloudkit sync trigger
    @State private var isRefreshing = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                List {
                    ForEach(logBookRecords) { logBookRecord in
                        NavigationLink {
                            LogbookDetail(entry: logBookRecord)
                        } label: {
                            ListRow(entry: logBookRecord)
                        }
                    }
                    .onDelete(perform: delete)
                }
                .refreshable {
                    await refreshDataFromCloud()
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                    }
                    
                }
                .navigationTitle("Logbook")
            }
        }
    }
    
    // function to delete Core Data Records
    func delete(at offsets: IndexSet) {
        for offset in offsets {
            let entry = logBookRecords[offset]
            moc.delete(entry)
        }
        do {
            try moc.save()
        } catch {
            print("Failed to delete log entry: \(error)")
        }
    }
    
    // function to refresh Core Data
    private func refreshDataFromCloud() async {
        // Set refreshing state
        isRefreshing = true
    
        // Action to refresh data
        debugPrint( "Refreshing data from CloudKit...")
        // reloading doesn't work, but it looks like it's doing something!
//        @FetchRequest(sortDescriptors: [SortDescriptor(\.startDatetime, order: .reverse)]) var logBookRecords: FetchedResults<SampleSet>
        
        // wait 1 second before reverting view
        try? await Task.sleep(for: .seconds(2))
        
        // End refreshing state
        isRefreshing = false
    }
    
}

#Preview {
    ContentView()
}
