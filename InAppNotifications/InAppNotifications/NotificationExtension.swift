//
//  NotificationExtension.swift
//  InAppNotifications
//
//  Created by JXW003 on 2024/1/16.
//

import SwiftUI


extension UIApplication {
    func inAppNotification<Content: View>(adaptForDynamicIsland: Bool = false, timeout: CGFloat = 5, swipeToClose: Bool = true, @ViewBuilder content: @escaping () -> Content) {
        /// Fetching Active Window VIA WindowScene
        if let activeWindow = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first(where: { $0.tag == 0320 }) {
            /// Frame and safeArea Values
            let frame = activeWindow.frame
            let safeArea = activeWindow.safeAreaInsets
            let checkForDynamicIsland = adaptForDynamicIsland && safeArea.top >= 51
            var tag = 1020
            
            if let previousTag = UserDefaults.standard.value(forKey: "In_App_Notification_Tag") as? Int {
                tag = previousTag + 1
            }
            UserDefaults.standard.setValue(tag, forKey: "In_App_Notification_Tag")
            
            /// Changing status into black to blend with dynamic island
            if checkForDynamicIsland {
                if let controller = activeWindow.rootViewController as? StatusBarBasedController {
                    controller.statusBarStyle = .darkContent
                    controller.setNeedsStatusBarAppearanceUpdate()
                }
            }
            
            /// Creating UIView frame SwiftUI View using UIHosting Configuration
            let config = UIHostingConfiguration {
                AnimatedNotificationView(
                    content: content(),
                    safeArea: safeArea,
                    tag: tag,
                    adaptForDynamicIsland: adaptForDynamicIsland,
                    timeout: timeout,
                    swipeToClose: swipeToClose
                )
                /// Maximum Notification Height will be 120
                .frame(width: frame.width - (checkForDynamicIsland ? 20 : 30), height: 120, alignment: .topLeading)
                .contentShape(.rect)
            }
            
            /// Creating UIView
            let view = config.makeContentView()
            view.tag = tag
            view.backgroundColor = .clear
            view.translatesAutoresizingMaskIntoConstraints = false
            
            if let rootView = activeWindow.rootViewController?.view {
                rootView.addSubview(view)
                
                /// Layout Contraints
                view.centerXAnchor.constraint(equalTo: activeWindow.centerXAnchor).isActive = true
                view.centerYAnchor.constraint(equalTo: activeWindow.centerYAnchor, constant: (-(frame.height - safeArea.top)/2.0) + (checkForDynamicIsland ? 11 : safeArea.top)).isActive = true
            }
        }
    }
}


fileprivate struct AnimatedNotificationView<Content: View>: View {
    var content: Content
    var safeArea: UIEdgeInsets
    var tag: Int
    var adaptForDynamicIsland: Bool
    var timeout: CGFloat
    var swipeToClose: Bool
    
    @State private var animateNotification: Bool = false
    
    var body: some View {
        content
            .blur(radius: animateNotification ? 0 : 10)
            .disabled(!animateNotification)
            .mask {
                if adaptForDynamicIsland {
                    /// Size Based Capusule
                    GeometryReader(content: { geometry in
                        let size = geometry.size
                        let radius = size.height / 2
                        RoundedRectangle(cornerRadius: radius, style: .continuous)
                    })
                } else {
                    Rectangle()
                }
            }
            /// Scaling Animation only ForDynamic Island Notification
            .scaleEffect(adaptForDynamicIsland ? (animateNotification ? 1 : 0.01) : 1, anchor: .init(x: 0.5, y: 0.01))
            .offset(y: offsetY)
            .gesture(
                DragGesture()
                    .onEnded({ value in
                        if -value.translation.height > 50 && swipeToClose {
                            withAnimation(.smooth, completionCriteria: .logicallyComplete) {
                                animateNotification = false
                            } completion: {
                                removeNotificationView()
                            }
                        }
                    })
            )
            .onAppear() {
                Task {
                    guard !animateNotification else { return }
                    
                    withAnimation(.smooth) {
                        animateNotification = true
                    }
                    
                    try await Task.sleep(for: .seconds(timeout < 1 ? 1 : timeout))
                    guard animateNotification else { return }
                    
                    withAnimation(.smooth, completionCriteria: .logicallyComplete) {
                        animateNotification = false
                    } completion: {
                        removeNotificationView()
                    }
                }
            }
    }
    
    var offsetY: CGFloat {
        if adaptForDynamicIsland {
            return 0
        }
        return animateNotification ? 10 : -(safeArea.top + 130)
    }
    
    func removeNotificationView() {
        if let activeWindow = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first(where: { $0.tag == 0320 }) {
            if let view = activeWindow.viewWithTag(tag) {
                print("remove view with tag = \(tag)")
                view.removeFromSuperview()
                
                /// Resetting Once All the notifications was removed
                if let controller = activeWindow.rootViewController as? StatusBarBasedController, controller.view.subviews.isEmpty {
                    controller.statusBarStyle = .default
                    controller.setNeedsStatusBarAppearanceUpdate()
                }
            }
        }
    }
}



#Preview {
    ContentView()
}
