//
//  EditNotesView.swift
//  Notes
//
//  Created by Janus on 1/27/25.
//

import SwiftUI

struct EditNotesView: View {
    
    @EnvironmentObject var vm: NotesViewModel
    
    @State var note: Note?
    @State private var title: String = ""
    @State private var content: String = ""
    
    @FocusState private var contentEditorInFocus: Bool

    var body: some View {
        
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                                
                TextField("Title", text: $title, axis: .vertical)
                    .font(.title.bold())
                    .submitLabel(.next)
                    .onChange(of: title, {
                        guard let newValueLastChar = title.last else { return }
                        if newValueLastChar == "\n" {
                            title.removeLast()
                            contentEditorInFocus = true
                        }
                    })
                    
                TextEditorView(string: $content)
                    .scrollDisabled(true)
                    .font(.title3)
                .focused($contentEditorInFocus)
                
    
            }
            .padding(10)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .keyboard) {
                HStack {
                    Spacer()
                    Button {
                        self.hideKeyboard()
                        vm.postNotes(title: title, content: content)
                    } label: {
                        Text("Done")
                            .bold()
                            .font(.title3)
                            .foregroundStyle(.black)
                    }
                }
            }
        }
        .onAppear {
            if let note = note {
                self.title = note.title ?? ""
                self.content = note.content ?? ""
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.contentEditorInFocus = true
                }
            }
        }
    }
    
}
