//
//  StackedCards.swift
//  StackedCardsView
//
//  Created by JXW003 on 2024/5/17.
//

import SwiftUI

struct StackedCards<Content: View, Data: RandomAccessCollection>: View where Data.Element: Identifiable {
    
    var items: Data
    var statckedDisplayCount: Int = 2
    var opacityDisplayCount: Int = 2
    var spacing: CGFloat = 5
    var itemHeight: CGFloat
    
    @ViewBuilder var content: (Data.Element) -> Content
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            let topPadding: CGFloat = size.height - itemHeight
            
            ScrollView(.vertical) {
                VStack(spacing: spacing) {
                    ForEach(items) { item in
                        content(item)
                            .frame(height: itemHeight)
                            .visualEffect { content, geometryProxy in
                                content
                                    .opacity(opacity(geometryProxy))
                                    .scaleEffect(scale(geometryProxy), anchor: .bottom)
                                    .offset(y: offset(geometryProxy))
                            }
                            .zIndex(zIndex(item))
                    }
                }
                .scrollTargetLayout()
                .overlay(alignment: .top) {
                    HeaderView(topPadding)
                }
            }
            .scrollIndicators(.hidden)
            .scrollTargetBehavior(.viewAligned(limitBehavior: .always))
            .safeAreaPadding(.top, topPadding)
        }
    }
    
    
    @ViewBuilder
    func HeaderView(_ topPadding: CGFloat) -> some View {
        VStack(spacing: 0) {
            Text(Date.now.formatted(date: .complete, time: .omitted))
                .font(.title3.bold())
            
            Text("9:41")
                .font(.system(size: 100, weight: .bold, design: .rounded))
                .padding(.top, -15)
        }
        .foregroundStyle(.white)
        .visualEffect { content, geometryProxy in
            content
                .offset(y: headerOffset(geometryProxy, topPadding))
        }
    }
    
    func headerOffset(_ proxy: GeometryProxy, _ topPadding: CGFloat) -> CGFloat {
        let minY = proxy.frame(in: .scrollView(axis: .vertical)).minY
        let viewSize = proxy.size.height - itemHeight
        
        return -minY > (topPadding - viewSize) ? -viewSize : -minY - topPadding
    }
    
    
    func zIndex(_ item: Data.Element) -> Double {
        if let index = items.firstIndex(where: { $0.id == item.id }) as? Int {
            return Double(items.count) - Double(index)
        }
        return 0
    }
    
    
    func offset(_ proxy: GeometryProxy) -> CGFloat {
        let minY = proxy.frame(in: .scrollView(axis: .vertical)).minY
        let progress = minY / itemHeight
        let maxOffset = CGFloat(statckedDisplayCount) * offsetForEachItem
        let offset = max(min(progress * offsetForEachItem, maxOffset), 0)
        return minY < 0 ? 0 : -minY + offset
    }
    
    func scale(_ proxy: GeometryProxy) -> CGFloat {
        let minY = proxy.frame(in: .scrollView(axis: .vertical)).minY
        let progress = minY / itemHeight
        let maxScale = CGFloat(statckedDisplayCount) * scaleForEachItem
        let scale = max(min(progress * scaleForEachItem, maxScale), 0)
        return 1 - scale
    }
    
    func opacity(_ proxy: GeometryProxy) -> CGFloat {
        let minY = proxy.frame(in: .scrollView(axis: .vertical)).minY
        let progress = minY / itemHeight
        let opacityForItem = 1 / CGFloat(opacityDisplayCount + 1)
        
        let maxOpacity = CGFloat(opacityForItem) * CGFloat(opacityDisplayCount + 1)
        let opacity = max(min(progress * opacityForItem, maxOpacity), 0)
        return progress < CGFloat(opacityDisplayCount + 1) ? 1 - opacity : 0
    }
    
    var offsetForEachItem: CGFloat {
        return 8
    }
    
    var scaleForEachItem: CGFloat {
        return 0.08
    }
}

#Preview {
    ContentView()
}
