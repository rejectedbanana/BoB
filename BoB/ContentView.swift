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
    
    // create an instance of the watch connection class
    @ObservedObject var phoneSessionManager = PhoneSessionManager()
    
    @State var messageString: String? = ""
    @State var messageDictionary: [String: Any] = [:]
    
    var body: some View {
        NavigationStack {
            ZStack {
                List {
                    ForEach(logBookRecords) {logBookRecord in
                        NavigationLink {
                            LogbookDetail(entry: logBookRecord)
                        } label: {
                            ListRow(entry: logBookRecord)
                        }
                    }
                    .onDelete(perform: deleteSampleSet)
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                    }
                }
                
                VStack {
                    Spacer()
                    // Sync data with phone
                    Button {
                        // GET DATA AS A MESSAGE
//                        self.messageString = phoneSessionManager.getMessageFromWatch()
                        
                        // GET DATA AS A DICTIONARY
                        self.messageDictionary = phoneSessionManager.getDictionaryFromWatch()
                        // print out the data for debugging
                        for (key, value) in messageDictionary {
                            print("phoneDictionary[\(key)] = \(value) (\(type(of: value)))")
                        }
                        // write the entry to Core Data
                        let newEntry = SampleSet(context: moc)
                        newEntry.id = UUID()
                        newEntry.name = messageDictionary["name"] as? String
                        newEntry.startDatetime = messageDictionary["startDatetime"] as? Date
                        newEntry.stopDatetime = messageDictionary["stopDatetime"] as? Date
                        if let startLat = messageDictionary["startLatitude"] as? Double {
                            newEntry.startLatitude = startLat
                        }
                        if let startLon = messageDictionary["startLongitude"] as? Double {
                            newEntry.startLongitude = startLon
                        }
                        if let stopLat = messageDictionary["stopLatitude"] as? Double {
                            newEntry.stopLatitude = stopLat
                        }
                        if let stopLon = messageDictionary["stopLongitude"] as? Double {
                            newEntry.stopLongitude = stopLon
                        }
                        newEntry.sampleCSV = messageDictionary["sampleCSV"] as? String
                        
//                        // GET ENCODED DATA (DOESN'T WORK)
//                        self.messageString = phoneSessionManager.getMessageFromWatch()

                        
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
