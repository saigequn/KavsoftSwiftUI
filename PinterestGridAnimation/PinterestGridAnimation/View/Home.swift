//
//  Home.swift
//  PinterestGridAnimation
//
//  Created by JXW003 on 2024/5/15.
//

import SwiftUI

struct Home: View {
    var coordinator: UICoordinator = .init()
    @State private var posts: [Item] = sampleImages

    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(alignment: .leading, spacing: 10) {
                Text("Welcome Back!")
                    .font(.largeTitle.bold())
                    .padding(.vertical, 10)
                
                LazyVGrid(columns: Array(repeating: GridItem(spacing: 10), count: 2), spacing: 10) {
                    ForEach(posts) { post in
                        PostCardView(post)
                    }
                }
            }
            .padding(15)
            .background {
                ScrollViewExtractor {
                    coordinator.scrollview = $0
                }
            }
        }
        //        .opacity(coordinator.animationLayer == nil ? 1 : 0)
        .opacity(coordinator.hideRootView ? 0 : 1)
        .scrollDisabled(coordinator.hideRootView)
        .allowsHitTesting(!coordinator.hideRootView)
        .overlay {
            Detail()
                .environment(coordinator)
                .allowsHitTesting(coordinator.hideLayer)
//            if let animationLayer = coordinator.animationLayer {
//                Image(uiImage: animationLayer)
//                    .ignoresSafeArea()
//                    .opacity(0.5)
//            }
        }
    }
    
    @ViewBuilder
    func PostCardView(_ post: Item) -> some View {
        GeometryReader {
            let frame = $0.frame(in: .global)
            
            ImageView(post: post)
                .clipShape(.rect(cornerRadius: 10))
                .contentShape(.rect(cornerRadius: 10))
                .onTapGesture {
                    coordinator.toggleView(show: true, frame: frame, post: post)
                }
        }
        .frame(height: 180)
    }
}

#Preview {
    ContentView()
}
