//
//  NotesView.swift
//  Notes
//
//  Created by Janus on 1/27/25.
//  Refactored to use async/await pattern
//

import SwiftUI

struct NotesView: View {
    @EnvironmentObject var noteViewModel: NotesViewModel
    @State private var showConfirmationDialogue: Bool = false
    @State private var selectedNote: Note?
    @State private var isCreatingNote = false
    @State private var isHeadToHome = false
    @State private var isLoading = true
    @State private var isRefreshing = false

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
                        // Create a blank note template
                        isCreatingNote = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title)
                            .foregroundColor(.noteAlmond)
                    }
                    
                    // Add refresh button
                    Spacer()
                    
                    Button {
                        refreshNotes()
                    } label: {
                        Image(systemName: isRefreshing ? "arrow.triangle.2.circlepath" : "arrow.clockwise")
                            .font(.title)
                            .foregroundColor(.noteAlmond)
                            .rotationEffect(isRefreshing ? .degrees(360) : .degrees(0))
                            .animation(isRefreshing ? .linear(duration: 1).repeatForever(autoreverses: false) : .default, value: isRefreshing)
                    }
                    .disabled(isRefreshing)
                    
                    Spacer()
                }
                .padding()
                
                if isLoading {
                    Spacer()
                    ProgressView("Loading notes...")
                        .tint(.noteAlmond)
                        .foregroundColor(.noteAlmond)
                    Spacer()
                } else if noteViewModel.notes.isEmpty {
                    Spacer()
                    VStack {
                        Text("No notes yet")
                            .font(.title2)
                            .foregroundColor(.noteAlmond)
                        
                        Text("Tap + to create your first note")
                            .foregroundColor(.noteAlmond)
                            .padding(.top, 5)
                    }
                    Spacer()
                } else {
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
                            deleteNote(at: indexSet)
                        }
                        .listRowBackground(Color.clear)
                    }
                    .scrollContentBackground(.hidden) // Hide default list background
                    .background(Color(.noteAlmond))
                    .refreshable {
                        await refreshNotes()
                    }
                }
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
        .task {
            await loadNotes()
        }
        .fullScreenCover(isPresented: $isHeadToHome) {
            ContentView()
                .environmentObject(noteViewModel)
        }
    }

    private func loadNotes() async {
        isLoading = true
        await noteViewModel.getNotes()
        isLoading = false
    }
    
    private func refreshNotes() {
        isRefreshing = true
        
        Task {
            await noteViewModel.getNotes()
            
            // Add slight delay to make the refresh animation visible
            try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
            
            await MainActor.run {
                isRefreshing = false
            }
        }
    }

    private func deleteNote(at offsets: IndexSet) {
        for index in offsets {
            let noteToDelete = noteViewModel.notes[index]
            noteViewModel.deleteNote(noteToDelete)
        }
    }

    private func createNote() async {
        let newTitle = "New Note"
        let newContent = ""
        
        await noteViewModel.postNotes(title: newTitle, content: newContent)
        await noteViewModel.getNotes()
    }
}

#Preview {
    NotesView()
        .environmentObject(NotesViewModel())
}
