//
//  ContentView.swift
//  InfiniteLoopScrollView
//
//  Created by JXW003 on 2024/1/5.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            Home()
                .navigationTitle("Looping ScrollView")
        }
    }
}

#Preview {
    ContentView()
}
