//
//  NoteData.swift
//  Notes
//
//  Created by Hualiteq International on 2025/2/2.
//
//
//  NoteData.swift
//  Notes
//
//  Created by Hualiteq International on 2025/2/2.
//  Updated for Async/Await compatibility
//

import Foundation

// Model for a single note
struct Note: Codable, Hashable, Identifiable {
    let id: String
    let title: String?
    let content: String?
    let favorite: Bool
    let created_at: String?
    let updated_at: String?
    
    // Added initializer for creating new notes
    init(id: String, title: String?, content: String?, favorite: Bool, created_at: String?, updated_at: String?) {
        self.id = id
        self.title = title
        self.content = content
        self.favorite = favorite
        self.created_at = created_at
        self.updated_at = updated_at
    }
}

// Response model for getting all notes
struct NoteResponse: Codable, Hashable {
    let message: String?  // Make optional to handle case when API doesn't include it
    let statusCode: Int?  // Make optional in case it's missing
    let result: [Note]
    
    // Custom decoder to handle cases where API response format varies
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Try to decode with optional fields
        message = try container.decodeIfPresent(String.self, forKey: .message)
        statusCode = try container.decodeIfPresent(Int.self, forKey: .statusCode)
        
        // For the notes array, which is critical
        do {
            result = try container.decode([Note].self, forKey: .result)
        } catch {
            // If the API just returns a direct array of notes without a wrapper
            do {
                result = try [Note](from: decoder)
            } catch {
                // Log specific decoding errors to help with debugging
                print("Failed to decode notes array: \(error)")
                throw error
            }
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case message
        case statusCode
        case result
    }
}

// Response for posting a new note
struct NotePostResponse: Codable {
    let message: String
    let result: Bool
    let statusCode: Int
}

// Response for user sign-in
struct SignInResponse: Codable {
    let message: String
    let statusCode: Int
    let result: SignIn
}

// Token data for sign-in
struct SignIn: Codable {
    let refreshToken: String
    let accessToken: String
    let accessExpiresIn: Int
    let refreshExpiresIn: Int
}

// Payload for creating a new note
struct NotePayloadForPost: Codable, Hashable {
    let title: String
    let content: String
}

// Response for deleting a note
struct DeleteNoteResponse: Codable, Hashable {
    let id: String
    let title: String
    let content: String
}

// Payload for signing in
struct SignInPayload: Codable, Hashable {
    let email: String
    let password: String
}

// Payload for creating a new account
struct SignUpPayload: Codable, Hashable {
    let name: String
    let email: String
    let password: String
    let phone: String
}

// Response for sign-up
struct SignUpResponse: Codable {
    let message: String
    let statusCode: Int
    let result: Bool
}
