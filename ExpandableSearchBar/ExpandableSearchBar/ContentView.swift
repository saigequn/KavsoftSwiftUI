//
//  ContentView.swift
//  ExpandableSearchBar
//
//  Created by JXW003 on 2024/5/20.
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
