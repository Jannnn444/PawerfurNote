//
//  NoteData.swift
//  Notes
//
//  Created by Hualiteq International on 2025/2/2.
//

import Foundation

struct Note: Codable, Hashable, Identifiable {
    let id: String
    let title: String
    let content: String
    let favorite: Bool
    let created_at: String
    let updated_at: String
}

struct NoteResponse: Codable, Hashable {
    let message: String
    let statusCode: Int
    let result: [Note]
}

struct NotePostResponse: Codable {
    let message: String
    let result: Bool
    let statusCode: Int
}

struct SignInResponse: Codable {
    let message: String
    let statusCode: Int
    let result: SignIn
}

struct SignIn: Codable {
    let refreshToken: String
    let accessToken: String
    let accessExpiresIn: Int
    let refreshExpiresIn: Int
}

struct NotePayloadForPost: Codable, Hashable {
    let title: String
    let content: String
}

struct DeleteNoteResponse: Codable, Hashable {
    let id: String
    let title: String
    let content: String
}

struct AccountPayload: Codable, Hashable {
    let email: String
    let password: String
}

/*
 {
  "message": "Note was successfully created.",
  "result": true,
  "statusCode": 200
}
 */
