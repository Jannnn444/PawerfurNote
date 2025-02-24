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
            Capsule()
                .fill(
                    LinearGradient(colors: [
                        .noteLighttea,
                        .noteMediumtea,
                        .noteMediumDarktea],
                                   startPoint: .top,
                                   endPoint: .bottom
                    )
                )
                .frame(width: 100, height: 50)
        }
    }
}

#Preview {
    CustomButtonView()
}
