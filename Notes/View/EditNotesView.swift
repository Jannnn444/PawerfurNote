//
//  EditNotesView.swift
//  Notes
//
//  Created by Janus on 1/27/25.
//

import SwiftUI

struct EditNotesView: View {
    
    @ObservedObject var vm: NotesViewModel
    @State var note: Note?
    @State private var title: String = ""
    @State private var content: String = ""
    @FocusState private var contentEditorInFocus: Bool
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
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
            .navigationTitle("Edit Note")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // ✅ Done Button (always visible)
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        self.hideKeyboard()
                        vm.postNotes(title: title, content: content)
                        dismiss()
                        vm.getNotes() // Fetch new updated!
                    } label: {
                        Text("Done")
                            .bold()
                            .font(.title3)
                            .foregroundStyle(.black)
                    }
                }
                
                // ✅ Delete Button (only if note exists)
                if note != nil {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(role: .destructive) {
                            vm.deleteNote(note!) // Delete the note
                            dismiss() // Close the sheet
//                          vm.getNotes() Refresh list
                        } label: {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                        }
                    }
                }
            }
            .onAppear {
                print("Note: \(String(describing: note))") // Debugging
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
}
