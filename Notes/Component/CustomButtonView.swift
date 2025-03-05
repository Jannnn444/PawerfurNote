//
//  CustomButton.swift
//  Notes
//
//  Created by Hualiteq International on 2025/2/24.
//

import Foundation
import SwiftUI

struct CustomButtonView: View {
    var body: some View {
        ZStack {
            Rectangle()
                .fill(
                    LinearGradient(colors: [
                        .noteLighttea,
                        .noteMediumDarktea,
                        .noteDarktea],
                                   startPoint: .top,
                                   endPoint: .bottom
                    )
                )
                .frame(width: 80, height: 40)
                .cornerRadius(8)
        }
    }
}

#Preview {
    CustomButtonView()
}
