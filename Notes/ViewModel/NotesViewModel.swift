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
    @Published var showPleaseLogin = true
    @Published var isLogin = false
    @Published var isCreated = false
    
    init() {
        getNotes() // it runs first when it initialize itself
    }
    
    func login(email: String, password: String) {
        let url = "/api/member/signin"
        print("✅ Fetching login @url: \(url)...")
        
        let authenticatedAccount = SignInPayload(email: email, password: password)
        
        // Ensure JSON encoding is correct
        guard let jsonData = try? JSONEncoder().encode(authenticatedAccount) else {
            print("❌ Failed to encode login JSON")
            return
        }
        print("✅ Encoded JSON: \(String(data: jsonData, encoding: .utf8) ?? "nil")")
        
        // Call NetworkManager to send the request
        NetworkManager.shared.postRequest(url: url, payload: authenticatedAccount) { (result: Result<SignInResponse, Error>) in
            
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    print("✅ Success Sign-in message: \(response.result), status: \(response.statusCode)")
                    self.showPleaseLogin = false
                    self.isLogin = true
                   
                case .failure(let error):
                    print("⚠️ Error Sign-in occurred: \(error.localizedDescription)")
                    self.handleError(error)
                    self.showPleaseLogin = true
                }
            }
        }
    }
    
    func signup(name: String, email: String, password: String, phone: String) {
        let url = "/api/member/signup"
        print("✅ Fetching sign up @url: \(url)")
        
        let newCreateAccount = SignUpPayload(name: name, email: email, password: password, phone: phone)
        
        guard let jsonData = try? JSONEncoder().encode(newCreateAccount) else {
            print("Failed to encode signup JSON")
            return
        }
        print("✅ Encoded JSON: \(String(data: jsonData, encoding: .utf8) ?? "nil")")
        
        // Network manager to send the request
        NetworkManager.shared.postRequest(url: url, payload: newCreateAccount) { (result: Result<SignUpResponse, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    print("✅ Success Sign-up messsage: \(response.result), status code: \(response.statusCode), result: \(response.result)")
                    // Here sets for we need to secure
                    self.isCreated = true
                    
                case .failure(let error):
                    print("⚠️ Error sign-up occured: \(error.localizedDescription)")
                    self.handleError(error)
                    self.isCreated = false
                }
            }
        }
    }

    func getNotes() {
        let url = "/api/notes"
        print("✅ Fetching note @url: \(url)...")
        
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
                    // Fetch the updated list of notes After Sucessful Creation!
                    self.getNotes()
                case .failure(let error):
                    print("⚠️ Error occurred: \(error.localizedDescription)")
                    self.handleError(error)
                }
            }
        }
    }
    
    func deleteNote(_ note: Note) {
        print("🗑 Deleting note with ID: \(note.id) (No API call)")
        
        DispatchQueue.main.async {
            self.notes.removeAll { $0.id == note.id } // Remove note by id from note array
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

