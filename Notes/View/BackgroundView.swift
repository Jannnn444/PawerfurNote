//
//  BackgroundView.swift
//  Notes
//
//  Created by Hualiteq International on 2025/2/10.
//

import Foundation
import SwiftUI

struct BackgroundView: View {
    var body: some View {
        ZStack {
            // MARK: - 3. DEPH
            
            Color(.noteDarktea)
                .cornerRadius(40)
                .offset(y: 12)
            // MARK: - 2. LiGHT
            
            Color(.noteMilktea)
                .cornerRadius(40)
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
            .cornerRadius(40)
                
        }
    }
}

#Preview {
    BackgroundView()
        .padding()
}
