//
//  ContentView.swift
//  BoB
//
//  Created by Kim Martini on 10/19/23.
//

import SwiftUI
//import WatchConnectivity

//class SessionDelegate: NSObject, WCSessionDelegate {
//    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
//        
//    }
//    
//    func sessionDidBecomeInactive(_ session: WCSession) {
//        
//    }
//    
//    func sessionDidDeactivate(_ session: WCSession) {
//        
//    }
//    
//    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
//        
//    }
//}

struct ContentView: View {
    @State private var metadata: [String: Any]?
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
                    //            .onAppear {
                    //                let sessionDelegate = SessionDelegate()
                    //                WCSession.default.delegate = sessionDelegate
                    //                WCSession.default.activate()
                    //            }
                    
                    VStack {
                        Spacer()
                        
                        Button {
                            // insert sync action here
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
    
//    private func sendMetadataToWatch() {
//        let metadata: [String: Any] = ["key1": "value1", "key2": "value2"]
//        WCSession.default.sendMessage(metadata, replyHandler: nil, errorHandler: nil)
//    }

}

#Preview {
    ContentView()
}
