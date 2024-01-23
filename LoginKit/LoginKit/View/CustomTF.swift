//
//  CustomTF.swift
//  LoginKit
//
//  Created by JXW003 on 2024/1/23.
//

import SwiftUI

struct CustomTF: View {
    
    var sfIcon: String
    var iconTint: Color = .gray
    var hint: String
    /// Hides TextField
    var isPassword: Bool = false
    @Binding var value: String
    @State private var showPassword: Bool = false
    
    var body: some View {
        HStack(alignment: .top, spacing: 5) {
            Image(systemName: sfIcon)
                .foregroundStyle(iconTint)
                .frame(width: 30)
                .offset(y: 2)
            
            VStack(alignment: .leading, spacing: 8) {
                if isPassword {
                    Group {
                        if showPassword {
                            TextField(hint, text: $value)
                        } else {
                            SecureField(hint, text: $value)
                        }
                    }
                } else {
                    TextField(hint, text: $value)
                }
                Divider()
            }
            .overlay(alignment: .trailing) {
                if isPassword {
                    Button(action: {
                        withAnimation {
                            showPassword.toggle()
                        }
                    }, label: {
                        Image(systemName: showPassword ? "eye.slash" : "eye")
                            .foregroundColor(.gray)
                            .padding(10)
                            .contentShape(.rect)
                        
                    })
                }
            }
        }
        
        
    }
}

#Preview {
    CustomTF(sfIcon: "at", hint: "email ID", value: .constant("0"))
}
