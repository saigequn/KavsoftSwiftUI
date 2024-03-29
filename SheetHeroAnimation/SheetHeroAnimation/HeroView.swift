//
//  HeroView.swift
//  SheetHeroAnimation
//
//  Created by JXW003 on 2024/1/19.
//

import SwiftUI

struct CustomHeroAnimationView: View {
    @Environment(WindowSharedModel.self) private var windowSharedModel
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        GeometryReader(content: { geometry in
            //let safeArea = geometry.safeAreaInsets
            VStack {
                let sourceRect = windowSharedModel.sourceRect
                if let selectedProfile = windowSharedModel.selectedProfile, windowSharedModel.hideNativeView {
                Image(selectedProfile.profilePicture)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: sourceRect.width, height: sourceRect.height)
                    .overlay {
                        let color = scheme == .dark ? Color.black : Color.white
                        LinearGradient(
                            colors: [
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
                        .opacity(windowSharedModel.showGradient ? 1 : 0)
                    }
                    .clipShape(.rect(cornerRadius: windowSharedModel.cornerRadius))
                    .offset(x: sourceRect.midX, y: sourceRect.midY)
                    .animation(.snappy(duration: 0.3, extraBounce: 0), value: windowSharedModel.showGradient)
                }
            }
            /// Animating Frame Changes
            .animation(.snappy(duration: 0.3, extraBounce: 0), value: windowSharedModel.sourceRect)
            .ignoresSafeArea()
        })
    }
}
