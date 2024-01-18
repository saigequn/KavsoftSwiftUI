//
//  Navigation+Extension.swift
//  SwipeToHideNavBar
//
//  Created by JXW003 on 2024/1/18.
//

import SwiftUI

extension View {
    @ViewBuilder
    func hideNavBarOnSwipe(_ isHidden: Bool) -> some View {
        self.modifier(NavBarModifier(isHidden: isHidden))
    }
}


private struct NavBarModifier: ViewModifier {
    var isHidden: Bool
    @State private var isNavBarHidden: Bool?
    
    func body(content: Content) -> some View {
        content
            .onChange(of: isHidden, { oldValue, newValue in
                isNavBarHidden = newValue
            })
            .onDisappear(perform: {
                isNavBarHidden = nil
            })
            .background(NavigationControllerExtractor(isHidden: isNavBarHidden))
    }
}


/// Extracting UINavigationController from SwiftUI view
private struct NavigationControllerExtractor: UIViewRepresentable {
    var isHidden: Bool?
    
    func makeUIView(context: Context) -> UIView {
        return UIView()
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            if let hostView = uiView.superview?.superview, let parentController = hostView.parentController, let isHidden {
                parentController.navigationController?.hidesBarsOnSwipe = isHidden
            }
        }
    }
}


private extension UIView {
    var parentController: UIViewController? {
        sequence(first: self) { view
            in
            view.next
        }
        .first { responder in
            return responder is UIViewController
        } as? UIViewController
    }
}


#Preview {
    ContentView()
}
