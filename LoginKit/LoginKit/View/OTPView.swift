//
//  OTPView.swift
//  LoginKit
//
//  Created by JXW003 on 2024/1/23.
//

import SwiftUI

struct OTPView: View {
    @Binding var otpText: String
    /// Environment Properties
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            /// Back Button
            Button(action: {
                dismiss()
            }, label: {
                Image(systemName: "xmark")
                    .font(.title2)
                    .foregroundStyle(.gray)
            })
            .padding(.top, 15)
                        
            Text("Enter OTP")
                .font(.largeTitle)
                .fontWeight(.heavy)
                .padding(.top, 5)
            
            Text("An 6 digit code  has been sent to your Email ID.")
                .font(.callout)
                .fontWeight(.semibold)
                .foregroundColor(.gray)
                .padding(.top, 5)
            
            VStack(spacing: 25) {
                /// Custom OTP TextFiled
                OTPVerificationView(otpText: $otpText)
                
                /// Login Button
                GradientButton(title: "Send Link", icon: "arrow.right") {
                }
                .hSpacing(.trailing)
                .disableWithOpacity(otpText.count < 6)
            }
            .padding(.top, 20)
        }
        .padding(.vertical, 15)
        .padding(.horizontal, 25)
        /// Since this is going to be a sheet
        .interactiveDismissDisabled()
    }
}

#Preview {
    ContentView()
}
