//
//  ContentView.swift
//  watchBoB Watch App
//
//  Created by Kim Martini on 10/19/23.
//

import SwiftUI
import WatchConnectivity

struct ContentView: View {
    // Get a reference to the managed object context from the environment. 
    @Environment(\.managedObjectContext) var moc
    
    var body: some View {
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
                
            }
        }
        .navigationTitle("BoB")
    }
}

#Preview {
    ContentView()
}

