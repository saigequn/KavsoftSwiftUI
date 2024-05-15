//
//  Home.swift
//  PhotosApp
//
//  Created by JXW003 on 2024/5/14.
//

import SwiftUI

struct Home: View {
    @Environment(UICoordinator.self) private var coordinator
    
    var body: some View {
        @Bindable var bindableCoordinator = coordinator
        
        ScrollViewReader { reader in
            ScrollView(.vertical) {
                LazyVStack(alignment: .leading, spacing: 0) {
                    Text("Recents")
                        .font(.largeTitle.bold())
                        .padding(.top, 15)
                        .padding(.horizontal, 15)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(spacing: 3), count: 3), spacing: 3) {
                        ForEach($bindableCoordinator.items) { $item in
                            GridImageView(item)
                                .id(item.id)
                                .didFrameChange {  frame, bounds in
                                    let minY = frame.minY
                                    let maxY = frame.maxY
                                    let height = bounds.height
                                    if maxY < 0 || minY > height {
                                        item.appeared = false
                                    } else {
                                        item.appeared = true
                                    }
                                }
                                .onDisappear() {
                                    item.appeared = false
                                }
                                .onTapGesture {
                                    coordinator.selectedItem = item
                                }
                        }
                    }
                    .padding(.vertical, 15)
                }
            }
            .onChange(of: coordinator.selectedItem) { oldValue, newValue in
                if let item = coordinator.items.first(where: { $0.id == newValue?.id }), !item.appeared {
//                if let item = newValue, !item.appeared {
                    reader.scrollTo(item.id, anchor: .bottom)
                }
            }
        }
        .toolbar(.hidden, for: .navigationBar)
//        .allowsHitTesting(coordinator.selectedItem == nil)
    }
    
    
    @ViewBuilder
    func GridImageView(_ item: Item) -> some View {
        GeometryReader {
            let size = $0.size
            
            Rectangle()
                .fill(.clear)
                .anchorPreference(key: HeroKey.self, value: .bounds, transform: { anchor in
                    return [item.id + "SOURCE": anchor]
                })
            
            if let previewImage = item.previewImage {
                Image(uiImage: previewImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size.width, height: size.height)
                    .clipped()
                    .opacity(coordinator.selectedItem?.id == item.id ? 0 : 1)
            }
        }
        .frame(height: 130)
        .contentShape(.rect)
    }
}

#Preview {
    ContentView()
}
