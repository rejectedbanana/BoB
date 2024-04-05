//
//  ContentView.swift
//  watchBoB Watch App
//
//  Created by Kim Martini on 10/19/23.
//

import SwiftUI
import WatchConnectivity

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    
    @StateObject var settings = SettingsManager()
    
    var body: some View {
        
        // MARK: - Navigation Flow
        
        NavigationView {
            ScrollView {
                
                // Header
                HStack {
                    HStack {
                        Image(systemName: "timer")
                        Image(systemName: "thermometer.and.liquid.waves")
                        Image(systemName: "water.waves.and.arrow.down")
                    }
                    .foregroundColor(.blue)
                    Text("BoB")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(.leading)
                   
                }
                
                // Sampling Button
                NavigationLink(destination: LogDataView() ) {
                    HStack {
                        Text("Start Sampling")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.headline)
                        Image(systemName: "waveform")
                    }
                    .padding(.bottom, 60)
                }
                .tint(.fandango)
                .buttonBorderShape(.roundedRectangle(radius: 10))
                .cornerRadius(10)
                .buttonStyle(.borderedProminent)
                .padding(.bottom, 20)
                .padding(.top, 10)
                
                // Review Data
                NavigationLink(destination: LogbookView() ) {
                    HStack {
                        Text("Logbook")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.headline)
                        Image(systemName: "list.clipboard")
                    }
                    .padding(.bottom, 60)
                }
                .tint(.lightRed)
                .buttonBorderShape(.roundedRectangle(radius: 10))
                .cornerRadius(10)
                .buttonStyle(.borderedProminent)
                .padding(.bottom, 20)
                
                
                // Sync coredata with phone
                Button {
                    // sync action here
//                    sendMetadataToPhone()
                } label: {
                    HStack {
                        Text("Sync with phone")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.headline)
                        Image(systemName: "iphone.and.arrow.forward")
                    }
                    .padding(.bottom, 60)
                }
                .tint(.silver)
                .opacity(0.8)
                .buttonBorderShape(.roundedRectangle(radius: 10))
                .buttonStyle(.borderedProminent)
                
            }
        }
        .navigationTitle("BoB")
        .environmentObject(settings)
    }
    
//    private func sendMetadataToPhone() {
//        guard WCSession.default.isReachable else {
//            print("Phone is not reachable")
//            return
//        }
//
//        let metadata: [String: Any] = ["key1": "value1", "key2": "value2"] // Replace with your metadata
//        WCSession.default.sendMessage(metadata, replyHandler: nil, errorHandler: nil)
//    }
}

#Preview {
    ContentView()
}
