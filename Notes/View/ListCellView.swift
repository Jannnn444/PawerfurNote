//
//  ListCellView.swift
//  Notes
//
//  Created by Janus on 1/27/25.
//

import SwiftUI

struct ListCellView: View {
    var note: Note
    
    var body: some View {
        ZStack (alignment: .leading) {
        BackgroundView()
            VStack(alignment: .leading, spacing: 5) {
                Text(note.title ?? "New Note")
                    .lineLimit(1)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(.noteBlack)
                Text(note.content ?? "No context available")
                    .lineLimit(1)
                    .fontWeight(.light)
                    .foregroundStyle(.noteBlack)
            }
            .padding()
            .frame(width: 300, height: 150, alignment: .leading) // Ensure full width alignment
        }
    }
    
//    private func noteBackgroundColor(_ note: NoteEntity) -> Color {
//        if let title = note.title, title.contains("Important") {
//            return .red.opacity(0.2) // Highlight important notes
//        } else {
//            return .noteMilktea.opacity(0.3) // Default background
//        }
//    }
}
