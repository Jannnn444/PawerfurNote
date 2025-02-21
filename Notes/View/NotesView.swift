//
//  SwiftUIView.swift
//  Notes
//
//  Created by Janus on 1/27/25.
//

import SwiftUI
import CoreData

struct NotesView: View {

    @StateObject var noteViewModel = NotesViewModel()
    @State var showConfirmationDialogue: Bool = false
    @State var showOverlay: Bool = false
    @State private var searchText = ""
    @State private var selectedNote: Note?
    @State private var isCreatingNote = false
    
    var body: some View {
        ScrollView {
            ZStack {
                Color(.noteBlack)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    HStack {
                        Text("Notes")
                            .fontDesign(.rounded)
                            .foregroundStyle(.noteAlmond)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding(.leading)
                            .padding(.top)
                            .padding(.bottom, -5)
                        Spacer()
                        Text("!")
                            .fontDesign(.rounded)
                            .foregroundStyle(.noteAlmond)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding(.leading)
                            .padding(.top)
                            .padding(.bottom, -5)
                        
                        Button {
                            createNote()
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .font(.title)
                                .foregroundColor(.noteAlmond)
                        }
                        .padding()
                    }
                    
                    ForEach(noteViewModel.notes) { note in
                        Button {
                            selectedNote = note
                        } label: {
                            ListCellView(note: note)
                                .padding()
                        }
                    }
                } //: VSTACK
                .padding()
                .padding(.top, 30)
                .sheet(item: $selectedNote) { note in
                    EditNotesView(note: note)
                }
            }
        }.ignoresSafeArea()
         .background(.black)
         .onAppear() {
//             noteViewModel.postNotes(title: "Meow", content: "Hit!!!")
//             noteViewModel.postNotes(title: "Hi baby 20250212", content: "Today gonna do the button :)")
             noteViewModel.getNotes()
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
