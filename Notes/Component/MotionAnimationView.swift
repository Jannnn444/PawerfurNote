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
    @State private var isAnimating: Bool = false
    
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
    func randomScale() -> CGFloat {
        return CGFloat(Double.random(in: 0.1...2.0))
    }
    
    // 4. Random speed
    func randomSpeed() -> Double {
        return Double.random(in: 0.05...1.0)
    }
    
    // 5. Random delay
    func randomDelay() -> Double {
        return Double.random(in: 0...2)
    }
    
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
                    .scaleEffect(isAnimating ? randomScale() : 1)  // start moving!
                    .onAppear(perform: {
                        withAnimation(
                            .interpolatingSpring(stiffness: 0.25, damping: 0.25)
                            .repeatForever()
                            .speed(randomSpeed())
                            .delay(randomDelay())
                        ) {
                            isAnimating = true
                        }
                    })
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
