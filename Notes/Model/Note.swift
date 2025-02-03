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

