//
//  ContentView.swift
//  AnimatedToasts
//
//  Created by JXW003 on 2024/1/3.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Button("Present Toast") {
                Toast.shared.present(
                    title: "Hello World",
                    symbol: "globe",
                    isUserInteractionEnabld: true,
                    timing: .long)
            }
        }
        .padding()
    }
}

#Preview {
    RootView {
        ContentView()
    }
}
