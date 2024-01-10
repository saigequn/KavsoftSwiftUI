//
//  ContentView.swift
//  ReelsLayout
//
//  Created by JXW003 on 2024/1/9.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        GeometryReader {
            let size = $0.size
            let safeArea = $0.safeAreaInsets
            
            Home(size: size, safeArea: safeArea)
                .ignoresSafeArea(.container, edges: .all)
                .environment(\.colorScheme, .dark)
        }
    }
}

#Preview {
    ContentView()
}
