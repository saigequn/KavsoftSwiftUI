//
//  Home.swift
//  ComplexHeroAnimation
//
//  Created by JXW003 on 2024/1/4.
//

import SwiftUI

struct Home: View {
    
    @State private var posts: [Post] = samplePosts
    @State private var showDetailView: Bool = false
    @State private var detailViewAnimation: Bool = false
    @State private var selectedPicID: UUID?
    @State private var selectedPost: Post?

    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                VStack(spacing: 15) {
                    ForEach(posts) { post in
                        CardView(post)
                    }
                }
                .safeAreaPadding(15)
            }
            .navigationTitle("Animation")
        }
        .overlay {
            if let selectedPost, showDetailView {
                
                DetailView(
                    showDetailView: $showDetailView,
                    detailViewAnimation: $detailViewAnimation,
                    post: selectedPost,
                    selectedPicID: $selectedPicID) { id in
                        /// Updating Scroll Position
                        if let index = posts.firstIndex(where: { $0.id == selectedPost.id }) {
                            posts[index].scrollPosition = id
                        }
                    }
                    .transition(.offset(y: 5))
            }
        }
        .overlayPreferenceValue(OffsetKey.self, { value in
            GeometryReader { proxy in
                if let selectedPicID, let source = value[selectedPicID.uuidString], let destination = value["DESTINATION\(selectedPicID.uuidString)"], let picItem = selectedImage(), showDetailView {
                    let sRect = proxy[source]
                    let dRect = proxy[destination]
                    
                    Image(picItem.image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: detailViewAnimation ? dRect.width : sRect.width, height: detailViewAnimation ? dRect.height : sRect.height)
                        .clipShape(.rect(cornerRadius: detailViewAnimation ? 0 : 10))
                        .offset(x: detailViewAnimation ? dRect.minX : sRect.minX, y: detailViewAnimation ? dRect.minY : sRect.minY)
                        .allowsTightening(false)
                }
            }
        })
    }
    
    func selectedImage() -> PicItem? {
        if let pic = selectedPost?.pics.first(where: { $0.id == selectedPicID }) {
            return pic
        }
        return nil
    }
    
    @ViewBuilder
    func CardView(_ post: Post) -> some View {
        VStack(spacing: 12) {
            HStack(spacing: 15) {
                Image(systemName: "person.circle.fill")
                    .font(.largeTitle)
                    .foregroundStyle(.teal)
                    .frame(width: 30, height: 30)
                    .background(.background)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(post.username)
                        .fontWeight(.semibold)
                        .textScale(.secondary)
                    
                    Text(post.content)
                }
                
                Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
                
                Button("", systemImage: "ellipsis") {
                    
                }
                .foregroundStyle(.primary)
                .offset(y: -10)
            }
            
            VStack(alignment: .leading, spacing: 10) {
                GeometryReader {
                    let size = $0.size
                    ScrollView(.horizontal) {
                        HStack(spacing: 10) {
                            ForEach(post.pics) { pic in
                                LazyHStack {
                                    Image(pic.image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(maxWidth: size.width)
                                        .clipShape(.rect(cornerRadius: 10))
                                }
                                .frame(maxWidth: size.width)
                                .frame(height: size.height)
                                .anchorPreference(key: OffsetKey.self, value: .bounds, transform: { anchor in
                                    return [pic.id.uuidString: anchor]
                                })
                                .onTapGesture {
                                    selectedPost = post
                                    selectedPicID = pic.id
                                    showDetailView = true
                                }
                                .contentShape(.rect)
                                .opacity(selectedPicID == pic.id ? 0 : 1)
                            }
                        }
                        .scrollTargetLayout()
                    }
                    .scrollPosition(id: .init(get: {
                        return post.scrollPosition
                    }, set: { _ in
                        
                    }))
                    .scrollIndicators(.hidden)
                    .scrollTargetBehavior(.viewAligned)
                    .scrollClipDisabled()
                }
                .frame(height: 200)
                
                HStack(spacing: 10) {
                    ImageButton("suit.heart") {
                        
                    }
                    
                    ImageButton("message") {
                        
                    }
                    
                    ImageButton("arrow.2.squarepath") {
                        
                    }
                    
                    ImageButton("paperplane") {
                        
                    }
                }
                
            }
            .safeAreaPadding(.leading, 45)
            
            HStack(spacing: 10) {
                Image(systemName: "person.circle.fill")
                    .frame(width: 30, height: 30)
                    .background(.background)
                
                Button("10 replies") {
                    
                }
                Button("10 replies") {
                    
                }
                .padding(.leading, -5)
                
                Spacer()
            }
            .textScale(.secondary)
            .foregroundStyle(.secondary)
        }
        .background(alignment: .leading) {
            Rectangle()
                .fill(.secondary)
                .frame(width: 1)
                .padding(.bottom, 30)
                .offset(x: 15, y: 10)
        }
    }
    
    
    @ViewBuilder
    func ImageButton(_ icon: String, onTap: @escaping () -> ()) -> some View {
        Button("", systemImage: icon, action: onTap)
            .font(.title3)
            .foregroundStyle(.primary)
    }
}


