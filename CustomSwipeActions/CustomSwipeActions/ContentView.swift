//
//  ContentView.swift
//  CustomSwipeActions
//
//  Created by JXW003 on 2024/1/8.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            Home()
                .navigationTitle("Messages")
        }
    }
}

#Preview {
    ContentView()
}
