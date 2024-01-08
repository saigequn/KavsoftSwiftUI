//
//  ContentView.swift
//  ComplexScrollAnimations
//
//  Created by JXW003 on 2024/1/8.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        GeometryReader {
            let safeArea = $0.safeAreaInsets
            Home(safeArea: safeArea)
                .ignoresSafeArea(.container, edges: .top)
        }
    }
}

#Preview {
    ContentView()
}
