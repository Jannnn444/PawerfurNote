//
//  CustomCircleView.swift
//  Notes
//
//  Created by Hualiteq International on 2025/2/24.
//

import SwiftUI

struct CustomCircleView: View {
    @State private var isAnimateGradient: Bool = false
    
    var body: some View {
        Rectangle()
            .fill(
                LinearGradient(colors: [
                    .noteMilktea.opacity(0.8),
                    .noteAlmond
                    
                ], startPoint: isAnimateGradient ? .topLeading : .bottomLeading,
                   endPoint: isAnimateGradient ? .bottomTrailing : .topTrailing
                )
            )
            .onAppear {
                withAnimation(.linear(duration: 2.5).repeatForever(autoreverses: true)) {
                    isAnimateGradient.toggle()
                }
            }
            . frame(width: 256, height: 256)
            .cornerRadius(10)
    }
}

#Preview {
    CustomCircleView()
}
