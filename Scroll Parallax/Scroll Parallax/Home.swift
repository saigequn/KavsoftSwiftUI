//
//  Home.swift
//  Scroll Parallax
//
//  Created by JXW003 on 2023/12/28.
//

import SwiftUI

struct Home: View {
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 15) {
                DummySection(title: "Social Mddia")
                
                DummySection(title: "Sales", isLong: true)
                
                /// ParallaxImage
                ParallaxImageView(usesFullWidth: true) { size in
                    Image(.a3)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: size.width, height: size.height)
                }
                .frame(height: 300)
                
                DummySection(title: "Busniss", isLong: true)
                
                DummySection(title: "Promotion", isLong: true)
                
                ParallaxImageView(maximumMovement: 150, usesFullWidth: false) { size in
                    Image(.a1)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: size.width, height: size.height)
                }
                .frame(height: 300)
                
                DummySection(title: "YouTube")
                
                DummySection(title: "Twitter")
            }
            .padding(15)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    /// Dumy Section
    @ViewBuilder
    func DummySection(title: String, isLong: Bool = false) -> some View {
        VStack(alignment: .leading, spacing: 8, content: {
            
            Text(title)
                .font(.title.bold())
            
            Text("In this video, I'm going to show how to create a cool parallax scroll effect that will be commonly used on web pages using SwiftUI | SwiftUI Parallax Effect | SwiftUI Parallax Scroll | SwiftUI Animations | Xcode 15 | iOS 17 | Swift | SwiftUI Xcode 15 | SwiftUI for iOS 17 | Xcode 15 SwiftUI. \(isLong ? "\nMake sure to like and Subscribe For More Content !!!" : "")")
                .multilineTextAlignment(.leading)
                .kerning(1.2)
            
        })
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}


struct ParallaxImageView<Content: View>: View {
    var maximumMovement: CGFloat = 100
    var usesFullWidth: Bool = false
    @ViewBuilder var content: (CGSize) -> Content
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            /// Movement animation Properties
            let minY = $0.frame(in: .scrollView(axis: .vertical)).minY
            let scrollViewHeight = $0.bounds(of: .scrollView)?.size.height ?? 0
            let maxMovement = min(maximumMovement, size.height * 0.35)
            let stretchedSize: CGSize = .init(width: size.width, height: size.height + maxMovement)
            let progress = minY / scrollViewHeight
            let cropProgress = max(min(progress, 1.0), -1.0)
            let movementOffset = cropProgress * -maxMovement
            
            content(size)
                .offset(y: movementOffset)
                .frame(width: stretchedSize.width, height: stretchedSize.height)
                .frame(width: size.width, height: size.height)
                .overlay(alignment: .bottom) {
                    Text("\(cropProgress)")
                        .font(.title)
                        .foregroundStyle(.white)
                }
                .clipped()
        }
        .containerRelativeFrame(usesFullWidth ? [.horizontal] : [])
    }
}


#Preview {
    ContentView()
}
