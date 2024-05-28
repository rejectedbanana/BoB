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
    // Get a reference to the managed object context from the environment.
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [SortDescriptor(\.startDatetime, order: .reverse)]) var logBookRecords: FetchedResults<SampleSet>
    @Environment(\.dismiss) var dismiss
    
    @StateObject var coreDataController = CoreDataController()
    
    // create an instance of the watch connection class
    @ObservedObject var phoneSessionManager = PhoneSessionManager()
    
    @State var message: String? = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                List {
                    ForEach(logBookRecords) {logBookRecord in
                        NavigationLink {
                            LogbookDetail()
                        } label: {
                            ListRow(record: logBookRecord)
                        }
                    }
                    .onDelete(perform: deleteSampleSet)
                }
                .onAppear {
                    // You can perform operations on your Core Data stack here
                    // For example, enable NSPersistentHistoryTrackingKey
                    coreDataController.enableHistoryTracking()
                }
                //                .navigationTitle("Logbook")
                //                .toolbar {
                //                    Button("Edit") {
                //
                //                    }
                //                }
                
                VStack {
                    Spacer()
                    
                    Button {
                        // insert sync action here
                        self.message = phoneSessionManager.getMessageFromWatch()
                        
                        // now write the entry to Core Data
                        let newEntry = SampleSet(context: moc)
                        newEntry.id = UUID()
                        newEntry.startDatetime = Date.now
                        newEntry.stopDatetime = Date.now
                        newEntry.name = self.message
                        newEntry.startLatitude = 1.1
                        newEntry.startLongitude = 1.2
                        newEntry.stopLatitude = 1.3
                        newEntry.stopLongitude = 1.4
                        // save to Core Data
                        do {
                            try moc.save()
                            print("Entry saved!")
                        } catch {
                            print("Failed to save log entry: \(error)")
                        }
                        dismiss()
                        
                    } label: {
                        Image(systemName: "arrow.down.applewatch")
                            .font(.largeTitle)
                            .frame(width: 80, height: 80)
                            .background(.fandango)
                            .clipShape(Circle())
                            .foregroundColor(.white)
                    }
                    .padding()
                    .shadow(radius: 2)
                    
                    if (self.message == "") {
                        Text("No message received from IPhone")
                    } else {
                        Text("Message received: " + (self.message ?? "optional not unwrapped"))
                    }

                }
            }
        }
    }
    
    // Make a function to delete log entries
    func deleteSampleSet(at offsets: IndexSet) {
        for offset in offsets {
            let entry = logBookRecords[offset]
            moc.delete(entry)
        }
    }
}

#Preview {
    ContentView()
}
