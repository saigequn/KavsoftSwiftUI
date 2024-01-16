//
//  View+Extensions.swift
//  DarkModeAnimation
//
//  Created by JXW003 on 2024/1/16.
//

import SwiftUI

extension View {
    @ViewBuilder
    func rect(value: @escaping (CGRect) -> ()) -> some View {
        self
            .overlay {
                GeometryReader(content: { geometry in
                    let rect = geometry.frame(in: .global)
                    Color.clear
                        .preference(key: RectKey.self, value: rect)
                        .onPreferenceChange(RectKey.self, perform: { rect in
                            value(rect)
                        })
                })
            }
    }
    
    @MainActor
    @ViewBuilder
    func createImages(toggleDarkMode: Bool, currentImage: Binding<UIImage?>, previousImage: Binding<UIImage?>, activateDarkMode: Binding<Bool>) -> some View {
        self
            .onChange(of: toggleDarkMode) { oldValue, newValue in
                Task {
                    if let window = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first(where: { $0.isKeyWindow }) {
                        let imageView = UIImageView()
                        imageView.frame = window.frame
                        imageView.image = window.rootViewController?.view.image(window.frame.size)
                        imageView.contentMode = .scaleAspectFit
                        window.addSubview(imageView)
                        
                        if let rootView = window.rootViewController?.view {
                            let frameSize = rootView.frame.size
                            /// Creating Snapshots
                            /// Old One
                            activateDarkMode.wrappedValue = !newValue
                            previousImage.wrappedValue = rootView.image(frameSize)
                            /// New One with Updated Trait State
                            activateDarkMode.wrappedValue = newValue
                            /// Giving some time Updated Trait State
                            try await Task.sleep(for: .seconds(0.01))
                            currentImage.wrappedValue = rootView.image(frameSize)
                            /// Removing once all the snapshots has token
                            try await Task.sleep(for: .seconds(0.01))
                            imageView.removeFromSuperview()
                        }
                    }
                }
            }
    }
}


/// Converting UIView to UIImage
extension UIView {
    func image(_ size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            drawHierarchy(in: .init(origin: .zero, size: size), afterScreenUpdates: true)
        }
    }
}


struct RectKey: PreferenceKey {
    static var defaultValue: CGRect = .zero
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}


#Preview {
    ContentView()
}
