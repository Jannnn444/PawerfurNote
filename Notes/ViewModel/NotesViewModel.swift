//
//  NotesViewModel.swift
//  Notes
//
//  Created by Janus on 1/28/25.
//

import Foundation
import CoreData

class NotesViewModel: ObservableObject {
    
    @Published var notes: [Note] = []
    @Published var isDataLoaded = false
    @Published var errorMessages: String? = nil
    @Published var note: Note?

    init() {
        getNotes() // it runs first when it initialize itself
    }

    func getNotes() {
        let url = "/api/notes"
        print("✅ Fetching note from url: \(url)...")
        
        NetworkManager.shared.getRequest(url: url) { (result: Result<NoteResponse, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let notes):
                    print("✅ Success. Receving notes: \(notes.result)")
                    self.notes = notes.result
                case .failure(let error):
                    print("⚠️ Error occurred: \(self.errorMessages ?? "Unknown error")")
                    self.handleError(error)
                }
            }
        }
    }
    
    func postNotes(title: String, content: String) {
        let url = "/api/notes"
        
        let dateFormatter = ISO8601DateFormatter()
        
        // The payload dictionary needs to be explicitly encoded as JSON before sending it in the network request.
        let newNote: [String: Any] = [
            "id": "UUID().uuidString",
            "title": title,
            "content": content,
            "favorite": false,  // Convert boolean to string if needed
            "created_at": "dateFormatter.string(from: Date())",
            "updated_at": "dateFormatter.string(from: Date())"
        ]

        guard let jsonData = try? JSONSerialization.data(withJSONObject: newNote, options: .prettyPrinted) else {
              print("⚠️ Failed to encode note data")
              return
          }

          // Print JSON before sending
          if let jsonString = String(data: jsonData, encoding: .utf8) {
              print("📩 JSON Payload: \(jsonString)")
          }
          
          print("✅ Posting note to url: \(url)...")
        
        NetworkManager.shared.postRequest(url: url, payload: jsonData) { (result: Result<NoteResponse, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    print("✅ Success. Posted note: \(response.result)")
//                    self.fetchNotes() // Refresh notes after posting
                case .failure(let error):
                    print("⚠️ Error occurred: \(error.localizedDescription)")
                    self.handleError(error)
                }
            }
        }
    }

    
//    func createNote() -> Note {
//        let newNote = Note(id: UUID(), title: <#T##String#>, content: <#T##String#>, favorite: <#T##Bool#>, created_at: <#T##String#>, updated_at: <#T##String#>)
//        newNote.id = UUID()
//        newNote.timestamp = Date()
//        saveContext()
//        fetchNotes() // Refresh notes list
////        getNotes()
//        
//        return newNote
//    }

    func deleteNote(_ note: NoteEntity) {
//        manager.container.viewContext.delete(note)
     
//        fetchNotes() // Refresh notes list
    }

    func updateNote(_ note: NoteEntity, title: String, content: String) {
        note.title = title
        note.content = content
   
//        fetchNotes() // Refresh notes list
    }
    
    func searchNotes(with searchText: String) {
//        fetchNotes(with: searchText)
    } 
    
    func addToFavorite() {
        
    }

   
    
    private func handleError(_ error: Error) {
           self.errorMessages = error.localizedDescription
           print("DEBUG: Error occurred: \(self.errorMessages ?? "Unknown error")")
           
           if let decodingError = error as? DecodingError {
               switch decodingError {
               case .dataCorrupted(let context):
                   print("DEBUG: Data corrupted: \(context.debugDescription)")
               case .keyNotFound(let key, let context):
                   print("DEBUG: Key '\(key)' not found: \(context.debugDescription)")
               case .typeMismatch(let type, let context):
                   print("DEBUG: Type mismatch for type '\(type)': \(context.debugDescription)")
               case .valueNotFound(let value, let context):
                   print("DEBUG: Value '\(value)' not found: \(context.debugDescription)")
               @unknown default:
                   print("DEBUG: Unknown decoding error")
               }
           } else {
               print("DEBUG: General error: \(error.localizedDescription)")
           }
       }
}

