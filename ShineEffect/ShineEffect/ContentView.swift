//
//  ContentView.swift
//  ShineEffect
//
//  Created by JXW003 on 2024/1/5.
//

import SwiftUI

struct ContentView: View {
    @State private var shineButton: Bool = false
    @State private var shine: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                
                Button("Shine Button", systemImage: "square.and.arrow.up.circle.fill") {
                    shineButton.toggle()
                }
                .buttonStyle(.borderedProminent)
                .shine(shineButton, duration: 1.0, clipShape: .capsule)
                
                Image(.pic)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 150, height: 150)
                    .shine(shine, duration: 0.8, clipShape: .rect(cornerRadius: 20))
                    .onTapGesture {
                        shine.toggle()
                    }
            }
            .navigationTitle("Shine Effect")
        }
    }
}



extension View {
    @ViewBuilder
    func shine(_ toggle: Bool, duration: CGFloat = 0.5, clipShape: some Shape = .rect, rightToLeft: Bool = false) -> some View {
        self
            .overlay {
                GeometryReader {
                    let size = $0.size
                    let moddedDuration = max(0.3, duration)
                    
                    Rectangle()
                        .fill(.linearGradient(
                            colors: [
                                .clear,
                                .clear,
                                .white.opacity(0.1),
                                .white.opacity(0.5),
                                .white.opacity(1.0),
                                .white.opacity(0.5),
                                .white.opacity(0.1),
                                .clear,
                                .clear
                            ],
                            startPoint: .leading,
                            endPoint: .trailing)
                        )
                        .scaleEffect(y: 8)
                        .keyframeAnimator(initialValue: 0.0, trigger: toggle, content: { content, progress in
                            content
                                .offset(x: -size.width + progress * (2.0 * size.width))
                        }, keyframes: { _ in
                            CubicKeyframe(.zero, duration: 0.1)
                            CubicKeyframe(1, duration: moddedDuration)
                        })
                        .rotationEffect(.init(degrees: 45))
                        .scaleEffect(x: rightToLeft ? -1 : 1)
                }
            }
            .clipShape(clipShape)
    }
}


#Preview {
    ContentView()
}
