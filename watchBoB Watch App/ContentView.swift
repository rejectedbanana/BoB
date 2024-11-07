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
            VStack {
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
                
                List {
                    // Sampling Button
                    NavigationLink(destination: LogDataView() ) {
                        HStack {
                            Text("Start Sampling")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .font(.headline)
                            Image(systemName: "waveform")
                        }
                        .padding(.top, 10)
                        .padding(.bottom, 80)
                    }
                    .listItemTint(.fandango)
                        
                    // Review Data
                    NavigationLink(destination: LogbookView() ) {
                        HStack {
                            Text("Logbook")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .font(.headline)
                            Image(systemName: "list.clipboard")
                        }
                        .padding(.top, 10)
                        .padding(.bottom, 80)
                    }
                    .listItemTint(.lightRed)
                }
                .listStyle(CarouselListStyle())
            }
        }
        .navigationTitle("BoB")
    }
}

#Preview {
    ContentView()
}

