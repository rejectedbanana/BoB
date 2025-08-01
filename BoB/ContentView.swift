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
    
    // Info popup
    @AppStorage("showHelpAlert") private var showHelpAlert: Bool = false
    
    var body: some View {
        NavigationStack {
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

            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showHelpAlert = true
                    } label: {
                        Image(systemName: "exclamationmark.icloud.fill")
                            .foregroundColor(.blue)
                    }
                    .alert("Reasons why your data might not be syncing", isPresented: $showHelpAlert) {
                        Button("OK", role: .cancel) { }
                        Button("Help!") {
                            let subject = "Help! Bob is behaving badly 🙁"
                            let encodedSubject = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                            if let url = URL(string: "mailto:lifesaver@tiniscientific.com?subject=\(encodedSubject)") {
                                UIApplication.shared.open(url)
                            }
                        }
                    } message: {
                        Text("1) Internet connectivity is poor. Be patient. 2) iCloud storage is full. Check your settings. 3) Time series longer than 1 hour take a while to sync. We are working on that.")
                    }
                }
                
            }
            
            .navigationTitle("Logbook")
            .refreshable {
                await refreshDataFromCloud()
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
        // Action to refresh data
        debugPrint( "Refreshing data from CloudKit...")
        // reloading doesn't work, but it looks like it's doing something!
//        @FetchRequest(sortDescriptors: [SortDescriptor(\.startDatetime, order: .reverse)]) var logBookRecords: FetchedResults<SampleSet>
        
        // wait 1 second before reverting view
        try? await Task.sleep(for: .seconds(2))
        
    }
    
}

//#Preview {
//    ContentView()
//}
