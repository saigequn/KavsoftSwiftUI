//
//  GradientButton.swift
//  LoginKit
//
//  Created by JXW003 on 2024/1/23.
//

import SwiftUI

struct GradientButton: View {
    
    var title: String
    var icon: String
    var onClick: () -> ()
    
    var body: some View {
        Button(action: onClick, label: {
            HStack(spacing: 15) {
                Text(title)
                Image(systemName: icon)
            }
            .fontWeight(.bold)
            .foregroundStyle(.white)
            .padding(.vertical, 12)
            .padding(.horizontal, 35)
            .background(.linearGradient(
                colors: [.appYellow, .orange, .red],
                startPoint: .top,
                endPoint: .bottom),
                        in: Capsule())
        })
    }
}

#Preview {
    GradientButton(title: "Login", icon: "arrow.right") {
        
    }
}
