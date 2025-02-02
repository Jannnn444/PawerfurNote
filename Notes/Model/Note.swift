//
//  NoteData.swift
//  Notes
//
//  Created by Hualiteq International on 2025/2/2.
//

import Foundation

struct Note: Codable, Hashable, Identifiable {
    let id: UUID
    let title: String
    let content: String
    let favorite: Bool
    let createdAt: Date
    let updatedAt: Date
}