struct DetailView: View {
    
    @Binding var showDetailView: Bool
    @Binding var detailViewAnimation: Bool
    var post: Post
    @Binding var selectedPicID: UUID?
    var updateScrollPosition: (UUID?) -> ()
    /// View Properties
    @State private var detailScrollPosition: UUID?
    /// Dispatch Tasks
    @State private var startTask1: DispatchWorkItem?
    @State private var startTask2: DispatchWorkItem?
    @State private var endTask1: DispatchWorkItem?
    @State private var endTask2: DispatchWorkItem?
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 0) {
                ForEach(post.pics) { pic in
                    Image(pic.image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .containerRelativeFrame(.horizontal)
                        .clipped()
                        .anchorPreference(key: OffsetKey.self, value: .bounds, transform: { anchor in
                            return ["DESTINATION\(pic.id.uuidString)": anchor]
                        })
                        .opacity(selectedPicID == pic.id ? 0 : 1)
                }
            }
            .scrollTargetLayout()
        }
        .scrollPosition(id: $detailScrollPosition)
        .background(.black)
        .opacity(detailViewAnimation ? 1 : 0)
        .scrollTargetBehavior(.paging)
        .scrollIndicators(.hidden)
        .overlay(alignment: .topLeading) {
            Button("", systemImage: "xmark.circle.fill") {
                cancelTasks()
                
                updateScrollPosition(detailScrollPosition)
                selectedPicID = detailScrollPosition
                
                /// Giving soome time to set the Scroll Position
                initiateTask(ref: &startTask1, task: .init(block: {
                    withAnimation(.snappy(duration: 0.3, extraBounce: 0)) {
                        detailViewAnimation = false
                    }
                    
                    /// Removing Layer View
                    initiateTask(ref: &startTask2, task: .init(block: {
                        showDetailView = false
                        selectedPicID = nil
                    }), duration: 0.3)
                }), duration: 0.05)
                
            }
            .font(.title)
            .foregroundStyle(.white.opacity(0.8), .white.opacity(0.15))
            .padding()
        }
        .onAppear {
            cancelTasks()
            
            guard detailScrollPosition == nil else { return }
            
            detailScrollPosition = selectedPicID
            /// Giving soome time to set the Scroll Position
            initiateTask(ref: &startTask1, task: .init(block: {
                withAnimation(.snappy(duration: 0.3, extraBounce: 0)) {
                    detailViewAnimation = true
                }
                
                /// Removing Layer View
                initiateTask(ref: &startTask2, task: .init(block: {
                    selectedPicID = nil
                }), duration: 0.3)
            }), duration: 0.05)
        }
    }
    
    
    func initiateTask(ref: inout DispatchWorkItem?, task: DispatchWorkItem, duration: Double) {
        ref = task
        DispatchQueue.main.asyncAfter(deadline: .now() + duration, execute: task)
    }
    
    /// Cancel Previous Tasks
    func cancelTasks() {
        if let startTask1, let startTask2 {
            startTask1.cancel()
            startTask2.cancel()
            self.startTask1 = nil
            self.startTask2 = nil
        }
    }
}



#Preview {
    ContentView()
}
