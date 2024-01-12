//
//  ContentView.swift
//  LockSwiftUIView
//
//  Created by JXW003 on 2024/1/12.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        
        LockView(lockType: .both, lockPin: "0320", isEnabled: true) {
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("Hello, world!")
            }
            .padding()
        }
        
    }
}

#Preview {
    ContentView()
}
