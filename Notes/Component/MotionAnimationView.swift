//
//  MotionAnimationView.swift
//  Notes
//
//  Created by Hualiteq International on 2025/2/24.
//

import SwiftUI

struct MotionAnimationView: View {
    // MARK: PROPERTIES
    
    @State private var randomCircle: Int = Int.random(in: 6...12)
    // MARK: FUNCS
    
    // 1. Random cordinate
    func randomCordinate() -> CGFloat {
        return CGFloat.random(in: 0...256)
    }
    // 2. Random size
    func randonSize() -> CGFloat {
        return CGFloat(Int.random(in: 4...80))
    }
    // 3. Random scale
    // 4. Random speed
    // 5. Random delay
    
    var body: some View {
        ZStack {
            ForEach(0...randomCircle, id: \.self) { item in
                Circle()
                    .foregroundColor(.white)
                    .opacity(0.25)
                    .frame(width: randonSize())
                    .position(
                    x: randomCordinate(),
                    y: randomCordinate()
                    )
            }
        } //: Zstack
        .frame(width: 256, height: 256)
    }
}

#Preview {
    ZStack {
        Color.teal.ignoresSafeArea() // background color
        MotionAnimationView()
    }
}
