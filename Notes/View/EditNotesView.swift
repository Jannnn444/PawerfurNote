//
//  EditNotesView.swift
//  Notes
//
//  Created by Janus on 1/27/25.
//  Updated with async/await pattern
//

import SwiftUI

struct EditNotesView: View {
    
    @ObservedObject var noteViewModel: NotesViewModel
    @State var note: Note?
    @State private var title: String = ""
    @State private var content: String = ""
    @State private var isSubmitting = false
    @FocusState private var contentEditorInFocus: Bool
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    TextField("Title", text: $title, axis: .vertical)
                        .font(.title.bold())
                        .submitLabel(.next)
                        .onChange(of: title) {
                            guard let newValueLastChar = title.last else { return }
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
            .overlay {
                if isSubmitting {
                    ProgressView()
                        .scaleEffect(1.5)
                        .tint(.noteDarktea)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(.ultraThinMaterial)
                                .frame(width: 100, height: 100)
                        )
                }
            }
            .toolbar {
                // ✅ Done Button (always visible)
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        saveNote()
                    } label: {
                        Text("Done")
                            .bold()
                            .font(.title3)
                            .foregroundStyle(.noteDarktea)
                    }
                    .disabled(isSubmitting)
                }
                
                // ✅ Delete Button (only if note exists)
                if note != nil {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(role: .destructive) {
                            deleteNote()
                        } label: {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                        }
                        .disabled(isSubmitting)
                    }
                }
            }
            .toolbarBackground(.hidden, for: .navigationBar)
            .onAppear {
                print("Note: \(String(describing: note))") // Debugging
                if let note = note {
                    self.title = note.title ?? ""
                    self.content = note.content ?? ""
                    
                    // Focus on content with a slight delay for better UX
                    Task { @MainActor in
                        try? await Task.sleep(for: .milliseconds(100))
                        self.contentEditorInFocus = true
                    }
                }
            }
        }
    }
    
    // MARK: - Helper Functions
    
    private func saveNote() {
        self.hideKeyboard()
        isSubmitting = true
        
        Task { @MainActor in
            do {
                // Post the note with async/await
                await noteViewModel.postNotes(title: title, content: content)
                
                // Fetch updated notes list
                await noteViewModel.getNotes()
                
                isSubmitting = false
                dismiss()
            } catch {
                isSubmitting = false
                // Handle error if needed
                print("Error saving note: \(error.localizedDescription)")
            }
        }
    }
    
    private func deleteNote() {
        guard let note = note else { return }
        
        isSubmitting = true
        
        Task { @MainActor in
            do {
                // Delete the note with async/await
                await noteViewModel.deleteNote(note)
                
                isSubmitting = false
                dismiss()
            } catch {
                isSubmitting = false
                // Handle error if needed
                print("Error deleting note: \(error.localizedDescription)")
            }
        }
    }
}

