//
//  NotesViewModel.swift
//  Notes
//
//  Created by Janus on 1/28/25.
//
//
//  NotesViewModel.swift
//  Notes
//
//  Created by Janus on 1/28/25.
//  Refactored to use async/await pattern
//

import Foundation
import CoreData

@MainActor // Ensures all properties are updated on main thread
class NotesViewModel: ObservableObject {
    
    @Published var notes: [Note] = []
    @Published var isDataLoaded = false
    @Published var errorMessages: String? = nil
    @Published var note: Note?
    @Published var showPleaseLogin = true
    @Published var isLogin = false
    @Published var isCreated = false
    
    init() {
        Task {
            await getNotes() // Load notes when ViewModel initializes
        }
    }
    
    func login(email: String, password: String) async {
        let url = "/api/member/signin"
        print("✅ Fetching login @url: \(url)...")
        
        let authenticatedAccount = SignInPayload(email: email, password: password)
        
        do {
            let response = try await NetworkManager.shared.postRequest(
                url: url,
                payload: authenticatedAccount
            ) as SignInResponse
            
            print("✅ Success Sign-in message: \(response.result), status: \(response.statusCode)")
            self.showPleaseLogin = false
            self.isLogin = true
            
        } catch {
            print("⚠️ Error Sign-in occurred: \(error.localizedDescription)")
            handleError(error)
            self.showPleaseLogin = true
        }
    }
    
    func signup(name: String, email: String, password: String, phone: String) async {
        let url = "/api/member/signup"
        print("✅ Fetching sign up @url: \(url)")
        
        let newCreateAccount = SignUpPayload(name: name, email: email, password: password, phone: phone)
        
        do {
            let response = try await NetworkManager.shared.postRequest(
                url: url,
                payload: newCreateAccount
            ) as SignUpResponse
            
            print("✅ Success Sign-up message: \(response.result), status code: \(response.statusCode), result: \(response.result)")
            self.isCreated = true
            
        } catch {
            print("⚠️ Error sign-up occurred: \(error.localizedDescription)")
            handleError(error)
            self.isCreated = false
        }
    }

    func getNotes() async {
        let url = "/api/notes"
        print("✅ Fetching note @url: \(url)...")
        
        do {
            let response = try await NetworkManager.shared.getRequest(url: url) as NoteResponse
            print("✅ Success @Receiving notes: \(response.result)")
            self.notes = response.result
            self.isDataLoaded = true
            
        } catch {
            print("⚠️ Error occurred while fetching notes")
            handleError(error)
        }
    }
    
    func postNotes(title: String, content: String) async {
        let url = "/api/notes"
        print("📩 Posting to post note with title: \(title) and content: \(content)")

        // Create note payload
        let newNote = NotePayloadForPost(title: title, content: content)

        do {
            let response = try await NetworkManager.shared.postRequest(
                url: url,
                payload: newNote
            ) as NotePostResponse
            
            print("✅ Success! @Message: \(response.message), status: \(response.statusCode)")
            // Fetch the updated list of notes after successful creation
            await getNotes()
            
        } catch {
            print("⚠️ Error occurred: \(error.localizedDescription)")
            handleError(error)
        }
    }
    
    func deleteNote(_ note: Note) {
        print("🗑 Deleting note with ID: \(note.id) (No API call)")
        // Remove note by id from note array
        self.notes.removeAll { $0.id == note.id }
    }
    
    // This would be implemented if needed
    func searchNotes(with searchText: String) {
        // await fetchNotes(with: searchText)
    }
    
    // This would be implemented if needed
    func addToFavorite() {
        // Implementation here
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
