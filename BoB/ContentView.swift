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
                if logBookRecords.isEmpty {
                    VStack {
                        Image(systemName: "book.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 32, height: 32)
                            .foregroundColor(.gray)
                            .padding()
                        
                        Text("No Log Entries")
                            .font(.headline)
                            .foregroundColor(.gray)
                        
                        Text("Start a new logbook entry or sync data from your watch.")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        
                        Spacer()
                    }
                } else {
                    List {
                        ForEach(logBookRecords) { logBookRecord in
                            NavigationLink {
                                LogbookDetail(entry: logBookRecord, jsonParserService: DefaultJSONParserService())
                            } label: {
                                ListRow(entry: logBookRecord)
                            }
                        }
                        .onDelete(perform: delete)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
//#if DEBUG
//                ToolbarItem(placement: .navigationBarLeading) {
//                    Button("Generate Mock Data") {
//                        generateMockData()
//                    }
//                }
//#endif
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
            debugPrint("Failed to delete log entry: \(error)")
        }
    }

}

#Preview {
    ContentView()
}
