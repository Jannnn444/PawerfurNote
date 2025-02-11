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
                    print("✅ Success @Receving notes: \(notes.result)")
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
        print("📩 Posting to post note with title: \(title) and content: \(content)")

        // Create JSON payload
        let newNote = NotePayloadForPost(title: title, content: content)

        // Ensure JSON encoding is correct
        guard let jsonData = try? JSONEncoder().encode(newNote) else {
            print("❌ Failed to encode JSON")
            return
        }

        print("✅ Encoded JSON: \(String(data: jsonData, encoding: .utf8) ?? "nil")")

        // Call NetworkManager to send the request
        NetworkManager.shared.postRequest(url: url, payload: newNote) { (result: Result<NotePostResponse, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    print("✅ Success! @Message: \(response.message), status: \(response.statusCode)")
                case .failure(let error):
                    print("⚠️ Error occurred: \(error.localizedDescription)")
                    self.handleError(error)
                }
            }
        }
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

