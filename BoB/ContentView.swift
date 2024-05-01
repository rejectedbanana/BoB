//
//  ContentView.swift
//  BoB
//
//  Created by Kim Martini on 10/19/23.
//

import SwiftUI

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
}

#Preview {
    ContentView()
}
