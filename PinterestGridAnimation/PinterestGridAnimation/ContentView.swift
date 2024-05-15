//
//  ContentView.swift
//  PinterestGridAnimation
//
//  Created by JXW003 on 2024/5/15.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            Home()
                .toolbar(.hidden, for: .navigationBar)
        }
    }
}

#Preview {
    ContentView()
}
