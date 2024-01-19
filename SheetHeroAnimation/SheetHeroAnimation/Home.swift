//
//  Home.swift
//  SheetHeroAnimation
//
//  Created by JXW003 on 2024/1/18.
//

import SwiftUI

struct Home: View {
    
    @State private var selectedProfile: Profile?
    @State private var showProfileView: Bool = false
    @Environment(WindowSharedModel.self) private var windowSharedModel
    @Environment(SceneDelegate.self) private var sceneDelegate
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 15) {
                ForEach(profiles) { profile in
                    HStack(spacing: 12) {
                        GeometryReader(content: { geometry in
                            let rect = geometry.frame(in: .global)
                            Image(profile.profilePicture)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: rect.width, height: rect.height)
                                .opacity(windowSharedModel.selectedProfile?.id == profile.id ? (windowSharedModel.hideNativeView || showProfileView ? 0 : 1) : 1)
                                .clipShape(.circle)
                                .contentShape(.circle)
                                .onTapGesture {
                                    Task {
                                        /// Opening Profile
                                        selectedProfile = profile
                                        windowSharedModel.selectedProfile = profile
                                        windowSharedModel.cornerRadius = rect.width * 0.5
                                        windowSharedModel.sourceRect = rect
                                        /// Storing the Source Rect for Closing Animation
                                        windowSharedModel.previousSourceRect = rect
                                        
                                        try? await Task.sleep(for: .seconds(0))
                                        windowSharedModel.hideNativeView = true
                                        showProfileView.toggle()
                                        
                                        /// After Animation finished, Removing Hero View
                                        try? await Task.sleep(for: .seconds(0.5))
                                        if windowSharedModel.hideNativeView {
                                            windowSharedModel.hideNativeView = false
                                        }
                                    }
                                }
                                .onAppear { print(rect) }
                        })
                        .frame(width: 50, height: 50)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(profile.userName)
                                .fontWeight(.bold)
                            Text(profile.lastMsg)
                                .font(.caption)
                                .foregroundStyle(.gray)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text(profile.lastActive)
                            .font(.caption2)
                            .foregroundStyle(.gray)
                    }
                }
            }
            .padding(15)
            .padding(.horizontal, 5)
        }
        .scrollIndicators(.hidden)
        .sheet(isPresented: $showProfileView, content: {
            DetailProfileView(
                selectedProfile: $selectedProfile,
                showProfileView: $showProfileView
            )
            .presentationDetents([.medium, .large])
            .presentationCornerRadius(25)
            .interactiveDismissDisabled()
            .presentationDragIndicator(.hidden)
        })
        /// Adding Hero Overlay Window For Performing Hero Animation's
        .onAppear(perform: {
            guard sceneDelegate.heroWindow == nil else { return }
            sceneDelegate.addHeroWindow(windowSharedModel)
        })
    }
}


struct DetailProfileView: View {
    @Binding var selectedProfile: Profile?
    @Binding var showProfileView: Bool
    @Environment(\.colorScheme) private var scheme
    @Environment(WindowSharedModel.self) private var windowSharedModel

    var body: some View {
        VStack {
            GeometryReader(content: { geometry in
                let size = geometry.size
                let rect = geometry.frame(in: .global)
                
                if let selectedProfile {
                    Image(selectedProfile.profilePicture)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: size.width, height: size.height)
                        .overlay {
                            let color = scheme == .dark ? Color.black : Color.white
                            LinearGradient(
                                colors: [
                                    .clear,
                                    .clear,
                                    .clear,
                                    .clear,
                                    color.opacity(0.1),
                                    color.opacity(0.5),
                                    color.opacity(0.9),
                                    color
                                ],
                                startPoint: .top,
                                endPoint: .bottom)
                        }
                        .clipped()
                        .opacity(windowSharedModel.hideNativeView ? 0 : 1)
                        .preference(key: RectKey.self, value: rect)
                        .onPreferenceChange(RectKey.self, perform: { value in
                            if showProfileView {
                                windowSharedModel.sourceRect = value
                            }
                        })
                }
            })
            .frame(maxHeight: 330)
            .overlay(alignment: .topLeading) {
                Button(action: {
                    /// Closing the Same Way as Opening
                    Task {
                        windowSharedModel.hideNativeView = true
                        showProfileView = false
                        try? await Task.sleep(for: .seconds(0))
                        /// Using the Stored Source Frame Rect to RePosition to it's original place
                        windowSharedModel.sourceRect = windowSharedModel.previousSourceRect
                        windowSharedModel.showGradient = false
                        /// Waiting for animation completion
                        try? await Task.sleep(for: .seconds(0.5))
                        if windowSharedModel.hideNativeView {
                            windowSharedModel.reset()
                            selectedProfile = nil
                        }
                    }
                }, label: {
                    Image(systemName: "xmark")
                        .foregroundStyle(.white)
                        .contentShape(.rect)
                        .padding(10)
                        .background(.black, in: .circle)
                })
                .padding([.leading, .top], 20)
                .scaleEffect(0.9)
                .opacity(windowSharedModel.hideNativeView ? 0 : 1)
                .animation(.snappy, value: windowSharedModel.hideNativeView)
            }
            
            Spacer()
        }
    }
}

/// Prefernce Key to Read View Bounds
struct RectKey: PreferenceKey {
    static var defaultValue: CGRect = .zero
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}


#Preview {
    ContentView()
}
