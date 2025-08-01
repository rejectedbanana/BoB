//
//  FilenameEditor.swift
//  BoB
//
//  Created by Kim Martini on 8/1/25.
//

import SwiftUI

struct FilenameEditor: View {
    @Binding var isEditing: Bool
    @Binding var filename: String
    let onSave: (String) -> Void
    
    @State private var localText: String = ""
    @FocusState private var isFocused: Bool
    
    var body: some View {
        LazyHStack {
            TextField("Tap done to save new filename", text: $localText)
                .focused($isFocused)
                .onSubmit {
                    onSave(localText)
                    isEditing = false
                }
                .submitLabel(.done)
            
            Spacer()
            
            Button("Cancel") {
                localText = filename // Reset
                isEditing = false
            }
            .foregroundStyle(.blue)
        }
        .onAppear {
            localText = filename
            isFocused = true
        }
    }
}

//#Preview {
//    FilenameEditor()
//}
