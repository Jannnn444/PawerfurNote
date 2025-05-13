//
//  NotesViewModel.swift
//  Notes
//
//  Created by Janus on 1/28/25.
//  Updated with async/await pattern
//

import Foundation
import CoreData

@MainActor
class NotesViewModel: ObservableObject {
    
    @Published var notes: [Note] = []
    @Published var isDataLoaded = false
    @Published var errorMessages: String? = nil
    @Published var note: Note?
    @Published var showPleaseLogin = true
    @Published var isLogin = false
    @Published var isCreated = false
    
    init() {
        // Task is used to call async functions from non-async contexts
        Task {
            await getNotes() // it runs first when it initializes itself
        }
    }
    
    func login(email: String, password: String) async {
        let url = "/api/member/signin"
        print("✅ Fetching login @url: \(url)...")
        
        let authenticatedAccount = SignInPayload(email: email, password: password)
        
        do {
            // Call updated NetworkManager to send the request
            let response: SignInResponse = try await NetworkManager.shared.postData(
                to: url,
                payload: authenticatedAccount
            )
            
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
            // Network manager to send the request
            let response: SignUpResponse = try await NetworkManager.shared.postData(
                to: url,
                payload: newCreateAccount
            )
            
            print("✅ Success Sign-up message: \(response.result), status code: \(response.statusCode), result: \(response.result)")
            // Here sets for we need to secure
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
            let notesResponse: NoteResponse = try await NetworkManager.shared.fetchData(from: url)
            print("✅ Success @Receiving notes: \(notesResponse.result)")
            self.notes = notesResponse.result
            self.isDataLoaded = true
        } catch {
            print("⚠️ Error occurred: \(error.localizedDescription)")
            handleError(error)
        }
    }
    
    func postNotes(title: String, content: String) async {
        let url = "/api/notes"
        print("📩 Posting to post note with title: \(title) and content: \(content)")

        // Create JSON payload
        let newNote = NotePayloadForPost(title: title, content: content)

        do {
            // Call updated NetworkManager to send the request
            let response: NotePostResponse = try await NetworkManager.shared.postData(
                to: url,
                payload: newNote
            )
            
            print("✅ Success! @Message: \(response.message), status: \(response.statusCode)")
            // Fetch the updated list of notes After Successful Creation!
            await getNotes()
            
        } catch {
            print("⚠️ Error occurred: \(error.localizedDescription)")
            handleError(error)
        }
    }
    
    func deleteNote(_ note: Note) async {
        let url = "/api/notes/\(note.id)"
        print("🗑 Deleting note with ID: \(note.id)")
        
        do {
            // Using the new async/await NetworkManager
            _ = try await NetworkManager.shared.deleteData(at: url)
            print("✅ Successfully deleted note with ID: \(note.id)")
            
            // Remove note from local array
            self.notes.removeAll { $0.id == note.id }
            
        } catch {
            print("⚠️ Error deleting note: \(error.localizedDescription)")
            handleError(error)
            
            // You might want to keep this fallback behavior if the API call fails
            // but the user should see it disappear from the UI
            self.notes.removeAll { $0.id == note.id }
        }
    }
    
    func searchNotes(with searchText: String) {
        // Placeholder for future implementation
        // await fetchNotes(with: searchText)
    }
    
    func addToFavorite() {
        // Placeholder for future implementation
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
        } else if let networkError = error as? NetworkError {
            switch networkError {
            case .urlError:
                print("DEBUG: Invalid URL")
            case .decodingError(let message):
                print("DEBUG: Decoding error: \(message)")
            case .serverError(let message):
                print("DEBUG: Server error: \(message)")
            case .unknownError:
                print("DEBUG: Unknown network error")
            }
        } else {
            print("DEBUG: General error: \(error.localizedDescription)")
        }
    }
}
