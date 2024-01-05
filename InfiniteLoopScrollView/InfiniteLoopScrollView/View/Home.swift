//
//  Home.swift
//  InfiniteLoopScrollView
//
//  Created by JXW003 on 2024/1/5.
//

import SwiftUI

struct Home: View {
    
    @State private var items: [Item] = [.red, .blue, .green, .yellow, .purple].compactMap({ return .init(color: $0) })

    var body: some View {
        ScrollView(.vertical) {
            VStack {
                GeometryReader {
                    LoopingScrollView(width: $0.size.width, spacing: 0, items: items) { item in
                        RoundedRectangle(cornerRadius: 15)
                            .fill(item.color.gradient)
                            .padding(.horizontal, 15)
                    }
                    .scrollTargetBehavior(.paging)
                }
                .frame(height: 220)
                
//                LoopingScrollView(width: 150, spacing: 10, items: items) { item in
//                    RoundedRectangle(cornerRadius: 15)
//                        .fill(item.color.gradient)
//                }
//                .frame(height: 150)
//                .contentMargins(.horizontal, 15, for: .scrollContent)
                
            }
            .padding(.vertical, 15)
        }
        .scrollIndicators(.hidden)
    }
}

#Preview {
    ContentView()
}
