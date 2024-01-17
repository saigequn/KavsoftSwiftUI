//
//  PulseHeartView.swift
//  HeartAnimation
//
//  Created by JXW003 on 2024/1/16.
//

import SwiftUI

struct PulseHeartView: View {
    
    @State private var startAnimation: Bool = false
    
    var body: some View {
        Image(systemName: "suit.heart.fill")
            .font(.system(size: 100))
            .foregroundStyle(.red.gradient)
            .background() {
                Image(systemName: "suit.heart.fill")
                    .font(.system(size: 100))
                    .foregroundStyle(.black.gradient)
                    .blur(radius: 5.0, opaque: false)
                    .scaleEffect(startAnimation ? 1.1 : 0)
                    .animation(.linear(duration: 1.5), value: startAnimation)
            }
            .scaleEffect(startAnimation ? 4 : 1)
            .opacity(startAnimation ? 0 : 1)
            .onAppear(perform: {
                withAnimation(.linear(duration: 3)) {
                    startAnimation = true
                }
            })
    }
}

#Preview {
    PulseHeartView()
}
