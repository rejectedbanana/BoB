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
    
    // create an instance of the watch connection class
    @ObservedObject var phoneSessionManager = PhoneSessionManager()
    
    @State var message = ""
    
    func getMessageFromWatch() {
        print("Getting message from watch...")
        // retrieve the message
        if let storedReceivedMessage = UserDefaults.standard.string(forKey: "message") {
            self.message = storedReceivedMessage.description
            print("Successfully retrieved message from watch")
        } else {
            self.message = ""
            print("Could not retrieve message from watch")
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // List of Logbook entries. Imported BoBDataList.json for building UI. Will replace with CoreData Metadata
                List(entries) {entry in
                    NavigationLink {
                        LogbookDetail()
                    } label: {
                        LogbookRow(entry: entry)
                    }
                }
                .navigationTitle("Logbook")
                .toolbar {
                    Button("Edit") {
                        
                    }
                }
                
                VStack {
                    Spacer()
                    
                    Button {
                        // insert sync action here
                        getMessageFromWatch()
                        
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
                        Text("Message received: " + message)
                    }

                }
            }
        }
    }
}

#Preview {
    ContentView()
}
