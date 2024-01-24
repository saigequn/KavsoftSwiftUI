//
//  TabStateScrollView.swift
//  ScrollToHideTabBar
//
//  Created by JXW003 on 2024/1/23.
//

import SwiftUI

struct TabStateScrollView<Content: View>: View {
    
    var axis: Axis.Set
    var showsIndicator: Bool
    @Binding var tabState: Visibility
    var content: Content
    
    init(axis: Axis.Set, showsIndicator: Bool, tabState: Binding<Visibility>, @ViewBuilder content: @escaping () -> Content) {
        self.axis = axis
        self.showsIndicator = showsIndicator
        self._tabState = tabState
        self.content = content()
    }
    
    var body: some View {
        if #available(iOS 17, *) {
            ScrollView(axis) {
                content
            }
            .scrollIndicators(showsIndicator ? .visible : .hidden)
            .background {
                CustomGesture {
                    handleTabState($0)
                }
            }
        } else {
            ScrollView(axis, showsIndicators: showsIndicator) {
                content
            }
            .background {
                CustomGesture {
                    handleTabState($0)
                }
            }
        }
    }
    
    func handleTabState(_ gesture: UIPanGestureRecognizer) {
        let offsetY = gesture.translation(in: gesture.view).y
        let velocity = gesture.velocity(in: gesture.view).y
        
        if velocity < 0 {
            /// Swiping up
            if -(velocity / 5) > 60 && tabState == .visible {
                tabState = .hidden
            }
        } else {
            /// Swiping Down
            if (velocity / 5) > 40 && tabState == .hidden {
                tabState = .visible
            }
        }
    }
}


/// 添加一个通用手势，来识别滑动方向
fileprivate struct CustomGesture: UIViewRepresentable {
    var onChange: (UIPanGestureRecognizer) -> Void
    private let gestureID = UUID().uuidString
    
    func makeUIView(context: Context) -> UIView {
        return UIView()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        DispatchQueue.main.async {
            /// Verifying if there is already ang gesture is added
            if let superView = uiView.superview?.superview, !(superView.gestureRecognizers?.contains(where: { $0.name == gestureID }) ?? false) {
                let gesture = UIPanGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.gestureChange(gesture:)))
                gesture.name = gestureID
                gesture.delegate = context.coordinator
                /// Adding Gesture to the SuperView
                superView.addGestureRecognizer(gesture)
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(onChange: onChange)
    }
    
    class Coordinator: NSObject, UIGestureRecognizerDelegate {
        var onChange: (UIPanGestureRecognizer) -> Void
        
        init(onChange: @escaping (UIPanGestureRecognizer) -> Void) {
            self.onChange = onChange
        }
        
        @objc func gestureChange(gesture: UIPanGestureRecognizer) {
            /// Simply Calling the onChange Callback
            onChange(gesture)
        }
        
        func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
            return true
        }
    }
}

#Preview {
    ContentView()
}
