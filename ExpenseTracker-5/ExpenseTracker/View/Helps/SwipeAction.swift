//
//  SwipeAction.swift
//  ExpenseTracker
//
//  Created by JXW003 on 2023/12/29.
//

import SwiftUI

struct SwipeAction<Content: View>: View {
    
    var cornerRadius: CGFloat = 0
    var direction: SwipeDirection = .trailing
    
    @ViewBuilder var content: Content
    @ActionBuilder var actions: [Action]
    
    @Environment(\.colorScheme) private var scheme
    let viewID: String = UUID().uuidString
    @State private var isEnabled: Bool = false
    @State private var scrollOffset: CGFloat = .zero
    
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal) {
                LazyHStack(spacing: 0) {
                    content
                        .rotationEffect(.init(degrees: direction == .leading ? -180 : 0))
                        .containerRelativeFrame(.horizontal)
                        .background(scheme == .dark ? .black : .white)
                        .background {
                            if let firstAction = filteredActions.first {
                                Rectangle()
                                    .fill(firstAction.tint)
                                    .opacity(scrollOffset == .zero ? 0 : 1)
                            }
                        }
                        .id(viewID)
                        .transition(.identity)
                        .overlay {
                            GeometryReader {
                                let minX = $0.frame(in: .scrollView(axis: .horizontal)).minX
                                Color.clear
                                    .preference(key: OffsetKey.self, value: minX)
                                    .onPreferenceChange(OffsetKey.self) { value in
                                        scrollOffset = value
                                    }
                            }
                        }
                    
                    ActionButtons() {
                        withAnimation(.snappy) {
                            proxy.scrollTo(viewID, anchor: direction == .trailing ? .topLeading : .topTrailing)
                        }
                    }
                    .opacity(scrollOffset == .zero ? 0 : 1)
                }
                .scrollTargetLayout()
                .visualEffect { content, geometryProxy in
                    content
                        .offset(x: scrollOffset(geometryProxy))
                }
            }
            .scrollIndicators(.hidden)
            .scrollTargetBehavior(.viewAligned)
            .background {
                Group {
                    if let lastAction = filteredActions.last {
                        Rectangle()
                            .fill(lastAction.tint)
                    }
                }
            }
            .clipShape(.rect(cornerRadius: cornerRadius))
        }
        .allowsTightening(isEnabled)
        .transition(CustomTransition())
        .rotationEffect(.init(degrees: direction == .leading ? 180 : 0))
    }
        
    @ViewBuilder
    func ActionButtons(resetPosition: @escaping () -> ()) -> some View {
        Rectangle()
            .fill(.clear)
            .frame(width: CGFloat(filteredActions.count) * 100)
            .overlay(alignment: direction.alignment) {
                HStack(spacing: 0) {
                    ForEach(filteredActions) { button in
                        Button(action: {
                            Task {
                                isEnabled = false
                                resetPosition()
                                try? await Task.sleep(for: .seconds(0.25))
                                button.action()
                                try? await Task.sleep(for: .seconds(0.1))
                                isEnabled = true
                            }
                        }, label: {
                            Image(systemName: button.icon)
                                .font(button.iconFont)
                                .foregroundStyle(button.iconTint)
                                .frame(width: 100)
                                .frame(maxHeight: .infinity)
                                .contentShape(.rect)
                        })
                        .buttonStyle(.plain)
                        .background(button.tint)
                        .rotationEffect(.init(degrees: direction == .leading ? 180 : 0))
                    }
                }
            }
    }
    
    func scrollOffset(_ proxy: GeometryProxy) -> CGFloat {
        let minX = proxy.frame(in: .scrollView(axis: .horizontal)).minX
        return (minX > 0 ? -minX : 0)    
    }
    
    var filteredActions: [Action] {
        return actions.filter({ $0.isEnabled })
    }
}


enum SwipeDirection {
    case leading
    case trailing
    
    var alignment: Alignment {
        switch self {
        case .leading:
            return .leading
        case .trailing:
            return .trailing
        }
    }
}


struct Action: Identifiable {
    private(set) var id: UUID = .init()
    var tint: Color
    var icon: String
    var iconFont: Font = .title
    var iconTint: Color = .white
    var isEnabled: Bool = true
    var action: () -> ()
}


@resultBuilder
struct ActionBuilder {
    static func buildBlock(_ components: Action...) -> [Action] {
        return components
    }
}


struct OffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}


struct CustomTransition: Transition {
    func body(content: Content, phase: TransitionPhase) -> some View {
        content
            .mask {
                GeometryReader {
                    Rectangle()
                        .offset(y: phase == .identity ? 0 : -$0.size.height)
                }
                .containerRelativeFrame(.horizontal)
            }
    }
}


#Preview {
    NavigationStack {
        SwipeActionHome()
            .navigationTitle("Messages")
    }
}


struct SwipeActionHome: View {
    @State private var colors: [Color] = [.black, .yellow, .purple, .brown]
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack {
                ForEach(colors, id: \.self) { color in
                    SwipeAction(cornerRadius: 15, direction: color == .yellow ? .leading : .trailing) {
                        CardView(color)
                    } actions: {
                        Action(tint: .blue, icon: "star.fill", isEnabled: color == .black) {
                            print("Bookmarked")
                        }
                        
                        Action(tint: .red, icon: "trash.fill") {
                            withAnimation(.snappy) {
                                colors.removeAll(where: { $0 == color })
                            }
                        }
                    }
                }
            }
            .padding(15)
        }
        .scrollIndicators(.hidden)
    }
    
    @ViewBuilder
    func CardView(_ color: Color) -> some View {
        HStack(spacing: 12) {
            Circle()
                .frame(width: 50, height: 50)
            
            VStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 8)
                    .frame(width: 100, height: 8)
                
                RoundedRectangle(cornerRadius: 8)
                    .frame(width: 70, height: 8)
            }
            
            Spacer()
        }
        .foregroundStyle(.white.opacity(0.4))
        .padding(.horizontal, 15)
        .padding(.vertical, 10)
        .background(color.gradient)
    }
}
