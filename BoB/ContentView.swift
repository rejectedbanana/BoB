//
//  ContentView.swift
//  BoB
//
//  Created by Kim Martini on 10/19/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            // List of Logbook entries. Imported BoBDataList.json for building UI. Will replace with CoreData Metadata
            List(entries) {entry in
                NavigationLink {
                    phoneLogbookDetail()
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
            
            Button("Sync with Watch", systemImage: "arrow.left.arrow.right") {
                
            }
            .padding(.horizontal, 70)
            .frame(height: 50)
            .border(Color.black)
            .foregroundColor(.black)
        }
    }
}

#Preview {
    ContentView()
}
