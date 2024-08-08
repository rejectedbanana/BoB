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
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [SortDescriptor(\.startDatetime, order: .reverse)]) var logBookRecords: FetchedResults<SampleSet>
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var phoneSessionManager = PhoneSessionManager()
    
    @State var messageString: String? = ""
    @State var messageDictionary: [String: Any] = [:]
    
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
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                    }
                }
                
                VStack {
                    Spacer()
                    Button {
                        self.messageDictionary = phoneSessionManager.getDictionaryFromWatch()
                        for (key, value) in messageDictionary {
                            print("phoneDictionary[\(key)] = \(value) (\(type(of: value)))")
                        }
                        let newEntry = SampleSet(context: moc)
                        newEntry.id = UUID()
                        newEntry.name = messageDictionary["name"] as? String
                        newEntry.startDatetime = messageDictionary["startDatetime"] as? Date
                        newEntry.stopDatetime = messageDictionary["stopDatetime"] as? Date
                        newEntry.startLatitude = messageDictionary["startLatitude"] as? Double ?? 0.0
                        newEntry.startLongitude = messageDictionary["startLongitude"] as? Double ?? 0.0
                        newEntry.stopLatitude = messageDictionary["stopLatitude"] as? Double ?? 0.0
                        newEntry.stopLongitude = messageDictionary["stopLongitude"] as? Double ?? 0.0
                        newEntry.sampleCSV = messageDictionary["sampleCSV"] as? String
                        
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
                            .background(Color.purple)
                            .clipShape(Circle())
                            .foregroundColor(.white)
                    }
                    .padding()
                    .shadow(radius: 2)
                }
            }
        }
    }
    
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
}

#Preview {
    ContentView()
}
