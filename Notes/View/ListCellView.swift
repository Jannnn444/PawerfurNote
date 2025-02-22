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
        NoteBackgroundView()
            VStack(alignment: .leading, spacing: 5) {
                Text(note.title ?? "New Note")
                    .lineLimit(1)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(.noteDarktea)
                Text(note.content ?? "No context available")
                    .lineLimit(1)
                    .font(.title3)
                    .foregroundStyle(.noteDarktea)
            }
            .padding()
            .frame(width: 300, height: 150, alignment: .leading) // Ensure full width alignment
        }
    }
}
