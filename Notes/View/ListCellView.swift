//
//  ListCellView.swift
//  Notes
//
//  Created by Janus on 1/27/25.
//

import SwiftUI

struct ListCellView: View {
    var note: NoteEntity
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(note.title ?? "New Note")
                .lineLimit(1)
                .font(.title3)
                .fontWeight(.bold)
            Text(note.content ?? "No context available")
                .lineLimit(1)
                .fontWeight(.light)
        }
       
        .padding(.trailing)
        .frame(width: 400 ,height: 80)
        .background(noteBackgroundColor(note))
        .cornerRadius(10)
    }
    
    private func noteBackgroundColor(_ note: NoteEntity) -> Color {
        if let title = note.title, title.contains("Important") {
            return .red.opacity(0.2) // Highlight important notes
        } else {
            return .noteMilktea.opacity(0.3) // Default background
        }
    }
}
