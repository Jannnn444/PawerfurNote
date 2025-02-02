//
//  SwiftUIView.swift
//  Notes
//
//  Created by Janus on 1/27/25.
//

import SwiftUI
import CoreData

struct NotesView: View {

    @EnvironmentObject var vm: NotesViewModel
    @State var showConfirmationDialogue: Bool = false
    @State var showOverlay: Bool = false
    @State private var searchText = ""
    @State private var selectedNote: NoteEntity?

    var groupedByDate: [Date: [NoteEntity]] {
        let calendar = Calendar.current
        return Dictionary(grouping: vm.notes) { noteEntity in
            let dateComponents = calendar.dateComponents([.year, .month, .day], from: noteEntity.timestamp!)
            return calendar.date(from: dateComponents) ?? Date()
        }
    }
    
    var headers: [Date] {
        groupedByDate.keys.sorted(by: { $0 > $1 })
    }
    
    var body: some View {
        ZStack {
            Color(.noteBlack)
                .edgesIgnoringSafeArea(.all)
      
               
                VStack {
                    HStack {
                        Text("Notes")
                            .fontDesign(.rounded)
                            .foregroundStyle(.noteSecondary)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding(.leading)
                            .padding(.top)
                            .padding(.bottom, -5)
                        Spacer()
                        
                        Button {
                            createNewNote()
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .font(.title)
                                .foregroundColor(.primary)
                        }
                        .padding()
                    }
                    
                    List {
                        ForEach(headers, id: \.self) { header in
                            Section(header: Text(header, style: .date).font(.headline)) {
                                ForEach(groupedByDate[header]!) { note in
                                    Button {
                                        selectedNote = note
                                    } label: {
                                        ListCellView(note: note)
                                    }
                                }
                                .onDelete { indexSet in
                                    deleteNote(in: header, at: indexSet)
                                }
                            }
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .searchable(text: $searchText)
                    .onChange(of: searchText) {
                        vm.searchNotes(with: searchText)
                    }
                }
                .sheet(item: $selectedNote) { note in
                    EditNotesView(note: note)
                }
            
           
        }
    }
    
    // MARK: Core Data Operations
    
    private func createNewNote() {
        selectedNote = nil
        selectedNote = vm.createNote()
    }

    private func deleteNote(in header: Date, at offsets: IndexSet) {
        offsets.forEach { index in
            if let noteToDelete = groupedByDate[header]?[index] {
                if noteToDelete == selectedNote {
                    selectedNote = nil
                }
                vm.deleteNote(noteToDelete)
            }
        }
    }
}

#Preview {
    NotesView()
}
