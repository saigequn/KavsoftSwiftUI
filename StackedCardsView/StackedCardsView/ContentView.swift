//
//  ContentView.swift
//  StackedCardsView
//
//  Created by JXW003 on 2024/5/17.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            GeometryReader { _ in
                Image(.wallpaper)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()
            }
            
            Home()
        }
        .environment(\.colorScheme, .dark)
    }
}

#Preview {
    ContentView()
}
