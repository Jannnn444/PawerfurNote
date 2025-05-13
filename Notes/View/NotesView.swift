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
    @State private var isHeadToHome = false

    var body: some View {
       
            ZStack {
                Color(.noteMilktea).edgesIgnoringSafeArea(.all)
                
                VStack {
                    HStack {
                        Text("♡♥︎ Notes ♥︎♡")
                            .fontDesign(.rounded)
                            .foregroundStyle(.noteAlmond)
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                        Spacer()
                        Button {
                            isHeadToHome = true
                        } label: {
                            Image(systemName: "house")
                                .font(.title)
                                .foregroundColor(.noteAlmond)
                        }
            
                        Spacer()
                        
                        Button {
                            isCreatingNote = true
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .font(.title)
                                .foregroundColor(.noteAlmond)
                        }
                        Spacer()
                    }.padding()
                    
                    List {
                        ForEach(noteViewModel.notes) { note in
                            Button {
                                selectedNote = note
                            } label: {
                                ListCellView(note: note)
                                    .padding()
                            }
                            .listRowSeparator(.hidden)
                        }
                        .onDelete { indexSet in
                            indexSet.forEach { index in
                                let noteToDelete = noteViewModel.notes[index]
//                    noteViewModel.deleteNote(noteToDelete) // Delete only this note
                                
                                Task {
                                    do {
                                        await noteViewModel.deleteNote(noteToDelete)
                                    }
                                }
                            }
                        }
                        .listRowBackground(Color.clear)
                    }
                    .scrollContentBackground(.hidden) // Hide default list background
                    .background(Color(.noteAlmond))
                }
                .padding(.top, 30)
                .sheet(item: $selectedNote) { note in
                    EditNotesView(noteViewModel: noteViewModel, note: note)
                }
                .sheet(isPresented: $isCreatingNote) {
                    EditNotesView(noteViewModel: noteViewModel, note: Note(id: "", title: "Title", content: "Content", favorite: false, created_at: "", updated_at: ""))
                }
            }

        .ignoresSafeArea()
        .background(.noteAlmond)
        .onAppear {
//            noteViewModel.getNotes()
            Task {
                do {
                    await noteViewModel.getNotes()
                }
            }
        }
        .fullScreenCover(isPresented: $isHeadToHome) {
            ContentView()
        }
    }

    private func deleteNote(at offsets: IndexSet) {
        for index in offsets {
            let noteToDelete = noteViewModel.notes[index]
//            noteViewModel.deleteNote(noteToDelete)
            
            Task {
                do {
                    await noteViewModel.deleteNote(noteToDelete)
                }
            }
        }
    }

    private func createNote() {
        let newTitle = "New Note"
        let newContent = ""
        
        task {
            do {
                await noteViewModel.postNotes(title: newTitle, content: newContent)
                await noteViewModel.getNotes()
            }
        }
    }
}

#Preview {
    NotesView()
}
