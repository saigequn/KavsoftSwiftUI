//
//  RadialLayout.swift
//  RadialView
//
//  Created by JXW003 on 2024/1/24.
//

import SwiftUI

struct RadialLayout<Content: View, Item: RandomAccessCollection, ID: Hashable>: View where Item.Element: Identifiable {
    
    var items: Item
    var keyPathID: KeyPath<Item.Element, ID>
    var spacing: CGFloat?
    /// return Index and view size
    var content: (Item.Element, Int, CGFloat) -> Content
    var onIndexChange: (Int) -> ()
    
    @State private var dragRotation: Angle = .zero
    @State private var lastDragRotation: Angle = .zero
    @State private var activeIndex: Int = 0
    
    init(items: Item, keyPathID: KeyPath<Item.Element, ID>,
         spacing: CGFloat? = nil, @ViewBuilder content: @escaping (Item.Element, Int, CGFloat) -> Content, onIndexChange: @escaping (Int) -> Void) {
        self.items = items
        self.keyPathID = keyPathID
        self.spacing = spacing
        self.content = content
        self.onIndexChange = onIndexChange
    }
    
    var body: some View {
        GeometryReader(content: { geometry in
            let size = geometry.size
            let width = size.width
            let count = CGFloat(items.count)
            let spacing = spacing ?? 0
            let viewSize = (width - spacing) / (count / 2)
            
            ZStack(content: {
                ForEach(items, id: keyPathID) { item in
                    let index = fetchIndex(item)
                    let rotation = (CGFloat(index) / count) * 360.0
                    
                    content(item, index, viewSize)
                        .rotationEffect(.degrees(90))
                        .rotationEffect(.degrees(-rotation))
                        .rotationEffect(-dragRotation)
                        .frame(width: viewSize, height: viewSize)
                        .offset(x: (width - viewSize) / 2)
                        .rotationEffect(.degrees(-90))
                        .rotationEffect(.degrees(rotation))
                        
                }
            })
            .frame(width: width, height: width)
            /// Gesture
            .contentShape(.rect)
            .rotationEffect(dragRotation)
            .gesture(
                DragGesture()
                    .onChanged({ value in
                        let translationX = value.translation.width
                        let progress = translationX / (viewSize * 2)
                        let rotationFraction = 360.0 / count
                        dragRotation = .degrees(rotationFraction * progress) + lastDragRotation
                        calculateIndex(count)
                    })
                    .onEnded({ value in
                        
                        let velocityX = value.velocity.width / 15
                        let translationX = value.translation.width + velocityX
                        let progress = (translationX / (viewSize * 2)).rounded()
                        let rotationFraction = 360.0 / count
                        withAnimation(.smooth) {
                            dragRotation = .degrees(rotationFraction * progress) + lastDragRotation
                        }
                        lastDragRotation = dragRotation
                        calculateIndex(count)
                    })
            )
        })
    }
    
    
    /// Calculate the center top index
    func calculateIndex(_ count: CGFloat) {
        var activeIndex = (dragRotation.degrees / 360.0 * count).rounded().truncatingRemainder(dividingBy: count)
        activeIndex = activeIndex == 0 ? 0 : (activeIndex < 0 ? -activeIndex : (count - activeIndex))
        self.activeIndex = Int(activeIndex)
        /// Notifying the View
        onIndexChange(self.activeIndex)
    }
    
    /// Fetching Item Index
    func fetchIndex(_ item: Item.Element) -> Int {
//        if let index = items.firstIndex(where: { $0.id == item.id }) as? Int {
//            return index
//        }
//        return 0
        return items.firstIndex(where: { $0.id == item.id }) as? Int ?? 0
    }
}

#Preview {
    ContentView()
}
