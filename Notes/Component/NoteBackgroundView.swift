//
//  BackgroundView.swift
//  Notes
//
//  Created by Hualiteq International on 2025/2/10.
//

import Foundation
import SwiftUI

struct NoteBackgroundView: View {
    var body: some View {
        ZStack {
            // MARK: - 3. DEPH
            
            Color(.noteDarktea)
                .cornerRadius(36)
                .offset(y: 10)
            
            // MARK: - 2. LiGHT
            
            Color(.noteMilktea)
                .cornerRadius(35)
                .offset(y: 3)
                .opacity(0.7)
            
            // MARK: - 1. SURFACE
            LinearGradient(
                colors: [
                    Color(.noteAlmond),
                    Color(.noteMilktea)
            ],
                startPoint: .top,
                endPoint: .bottom
            )
            .cornerRadius(34)
                
        }
    }
}

#Preview {
    NoteBackgroundView()
        .padding()
}
