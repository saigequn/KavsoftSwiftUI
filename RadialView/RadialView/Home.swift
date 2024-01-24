//
//  Home.swift
//  RadialView
//
//  Created by JXW003 on 2024/1/24.
//

import SwiftUI

struct Home: View {
    
    @State private var colors: [ColorValue] = [.red, .yellow, .green, .purple, .pink, .orange, .brown, .cyan, .indigo, .mint].compactMap { color -> ColorValue? in
        return .init(color: color)
    }
    @State private var activeIndex: Int = 0
    
    var body: some View {
        GeometryReader(content: { geometry in
            VStack {
                Spacer()
                
                RadialLayout(items: colors, keyPathID: \.id, spacing: 220) { value, index, size in
                    Circle()
                        .fill(value.color.gradient)
                        .overlay {
                            Text("\(index)")
                                .fontWeight(.semibold)
                        }
                } onIndexChange: { index in
                    activeIndex = index
                }
                .padding(.horizontal, -100)
                .frame(width: geometry.size.width, height: geometry.size.width / 2)
                .overlay {
                    Text("\(activeIndex)")
                        .font(.largeTitle.bold())
                        .offset(y: 70)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        })
        .padding(15)
    }
}

#Preview {
    ContentView()
}
