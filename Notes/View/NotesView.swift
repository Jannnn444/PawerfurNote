//
//  SwiftUIView.swift
//  Notes
//
//  Created by Janus on 1/27/25.
//

import SwiftUI

struct NotesView: View {
    @ObservedObject var noteViewModel = NotesViewModel()
    @State var showConfirmationDialogue: Bool = false
    @State private var selectedNote: Note?
    @State private var isCreatingNote = false

    var body: some View {
        NavigationView {
            ZStack {
                Color(.noteBlack).edgesIgnoringSafeArea(.all)
                
                VStack {
                    HStack {
                        Text("♡♥︎ Notes ♥︎♡")
                            .fontDesign(.rounded)
                            .foregroundStyle(.noteAlmond)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                            .padding(.top)
                            .padding(.bottom, -5)
                        Spacer()
                        Button {
                            isCreatingNote = true
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .font(.title)
                                .foregroundColor(.noteAlmond)
                        }
                        .padding(.trailing)
                    }
                    
                    List {
                        ForEach(noteViewModel.notes) { note in
                            Button {
                                selectedNote = note
                            } label: {
                                ListCellView(note: note)
                                    .padding()
                            }
                        }
                        .onDelete { indexSet in
                            indexSet.forEach { index in
                                let noteToDelete = noteViewModel.notes[index]
                                noteViewModel.deleteNote(noteToDelete) // Delete only this note
                            }
                        }
                        .listRowBackground(Color.clear)
//                        .listStyle(PlainListStyle())
                    }
                    .scrollContentBackground(.hidden) // Hide default list background
                    .background(Color(.noteBlack))
                }
                .padding(.top, 30)
                .sheet(item: $selectedNote) { note in
                    EditNotesView(vm: noteViewModel, note: note)
                }
                .sheet(isPresented: $isCreatingNote) {
                    EditNotesView(vm: noteViewModel, note: Note(id: "", title: "Title", content: "Content", favorite: false, created_at: "", updated_at: ""))
                }
            }
        }
        .ignoresSafeArea()
        .background(.black)
        .onAppear {
            noteViewModel.getNotes()
        }
    }

    private func deleteNote(at offsets: IndexSet) {
        for index in offsets {
            let noteToDelete = noteViewModel.notes[index]
            noteViewModel.deleteNote(noteToDelete)
        }
    }

    private func createNote() {
        let newTitle = "New Note"
        let newContent = ""
        noteViewModel.postNotes(title: newTitle, content: newContent)
        noteViewModel.getNotes()
    }
}

#Preview {
    NotesView()
}
