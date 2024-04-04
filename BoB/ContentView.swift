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
            // List of Logbook entries. Imported BoBDataList.json for building UI. Will replace with CoreData Metadata
            List(entries) {entry in
                NavigationLink {
                    phoneLogbookDetailView()
                } label: {
                   phoneLogbookRow(entry: entry)
                }
            }
            .navigationTitle("Logbook")
            
            //MARK: - Buttons
            
            .toolbar {
                Button("Edit") {
                    
                }
            }
//            .onAppear {
//                let sessionDelegate = SessionDelegate()
//                WCSession.default.delegate = sessionDelegate
//                WCSession.default.activate()
//            }
            
            Button("Sync with Watch", systemImage: "arrow.left.arrow.right") {
                
            }
            .padding(.horizontal, 70)
            .frame(height: 50)
            .border(Color.black)
            .foregroundColor(.black)
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
