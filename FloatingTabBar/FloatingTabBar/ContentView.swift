//
//  ContentView.swift
//  FloatingTabBar
//
//  Created by JXW003 on 2024/1/24.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var tabModel: TabModel = .init()
    @Environment(\.controlActiveState) private var state
    
    var body: some View {
        TabView(selection: $tabModel.activeTab,
                content:  {
//            NavigationStack {
//                Text("Home View")
//                    .toolbar {
//                        ToolbarItem(placement: .primaryAction) {
//                            Button("", systemImage: "sidebar.left") {
//                                tabModel.hideTabBar.toggle()
//                            }
//                        }
//                    }
//            }
//            .tag(Tab.home)
//            .background(HideTabBar())
            
            Rectangle()
                .fill(.red)
                .padding(10)
                .tag(Tab.home)
                .background(HideTabBar())
            
//            Text("Home View")
//                .tabItem {
//                    Text("Tab 1")
//                }
//                .tag(Tab.home)
//                .background(HideTabBar())
            
            Text("Favourites View").tabItem {
                Text("Tab 2")
            }.tag(Tab.favourites)
            
            Text("Favourites View").tabItem {
                Text("Tab 3")
            }.tag(Tab.notifications)
            
            Text("Favourites View").tabItem {
                Text("Tab 4")
            }.tag(Tab.settings)
        })
        .opacity(tabModel.isTabBarAdded ? 1 : 0)
        .background {
            GeometryReader {
                let rect = $0.frame(in: .global)
                
                Color.clear
                    .customOnChange(value: rect) { _ in
                        tabModel.updateTabPosition()
                    }
            }
        }
        .customOnChange(value: state, initial: true) { newValue in
            if newValue == .key {
                tabModel.addTabBar()
            }
        }
    }
}

extension View {
    @ViewBuilder
    func customOnChange<Value: Equatable>(value: Value, initial: Bool = false, result: @escaping (Value) -> ()) -> some View {
        if #available(macOS 14, *) {
            self
                .onChange(of: value, initial: initial) { oldValue, newValue in
                    result(newValue)
                }
        } else {
            self
                .onChange(of: value, perform: result)
                .onAppear {
                    result(value)
                }
        }
    }
    
    @ViewBuilder
    func windowBackground() -> some View {
        if #available(macOS 14, *) {
            self
                .background(.windowBackground)
        } else {
            self.background(.background)
        }
    }
}

#Preview {
    ContentView()
}


class TabModel: ObservableObject {
    @Published var activeTab: Tab = .home
    @Published private(set) var isTabBarAdded: Bool = false
    @Published var hideTabBar: Bool = false
    private let id: String = UUID().uuidString
    
    func addTabBar() {
        guard !isTabBarAdded else { return }
        
        if let applicationWindow = NSApplication.shared.mainWindow {
            let customTabBar = NSHostingView(rootView: FloatingTabBarView())
            let floatingWindow = NSWindow()
            floatingWindow.styleMask = .borderless
            floatingWindow.contentView = customTabBar
            floatingWindow.backgroundColor = .clear
            floatingWindow.title = id
            
            let windowSize = applicationWindow.frame.size
            let windowOrigin = applicationWindow.frame.origin
            floatingWindow.setFrameOrigin(.init(x: windowOrigin.x - 50, y: windowOrigin.y + (windowSize.height - 150) / 2))
            
            /// Adding Above the application window
            applicationWindow.addChildWindow(floatingWindow, ordered: .above)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) { [weak self] in
                self?.isTabBarAdded = true
            }
        } else {
            print("no window found")
        }
    }
    
    func updateTabPosition() {
        if let floatingWindow = NSApplication.shared.windows.first(where: {$0.title == id }), let applicationWindow = NSApplication.shared.mainWindow {
            let windowSize = applicationWindow.frame.size
            let windowOrigin = applicationWindow.frame.origin
            floatingWindow.setFrameOrigin(.init(x: windowOrigin.x - 50, y: windowOrigin.y + (windowSize.height - 150) / 2))
        }
    }
}

enum Tab: String, CaseIterable {
    case home = "house.fill"
    case favourites = "suit.heart.fill"
    case notifications = "bell.fill"
    case settings = "gearshape"
}


fileprivate struct FloatingTabBarView: View {
    
    @EnvironmentObject private var tabModel: TabModel
    @Environment(\.colorScheme) private var colorScheme
    @Namespace private var animation
    private var animationID: UUID = .init()
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(Tab.allCases, id: \.rawValue) { tab in
                Button(action: {
                    tabModel.activeTab = tab
                }, label: {
                    Image(systemName: tab.rawValue)
                        .font(.title3)
                        .foregroundStyle(colorScheme == .dark ? .black : .primary)
//                        .foregroundStyle(tabModel.activeTab == tab ? (colorScheme == .dark ? .black : .white) : .primary)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background {
//                            if tabModel.activeTab == tab {
//                                Circle()
//                                    .fill(.primary)
//                                    .matchedGeometryEffect(id: animationID, in: animation)
//                            }
                        }
                        .contentShape(.rect)
//                        .animation(.bouncy, value: tabModel.activeTab)
                })
                .buttonStyle(.plain)
            }
        }
        .padding(5)
        .frame(width: 45, height: 150)
        .windowBackground()
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(width: 50)
        .clipShape(.capsule)
        .contentShape(.capsule)
        .offset(x: tabModel.hideTabBar ? 60 : 0)
        .animation(.snappy, value: tabModel.hideTabBar)
    }
}

/// Hiding MacOS TabBar
fileprivate struct HideTabBar: NSViewRepresentable {
    func updateNSView(_ nsView: NSView, context: Context) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.06) {
            if let tabView = nsView.superview?.superview?.superview as? NSTabView {
                //print(tabView)
                tabView.tabViewType = .noTabsNoBorder
                tabView.tabViewBorderType = .none
                tabView.tabPosition = .none
            }
        }
    }
    
    func makeNSView(context: Context) -> NSView {
        return NSView()
    }
}
