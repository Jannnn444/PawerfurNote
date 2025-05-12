//
//  EditNotesView.swift
//  Notes
//
//  Created by Janus on 1/27/25.
//
//
//  EditNotesView.swift
//  Notes
//
//  Created by Janus on 1/27/25.
//  Refactored to use async/await pattern
//

import SwiftUI

struct EditNotesView: View {
    
    @ObservedObject var noteViewModel: NotesViewModel
    @State var note: Note?
    @State private var title: String = ""
    @State private var content: String = ""
    @State private var isSaving = false
    @FocusState private var contentEditorInFocus: Bool
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    TextField("Title", text: $title, axis: .vertical)
                        .font(.title.bold())
                        .submitLabel(.next)
                        .onChange(of: title) { _, newValue in
                            guard let newValueLastChar = newValue.last else { return }
                            if newValueLastChar == "\n" {
                                title.removeLast()
                                contentEditorInFocus = true
                            }
                        }
                    
                    TextEditorView(string: $content)
                        .scrollDisabled(true)
                        .font(.system(size: 10))
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
                        saveNote()
                    } label: {
                        if isSaving {
                            ProgressView()
                                .tint(.noteDarktea)
                        } else {
                            Text("Done")
                                .bold()
                                .font(.title3)
                                .foregroundStyle(.noteDarktea)
                        }
                    }
                    .disabled(isSaving)
                }
                
                // ✅ Delete Button (only if note exists)
                if note != nil {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(role: .destructive) {
                            if let note = note {
                                noteViewModel.deleteNote(note) // Delete the note
                                dismiss() // Close the sheet
                            }
                        } label: {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                        }
                        .disabled(isSaving)
                    }
                }
            }
            .toolbarBackground(.hidden, for: .navigationBar)
            .onAppear {
                print("Note: \(String(describing: note))") // Debugging
                if let note = note {
                    self.title = note.title ?? ""
                    self.content = note.content ?? ""
                    
                    // Focus the content editor after a short delay
                    Task {
                        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
                        self.contentEditorInFocus = true
                    }
                }
            }
        }
    }
    
    private func saveNote() {
        // Hide keyboard first
        
        // Set saving state
        isSaving = true
        
        // Save the note using async/await
        Task {
            await noteViewModel.postNotes(title: title, content: content)
            
            // Refresh notes list after saving
            await noteViewModel.getNotes()
            
            // Update UI on main thread
            await MainActor.run {
                isSaving = false
                dismiss()
            }
        }
    }
}

