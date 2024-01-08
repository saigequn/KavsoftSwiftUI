//
//  Home.swift
//  CustomSwipeActions
//
//  Created by JXW003 on 2024/1/8.
//

import SwiftUI

struct Home: View {
    
    @State private var colors: [Color] = [.black, .yellow, .purple, .brown]
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 10) {
                ForEach(colors, id: \.self) { color in
                    SwipeAction(cornerRadius: 15, direction: color == .black ? .trailing : .leading) {
                        CardView(color)
                    } actions: {
                        
                        Action(tint: .blue, icon: "star.fill", isEnabled: color == .black) {
                            print("Bookmarked")
                        }
                        
                        Action(tint: .red, icon: "trash.fill") {
                            withAnimation(.snappy) {
                                colors.removeAll(where: { $0 == color })
                            }
                        }
                    }
                }
            }
            .padding(15)
        }
        .scrollIndicators(.hidden)
    }
    
    @ViewBuilder
    func CardView(_ color: Color) -> some View {
        HStack(spacing: 12) {
            Circle()
                .frame(width: 50, height: 50)
            
            VStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 8)
                    .frame(width: 100, height: 8)
                
                RoundedRectangle(cornerRadius: 8)
                    .frame(width: 70, height: 8)
            }
            
            Spacer()
        }
        .foregroundStyle(.white.opacity(0.4))
        .padding(.horizontal, 15)
        .padding(.vertical, 10)
        .background(color.gradient)
    }
    
}

#Preview {
    Home()
}
