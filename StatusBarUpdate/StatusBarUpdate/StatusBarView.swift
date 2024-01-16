//
//  StatusBarView.swift
//  StatusBarUpdate
//
//  Created by JXW003 on 2024/1/15.
//

import SwiftUI

struct StatusBarView<Content: View>: View {
    
    @ViewBuilder var content: Content
    /// Status Bar Window
    @State private var statusBarWindow: UIWindow?
    
    var body: some View {
        content
            .onAppear(perform: {
                if statusBarWindow == nil {
                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                        let statusBarWindow = UIWindow(windowScene: windowScene)
                        statusBarWindow.windowLevel = .statusBar
                        statusBarWindow.tag = 6140
                        let controller = StatusBarViewController()
                        controller.view.isUserInteractionEnabled = false
                        controller.view.backgroundColor = .clear
                        statusBarWindow.rootViewController = controller
                        statusBarWindow.isHidden = false
                        statusBarWindow.isUserInteractionEnabled = false
                        self.statusBarWindow = statusBarWindow
                        
                        print("create")
                    }
                }
            })
    }
}


extension UIApplication {
    func setStatusBarStyle(_ style: UIStatusBarStyle) {
        if let statusBarWindow = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first(where: { $0.tag == 6140 }), let statusBarController = statusBarWindow.rootViewController as? StatusBarViewController {
            /// Updating Status Bar Style
            statusBarController.statusBarStyle = style
            /// Refreshing Changes
            statusBarController.setNeedsStatusBarAppearanceUpdate()
        }
    }
}


class StatusBarViewController: UIViewController {
    var statusBarStyle: UIStatusBarStyle = .default
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return statusBarStyle
    }
}


#Preview {
    ContentView()
}
