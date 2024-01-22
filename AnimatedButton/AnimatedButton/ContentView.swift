//
//  ContentView.swift
//  AnimatedButton
//
//  Created by JXW003 on 2024/1/19.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        CustomButton(buttonTint: .blue) {
            HStack(spacing: 10) {
                Text("Login")
                Image(systemName: "chevron.right")
            }
            .fontWeight(.bold)
            .foregroundStyle(.white)
        } action: {
            try? await Task.sleep(for: .seconds(2))
            return .failed("Password Incorrect")
//            return .success
        }
        .buttonStyle(.opacityLass)
        .preferredColorScheme(.dark)
    }
}


#Preview {
    ContentView()
}
