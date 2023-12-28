//
//  ContentView.swift
//  Scroll Parallax
//
//  Created by JXW003 on 2023/12/28.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            Home()
                .navigationTitle("Parallax Scroll Effect")
        }
    }
}

#Preview {
    ContentView()
}
