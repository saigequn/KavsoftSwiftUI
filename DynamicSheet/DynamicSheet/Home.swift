//
//  Home.swift
//  DynamicSheet
//
//  Created by JXW003 on 2024/1/22.
//

import SwiftUI

struct Home: View {
    @State private var showSheet: Bool = false
    @State private var sheetHeight: CGFloat = .zero
    @State private var alreadyHavingAccount: Bool = false
    @State private var emailAddress: String = ""
    @State private var password: String = ""
    
    @State private var isKeyboardShowing: Bool = false

    /// View's Height (Storing For Swipe Calculation)
    @State private var sheetFirstPageHeight: CGFloat = .zero
    @State private var sheetSecondPageHeight: CGFloat = .zero
    
    @State private var sheetScrollProgress: CGFloat = .zero

    
    var body: some View {
        VStack {
            Spacer()
            
            Button("Show Sheet") {
                showSheet.toggle()
            }
            .buttonStyle(.borderedProminent)
            .tint(.red)
        }
        .padding(30)
        .sheet(isPresented: $showSheet, onDismiss: {
            /// Reseting Properties
            sheetHeight = .zero
            sheetFirstPageHeight = .zero
            sheetSecondPageHeight = .zero
            sheetScrollProgress = .zero
        }, content: {
            /// Sheet view
            GeometryReader(content: { geometry in
                let size = geometry.size
                
                ScrollViewReader(content: { proxy in
                    ScrollView(.horizontal) {
                        HStack(alignment: .top, spacing: 0) {
                            OnBoarding(size)
                                .id("First Page")
                            
                            LoginView(size)
                                .id("Second Page")
                        }
                        /// For Paging Needs to be Enabled
                        .scrollTargetLayout()
                    }
                    /// Enabling Paging ScrollView
                    .scrollTargetBehavior(.paging)
                    .scrollIndicators(.hidden)
                    /// Disbaling ScrollView when Will be Updated over scroll
                    .scrollDisabled(isKeyboardShowing)
                    .overlay(alignment: .topTrailing) {
                        Button(action: {
                            if sheetScrollProgress < 1.0 {
                                // Continue Button
                                // Moving to the next page (using scrollview Reader)
                                withAnimation(.snappy) {
                                    proxy.scrollTo("Second Page", anchor: .leading)
                                }
                            } else {
                                
                            }
                        }, label: {
                            Text("Continue")
                                .fontWeight(.semibold)
                                .opacity(1 - sheetScrollProgress)
                                /// Adding Some Extra with for second page
                                /// Since Login Text Size is Small Reducing the Size
                                .frame(width: 120 + sheetScrollProgress * (alreadyHavingAccount ? -0 : 50))
                                .overlay(content: {
                                    /// Next Page Text
                                    HStack(spacing: 8) {
                                        Text(alreadyHavingAccount ? "Login" : "Get Started")
                                        
                                        Image(systemName: "arrow.right")
                                    }
                                    .fontWeight(.semibold)
                                    .opacity(sheetScrollProgress)
                                })
                                .padding(.vertical, 12)
                                .foregroundStyle(.white)
                                .background(.linearGradient(colors: [.red, .orange], startPoint: .topLeading, endPoint: .bottomTrailing), in: .capsule)
                        })
                        .padding(15)
                        .offset(y: sheetHeight - 100)
                        /// Moving Button Near to the Next View
                        .offset(y: -sheetScrollProgress * 120)
                    }
                })
                
            })
            .presentationCornerRadius(30)
            .presentationDetents(sheetHeight == .zero ? [.medium] : [.height(sheetHeight)])
            /// Disabling Swipe to Dismiss 禁止滑动返回
            .interactiveDismissDisabled()
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification), perform: { _ in
                isKeyboardShowing = true
            })
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification), perform: { _ in
                isKeyboardShowing = false
            })
        })
    }
    
    @ViewBuilder
    func OnBoarding(_ size: CGSize) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Know Everything\n\("about the weather")")
                .font(.largeTitle.bold())
                .lineLimit(2)
            
            Text(attributedSubTitle)
                .font(.callout)
                .foregroundStyle(.gray)
        }
        .padding(15)
        .padding(.horizontal, 10)
        .padding(.top, 15)
        .padding(.bottom, 130)
        .frame(width: size.width, alignment: .leading)
        /// Finding the View's Height
        .heightChangePreference { height in
            sheetFirstPageHeight = height
            /// Since the Sheet Height will be same as the First/Initial Page Height
            sheetHeight = height
        }
    }
    
    @ViewBuilder
    func LoginView(_ size: CGSize) -> some View {
        VStack(alignment: .leading, spacing: 12, content: {
            Text(alreadyHavingAccount ? "Login" : "Create an account")
                .font(.largeTitle.bold())
            
            CustomTextField(hint: "Email Address", text: $emailAddress, icon: "envelope")
            
            CustomTextField(hint: "Password", text: $password, icon: "lock", isPassword: true)
        })
        .padding(15)
        .padding(.horizontal, 10)
        .padding(.top, 15)
        .padding(.bottom, 220)
        .overlay(alignment: .bottom) {
            VStack(spacing: 15) {
                Group {
                    if alreadyHavingAccount {
                        HStack(spacing: 4, content: {
                            Text("Don't have an account?")
                                .foregroundStyle(.gray)
                            
                            Button("Create an account") {
                                withAnimation(.snappy) {
                                    alreadyHavingAccount.toggle()
                                }
                            }
                            .tint(.red)
                        })
                        .transition(.push(from: .bottom))
                    } else {
                        HStack(spacing: 4, content: {
                            Text("Already having an account?")
                                .foregroundStyle(.gray)
                            
                            Button("Login") {
                                withAnimation(.snappy) {
                                    alreadyHavingAccount.toggle()
                                }
                            }
                            .tint(.red)
                        })
                        .transition(.push(from: .top))
                    }
                }
                .font(.callout)
                .textScale(.secondary)
                .padding(.bottom, alreadyHavingAccount ? 0 : 15)
                
                if !alreadyHavingAccount {
                    Text("By signing up, you're agreeing to our **[Terms & Condition](https://apple.com)** and **[Privacy Policy](https://apple.com)**")
                        .font(.caption)
                        .tint(.red)
                        .foregroundStyle(.gray)
                        .transition(.offset(y: 100))
                }
            }
            .padding(.bottom, 15)
            .padding(.horizontal, 20)
            .multilineTextAlignment(.center)
            .frame(width: size.width)
        }
        .frame(width: size.width)
        /// Finding the View's Height
        .heightChangePreference { height in
            sheetSecondPageHeight = height
            let diff = sheetSecondPageHeight - sheetFirstPageHeight
            sheetHeight = sheetFirstPageHeight + diff * sheetScrollProgress
        }
        /// Offset Preference
        .minXChangePreference { minX in
            let diff = sheetSecondPageHeight - sheetFirstPageHeight
            /// Truncating MinX between (0 to Screen Width)
            let truncatedMinX = min(size.width - minX, size.width)
            guard truncatedMinX > 0 else { return }
            /// Converting MinX to Progress (0 - 1)
            sheetScrollProgress = truncatedMinX / size.width
            sheetHeight = sheetFirstPageHeight + diff * sheetScrollProgress
        }
    }
    
    var attributedSubTitle: AttributedString {
        let string = "Start now and learn more about local weather instantly"
        var attString = AttributedString(stringLiteral: string)
        if let range = attString.range(of: "local weather") {
            attString[range].foregroundColor = .black
            attString[range].font = .callout.bold()
        }
        return attString
    }
}


struct CustomTextField: View {
    var hint: String
    @Binding var text: String
    var icon: String
    var isPassword: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12, content: {
            if isPassword {
                SecureField(hint, text: $text)
            } else {
                TextField(hint, text: $text)
            }
            
            Divider()
        })
        .overlay(alignment: .trailing) {
            Image(systemName: icon)
                .foregroundStyle(.gray)
        }
    }
}


#Preview {
    ContentView()
}
